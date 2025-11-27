# 🚀 Terraform Automation Pipeline

### GitHub Actions CI/CD with OIDC, Security Scanning, Teams Notifications & Manual Team Approval

This repository contains an automated Terraform pipeline powered by **GitHub Actions**, designed for secure, validated, team-approved infrastructure deployments.
It supports **Terraform Plan**, **Apply**, and **Destroy** operations with built-in security checks and manual approval gates.

---

## 📌 Features

### 🔐 **Secure Authentication with AWS OIDC**

* Uses GitHub Actions’ **OpenID Connect (OIDC)** to obtain temporary AWS credentials.
* No static AWS keys required.

### 🛡 **Security & Validation**

The pipeline runs multiple validation and security checks:

* **terraform validate**
* **tfsec** (fails if HIGH severity issues are found)
* **Semgrep** (fails on ERROR severity)
* Optional **Terraform Plan** generation

### 📨 **Microsoft Teams Alerts**

* Sends a Teams message whenever a deployment requires approval.
* Includes repository, action, actor, and environment details.

### 👥 **Team-Based Manual Approval**

* Apply/Destroy actions require environment-level approval through GitHub Environments.
* Ensures critical changes are reviewed before execution.

### ⚙️ **Automated Terraform Execution**

Depending on selected input:

* **plan** → Runs validation + scanning + plan
* **apply** → Requires approval → Uses saved plan → Terraform apply
* **destroy** → Requires approval → Terraform destroy

---

## 📂 Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── cicd.yml   # The CI/CD pipeline
└── Terraform/              # Terraform root module
```

---

## 🧰 Prerequisites

### 1. **GitHub Secrets**

Ensure the following secrets are set as such for all required accounts:

| Secret Name         | Description                              |
| ------------------- | ---------------------------------------- |
| `AWS_ROLE_ARN`      | IAM role for GitHub OIDC federation      |
| `TEAMS_WEBHOOK_URL` | Incoming webhook for Teams notifications |

### 2. **GitHub Environment**

Create an environment named:

```
terraform-approval
```

Enable:

* Required reviewer(s)
* (Optional) Deployment protection rules
* (Optional) Environment secrets

---

## 🚦 Workflow Inputs

Triggered manually via **workflow_dispatch**:

| Input    | Values                 | Description                        |
| -------- | ---------------------- | ---------------------------------- |
| `action` | plan / apply / destroy | Determines the Terraform operation |

Additional inputs can be taken in a similar way for AWS Account Number

Example run:

```
Action: plan
```

---

## 🔄 Pipeline Overview

### **1️⃣ Validation & Security Scanning**

Runs on every action:

* Validates Terraform configuration
* Performs tfsec & Semgrep static analysis
* Generates Terraform plan (for plan/apply)
* Uploads plan as an artifact (for apply)

### **2️⃣ Approval + Execution**

Triggered after successful validation:

* Sends Teams alert for approval
* Waits for GitHub Environment approval
* Runs the final Terraform action:

  * `apply` → uses the saved plan
  * `destroy` → destroys resources

---

## 🏗 How to Use

### **Step 1 — Trigger the Workflow**

Go to:

```
GitHub → Actions → Terraform CI/CD → Run workflow
```

Select the action:

* **plan**
* **apply**
* **destroy**

### **Step 2 — Review Validation Output**

Ensure:

* tfsec scan passes
* Semgrep passes
* Plan output looks correct (for apply)

### **Step 3 — Approve (For Apply/Destroy Only)**

Reviewer approves the run inside:

```
Environment → terraform-approval
```

### **Step 4 — Automatic Deployment**

Terraform is executed according to your selected action.

---

## 🔒 Security Design

* OIDC replaces long-lived AWS credentials.
* tfsec + Semgrep fail the pipeline on serious issues.
* Manual approval prevents accidental infrastructure changes.
* Plans are generated during validation and reused for apply, ensuring consistency.

---

## 📄 Workflow File

The workflow file (`cicd.yml`) is included exactly as implemented in the root message above.


---

## 🙌 Support

If you have feature requests or run into issues, open an issue in the repository or contact the DevOps Team
