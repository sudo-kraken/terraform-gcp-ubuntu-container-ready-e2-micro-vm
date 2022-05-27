# Deploys a Container-Optimized OS Virtual Machine in GCP using Terraform
Using the below instructions and supplied .tf files you will be able to deploy an e2-micro instance into GCP using Terraform, this is the free tier so shouldnt cost you a thing.

## Instructions
Firstly you will need to have a GCP account you can read more on this [here](https://cloud.google.com/free/docs/gcp-free-tier). Once this is done, go ahead and create yourself a blank project, name it whatever you like. Then enable the Compute Engine API, finally proceed to open up the cloud shell from within that project.

Create the folders required for your auth and tf files. (You should automatically be in your home folder feel free to put these wherever you choose.)
```
mkdir terraform

mkdir auth
```

Now you will need to create a service account to use Terraform with and give it all the required permissions necessary to provision the VM.

```
# Creates a service account named tf-serviceaccount 
gcloud iam service-accounts create tf-serviceaccount --description="service account for terraform" --display-name="terraform_service_account"

# List accounts to ensure it was created
gcloud iam service-accounts list

# Create keys for the service account to use when provisioning and store them in the auth folder.
**Ensure that you update PROJECT-ID-HERE with your project ID.**
gcloud iam service-accounts keys create ~/auth/google-key.json --iam-account tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com
```

With this done we will now add the following permissions to the service account.

```
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable serviceusage.googleapis.com

# For all of the below commands ensure that you update PROJECT-ID-HERE with your project ID.
gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@.iam.gserviceaccount.com --role roles/viewer

gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/storage.admin

gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/compute.instanceAdmin.v1

gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/compute.networkAdmin

gcloud projects add-iam-policy-binding PROJECT-ID-HERE --member serviceAccount:tf-serviceaccount@PROJECT-ID-HERE.iam.gserviceaccount.com --role roles/compute.securityAdmin
```

Now you will want to copy all of the .tf files in this repo into the terraform folder we created earlier, ensure you read all of them carefully and update each one with your own information.

You should now be ready to deploy. First you will run the init, to pull all dependancies, then a plan to test the config and finally apply to build the project.
```
terraform init

terraform plan

terraform apply
```

Voila! if all is well you should be presented with the information of your new vm. You can now SSH in or go through the cloud console SSH which can be found in the GCP Compute Engine under VM Instances.

### Notes

COS Version Definitions - **cos-versions.tf**

Main VM Configuration Definitions - **cos-vm-main.tf**

Information To Display When Provisioning Completes - **cos-vm-output.tf**

Main VM Terraform Variable Definitions - **cos-vm-variables.tf**

Network Firewall Rule Definitions - **network-firewall.tf**

Network Definitions - **network-main.tf**

Network Terraform Variable Definitions - **network-variables.tf**

GCP Providers Definitions - **provider-main.tf**

GCP Providers Terraform Variable Definitions - **provider-variables.tf**

Terraform Variable Definitions - **terraform.tfvars**
