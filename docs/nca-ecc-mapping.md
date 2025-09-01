# Saudi Arabia — NCA Essential Cybersecurity Controls (ECC) Mapping

Mapping of Secure AWS Baseline implementation to NCA ECC requirements.

---

## Step 2 — Centralized Logging
- **D1/D2 Logging & compliance monitoring**: CloudTrail and CloudWatch logging enforced with KMS encryption.

## Step 3 — AWS Config
- **CC-06 Compliance checks**: Conformance packs continuously enforce policy compliance.

## Step 4 — GuardDuty, Security Hub
- **D5.5 Threat detection**: GuardDuty detectors enabled across accounts.
- **CC-06**: Security Hub compliance reporting.

## Step 5 — OPA / Policy-as-Code
- **D3.2 Security by design**: Terraform plan evaluation with OPA enforces preventive controls.
- **D5.3 Identity & Access Management**: Permission boundary enforcement.

## Step 6 — Organizations & SCPs
- **D5.2 IAM**: Require MFA toggle, IAM enforcement at org level.
- **D5.5 Threat detection**: SCPs prevent disabling GuardDuty.
- **D1/D2 Logging**: SCPs prevent disabling CloudTrail and Config.
- **CC-06**: SCPs enforce compliance guardrails across all OUs.
