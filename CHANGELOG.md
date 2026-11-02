# Changelog

## [Unreleased]

### Dockerfiles
- `debian/Dockerfile`: fixed missing `samba-ad-provision` package (omitted due to `--no-install-recommends` causing domain provision failure)
- `debian/Dockerfile`: removed duplicate `-y` parameter in `apt-get install`
- `ubuntu/Dockerfile`: fixed base image from `ubuntu:latest` to `ubuntu:24.04` for deterministic builds
- `ubuntu/Dockerfile`: fixed missing `samba-ad-dc` and `samba-ad-provision` packages (required for AD DC functionality)
- `ubuntu/Dockerfile`: added `apt-get upgrade -y` for security patches
- `fedora/Dockerfile`: optimized image size (~100MB+) using `--nodocs` and `--setopt=install_weak_deps=False` and cleaning libdnf5 cache
- `fedora/Dockerfile`: aligned diagnostic toolset with Debian/Ubuntu (`tree`, `jq`, `iputils`)
- `fedora/Dockerfile`: removed unexistent `ccze` package
- All Dockerfiles: added `HEALTHCHECK` using `smbclient -L localhost -N` to verify AD service availability
- All Dockerfiles: standardized labels using OpenContainers (OCI) specification
- All Dockerfiles: enforced script executable permissions with `COPY --chmod=755`

### docker-compose.yml
- All variants: added `build:` section enabling `docker compose up --build`
- All variants: `container_name` now uses `${_CONTAINER_NAME:-samba4-ad}` variable
- All variants: added `security_opt: no-new-privileges:true` to mitigate `SYS_ADMIN` capability
- All variants: ports simplified — only 636/tcp exposed by default; other ports listed commented as reference

### Entrypoints
- `entrypoint.sh`: improved error handling during `samba-tool domain provision` to display actual error logs instead of silencing output
- `entrypoint.sh`: fixed `sed` regex from `log level = 0` to `^[[:space:]]*log level = .*` so it works on every restart regardless of current log level value

### env.example
- Added `_CONTAINER_NAME` variable
