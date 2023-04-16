FROM alpine:3.17

ARG USER
ENV USER=${USER}

ARG TERM_SHELL
ENV TERM_SHELL=${TERM_SHELL}

ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENV APP=/app

RUN apk --no-cache add \
  ansible \
  ansible-lint \
  ansible-core-doc \
  bash \
  bash-doc \
  bash-completion \
  bash-completion-doc \
  ca-certificates \
  curl \
  curl-doc \
  curl-zsh-completion \
  git \
  git-doc \
  git-crypt \
  git-crypt-doc \
  github-cli \
  github-cli-doc \
  gnupg \
  helm-zsh-completion \
  helm-bash-completion \
  just \
  just-zsh-completion \
  just-bash-completion \
  make \
  make-doc \
  mandoc man-pages mandoc-apropos less less-doc \
  openssl \
  openssh-client \
  python3 \
  py3-pip \
  sudo \
  tzdata \
  zsh \
  zsh-doc \
  zsh-vcs \
  zsh-completions \
  zsh-shift-select \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-syntax-highlighting-doc && \
  rm -rf /var/cache/apk/*
  
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

RUN \
  adduser --disabled-password --home /home/${USER} --shell /bin/${TERM_SHELL} ${USER} && \
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
  mkdir -p /home/${USER}/.ssh && mkdir -p /home/${USER}/.dotfiles && \
  chmod 700 /home/${USER}/.ssh && \
  mkdir -p ${APP} && \
  mkdir -p /mnt/.devcontainer && chown -R ${USER}:${USER} /mnt/.devcontainer && \
  echo "rm -f /home/${USER}/.bash_profile" >> "/home/${USER}/.bash_profile" && \
  echo "make -f ${APP}/.devcontainer/Makefile" >> "/home/${USER}/.bash_profile" && \
  echo "exec ${TERM_SHELL} -l" >> "/home/${USER}/.bash_profile" && \
  echo "make -f ${APP}/.devcontainer/Makefile" >> "/home/${USER}/.${TERM_SHELL}rc" && \
  echo "source ~/.${TERM_SHELL}rc" >> "/home/${USER}/.${TERM_SHELL}rc" && \
  chown -R ${USER}:${USER} /home/${USER} 

ENV HISTFILE=/mnt/.devcontainer/shell-history
WORKDIR ${APP}/

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER ${USER}:${USER}
  
# https://code.visualstudio.com/remote/advancedcontainers/start-processes#_adding-startup-commands-to-the-docker-image-instead
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "sleep", "infinity" ]
