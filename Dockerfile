FROM ubuntu:latest

#updated by b_rad <brae/dot/04/plus/tizonia/at/gmail/dot/com>
LABEL maintainer "Juan A. Rubio <juan.rubio@aratelia.com>"

# Install Tizonia, and dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    build-essential \
    python-dev \
    libffi-dev \
    libssl-dev \
    python-wheel \
    python-pip \
    python-pkg-resources \
    python-setuptools \
    libpulse0 \
    pulseaudio-utils \
    --no-install-recommends \
    && curl 'http://apt.mopidy.com/mopidy.gpg' | apt-key add - \
    && echo "deb http://apt.mopidy.com/ stable main contrib non-free" > /etc/apt/sources.list.d/libspotify.list \
    && curl 'https://bintray.com/user/downloadSubjectPublicKey?username=tizonia' | apt-key add - \
    && echo "deb https://dl.bintray.com/tizonia/ubuntu xenial main" > /etc/apt/sources.list.d/tizonia.list \
    && apt-get update && apt-get install -y \
    libspotify12 \
    tizonia-all \
    --no-install-recommends \
    && pip2 install --upgrade \
    gmusicapi \
    soundcloud \
    youtube-dl \
    pafy \
    pycountry \
    titlecase \
    fuzzywuzzy \
    python-levenshtein \
    && apt-get purge --auto-remove -y \
    build-essential \
    python-dev \
    libffi-dev \
    libssl-dev \
    python-wheel \
    python-pip \
    python-pkg-resources \
    python-setuptools \
    curl \
    && rm -rf /var/lib/apt/lists/*

ENV UNAME tizonia

RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio

COPY pulse-client.conf /etc/pulse/client.conf

# Run Tizonia as non privileged user
USER $UNAME
ENV HOME /home/$UNAME
WORKDIR $HOME

ENTRYPOINT [ "tizonia" ]
