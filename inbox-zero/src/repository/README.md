# ECR Repository for Inbox Zero

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

No modules.

## Resources

| Name                                                                                                                              | Type        |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/ecr_lifecycle_policy) | resource    |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/resources/ecr_repository)             | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/data-sources/caller_identity)     | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.21.0/docs/data-sources/region)                       | data source |

## Inputs

| Name                                                                                                                              | Description                                                                            | Type          | Default        | Required |
| --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ------------- | -------------- | :------: |
| <a name="input_encryption_type"></a> [encryption_type](#input_encryption_type)                                                    | Encryption type (AES256 or KMS)                                                        | `string`      | `"AES256"`     |    no    |
| <a name="input_image_tag_mutability"></a> [image_tag_mutability](#input_image_tag_mutability)                                     | Image tag mutability setting (MUTABLE or IMMUTABLE)                                    | `string`      | `"MUTABLE"`    |    no    |
| <a name="input_kms_key"></a> [kms_key](#input_kms_key)                                                                            | KMS key ARN for encryption (only used if encryption_type is KMS)                       | `string`      | `null`         |    no    |
| <a name="input_lifecycle_policy_max_image_count"></a> [lifecycle_policy_max_image_count](#input_lifecycle_policy_max_image_count) | Maximum number of images to retain (untagged images older than this count are deleted) | `number`      | `10`           |    no    |
| <a name="input_nuon_install_id"></a> [nuon_install_id](#input_nuon_install_id)                                                    | Nuon Install ID                                                                        | `string`      | n/a            |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                                               | AWS Region                                                                             | `string`      | n/a            |   yes    |
| <a name="input_repository_name"></a> [repository_name](#input_repository_name)                                                    | Name of the ECR repository                                                             | `string`      | `"inbox-zero"` |    no    |
| <a name="input_scan_on_push"></a> [scan_on_push](#input_scan_on_push)                                                             | Enable image scanning on push                                                          | `bool`        | `true`         |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                     | Additional tags to apply to the repository                                             | `map(string)` | `{}`           |    no    |

## Outputs

| Name                                                                                                     | Description                                             |
| -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| <a name="output_registry_id"></a> [registry_id](#output_registry_id)                                     | Registry ID where the repository was created            |
| <a name="output_repository_arn"></a> [repository_arn](#output_repository_arn)                            | ARN of the ECR repository                               |
| <a name="output_repository_name"></a> [repository_name](#output_repository_name)                         | Name of the ECR repository                              |
| <a name="output_repository_registry_url"></a> [repository_registry_url](#output_repository_registry_url) | ECR registry URL (account.dkr.ecr.region.amazonaws.com) |
| <a name="output_repository_url"></a> [repository_url](#output_repository_url)                            | URL of the ECR repository                               |
