# NIST Cybersecurity Framework Mapping

This document maps the AWS secure multi-account baseline to **NIST CSF (Identify, Protect, Detect, Respond, Recover)**.

| Step | Implementation Example | NIST CSF Function |
|------|-------------------------|-------------------|
| 1 — State Backend | S3 backend SSE-KMS, DynamoDB lock | Protect (PR.DS-1 Data-at-rest protected) |
| 2 — Centralized Logging | CloudTrail + CloudWatch + KMS | Detect (DE.AE-1 Anomalous activity detected) |
| 3 — Config & Conformance | Config rules, compliance packs | Identify (ID.RA-1 Asset risks identified) |
| 4 — Security Hub & GuardDuty | Threat detection + dashboards | Detect (DE.CM-1 Continuous monitoring) |
| 5 — OPA Policy-as-Code | Terraform plan enforcement | Protect (PR.IP-3 Secure dev lifecycle) |
| 6 — Organizations & SCPs | DenyRoot, RestrictRegions SCPs | Respond (RS.MI-1 Mitigation executed) |

---
