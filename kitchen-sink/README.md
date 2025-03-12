# Kitchen Sink App

## Requirements

This app makes use of AWS inferentia instance types. Ensure the account it is
deployed to has quota.

## Sandbox

This app uses karpenter and as such requires some additional permissions. See
[provision.json](https://github.com/nuonco/terraform-aws-eks-sandbox/blob/fd/feat/karpenter-sandbox/artifacts/provision.json)
in the
[`fd/feat/karpenter-sandbox` branch](https://github.com/nuonco/terraform-aws-eks-sandbox/tree/fd/feat/karpenter-sandbox).
