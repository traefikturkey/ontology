FROM alpine:3.17

ARG USER=anvil
ENV USER=${USER}
ENV TZ=America/New_York
WORKDIR /app/

RUN apk --no-cache add \
  bash \
  bash-completion \
  ca-certificates \
  curl \
  git \
  tzdata \
  zsh \
  zsh-autosuggestions\
  zsh-syntax-highlighting && \
  rm -rf /var/cache/apk/*
  