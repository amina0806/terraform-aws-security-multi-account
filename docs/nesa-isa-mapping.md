# UAE — NESA / IAS Compliance Mapping

Mapping of Secure AWS Baseline implementation to UAE NESA IAS requirements.

---

## Step 2 — Centralized Logging
- **Logging & Monitoring**: CloudTrail + CloudWatch with KMS enforced.

## Step 3 — AWS Config
- **Compliance & Audit Governance**: Conformance packs evaluate controls continuously.

## Step 4 — GuardDuty, Security Hub
- **Threat & Vulnerability Management**: GuardDuty anomaly detection.
- **Security Monitoring**: Security Hub findings aggregation.

## Step 5 — OPA / Policy-as-Code
- **Secure Development Lifecycle**: OPA integration into CI/CD pipelines.
- **Automated Compliance**: Enforced technical compliance review via OPA eval and CI.

## Step 6 — Organizations & SCPs
- **Governance**: Org-wide SCPs define mandatory security guardrails.
- **Access Control**: RestrictRegions SCP and DenyRootUser SCP enforce org-wide access rules.
- **Continuous Monitoring**: Prevent disabling of CloudTrail/Config/GuardDuty/Security Hub.
