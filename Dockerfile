## Shubham's base image for CI Related Operations.
FROM debian:buster


# Build arguments, which are used to control version numbers.
ARG VERSION_TERRAFORM=1.3.3
ARG VERSION_TFLINT=0.18.0
ARG VERSION_AWS_CLI=1.16
ARG VERSION_CHECKOV=1.0.484
ENV KUBE_VERSION=1.25.3
ENV HELM_VERSION=3.10.1
ENV YQ_VERSION=4.28.2
ENV TARGETOS=linux
ENV TARGETARCH=amd64
ENV KOPS_VERSION=v1.23.0

# Install some common tools we'll need for builds.
# Also install tools needed to use this as a CircleCI 2 build image. See:
#   https://circleci.com/docs/2.0/custom-images/
RUN apt-get update -qq && apt-get install -qq -y \
    make \
    wget \
    git \
    ssh \
    tar \
    gzip \
    unzip \
    ca-certificates \
    python3-dev \
    python3-pip \
    shellcheck \
    curl

# Basic Tools:
RUN apt-get update \
    && apt-get install --auto-remove -y wget curl jq \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    && wget -q https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETOS}_${TARGETARCH} -O /usr/local/bin/yq \
    && chmod +x /usr/local/bin/helm /usr/local/bin/kubectl /usr/local/bin/yq  \
    && curl -O --location --silent --show-error https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
    && mv kops-linux-amd64 /usr/local/bin/kops 
RUN \
    # Install jq-1.6 (final release)
    curl -s -L -o /tmp/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    mv /tmp/jq /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq

# Install Terraform.
RUN wget -q https://releases.hashicorp.com/terraform/${VERSION_TERRAFORM}/terraform_${VERSION_TERRAFORM}_linux_amd64.zip
RUN unzip terraform_${VERSION_TERRAFORM}_linux_amd64.zip
RUN install terraform /usr/local/bin
RUN terraform -v

# Install tflint.
RUN wget -q https://github.com/wata727/tflint/releases/download/v${VERSION_TFLINT}/tflint_linux_amd64.zip
RUN unzip tflint_linux_amd64.zip
RUN install tflint /usr/local/bin
RUN chmod ugo+x /usr/local/bin/tflint
RUN tflint -v

# Install Checkov.
RUN pip3 install --upgrade setuptools
RUN pip3 install checkov==${VERSION_CHECKOV}
RUN checkov -v

# Install the AWS CLI.
RUN pip3 install awscli==${VERSION_AWS_CLI}

# Install the Azure CLI.
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash


# INstall Infracost

RUN     wget -qO- wget https://github.com/infracost/infracost/releases/download/v0.10.13/infracost-linux-amd64.tar.gz | tar zxv && \
        chmod 700 infracost-linux-amd64 && \
        cp ./infracost-linux-amd64 /bin/infracost


# Install ArgoCD CLI
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 &&\
    install -m 555 argocd-linux-amd64 /usr/local/bin/argocd && \
    rm argocd-linux-amd64
