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
  tzdata \
  openssh-client \
  zsh \
  zsh-autosuggestions\
  zsh-syntax-highlighting && \
  rm -rf /var/cache/apk/*
  