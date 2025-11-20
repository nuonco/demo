# Builder

Terraform module that deploys a Kaniko-based image builder as an ECS Fargate task.

## Overview

This module creates an on-demand, serverless container builder that:

- Runs only when triggered (no persistent infrastructure)
- Clones a specific branch from the repo
- Builds a Next.js Docker image with custom build args
- Pushes the result to ECR
- Automatically terminates after completion

## Architecture

The ECS task consists of two containers:

1. **Init container (git-clone)**: Clones the specified branch into a shared volume
2. **Main container (kaniko)**: Builds the Dockerfile and pushes to ECR

These containers share an ephemeral volume that exists only during task execution.

## Inputs/Variables

| Variable          | Description                                            | Type         | Required                          |
| ----------------- | ------------------------------------------------------ | ------------ | --------------------------------- |
| `ecr_registry`    | ECR registry URL                                       | string       | yes                               |
| `ecr_repository`  | ECR repository name                                    | string       | yes                               |
| `git_repo_url`    | Git repository URL (HTTPS)                             | string       | yes                               |
| `dockerfile_path` | Path to Dockerfile relative to repo root               | string       | no (default: "docker/Dockerfile") |
| `vpc_id`          | VPC ID for Fargate task                                | string       | yes                               |
| `subnet_ids`      | List of subnet IDs for Fargate task                    | list(string) | yes                               |
| `ecs_cluster_id`  | ECS cluster ID (optional, creates one if not provided) | string       | no                                |

## Runtime Parameters (passed when triggering)

These are passed as container overrides when running the task:

- `BRANCH`: Git branch to clone and build
- `IMAGE_TAG`: Tag to apply to the built image
- `BUILD_ARGS`: Build arguments (e.g., NEXT_PUBLIC_BASE_URL)

## Outputs

| Output                    | Description                          |
| ------------------------- | ------------------------------------ |
| `task_definition_arn`     | ARN of the ECS task definition       |
| `task_execution_role_arn` | ARN of the task execution role       |
| `task_role_arn`           | ARN of the task IAM role             |
| `security_group_id`       | Security group ID for the task       |
| `cluster_id`              | ECS cluster ID (created or provided) |

## Usage

### Terraform Module

```hcl
module "image_builder" {
  source = "./components/builder"

  ecr_registry     = "123456789.dkr.ecr.us-east-1.amazonaws.com"
  ecr_repository   = "inbox-zero"
  git_repo_url     = "https://github.com/elie222/inbox-zero.git"
  dockerfile_path  = "docker/Dockerfile"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}
```

### Triggering a Build

Use AWS CLI or SDK to run the task:

```bash
aws ecs run-task \
  --cluster <cluster_id> \
  --task-definition <task_definition_arn> \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[<subnet_ids>],securityGroups=[<sg_id>]}" \
  --overrides '{
    "containerOverrides": [
      {
        "name": "git-clone",
        "environment": [
          {"name": "BRANCH", "value": "main"}
        ]
      },
      {
        "name": "kaniko",
        "environment": [
          {"name": "IMAGE_TAG", "value": "main"},
          {"name": "BUILD_ARGS", "value": "NEXT_PUBLIC_BASE_URL=app.example.com"}
        ]
      }
    ]
  }'
```

## IAM Permissions

The task IAM role includes:

- `ecr:PutImage`, `ecr:InitiateLayerUpload`, `ecr:UploadLayerPart`, `ecr:CompleteLayerUpload`
- `ecr:BatchCheckLayerAvailability`, `ecr:GetAuthorizationToken`

## Cost Model

- **No persistent infrastructure costs** - only pay when building
- Fargate pricing based on vCPU/memory per second of task runtime
- Typical Next.js build: ~5-10 minutes on 0.5 vCPU / 1GB RAM
- Estimated cost per build: $0.01-0.02

## Design Decisions

1. **Fargate over EC2**: No server management, truly ephemeral
2. **Init container pattern**: Separates git clone from build for clarity
3. **Shared ephemeral volume**: No EFS needed, faster and cheaper
4. **Container overrides**: Allows dynamic branch/tag without rebuilding task definition
5. **No secrets for public repos**: Uses HTTPS clone for simplicity (add git credentials for private repos)
