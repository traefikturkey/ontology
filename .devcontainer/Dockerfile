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
  openssh-client \
  sudo \
  tzdata \
  zsh \
  zsh-autosuggestions\
  zsh-syntax-highlighting && \
  rm -rf /var/cache/apk/*
  
# setup local timezone

RUN \
  adduser --disabled-password --home /home/${USER} --shell /bin/zsh ${USER} && \
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
  mkdir -p /home/${USER}/.ssh && \
  ln -snf /run/secrets/user_ssh_key /home/${USER}/.ssh/id_ed25519 && \
  chown -R ${USER}:${USER} /home/${USER} && \
  chmod 700 /home/${USER}/.ssh && \
  ln -snf /etc/localtime /usr/share/zoneinfo/${TZ} && echo ${TZ} > /etc/timezone 

USER ${USER}:${USER}

#CMD ["/bin/zsh"]