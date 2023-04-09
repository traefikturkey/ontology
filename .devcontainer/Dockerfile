# syntax=docker/dockerfile:1.3-labs 
FROM alpine:3.17

ARG USER=anvil
ENV USER=${USER}
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TZ=America/New_York
ENV APP=/app
WORKDIR ${APP}/

RUN apk --no-cache add \
  bash \
  bash-completion \
  ca-certificates \
  curl \
  git \
  openssl \
  openssh-client \
  sudo \
  tzdata \
  zsh \
  zsh-autosuggestions\
  zsh-syntax-highlighting && \
  rm -rf /var/cache/apk/*
  
# install kubectl
RUN \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl 

# install helm
RUN VERIFY_CHECKSUM=false curl -L https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -s


RUN \
  adduser --disabled-password --home /home/${USER} --shell /bin/zsh ${USER} && \
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
  mkdir -p /home/${USER}/.ssh && \
  ln -snf /run/secrets/user_ssh_key /home/${USER}/.ssh/id_ed25519 && \
  chown -R ${USER}:${USER} /home/${USER} && \
  chmod 700 /home/${USER}/.ssh && \
  ln -snf /etc/localtime /usr/share/zoneinfo/${TZ} && echo ${TZ} > /etc/timezone

COPY gitconfig /etc/gitconfig

USER ${USER}:${USER}

COPY zshrc /home/$USER/.zshrc

#CMD ["/bin/zsh"]