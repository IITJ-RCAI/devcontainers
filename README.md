# Development Containers

Powered by,

- [ml-workspace](https://github.com/ml-tooling/ml-workspace)

To use run the following command,

`bash -c "source <(curl -s https://raw.githubusercontent.com/IITJ-RCAI/devcontainers/main/deployment/run.sh)"`

## Shutdown

Please shutdown the devcontainer when your work with it is done.

To shutdown, use the following command in the terminal inside the devcontainer,

`supervisorctl shutdown`

> Note that shutting down the container doesn't delete the Kubectl Job.
