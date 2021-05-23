# syntax=docker/dockerfile:experimental

# Set base image arg, allowed values: cpu, gpu
ARG base_arc=cpu
# Set base image library, allowed values: pytorch, tf
ARG base_lib=pytorch
# Non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID


# See: https://cloud.google.com/deep-learning-containers/docs/choosing-container
FROM gcr.io/deeplearning-platform-release/${base_lib}-${base_arc} as base
# Add google apt gpg key
# See: https://groups.google.com/g/gce-discussion/c/zeGb4gdK2Iw
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# See: https://code.visualstudio.com/docs/remote/containers-advanced#_creating-a-nonroot-user
# Non-root user
ARG USERNAME
ARG USER_UID
ARG USER_GID
# Rename the user
RUN usermod -l $USERNAME jupyter \
    # Update home links
    && usermod -d /home/$USERNAME -m $USERNAME \
    && mkdir /home/jupyter \
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
# See: https://stackoverflow.com/a/61751745/10027894
# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1 \
    # Turns off buffering for easier container logging
    PYTHONUNBUFFERED=1 \
    # pip
    # PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    # google container disable root
    NOTEBOOK_DISABLE_ROOT=1
# Local pip path
RUN mkdir -p /home/$USERNAME/.local/bin
ENV PATH="${PATH}:/home/$USERNAME/.local/bin"


# Define image with common pip packages
FROM base as common
# Copy requirements.txt
COPY common/requirements.txt requirements.txt
# Install pip packages
RUN --mount=type=cache,target=/home/$USERNAME/.cache \
    pip install -r requirements.txt
# Save pip freeze as artifact
RUN pip list --format=freeze | sudo tee /pip-freeze.txt > /dev/null