FROM alpine:3.14



# TODO : Update to latest versions
ARG TERRAFORM_VERSION=0.15.7
ARG TERRAGRUNT_VERSION=0.26.7
ARG TERRAFORM_COMPLIANCE_VERSION=0.6.2
ARG TF_LINT_VERSION=0.18.0
ARG AWS_CLI_VERSION=2.4.5
ARG KOPS_VERSION=1.18.2
ARG YQ_VERSION=4.4.0
ARG JQ_VERSION=1.8
ARG CHECKOV_VERSION=1.2.2

# Install dependencies
RUN apk update && apk add --no-cache git curl bash openssh openssl

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Terraform
RUN curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform.zip
RUN mv terraform /usr/local/bin/

# Install Terragrunt
RUN curl -fsSL -o terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
RUN chmod +x terragrunt
RUN mv terragrunt /usr/local/bin/

# Install Terraform Compliance
RUN curl -fsSL -o terraform-compliance https://github.com/litmuschaos/terraform-compliance/releases/download/${TERRAFORM_COMPLIANCE_VERSION}/terraform-compliance_${TERRAFORM_COMPLIANCE_VERSION}_Linux_x86_64.tar.gz
RUN tar -xf terraform-compliance
RUN mv terraform-compliance /usr/local/bin/

# Install tf-lint
RUN curl -fsSL -o tf-lint https://github.com/terraform-linters/tflint/releases/download/v${TF_LINT_VERSION}/tflint_linux_amd64.zip
RUN unzip tf-lint
RUN mv tflint /usr/local/bin/

# Install AWS CLI
RUN curl -fsSL -o aws-cli-exe https://awscli.amazonaws.com

# Install kaniko
RUN curl -fsSL -o /tmp/kaniko.tar.gz https://github.com/GoogleContainerTools/kaniko/releases/download/v0.12.0/kaniko-v0.12.0.tar.gz
RUN tar -C /tmp -xvzf /tmp/kaniko.tar.gz
RUN mv /tmp/kaniko-v0.12.0/executor /usr/local/bin/kaniko

# Install cosign
RUN curl -fsSL -o cosign.zip https://github.com/shyiko/cosign/releases/download/v1.0.0/cosign-v1.0.0-linux-amd64.zip
RUN unzip cosign.zip
RUN mv cosign /usr/local/bin/
