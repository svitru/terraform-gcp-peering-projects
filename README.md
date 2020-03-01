# terraform-gcp-peering-projects

Cross project management using service account:
Create the first service account in project A in the Cloud Console. Activate it using gcloud auth activate-service-account.

In the Cloud Console, navigate to project B. Find the "IAM & admin" > "IAM" page. Click the "Add" button. In the "New members" field paste the name of the service account (it should look like a strange email address) and give it the appropriate role.

Run gcloud commands with --project set to project B. They should succeed (I just manually verified that this will work).
