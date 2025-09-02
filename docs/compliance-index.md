# Compliance Mapping Index

This repository demonstrates how a secure AWS multi-account baseline (built with Terraform, OPA, and AWS native services) aligns with international and regional security frameworks.
This index links to detailed mapping documents and provides a one-glance summary table.

---

## 📑 Framework Coverage

- [ISO/IEC 27001 Annex A Mapping (2013 → 2022)](iso27001-mapping.md)
  Global best practice standard for Information Security Management Systems (ISMS). Includes dual mapping to both the 2013 and 2022 Annex A control sets.

- [CIS AWS Foundations Controls Coverage](cis-controls-coverage.md)
  Baseline AWS security controls based on the Center for Internet Security (CIS) AWS Foundations Benchmark.

- [Saudi Arabia — NCA Essential Cybersecurity Controls (ECC) Mapping](nca-ecc-mapping.md)
  Shows how the baseline enforces logging, monitoring, IAM, and threat detection controls required by the National Cybersecurity Authority (NCA) ECC.

- [UAE — NESA / IAS Compliance Mapping](nesa-mapping.md)
  Maps project steps to UAE’s Information Assurance Standard (IAS), including governance, monitoring, and secure development requirements.

---

## 📊 One-Glance Compliance Mapping (Summary)

| Step | Implementation Example | ISO/IEC 27001 (2013→2022) | CIS AWS Foundations | Saudi NCA ECC | UAE NESA / IAS |
|------|-------------------------|---------------------------|---------------------|---------------|----------------|
| **1 — State Backend** | S3 backend SSE-KMS, DynamoDB lock | A.8.20 → 8.24 (crypto), A.8.16 → 5.15 (access control) | 2.2 log encryption, 2.1.1 public access blocked | — | — |
| **2 — Centralized Logging** | CloudTrail, CloudWatch, KMS | A.12.4 → 8.15 (logging), A.8.20 → 8.24 | 2.1 all regions, 2.2 validation, 2.3 CMKs | D1/D2 logging & monitoring | Logging & monitoring |
| **3 — Config & Conformance** | Config rules, Conformance packs | A.12.1 → 5.14, A.18.2.2 → 5.36, A.12.7 → 5.35 | 2.5 Config enabled, 2.6 all resources | CC-06 compliance checks | Compliance & audit governance |
| **4 — Security Hub & GuardDuty** | Threat detection, incident dashboard | A.12.4 → 8.15, A.12.6 → 8.8, A.16.1 → 5.25 | 3.1 GuardDuty, 3.2 Security Hub | D5.5 threat detection, CC-06 | Threat & vulnerability management, security monitoring |
| **5 — OPA Policy-as-Code** | Terraform plan eval, CI/CD enforcement | A.12.6 → 8.8, A.12.4 → 8.15, A.18.2.2 → 5.36, A.9.2.3 → 5.18 | 1.1 MFA, 2.x log checks, 3.x GuardDuty/SecHub | D3.2 secure by design, D5.3 IAM | Secure development lifecycle, automated compliance |
| **6 — Organizations & SCPs** | DenyLeaveOrg, Protect Security Services, RestrictRegions | A.5.1.1 → 5.1, A.12.4 → 8.15, A.9.1.2 → 5.12, A.9.2.3 → 5.18 | 1.1 MFA, 1.5 IAM, 1.6 Root disabled, 2.1 CloudTrail | D5.2 IAM, D5.5 GuardDuty, D1/D2 logging, CC-06 | Governance, access control, continuous monitoring |
