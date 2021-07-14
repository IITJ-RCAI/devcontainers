# Development Containers

Powered by,

- [vscode-micromamba](https://github.com/mamba-org/vscode-micromamba)
- [micromamba](https://github.com/mamba-org/mamba#micromamba)
- [micromamba-docker](https://github.com/mamba-org/micromamba-docker)
- [tmux](https://github.com/tmux/tmux/wiki)
- [supervisor](https://github.com/ochinchina/supervisord)

Container images are defined as mamba spec `yml` files and are located in `images/*` folder.

## Behaviour

The container starts a `ssh` server on startup.

It will shutdown if there are no `tmux` sessions in the container for 5 minutes.

> A `tmux` session called `main` is created on startup for convinience. The output of this `main` session is replicated in the image logs.

If you wish to shutdown the container after your task is finished, run the `/shutdown.sh` file.
