FROM ubuntu:18.04

#updated by b_rad <brae/dot/04/plus/tizonia/at/gmail/dot/com>
LABEL maintainer "Juan A. Rubio <juan.rubio@aratelia.com>"


###############################################################
#
# Configure
#
###############################################################

# Version of Tizonia to be installed
ARG TIZONIA_VERSION=0.15.0-1

# Configure username for executing process
ENV UNAME tizonia

# A list of dependencies installed with
ARG PYTHON_DEPENDENCIES=" \
        gmusicapi>=11.0.3 \
        soundcloud>=0.5.0 \
        youtube-dl>=2018.11.7 \
        pafy>=0.5.4 \
        pycountry>=18.5.26 \
        titlecase>=0.12.0 \
        fuzzywuzzy>=0.17.0 \
        python-levenshtein>=0.12.0 \
    "

# Build Dependencies (not required in final image)
ARG BUILD_DEPENDENCIES=" \
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
    "

###############################################################



# Exec build step
RUN \
    echo "**** Update sources ****" \
       && apt-get update \
    && \
    echo "**** Install package build tools ****" \
        && apt-get install -y --no-install-recommends \
            ${BUILD_DEPENDENCIES} \
    && \
    echo "**** Add additional apt repos ****" \
        && curl -ksSL 'http://apt.mopidy.com/mopidy.gpg' | apt-key add - \
        && echo "deb http://apt.mopidy.com/ stable main contrib non-free" > /etc/apt/sources.list.d/libspotify.list \
        && curl -ksSL 'https://bintray.com/user/downloadSubjectPublicKey?username=tizonia' | apt-key add - \
        && echo "deb https://dl.bintray.com/tizonia/ubuntu bionic main" > /etc/apt/sources.list.d/tizonia.list \
        && apt-get update \
    && \
    echo "**** Install python dependencies ****" \
        && python -m pip install --no-cache-dir --upgrade ${PYTHON_DEPENDENCIES} \
    && \
    echo "**** Install tizonia ****" \
        && apt-get install -y \
            pulseaudio-utils \
            libspotify12 \
            tizonia-all=${TIZONIA_VERSION} \
    && \
    echo "**** create ${UNAME} user and make our folders ****" \
        && mkdir -p \
            /home/${UNAME} \
        && groupmod -g 1000 users \
        && useradd -u 1000 -U -d /home/${UNAME} -s /bin/false ${UNAME} \
        && usermod -G users ${UNAME} \
    && \
    echo "**** Cleanup ****" \
        && apt-get purge -y --auto-remove \
	        ${BUILD_DEPENDENCIES} \
        && apt-get clean \
        && rm -rf \
            /tmp/* \
            /var/tmp/* \
            /var/lib/apt/lists/* \
            /etc/apt/sources.list.d/* \
    && \
    echo


# Copy run script
COPY run.sh /run.sh


# Run Tizonia as non privileged user
USER ${UNAME}
ENV HOME=/home/${UNAME}
WORKDIR ${HOME}


ENTRYPOINT [ "/run.sh" ]
