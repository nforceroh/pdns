FROM ghcr.io/nforceroh/alpine-base:3.24

ARG \
  BUILD_DATE=now \
  VERSION=unknown

LABEL \
  org.label-schema.maintainer="Sylvain Martin (sylvain@nforcer.com)" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.vcs-url="https://github.com/nforceroh/pdns" \
  org.label-schema.vcs-ref="${VERSION}" \
  org.label-schema.schema-version="1.0"

ENV \
  PDNS_API_URL="" \
  PDNS_API_KEY=""

### Install Dependencies
RUN \
  apk add --no-cache \
    mariadb-client \
    pdns \
    pdns-backend-mysql \
    pdns-doc \
    py3-pip \
    python3 \
  && rm -rf /var/cache/apk/*

### Add Files
ADD --chmod=755 /content/etc/s6-overlay /etc/s6-overlay

### Services
ADD --chmod=755 /content/etc/s6-overlay/s6-rc.d /etc/s6-rc.d

# Default DNS ports
EXPOSE 53/udp
EXPOSE 53/tcp
# Default webserver port
EXPOSE 8081/tcp

ENTRYPOINT ["/init"]