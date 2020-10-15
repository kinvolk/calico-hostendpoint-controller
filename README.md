This is a few minutes hack to manage calico hostendpoint resources when nodes
are added or deleted.

Please note that the code is messy, names were not carefully chosen, directories
for better organization might be missing, has several TODOs, and for now it is
Packet specific (the script uses "bond0" as the interface name).

Also, another important consideration is that since a node start till the policy
is applied, the node should not be exposed. This is not covered by this
controller.

## Building

Depending on your architecture you would use one of the commands:

### x86

```
ARCH=amd64 docker build -t quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-amd64 \
    --build-arg ARCH . && docker push quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-amd64
```

### arm

```
ARCH=arm64 docker build -t quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-arm64 \
    --build-arg ARCH . && docker push quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-arm64
```

There are multiple ways for building an image for another architecture which is
not your native OS architecture.
The most convenient one is to install the `qemu-user-static` package on your
system to set up binary translation so that the Linux kernel can run binaries
for other architectures.

> **NOTE**: You may have to run `sudo systemctl restart systemd-binfmt.service` after installing.

The downside of this approach is that a base image for the non-native
architecture must be explicitly specified in the `FROM` directive of the
Dockerfile instead of an image like `debian:9`, which is a multiarch image.
For example, for building a Debian-based ARM64 image on an x86-64 machine you
need to use `arm64v8/debian:9` (prefixed because there is no `debian:9-arm64`).

When done building, you can change the Dockerfile back to the way it was
before. Unfortunately the `FROM` directive does not handle build arguments.

### Combined image tag

Now make sure you have `"experimental": "enabled"` in your
`~/.docker/config.json` (surrounded by `{` and `}` if the file is otherwise
empty).

When all images are built on the respective architectures and pushed they can
be combined through a manifest to build a multiarch image:

```
docker manifest create quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4 \
    --amend quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-amd64 \
    --amend quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-arm64

docker manifest annotate quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4 \
    quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-amd64 --arch=amd64 --os=linux

docker manifest annotate quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4 \
    quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4-arm64 --arch=arm64 --os=linux

docker manifest push quay.io/kinvolk/calico-hostendpoint-controller:v0.0.4
```

> **NOTE**: Above commands can be run from any machine.
