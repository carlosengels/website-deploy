#!/bin/bash

set -e  # Exit on errors

REPO_DIR="/opt/website-sync/repo"
BRANCH="main"
S3_BUCKET="s3://carlosengels.com"
AWS_PROFILE="default"

cd "$REPO_DIR"

# Ensure latest content
git fetch origin
git reset --hard origin/$BRANCH

# Install dependencies
npm install

# Build the site (if using a static site generator like Next.js, Vue, Astro, etc.)
npm run build

# Sync the output directory to S3 (adjust if output isn't 'dist')
aws s3 sync ./dist "$S3_BUCKET" --delete --profile "$AWS_PROFILE"
