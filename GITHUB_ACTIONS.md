# Simple Terraform GitHub Actions

## Quick Setup

1. **Create S3 buckets for state storage:**
   ```bash
   aws s3api create-bucket --bucket terra-task-dev-state --region us-east-1
   aws s3api create-bucket --bucket terra-task-prod-state --region us-east-1
   ```

2. **Add GitHub repository secrets:**
   - Go to Settings → Secrets and variables → Actions
   - Add: `AWS_ACCESS_KEY_ID`
   - Add: `AWS_SECRET_ACCESS_KEY`

## How to Use

1. Go to **Actions** tab in your GitHub repo
2. Click **Terraform** workflow
3. Click **Run workflow**
4. Choose:
   - **Environment**: `dev` or `prod`
   - **Action**: `validate`, `plan`, or `apply`
5. Click **Run workflow**

## Actions Explained

- **validate**: Check if Terraform configuration is valid
- **plan**: Show what changes will be made (safe, no changes applied)
- **apply**: Actually create/update your AWS infrastructure

That's it! Simple and clean.
