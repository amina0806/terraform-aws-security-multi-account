# 🌐 Terraform AWS Security Multi-account Project   

---
 **Overview** 
---

**Enterprise AWS Secure Baseline with Terraform**  
Multi-account architecture with **AWS Organizations, SCP guardrails, centralized CloudTrail logging, KMS encryption, and CloudWatch integration**.  

---
📘 **What This Portfolio Demonstrates**
- **Secure IaC foundations**: reliable remote state with encryption and locking
- **Centralized audit logging**: CloudTrail → S3 + CloudWatch with KMS
- **Encryption by default**: CMKs with rotation enabled
- **Compliance readiness**: codified mappings to  
  - Global: **CIS AWS Foundations**, **ISO/IEC 27001 Annex A**  
  - Regional: **Saudi NCA Essential Cybersecurity Controls (ECC)**, **UAE NESA/IAS**  
- **Evidence-based documentation**: console screenshots + Terraform code

---

📑 **ISO/IEC 27001 Annex A Coverage (so far)**

| Step | Controls Implemented |
|------|-----------------------|
| **Step 1** | A.8.20 Use of cryptography (S3 backend with SSE-KMS)<br>A.8.23 Information security in cloud services (remote state segregation)<br>A.8.16 Access control (DynamoDB state locking) |
| **Step 2** | A.12.4 Logging & monitoring (CloudTrail, CloudWatch)<br>A.8.20 Use of cryptography (CMK, SSE-KMS)<br>A.8.24 Data leakage prevention (Block Public Access, TLS-only)<br>A.8.16 Monitoring activities (log file validation, versioned bucket) |

📄 Full mappings:  
- [docs/iso27001-mapping.md](docs/iso27001-mapping.md)  
- [docs/cis-controls-coverage.md](docs/cis-controls-coverage.md)  
- [docs/nca-ecc-mapping.md](docs/nca-ecc-mapping.md)  
- [docs/nesa-mapping.md](docs/nesa-mapping.md)  

---

🖼️ **Architecture Diagram**  
`docs/architecture-diagram.png`  

---

📂 **Project Structure**



---


---
## Step 1 — Remote State Backend

### Screenshots (Step 1)

| Step | Screenshot |
|------|------------|
| ✅ S3 Backend Bucket (SSE-KMS + Versioning) | ![S3 Backend](docs/screenshots/step1/state-s3-backend.png) |
| ✅ DynamoDB Table for State Locking | ![DynamoDB State Lock](docs/screenshots/step1/state-dynamodb.png) |

---

### Security Highlights

- **Centralized remote state** → Terraform state stored in secure S3 bucket.  
- **Integrity & consistency** → DynamoDB table prevents concurrent state changes.  
- **Encrypted at rest** → Backend bucket encrypted with AWS KMS CMK.  
- **Versioning enabled** → Rollback and tamper detection for state files.  
- **Least privilege IAM** → Access to state backend scoped to pipeline role only.  

---

### ISO/IEC 27001 Annex A Mapping

- **A.8.20 Use of cryptography** → State backend encrypted with KMS.  
- **A.12.4 Logging & monitoring** → State versioning supports auditability.  
- **A.5.23 Cloud security** → Enforced remote backend instead of local state.  
- **A.8.16 Identity & access control** → IAM policies restrict access to state bucket/DDB.  

---

### NCA ECC (Essential Cybersecurity Controls) Mapping

- **ECC-1.2 Data Protection at Rest** → S3 backend encryption with KMS.  
- **ECC-1.6 Secure Configuration Management** → Remote state ensures centralized control.  
- **ECC-5.1 Access Control** → Scoped IAM policies on state bucket and DDB.  
- **ECC-6.2 Audit Logging** → Versioning provides history of changes.  

---

## Step 2 — Centralized Logging (CloudTrail → S3)

### Screenshots (Step 2)

| Step | Screenshot |
|------|------------|
| ✅ KMS CMK Created (Rotation Enabled) | ![KMS Key](docs/screenshots/step2/kms-key.png) |
| ✅ Log Bucket Encryption (SSE-KMS) | ![S3 Encryption](docs/screenshots/step2/s3-encryption.png) |
| ✅ S3 Block Public Access ON | ![S3 BPA](docs/screenshots/step2/s3-bpa.png) |
| ✅ Log Bucket Policy (TLS-only + enforce KMS) | ![S3 Policy](docs/screenshots/step2/s3-policy.png) |
| ✅ CloudTrail Settings (Multi-Region, Validation, KMS) | ![CloudTrail Settings](docs/screenshots/step2/cloudtrail-settings.png) |
| ✅ CloudTrail Log Files in S3 (Proof) | ![CloudTrail S3 Objects](docs/screenshots/step2/cloudtrail-s3-objects.png) |


---

### Security Highlights

- **Organization-wide audit trail** → CloudTrail multi-region enabled.  
- **Tamper-proof logging** → Log file validation + SSE-KMS encryption.  
- **Centralized evidence storage** → S3 log bucket with versioning and lifecycle.  
- **Defense in depth** → TLS-only bucket policy and enforced KMS key usage.  
- **Default deny** → Block Public Access prevents accidental exposure.  

---

### ISO/IEC 27001 Annex A Mapping

- **A.12.4 Logging & monitoring** → CloudTrail captures all management events.  
- **A.8.20 Use of cryptography** → Logs encrypted with KMS CMK.  
- **A.8.24 Data leakage prevention** → TLS-only + BPA policies on log bucket.  
- **A.5.23 Cloud security** → Centralized, immutable audit logs.  
- **A.8.16 Identity & access control** → Access scoped by IAM & bucket policies.  

---

### NCA ECC (Essential Cybersecurity Controls) Mapping

- **ECC-1.2 Data Protection at Rest** → CloudTrail logs encrypted with KMS.  
- **ECC-1.3 Data Protection in Transit** → TLS-only bucket policy.  
- **ECC-3.1 Security Logging** → Multi-region CloudTrail with validation.  
- **ECC-3.2 Log Protection** → S3 versioning + lifecycle + KMS key rotation.  
- **ECC-5.1 Access Control** → Bucket policies restrict access to CloudTrail + account root.  

