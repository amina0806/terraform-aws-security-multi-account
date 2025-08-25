
📘 **Overview**  
**Enterprise AWS Secure Baseline with Terraform**  
Multi-account architecture with **AWS Organizations, SCP guardrails, centralized CloudTrail logging, KMS encryption, and CloudWatch integration**.  

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
(Shows: Terraform user → S3+DDB backend → CloudTrail → S3 log bucket (SSE-KMS) + CloudWatch Logs)

---

📂 **Project Structure**



---

### Step 1 — Remote State Backend
- **S3 bucket (SSE-KMS, versioning enabled)** for Terraform state storage
- **DynamoDB table** for state locking and consistency

---

### Step 2 — Centralized Logging
- **CloudTrail (multi-region, global events, log file validation)**
- **S3 log bucket** (versioned, SSE-KMS CMK, Block Public Access, TLS-only policy)
- **CloudWatch Logs group** (KMS-encrypted, retention 365 days)

---
