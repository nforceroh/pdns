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

There are no runtime `ENV` tunables: PowerDNS reads its configuration from
`/etc/pdns/pdns.conf` (override via a bind mount or an inheriting image), and
database credentials belong to the backend configuration, not the image.

## Local development

```sh
make build   # build the image
make test    # build, then run tests/run_tests.sh
make run     # run with 53 (tcp+udp) and 8081 published
```

CI is the only publisher — see
[nforceroh/.github](https://github.com/nforceroh/.github) for the shared build and
cleanup workflows. Published tags: `3.24` (stable pin), `latest`, `main`, date and sha
tags.

