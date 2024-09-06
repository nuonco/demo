# Nuon Demo

## Overview

This contains source code and Nuon config for a simple web service, and a couple installations of that service. It's purpose is to demonstrate how to package, deploy, and maintain an app for BYOC.

## Project Structure

- `/.github/workflows`: Basic automation using our Github Action.
- `/src`: The source code for a simple web service.
- `/nuon`: Nuon config files for packaging the service for deployment to customer AWS accounts.
  - `installer.toml`: The installer config. This drives a UI at [https://demo-installer.vercel.app/](https://demo-installer.vercel.app/), which is using our [open-source installer project](https://github.com/nuonco/installer).
  - `/nuon.aws-ecs-app.toml`: Packages the app for stand-alone, turn-key deployment to AWS.
  - `/nuon.aws-ecs-byovpc.toml`: Packages the app for deployment to a customer's existing VPC.
  - `/components`: Config for pulling the app code from the `/src` directory.

## Development Flow

The process to make updates to the app, and release them to customers.

1. Create a branch and make some changes to the source code, the Nuon config, or both.
1. **Optional** Create a test install, and use the Nuon CLI to deploy manually to test your changes.
1. Commit and open a pull request. This will trigger PR checks to test and validate the code.
1. Merge your PR. Github Actions will sync the config files, create new builds, and update the staging install.
1. When you're ready to release to customers, trigger the release workflow, which will release the latest builds to all active installs one at a time.
