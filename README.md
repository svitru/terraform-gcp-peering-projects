## terraform-gcp-peering-projects

There are two projects without service accounts: project-a - id=project-a-xxxxxx and project-b - id=project-b-xxxxxx

The utility gcloud must be initialized for your GCP account.

### Create service account for project-a:
```sh
# Select project-a as active
gcloud config set project project-a-xxxxxx
# Create service account
gcloud iam service-accounts create service-account-project-a --display-name "service-account-project-a"
# Grant permissions to the service account
gcloud projects add-iam-policy-binding project-a-xxxxxx --member "serviceAccount:service-account-project-a@project-a-xxxxxx.iam.gserviceaccount.com" --role "roles/owner"
# Generate the key file
gcloud iam service-accounts keys create project-a-key.json --iam-account service-account-project-a@project-a-xxxxxx.iam.gserviceaccount.com
```
### Create cross project management using service account:
```sh
# Add service account from project-a to project-b
gcloud projects add-iam-policy-binding project-b-xxxxxx --member "serviceAccount:service-account-project-a@project-a-xxxxxx.iam.gserviceaccount.com" --role "roles/owner"
```
