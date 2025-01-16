# webcface-package

This repository releases [WebCFace](https://github.com/na-trium-144/webcface), [webui](https://github.com/na-trium-144/webcface-webui) and [tools](https://github.com/na-trium-144/webcface-tools)
as zip archives.

## Download Archives

Download from [Releases](https://github.com/na-trium-144/webcface-windows-package/releases).
Refer to the README of WebCFace for details.

## Docker

You can also pull and run `webcface-server` and tools using Docker.

### webcface-server

* For arm64 or armhf, replace `amd64` in the image name.
* Example (TCP and Unix Socket)
```sh
docker run --rm \
    -p 7530:7530 \
    -v /tmp/webcface:/tmp/webcface \
    ghcr.io/na-trium-144/webcface-package/webcface-amd64:latest
```

### webcface-tools

* For arm64 or armhf, replace `amd64` in the image name.
* Example (Unix Socket)
```sh
docker run --rm \
    -v /tmp/webcface:/tmp/webcface \
    ghcr.io/na-trium-144/webcface-package/webcface-amd64:latest \
    webcface-ls
```
* Example (TCP)
```sh
docker run --rm \
    --add-host=host.docker.internal:host-gateway \
    ghcr.io/na-trium-144/webcface-package/webcface-amd64:latest \
    webcface-ls -a host.docker.internal
```
