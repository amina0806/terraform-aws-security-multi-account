# Compliance Mapping Index

This repository demonstrates how a secure AWS multi-account baseline (built with Terraform, OPA, and AWS native services) aligns with international and regional security frameworks.
This index links to detailed mapping documents and provides a one-glance summary table.

---

## Framework Coverage

- [ISO/IEC 27001 Annex A Mapping (2013 → 2022)](iso27001-mapping.md)
  Global best practice standard for Information Security Management Systems (ISMS). Includes dual mapping to both the 2013 and 2022 Annex A control sets.

- [NIST Cybersecurity Framework (CSF) Mapping](nist-csf-mapping.md)
  Mapping to the NIST Cybersecurity Framework (Identify, Protect, Detect, Respond, Recover).

- [PCI DSS Mapping](pci-dss-mapping.md)
  Coverage for payment card industry requirements, focused on encryption, access control, and monitoring.

- [Saudi Arabia — NCA Essential Cybersecurity Controls (ECC) Mapping](nca-ecc-mapping.md)
  Shows how the baseline enforces logging, monitoring, IAM, and threat detection controls required by the National Cybersecurity Authority (NCA) ECC.

- [Saudi Arabia — SAMA Cybersecurity Framework (CSF) Mapping](sama-csf-mapping.md)
  Demonstrates how the baseline supports compliance with the Saudi Central Bank’s Cybersecurity Framework, covering Governance & Leadership, Risk Management & Compliance, Operations & Technology, and Third-Party Cybersecurity.

- [UAE — NESA / IAS Compliance Mapping](nesa-ias-mapping.md)
  Maps project steps to UAE’s Information Assurance Standard (IAS), including governance, monitoring, and secure development requirements.

- [Qatar — NCSA Cybersecurity Framework (CSF) Mapping](ncsa-csf-mapping.md)
  Alignment with Qatar’s National Cyber Security Agency controls for government and critical sectors.

- [CIS AWS Foundations Controls Coverage](cis-aws-foundations.md)
  Baseline AWS security controls based on the Center for Internet Security (CIS) AWS Foundations Benchmark.

---

## One-Glance Compliance Mapping (Summary)

This summary shows how the secure AWS multi-account baseline (Terraform + Policy-as-Code) aligns with **international standards** and **regional GCC frameworks**.

| Step | Implementation Example | ISO/IEC 27001 | NIST CSF | PCI DSS | Saudi NCA ECC | Saudi SAMA CSF | UAE NESA IAS | Qatar NCSA CSF |
|------|-------------------------|---------------|----------|---------|----------------|----------------|--------------|----------------|
| 1 — State Backend | S3 backend SSE-KMS, DynamoDB lock | A.8.20 → 8.24 (crypto), A.8.16 → 5.15 (access control) | PR.DS-1 (Data-at-rest protected) | Req. 3.5 (Encryption of cardholder data) | — | Cryptography (CRY), Access Control (ACC) | — | Data Protection |
| 2 — Centralized Logging | CloudTrail, CloudWatch, KMS | A.12.4 → 8.15 (logging), A.8.20 → 8.24 | DE.AE-1 (Anomalous activity detected) | Req. 10 (Logging & monitoring) | D1/D2 (Logging & monitoring) | Operations & Technology (LOG) | Logging & monitoring | Logging & Monitoring |
| 3 — Config & Conformance | Config rules, Conformance packs | A.12.1 → 5.14, A.18.2.2 → 5.36 | ID.RA-1 (Risks identified) | Req. 11.5 (File integrity monitoring) | CC-06 (Compliance checks) | Risk Mgmt & Compliance (RSK), Compliance (COM) | Compliance & audit governance | Risk Mgmt & Compliance |
| 4 — Security Hub & GuardDuty | Threat detection, incident dashboard | A.12.4 → 8.15, A.12.6 → 8.8 | DE.CM-1 (Continuous monitoring) | Req. 12.10 (Incident response) | D5.5 (Threat detection), CC-06 | Operations & Technology (TVM, OPM) | Threat & vulnerability mgmt, monitoring | Threat Detection & Response |
| 5 — OPA Policy-as-Code | Terraform plan eval, CI/CD enforcement | A.12.6 → 8.8, A.18.2.2 → 5.36, A.9.2.3 → 5.18 | PR.IP-3 (Secure dev lifecycle) | Req. 6.3 (Secure development practices) | D3.2 (Secure by design), D5.3 (IAM) | Operations & Technology (SSA), Identity & Access (ACC) | Secure development lifecycle | Secure Development Lifecycle |
| 6 — Organizations & SCPs | DenyLeaveOrg, Protect Security Services, RestrictRegions | A.5.1.1 → 5.1, A.12.4 → 8.15, A.9.2.3 → 5.18 | RS.MI-1 (Mitigation executed) | Req. 7.2 (Restrict access to cardholder data) | D5.2 (IAM), D5.5 (GuardDuty), D1/D2 (logging) | Governance & Leadership (GOV), Access Control (ACC) | Governance, access control, monitoring | Governance & Access Control |

---

### Legend
- **SAMA**: GOV = Leadership & Governance | RSK = Risk Mgmt | COM = Compliance | CRY = Cryptography | LOG = Logging | TVM = Threat & Vulnerability Mgmt | SSA = Secure Systems & Applications | ACC = Identity & Access Mgmt
- **NIST CSF**: ID = Identify | PR = Protect | DE = Detect | RS = Respond | RC = Recover
- **PCI DSS**: Req. = Requirement
- **NCA ECC / NESA / NCSA**: Abbreviations match national subdomains.

---

### Conclusion
This compliance mapping demonstrates how the AWS secure multi-account baseline enforces **core security controls** and aligns with both **global standards** (ISO/IEC 27001, NIST CSF, PCI DSS) and **regional GCC frameworks** (NCA, SAMA, NESA, NCSA).

The result: cloud environments that are **secure, audit-ready, and trusted** for regulated industries such as **banking, healthcare, government, telecom, and energy** — fully supporting the cybersecurity priorities of the Gulf region.
