# ECS Cluster

Terraform module that creates an ECS cluster with mixed capacity providers for different workload types.

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | = 6.21.0  |

## Providers

| Name                                             | Version  |
| ------------------------------------------------ | -------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | = 6.21.0 |

## Modules

| Name                                                                 | Source                        | Version |
| -------------------------------------------------------------------- | ----------------------------- | ------- |
| <a name="module_ecs_cluster"></a> [ecs_cluster](#module_ecs_cluster) | terraform-aws-modules/ecs/aws | ~> 5.0  |

## Resources

| Name                                                                                                                                                  | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_autoscaling_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/autoscaling_group)                            | resource    |
| [aws_iam_instance_profile.ecs_instance](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/iam_instance_profile)             | resource    |
| [aws_iam_role.ecs_instance](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.ecs_instance](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_launch_template.ecs](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/launch_template)                                | resource    |
| [aws_security_group.ecs_instances](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/security_group)                        | resource    |
| [aws_security_group_rule.ecs_from_alb](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/security_group_rule)               | resource    |
| [aws_ssm_parameter.ecs_optimized_ami](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/data-sources/ssm_parameter)                   | data source |

## Inputs

| Name                                                                                             | Description                                                | Type           | Default        | Required |
| ------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- | -------------- | -------------- | :------: |
| <a name="input_alb_security_group_id"></a> [alb_security_group_id](#input_alb_security_group_id) | Security group ID of the ALB (optional, for ingress rules) | `string`       | `null`         |    no    |
| <a name="input_ecs_desired_capacity"></a> [ecs_desired_capacity](#input_ecs_desired_capacity)    | Desired number of EC2 instances in the ECS cluster         | `number`       | `2`            |    no    |
| <a name="input_ecs_instance_type"></a> [ecs_instance_type](#input_ecs_instance_type)             | EC2 instance type for ECS container instances              | `string`       | `"t3.medium"`  |    no    |
| <a name="input_ecs_max_size"></a> [ecs_max_size](#input_ecs_max_size)                            | Maximum number of EC2 instances in the ECS cluster         | `number`       | `4`            |    no    |
| <a name="input_ecs_min_size"></a> [ecs_min_size](#input_ecs_min_size)                            | Minimum number of EC2 instances in the ECS cluster         | `number`       | `1`            |    no    |
| <a name="input_nuon_install_id"></a> [nuon_install_id](#input_nuon_install_id)                   | Nuon Install ID                                            | `string`       | n/a            |   yes    |
| <a name="input_prefix"></a> [prefix](#input_prefix)                                              | Prefix for resource names                                  | `string`       | `"inbox-zero"` |    no    |
| <a name="input_private_subnet_ids"></a> [private_subnet_ids](#input_private_subnet_ids)          | List of private subnet IDs for ECS EC2 instances           | `list(string)` | n/a            |   yes    |
| <a name="input_region"></a> [region](#input_region)                                              | AWS Region                                                 | `string`       | n/a            |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                    | Tags to apply to all resources                             | `map(string)`  | `{}`           |    no    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                              | VPC ID where ECS cluster will be deployed                  | `string`       | n/a            |   yes    |

## Outputs

| Name                                                                                                                          | Description                                           |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| <a name="output_autoscaling_group_arn"></a> [autoscaling_group_arn](#output_autoscaling_group_arn)                            | ARN of the Auto Scaling Group for EC2 instances       |
| <a name="output_autoscaling_group_name"></a> [autoscaling_group_name](#output_autoscaling_group_name)                         | Name of the Auto Scaling Group for EC2 instances      |
| <a name="output_capacity_providers"></a> [capacity_providers](#output_capacity_providers)                                     | List of capacity providers configured for the cluster |
| <a name="output_cluster_arn"></a> [cluster_arn](#output_cluster_arn)                                                          | ECS cluster ARN                                       |
| <a name="output_cluster_id"></a> [cluster_id](#output_cluster_id)                                                             | ECS cluster ID                                        |
| <a name="output_cluster_name"></a> [cluster_name](#output_cluster_name)                                                       | ECS cluster name                                      |
| <a name="output_ecs_instance_role_arn"></a> [ecs_instance_role_arn](#output_ecs_instance_role_arn)                            | IAM role ARN for ECS EC2 instances                    |
| <a name="output_ecs_instance_role_name"></a> [ecs_instance_role_name](#output_ecs_instance_role_name)                         | IAM role name for ECS EC2 instances                   |
| <a name="output_ecs_instance_security_group_id"></a> [ecs_instance_security_group_id](#output_ecs_instance_security_group_id) | Security group ID for ECS EC2 instances               |

## Workload Types

### Long-lived Services (EC2 Capacity Provider)

1. Inbox Zero App
2. Inbox Zero Web

### Ephemeral Tasks (Fargate Capacity Provider)

1. Builder (on-demand image builds)

## Architecture

This module creates an ECS cluster with three capacity providers:

1. **EC2 (default)** - Auto-scaled EC2 instances for steady-state, long-lived services
2. **FARGATE** - On-demand Fargate tasks for ephemeral workloads
3. **FARGATE_SPOT** - Cost-optimized Fargate Spot for flexible ephemeral workloads

### Capacity Provider Strategy

- **Default**: EC2 capacity provider (weight: 100, base: 1)

  - Long-lived services (App, Web) automatically use EC2 instances
  - Cost-effective for predictable workloads
  - Auto-scales based on cluster utilization (target: 80%)

- **Explicit**: Fargate capacity providers (weight: 0)
  - Builder task explicitly requests Fargate
  - No persistent infrastructure cost
  - Only runs when triggered

## Components

### EC2 Infrastructure

- **Auto Scaling Group**: Manages EC2 container instances
- **Launch Template**: Uses ECS-optimized Amazon Linux 2 AMI
- **IAM Role**: Container instance role with ECS permissions
- **Security Group**: Allows egress and optional ALB ingress

### Cluster Configuration

- **Managed Scaling**: Automatic capacity management
- **Termination Protection**: Enabled for EC2 instances
- **CloudWatch Container Insights**: Available for monitoring

## Inputs/Variables

| Variable                | Description                          | Type         | Default     | Required |
| ----------------------- | ------------------------------------ | ------------ | ----------- | -------- |
| `prefix`                | Prefix for resource names            | string       | -           | yes      |
| `vpc_id`                | VPC ID for ECS cluster               | string       | -           | yes      |
| `private_subnet_ids`    | Private subnet IDs for EC2 instances | list(string) | -           | yes      |
| `alb_security_group_id` | ALB security group for ingress rules | string       | null        | no       |
| `ecs_instance_type`     | EC2 instance type                    | string       | "t3.medium" | no       |
| `ecs_min_size`          | Min EC2 instances                    | number       | 1           | no       |
| `ecs_max_size`          | Max EC2 instances                    | number       | 4           | no       |
| `ecs_desired_capacity`  | Desired EC2 instances                | number       | 2           | no       |
| `tags`                  | Tags for all resources               | map(string)  | {}          | no       |

## Outputs

| Output                           | Description                         |
| -------------------------------- | ----------------------------------- |
| `cluster_id`                     | ECS cluster ID                      |
| `cluster_arn`                    | ECS cluster ARN                     |
| `cluster_name`                   | ECS cluster name                    |
| `autoscaling_group_name`         | ASG name                            |
| `autoscaling_group_arn`          | ASG ARN                             |
| `ecs_instance_security_group_id` | Security group ID for EC2 instances |
| `ecs_instance_role_arn`          | IAM role ARN for EC2 instances      |
| `capacity_providers`             | Map of available capacity providers |

## Usage

```hcl
module "ecs_cluster" {
  source = "./components/ecs_cluster"

  prefix             = "inbox-zero"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  alb_security_group_id = module.alb.security_group_id

  ecs_instance_type    = "t3.medium"
  ecs_min_size         = 1
  ecs_max_size         = 4
  ecs_desired_capacity = 2

  tags = {
    Environment = "production"
    Project     = "inbox-zero"
  }
}
```

## Service Deployment Examples

### Long-lived Service (uses EC2 by default)

```hcl
resource "aws_ecs_service" "app" {
  name            = "inbox-zero-app"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2

  # No capacity provider specified = uses default EC2
  # Or explicitly specify:
  capacity_provider_strategy {
    capacity_provider = "ec2"
    weight           = 100
    base             = 1
  }
}
```

### Ephemeral Task (explicitly use Fargate)

```hcl
# Trigger builder task
resource "null_resource" "build_trigger" {
  provisioner "local-exec" {
    command = <<-EOT
      aws ecs run-task \
        --cluster ${module.ecs_cluster.cluster_id} \
        --task-definition builder \
        --launch-type FARGATE \
        --capacity-provider-strategy capacityProvider=FARGATE,weight=1
    EOT
  }
}
```

## Cost Optimization

### EC2 Capacity Provider

- Runs continuously for long-lived services
- Managed scaling optimizes instance count
- Cost: ~$30-60/month for t3.medium (depending on hours)

### Fargate Capacity Provider

- Zero cost when not running
- Pay only during task execution
- Typical builder cost: $0.01-0.02 per build

## Security Features

- **IMDSv2**: Enforced on EC2 instances (hop limit: 1)
- **Termination Protection**: Enabled for managed instances
- **Security Groups**: Isolated egress, controlled ingress
- **IAM Roles**: Least-privilege permissions for instances and tasks
