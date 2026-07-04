# Changelog

## [Unreleased]

### Dockerfiles
- `ubuntu/Dockerfile`: fixed base image from `ubuntu:latest` to `ubuntu:24.04` for deterministic builds
- `ubuntu/Dockerfile`, `debian/Dockerfile`: fixed broken `COPY ../entrypoint.sh` → `COPY entrypoint.sh` (path was outside build context)
- `fedora/Dockerfile`: removed unnecessary `hostname` package
- All Dockerfiles: added `HEALTHCHECK` to monitor samba process
- All Dockerfiles: removed redundant comments

### docker-compose.yml
- All variants: added `build:` section enabling `docker compose up --build`
- All variants: `container_name` now uses `${_CONTAINER_NAME:-samba4-ad}` variable
- All variants: added `security_opt: no-new-privileges:true` to mitigate `SYS_ADMIN` capability
- All variants: ports simplified — only 636/tcp exposed by default; other ports listed commented as reference

### Entrypoints
- All entrypoint.sh: fixed `sed` regex from `log level = 0` to `^[[:space:]]*log level = .*` so it works on every restart regardless of current log level value

### env.example
- Added `_CONTAINER_NAME` variable
- Added port override variables (`_DNS_PORT`, `_KERBEROS_PORT`, etc.) for when ports are uncommented
