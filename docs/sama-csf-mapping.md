# Saudi Arabia — SAMA Cybersecurity Framework (CSF) Mapping

This document demonstrates how the Terraform AWS Secure Multi-Account Baseline aligns with the **Saudi Central Bank (SAMA) Cybersecurity Framework (v1.0)**.
The mapping focuses on key domains and subdomains relevant to cloud security, governance, and compliance.

---

## SAMA CSF Domains
- **Cyber Security Leadership & Governance**
- **Cyber Security Risk Management & Compliance**
- **Cyber Security Operations & Technology**
- **Third-Party Cyber Security**

---

## Step-by-Step Mapping

### Step 1 — State Backend (S3 backend SSE-KMS, DynamoDB lock)
- **SAMA CSF Coverage:**
  - Operations & Technology → *Cryptography*
  - Operations & Technology → *Identity & Access Management*
- **Implementation Evidence:**
  - S3 backend encrypted with SSE-KMS
  - DynamoDB state locking prevents unauthorized writes

---

### Step 2 — Centralized Logging (CloudTrail, CloudWatch, KMS)
- **SAMA CSF Coverage:**
  - Operations & Technology → *Logging & Monitoring*
- **Implementation Evidence:**
  - Multi-region CloudTrail logging with KMS encryption
  - CloudWatch logs aggregated for monitoring

---

### Step 3 — Config & Conformance (AWS Config rules, Conformance packs)
- **SAMA CSF Coverage:**
  - Risk Management & Compliance → *Risk Assessment*
  - Risk Management & Compliance → *Compliance*
- **Implementation Evidence:**
  - AWS Config rules enforce configuration baselines
  - Conformance packs align with security best practices

---

### Step 4 — Security Hub & GuardDuty (Threat detection, dashboards)
- **SAMA CSF Coverage:**
  - Operations & Technology → *Threat & Vulnerability Management*
  - Operations & Technology → *Security Monitoring*
- **Implementation Evidence:**
  - GuardDuty detector with S3 and Malware Protection
  - Security Hub enabled with CIS and AFSBP standards

---

### Step 5 — OPA Policy-as-Code (Terraform plan evaluation, CI/CD enforcement)
- **SAMA CSF Coverage:**
  - Operations & Technology → *Secure Systems & Applications*
  - Operations & Technology → *Identity & Access Management*
- **Implementation Evidence:**
  - OPA/Rego rules prevent insecure Terraform code merges
  - CI/CD workflow blocks non-compliant plans

---

### Step 6 — Organizations & SCPs (DenyLeaveOrg, Protect Security Services, RestrictRegions)
- **SAMA CSF Coverage:**
  - Leadership & Governance → *Information Security Governance*
  - Operations & Technology → *Identity & Access Management*
- **Implementation Evidence:**
  - SCPs prevent disabling security services (CloudTrail, GuardDuty, Config)
  - Restricts regions to approved geographies

---

## Notes
- This mapping highlights **initial coverage** of SAMA CSF domains by the baseline.
- Future work will extend coverage to additional SAMA subdomains such as *Third-Party Cyber Security* and *Incident Management*.
