#!/usr/bin/env sh

set -e
set -o pipefail
set -u

# Script to trigger the ECS Fargate image builder task

# override-able but w/ defaults
# - BRANCH: Git branch to build (default: main)
# - IMAGE_TAG: Docker image tag (default: latest)
# - BUILD_ARGS: Docker build arguments (default: empty)

# prepare outputs
OUTPUTS='{}'

# Set defaults
BUILD_ARGS="${BUILD_ARGS:-}"

# Convert comma-separated subnet IDs to JSON array format
SUBNETS_ARRAY=$(echo "$SUBNET_IDS" | sed 's/,/","/g' | sed 's/^/"/' | sed 's/$/"/')

echo "Starting ECS Builder Task"
echo " >         cluster: $CLUSTER_ID"
echo " > task definition: $TASK_DEFINITION_ARN"
echo " >          branch: $BRANCH"
echo " >       image tag: $IMAGE_TAG"
echo " >      build args: ${BUILD_ARGS:-none}"
echo " >          region: $AWS_REGION"

# Build the overrides JSON using jq
OVERRIDES_FILE="/tmp/ecs-overrides-$$.json"
jq -n \
  --arg branch "$BRANCH" \
  --arg image_tag "$IMAGE_TAG" \
  --arg build_args "$BUILD_ARGS" \
  '{
    containerOverrides: [
      {
        name: "git-clone",
        environment: [
          {name: "BRANCH", value: $branch}
        ]
      },
      {
        name: "kaniko",
        environment: [
          {name: "IMAGE_TAG", value: $image_tag},
          {name: "BUILD_ARGS", value: $build_args}
        ]
      }
    ]
  }' > "$OVERRIDES_FILE"

OVERRIDES_JSON=$(cat "$OVERRIDES_FILE")

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

# Fetch Log Configuration from Task Definition
LOG_CONFIGS=$(aws ecs describe-task-definition \
  --task-definition "$TASK_DEFINITION_ARN" \
  --region "$AWS_REGION" \
  | jq -c '[.taskDefinition.containerDefinitions[] | select(.logConfiguration.logDriver == "awslogs") | {container: .name, awslogs: .logConfiguration.options}]')

# Compose outputs JSON
OUTPUTS=$(jq -c -n \
  --arg task_arn "$TASK_ARN" \
  --arg cluster_id "$CLUSTER_ID" \
  --argjson log_configs "$LOG_CONFIGS" \
  '{"task_arn": $task_arn, "cluster_id": $cluster_id, "log_configs": $log_configs}')
echo "$OUTPUTS"
echo "$OUTPUTS" >> $NUON_ACTIONS_OUTPUT_FILEPATH
