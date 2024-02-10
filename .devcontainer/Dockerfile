# syntax=docker/dockerfile:1.4
ARG IMAGE_LANG=alpine 
ARG IMAGE_VERSION=3.18

FROM ${IMAGE_LANG}:${IMAGE_VERSION}
LABEL maintainer="Mike Glenn <mglenn@ilude.com>"

ARG PUID=1000
ARG PGID=1000

ARG USER=anvil
ARG PROJECT_NAME
ARG HOST_PROJECT_PATH
ARG TZ
ENV USER=${USER}
ENV PROJECT_NAME=${PROJECT_NAME}
ENV HOST_PROJECT_PATH=${HOST_PROJECT_PATH}
ENV TZ=${TZ}

ARG TERM_SHELL=bash
ENV TERM_SHELL=${TERM_SHELL}

ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apk --no-cache add \
  ansible \
  ansible-core-doc \
  ansible-lint \
  bash \
  bash-completion \
  bash-completion-doc \
  bash-doc \
  binutils \
  build-base \
  ca-certificates \
  cmake \
  coreutils \
  curl \
  curl-doc \
  curl-zsh-completion \
  exa \
  extra-cmake-modules \
  findutils \
  git \
  git-crypt \
  git-crypt-doc \
  git-doc \
  github-cli \
  github-cli-doc \
  gnupg \
  helm-bash-completion \
  helm-zsh-completion \
  iproute2 \
  jq \
  just \
  just-bash-completion \
  just-zsh-completion \
  less \
  less-doc \
  linux-headers \
  make \
  make-doc \
  mandoc \
  mandoc-apropos \
  man-pages \
  nano \
  openssl \
  openssh-client \
  py3-pip \
  python3 \
  python3-dev \
  ripgrep \
  rsync \
  shadow \
  sshpass \
  sudo \
  tar \
  tree \
  tzdata \
  util-linux \
  xz \
  yq \
  zsh \
  zsh-autosuggestions \
  zsh-completions \
  zsh-doc \
  zsh-shift-select \
  zsh-syntax-highlighting \
  zsh-syntax-highlighting-doc && \
  rm -rf /var/cache/apk/* && \
  # https://www.jeffgeerling.com/blog/2023/how-solve-error-externally-managed-environment-when-installing-pip3
  sudo rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED  && \
	pip3 install tldr thefuck dircolors
  
# install kubectl
RUN \
  curl -LsO https://storage.googleapis.com/kubernetes-release/release/$(curl -LsS https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl 

# install helm
RUN VERIFY_CHECKSUM=false curl -LsS https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -s

# install terraform
# versioning info from
# https://github.com/devops-infra/docker-terragrunt/blob/master/Dockerfile
RUN \
  release=$( curl -LsS https://releases.hashicorp.com/terraform/ | grep -Eo '/[.0-9]+/' | grep -Eo '[.0-9]+' | sort -V | tail -1 ) && \
  curl -LsS https://releases.hashicorp.com/terraform/${release}/terraform_${release}_linux_amd64.zip -o terraform.zip && \
  unzip terraform.zip && rm terraform.zip && \
  mv terraform /usr/local/bin/terraform 

# install doppler cli
RUN curl -LsS --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sh

RUN addgroup -g ${PGID} ${USER} && \
		adduser -u ${PUID} -G ${USER} -s /bin/${TERM_SHELL} -D ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} && \
    mkdir -p /workspace/${PROJECT_NAME} && \
		ln -s /usr/share/zoneinfo/${TZ} /etc/localtime

ENV HOME=/home/${USER}

COPY --chmod=755 <<-"EOF" /usr/local/bin/docker-entrypoint.sh
#!/bin/bash
set -e
if [ -v DOCKER_ENTRYPOINT_DEBUG ] && [ "$DOCKER_ENTRYPOINT_DEBUG" == 1 ]; then
  set -x
  set -o xtrace
fi

sudo chown -R ${USER}:${USER} ${HOME}/.ssh
sudo chmod 700 ${HOME}/.ssh
sudo chmod -R 600 ${HOME}/.ssh/*

echo "Running: $@"
exec $@
EOF

USER ${USER}

ENV ANSIBLE_HOST_KEY_CHECKING=False
  
# https://code.visualstudio.com/remote/advancedcontainers/start-processes#_adding-startup-commands-to-the-docker-image-instead
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "sleep", "infinity" ]
