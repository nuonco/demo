# Builder

Terraform module that deploys a Kaniko-based image builder as an ECS Fargate task.

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | = 6.21.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                    | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_log_group.builder](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/cloudwatch_log_group)                    | resource    |
| [aws_ecs_task_definition.builder](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/ecs_task_definition)                      | resource    |
| [aws_iam_role.task](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/iam_role)                                               | resource    |
| [aws_iam_role.task_execution](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy.ecr_push](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/iam_role_policy)                             | resource    |
| [aws_iam_role_policy_attachment.task_execution](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_security_group.builder](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/security_group)                                | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/data-sources/caller_identity)                           | data source |
| [aws_ecr_repository.target](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/data-sources/ecr_repository)                              | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/data-sources/region)                                             | data source |

## Inputs

| Name                                                                                    | Description                                                        | Type          | Default               | Required |
| --------------------------------------------------------------------------------------- | ------------------------------------------------------------------ | ------------- | --------------------- | :------: |
| <a name="input_cpu"></a> [cpu](#input_cpu)                                              | Fargate task CPU units (256, 512, 1024, 2048, 4096)                | `string`      | `"512"`               |    no    |
| <a name="input_dockerfile_path"></a> [dockerfile_path](#input_dockerfile_path)          | Path to Dockerfile relative to repo root                           | `string`      | `"docker/Dockerfile"` |    no    |
| <a name="input_ecr_registry"></a> [ecr_registry](#input_ecr_registry)                   | ECR registry URL (e.g., 123456789.dkr.ecr.us-east-1.amazonaws.com) | `string`      | n/a                   |   yes    |
| <a name="input_ecr_repository"></a> [ecr_repository](#input_ecr_repository)             | ECR repository name                                                | `string`      | n/a                   |   yes    |
| <a name="input_ecs_cluster_id"></a> [ecs_cluster_id](#input_ecs_cluster_id)             | ECS cluster ID where the builder task will be registered           | `string`      | n/a                   |   yes    |
| <a name="input_git_repo_url"></a> [git_repo_url](#input_git_repo_url)                   | Git repository URL (HTTPS)                                         | `string`      | n/a                   |   yes    |
| <a name="input_log_retention_days"></a> [log_retention_days](#input_log_retention_days) | CloudWatch Logs retention in days                                  | `number`      | `7`                   |    no    |
| <a name="input_memory"></a> [memory](#input_memory)                                     | Fargate task memory in MB (512, 1024, 2048, etc.)                  | `string`      | `"1024"`              |    no    |
| <a name="input_name_prefix"></a> [name_prefix](#input_name_prefix)                      | Prefix for resource names                                          | `string`      | `"builder"`           |    no    |
| <a name="input_nuon_install_id"></a> [nuon_install_id](#input_nuon_install_id)          | Nuon Install ID                                                    | `string`      | n/a                   |   yes    |
| <a name="input_region"></a> [region](#input_region)                                     | AWS Region                                                         | `string`      | n/a                   |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                           | Tags to apply to all resources                                     | `map(string)` | `{}`                  |    no    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                     | VPC ID for Fargate task security group                             | `string`      | n/a                   |   yes    |

## Outputs

| Name                                                                                                     | Description                                |
| -------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| <a name="output_cluster_id"></a> [cluster_id](#output_cluster_id)                                        | ECS cluster ID (passed through from input) |
| <a name="output_log_group_name"></a> [log_group_name](#output_log_group_name)                            | CloudWatch log group name                  |
| <a name="output_security_group_id"></a> [security_group_id](#output_security_group_id)                   | Security group ID for the builder task     |
| <a name="output_task_definition_arn"></a> [task_definition_arn](#output_task_definition_arn)             | ARN of the ECS task definition             |
| <a name="output_task_execution_role_arn"></a> [task_execution_role_arn](#output_task_execution_role_arn) | ARN of the task execution role             |
| <a name="output_task_role_arn"></a> [task_role_arn](#output_task_role_arn)                               | ARN of the task IAM role                   |

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

| Variable          | Description                              | Type   | Required                          |
| ----------------- | ---------------------------------------- | ------ | --------------------------------- |
| `ecr_registry`    | ECR registry URL                         | string | yes                               |
| `ecr_repository`  | ECR repository name                      | string | yes                               |
| `git_repo_url`    | Git repository URL (HTTPS)               | string | yes                               |
| `dockerfile_path` | Path to Dockerfile relative to repo root | string | no (default: "docker/Dockerfile") |
| `vpc_id`          | VPC ID for security group                | string | yes                               |
| `ecs_cluster_id`  | ECS cluster ID (must be pre-created)     | string | yes                               |

## Runtime Parameters (passed when triggering)

These are passed as container overrides when running the task:

- `BRANCH`: Git branch to clone and build
- `IMAGE_TAG`: Tag to apply to the built image
- `BUILD_ARGS`: Build arguments (e.g., NEXT_PUBLIC_BASE_URL)

**Note:** Subnet IDs are not stored in the task definition. They must be provided at runtime via the
`--network-configuration` parameter when running the task.

## Outputs

| Output                    | Description                     |
| ------------------------- | ------------------------------- |
| `task_definition_arn`     | ARN of the ECS task definition  |
| `task_execution_role_arn` | ARN of the task execution role  |
| `task_role_arn`           | ARN of the task IAM role        |
| `security_group_id`       | Security group ID for the task  |
| `cluster_id`              | ECS cluster ID (passed through) |
| `log_group_name`          | CloudWatch log group name       |

## Usage

### Terraform Module

```hcl
module "image_builder" {
  source = "./components/builder"

  ecr_registry     = "123456789.dkr.ecr.us-east-1.amazonaws.com"
  ecr_repository   = "inbox-zero"
  git_repo_url     = "https://github.com/elie222/inbox-zero.git"
  dockerfile_path  = "docker/Dockerfile"

  vpc_id          = module.vpc.vpc_id
  ecs_cluster_id  = module.ecs_cluster.cluster_id
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
