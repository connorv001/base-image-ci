# base-image-ci


This Dockerfile builds an image with the following tools installed:

- git
- kubectl
- terraform
- helm
- terragrunt
- terraform-compliance
- tf-lint
- aws-cli
- kops
- yq
- jq
- checkov
- terraform cost
- kaniko
- cosign

All of the tool versions are specified as arguments, so you can customize the version of each tool that gets installed.