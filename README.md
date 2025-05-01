# Website Sync to S3 via systemd

This setup automatically syncs the contents of a GitHub repository to an AWS S3 bucket using a Linux systemd service and timer.

## 📦 Repository

This system pulls and builds the website from:

```
https://github.com/carlosengels/carlosengels.com
```

## 🛠 Features

- Periodically pulls the latest changes from GitHub.
- Runs `npm install` and `npm run build`.
- Syncs the built output (from `dist/`) to an S3 bucket.
- Uses `systemd` and a timer for automatic execution.

---

## 📁 Directory Structure

```
/opt/website-sync/
├── repo/             # Cloned GitHub repository
└── sync.sh           # Sync and deploy script
```

---

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
sudo mkdir -p /opt/website-sync
cd /opt/website-sync
sudo git clone https://github.com/carlosengels/carlosengels.com repo
```

### 2. Install Dependencies

Make sure these are installed:

```bash
sudo apt update
sudo apt install git awscli nodejs npm -y
```

### 3. Create the Sync Script

Create `/opt/website-sync/sync.sh`:

```bash
#!/bin/bash
set -e

REPO_DIR="/opt/website-sync/repo"
BRANCH="main"
S3_BUCKET="s3://your-bucket-name"
AWS_PROFILE="default"

cd "$REPO_DIR"

git fetch origin
git reset --hard origin/$BRANCH

npm install
npm run build

aws s3 sync ./dist "$S3_BUCKET" --delete --profile "$AWS_PROFILE"
```
