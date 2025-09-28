# Qatar NCSA Cybersecurity Framework Mapping

This document maps the AWS secure multi-account baseline to **Qatar’s National Cyber Security Agency (NCSA) Cybersecurity Framework** domains.

| Step | Implementation Example | NCSA CSF Domain |
|------|-------------------------|------------------|
| 1 — State Backend | S3 backend SSE-KMS | Data Protection |
| 2 — Centralized Logging | CloudTrail all regions, KMS log encryption | Logging & Monitoring |
| 3 — Config & Conformance | Config rules, Conformance packs | Risk Management & Compliance |
| 4 — Security Hub & GuardDuty | Security Hub + GuardDuty org-wide | Threat Detection & Response |
| 5 — OPA Policy-as-Code | CI/CD compliance enforcement | Secure Development Lifecycle |
| 6 — Organizations & SCPs | SCPs to restrict regions/services | Governance & Access Control |

---
