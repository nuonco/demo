#!/usr/bin/env bash

set -e
set -o pipefail
set -u

# Script to trigger the ECS Fargate image builder task
# Uses outputs from the builder terraform module

# Required environment variables (should be set by builder outputs):
# - CLUSTER_ID: ECS cluster ID
# - TASK_DEFINITION_ARN: ARN of the builder task definition
# - SECURITY_GROUP_ID: Security group for the task
# - SUBNET_IDS: Comma-separated list of subnet IDs

# Optional environment variables:
# - BRANCH: Git branch to build (default: main)
# - IMAGE_TAG: Docker image tag (default: latest)
# - BUILD_ARGS: Docker build arguments (default: empty)
# - AWS_REGION: AWS region (default: us-east-1)

# Set defaults
BUILD_ARGS="${BUILD_ARGS:-}"

# Convert comma-separated subnet IDs to JSON array format
SUBNETS_ARRAY=$(echo "$SUBNET_IDS" | sed 's/,/","/g' | sed 's/^/"/' | sed 's/$/"/')

echo "==================================="
echo "Starting ECS Builder Task"
echo "==================================="
echo "Cluster: $CLUSTER_ID"
echo "Task Definition: $TASK_DEFINITION_ARN"
echo "Branch: $BRANCH"
echo "Image Tag: $IMAGE_TAG"
echo "Build Args: ${BUILD_ARGS:-none}"
echo "Region: $AWS_REGION"
echo "==================================="

# Build the overrides JSON
OVERRIDES_JSON=$(cat <<EOF
{
  "containerOverrides": [
    {
      "name": "git-clone",
      "environment": [
        {"name": "BRANCH", "value": "$BRANCH"}
      ]
    },
    {
      "name": "kaniko",
      "environment": [
        {"name": "IMAGE_TAG", "value": "$IMAGE_TAG"},
        {"name": "BUILD_ARGS", "value": "$BUILD_ARGS"}
      ]
    }
  ]
}
EOF
)

# Run the ECS task
TASK_RESULT=$(aws ecs run-task \
  --cluster "$CLUSTER_ID" \
  --task-definition "$TASK_DEFINITION_ARN" \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[$SUBNETS_ARRAY],securityGroups=[\"$SECURITY_GROUP_ID\"],assignPublicIp=ENABLED}" \
  --overrides "$OVERRIDES_JSON" \
  --region "$AWS_REGION")

# Extract task ARN
TASK_ARN=$(echo "$TASK_RESULT" | jq -r '.tasks[0].taskArn')

if [[ -z "$TASK_ARN" ]] || [[ "$TASK_ARN" == "null" ]]; then
  echo "Error: Failed to start task"
  echo "$TASK_RESULT" | jq .
  exit 1
fi

echo ""
echo "Task started successfully!"
echo "Task ARN: $TASK_ARN"
echo ""
echo "Monitor the task with:"
echo "  aws ecs describe-tasks --cluster $CLUSTER_ID --tasks $TASK_ARN --region $AWS_REGION"
echo ""
echo "View logs in CloudWatch Logs group (check builder outputs for log group name)"

# Compose outputs JSON
OUTPUTS=$(jq -n \
  --arg task_arn "$TASK_ARN" \
  --arg cluster_id "$CLUSTER_ID" \
  '{task_arn: $task_arn, cluster_id: $cluster_id}')

echo "$OUTPUTS"
