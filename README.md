# pdns

Authoritative DNS server image in the portfolio: PowerDNS with the MySQL backend
client tooling, on [alpine-base](https://github.com/nforceroh/alpine-base) with
s6-overlay running the daemon.

Pin it by tag:

```dockerfile
FROM ghcr.io/nforceroh/pdns:3.24
```

## What's inside

- PowerDNS authoritative server (`pdns_server`) with the MySQL backend
  (`pdns-backend-mysql`) and `mariadb-client` for schema provisioning
- `python3` / `py3-pip` for zone-management tooling
- PowerDNS documentation package

## Runtime layout

| Path | Purpose |
| --- | --- |
| `/etc/pdns/pdns.conf` | PowerDNS configuration, provided by the Alpine package |
| `/etc/s6-overlay/s6-rc.d/powerdns` | s6 longrun that starts `pdns_server` in the foreground |

## Services

s6-overlay runs one longrun, dependent on the base's `user` init:

- `powerdns` — `pdns_server` in the foreground

## Ports

| Port | Protocol | Purpose |
| --- | --- | --- |
| `53` | udp + tcp | DNS queries |
| `8081` | tcp | PowerDNS built-in webserver / API |

## Build-time tunables

| ARG | Default | Description |
| --- | --- | --- |
| `BUILD_DATE` | `now` | label metadata |
| `VERSION` | `unknown` | label metadata; CI passes the build date |

The Dockerfile declares `PDNS_API_URL` and `PDNS_API_KEY` as empty defaults,
but the bundled PowerDNS service and configuration do not consume them. They
do not configure or enable the PowerDNS API. Configure PowerDNS through
`/etc/pdns/pdns.conf` (or an override/mount), including any API settings and
database credentials required by your deployment.

The image does not declare a configuration volume. Mount the configuration
file read-only if you want to supply a deployment-specific configuration:

```sh
docker run -d --name pdns \
  --restart unless-stopped \
  -p 53:53/tcp -p 53:53/udp -p 8081:8081/tcp \
  -v "$PWD/pdns.conf:/etc/pdns/pdns.conf:ro" \
  ghcr.io/nforceroh/pdns:latest
```

The example publishes the PowerDNS webserver port as well as DNS; restrict
port `8081` to trusted management clients and enable/configure it deliberately.

## Local development

```sh
make build   # build the image
make test    # build, then run tests/run_tests.sh
make run     # run with 53 (tcp+udp) and 8081 published
```

For a working authoritative DNS service, supply a valid PowerDNS configuration
with a backend and zone data. The local `make run` target only publishes ports;
it does not configure a DNS backend or create zones.

CI is the only publisher — see
[nforceroh/.github](https://github.com/nforceroh/.github) for the shared build and
cleanup workflows. Published tags: `3.24` (stable pin), `latest`, `main`, date and sha
tags.
