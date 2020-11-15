ARG ALPINE_VERSION=3.12
ARG PYTHON_VERSION=3.9

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}
WORKDIR /code
ENTRYPOINT ["/bin/zsh"]

ARG ANSIBLE_VERSION=2.9.15

RUN \
  apk --update add \
    ca-certificates \
    make \
    openssh-client \
    zsh && \
  apk add --virtual .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base && \
  pip3 install ansible==${ANSIBLE_VERSION}  && \
  apk del .build-deps && rm -rf /var/cache/* /root/cache/* && mkdir /var/cache/apk

COPY . .
RUN INSIDE_CONTAINER=1 make build_env

