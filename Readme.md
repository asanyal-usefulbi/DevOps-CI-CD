Here’s an **updated README** reflecting your **new distributed, team-based approval workflow** and **PR-based Teams notifications**, removing the old manual environment approval steps.

---

# 🚀 Terraform Automation Pipeline

### GitHub Actions CI/CD with OIDC, Security Scanning, and Distributed Team Approvals

This repository contains an automated Terraform pipeline powered by **GitHub Actions**, designed for secure, validated, team-approved infrastructure deployments.
It supports **Terraform Plan**, **Apply**, and **Destroy** operations with built-in security checks and **GitHub-native PR approvals**.

---

## 📌 Features

### 🔐 **Secure Authentication with AWS OIDC**

* Uses GitHub Actions’ **OpenID Connect (OIDC)** to obtain temporary AWS credentials.
* No static AWS keys required.

### 🛡 **Security & Validation**

The pipeline runs multiple validation and security checks on pull requests:

* **terraform validate**
* **tfsec** (fails if HIGH severity issues are found)
* **Semgrep** (fails on ERROR severity)
* **Talisman** (checks for secrets in the repo)
* Terraform Plan generation for preview

### 📨 **Microsoft Teams Alerts**

* Sends a Teams message whenever a **Pull Request is created**.
* Includes repository, PR title, number, author, branch, and link.
* Helps approvers track new infrastructure changes.

### 👥 **Team-Based Approval via GitHub PRs**

* Approvers are members of **GitHub Teams** associated with the repository.
* Approval is enforced using **CODEOWNERS + branch protection rules**.
* Ensures that only authorized teams can merge PRs and trigger Terraform Apply/Destroy.

### ⚙️ **Automated Terraform Execution**

* **plan** → Runs validation + scanning + plan on pull requests.
* **apply** → Runs automatically **after PR is merged** to `main` (requires team approval in GitHub PR).
* **destroy** → Runs automatically **after PR is merged** (requires team approval).

---

## 📂 Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── cicd.yml           # Terraform CI/CD workflow
│       └── pr-teams-notify.yml # PR notification to Teams
├── .github/CODEOWNERS         # Team-based approval rules
└── terraform/                 # Terraform root module
```

---

## 🧰 Prerequisites

### 1. **GitHub Secrets**

Ensure the following secrets are set:

| Secret Name         | Description                              |
| ------------------- | ---------------------------------------- |
| `AWS_ROLE_ARN`      | IAM role for GitHub OIDC federation      |
| `TEAMS_WEBHOOK_URL` | Incoming webhook for Teams notifications |

### 2. **GitHub Teams & CODEOWNERS**

* Create a **GitHub Team** for the repository (e.g., `infra-approvers`).
* Add all authorized approvers to the team.
* Define `.github/CODEOWNERS`:

```
* @my-org/infra-approvers
```

* Enable **branch protection** on `main`:

  * Require pull request reviews
  * Require approval from Code Owners
  * Require status checks (terraform validate, tfsec, semgrep, Talisman)

---

## 🚦 Workflow Triggers

### Pull Request Validation

* Triggered on **pull_request** for:

  * opened
  * reopened
  * ready_for_review

### Post-Merge Deployment

* Triggered on **push** to `main` branch (after PR approval and merge)

---

## 🔄 Pipeline Overview

### **1️⃣ Validation & Security Scanning (Pull Request)**

* Terraform configuration validation
* Security scans: tfsec, Semgrep, Talisman
* Terraform Plan generation
* Sends a **Teams notification** for the PR

### **2️⃣ Terraform Execution (Post-Merge)**

* Automatically triggered **after PR is merged** to `main`

* Runs Terraform action based on PR workflow input:

  * `apply` → Uses plan generated in PR workflow
  * `destroy` → Destroys resources

* Only merges approved by the **repository team** are executed

---

## 🏗 How to Use

### **Step 1 — Open a Pull Request**

* Developers create a PR to `main` with changes.
* A Teams notification is sent automatically.

### **Step 2 — Review Validation Output**

* Ensure Terraform validation passes
* tfsec and Semgrep scans pass
* Plan output looks correct

### **Step 3 — PR Approval by Team**

* Approvers in the GitHub Team review and approve the PR
* Branch protection enforces approval before merge

### **Step 4 — Merge and Automatic Deployment**

* Once merged, Terraform Apply or Destroy runs automatically on the `main` branch

---

## 🔒 Security Design

* OIDC replaces long-lived AWS credentials
* tfsec, Semgrep, and Talisman fail the pipeline on serious issues
* PR-based approvals enforce distributed control per repository
* Plans are generated during PR validation and reused for Apply, ensuring consistency

---

## 📄 Workflow Files

| Workflow File                           | Purpose                                                                                |
| --------------------------------------- | -------------------------------------------------------------------------------------- |
| `.github/workflows/cicd.yml`            | Terraform validation, security scanning, plan generation, and post-merge Apply/Destroy |
| `.github/workflows/pr-teams-notify.yml` | Sends Teams notification on PR creation                                                |
| `.github/CODEOWNERS`                    | Defines team-based PR approval rules                                                   |

---
