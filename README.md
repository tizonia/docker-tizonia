[![](https://images.microbadger.com/badges/image/tizonia/docker-tizonia.svg)](http://microbadger.com/images/tizonia/docker-tizonia "Get your own image badge on microbadger.com")

# Tizonia on Docker container

Containerized [**Tizonia**](http://www.tizonia.org/) cloud music player that uses the host's sound system.

## Audio Output

Tizonia connects as a client directly to the hosts PulseAudio server and uses
its configuration/devices to output the sound. This is achieved by mapping the
UNIX socket used by PulseAudio in the host into the container and configuring
its use.

> Credits: Method borrowed from [docker-pulseaudio-example](https://github.com/thebiggerguy/docker-pulseaudio-example).

## Launch Command

Use the convenience script [docker-tizonia](docker-tizonia).

The script bind mounts the host's '$HOME/.config/tizonia' to make
'tizonia.conf' available inside the container.

> NOTE: The Tizonia process running inside the container needs 'rwx'
> permissions on this directory.

Once the script is in your path, and the permissions of '$HOME/.config/tizonia'
have been changed, just use the usual Tizonia commands:

``` bash

# Change Tizonia's config dir permissions
$ chmod a+wrx $HOME/.config/tizonia

# Install the wrapper script in a location in your PATH
$ sudo install docker-tizonia /usr/local/bin

# Pass the usual Tizonia commands to the wrapper
$ docker-tizonia --youtube-audio-mix-search "Queen Official"

```

## Mac Support

### Step 1)

It is required that pulse audio to be installed via homebrew
(`brew install pulseaudio`), and the following lines in
`/usr/local/Cellar/pulseaudio/13.0/etc/pulse/default.pa` to be uncommented:

```
load-module module-esound-protocol-tcp
load-module module-native-protocol-tcp
```

### Step 2)

Too adjust the device being used for output, bring up a list of possible output devices and
select one as the default sink:

```bash
pactl list short sinks

pacmd set-default-sink n  # where n is the chosen output number
```

### Step 3)

Start the Pulseaudio daemon:

```bash
pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1 --daemon
```

You should now be able to utilize the docker container to route audio from the docker container
to the host machine!

# License

The [Unlicense](LICENSE.md).

# Tizonia's main repo

See [tizonia-openmax-il](https://github.com/tizonia/tizonia-openmax-il).
