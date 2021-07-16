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

It will shutdown if there are no `ssh` sessions in the container for 5 minutes.

To have persistent terminals, i.e. ones that do not get killed when you disconnect the ssh session, use `tmux`.

> A `tmux` session called `main` is created on startup for convinience.

If you wish to shutdown the container after your task is finished, run the `/shutdown.sh` file.

## Controll

The `/scripts` folder contains utility scripts to controll the behaviour of the container.

|Sctipt|Usage|
|:-:|:-|
|`shutdown.sh`|Shuts down the container.|
|`afktimer.sh <on/off>`|Turns the afk timer on/off. Turn it off when you have a long runnnung task that needs to persist after you disconnect `ssh`.|

The container respects the following runtime environment variables,

|Env. Var.|Usage|
|:-|:-|
|`SSHD_DEBUG`|If present, the `sshd` process runs in debug mode.|
|`AFK_TIMER_DISABLES`|If present, disables the afk timer on start, else enables it.|
|`AFK_TIMEOUT_SECONDS` [default:300]|The number of seconds of AFK after which the container exits.|
|`AFK_CHECK_INTERVAL_SECONDS` [default:60]|The internal poling interval of the AFK timer.|

