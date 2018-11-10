#!/bin/bash

PUID=${PUID:-1000}
PGID=${PGID:-1000}
UNAME=${UNAME:-tizonia}

# The default UID and GID is 1000
# If this container is run as a different user, then
# lets also change the UID and GID of the default
# user in the container
if [[ ${PUID} != 1000 || ${PGID} != 1000 ]]; then
    groupmod -o -g "${PGID}" ${UNAME};
    usermod -o -u "${PUID}" ${UNAME};
    chown ${UNAME}:${UNAME} /home/${UNAME};
fi

# Continue to exec tizonia
exec tizonia "$@";

