# 🟣 PHASE 0 — FOUNDATION: Tools, Auth & Environment Setup
## Complete Reference Document | Neonatal → Production Level

> **Mentor's Note**: You know nothing yet. That is your superpower. We build every mental model from the ground up. No jargon without explanation. No command without understanding. By the end of this document, your laptop will be talking to Azure through Terraform Cloud — and you'll understand every wire connecting them.

---

# TABLE OF CONTENTS

| # | Topic | Page Anchor |
|---|-------|-------------|
| 0.1 | What is Cloud? What is Azure? Why not just use a physical server? | [→ Jump](#01) |
| 0.2 | Azure Account, Free Tier Setup, Azure Portal Tour | [→ Jump](#02) |
| 0.3 | Azure CLI — Installation, Login, Basic Commands | [→ Jump](#03) |
| 0.4 | What is Terraform? IaC vs ClickOps vs Scripts | [→ Jump](#04) |
| 0.5 | Terraform Installation & First HCL File | [→ Jump](#05) |
| 0.6 | Git Basics — init, add, commit, push, branches | [→ Jump](#06) |
| 0.7 | GitHub Account, Repo Creation, SSH Key Setup | [→ Jump](#07) |
| 0.8 | Terraform Cloud — Account, Workspaces, VCS Integration | [→ Jump](#08) |
| 0.9 | Service Principal Creation — Azure Auth for Terraform | [→ Jump](#09) |
| 0.10 | OIDC / Workload Identity Federation | [→ Jump](#010) |
| 0.11 | Terraform Cloud Variable Sets | [→ Jump](#011) |
| 0.12 | First terraform init / plan / apply through TFC | [→ Jump](#012) |
| 0.13 | Production-Grade Repo Structure | [→ Jump](#013) |

---

---

# <a name="01"></a>📌 TOPIC 0.1 — What is Cloud? What is Azure? Why not just use a physical server?

## 🧠 Mental Model First (Explain Like I'm 10)

Imagine you need electricity to power your house. You have **two choices**:

**Option A:** Buy your own power generator. You pay for it upfront. You maintain it. You fuel it. If it breaks at 2 AM, you fix it. If your city's population doubles overnight, your generator can't handle it — you need to buy a bigger one.

**Option B:** Plug into the city's power grid (WAPDA/DESCO/LESCO). You pay only for what you use. The grid scales automatically. If it breaks, the electric company fixes it. You never see or touch the generator.

> **Cloud computing is the power grid. Physical servers are the generator.**

---

## 🔍 What Is a Physical Server?

A **physical server** is a real, tangible computer — with a CPU, RAM, hard drives, and network cards — sitting in a rack in a building called a **datacenter** (or server room).

Before cloud existed, every company had to:
1. **Buy** physical servers (costs: $5,000–$50,000 per machine)
2. **Rack** them in a datacenter they owned or leased
3. **Cable** them (network, power, cooling)
4. **Install** an operating system
5. **Maintain** them (patches, hardware failures, overheating)
6. **Guess** future capacity and over-provision (buying 10 servers when you need 3, just in case)
7. **Wait 4–12 weeks** for new hardware to arrive when you needed to scale

This is called **on-premises (on-prem)** infrastructure.

---

## ☁️ What Is Cloud Computing?

**Cloud computing** means renting computing resources — servers, storage, networks, databases — from someone else's datacenter, over the internet, and paying only for what you use.

The 3 key properties of cloud:

| Property | What It Means | Real Example |
|----------|--------------|--------------|
| **On-demand self-service** | You get resources instantly, no human approval needed | Create a VM in 2 minutes via portal |
| **Elasticity/Scalability** | Scale up or down in minutes | Black Friday traffic spikes — auto-add servers |
| **Pay-as-you-go** | Pay per second/minute/hour, not upfront | Shut down a VM at night = zero cost |

---

## 🏢 What Is Microsoft Azure?

**Microsoft Azure** is Microsoft's cloud platform. It is one of the "Big 3" cloud providers:

| Provider | Market Position | Key Strength |
|----------|----------------|--------------|
| **AWS (Amazon Web Services)** | #1 (largest) | Broadest service catalog |
| **Microsoft Azure** | #2 | Enterprise, Windows, Office 365 integration |
| **GCP (Google Cloud Platform)** | #3 | AI/ML, Data Analytics |

Azure is a collection of **200+ services** organized into categories:
- **Compute**: Virtual Machines, Kubernetes, App Service
- **Storage**: Blob Storage, File Storage, Databases
- **Networking**: Virtual Networks, Load Balancers, DNS
- **Identity**: Entra ID (Azure AD), RBAC
- **Security**: Defender for Cloud, Key Vault, Sentinel
- **Monitoring**: Azure Monitor, Log Analytics

All of these run in **Microsoft's global datacenters** — 60+ regions worldwide.

---

## 🌍 Azure Global Infrastructure — Key Concepts

```
GEOGRAPHY
│
├── REGION (e.g., "East US", "UK South", "UAE North")
│   ├── AVAILABILITY ZONE 1 (physically separate datacenter)
│   │   └── Datacenter with power, cooling, network
│   ├── AVAILABILITY ZONE 2
│   └── AVAILABILITY ZONE 3
│
└── REGION PAIR (e.g., East US ↔ West US)
    └── Microsoft replicates data between pairs for DR
```

**Why does this matter to you as an engineer?**
- Deploy resources in the **right region** (close to your users = low latency)
- Use **Availability Zones** for high availability (HA) — if one datacenter burns down, your app still runs
- Use **region pairs** for disaster recovery (DR)

---

## 🆚 Cloud vs Physical Server — Decision Matrix

| Criteria | Physical Server (On-Prem) | Azure Cloud |
|----------|--------------------------|-------------|
| **Upfront Cost** | Very high ($$$) | Zero (pay-as-you-go) |
| **Time to provision** | Weeks/months | Minutes |
| **Scalability** | Manual, slow | Automatic, instant |
| **Maintenance** | Your team | Microsoft's team |
| **Global reach** | Complex, expensive | Built-in (60+ regions) |
| **Security responsibility** | 100% yours | Shared model |
| **Compliance** | You prove it | Azure has certifications |

---

## 🛎️ Cloud Service Models — IaaS, PaaS, SaaS

This is a concept you WILL be asked in interviews and on the AZ-104 exam:

```
FULL CONTROL ◄──────────────────────────────────► LESS CONTROL
             ON-PREM     IaaS          PaaS          SaaS

You manage:
├── Applications       ✅             ✅             ❌
├── Runtime/Runtime    ✅             ✅             ❌
├── Middleware         ✅             ✅             ❌
├── OS                 ✅             ✅             ❌
├── Virtualization     ✅             ❌             ❌
├── Servers            ✅             ❌             ❌
├── Storage            ✅             ❌             ❌
└── Networking         ✅             ❌             ❌
```

| Model | Meaning | Azure Example | AWS Equivalent |
|-------|---------|---------------|----------------|
| **IaaS** (Infrastructure as a Service) | You get raw VMs/Networking/Storage. You manage the OS up. | Azure Virtual Machines | EC2 |
| **PaaS** (Platform as a Service) | You get a managed platform. Deploy your code. | Azure App Service | Elastic Beanstalk |
| **SaaS** (Software as a Service) | You just use the software. No infra management. | Microsoft 365, Salesforce | — |

---

## 🩸 PRODUCTION SCAR #001
> **"The Region Mismatch Disaster"**
>
> A junior engineer deployed all resources in `East US` but the company's compliance policy required data to stay in `UK South` (GDPR). The VMs, databases, and storage were all in the wrong region. Fixing this required a full migration — weeks of work and a $40,000 emergency project.
>
> **Lesson**: **ALWAYS** confirm the Azure region requirement with your compliance/legal team before deploying a single resource. Put it in Terraform variables so it's enforced by code, not by memory.

---

## ✅ Topic 0.1 — Key Takeaways

1. Cloud = renting computing power from someone else's datacenter
2. Azure is Microsoft's cloud platform with 200+ services in 60+ global regions
3. Cloud advantage over physical: speed, scale, cost model, global reach
4. IaaS = you manage OS up | PaaS = you manage code up | SaaS = you just use it
5. Always choose your Azure Region intentionally (latency, compliance, HA)

---

---

# <a name="02"></a>📌 TOPIC 0.2 — Azure Account, Free Tier Setup, Azure Portal Tour

## 🧠 What Is an Azure Account?

An **Azure Account** is your identity relationship with Microsoft. When you sign up, Microsoft creates:
1. **A Microsoft Account** (your login: email + password)
2. **An Azure Tenant** — your organization's private instance of Microsoft Entra ID (Azure AD). Think of it as your company's dedicated identity folder inside Microsoft's systems.
3. **An Azure Subscription** — the billing and resource container tied to your credit card/payment method

```
YOUR EMAIL (Microsoft Account)
    │
    └── AZURE TENANT (your organization's identity space)
            │
            └── AZURE SUBSCRIPTION (billing container)
                    │
                    ├── Resource Group A
                    │       ├── Virtual Machine 1
                    │       └── Storage Account 1
                    │
                    └── Resource Group B
                            └── Database 1
```

---

## 🆓 Azure Free Tier — What Do You Get?

Azure offers a **Free Account** with:

| Offer Type | What You Get | Duration |
|-----------|-------------|----------|
| **$200 Azure Credit** | Spend freely on any service | First 30 days |
| **55+ Always-Free Services** | Limited usage, no expiry | Forever |
| **12-Month Free Services** | Popular services with monthly limits | 12 months |

**Always-Free services relevant to us:**
- Azure Container Registry (Basic - limited)
- Azure DevOps (5 users free)
- Log Analytics (5 GB/month free)

**12-Month Free (key ones):**
- 750 hours/month of B1s Linux VM
- 750 hours/month of B1s Windows VM
- 5 GB Blob Storage
- Azure SQL Database (250 GB)

---

## 🛠️ HANDS-ON PRACTICE 1 — Create Your Azure Free Account

**Steps:**
1. Go to: `https://azure.microsoft.com/en-us/free/`
2. Click **"Start free"**
3. Sign in with a Microsoft account (or create one — use a Gmail or Outlook)
4. Fill in your personal details
5. Enter a credit/debit card (for identity verification — you won't be charged during free tier)
6. Complete phone verification
7. You'll land on the **Azure Portal**: `https://portal.azure.com`

> ⚠️ **IMPORTANT**: Enable **Cost Alerts** immediately after creating your account. Go to **Cost Management + Billing** → **Budgets** → Create a budget of $10 with email alert at 80%. This prevents accidental charges.

---

## 🖥️ Azure Portal Tour — Key Areas to Know

The Azure Portal (`portal.azure.com`) is the web-based graphical interface to manage all Azure resources.

```
AZURE PORTAL LAYOUT
│
├── 🔍 Search Bar (top) — Search any service or resource by name
├── 📋 All Services — Full catalog of 200+ Azure services  
├── 🏠 Home — Your dashboard and recent resources
├── 📊 Dashboard — Customizable widgets
│
├── LEFT SIDEBAR (Navigation)
│   ├── Create a resource (+) — Deploy new resources
│   ├── All resources — List everything you own
│   ├── Resource groups — Logical containers
│   ├── Subscriptions — Your billing units
│   └── Microsoft Entra ID — Identity management
│
└── TOP BAR
    ├── Cloud Shell (>_) — Browser-based terminal (bash/PowerShell)
    ├── Notifications (bell) — Deployment status
    ├── Settings (gear) — Portal preferences
    └── Your Account (profile) — Tenant/Subscription switcher
```

---

## 🔍 Key Portal Navigation — Practice These Now

**Practice 2:** Open Azure Portal and find each of these:

```
ACTION                          WHERE TO GO
──────────────────────────────────────────────────────
Find your Subscription ID  →  Search "Subscriptions" → click your subscription → copy ID
Find your Tenant ID        →  Search "Microsoft Entra ID" → Overview → Tenant ID
Open Cloud Shell           →  Click the ">_" icon in top bar → Choose Bash
See your billing           →  Search "Cost Management + Billing"
Create a Resource Group    →  Search "Resource Groups" → Create
```

**Write down these values — you'll need them throughout the course:**
```
My Subscription ID: ________________________________
My Tenant ID:       ________________________________
My Azure Region:    ________________________________  (e.g., East US, UK South, UAE North)
```

---

## 🩸 PRODUCTION SCAR #002
> **"The Subscription Confusion"**
>
> A consultant was hired to deploy infrastructure for a client. They accidentally deployed everything into their OWN personal Azure subscription instead of the client's subscription. The client's users couldn't access anything, and the consultant was billed $3,000 before the mistake was caught.
>
> **Lesson**: ALWAYS verify which subscription and tenant you are working in before running ANY command. Check `az account show` (which we'll learn next) before every session.

---

## ✅ Topic 0.2 — Key Takeaways

1. Azure Account → creates a Tenant (identity) + Subscription (billing)
2. Free tier gives $200 credit for 30 days + always-free and 12-month free services
3. Set a Cost Budget alert IMMEDIATELY after account creation
4. Know where to find your Subscription ID and Tenant ID — you'll use them constantly
5. Azure Portal is great for learning but NOT for production management (we use Terraform)

---

---

# <a name="03"></a>📌 TOPIC 0.3 — Azure CLI: Installation, Login, Basic Commands

## 🧠 What Is the Azure CLI?

The **Azure CLI** (`az`) is a command-line tool that lets you manage all Azure resources using text commands in a terminal, instead of clicking through the portal.

**Why use CLI over the Portal?**

| Portal (GUI) | Azure CLI |
|-------------|-----------|
| Slow — many clicks | Fast — one command |
| Can't be automated | Fully scriptable |
| Can't be version controlled | Commands can be in scripts (Git) |
| Easy to make mistakes | Reproducible, consistent |
| Can't be used in pipelines | Used in CI/CD pipelines |

> 🧠 **Mental model**: The Portal is the showroom. The CLI is the engine room. Real engineers live in the engine room.

---

## 🛠️ HANDS-ON PRACTICE 3 — Install Azure CLI

### Windows Installation

```powershell
# Method 1: Direct Installer (Recommended for beginners)
# Download from: https://aka.ms/installazurecliwindows
# Run the .msi installer

# Method 2: Via PowerShell (Run as Administrator)
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
Remove-Item .\AzureCLI.msi

# Method 3: Via Winget (Windows Package Manager)
winget install Microsoft.AzureCLI
```

### macOS Installation
```bash
brew update && brew install azure-cli
```

### Linux (Ubuntu/Debian) Installation
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Verify Installation
```bash
az --version
# Expected output: azure-cli 2.x.x  (any version 2.50+ is fine)
```

---

## 🔑 Azure CLI Login Methods

```bash
# Method 1: Interactive Login (opens browser — use this for personal dev)
az login
# → A browser window opens, you sign in with your Azure credentials
# → Returns JSON with your subscription list

# Method 2: Login with specific tenant
az login --tenant "YOUR_TENANT_ID"

# Method 3: Service Principal Login (used in automation/CI/CD)
az login --service-principal \
  --username "APP_ID" \
  --password "CLIENT_SECRET" \
  --tenant "TENANT_ID"

# Method 4: Device Code (for environments without browser)
az login --use-device-code
```

---

## 📋 The 20 Azure CLI Commands You Must Know Cold

### Account & Subscription Management
```bash
# Show current login context (ALWAYS run this first!)
az account show
# Output: subscription name, ID, tenant ID, user

# List all subscriptions you have access to
az account list --output table

# Set active subscription (use when you have multiple)
az account set --subscription "SUBSCRIPTION_NAME_OR_ID"

# Show current subscription details
az account show --query "{Name:name, ID:id, Tenant:tenantId}" --output table
```

### Resource Group Operations
```bash
# List all resource groups
az group list --output table

# Create a resource group
az group create \
  --name "rg-learning-dev-001" \
  --location "eastus" \
  --tags Environment=Dev Project=Learning ManagedBy=Terraform

# Show a specific resource group
az group show --name "rg-learning-dev-001"

# Delete a resource group (CAREFUL — deletes EVERYTHING inside)
az group delete --name "rg-learning-dev-001" --yes --no-wait
```

### Resource Operations
```bash
# List all resources in a resource group
az resource list --resource-group "rg-learning-dev-001" --output table

# List all resources across all resource groups
az resource list --output table

# Show details of a specific resource
az resource show \
  --resource-group "rg-learning-dev-001" \
  --name "myStorageAccount" \
  --resource-type "Microsoft.Storage/storageAccounts"
```

### Identity & Auth
```bash
# Show current signed-in user
az ad signed-in-user show

# List all users in your tenant
az ad user list --output table

# List Service Principals
az ad sp list --display-name "sp-terraform" --output table

# Show current Azure CLI version and installed extensions
az version
az extension list --output table
```

### Output Formats & Querying
```bash
# --output formats: json (default), table, tsv, yaml, jsonc, none
az group list --output table
az group list --output json
az group list --output yaml

# --query: JMESPath expressions to filter output
az account show --query "id" --output tsv          # Just the subscription ID
az account show --query "name" --output tsv         # Just the subscription name
az group list --query "[].{Name:name, Location:location}" --output table
```

---

## 🏋️ HANDS-ON PRACTICE 4 — CLI Workout (Do All of These)

```bash
# 1. Login
az login

# 2. Verify you're in the right subscription
az account show --output table

# 3. Create your first resource group
az group create \
  --name "rg-devops-training-001" \
  --location "eastus" \
  --tags \
    Environment="Dev" \
    CreatedBy="YourName" \
    Project="AZ104Training"

# 4. Verify it was created
az group show --name "rg-devops-training-001"

# 5. List all your resource groups
az group list --output table

# 6. Delete the resource group (we'll recreate it with Terraform)
az group delete --name "rg-devops-training-001" --yes
```

---

## 🩸 PRODUCTION SCAR #003
> **"The Wrong Subscription Delete"**
>
> An engineer ran `az group delete --name "rg-prod-database-001" --yes` thinking they were in the Dev subscription. They were in Production. The database resource group — with no backup policy configured — was permanently deleted. The company lost 3 days of data.
>
> **Lesson**: ALWAYS run `az account show` before ANY destructive command. Write it as a habit — make it muscle memory. Some teams create a shell alias that prints the subscription name in red before every `az` command.

---

## ✅ Topic 0.3 — Key Takeaways

1. Azure CLI = command-line tool to manage Azure resources (faster and automatable vs Portal)
2. Always run `az account show` before any command to confirm you're in the right subscription
3. `az login` for interactive, `az login --service-principal` for automation
4. `--output table` for human reading, `--query` for extracting specific fields
5. Every CLI command you run manually is a candidate to become Terraform code

---

---

# <a name="04"></a>📌 TOPIC 0.4 — What is Terraform? IaC vs ClickOps vs Scripts

## 🧠 The Problem Terraform Solves

Imagine you're a chef. You have 3 ways to teach another chef your recipe:

| Method | How | Problem |
|--------|-----|---------|
| **ClickOps** | "Watch me cook it" — show them in the kitchen | Can't be reproduced perfectly. Can't scale. |
| **Script (bash/PowerShell)** | "Here's the recipe steps written down" | Steps can fail mid-way. No way to undo cleanly. Hard to know current state. |
| **Terraform (IaC)** | "Here's the final dish specification — and the kitchen robot handles the rest" | Declares the desired end state. Terraform figures out HOW to get there. Can undo cleanly. Knows current state. |

---

## 📖 What is Infrastructure as Code (IaC)?

**Infrastructure as Code (IaC)** means writing your infrastructure configuration in code files (text files) that are:
- **Version controlled** (stored in Git — tracked, auditable, reversible)
- **Repeatable** (run the same code = get the same infrastructure, every time)
- **Automated** (no human clicking required)
- **Reviewable** (teammates can review infra changes like code changes)

---

## ⚔️ IaC vs ClickOps vs Scripts — The Complete Comparison

### Method 1: ClickOps (Azure Portal)
```
Engineer opens portal.azure.com
→ Clicks "Create Virtual Machine"
→ Fills in 20 form fields
→ Clicks "Review + Create"
→ Clicks "Create"
→ VM appears in 3 minutes
```

**Problems:**
- Zero documentation (nobody knows WHY settings were chosen)
- Not repeatable (try to create the exact same VM 6 months later — impossible)
- Not auditable (WHO changed WHAT? Portal history is limited)
- Doesn't scale (create 100 VMs = 100x the clicking)
- Prone to human error (wrong dropdown, wrong size, wrong region)

---

### Method 2: Scripts (Azure CLI / PowerShell)
```bash
#!/bin/bash
az vm create \
  --resource-group "rg-prod" \
  --name "vm-webserver-001" \
  --image "UbuntuLTS" \
  --size "Standard_B2s" \
  --admin-username "azureuser" \
  --generate-ssh-keys
```

**Better than ClickOps because:**
- Can be version controlled in Git
- Repeatable
- Automatable

**Still has problems:**
- **Imperative** (tells HOW, not WHAT) — "create this VM" not "I want a VM to exist"
- **No state tracking** — runs again? Creates a SECOND VM. Doesn't know the first exists.
- **Partial failure problem** — script fails at step 5 of 10. Now you have half-infrastructure. What do you re-run?
- **No destroy** — how do you cleanly delete everything the script created?

---

### Method 3: Terraform (IaC — Declarative)
```hcl
# I DECLARE: I want a Virtual Machine to exist with these properties
resource "azurerm_linux_virtual_machine" "webserver" {
  name                = "vm-webserver-001"
  resource_group_name = "rg-prod"
  location            = "East US"
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  # ...
}
```

**How Terraform thinks:**
```
CURRENT STATE (what exists)  →  DESIRED STATE (what you declared)
         │                              │
         └──────── DIFF ───────────────┘
                    │
               Terraform creates a PLAN:
               "I need to: CREATE 1 VM, MODIFY 1 NSG, DELETE 0 resources"
                    │
               You APPROVE the plan
                    │
               Terraform APPLIES it
```

**Why Terraform wins:**
- **Declarative**: You say WHAT you want. Terraform figures out HOW.
- **State-aware**: Knows what already exists. Won't create duplicates.
- **Idempotent**: Run it 100 times = same result. No duplicates, no errors.
- **Plan first**: See exactly what will change BEFORE it changes.
- **Destroy**: `terraform destroy` cleanly removes everything Terraform created.
- **Multi-cloud**: Same tool for Azure, AWS, GCP, Kubernetes.
- **Modular**: Write reusable components (modules) for your organization.

---

## 🧩 How Terraform Works — The Core Architecture

```
YOUR .tf FILES          TERRAFORM CORE          PROVIDER              AZURE API
(HCL Code)                   │                (azurerm)
    │                         │                   │
    ├── main.tf      →  terraform init  →  Downloads provider  →  [Azure]
    ├── variables.tf  │                   plugin (.exe)
    ├── outputs.tf    │
    └── backend.tf    │
                      │
                      ├── terraform plan   →  Reads state file
                      │                   →  Calls Azure API (read-only)
                      │                   →  Computes diff
                      │                   →  Shows you PLAN
                      │
                      └── terraform apply  →  Executes plan
                                          →  Calls Azure API (write)
                                          →  Updates state file
```

---

## 📄 The Terraform State File — The Most Important Concept

The **state file** (`terraform.tfstate`) is a JSON file that Terraform uses to:
1. Remember what resources it has created
2. Map your HCL code to real Azure resources
3. Calculate what needs to change on the next apply

```json
{
  "version": 4,
  "terraform_version": "1.9.0",
  "resources": [
    {
      "type": "azurerm_resource_group",
      "name": "main",
      "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
      "instances": [
        {
          "attributes": {
            "id": "/subscriptions/xxxx/resourceGroups/rg-prod",
            "location": "eastus",
            "name": "rg-prod"
          }
        }
      ]
    }
  ]
}
```

> ⚠️ **THE GOLDEN RULE**: The state file is sacred. NEVER manually edit it. NEVER store it in Git without encryption. ALWAYS store it remotely (Terraform Cloud or Azure Storage). We'll cover this in detail.

---

## 🌐 IaC Alternatives — Where Terraform Fits

| Tool | Who Makes It | Language | Multi-Cloud? | Approach |
|------|-------------|----------|-------------|----------|
| **Terraform** | HashiCorp | HCL | ✅ Yes | Declarative |
| **Bicep** | Microsoft | Bicep | ❌ Azure only | Declarative |
| **ARM Templates** | Microsoft | JSON | ❌ Azure only | Declarative |
| **Pulumi** | Pulumi Corp | Python/JS/Go | ✅ Yes | Imperative + Declarative |
| **Ansible** | Red Hat | YAML | ✅ Yes | Mostly Imperative |
| **CDK for Terraform** | HashiCorp | Python/TypeScript | ✅ Yes | Imperative |

> **Why we use Terraform**: It is the #1 IaC tool in the industry, used by 70%+ of cloud engineering teams globally. AZ-104 doesn't require Terraform knowledge, but every DevOps job does.

---

## 🩸 PRODUCTION SCAR #004
> **"The ClickOps Disaster Recovery"**
>
> A 50-person startup had their entire Azure infrastructure built through ClickOps over 2 years. One day, their Azure subscription was accidentally cancelled (billing issue). Microsoft deleted all resources after 90 days. The team had ZERO documentation of what was deployed. Rebuilding took 4 months and cost $600,000 in consulting fees.
>
> **Lesson**: If it's not in code, it doesn't exist. ClickOps is technical debt that compounds until it destroys you.

---

## ✅ Topic 0.4 — Key Takeaways

1. **ClickOps**: Fast to start, impossible to scale or audit — never use in production
2. **Scripts**: Better but imperative, no state awareness, partial failure problems
3. **Terraform (IaC)**: Declarative, state-aware, idempotent, plan-first — the industry standard
4. **State file**: Terraform's memory — sacred, must be stored remotely, never in Git unencrypted
5. **Declarative** = you define the desired end state, Terraform figures out how to achieve it

---

---

# <a name="05"></a>📌 TOPIC 0.5 — Terraform Installation & First HCL File

## 🛠️ Installing Terraform

### Windows (Recommended: via Chocolatey or direct download)

```powershell
# Method 1: Chocolatey (install Chocolatey first if needed)
choco install terraform

# Method 2: winget
winget install HashiCorp.Terraform

# Method 3: Manual
# 1. Go to: https://developer.hashicorp.com/terraform/downloads
# 2. Download Windows AMD64 zip
# 3. Extract terraform.exe
# 4. Move to C:\Windows\System32\ or add to PATH

# Verify
terraform -version
# Expected: Terraform v1.9.x (or latest)
```

### macOS
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Verify
terraform -version
```

### Linux (Ubuntu/Debian)
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform

# Verify
terraform -version
```

---

## 📝 HCL — HashiCorp Configuration Language

**HCL** is Terraform's language. It is designed to be:
- Human-readable (not JSON or YAML)
- Machine-parseable
- Expressive but not a full programming language

### HCL Syntax — Learn the 4 Primitives

```hcl
# 1. BLOCK — The main building unit. Has a type, labels, and a body.
<BLOCK_TYPE> "<BLOCK_LABEL_1>" "<BLOCK_LABEL_2>" {
  # Body — key = value pairs
  <ARGUMENT_KEY> = <ARGUMENT_VALUE>
}

# 2. STRING — Text value
name = "my-resource-group"

# 3. NUMBER — Numeric value
count = 3

# 4. BOOLEAN — True or False
enabled = true
```

---

## 🏗️ The 5 Essential Terraform File Types

Every Terraform project uses these files:

```
project/
├── main.tf          # Where you define your resources (the WHAT)
├── variables.tf     # Input variables (the PARAMETERS)
├── outputs.tf       # Output values (the RESULTS you want to see)
├── providers.tf     # Configure Terraform providers (Azure, AWS, etc.)
└── terraform.tfvars # Variable values (NOT committed to Git if sensitive)
```

---

## 🔥 HANDS-ON PRACTICE 5 — Write Your First Terraform HCL

Create a new folder and write these files:

```bash
# Create your project directory
mkdir ~/az104-terraform-training
cd ~/az104-terraform-training
mkdir 00-foundation
cd 00-foundation
```

### File 1: `providers.tf`
```hcl
# providers.tf
# This tells Terraform: "We're using Microsoft Azure"
# and which version of the provider to use

terraform {
  # Minimum Terraform version required
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"   # ~> means "3.100.x but not 4.x"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {
    # Empty features block is required by the azurerm provider
    # We'll add specific features as we need them
  }
}
```

### File 2: `variables.tf`
```hcl
# variables.tf
# Define all INPUT variables for this module

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "East US"

  validation {
    condition     = contains(["East US", "West US", "UK South", "UAE North"], var.location)
    error_message = "Location must be one of: East US, West US, UK South, UAE North."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name of the project - used in resource naming"
  type        = string
  default     = "az104training"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
```

### File 3: `main.tf`
```hcl
# main.tf
# This is where we declare our Azure resources

# LOCAL VALUES — computed values derived from variables
locals {
  # Standardized naming convention: {resource-type}-{project}-{environment}-{number}
  resource_group_name = "rg-${var.project_name}-${var.environment}-001"

  # Common tags applied to ALL resources
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  })
}

# RESOURCE — The actual Azure resource we want to create
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}
```

### File 4: `outputs.tf`
```hcl
# outputs.tf
# Values Terraform will display after a successful apply
# These can also be consumed by other Terraform modules

output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "The Azure Resource ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_location" {
  description = "The Azure region of the resource group"
  value       = azurerm_resource_group.main.location
}
```

### File 5: `terraform.tfvars`
```hcl
# terraform.tfvars
# Actual values for your variables
# ⚠️ Add this to .gitignore if it contains secrets

location     = "East US"
environment  = "dev"
project_name = "az104training"

tags = {
  Owner      = "YourName"
  CostCenter = "Training"
  Repo       = "https://github.com/yourusername/az104-terraform"
}
```

---

## 🏃 Running Terraform — The 4 Commands

```bash
# STEP 1: Initialize — Downloads provider plugins
terraform init

# What happens:
# - Creates .terraform/ directory
# - Downloads azurerm provider binary
# - Sets up the backend

# STEP 2: Validate — Check HCL syntax (no API calls)
terraform validate

# STEP 3: Plan — Preview changes (READ-ONLY to Azure)
terraform plan

# What you see:
# + resource will be CREATED (green)
# ~ resource will be MODIFIED (yellow)  
# - resource will be DESTROYED (red)

# STEP 4: Apply — Execute the plan (WRITES to Azure)
terraform apply

# Type "yes" when prompted, OR:
terraform apply -auto-approve   # Skip the confirmation (use carefully!)

# DESTROY — Remove everything Terraform created
terraform destroy
```

---

## 🩸 PRODUCTION SCAR #005
> **"The Auto-Approve Disaster"**
>
> A senior engineer was testing a script. It ran `terraform apply -auto-approve`. The script had a bug — it was pointing at the production workspace. Without the confirmation prompt, 47 resources were deleted in 90 seconds, including a production database with no recent backup.
>
> **Lesson**: NEVER use `-auto-approve` in production pipelines. Always require an explicit approval step. In CI/CD, use a manual gate between `plan` and `apply`. The 5-second confirmation prompt has saved companies millions of dollars.

---

## ✅ Topic 0.5 — Key Takeaways

1. Terraform uses HCL — human-readable, declarative configuration language
2. 5 key files: `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`, `terraform.tfvars`
3. Always use `validation` blocks on variables — don't accept garbage input
4. Use `locals` for computed/derived values (naming conventions, merged tags)
5. Flow: `init` → `validate` → `plan` → `apply` — NEVER skip `plan`

---

---

# <a name="06"></a>📌 TOPIC 0.6 — Git Basics: init, add, commit, push, branches

## 🧠 What Is Git?

**Git** is a version control system. It tracks changes to your code files over time — like a sophisticated "track changes" in Microsoft Word, but for entire codebases.

**Mental model**: Git is like a time machine for your code folder. Every time you "commit," you create a snapshot. You can go back to ANY snapshot. You can create parallel universes (branches). You can merge those universes back together.

**Why DevOps engineers use Git:**
- All Terraform code lives in Git
- CI/CD pipelines trigger on Git events (push, pull request)
- Code review happens in Git (Pull Requests)
- Audit trail — who changed what, when, and why
- Rollback capability — revert bad changes in seconds

---

## 📖 Git Core Concepts — The Glossary

| Term | Simple Explanation |
|------|-------------------|
| **Repository (repo)** | A folder tracked by Git — contains your code + full history |
| **Working Directory** | The actual files on your computer that you're editing |
| **Staging Area (Index)** | A "ready to commit" holding area — you pick which changes to include |
| **Commit** | A saved snapshot of staged changes, with a message explaining what changed |
| **Branch** | A parallel version of the code — you can work without affecting the main code |
| **Remote** | A copy of the repo on a server (GitHub, Azure DevOps, GitLab) |
| **Push** | Send your local commits to the remote repo |
| **Pull** | Get commits from the remote repo to your local machine |
| **Clone** | Download a complete copy of a remote repo to your machine |
| **Merge** | Combine changes from one branch into another |
| **Pull Request (PR)** | A formal request to merge your branch — triggers code review |

---

## 🛠️ Installing Git

```bash
# Windows
winget install Git.Git
# OR: Download from https://git-scm.com/download/win

# macOS
brew install git

# Linux
sudo apt install git

# Verify
git --version
# Expected: git version 2.x.x
```

---

## ⚙️ Git Initial Configuration (Do This Once)

```bash
# Set your identity — this info appears in every commit you make
git config --global user.name "Your Full Name"
git config --global user.email "your.email@example.com"

# Set default branch name to 'main' (modern standard)
git config --global init.defaultBranch main

# Set VS Code as default editor
git config --global core.editor "code --wait"

# Enable color output
git config --global color.ui auto

# Verify your config
git config --list
```

---

## 🏋️ HANDS-ON PRACTICE 6 — Git Muscle Memory Training

```bash
# ─────────────────────────────────────────────
# SCENARIO: Initialize a Git repo for our Terraform project
# ─────────────────────────────────────────────

# 1. Navigate to your project folder (from Topic 0.5)
cd ~/az104-terraform-training

# 2. Initialize Git
git init
# Output: Initialized empty Git repository in .../az104-terraform-training/.git/

# 3. Check status — see what Git sees
git status
# Output: Shows all untracked files (red)

# 4. Create a .gitignore — CRITICAL for Terraform
cat > .gitignore << 'EOF'
# Terraform state files — NEVER commit these
*.tfstate
*.tfstate.backup
*.tfstate.*.backup

# Terraform cache and plugin directories
.terraform/
.terraform.lock.hcl    # Debated — some teams commit this, we'll discuss

# Variable files that may contain secrets
*.tfvars
*.tfvars.json

# Override files (local overrides)
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Crash log files
crash.log
crash.*.log

# OS files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp

# Environment files
.env
.env.*
EOF

# 5. Check status again
git status
# Now .gitignore is untracked (good), .terraform/ is ignored (good)

# 6. Stage ALL files
git add .
# OR stage specific file: git add main.tf

# 7. Check status again — files are now green (staged)
git status

# 8. Make your first commit
git commit -m "feat: initial terraform foundation for az104 training

- Add providers.tf with azurerm provider v3.100
- Add variables.tf with location, environment, project_name
- Add main.tf with resource group resource
- Add outputs.tf with rg name, id, location
- Add .gitignore for terraform files"

# 9. View commit history
git log --oneline
# Output: abc1234 feat: initial terraform foundation for az104 training
```

---

## 🌿 Git Branching Strategy — The DevOps Way

In production, you NEVER commit directly to the `main` branch. You use a branching strategy:

```
GITFLOW (simplified version for our purposes):

main        ────●────────────────────●────  (production-ready code only)
                 \                  /
feature/xxx   ────●──●──●──●──●────  (your work in progress)
```

**Standard branch naming conventions:**
```
feature/add-networking-module      # New feature
fix/nsg-rule-priority-bug          # Bug fix
chore/update-provider-version      # Maintenance
docs/add-readme                    # Documentation
```

```bash
# Create a new branch and switch to it
git checkout -b feature/add-vnet-module

# Check which branch you're on
git branch
# * feature/add-vnet-module   (asterisk = current)
#   main

# Make changes, add, commit
git add .
git commit -m "feat: add VNet module scaffold"

# Switch back to main
git checkout main

# Merge your feature branch into main
git merge feature/add-vnet-module

# Delete the feature branch (clean up)
git branch -d feature/add-vnet-module
```

---

## 🩸 PRODUCTION SCAR #006
> **"The Direct Push to Main"**
>
> A developer pushed broken Terraform code directly to the `main` branch at 4 PM on a Friday. The CI/CD pipeline auto-applied it (no manual gate). 15 production NSG rules were deleted, cutting off database connectivity for 50,000 users. The incident lasted 3 hours.
>
> **Lesson**: ALWAYS protect the `main` branch. Require Pull Requests. Require at least 1 reviewer. Require CI checks to pass before merging. This is non-negotiable in production. We'll configure this in GitHub in Topic 0.7.

---

## ✅ Topic 0.6 — Key Takeaways

1. Git = version control for code — every change is tracked, auditable, reversible
2. Core flow: `git add` (stage) → `git commit` (snapshot) → `git push` (share)
3. `.gitignore` is critical — `*.tfstate`, `.terraform/`, and `*.tfvars` must ALWAYS be ignored
4. Never commit directly to `main` — use feature branches and Pull Requests
5. Commit messages are documentation — write them clearly (use conventional commits format)

---

---

# <a name="07"></a>📌 TOPIC 0.7 — GitHub Account, Repo Creation, SSH Key Setup

## 🧠 What Is GitHub?

**GitHub** is a web-based platform that hosts Git repositories remotely. It adds:
- A web UI to view code, history, and branches
- **Pull Requests** — the core collaboration mechanism
- **GitHub Actions** — built-in CI/CD pipelines
- **Issues & Projects** — task tracking
- **Branch Protection Rules** — prevent direct pushes to main
- **Secrets** — encrypted storage for credentials used in pipelines

**GitHub ≠ Git.** Git is the version control tool. GitHub is a hosting platform for Git repos.

Alternatives: Azure DevOps Repos, GitLab, Bitbucket. We use GitHub because GitHub Actions integrates cleanly with Terraform Cloud.

---

## 🛠️ HANDS-ON PRACTICE 7A — Create GitHub Account & Repository

### Step 1: Create GitHub Account
1. Go to `https://github.com`
2. Click **Sign up**
3. Use a professional username (e.g., `firstname-lastname-devops` or `fnamelname`)
4. Enable 2FA immediately after creating your account

### Step 2: Create Your Repository
1. Click the **+** icon → **New repository**
2. Fill in:
   - **Repository name**: `az104-devops-training`
   - **Description**: `AZ-104 + Terraform IaC training repository`
   - **Visibility**: `Private` (keep your learning work private)
   - ✅ **Add a README file**
   - **Add .gitignore**: Select **Terraform** from the dropdown
   - **License**: MIT (optional)
3. Click **Create repository**

### Step 3: Configure Branch Protection
1. Go to your repo → **Settings** → **Branches**
2. Under **Branch protection rules** → **Add rule**
3. Branch name pattern: `main`
4. Enable:
   - ✅ **Require a pull request before merging**
   - ✅ **Require approvals**: 1 (you'll be reviewing your own PRs for now)
   - ✅ **Require status checks to pass before merging** (add Terraform plan check later)
   - ✅ **Do not allow bypassing the above settings**
5. Click **Create**

---

## 🔑 SSH Key Setup — The Right Way to Authenticate

**Why SSH keys instead of username/password?**

| Username/Password | SSH Key |
|------------------|---------|
| One secret to leak | Private key never leaves your machine |
| Must type it every time | Automatic authentication |
| Can be phished | Cannot be phished (no secret transmitted) |
| GitHub deprecated this for Git operations | Industry standard |

SSH keys work like a lock-and-key system:
- **Private key**: Lives ONLY on your machine. Never share this.
- **Public key**: You give this to GitHub. It's safe to share.
- When you push, GitHub validates: "Does their private key match this stored public key?"

---

## 🛠️ HANDS-ON PRACTICE 7B — Generate SSH Key & Add to GitHub

```bash
# STEP 1: Check if you already have SSH keys
ls -la ~/.ssh/
# If you see id_ed25519 and id_ed25519.pub, you already have keys
# If not, generate them:

# STEP 2: Generate a new SSH key (ed25519 is more secure than RSA)
ssh-keygen -t ed25519 -C "your.email@example.com" -f ~/.ssh/id_ed25519_github

# When prompted:
# Enter passphrase: (enter a strong passphrase — this encrypts your private key)
# Confirm passphrase: (repeat it)

# STEP 3: Start the SSH agent and add your key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_github

# STEP 4: Copy your PUBLIC key (this is safe to share)
cat ~/.ssh/id_ed25519_github.pub
# Output: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your.email@example.com

# STEP 5: Add to GitHub
# 1. Go to GitHub → Profile picture → Settings
# 2. Click "SSH and GPG keys" in left sidebar
# 3. Click "New SSH key"
# 4. Title: "My Laptop - DevOps Training"
# 5. Key type: Authentication Key
# 6. Paste the PUBLIC key (from step 4)
# 7. Click "Add SSH key"

# STEP 6: Test the connection
ssh -T git@github.com
# Expected: Hi yourusername! You've successfully authenticated...
```

---

## 🔗 Connect Local Repo to GitHub

```bash
# Navigate to your local Terraform project
cd ~/az104-terraform-training

# Add GitHub as the remote (use SSH URL, not HTTPS)
git remote add origin git@github.com:YOUR_USERNAME/az104-devops-training.git

# Verify the remote was added
git remote -v
# Output:
# origin  git@github.com:YOUR_USERNAME/az104-devops-training.git (fetch)
# origin  git@github.com:YOUR_USERNAME/az104-devops-training.git (push)

# Push your local main branch to GitHub
git push -u origin main
# -u sets the upstream tracking, so future "git push" works without arguments

# Verify: Go to https://github.com/YOUR_USERNAME/az104-devops-training
# You should see your files!
```

---

## 🏗️ Professional GitHub Repository Structure

Your repo should look like this after this phase:

```
az104-devops-training/
├── README.md                    # Project description, setup guide
├── .gitignore                   # Terraform and OS ignores
├── .github/
│   ├── workflows/               # GitHub Actions pipelines (Phase 5)
│   │   └── terraform-plan.yml
│   └── PULL_REQUEST_TEMPLATE.md # PR template
├── modules/                     # Reusable Terraform modules
│   └── README.md
├── environments/                # Environment-specific configs
│   ├── dev/
│   ├── staging/
│   └── prod/
└── 00-foundation/               # Current phase work
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── providers.tf
```

---

## 🩸 PRODUCTION SCAR #007
> **"The Public Repo Secret Leak"**
>
> A developer accidentally created their learning repository as **Public** instead of Private. They had committed their `terraform.tfvars` containing real Azure credentials (CLIENT_SECRET, SUBSCRIPTION_ID). GitHub's secret scanning bots and malicious crawlers found the file within 11 minutes. The credentials were used to spin up 47 Bitcoin mining VMs in Azure. The company's Azure bill jumped by $14,000 overnight.
>
> **Lesson**: 1) ALWAYS make repos private for work containing real credentials. 2) ALWAYS add `*.tfvars` to `.gitignore`. 3) Enable GitHub's "Secret scanning" on all repos. 4) Rotate credentials immediately if you suspect they were exposed. 5) Use OIDC (Topic 0.10) to eliminate static secrets entirely.

---

## ✅ Topic 0.7 — Key Takeaways

1. GitHub = remote hosting for Git repos + collaboration tools + CI/CD (GitHub Actions)
2. ALWAYS use SSH keys, not username/password for Git authentication
3. Protect the `main` branch — require PRs, require reviews, never direct push
4. Keep repos private unless you intend them to be public — secrets leak in seconds
5. Your GitHub repo is now the single source of truth for all your infrastructure

---

---

# <a name="08"></a>📌 TOPIC 0.8 — Terraform Cloud: Account, Workspaces, VCS Integration

## 🧠 What Is Terraform Cloud (TFC)?

**Terraform Cloud** is HashiCorp's managed service that runs Terraform for you — in the cloud, not on your laptop.

**Why use Terraform Cloud instead of running Terraform locally?**

| Local Terraform | Terraform Cloud |
|----------------|----------------|
| State file on YOUR laptop (lost if laptop dies) | State stored securely in TFC (encrypted, versioned) |
| Only you can run plans/applies | Team can collaborate, see runs, approve applies |
| No audit trail | Complete run history — who applied what, when |
| Credentials on YOUR machine | Credentials encrypted in TFC (zero on your machine) |
| No plan approval workflow | Build-in approval gates before apply |
| No policy enforcement | Sentinel/OPA policy as code |
| Free | Free tier: 500 apply hours/month |

---

## 🏗️ Terraform Cloud Architecture

```
Your Laptop                    GitHub                    Terraform Cloud
     │                            │                            │
     │  git push ──────────────►  │                            │
     │                            │  webhook ────────────────► │
     │                            │                            │  1. Pull code
     │                            │                            │  2. Run terraform plan
     │                            │                            │  3. Wait for approval
     │                            │                            │  4. Run terraform apply
     │                            │                            │
     │                            │            Azure API calls │
     │                            │                            │──────────────► [AZURE]
     │                            │                            │  (creates resources)
```

---

## 🛠️ HANDS-ON PRACTICE 8 — Set Up Terraform Cloud

### Step 1: Create TFC Account
1. Go to `https://app.terraform.io`
2. Click **Create a free account**
3. Enter username, email, password
4. Verify your email
5. Create or join an **Organization** (name it: `your-name-devops-training`)

### Step 2: Create a Workspace
1. In TFC → Click **New** → **Workspace**
2. Choose workflow: **Version Control Workflow** (connects to GitHub)
3. Connect to **GitHub** (authorize TFC to access your GitHub account)
4. Select your repo: `az104-devops-training`
5. Workspace settings:
   - **Name**: `az104-training-dev`
   - **Terraform Working Directory**: `00-foundation` (where your .tf files are)
   - **Auto Apply**: OFF (we want manual approval for learning)
6. Click **Create workspace**

### Step 3: Workspace Settings to Know

```
WORKSPACE SETTINGS MENU:
│
├── General
│   ├── Execution Mode: Remote (TFC runs Terraform)
│   ├── Auto Apply: OFF for learning, consider ON for dev, never for prod
│   └── Terraform Version: Set to latest (1.9.x)
│
├── Variables
│   ├── Terraform Variables: Input values for your .tf variables
│   └── Environment Variables: ARM_CLIENT_ID, ARM_TENANT_ID, etc.
│
├── Notifications
│   └── Configure Slack/email alerts on run completion
│
├── Run Triggers
│   └── Trigger this workspace when another workspace completes
│
└── State
    └── View current state, download state files, view history
```

---

## 🔄 How VCS Integration Works

When TFC is connected to your GitHub repo:

```
1. You push code to GitHub
        ↓
2. GitHub sends a webhook to TFC: "Hey, branch X was updated"
        ↓
3. TFC pulls the latest code from GitHub
        ↓
4. TFC runs "terraform plan" in its own managed runner
        ↓
5. Plan result appears in TFC UI and GitHub PR (as a status check)
        ↓
6. You review and CONFIRM the apply in TFC
        ↓
7. TFC runs "terraform apply" → resources created in Azure
```

---

## 🩸 PRODUCTION SCAR #008
> **"The Workspace Variable Leak"**
>
> A team stored production ARM_CLIENT_SECRET as a plain-text Terraform variable (not environment variable, not marked sensitive). The variable appeared in run logs that were shared with contractors. The secret had to be rotated immediately, causing a 2-hour production window.
>
> **Lesson**: ALWAYS mark sensitive variables with the **Sensitive** toggle in TFC. Sensitive variables are never shown in logs or the UI after they're set. Always use Environment Variables (not Terraform Variables) for credentials. We configure this in Topic 0.11.

---

## ✅ Topic 0.8 — Key Takeaways

1. TFC = managed platform that runs Terraform remotely with state management, approvals, and audit trails
2. VCS Integration = TFC watches your GitHub repo and triggers plans on push
3. State is stored securely in TFC — never on your laptop, never in Git
4. Always require manual confirmation for `apply` — never auto-apply to prod
5. Use TFC workspaces to separate environments (dev workspace, staging workspace, prod workspace)

---

---

# <a name="09"></a>📌 TOPIC 0.9 — Service Principal Creation: Azure Auth for Terraform

## 🧠 What Is a Service Principal?

When a **human** logs into Azure, they use their email + password + MFA.

When a **machine** (Terraform, GitHub Actions, a script) needs to access Azure, it can't use human credentials. Instead, it uses a **Service Principal (SP)**.

A Service Principal is:
- An **application identity** in Azure Entra ID (not a human identity)
- It has its own `Client ID` (like a username)
- It authenticates with either a `Client Secret` (like a password) or a `Certificate`
- It can be assigned Azure RBAC roles — scoped to exactly what it needs

**Mental model**: A Service Principal is like a **staff badge** issued to an automated system. The badge has a name, a PIN code, and access to only specific areas of the building.

---

## 🏗️ Service Principal — Three Components

```
SERVICE PRINCIPAL
│
├── App Registration (in Entra ID)
│   └── This is the "identity application"
│   └── Has a Client ID (App ID) — like a username
│
├── Service Principal Object
│   └── The actual entity that can be assigned roles
│   └── Created automatically when you create an App Registration
│
└── Credential
    ├── Option A: Client Secret (password) — expires, must rotate
    └── Option B: Certificate — more secure, longer lived
    └── Option C: OIDC Token — NO static credential (Topic 0.10)
```

---

## 🛠️ HANDS-ON PRACTICE 9 — Create Service Principal

### Method 1: Azure CLI (Fastest)

```bash
# First, always verify you're in the right subscription!
az account show --output table

# Get your subscription ID
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
echo "Subscription ID: $SUBSCRIPTION_ID"

# Create the Service Principal
# Naming convention: sp-{purpose}-{environment}-{number}
az ad sp create-for-rbac \
  --name "sp-terraform-training-dev-001" \
  --role "Contributor" \
  --scopes "/subscriptions/$SUBSCRIPTION_ID" \
  --output json

# ████████████████████████████████████████████████████████
# SAVE THIS OUTPUT IMMEDIATELY — SECRET SHOWN ONLY ONCE!
# ████████████████████████████████████████████████████████

# Output:
# {
#   "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",   ← ARM_CLIENT_ID
#   "displayName": "sp-terraform-training-dev-001",
#   "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",   ← ARM_CLIENT_SECRET  
#   "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"   ← ARM_TENANT_ID
# }
```

### Method 2: Terraform HCL (IaC-first approach — use after bootstrap)

```hcl
# This creates the Service Principal via Terraform (chicken-and-egg problem:
# you need auth to run Terraform, but you need Terraform to create auth)
# Solution: create the FIRST SP manually, then manage subsequent ones via Terraform

# Add to providers.tf for identity management
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
    }
  }
}

provider "azuread" {}

# Create an Azure AD Application
resource "azuread_application" "terraform_sp" {
  display_name = "sp-terraform-${var.environment}-001"
}

# Create a Service Principal from the application
resource "azuread_service_principal" "terraform_sp" {
  client_id = azuread_application.terraform_sp.client_id
}

# Create a Client Secret (password) for the Service Principal
resource "azuread_service_principal_password" "terraform_sp" {
  service_principal_id = azuread_service_principal.terraform_sp.object_id

  # Secret expires in 1 year — force rotation
  end_date_relative = "8760h"  # 8760 hours = 1 year
}

# Assign Contributor role at subscription scope
resource "azurerm_role_assignment" "terraform_sp_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.terraform_sp.object_id
}
```

---

## 📋 Four Values You Must Record

After creating your SP, you need these 4 values for Terraform Cloud:

```
ARM_CLIENT_ID       = appId from az ad sp create-for-rbac output
ARM_CLIENT_SECRET   = password from az ad sp create-for-rbac output
ARM_TENANT_ID       = tenant from az ad sp create-for-rbac output
ARM_SUBSCRIPTION_ID = your Azure subscription ID
```

Store these securely in a **password manager** (1Password, Bitwarden, LastPass). NOT in a file. NOT in a chat message. NOT in an email.

---

## 🔒 RBAC Scoping — Least Privilege Principle

**Contributor at subscription level is too broad for production.** Here's why:

```
SUBSCRIPTION LEVEL (/subscriptions/xxx)
│   └── Contributor = can create/modify/delete ANYTHING except RBAC assignments
│
RESOURCE GROUP LEVEL (/subscriptions/xxx/resourceGroups/rg-dev)
│   └── Contributor = can only touch resources IN that resource group
│
RESOURCE LEVEL (/subscriptions/xxx/resourceGroups/rg-dev/providers/...)
    └── Contributor = can only touch that ONE resource
```

**For training**: Subscription-level Contributor is OK.
**For production**: Create resource groups first, then assign Contributor at RG level — or create a custom role.

---

## 🩸 PRODUCTION SCAR #009
> **"The Shared Service Principal"**
>
> A company used ONE Service Principal for ALL environments — Dev, Staging, and Prod — all with Contributor at subscription level. A developer's script had a bug and accidentally deleted a production resource group using the shared SP credentials. Since it was shared, there was no way to tell in the audit log WHICH system/person triggered it.
>
> **Rule**: One Service Principal per environment. One Service Principal per pipeline/system. Never share credentials between environments. Naming: `sp-terraform-dev-001`, `sp-terraform-staging-001`, `sp-terraform-prod-001`.

---

## ✅ Topic 0.9 — Key Takeaways

1. Service Principal = non-human identity for automated systems to authenticate to Azure
2. Has 3 components: App Registration (identity) + Service Principal Object + Credential
3. Credential types: Client Secret (password, expires), Certificate, or OIDC (no static secret — best)
4. Save the 4 values immediately: CLIENT_ID, CLIENT_SECRET, TENANT_ID, SUBSCRIPTION_ID
5. Apply least privilege — scope to the minimum required resource level

---

---

# <a name="010"></a>📌 TOPIC 0.10 — OIDC / Workload Identity Federation (Zero Static Secrets)

## 🧠 The Problem with Client Secrets

Every SP Client Secret has these problems:
1. **It expires** — usually 1 or 2 years. When it expires at 3 AM on a Sunday, your pipeline breaks.
2. **It must be stored somewhere** — TFC variables, GitHub secrets, Azure Key Vault. More places = more attack surface.
3. **It can be leaked** — logs, screenshots, chat messages, emails.
4. **Rotation is painful** — update the secret in every system that uses it.

> **What if Terraform Cloud could prove its identity to Azure WITHOUT any secret?**

That's exactly what **OIDC (OpenID Connect) / Workload Identity Federation** enables.

---

## 🔐 How OIDC Works — The Mental Model

Think of it like an airport:

**Without OIDC (Client Secret method):**
```
Terraform Cloud says: "I am sp-terraform-dev-001"
Azure asks: "Prove it"
TFC shows: "Here's my password: abc123xyz"
Azure verifies the password and grants access
```
Problem: The password can be stolen.

**With OIDC:**
```
Terraform Cloud says: "I am sp-terraform-dev-001"
Azure asks: "Prove it"
TFC shows: "Here's a short-lived token, signed by HashiCorp's identity provider"
Azure calls HashiCorp's server: "Did you issue this token?"
HashiCorp: "Yes, for Terraform Cloud, workspace az104-training-dev, at 14:32 UTC"
Azure verifies: "Token matches, workspace matches, timestamp is <5 minutes old — GRANTED"
```

No static password ever transmitted. The token is valid for only a few minutes.

---

## 🏗️ OIDC Architecture

```
TERRAFORM CLOUD                              AZURE ENTRA ID
     │                                            │
     │  1. Request JWT token from                 │
     │     TFC's OIDC endpoint                    │
     │     (https://app.terraform.io)             │
     ↓                                            │
 [JWT Token]                                      │
 - Issuer: https://app.terraform.io               │
 - Subject: org:myorg:workspace:dev               │
 - Audience: api://AzureADTokenExchange           │
 - Expiry: 5 minutes                              │
     │                                            │
     │  2. Exchange JWT for Azure access token ──►│
     │     via Azure's STS endpoint               │
     │                                            │
     │  3. Azure validates JWT with TFC's ◄───────│
     │     OIDC public keys                       │
     │                                            │
     │  4. Azure issues access token ◄────────────│
     │                                            │
     │  5. Use access token to call Azure API ────►[Azure Resources]
```

---

## 🛠️ HANDS-ON PRACTICE 10 — Configure OIDC

### Step 1: Create App Registration & Federated Credential

```bash
# Step 1: Create the App Registration
az ad app create --display-name "sp-tfc-oidc-dev-001"

# Get the App ID
APP_ID=$(az ad app list --display-name "sp-tfc-oidc-dev-001" --query "[0].appId" --output tsv)
echo "App ID: $APP_ID"

# Step 2: Create Service Principal from the App
az ad sp create --id $APP_ID

# Get the Service Principal Object ID
SP_OBJECT_ID=$(az ad sp show --id $APP_ID --query id --output tsv)
echo "SP Object ID: $SP_OBJECT_ID"

# Step 3: Add Federated Credential
# This tells Azure: "Trust tokens from TFC, specifically for workspace az104-training-dev"
az ad app federated-credential create \
  --id $APP_ID \
  --parameters '{
    "name": "tfc-az104-training-dev",
    "issuer": "https://app.terraform.io",
    "subject": "organization:YOUR_TFC_ORG_NAME:project:Default Project:workspace:az104-training-dev:run_phase:apply",
    "description": "OIDC for Terraform Cloud workspace az104-training-dev apply runs",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Also add for plan runs (different subject)
az ad app federated-credential create \
  --id $APP_ID \
  --parameters '{
    "name": "tfc-az104-training-dev-plan",
    "issuer": "https://app.terraform.io",
    "subject": "organization:YOUR_TFC_ORG_NAME:project:Default Project:workspace:az104-training-dev:run_phase:plan",
    "description": "OIDC for Terraform Cloud workspace az104-training-dev plan runs",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Step 4: Assign RBAC Role to the Service Principal
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
az role assignment create \
  --assignee-object-id $SP_OBJECT_ID \
  --assignee-principal-type ServicePrincipal \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"
```

### Step 2: Terraform HCL Version (IaC-First)

```hcl
# oidc_setup/main.tf
# Run this with your INITIAL Service Principal (Client Secret method)
# to bootstrap the OIDC configuration

locals {
  tfc_organization = "your-tfc-org-name"
  tfc_workspace    = "az104-training-dev"
  tfc_hostname     = "app.terraform.io"
}

# Create the App Registration
resource "azuread_application" "tfc_oidc" {
  display_name = "sp-tfc-oidc-${var.environment}-001"
}

# Create the Service Principal
resource "azuread_service_principal" "tfc_oidc" {
  client_id = azuread_application.tfc_oidc.client_id
}

# Create Federated Credential for PLAN runs
resource "azuread_application_federated_identity_credential" "tfc_plan" {
  application_id = azuread_application.tfc_oidc.id
  display_name   = "tfc-${local.tfc_workspace}-plan"
  description    = "OIDC for TFC workspace ${local.tfc_workspace} plan runs"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://${local.tfc_hostname}"
  subject        = "organization:${local.tfc_organization}:project:Default Project:workspace:${local.tfc_workspace}:run_phase:plan"
}

# Create Federated Credential for APPLY runs
resource "azuread_application_federated_identity_credential" "tfc_apply" {
  application_id = azuread_application.tfc_oidc.id
  display_name   = "tfc-${local.tfc_workspace}-apply"
  description    = "OIDC for TFC workspace ${local.tfc_workspace} apply runs"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://${local.tfc_hostname}"
  subject        = "organization:${local.tfc_organization}:project:Default Project:workspace:${local.tfc_workspace}:run_phase:apply"
}

# Assign Contributor role
resource "azurerm_role_assignment" "tfc_oidc_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.tfc_oidc.object_id
}
```

---

## 📋 OIDC vs Client Secret — Comparison

| | Client Secret | OIDC |
|---|---|---|
| **Static credential stored?** | ✅ Yes (ARM_CLIENT_SECRET in TFC) | ❌ No |
| **Can be leaked?** | ✅ Yes | ❌ No |
| **Expires?** | ✅ Yes (must rotate) | N/A — tokens are 5-min lived |
| **Setup complexity** | Simple | Moderate |
| **Production recommendation** | ⚠️ Acceptable for learning | ✅ Required for production |

---

## 🩸 PRODUCTION SCAR #010
> **"The Expired Secret Outage"**
>
> A company set their Terraform Cloud Service Principal client secret to expire in 1 year. They forgot about it. Exactly 1 year later, ALL Terraform Cloud workspaces started failing with "Authentication failed." Every pipeline was broken. 14 different workspaces used that same SP. Rotating the secret and updating 14 different workspace variables took 6 hours of emergency work.
>
> **Lesson**: If you use Client Secrets, set calendar reminders 60 days before expiry. Better: adopt OIDC and eliminate the problem entirely. This is a key interview talking point — mention you prefer OIDC over client secrets in every interview.

---

## ✅ Topic 0.10 — Key Takeaways

1. OIDC = short-lived token exchange — NO static secret stored anywhere
2. Azure trusts TFC's identity provider — validates tokens directly with TFC's public keys
3. Subject field in federated credential is your security control — scopes to specific workspace + run phase
4. OIDC is the gold standard for CI/CD to cloud authentication — use it always
5. Client secrets are acceptable for learning (Topic 0.9) but migrate to OIDC before production

---

---

# <a name="011"></a>📌 TOPIC 0.11 — Terraform Cloud Variable Sets

## 🧠 What Are Variable Sets?

**Variable Sets** in Terraform Cloud are reusable collections of variables that can be applied to multiple workspaces at once — instead of configuring the same variables in each workspace individually.

**Without Variable Sets:**
```
workspace: az104-training-dev      → ARM_CLIENT_ID = "xxx", ARM_TENANT_ID = "yyy"...
workspace: az104-training-staging  → ARM_CLIENT_ID = "xxx", ARM_TENANT_ID = "yyy"...  (copy-pasted)
workspace: az104-training-prod     → ARM_CLIENT_ID = "xxx", ARM_TENANT_ID = "yyy"...  (copy-pasted)
# Problem: If tenant ID changes, update in 3 places
```

**With Variable Sets:**
```
Variable Set: "azure-common-auth"
  └── ARM_TENANT_ID = "yyy"
  └── ARM_SUBSCRIPTION_ID = "zzz"
  
Applied to:  az104-training-dev ✅
             az104-training-staging ✅  
             az104-training-prod ✅
# If tenant ID changes, update in 1 place → all workspaces inherit it
```

---

## 📋 Two Types of Variables in TFC

| Type | Purpose | Example |
|------|---------|---------|
| **Terraform Variables** | Values for your `.tf` variable declarations | `location = "East US"` |
| **Environment Variables** | OS-level env vars consumed by providers | `ARM_CLIENT_ID = "abc"` |

**Azure authentication uses Environment Variables** (because the `azurerm` provider reads these from the OS environment):
```
ARM_CLIENT_ID       - The Service Principal's App ID
ARM_CLIENT_SECRET   - The Client Secret (or use OIDC instead)
ARM_TENANT_ID       - Your Azure Tenant ID
ARM_SUBSCRIPTION_ID - Your Azure Subscription ID

# For OIDC (instead of ARM_CLIENT_SECRET):
TFC_AZURE_PROVIDER_AUTH = "true"
TFC_AZURE_RUN_CLIENT_ID = "the SP App ID"
```

---

## 🛠️ HANDS-ON PRACTICE 11 — Create Variable Set in TFC

### Via TFC UI

```
1. Go to Terraform Cloud → Your Organization → Settings → Variable Sets
2. Click "Create variable set"
3. Name: "azure-training-auth"
4. Description: "Azure authentication variables for az104 training"
5. Scope: Apply to specific workspaces → select "az104-training-dev"
6. Add Variables:

   TYPE: Environment Variable
   Key: ARM_CLIENT_ID
   Value: [paste appId from SP creation]
   Sensitive: NO (it's not a secret)
   
   TYPE: Environment Variable
   Key: ARM_CLIENT_SECRET
   Value: [paste password from SP creation]
   Sensitive: YES ← ALWAYS mark secrets as sensitive
   
   TYPE: Environment Variable
   Key: ARM_TENANT_ID
   Value: [paste tenantId]
   Sensitive: NO
   
   TYPE: Environment Variable
   Key: ARM_SUBSCRIPTION_ID
   Value: [paste subscription ID]
   Sensitive: NO

7. Click "Create variable set"
```

### For OIDC (Topic 0.10 — preferred)
```
Instead of ARM_CLIENT_SECRET, use:

TYPE: Environment Variable
Key: TFC_AZURE_PROVIDER_AUTH
Value: true
Sensitive: NO

TYPE: Environment Variable  
Key: TFC_AZURE_RUN_CLIENT_ID
Value: [paste appId]
Sensitive: NO

(No ARM_CLIENT_SECRET needed!)
```

---

## 🏗️ Variable Precedence in Terraform Cloud

When the same variable is defined in multiple places, TFC uses this order (highest wins):

```
1. Workspace-specific variable     (highest priority — overrides everything)
2. Variable set (if multiple sets, last applied wins)
3. Default value in variables.tf   (lowest priority)
```

**Example use case:**
```
Variable Set "azure-common-auth"     → ARM_TENANT_ID = "shared-tenant"
Workspace "az104-training-prod"      → ARM_SUBSCRIPTION_ID = "prod-sub-id" (override)
variables.tf default                 → location = "East US"
```

---

## 🩸 PRODUCTION SCAR #011
> **"The Non-Sensitive Secret Exposure"**
>
> A team set up their TFC workspace variables but forgot to mark `ARM_CLIENT_SECRET` as **Sensitive**. The secret value was visible in plain text in the TFC UI to anyone with workspace read access — including 12 contractors. The secret had to be rotated and audit logs reviewed.
>
> **Lesson**: ALWAYS mark credential values as Sensitive in TFC. Sensitive variables:
> - Are never displayed in the TFC UI (shown as `*****` after being set)
> - Are never written to plan output or logs
> - Cannot be read back once set — you can only overwrite or delete them

---

## ✅ Topic 0.11 — Key Takeaways

1. Variable Sets = reusable variable collections applied to multiple workspaces
2. Use Environment Variables for Azure auth (ARM_CLIENT_ID, ARM_TENANT_ID, etc.)
3. ALWAYS mark secrets (ARM_CLIENT_SECRET) as **Sensitive** — non-negotiable
4. For OIDC: use `TFC_AZURE_PROVIDER_AUTH=true` + `TFC_AZURE_RUN_CLIENT_ID` — no secret needed
5. Variable precedence: workspace-specific > variable set > default value

---

---

# <a name="012"></a>📌 TOPIC 0.12 — First terraform init / plan / apply through TFC

## 🧠 The Moment of Truth

Everything we've set up in Topics 0.1–0.11 comes together here. We will:
1. Write Terraform code that creates an Azure resource
2. Push to GitHub
3. TFC auto-detects the push
4. TFC runs `terraform plan` against Azure
5. We review and approve the plan
6. TFC runs `terraform apply`
7. The Azure resource appears in the portal

---

## 📁 Final File Structure Before the First Apply

```
00-foundation/
├── providers.tf        # azurerm provider + TFC backend
├── variables.tf        # Input variables with validation
├── main.tf             # Resources to create
├── outputs.tf          # Values to display after apply
└── versions.tf         # (Optional — some teams separate this)
```

---

## 🛠️ HANDS-ON PRACTICE 12 — Complete First Apply

### Step 1: Update `providers.tf` with TFC Backend

```hcl
# providers.tf — FINAL VERSION with TFC backend

terraform {
  required_version = ">= 1.6.0"

  # This tells Terraform: "Store state in Terraform Cloud"
  # NOT on your local machine
  cloud {
    organization = "YOUR_TFC_ORGANIZATION_NAME"    # ← Replace this

    workspaces {
      name = "az104-training-dev"                   # ← Replace this
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      # If true: terraform destroy will fail if RG has resources
      # Uncomment in production to prevent accidental deletion
      # prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = false  # Don't permanently delete KV on destroy
      recover_soft_deleted_key_vaults = true   # Auto-recover if soft-deleted KV exists
    }
  }
}
```

### Step 2: Final `variables.tf`

```hcl
# variables.tf

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"

  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2",
      "UK South", "UK West", "UAE North", "Southeast Asia"
    ], var.location)
    error_message = "Unsupported Azure region. Please use an approved region."
  }
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be: dev, staging, or prod."
  }
}

variable "project" {
  description = "Project short name used in resource naming (lowercase, no spaces)"
  type        = string
  default     = "az104"

  validation {
    condition     = can(regex("^[a-z0-9-]{2,15}$", var.project))
    error_message = "Project name must be 2-15 lowercase alphanumeric characters or hyphens."
  }
}

variable "owner" {
  description = "Owner name for tagging (your name)"
  type        = string
  default     = "student"
}
```

### Step 3: Final `main.tf`

```hcl
# main.tf

locals {
  # Standardized name for the resource group
  # Format: rg-{project}-{environment}-001
  rg_name = "rg-${var.project}-${var.environment}-001"

  # All resources get these tags
  common_tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = "Terraform"
    TFCWorkspace = "az104-training-${var.environment}"
    Repository  = "az104-devops-training"
  }
}

# PRIMARY RESOURCE: Azure Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}
```

### Step 4: Final `outputs.tf`

```hcl
# outputs.tf

output "resource_group_name" {
  description = "The name of the deployed resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "The full Azure Resource ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_location" {
  description = "The Azure region of the resource group"
  value       = azurerm_resource_group.main.location
}

output "environment" {
  description = "The deployment environment"
  value       = var.environment
}
```

### Step 5: Add TFC Terraform Variables

In TFC → Your Workspace → Variables:
```
KEY          VALUE    TYPE                SENSITIVE
─────────────────────────────────────────────────
environment  dev      Terraform Variable  No
location     East US  Terraform Variable  No
project      az104    Terraform Variable  No
owner        yourname Terraform Variable  No
```

### Step 6: Push to GitHub & Trigger the Run

```bash
# Stage all files
git add 00-foundation/

# Commit with meaningful message
git commit -m "feat(foundation): add first terraform resource - resource group

- Configure TFC remote backend (cloud block)
- Add azurerm provider v3.100 with features block  
- Add resource group with standardized naming and tags
- Add input variables with validation
- Add outputs for rg name, id, location"

# Push to GitHub
git push origin main

# ─────────────────────────────────────────────
# Now watch in Terraform Cloud:
# 1. A new Run appears automatically
# 2. Status: "Planning..."
# 3. Plan completes: shows "+ 1 to add, 0 to change, 0 to destroy"
# 4. Click "Confirm & Apply"
# 5. Status: "Applying..."
# 6. Status: "Applied" ✅
# ─────────────────────────────────────────────
```

### Step 7: Verify in Azure Portal

```bash
# Via Azure CLI — verify the resource group was created
az group show --name "rg-az104-dev-001" --output table

# Expected output:
# Location    Name               Status
# ----------  -----------------  ---------
# eastus      rg-az104-dev-001   Succeeded
```

---

## 📊 What a Successful TFC Plan Looks Like

```
Terraform will perform the following actions:

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "rg-az104-dev-001"
      + tags     = {
          + "Environment"  = "dev"
          + "ManagedBy"    = "Terraform"
          + "Owner"        = "yourname"
          + "Project"      = "az104"
          + "Repository"   = "az104-devops-training"
          + "TFCWorkspace" = "az104-training-dev"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + environment           = "dev"
  + resource_group_id     = (known after apply)
  + resource_group_location = "eastus"
  + resource_group_name   = "rg-az104-dev-001"
```

---

## 🩸 PRODUCTION SCAR #012
> **"The Missing Cloud Block"**
>
> An engineer cloned a TFC-configured repo and ran `terraform init` locally without noticing the `cloud {}` block in providers.tf. Terraform initialized a LOCAL backend and created a local `terraform.tfstate` file. They applied changes locally, creating real Azure resources — but TFC's state had no record of them. The two states diverged. Reconciling the drift took an entire day and required `terraform import` for 8 resources.
>
> **Lesson**: When using TFC, ALWAYS run `terraform init` in a TFC context (or just push to GitHub and let TFC handle it). Check where your state is stored with `terraform state list` before touching ANYTHING. If you see resources in Azure that aren't in TFC state, you have drift.

---

## ✅ Topic 0.12 — Key Takeaways

1. The `cloud {}` block in providers.tf connects Terraform to TFC as the remote backend
2. Git push to GitHub → TFC auto-detects → runs plan → requires manual confirmation → applies
3. Always set TFC workspace Terraform Variables (environment, location, etc.) before the first plan
4. Verify applies with `az group show` — never trust the TFC UI alone
5. Check TFC run output for `Plan: X to add, Y to change, Z to destroy` before confirming

---

---

# <a name="013"></a>📌 TOPIC 0.13 — Production-Grade Repo Structure

## 🧠 Why Repo Structure Matters

A bad repo structure in Terraform is like building a 20-floor skyscraper without a blueprint. It works for the first floor. Then it becomes a nightmare.

**Signs of a bad Terraform repo:**
- One gigantic `main.tf` file with 2,000 lines
- Environment-specific variables hardcoded in resource blocks
- No modules — copy-paste code everywhere
- `terraform.tfstate` committed to Git
- One workspace for all environments

**Production-grade structure** enables:
- Multiple engineers working simultaneously without conflicts
- Clear separation of environments (dev can't affect prod)
- Reusable modules (write once, use everywhere)
- Code review for infrastructure changes (just like application code)
- Automated CI/CD pipelines per environment

---

## 🏗️ Production Mono-Repo Structure

```
az104-devops-training/                          ← Root of GitHub repo
│
├── README.md                                   ← Project overview & setup guide
├── .gitignore                                  ← Terraform + OS ignores
│
├── .github/                                    ← GitHub-specific configs
│   ├── workflows/                              ← GitHub Actions CI/CD pipelines
│   │   ├── terraform-plan-dev.yml              ← Auto plan on PR to dev
│   │   ├── terraform-plan-staging.yml          ← Auto plan on PR to staging  
│   │   └── terraform-validate.yml              ← Validate HCL syntax on every PR
│   ├── PULL_REQUEST_TEMPLATE.md               ← Template for all PRs
│   └── CODEOWNERS                              ← Who must review which files
│
├── modules/                                    ← Reusable Terraform modules
│   ├── README.md
│   ├── networking/                             ← VNet, Subnet, NSG module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── virtual-machine/                        ← VM module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── storage/                               ← Storage Account module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
│
└── environments/                              ← Environment-specific deployments
    ├── dev/                                   ← TFC Workspace: az104-training-dev
    │   ├── main.tf                            ← Calls modules with dev-specific values
    │   ├── providers.tf                       ← TFC backend: az104-training-dev
    │   ├── variables.tf                       ← Dev-specific variable declarations
    │   ├── outputs.tf
    │   └── terraform.auto.tfvars             ← Dev variable values (non-sensitive only)
    ├── staging/                              ← TFC Workspace: az104-training-staging
    │   ├── main.tf
    │   ├── providers.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── terraform.auto.tfvars
    └── prod/                                 ← TFC Workspace: az104-training-prod
        ├── main.tf
        ├── providers.tf
        ├── variables.tf
        ├── outputs.tf
        └── terraform.auto.tfvars
```

---

## 📄 Key Files — Templates

### `README.md` (Root)
```markdown
# AZ-104 DevOps Training — Terraform Infrastructure

## Architecture Overview
This repository contains production-grade Terraform code for AZ-104 training,
deployed through Terraform Cloud with GitHub Actions CI/CD.

## Environments
| Environment | TFC Workspace | Azure Subscription |
|-------------|-------------|-------------------|
| dev | az104-training-dev | [dev subscription ID] |
| staging | az104-training-staging | [staging subscription ID] |
| prod | az104-training-prod | [prod subscription ID] |

## Setup
1. Prerequisites: Azure CLI, Terraform CLI, Git
2. Authentication: OIDC configured per environment
3. Deploy: Push to GitHub → TFC plan → Manual approval → Apply

## Module Documentation
- [networking](./modules/networking/README.md)
- [virtual-machine](./modules/virtual-machine/README.md)
- [storage](./modules/storage/README.md)
```

### `.github/PULL_REQUEST_TEMPLATE.md`
```markdown
## Summary
<!-- What does this PR change? Why? -->

## Type of Change
- [ ] New resource/module
- [ ] Modification to existing resource
- [ ] Deletion of resource
- [ ] Variable/output change
- [ ] Provider version update

## Environments Affected
- [ ] Dev
- [ ] Staging
- [ ] Prod

## Terraform Plan
<!-- Paste the TFC plan summary here -->
```
Plan: X to add, Y to change, Z to destroy.
```

## Checklist
- [ ] I have run `terraform validate` locally
- [ ] I have run `terraform fmt` to format code
- [ ] I have updated documentation if needed
- [ ] I have added/updated variables with descriptions and validation
- [ ] Sensitive values are NOT hardcoded
- [ ] Tags are applied to all resources
- [ ] I have reviewed the TFC plan output for unexpected changes
```

### `environments/dev/providers.tf`
```hcl
# environments/dev/providers.tf

terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "YOUR_TFC_ORG"
    workspaces {
      name = "az104-training-dev"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false  # Allow in dev
    }
  }
}
```

### `environments/prod/providers.tf`
```hcl
# environments/prod/providers.tf
# Note differences from dev!

terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "YOUR_TFC_ORG"
    workspaces {
      name = "az104-training-prod"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"  # Same version — consistency is key
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true  # Protect prod!
    }
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    virtual_machine {
      delete_os_disk_on_deletion = false  # Keep disks even if VM deleted
    }
  }
}
```

### `environments/dev/main.tf` — Module Consumption Pattern
```hcl
# environments/dev/main.tf
# This is how you consume modules — NOT where you define resources directly

locals {
  environment = "dev"
  location    = "East US"
  project     = "az104"

  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

# Call the networking module (Phase 2)
module "networking" {
  source = "../../modules/networking"

  resource_group_name = "rg-${local.project}-network-${local.environment}-001"
  location            = local.location
  environment         = local.environment

  vnet_address_space  = ["10.10.0.0/16"]
  subnets = {
    "snet-web"  = "10.10.1.0/24"
    "snet-app"  = "10.10.2.0/24"
    "snet-data" = "10.10.3.0/24"
  }

  tags = local.common_tags
}
```

### `modules/networking/main.tf` — Module Definition Pattern
```hcl
# modules/networking/main.tf
# This module is REUSABLE — called by dev, staging, prod

resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-001"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value]
}
```

---

## 🔧 `.github/workflows/terraform-validate.yml`

```yaml
# .github/workflows/terraform-validate.yml
# Runs on every Pull Request to validate Terraform syntax

name: Terraform Validate

on:
  pull_request:
    branches: [main]
    paths:
      - 'environments/**'
      - 'modules/**'

jobs:
  validate:
    name: Validate Terraform
    runs-on: ubuntu-latest

    strategy:
      matrix:
        environment: [dev, staging, prod]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "~1.9"
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Terraform Format Check
        run: terraform fmt -check -recursive
        working-directory: environments/${{ matrix.environment }}

      - name: Terraform Init
        run: terraform init -backend=false
        working-directory: environments/${{ matrix.environment }}

      - name: Terraform Validate
        run: terraform validate
        working-directory: environments/${{ matrix.environment }}
```

---

## 🩸 PRODUCTION SCAR #013
> **"The Monolithic Main.tf"**
>
> A startup built their entire Azure infrastructure (50 resources across 5 environments) in a single `main.tf` file, 3,200 lines long. One `terraform plan` took 18 minutes and always had 40+ resources in the diff — even for a 1-line change. One engineer's change accidentally conflicted with another's. State corruption occurred twice. They eventually rewrote everything — 6 weeks of migration work.
>
> **Lesson**: Structure your repo properly from Day 1. It is NEVER too early to use modules and environment separation. Tech debt in infrastructure is exponentially more expensive to fix than in application code.

---

## ✅ Topic 0.13 — Key Takeaways

1. Separate environments into folders (`environments/dev`, `environments/staging`, `environments/prod`)
2. Each environment folder has its own TFC workspace (different state, different variables)
3. Reusable logic goes in `modules/` — write once, call from multiple environments
4. `.github/` contains GitHub Actions workflows and PR templates
5. Provider configuration DIFFERS between environments (more protective in prod)

---

---

# 🏆 PHASE 0 — COMPLETE SUMMARY

## What You've Learned

| Topic | Core Skill Gained |
|-------|------------------|
| 0.1 | Cloud mental model, Azure geography, IaaS/PaaS/SaaS |
| 0.2 | Azure free account, portal navigation, cost alerts |
| 0.3 | Azure CLI 20 key commands, subscription awareness |
| 0.4 | IaC vs ClickOps vs Scripts, Terraform declarative model |
| 0.5 | HCL syntax, 5 Terraform file types, init/plan/apply |
| 0.6 | Git time machine model, branching strategy, .gitignore |
| 0.7 | GitHub repo setup, SSH keys, branch protection |
| 0.8 | TFC workspaces, VCS integration, run workflow |
| 0.9 | Service Principal creation, 4 auth values, least privilege |
| 0.10 | OIDC zero-secret auth, federated credentials, why it beats secrets |
| 0.11 | TFC Variable Sets, sensitive flag, variable precedence |
| 0.12 | Complete first apply through TFC via GitHub push |
| 0.13 | Production mono-repo structure, modules, environments |

## 🩸 Production Scars Collected This Phase

| # | Scar | Lesson |
|---|------|--------|
| 001 | Region mismatch GDPR violation | Always confirm region requirement before first resource |
| 002 | Wrong subscription deployment | Always `az account show` before every session |
| 003 | Wrong subscription delete | `az account show` before ANY destructive command |
| 004 | ClickOps subscription deleted — 4 months rebuild | If it's not in code, it doesn't exist |
| 005 | `-auto-approve` deleted 47 prod resources | Never use auto-approve in production pipelines |
| 006 | Direct push to main deleted NSG rules | Protect main branch — require PRs, always |
| 007 | Public repo leaked credentials in 11 minutes | Private repos + `.gitignore` + OIDC |
| 008 | Non-sensitive TFC variable exposed to contractors | ALWAYS mark credential values as Sensitive |
| 009 | Shared SP — no audit trail, prod delete | One SP per environment, never share |
| 010 | Expired SP secret took 6 hours to fix across 14 workspaces | Use OIDC to eliminate secret rotation entirely |
| 011 | Non-sensitive ARM_CLIENT_SECRET exposed | Mark ALL secrets as Sensitive in TFC |
| 012 | Local backend vs TFC state divergence | Always verify where your state lives |
| 013 | 3,200-line monolithic main.tf = $6-week rewrite | Structure correctly from Day 1 |

---

## 📊 Progress Update

| Phase | Status |
|-------|--------|
| **Phase 0 — Foundation** | ✅ **COMPLETE** |
| Phase 1 — Identity & Governance | ⬜ **NEXT** |
| Phase 2 — Networking | ⬜ Locked |
| Phase 3 — Compute & Storage | ⬜ Locked |
| Phase 4 — Containers & Serverless | ⬜ Locked |
| Phase 5 — Monitoring & CI/CD | ⬜ Locked |
| Phase 6 — Migration | ⬜ Locked |
| Phase 7 — Security | ⬜ Locked |

---

> **Coach's Final Note for Phase 0**: You now understand the complete foundation. Before we move to Phase 1, I want you to actually execute Topics 0.2 through 0.12 hands-on. Don't just read — type every command, hit every error, fix every problem. The muscle memory only builds through repetition. When you've completed your first successful `terraform apply` through TFC and verified the resource group in Azure, come back and we launch Phase 1: Identity & Governance. 🏋️
