# Nuon Demo

## Overview

This contains source code and Nuon config for a simple web service, and a couple installations of that service. It's purpose is to demonstrate how to package, deploy, and maintain an app for BYOC.

### Project Structure

- `/.github/workflows`: Basic automation using our Github Action.
- `/src`: The source code for a simple web service.
- `/nuon`: Nuon config files for packaging the service for deployment to customer AWS accounts.
  - `installer.toml`: The installer config. This drives a UI at [https://demo-installer.vercel.app/](https://demo-installer.vercel.app/), which is using our [open-source installer project](https://github.com/nuonco/installer).
  - `/nuon.aws-ecs-app.toml`: Packages the app for stand-alone, turn-key deployment to AWS.
  - `/nuon.aws-ecs-byovpc.toml`: Packages the app for deployment to a customer's existing VPC.
  - `/components`: Config for pulling the app code from the `/src` directory.

## Getting Started

You can fork this repo to test-drive Nuon, and get some hands-on experience with the BYOC development flow.

First, set up your Nuon account.

1. Request a Nuon account.
1. Once your account is created, log into the dashboard.
1. Install the Nuon CLI.
1. Run `nuon login` to authenticate from the CLI.

Then, create an app using the config files in this repo.

1. Fork this repo.
1. Clone your fork.
1. Go to the [./nuon](./nuon) directory.
1. Run `nuon apps create --name="aws-ecs-app"`
1. Delete the template file created by the CLI, since we already have a config file at [./nuon/nuon.aws-ecs-app.toml](./nuon/nuon.aws-ecs-app.toml).
1. In the [./nuon](./nuon) directory run `nuon apps sync --file=nuon.aws-ecs-app.toml`.
1. Run `nuon apps select` to select the app you just created.

The app is now ready to be deployed to a cloud account.

1. Log into an AWS account.
1. Go the [./installer](./installer) directory.
1. Copy the `.env.local.sample` to `.env.local`.
1. Update the env vars in `.env.local` with the IDs from your `~/.nuon` file.
1. Run `npm run dev` to start the installer.
1. Navigate to the localhost URL that is logged to the terminal.
1. Follow the steps in the UI to create an install of the app. Do this as many times as you would like to create multiple installs.

Once you have a running install, you can make updates to it.

1. Create a branch and make some changes to the source code, the Nuon config, or both.
1. Commit and open a pull request. This will trigger PR checks to test and validate the code.
1. Merge your PR. Github Actions will sync the config files, create new builds, and update all of your installs.
