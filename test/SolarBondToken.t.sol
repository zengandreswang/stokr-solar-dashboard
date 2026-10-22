// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {SolarBondToken} from "../src/SolarBondToken.sol";

contract SolarBondTokenTest is Test {
    SolarBondToken public implementation;
    SolarBondToken public bond;

    address public admin = makeAddr("admin");
    address public stokrControlAgent = makeAddr("stokrControlAgent");
    address public chainlinkOracle = makeAddr("chainlinkOracle");

    address public investorAlice = makeAddr("investorAlice");
    address public aliceNewSafeWallet = makeAddr("aliceNewSafeWallet");
    address public investorBob = makeAddr("investorBob");
    address public unverifiedHacker = makeAddr("unverifiedHacker");

    bytes32 public constant INITIAL_PPA_HASH = keccak256("LUX_SOLAR_2.5MWP_PPA_2026_001");
    bytes32 public constant ALICE_GAID       = keccak256("GAID_LU_RETAIL_001");
    bytes32 public constant BOB_GAID         = keccak256("GAID_LU_INST_002");

    function setUp() public {
        implementation = new SolarBondToken();

        bytes memory initData = abi.encodeCall(
            SolarBondToken.initialize,
            (admin, stokrControlAgent, chainlinkOracle, INITIAL_PPA_HASH)
        );
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);
        bond = SolarBondToken(address(proxy));

        // Control Agent 在 AMP 注册表中登记 Alice (Category 1: 零售合格投资者) 和 Bob (Category 2: 机构投资者)
        vm.startPrank(stokrControlAgent);
        bond.registerInvestorGAID(investorAlice, ALICE_GAID, 1);
        bond.registerInvestorGAID(investorBob, BOB_GAID, 2);

        // 向 Alice 初始配售 €500,000 太阳能债券代币
        bond.issueBondTokens(investorAlice, 500_000 * 1e18);
        vm.stopPrank();
    }

    // 测试 1: 验证 STOKR Private Credit Registry 2.5 MWp PPA 锁定与防重复质押
    function test_PPARegistryAndAntiDoublePledge() public view {
        assertFalse(bond.verifyPpaNotDoublePledged(INITIAL_PPA_HASH));
        assertTrue(bond.verifyPpaNotDoublePledged(keccak256("NEW_UNPLEDGED_PPA")));
    }

    // 测试 2: 验证 €500 最小起投粒度控制与 Blockstream AMP 白名单转账拦截
    function test_AMPCosignAndMinimumTicketGranularity() public {
        // 1. 合规转账 (€1,500，为 €500 的整数倍) 应成功
        vm.prank(investorAlice);
        bond.transfer(investorBob, 1_500 * 1e18);
        assertEq(bond.balanceOf(investorBob), 1_500 * 1e18);

        // 2. 非 €500 整数倍的转账 (€1,250) 应被粒度规则拦截
        vm.prank(investorAlice);
        vm.expectRevert(
            abi.encodeWithSelector(
                SolarBondToken.Bond_InvalidTicketGranularity.selector,
                1_250 * 1e18,
                500 * 1e18
            )
        );
        bond.transfer(investorBob, 1_250 * 1e18);

        // 3. 转给未注册 KYC 的黑客地址应被 AMP _update 钩子拦截
        vm.prank(investorAlice);
        vm.expectRevert(
            abi.encodeWithSelector(
                SolarBondToken.AMP_CosignRejected_UnregisteredInvestor.selector,
                unverifiedHacker
            )
        );
        bond.transfer(unverifiedHacker, 500 * 1e18);
    }

    // 测试 3: 验证卢森堡《区块链法 IV》Control Agent 原子级 Freeze-Wipe-Reissue 恢复
    function test_AtomicFreezeWipeReissueRecovery() public {
        vm.prank(stokrControlAgent);
        bond.atomicFreezeWipeReissue(
            investorAlice,
            aliceNewSafeWallet,
            "LUX-BLOCKCHAIN-LAW-IV-RECOVERY-2026"
        );

        assertEq(bond.balanceOf(investorAlice), 0);
        assertEq(bond.balanceOf(aliceNewSafeWallet), 500_000 * 1e18);

        (, bool isFrozen, , ) = bond.investorRegistry(investorAlice);
        assertTrue(isFrozen);
    }

    // 测试 4: 验证现金流瀑布储备金池 (Sinking Fund) 达到 100.01% 本金覆盖率 (10001 bps)
    function test_WaterfallAnd100Point01PercentPrincipalCoverage() public {
        // 模拟 10 年期累计派息 €800,000，且向偿债备付金池累计截留注入 €2,000,200
        vm.prank(stokrControlAgent);
        bond.recordWaterfallDistribution(800_000 * 1e18, 2_000_200 * 1e18);

        // €2,000,200 / €2,000,000 = 100.01% (10001 bps)
        assertEq(bond.getPrincipalCoverageBps(), 10001);
    }

    // 测试 5: 验证 0.55x DSCR 违约冲击与 IsolationForest 异常自动熔断，以及 1.34x P50 修复
    function test_OracleTelemetryDscrAndCircuitBreaker() public {
        // 模拟 0.55x DSCR (5500 bps) 及逆变器严重异常 (-550)，触发自动熔断暂停
        vm.prank(chainlinkOracle);
        bond.updateSolarTelemetryAndDscr(110_000, 5500, -550);
        assertTrue(bond.paused());

        // Control Agent 完成排查与现金流瀑布修复后解除暂停，预言机更新至 1.34x P50 DSCR (13400 bps)
        vm.prank(stokrControlAgent);
        bond.unpauseAfterAudit();

        vm.prank(chainlinkOracle);
        bond.updateSolarTelemetryAndDscr(320_000, 13400, 1600);
        assertFalse(bond.paused());
        assertEq(bond.currentDscrBps(), 13400);
    }
}