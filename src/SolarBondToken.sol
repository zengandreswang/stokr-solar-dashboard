// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title SolarBondToken (Full LHoFT Proposal Edition — STOKR S.A. Case Study)
 * @notice 卢森堡 SV €2.0M 太阳能高级担保到期一次还本债券 (2.5 MWp, 10年期)
 * @dev 完整包含:
 *      1. Blockstream AMP 映射 (GAID 注册表、Category 矩阵、_update 协同签名拦截)
 *      2. 卢森堡《区块链法 IV》Control Agent 原子级 Freeze-Wipe-Reissue 恢复
 *      3. STOKR Private Credit Registry 底层 PPA 应收账款防重复质押锁定
 *      4. €500 最小投资门槛与整数倍转账粒度校验
 *      5. 现金流瀑布储备金池 (Sinking Fund) 实时追踪 100.01% 本金覆盖率与 P50/P90 DSCR 契约
 *      6. Chainlink IoT 电表预言机 + IsolationForest 逆变器异常自动熔断器 (Circuit Breaker)
 */
contract SolarBondToken is 
    Initializable, 
    ERC20Upgradeable, 
    AccessControlUpgradeable, 
    PausableUpgradeable, 
    UUPSUpgradeable 
{
    // =============================================================
    //                    1. 角色与核心常量定义
    // =============================================================
    bytes32 public constant CONTROL_AGENT_ROLE = keccak256("CONTROL_AGENT_ROLE");
    bytes32 public constant ORACLE_FEED_ROLE   = keccak256("ORACLE_FEED_ROLE");
    bytes32 public constant UPGRADER_ROLE      = keccak256("UPGRADER_ROLE");

    uint256 public constant BOND_PRINCIPAL_EUR     = 2_000_000 * 1e18; // €2.0M 债券总本金
    uint256 public constant MIN_TICKET_EUR         = 500 * 1e18;       // Proposal: €500 最小认购/转让步长
    uint256 public constant TARGET_P50_DSCR_BPS    = 13400;            // Proposal: 1.34x P50 目标 DSCR
    uint256 public constant BREAKEVEN_P90_DSCR_BPS = 10000;            // Proposal: 1.00x P90 盈亏平衡底线
    int256  public constant CRITICAL_ANOMALY_SCORE = -500;             // IsolationForest 触发自动熔断阈值

    // =============================================================
    //           2. STOKR Private Credit Registry (防重复质押)
    // =============================================================
    struct PPACollateralRecord {
        bytes32 ppaContractHash;     // 光伏电站购电协议 (PPA) 唯一文件哈希
        uint256 capacityKwp;         // 装机容量: 2,500 kWp (2.5 MWp)
        uint256 maturityTimestamp;   // 10年期到期时间戳
        uint256 residualNpv20YrEur;  // 20年全生命周期残值 NPV 评估额
        bool    isPledged;           // 是否已排他性锁定
    }

    PPACollateralRecord public collateralAsset;
    // 全局已质押 PPA 哈希表，防止同一笔应收账款被重复质押 (Anti-Double-Pledging)
    mapping(bytes32 => bool) public globalPledgedPpaRegistry;

    // =============================================================
    //              3. Blockstream AMP 映射身份与分类结构
    // =============================================================
    struct InvestorProfile {
        bool    isRegistered;
        bool    isFrozen;
        uint8   category;   // 1: 零售合格投资者(€500起), 2: 机构投资者, 3: 卢森堡 SV 发行金库
        bytes32 gaidHash;   // 映射 Blockstream AMP GAID
    }

    mapping(address => InvestorProfile) public investorRegistry;
    mapping(uint8 => mapping(uint8 => bool)) public categoryTransferMatrix;

    // =============================================================
    //        4. 现金流瀑布 (Waterfall) 与 IoT 预言机状态变量
    // =============================================================
    uint256 public currentDscrBps;             // 当前 DSCR (如 5500 = 0.55x, 13400 = 1.34x)
    uint256 public sinkingFundBalanceEur;      // 链上记录的偿债备付金池累计余额 (目标 €2,000,200 = 100.01%)
    uint256 public cumulativeCouponPaidEur;    // 已累计派发的票息总额
    uint256 public latestGenerationKwh;        // Chainlink IoT 电表上报发电量
    int256  public isolationForestScoreBps;    // IsolationForest 逆变器遥测得分
    bool    public cashSweepWaterfallActive;   // 超额现金流截留机制开关

    // =============================================================
    //                       5. 错误与事件定义
    // =============================================================
    error AMP_CosignRejected_UnregisteredInvestor(address account);
    error AMP_CosignRejected_AccountFrozen(address account);
    error AMP_CosignRejected_CategoryRestriction(uint8 fromCat, uint8 toCat);
    error Bond_InvalidTicketGranularity(uint256 amount, uint256 minTicket);
    error Bond_CapExceeded(uint256 requested, uint256 maxPrincipal);
    error Registry_PPADoublePledgeDetected(bytes32 ppaHash);
    error AMP_InvalidRecoveryParameters();

    event PPACollateralLocked(bytes32 indexed ppaHash, uint256 capacityKwp, uint256 residualNpvEur);
    event AMPInvestorRegistered(address indexed wallet, bytes32 indexed gaidHash, uint8 category);
    event AMPAtomicFreezeWipeReissue(
        address indexed compromisedWallet,
        address indexed newSafeWallet,
        uint256 amountRecovered,
        bytes32 gaidHash,
        string legalReference
    );
    event WaterfallCashSweepExecuted(
        uint256 couponPaidEur,
        uint256 reserveInjectedEur,
        uint256 totalSinkingFundEur,
        uint256 principalCoverageBps
    );
    event TelemetryAndCovenantUpdated(
        uint256 generationKwh,
        uint256 newDscrBps,
        int256 anomalyScoreBps,
        bool cashSweepActive,
        bool circuitBreakerPaused
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address admin,
        address controlAgent,
        address oracleNode,
        bytes32 initialPpaHash
    ) public initializer {
        __ERC20_init("Luxembourg SV Solar Senior Bond 2026", "STOKR-SOLAR26");
        __AccessControl_init();
        __Pausable_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(CONTROL_AGENT_ROLE, controlAgent);
        _grantRole(ORACLE_FEED_ROLE, oracleNode);
        _grantRole(UPGRADER_ROLE, admin);

        // 锁定 2.5 MWp 光伏电站 PPA 应收账款，防止重复质押
        _registerAndLockPPA(initialPpaHash, 2500, block.timestamp + 3650 days, 3_450_000 * 1e18);

        // 开启 Category 1 (零售)、2 (机构)、3 (SV 金库) 之间的合规流转
        for (uint8 i = 1; i <= 3; i++) {
            for (uint8 j = 1; j <= 3; j++) {
                categoryTransferMatrix[i][j] = true;
            }
        }

        currentDscrBps = TARGET_P50_DSCR_BPS; // 1.34x P50 DSCR
        isolationForestScoreBps = 1500;
        cashSweepWaterfallActive = true;
    }

    // =============================================================
    //        6. STOKR Private Credit Registry 防重复质押逻辑
    // =============================================================
    function _registerAndLockPPA(
        bytes32 ppaHash,
        uint256 capacityKwp,
        uint256 maturity,
        uint256 residualNpvEur
    ) internal {
        if (globalPledgedPpaRegistry[ppaHash]) {
            revert Registry_PPADoublePledgeDetected(ppaHash);
        }
        globalPledgedPpaRegistry[ppaHash] = true;
        collateralAsset = PPACollateralRecord({
            ppaContractHash: ppaHash,
            capacityKwp: capacityKwp,
            maturityTimestamp: maturity,
            residualNpv20YrEur: residualNpvEur,
            isPledged: true
        });
        emit PPACollateralLocked(ppaHash, capacityKwp, residualNpvEur);
    }

    function verifyPpaNotDoublePledged(bytes32 ppaHash) external view returns (bool) {
        return !globalPledgedPpaRegistry[ppaHash];
    }

    // =============================================================
    //         7. 现金流瀑布与 100.01% 偿债备付金池 (Sinking Fund)
    // =============================================================

    /**
     * @notice 记录每期光伏电费净现金流分配 (先付票息，超额现金流注入偿债备付金池)
     * @dev 在第 10 年到期时，sinkingFundBalanceEur 达到 €2,000,200 即实现简历中的 100.01% 本金覆盖率
     */
    function recordWaterfallDistribution(
        uint256 couponPaidEur,
        uint256 reserveInjectedEur
    ) external onlyRole(CONTROL_AGENT_ROLE) whenNotPaused {
        cumulativeCouponPaidEur += couponPaidEur;
        sinkingFundBalanceEur += reserveInjectedEur;

        emit WaterfallCashSweepExecuted(
            couponPaidEur,
            reserveInjectedEur,
            sinkingFundBalanceEur,
            getPrincipalCoverageBps()
        );
    }

    /**
     * @notice 实时计算本金覆盖率 (以基点表示: 10001 bps = 100.01%)
     */
    function getPrincipalCoverageBps() public view returns (uint256) {
        return (sinkingFundBalanceEur * 10000) / BOND_PRINCIPAL_EUR;
    }

    // =============================================================
    //       8. Chainlink IoT 预言机、DSCR 契约与自动紧急熔断器
    // =============================================================
    function updateSolarTelemetryAndDscr(
        uint256 generationKwh,
        uint256 newDscrBps,
        int256 anomalyScoreBps
    ) external onlyRole(ORACLE_FEED_ROLE) {
        latestGenerationKwh = generationKwh;
        currentDscrBps = newDscrBps;
        isolationForestScoreBps = anomalyScoreBps;

        // 当 DSCR 低于 P50 (1.34x) 或进入 P90 压力区间 (1.00x) 时，强制开启现金流截留瀑布
        if (newDscrBps < TARGET_P50_DSCR_BPS) {
            cashSweepWaterfallActive = true;
        }

        // Proposal 机制: 若 IsolationForest 检测到严重硬件故障/欺诈 (<= -500) 或 DSCR 跌破 0.55x 违约线，自动触发紧急熔断
        bool triggeredPause = false;
        if (anomalyScoreBps <= CRITICAL_ANOMALY_SCORE || newDscrBps <= 5500) {
            _pause();
            triggeredPause = true;
        }

        emit TelemetryAndCovenantUpdated(
            generationKwh,
            newDscrBps,
            anomalyScoreBps,
            cashSweepWaterfallActive,
            triggeredPause
        );
    }

    function unpauseAfterAudit() external onlyRole(CONTROL_AGENT_ROLE) {
        _unpause();
    }

    // =============================================================
    //      9. Blockstream AMP 白名单、发行与 Freeze-Wipe-Reissue
    // =============================================================
    function registerInvestorGAID(
        address wallet,
        bytes32 gaidHash,
        uint8 category
    ) external onlyRole(CONTROL_AGENT_ROLE) {
        investorRegistry[wallet] = InvestorProfile({
            isRegistered: true,
            isFrozen: false,
            category: category,
            gaidHash: gaidHash
        });
        emit AMPInvestorRegistered(wallet, gaidHash, category);
    }

    function issueBondTokens(address to, uint256 amount) external onlyRole(CONTROL_AGENT_ROLE) {
        if (totalSupply() + amount > BOND_PRINCIPAL_EUR) {
            revert Bond_CapExceeded(totalSupply() + amount, BOND_PRINCIPAL_EUR);
        }
        _mint(to, amount);
    }

    function atomicFreezeWipeReissue(
        address compromisedWallet,
        address newSafeWallet,
        string calldata legalReference
    ) external onlyRole(CONTROL_AGENT_ROLE) {
        if (compromisedWallet == address(0) || newSafeWallet == address(0) || compromisedWallet == newSafeWallet) {
            revert AMP_InvalidRecoveryParameters();
        }
        InvestorProfile storage oldProfile = investorRegistry[compromisedWallet];
        if (!oldProfile.isRegistered) revert AMP_CosignRejected_UnregisteredInvestor(compromisedWallet);

        uint256 recoveryBalance = balanceOf(compromisedWallet);
        if (recoveryBalance == 0) revert AMP_InvalidRecoveryParameters();

        if (!investorRegistry[newSafeWallet].isRegistered) {
            investorRegistry[newSafeWallet] = InvestorProfile({
                isRegistered: true,
                isFrozen: false,
                category: oldProfile.category,
                gaidHash: oldProfile.gaidHash
            });
        }

        _burn(compromisedWallet, recoveryBalance);
        oldProfile.isFrozen = true;
        _mint(newSafeWallet, recoveryBalance);

        emit AMPAtomicFreezeWipeReissue(
            compromisedWallet,
            newSafeWallet,
            recoveryBalance,
            oldProfile.gaidHash,
            legalReference
        );
    }

    // =============================================================
    //     10. _update 钩子: 复刻 AMP 协同签名 + €500 最小票面粒度控制
    // =============================================================
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override whenNotPaused {
        // 校验 Proposal €500 最小认购与转让粒度
        if (value % MIN_TICKET_EUR != 0) {
            revert Bond_InvalidTicketGranularity(value, MIN_TICKET_EUR);
        }

        if (from == address(0)) {
            InvestorProfile memory receiver = investorRegistry[to];
            if (!receiver.isRegistered) revert AMP_CosignRejected_UnregisteredInvestor(to);
            if (receiver.isFrozen) revert AMP_CosignRejected_AccountFrozen(to);
            super._update(from, to, value);
            return;
        }

        if (to == address(0)) {
            super._update(from, to, value);
            return;
        }

        InvestorProfile memory sender = investorRegistry[from];
        InvestorProfile memory recipient = investorRegistry[to];

        if (!sender.isRegistered) revert AMP_CosignRejected_UnregisteredInvestor(from);
        if (!recipient.isRegistered) revert AMP_CosignRejected_UnregisteredInvestor(to);
        if (sender.isFrozen) revert AMP_CosignRejected_AccountFrozen(from);
        if (recipient.isFrozen) revert AMP_CosignRejected_AccountFrozen(to);

        if (!categoryTransferMatrix[sender.category][recipient.category]) {
            revert AMP_CosignRejected_CategoryRestriction(sender.category, recipient.category);
        }

        super._update(from, to, value);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}
}