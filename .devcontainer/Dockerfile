# syntax=docker/dockerfile:1.3-labs 
FROM alpine:3.17

ARG USER=anvil
ENV USER=${USER}
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TZ=America/New_York
ENV APP=/app

RUN apk --no-cache add \
  ansible \
  bash \
  bash-completion \
  ca-certificates \
  curl \
  git \
  just \
  make \
  openssl \
  openssh-client \
  python3 \
  py3-pip \
  sudo \
  tzdata \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting && \
  rm -rf /var/cache/apk/*
  
# install kubectl
RUN \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl 

# install helm
RUN VERIFY_CHECKSUM=false curl -L https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -s

# install terraform
# versioning info from
# https://github.com/devops-infra/docker-terragrunt/blob/master/Dockerfile
RUN \
  release=$( curl -LsS https://releases.hashicorp.com/terraform/ | grep -Eo '/[.0-9]+/' | grep -Eo '[.0-9]+' | sort -V | tail -1 ) && \
  curl -LsS https://releases.hashicorp.com/terraform/${release}/terraform_${release}_linux_amd64.zip -o terraform.zip && \
  unzip terraform.zip && rm terraform.zip && \
  mv terraform /usr/local/bin/terraform 

RUN \
  adduser --disabled-password --home /home/${USER} --shell /bin/zsh ${USER} && \
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
  mkdir -p /home/${USER}/.ssh && \
  ln -snf /run/secrets/user_ssh_key /home/${USER}/.ssh/id_ed25519 && \
  chown -R ${USER}:${USER} /home/${USER} && \
  chmod 700 /home/${USER}/.ssh && \
  mkdir -p ${APP} && \
  chown -R ${USER}:${USER} ${APP} && \
  echo "make -f ./.devcontainer/Makefile" > /home/${USER}/.zshenv && \
  ln -snf /etc/localtime /usr/share/zoneinfo/${TZ} && echo ${TZ} > /etc/timezone

WORKDIR ${APP}/

COPY --chmod=755 <<-"EOF" /usr/local/bin/docker-entrypoint.sh
#!/bin/bash
set -e
if [ -v DOCKER_ENTRYPOINT_DEBUG ] && [ "$DOCKER_ENTRYPOINT_DEBUG" == 1 ]; then
  set -x
  set -o xtrace
fi

if [ ! -z "$DOTFILE_OVERRIDE_URL" ]; then
  cd ~/.dotfiles/ && git remote set-url origin $DOTFILE_OVERRIDE_URL
fi

sudo chown -R $USER:$USER $APP

echo "Running: $@"
exec $@
EOF

USER ${USER}:${USER}

ARG DOTFILES_URL
RUN \
  git clone ${DOTFILES_URL} /home/${USER}/.dotfiles && \
  ~/.dotfiles/install
  
# https://code.visualstudio.com/remote/advancedcontainers/start-processes#_adding-startup-commands-to-the-docker-image-instead
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "sleep", "infinity" ]