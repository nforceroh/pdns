FROM ghcr.io/nforceroh/alpine-base:3.24

ARG \
  BUILD_DATE=now \
  VERSION=unknown

LABEL \
  maintainer="Sylvain Martin (sylvain@nforcer.com)"

RUN apk add --no-cache \
    mariadb-client \
    pdns \
    pdns-backend-mysql \
    pdns-doc \
    py3-pip \
    python3

ADD --chmod=755 /content/etc/s6-overlay /etc/s6-overlay

# Default DNS ports
EXPOSE 53/udp
EXPOSE 53/tcp
# Default webserver port
EXPOSE 8081/tcp

ENTRYPOINT ["/init"]