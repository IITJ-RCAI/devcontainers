# syntax=docker/dockerfile:experimental

# Set image arg
# 'image' should point to a .yml file or a folder containing multiple .yml files.
# ARG image='images/default.yml'
ARG PASSWORD='mamba'

# =================
# Base env image
# =================
FROM nvidia/cuda:11.4.0-base-ubuntu20.04 as base
# Use micromamba image
# FROM mambaorg/micromamba:latest as base
ARG PASSWORD

# Fix tz interactive bug
# https://github.com/moby/moby/issues/4032
ARG DEBIAN_FRONTEND=noninteractive

# Install apt packages
USER root
RUN apt-get update \
    && apt-get install -y \
    curl \
    wget \
    build-essential \
    git

# Install micromamba
RUN wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

# Add micromamba user
# https://github.com/mamba-org/micromamba-docker/blob/main/Dockerfile
ENV ENV_NAME="base"
ENV MAMBA_ROOT_PREFIX="/opt/conda"
RUN useradd -ms /bin/bash micromamba && \
    mkdir -p "$MAMBA_ROOT_PREFIX" && \
    chmod -R a+rwx "$MAMBA_ROOT_PREFIX" "/home" && \
    export ENV_NAME="$ENV_NAME"
USER micromamba

# Remove .bashrc interactive session check
RUN sed -i '4,9d' ~/.bashrc

# Update user password
USER root
RUN echo micromamba:${PASSWORD} | chpasswd
USER micromamba

# Enable man docs
# https://unix.stackexchange.com/a/480460
# USER root
# RUN sed -i '/path-exclude \/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/docker \
#     && sed -i '/path-exclude \/usr\/share\/groff/d' /etc/dpkg/dpkg.cfg.d/docker
# USER micromamba


# Install ssh server and other apt packages
USER root
RUN apt-get update \
    && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd \
    && mkdir -p /run/sshd
RUN ssh-keygen -A
    # && chmod -R ugo+r /etc/ssh/*
EXPOSE 22
USER micromamba

# Install tmux terminal
# https://unix.stackexchange.com/questions/479/keep-processes-running-after-ssh-session-disconnects
USER root
RUN apt-get update \
    && apt-get install -y tmux
USER micromamba
# Install tmux config
RUN cd /tmp \
    && git clone https://github.com/samoshkin/tmux-config.git \
    && ./tmux-config/install.sh

# Install supervisor
USER root
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord
# RUN apt-get update \
#     && apt-get install -y supervisor \
# RUN chmod -R ugo+rw /var/*
COPY scripts/supervisor.conf /etc/supervisor/supervisord.conf
USER micromamba

# Rename the user
# RUN usermod -l $USERNAME micromamba \
#     # Update home links
#     && usermod -d /home/$USERNAME -m $USERNAME

# Install Powershell
# USER root
# RUN apt-get update \
#     && apt-get install -y curl gnupg apt-transport-https \
#     && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#     && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list' \
#     && apt-get update \
#     && apt-get install -y powershell
# USER micromamba

# [Optional] Add sudo support. Omit if you don't need to install software after connecting.
# USER root
# RUN apt-get install -y sudo \
#     && echo micromamba ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/micromamba \
#     && chmod 0440 /etc/sudoers.d/micromamba
# USER micromamba

# Clear apt cache
USER root
RUN apt-get clean autoclean \
    && apt-get autoremove --yes
    # rm -rf /var/lib/{apt,dpkg,cache,log}/
USER micromamba

# Copy scripts to image
USER root
COPY scripts /scripts
RUN chmod -R a+rwx /scripts/*
USER micromamba

# Init. micromamba shell
RUN micromamba shell init -s bash -p /home/micromamba/micromamba
SHELL ["/bin/bash", "-c"]

# Set entrypoint
ENTRYPOINT [ "/scripts/internal/entrypoint.sh" ]
# Set root as final user to fix permisions
USER root

# ====================
# Install envs in image
# ====================
# ARG image

# # Copy image specs
# COPY ${image} /images/${image}

# # Install conda envs
# # TODO: Use dynamic userid values here
# RUN --mount=type=cache,target=/home/micromamba/micromamba/pkgs,uid=1000,gid=1000 \
#     source ~/.bashrc \
#     # Iterate over all .yml files recursively
#     && for file in /images/**/*;\
#         do \
#         NAME=$(grep -Pio '^name: *\K.*' "$file" | head -1); \
#         # If name is 'base' then update base else create new environment
#             if [[ $NAME == base ]]; \
#             then \
#                 micromamba install -y -n base -f "$file"; \
#             else \
#                 micromamba create -f "$file"; \
#             fi \
#         done \
#         # Log everything to ~/env_install.log
#         2>&1 | tee ~/env_install.log
