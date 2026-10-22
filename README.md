# LU-SOLAR-2026: €2.0M Tokenised C&I Solar Debt Instrument (STOKR Institutional Framework & Interactive Portal)

![MiFID II](https://img.shields.io/badge/Regulation-MiFID%20II%20Transferable%20Security-10b981)
![Ex-MiCAR](https://img.shields.io/badge/Ex--MiCAR-Art.%202(4)(a)-38bdf8)
![Architecture](https://img.shields.io/badge/Smart%20Contract-UUPS%20Proxy%20%E2%87%84%20Liquid%20AMP-6366f1)
![Oracle](https://img.shields.io/badge/Oracle-Chainlink%20%2B%20Creos%20Grid%20Audit-0ea5e9)
![AI Telemetry](https://img.shields.io/badge/AI%20Telemetry-Isolation%20Forest-f59e0b)

## 1. Live Interactive Portal & Repository Deliverables

- **Live Interactive Web2 Portal & Stress-Testing Simulator:**  
  [https://zengandreswang.github.io/stokr-solar-dashboard/](https://zengandreswang.github.io/stokr-solar-dashboard/)
  [https://sepolia.etherscan.io/address/0xa728BE19dcD714030FAb00C5ca9d0c6350bEBDE1#readProxyContract](https://sepolia.etherscan.io/address/0xa728BE19dcD714030FAb00C5ca9d0c6350bEBDE1#readProxyContract)
- **3-Page Institutional Proposal (`STOKR Proposal - Tokenised Solar Debt Instrument.pdf`):**  
  End-to-end commercial and technical proposal covering verifiable European precedents, hybrid on/off-chain oracle architecture, cognitive-fairness retail disclosures, a 12-month implementation roadmap, and Luxembourg legal boundaries.
- **6-Page Technical & Financial Modeling Appendix (`Appendix.pdf`):**  
  Supplementary quantitative documentation detailing authoritative European benchmarks (Fraunhofer ISE, EU JRC PVGIS v5.2, ILR, Creos Luxembourg S.A., Pexapark, ECB, LuxSE LGX), candidate bond structure comparisons, Year-10 residual asset Net Present Value (NPV) coverage proofs, and a 7-scenario sensitivity matrix.
- **Application Source Code (`index.html`):**  
  Single-page V4 interactive institutional dashboard built with Tailwind CSS and Chart.js, integrating a Web2 Retail Investor Portal, a dynamic Financial Stress-Test Simulator, and an Admin AI Risk & Smart Contract Compliance Console.

---

## 2. Executive Summary & Value Proposition

This project structures the tokenisation of a **€2.0M senior secured debt instrument** financing a **2.5 MWp Commercial & Industrial (C&I) solar photovoltaic installation** in Luxembourg (30-year physical design life; €800/kWp CapEx benchmark). Engineered strictly as a **MiFID II "Transferable Security"** (explicitly excluded from MiCAR under Article 2(4)(a)), the framework resolves the duration mismatch between 30-year renewable infrastructure assets and 10-year capital market liquidity horizons.

### Three Measurable Impact Indicators
1. **Retail Financial Inclusion (99.5% Reduction in Minimum Entry Ticket):**  
   Lowers minimum investment thresholds from the €100,000+ institutional private placement standard to **€500 per token (4,000 `SOLAR-26` tokens)**, while abstracting EVM UUPS and Bitcoin Liquid Network (Blockstream AMP) complexity behind an intuitive Web2 SEPA/Euro subscription interface.
2. **Lifecycle Cost Compression (68.2% Servicing Reduction / €167,000 Saved):**  
   Leverages the **Luxembourg Prospectus Law of 16 July 2019** simplified Information Note exemption (for public offerings below €8.0M) alongside automated smart contract coupon accounting, compressing 10-year cumulative issuance and paying-agent overhead from **€245,000 (12.25% of CapEx) to €78,000** (€48k setup/audit + €3k/yr oracle maintenance).
3. **Predictive Cash Flow Preservation (Protecting the 1.20x DSCR Covenant via AI):**  
   Deploys an off-chain unsupervised machine learning model (`sklearn.ensemble.IsolationForest`) monitoring plane-of-array irradiance and string inverter Performance Ratios (PR %). Under a simulated Inverter #3 hardware fault (PR drop to 63.8%, threatening a -300 MWh / -€22.5k loss that erodes DSCR to 1.14x), a 48-hour human-in-the-loop O&M dispatch saves **+€20.6k** in revenue and preserves DSCR at **1.32x**.

---

## 3. Financial Engineering: Resolving the 30-Year vs. 10-Year Duration Mismatch

Anchored to **EU JRC PVGIS v5.2** irradiance data for Southern Luxembourg (49.5°N, 6.0°E, 35° tilt, 79.2% PR), the 2.5 MWp facility generates a P50 baseline yield of **2,500 MWh/yr** (1,000 kWh/kWp). Net of **€40,000/yr** in fixed O&M and insurance expenses (€16/kWp benchmark), the plant produces an **Annual Operating Cash Flow (OCF) of €147,500** at a conservative **€75.00/MWh Luxembourg grid-injection PPA floor**.

### Structural Comparison Across Three Candidate Bond Architectures

| Bond Architecture | Annual Debt Service | Baseline DSCR | Year-10 Principal & Liquidity Outcome | Verdict |
| :--- | :--- | :--- | :--- | :--- |
| **1. 10-Yr Bullet Bond (5.5% Interest-Only)** | **€110,000 / yr** (Coupon Only) | **1.34x (Healthy)** (+€37.5k/yr cash buffer) | Full €2.0M principal repaid at Year 10 via bank refinancing or institutional buyout backed at **100.01% (€2,000,230)** by Years 11–30 Residual Asset NPV (**€1,625,230** @ 6.50% WACC) + 10-year accumulated cash reserves (**€375,000** at 0% interest, or **€429,895** @ 3.0% money-market yield). | **Selected Architecture** |
| **2. 10-Yr Fully Amortising (Constant P&I)** | **€265,346 / yr** (Principal + Interest) | **0.55x (Default)** (-€117.8k/yr cash deficit) | Forcing a 30-year infrastructure asset to amortise its full €2.0M CapEx over 10 years causes immediate Year-1 insolvency (even at a 0.00% coupon, €200k/yr straight-line principal repayment exceeds €147.5k OCF). | Immediate Structural Default |
| **3. 30-Yr Profit-Participating Note (100% Cash Sweep PPN)** | **€147,500 / yr** (100% OCF Sweep) | **N/A** (Yr-1: €110k Int + €37.5k Prin) | Avoids technical default but requires **25.6 years** to retire principal under P50 yield, stretching to **34.8 years** under a -10% P75 cloud shock (2,250 MWh)—exceeding the 30-year physical panel lifespan and locking up retail capital. | Illiquid Multi-Decade Lockup |

### Multi-Scenario Stress Testing & Dual Luxembourg Offtake Regimes
- **P90 Severe Weather Shock (-20% Irradiance Deficit):** Under a 1-in-10-year meteorological shock reducing output to **2,000 MWh/yr**, net OCF at the €75/MWh grid floor equals **€110,000/yr**, matching the €110,000 Bullet Bond interest obligation euro-for-euro (**1.00x Breakeven DSCR**) with zero principal default.
- **On-Site C&I Corporate PPA Upside (Mode B Behind-the-Meter):** Supplying an industrial plant or logistics hub directly via private wire at **€95–€125/MWh** (saving the corporate buyer ~40% against Luxembourg's €164.3–€200+/MWh non-household retail grid tariff) boosts Annual OCF to **€197,500–€272,500**, driving Bullet Bond DSCR to **1.80x–2.48x**.
- **Mathematical Breakeven Thresholds:** At the €147,500 baseline OCF, the Bullet Bond remains cash-flow positive (DSCR >= 1.00x) up to a maximum coupon of **7.375% p.a.** (and DSCR >= 1.20x up to **6.14% p.a.**), or breaks even at a minimum PPA tariff of **€60.00/MWh** at the 5.50% coupon.

---

## 4. Hybrid On/Off-Chain Technical & Regulatory Architecture

1. **Multi-Chain Institutional Portability (EVM UUPS ⇄ Bitcoin Liquid Network AMP):**  
   Prototyped on Ethereum Sepolia using OpenZeppelin's `UUPSUpgradeable` proxy pattern (`SolarDebtTokenUUPS.sol`), with deterministic state-machine mapping to STOKR's flagship **Bitcoin Liquid Network (Blockstream AMP)** register.
2. **BIS Project Genesis Oracle Standard & Creos Grid Reconciliation:**  
   Ingests daily MWh generation telemetry from physical Smarty IoT meters via Chainlink's `AggregatorV3Interface`. To mitigate physical sensor manipulation ("garbage in, immutable garbage out" per BIS *Project Genesis*), on-chain meter feeds undergo mandatory quarterly off-chain reconciliation against official grid settlement invoices from **Creos Luxembourg S.A.** (national TSO/DSO) and the **ILR** prior to coupon disbursement.
3. **Luxembourg Unregulated SV & Anti-Double-Pledging Registry:**  
   Issued via a bankruptcy-remote **Unregulated Securitisation Vehicle (SV)** under the **Luxembourg Securitisation Law of 22 March 2004**, enforcing a strict **Limited Recourse** boundary. Underlying 10-year PPA receivables are locked in the **STOKR Private Credit Registry** to prevent double-pledging.
4. **Zero Permanent Loss Governance (Atomic Freeze, Wipe & Reissue):**  
   Eliminates irreversible blockchain key-loss risk for retail investors. Upon verified identity checks or a judicial order, STOKR's `COMPLIANCE_ROLE` can atomically **Freeze** a compromised wallet, **Wipe** illicitly held tokens, and **Reissue** replacement tokens to a verified backup address. Simultaneously, `PAUSER_ROLE` provides an emergency circuit breaker (`pause()`) to halt secondary transfers during oracle anomalies or CSSF inquiries.

---

## 5. Interactive Dashboard User Guide (`index.html`)

Navigate across the three core operational views via the top header bar:
- **Tab 1 — Investor Portal (Web2 UI):** Simulates a KYC-whitelisted retail investor account (`0x71C8...9A2B`). Users can subscribe €500 tickets (`+ Subscribe €500`), review the Plain-Language Investor Factsheet, trigger live Chainlink IoT meter & Creos grid syncs, or file a lost-key recovery request.
- **Tab 2 — Financial Stress-Test Simulator:** Features 5 one-click institutional scenario presets (Baseline P50 Grid PPA, 10-Yr Amortising Default, P90 Weather Shock, €95/MWh C&I Direct PPA, and 30-Yr PPN Sweep) alongside interactive sliders for Annual Solar Yield (2,000–2,500 MWh), PPA Tariff (€40–€150/MWh), and Coupon Rate (3.0%–9.0%).
- **Tab 3 — AI Risk & Compliance Console (Admin):** Enables compliance officers to inject an Inverter #3 hardware anomaly and execute 48-hour O&M triage (`IsolationForest`), approve off-chain KYC applications onto the on-chain whitelist, execute atomic wallet recovery (`Freeze → Wipe → Reissue`), toggle the global circuit breaker (`pause()`), and inspect the live multi-chain smart contract event terminal.

---

## Author
**Wang (Andres) Zeng**  
MSc in Finance and Economics, University of Luxembourg | Master of Finance, The University of Hong Kong  
- **Sister Repository (MiCA Stablecoin Prototype):** [ScorpionMICA2 — MiCA-Compliant Upgradeable Stablecoin with Chainlink Proof-of-Reserve](https://github.com/zengandreswang/scorpion-mica-stablecoin)
- **LinkedIn:** [www.linkedin.com/in/wang-zeng](https://www.linkedin.com/in/wang-zeng)
