<div align="center">
<img src="docs/assets/logo.png" align="center" width="144px" height="144px"/>

### Terraform GCP Ubuntu e2-micro VM

_Deploys an Ubuntu Minimal VM on Google Cloud’s free tier with Docker CE and Docker Compose preinstalled. Injects a sample Compose project to an attached data disk for quick app bring-up._
</div>

<div align="center">

[![Terraform](https://img.shields.io/badge/Terraform-Required-623CE4?logo=terraform&logoColor=white&style=for-the-badge)](https://www.terraform.io/)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.6%2B-623CE4?logo=terraform&logoColor=white&style=for-the-badge)](https://www.terraform.io/)

</div>

<div align="center">

[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/sudo-kraken/terraform-gcp-ubuntu-container-ready-e2-micro-vm?label=openssf%20scorecard&style=for-the-badge)](https://scorecard.dev/viewer/?uri=github.com/sudo-kraken/terraform-gcp-ubuntu-container-ready-e2-micro-vm)

</div>

## Contents

- [Overview](#overview)
- [Architecture at a glance](#architecture-at-a-glance)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick start](#quick-start)
- [Repository structure](#repository-structure)
- [Google Free Tier information](#google-free-tier-information)
- [Troubleshooting](#troubleshooting)
- [Infrastructure model](#infrastructure-model)
- [Licence](#licence)
- [Security](#security)
- [Contributing](#contributing)
- [Support](#support)

## Overview

Using the supplied Terraform configuration, this project deploys a free-tier eligible **e2-micro** VM running Ubuntu Minimal, with **Docker CE** and **Docker Compose** installed automatically. A sample Compose file is injected onto a data disk at `/mnt/disks/docker/projects/app` that runs **Uptime Kuma** and **Healthchecks** as examples.

> [!NOTE]  
> The full, step-by-step installation guide lives in my docs site: **[sudo-kraken Docs](https://sudo-kraken.github.io/docs/gcp-free-forever/)**. The sections below summarise the essentials for quick use.

## Architecture at a glance

- Terraform Google provider provisions:
  - **Compute Engine e2-micro** instance based on **Ubuntu Minimal**
  - Optional **secondary persistent disk** for container data, mounted at `/mnt/disks/docker`
  - **Firewall rules** for required ingress such as SSH and web ports as defined in `network-firewall.tf`
- **Startup script** installs Docker CE and Docker Compose then places a sample `docker-compose.yaml` under `/mnt/disks/docker/projects/app`
- **SSH key injection** from `~/.ssh/sshkey.pub`
- Outputs expose VM details including external IP

## Features

- Free-tier friendly deployment targeting eligible US regions
- Automatic install of Docker CE and Docker Compose
- Sample Compose project seeded to a mounted data disk
- Separate Terraform files for provider, network, VM and variables for clarity
- Opinionated defaults you can customise via `terraform.tfvars`

## Prerequisites

- A Google Cloud account with Free Tier enabled
- A new or existing GCP project with **Compute Engine API** enabled
- A **service account** with keys and the following roles at project scope:
  - `roles/viewer`
  - `roles/storage.admin`
  - `roles/compute.instanceAdmin.v1`
  - `roles/compute.networkAdmin`
  - `roles/compute.securityAdmin`
- SSH keypair in `~/.ssh/sshkey` and `~/.ssh/sshkey.pub` in OpenSSH format
- Terraform 1.6 or newer

> [!NOTE]  
> Google defaults VM network service tier to Premium. Switch to **Standard** to stay aligned with free-tier usage. See the screenshot below.

## Quick start

Create basic folders in Cloud Shell or your workstation:

```bash
cd ~
mkdir -p terraform auth compose_files startup .ssh
```

Clone and copy files:

```bash
git clone https://github.com/sudo-kraken/terraform-gcp-ubuntu-container-ready-e2-micro-vm.git ~/terraform
# Place your docker-compose.yaml into ~/compose_files
# Place startup.sh into ~/startup
```

Create a service account and key:

```bash
# Replace PROJECT-ID-HERE with your project id
gcloud iam service-accounts create tf-serviceaccount \
  --description="service account for terraform" \
  --display-name="terraform_service_account"

gcloud iam service-accounts keys create ~/auth/google-key.json \
  --iam-account tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com
```

Enable required services and bind roles:

```bash
gcloud services enable cloudresourcemanager.googleapis.com cloudbilling.googleapis.com iam.googleapis.com storage.googleapis.com serviceusage.googleapis.com

gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/viewer
gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/storage.admin
gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/compute.instanceAdmin.v1
gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/compute.networkAdmin
gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/compute.securityAdmin
```

Copy the `.tf` files from this repo into your `~/terraform` folder, review and update variables to match your project and region, then run:

```bash
cd ~/terraform
terraform init
terraform plan
terraform apply
```

After apply completes, connect via the external IP using your SSH key or use the Cloud Console’s SSH. Allow a few minutes for the startup script to finish installing Docker and placing the Compose project.

## Repository structure

```text
.
├─ auth/                               # API user credentials
├─ compose_files/
│  └─ docker-compose.yaml              # Docker Compose configuration
├─ startup/
│  └─ startup.sh                       # Installs dependencies and seeds files
└─ terraform/
   ├─ network-firewall.tf              # Firewall rule definitions
   ├─ network-main.tf                  # Network definitions
   ├─ network-variables.tf             # Network variables
   ├─ provider-main.tf                 # GCP provider setup
   ├─ provider-variables.tf            # Provider variables
   ├─ terraform.tfvars                 # Your variable values
   ├─ ubnt-versions.tf                 # Ubuntu version data
   ├─ ubnt-vm-main.tf                  # VM resource definitions
   ├─ ubnt-vm-output.tf                # Outputs post-provision
   └─ ubnt-vm-variables.tf             # VM variables
```

## Google Free Tier information

Key points highlighted in bold.

- **Compute Engine**
  - 1 non-preemptible **e2-micro VM** per month in one of:
    - Oregon: **us-west1**
    - Iowa: us-central1
    - South Carolina: us-east1
  - 30 GB-months standard persistent disk
  - 5 GB-month snapshot storage in:
    - Oregon: **us-west1**
    - Iowa: us-central1
    - South Carolina: us-east1
    - Taiwan: asia-east1
    - Belgium: europe-west1
  - **1 GB egress from North America to all regions** per month excluding China and Australia
  - **Usage is time-based for e2-micro** across supported regions
  - **External IP address is not charged** under the free tier
  - GPUs and TPUs are excluded from the free tier

### Network service tier screenshot

By default Google sets the VM networking to Premium. Change it to **Standard** as shown here:

![Change network service tier to Standard](https://user-images.githubusercontent.com/53116754/171113057-e9b5409d-1719-422e-a28c-36da70bfee2d.png)

## Troubleshooting

- **APIs or permissions**  
  Errors during plan or apply often indicate a missing enabled API or insufficient IAM roles on the service account.
- **Startup work still in progress**  
  Give the VM a few minutes after first boot for Docker install and file injection. Check serial console logs if needed.
- **Network service tier charges**  
  Switch the VM’s network service tier from Premium to **Standard** to stick to free-tier limits.

## Infrastructure model

![Infrastructure model](.infragenie/infrastructure_model.png)

## Licence

This project is licensed under the MIT Licence. See the [LICENCE](LICENCE) file for details.

## Security

If you discover a security issue, please review and follow the guidance in [SECURITY.md](SECURITY.md), or open a private security-focused issue with minimal details and request a secure contact channel.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions or improvements.  
See [CONTRIBUTING.md](CONTRIBUTING.md)

## Support

Open an [issue](/../../issues) with as much detail as possible, including your project id, region and any Terraform output or error logs that help reproduce the problem.
