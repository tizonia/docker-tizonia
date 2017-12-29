# Tizonia on Docker container

Containerized [**Tizonia**](http://www.tizonia.org/) cloud music player that uses the host's sound system.

[![](https://images.microbadger.com/badges/image/tizonia/docker-tizonia.svg)](http://microbadger.com/images/tizonia/docker-tizonia "Get your own image badge on microbadger.com")

## Audio Output

Tizonia connects as a client directly to the hosts PulseAudio server and uses
its configuration/devices to output the sound. This is achieved by mapping the
UNIX socket used by PulseAudio in the host into the container and configuring
its use.

> Credits: Method borrowed from [docker-pulseaudio-example](https://github.com/thebiggerguy/docker-pulseaudio-example).

## Launch Command

Use the convenience script [docker-tizonia](docker-tizonia):

``` bash
#!/bin/bash

USER_ID=$(id -u)
GROUP_ID=$(id -g)

docker run -it --rm \
  --volume=/run/user/${USER_ID}/pulse:/run/user/${GROUP_ID}/pulse \
  --volume="$HOME/.config/tizonia":/home/tizonia/.config/tizonia \
  --name tizonia \
  tizonia/docker-tizonia "$@"

```

This script provides access inside the container to Tizonia's configuration
file in the host directory '$HOME/.config/tizonia'.

> 'chmod a+rwx $HOME/.config/tizonia' to allow write access to Tizonia running inside the container.

Once the script is in your path, the just call it with the usual Tizonia
commands:

``` bash

$ docker-tizonia --youtube-audio-mix-search "Queen Official"

```

# License

The [Unlicense](LICENSE.md).

# Tizonia's main repo

See [tizonia-openmax-il](https://github.com/tizonia/tizonia-openmax-il).
