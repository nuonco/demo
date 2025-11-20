# ECR Configuration
# Note: This module does not create the ECR repository itself.
# It only configures permissions to push to the specified repository.
# The repository should be created separately or passed as a variable.

data "aws_ecr_repository" "target" {
  name = var.ecr_repository
}
