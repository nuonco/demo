#!/usr/bin/env sh

set -e
set -o pipefail
set -u

# Script to list ECR images

# Inputs provided as environment variables
# - REPO: ECR Repository name
# - AWS_REGION: AWS Region

echo "Listing images for repo: $REPO in region: $AWS_REGION"

# Fetch images, sort by push date (latest last), take last 50
IMAGES=$(aws ecr describe-images \
  --repository-name "$REPO" \
  --region "$AWS_REGION" \
  --query 'sort_by(imageDetails, &imagePushedAt)[-50:]' \
  --output json)

# Output as single-line JSON
OUTPUTS=$(jq -c -n \
  --argjson images "$IMAGES" \
  '{"images": $images}')

echo "$OUTPUTS" >> "$NUON_ACTIONS_OUTPUT_FILEPATH"
