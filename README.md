# terraform-gcp-peering-projects

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

In the Cloud Console, navigate to project B. Find the "IAM & admin" > "IAM" page. Click the "Add" button. In the "New members" field paste the name of the service account (it should look like a strange email address "service-account-project-a@project-a-xxxxxx.iam.gserviceaccount.com") and give it the role owner.

Run gcloud commands with --project set to project B. They should succeed (I just manually verified that this will work).
