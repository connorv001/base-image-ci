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


To build the image, run the following command:

```
Copy codedocker build -t my-tools-image .
```

Replace my-tools-image with the name you want to give to the built image.

You can then run the image with the following command:

```
Copy codedocker run -it my-tools-image
```

This will give you a shell inside the container with all of the tools installed and ready to use.