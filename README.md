# LU-SOLAR-2026: €2.0M Tokenised C&I Solar Debt Instrument (STOKR Case Study & Interactive Portal)
# 卢森堡 200 万欧元工商业光伏代币化担保债券（STOKR 机构级框架与交互式风控终端）

![MiFID II](https://img.shields.io/badge/Regulation-MiFID%20II%20Transferable%20Security-10b981)
![Ex-MiCAR](https://img.shields.io/badge/Ex--MiCAR-Art.%202(4)(a)-38bdf8)
![Architecture](https://img.shields.io/badge/Smart%20Contract-UUPS%20Proxy%20%E2%87%84%20Liquid%20AMP-6366f1)
![Oracle](https://img.shields.io/badge/Oracle-Chainlink%20%2B%20Creos%20Grid%20Audit-0ea5e9)
![AI Risk](https://img.shields.io/badge/AI%20Telemetry-Isolation%20Forest-f59e0b)

---

## 1. Live Interactive Portal & Repository Deliverables (在线交互终端与核心交付物)

- **🌐 Live Interactive Web2 Portal & Stress-Testing Simulator (在线交互式看板与压力测试模拟器):**  
  👉 **[https://zengandreswang.github.io/stokr-solar-dashboard/](https://zengandreswang.github.io/stokr-solar-dashboard/)**
- **📄 3-Page Institutional Proposal (`STOKR Proposal - Tokenised Solar Debt Instrument.pdf`):**  
  完整的 3 页商业与技术提案，涵盖欧洲可验证先例、混合链上/链下预言机架构、认知公平散户披露表、12 个月落地路线图及法律边界分析。
- **📊 6-Page Technical & Financial Modeling Appendix (`Appendix.pdf`):**  
  6 页补充技术与财务建模附录，包含权威欧洲数据基准（Fraunhofer ISE, EU JRC PVGIS, ILR, Creos, Pexapark）、三种债券结构对比、第 10 年剩余资产净现值（Residual NPV）覆盖证明及 7 组多情景敏感性矩阵。
- **💻 Source Code (`index.html`):**  
  采用 Tailwind CSS 与 Chart.js 构建的 V4 版三合一交互式前端控制台（包含散户认购看板、动态财务模拟器、AI 逆变器故障预警与智能合约合规后台）。

---

## 2. Executive Summary & Value Proposition (项目核心价值与痛点解决)

本项目针对卢森堡一座 **2.5 MWp 工商业（C&I）光伏电站**（30 年物理设计寿命，总资本开支 €2,000,000，按 €800/kWp 欧洲基准测算），设计了一套符合欧盟 **MiFID II“可转让证券（Transferable Security）”** 标准的 **€2.0M 优先有担保债券代币化方案**。

### Three Measurable Impact Indicators (三大可量化核心成效)
1. **Retail Financial Inclusion (散户准入民主化 — 门槛降低 99.5%):**  
   将传统再生能源基建私募债 €100,000+ 的最低认购门槛降至 **€500/枚（共发行 4,000 枚 `SOLAR-26` 代币）**，并在 STOKR 直观的 Web2 界面下完全抽象底层 EVM 与 Liquid Network 复杂操作，支持欧元/SEPA 无缝认购。
2. **Lifecycle Cost Compression (全周期服务成本压缩 — 节省 68.2% / €167,000):**  
   利用卢森堡《2019年7月16日招股书法》下低于 €8.0M 公开发行的简化信息备忘录（Information Note）豁免，并结合智能合约自动化利息核算，将 10 年期累计发行与代理行服务成本从传统债务的 **€245,000（占 CapEx 12.25%）压缩至 €78,000**（含 €48k 法律/审计设立费及 €3k/年预言机维护费），净节省 **€167,000**。
3. **AI Cash Flow Preservation (链下 AI 预测性维护 — 守护 1.20x 机构偿债契约线):**  
   部署无监督机器学习模型（`sklearn.ensemble.IsolationForest`）实时监测光伏阵列辐照度与组串逆变器性能比（PR %）。当模拟 3 号逆变器故障（PR 跌至 63.8%，未干预将导致年发电量损失 300 MWh / €22.5k，使 DSCR 跌破 1.20x 警戒线至 1.14x）时，系统触发 48 小时人工介入（Human-in-the-Loop）抢修，成功挽回 **+€20.6k** 营收并将 DSCR 锁定在 **1.32x** 安全区间。

---

## 3. Financial Engineering: Resolving the 30-Year vs. 10-Year Duration Mismatch (财务工程与久期匹配证明)

基于欧盟联合研究中心（EU JRC PVGIS v5.2）对卢森堡南部光照带的测算，2.5 MWp 电站在 P50 基准下年发电量为 **2,500 MWh**（1,000 kWh/kWp，PR 79.2%），扣除每年 **€40,000** 固定运维成本（OpEx）后，在保守的 **€75/MWh 卢森堡电网并网保底电价（Grid PPA Floor）** 下可产生 **€147,500/年** 的净经营现金流（Annual OCF）。

### Structural Comparison Across Three Candidate Bond Architectures (三种候选债券结构对比)

| Bond Architecture (债券结构) | Annual Debt Service (年偿债额) | Baseline DSCR (基准偿债覆盖率) | Year-10 Principal & Liquidity Outcome (第10年本金偿付及流动性表现) | Verdict (评估结论) |
| :--- | :--- | :--- | :--- | :--- |
| **1. 10-Yr Bullet Bond (5.5% 按年付息、到期还本)** | **€110,000 / yr** (仅付息) | **1.34x (健康)** (+€37.5k/年现金盈余) | 第 10 年末由第 11–30 年剩余寿命资产净现值（**€1,625,230** @ 6.5% WACC）+ 10 年累计储备金（**€375,000**）提供 **€2,000,230（100.01% 本金覆盖）**，支持银行再融资或二级市场机构买断退出。 | **✅ Selected (最优方案)** |
| **2. 10-Yr Fully Amortising (10年期等额本息)** | **€265,346 / yr** (本金+利息) | **0.55x (违约)** (-€117.8k/年现金缺口) | 强行要求 30 年寿命的光伏资产在 10 年内摊销完 €2.0M 本金，第 1 年即发生结构性违约（即便利率降至 0%，每年 €200k 直线本金摊销仍超出 €147.5k OCF）。 | ❌ Immediate Default (结构性违约) |
| **3. 30-Yr Profit-Participating Note (100% 现金流清扫 PPN)** | **€147,500 / yr** (100% 现金流清扫) | **N/A** (首年付息 €110k + 还本 €37.5k) | 虽避免技术性违约，但在 P50 基准下需 **25.6 年** 才能还清本金；若遇 -10% 阴雨天气（P75: 2,250 MWh），回本周期拉长至 **34.8 年**（超出组件 30 年物理寿命），导致散户资金长期锁死。 | ❌ Illiquid Lockup (流动性锁死) |

### Multi-Scenario Stress Testing & Dual PPA Regimes (多情景压力测试与双模式购电协议)
- **P90 Severe Weather Shock (-20% 十年一遇极端低光照冲击):** 年发电量降至 **2,000 MWh** 时，按 €75/MWh 保底电价计算的净现金流为 **€110,000**，依然实现 **1.00x 盈亏平衡 DSCR**，100% 覆盖 €110,000 债券利息且无本金违约。
- **On-Site C&I Corporate PPA Upside (卢森堡工商业表后直供电溢价):** 若不走公共电网招标（Mode A: €70–€86/MWh），而是通过私有线路直接向卢森堡本地工厂或物流中心供电（Mode B: **€95–€125/MWh**，相比卢森堡非居民零售电价 €164.3–€200+/MWh 为企业节省约 40% 用电成本），年净现金流将跃升至 **€197,500–€272,500**，驱动 Bullet Bond 的 DSCR 升至 **1.80x–2.48x**。
- **Mathematical Breakeven Limits (数学盈亏平衡极限):** 在 €147,500 基准 OCF 下，Bullet Bond 最高可承受 **7.375% p.a.** 的票面利率（维持 DSCR ≥ 1.00x），或在 5.50% 利率下最低可承受 **€60.00/MWh** 的极限电价。

---

## 4. Hybrid On/Off-Chain Technical & Regulatory Architecture (混合链上/链下技术与卢森堡监管架构)

1. **Multi-Chain Portability (UUPS 代理与比特币侧链 Liquid AMP 兼容):**  
   原型基于以太坊 Sepolia 测试网的 OpenZeppelin `UUPSUpgradeable` 代理合约构建，并将合规状态机（白名单、冻结、增发、熔断）一对一映射至 STOKR 旗舰的 **Bitcoin Liquid Network (Blockstream AMP)** 架构。
2. **BIS Project Genesis Oracle Standard & Creos Grid Reconciliation (预言机防篡改与国家电网对账):**  
   通过 Chainlink `AggregatorV3Interface` 每日读取物理 Smarty 物联网智能电表的发电量（MWh）。为防范国际清算银行（BIS）*Project Genesis* 指出的物理传感器“垃圾进、不可篡改垃圾出”风险，链上预言机数据每个季度必须与卢森堡国家电网运营商 **Creos Luxembourg S.A.** 及国家监管局 **ILR** 的官方结算账单完成链下交叉审计，核验通过后方可释放利息池。
3. **Luxembourg Unregulated SV & Receivable Locking (卢森堡非监管证券化工具与防重复质押):**  
   依据《2004年3月22日卢森堡证券化法》设立独立 **Unregulated Securitisation Vehicle (SV)**，执行严格的**有限追索权（Limited Recourse）**隔离；同时将 10 年期 PPA 应收账款锁定在 **STOKR Private Credit Registry** 中，从源头杜绝底层现金流重复质押（Double-Pledging）。
4. **Zero Permanent Loss Governance (零永久损失合规恢复机制):**  
   当散户遭遇私钥丢失或黑客盗币并完成身份核验（或凭法院指令）后，持有 `COMPLIANCE_ROLE` 的合规官可执行原子化 **Freeze（冻结被盗地址）→ Wipe（定向销毁违规代币）→ Reissue（向投资者验证过的备份钱包等额补发代币）**；同时 `PAUSER_ROLE` 可在预言机异常或 CSSF 监管问询时一键触发二级市场全局熔断（`pause()`）。

---

## 5. Interactive Dashboard User Guide (`index.html` 三大交互模块说明)

打开在线演示链接后，可通过顶部导航栏切换三个核心视图：
- **Tab 1 — Investor Portal (Web2 UI 投资者门户):** 模拟已完成 SEPA/KYC 白名单认证的散户投资者视角，支持一键认购 €500 代币（`+ Subscribe €500`）、查看通俗语言投资者说明书（Plain-Language Factsheet）、发起私钥丢失恢复申请，以及点击 `Simulate Daily IoT Meter → Oracle & Creos Sync` 模拟每日电表数据上链与电网对账。
- **Tab 2 — Financial Stress-Test Simulator (财务压力测试模拟器):** 内置 5 个一键预设场景按钮（P50 基准、10 年摊销违约、P90 天气冲击、€95/MWh 工商业直供电、PPN 25.6 年锁死），并提供发电量（2,000–2,500 MWh）、PPA 电价（€40–€150/MWh）与票面利率（3.0%–9.0%）实时滑块，动态计算 DSCR 与第 10 年剩余资产净现值覆盖率。
- **Tab 3 — AI Risk & Compliance Console (AI 风控与合规管理后台):** 支持管理员模拟注入 3 号逆变器硬件故障（`Simulate Inverter #3 Fault`）并执行 48 小时人工介入派单（`Human-in-the-Loop: 48h O&M Triage`），同时可实时演示链下 KYC 审批上链、原子化钱包恢复（Freeze → Wipe → Reissue）、全局紧急熔断（`pause()`）以及查看底部的多链智能合约事件审计终端（`SolarDebtTokenUUPS.sol`）。

---

## Author (作者)
**Wang (Andres) Zeng**  
MSc in Finance and Economics, University of Luxembourg | Master of Finance, The University of Hong Kong  
- **Related Project:** [ScorpionMICA2 — MiCA-Compliant Upgradeable Stablecoin with Chainlink Proof-of-Reserve](https://github.com/zengandreswang/scorpion-mica-stablecoin)
- **LinkedIn:** [www.linkedin.com/in/wang-zeng](https://www.linkedin.com/in/wang-zeng)
