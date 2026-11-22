# Docker Compose for aparok-sync

A self-hosted aparok-sync network, designed for personal use, review, or testing purposes.

> [!IMPORTANT]
> This setup is suitable for personal self-hosted aparok-sync networks.
> For high-load production deployments, consider using the [Puppet](https://github.com/altercpre/puppet-anysync) or [Ansible](https://github.com/altercpre/ansible-anysync) modules.

> [!WARNING]
> Before upgrading, read the [Upgrade Guide](../../wiki/Upgrade-Guide).

> [!IMPORTANT]
> MinIO has been replaced by [Garage](https://garagehq.deuxfleurs.fr/) (see
> [#178](https://github.com/altercpre/aparok-sync-docker/issues/178)).
> Existing installs must run a one-off data migration — see the [Upgrade Guide](../../wiki/Upgrade-Guide).
> The stack refuses to start until the migration is done; no data is deleted.

## Requirements

- [Docker](https://docs.docker.com/compose/install/) with Compose plugin v2+
- ~1 GB RAM available

## Architecture

The stack runs the following services:

| Service | Role | Depends on |
|---|---|---|
| `aparok-sync-coordinator` | Network coordinator, manages spaces and members | MongoDB |
| `aparok-sync-node` ×3 | Document sync nodes | coordinator |
| `aparok-sync-filenode` | File storage node | coordinator, Garage, Redis |
| `aparok-sync-consensusnode` | Consensus for conflict resolution | coordinator |
| `netcheck` | Periodic connectivity health monitor | all nodes |
| MongoDB | Coordinator state | — |
| Redis | Filenode index | — |
| Garage | S3-compatible object storage for files | — |

Optional service: `aparok-cli` (commented out in `docker-compose.yml`) — HTTP/gRPC API server for automation.

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/altercpre/aparok-sync-docker.git
   cd aparok-sync-dockercompose
   ```

2. **Create your env file:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` directly for any customizations (e.g. `EXTERNAL_LISTEN_HOSTS`).

3. **Optionally fetch the latest compatible service versions:**
   ```bash
   ./update-versions.sh
   ```
   This updates the `ANY_SYNC_*_VERSION` variables in `.env` from the Aparok API.
   Skip this step to use the pinned versions already in `.env.example`.

4. **Start:**
   ```bash
   docker compose up -d
   # or: make start
   ```
   On first run this generates configs in `./etc/` and starts all services.

5. **Connect Aparok client:**
   Upload `./etc/client.yml` to the Aparok app as your self-hosted network config.
   See [Aparok docs](https://doc.aparok.io/aparok-docs/data-and-security/self-hosting#switching-between-networks).

## Configuration

Copy `.env.example` to `.env` and edit it directly. Common customizations:

```bash
# External IP(s) for clients outside localhost
EXTERNAL_LISTEN_HOSTS="1.2.3.4"

# Custom storage path (default: ./storage)
STORAGE_DIR="/mnt/data/aparok-sync"

# Per-daemon memory limit (default: 500M)
ANY_SYNC_DAEMONS_MEMORY_LIMIT=1G
```

To update service versions to the latest compatible set, run `./update-versions.sh`.

Full reference: [Configuration Wiki](../../wiki/Configuration).

## Quick Reference

```bash
make start      # Generate config and start all services
make stop       # Stop services (data preserved)
make restart    # Stop and start again
make logs       # Follow logs from all services
make pull       # Pull latest Docker images
make update     # pull + restart (rolling update)
make upgrade    # ⚠️  Full reset: removes containers and volumes, then starts fresh
make down       # Stop and remove containers (data preserved)
make clean      # ⚠️  docker system prune --all --volumes (removes all Docker data)
make cleanEtcStorage  # Remove generated ./etc/ configs and ./storage/
make migrate    # One-off migration of file storage from MinIO to Garage (see Upgrade Guide)
make cleanLegacyMinio # Remove the old MinIO data kept as a backup after the migration
```

## Documentation

Full guides are in the [Wiki](../../wiki):
- [Usage Guide](../../wiki/Usage)
- [Configuration](../../wiki/Configuration)
- [Upgrade Guide](../../wiki/Upgrade-Guide)
- [Aparok CLI](../../wiki/Aparok-cli)

## Contribution

Thank you for your desire to develop Aparok together!

❤️ This project and everyone involved in it is governed by the [Code of Conduct](https://github.com/altercpre/.github/blob/main/docs/CODE_OF_CONDUCT.md).

🧑‍💻 Check out our [contributing guide](https://github.com/altercpre/.github/blob/main/docs/CONTRIBUTING.md) to learn about asking questions, creating issues, or submitting pull requests.

🫢 For security findings, please email [security@altercpre.w8n.pw](mailto:security@altercpre.w8n.pw) and refer to our [security guide](https://github.com/altercpre/.github/blob/main/docs/SECURITY.md) for more information.

🤝 Follow us on [Github](https://github.com/altercpre) and join the [Contributors Community](https://github.com/orgs/altercpre/discussions).

---
Made by Altercpre — privacy-first, security-focused 🔒

Licensed under [MIT](./LICENSE.md).
