// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {SolarBondToken} from "../src/SolarBondToken.sol";

contract DeploySolarBond is Script {
    function run() external {
        // 1. 从 .env 读取带 0x 前缀的私钥并推导部署者地址
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        bytes32 initialPpaHash = keccak256("LUX_SOLAR_2.5MWP_PPA_2026_001");
        bytes32 treasuryGaid   = keccak256("GAID_LU_SV_TREASURY_001");

        vm.startBroadcast(deployerPrivateKey);

        // 2. 部署 SolarBondToken 逻辑合约 (Implementation)
        SolarBondToken implementation = new SolarBondToken();

        // 3. 编码 initialize 初始化参数并部署 UUPS 代理合约 (ERC1967Proxy)
        bytes memory initData = abi.encodeCall(
            SolarBondToken.initialize,
            (deployer, deployer, deployer, initialPpaHash)
        );
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), initData);
        SolarBondToken bond = SolarBondToken(address(proxy));

        // 4. 在链上初始化卢森堡 SV 发行金库 GAID，铸造 €2.0M 债券并记录 100.01% 储备金覆盖率
        bond.registerInvestorGAID(deployer, treasuryGaid, 3);
        bond.issueBondTokens(deployer, 2_000_000 * 1e18);
        bond.recordWaterfallDistribution(800_000 * 1e18, 2_000_200 * 1e18);

        vm.stopBroadcast();

        // 5. 在终端打印部署成功的合约地址
        console.log("==================================================");
        console.log("Implementation Address:", address(implementation));
        console.log("UUPS Proxy (Bond Token) Address:", address(proxy));
        console.log("Current DSCR (bps):", bond.currentDscrBps());
        console.log("Principal Coverage (bps):", bond.getPrincipalCoverageBps());
        console.log("==================================================");
    }
}