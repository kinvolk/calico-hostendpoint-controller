This is a few minutes hack to manage calico hostendpoint resources when nodes
are added or deleted.

Please note that the code is messy, names were not carefully chosen, directories
for better organization might be missing, has several TODOs, and for now it is
Packet specific (the script uses "bond0" as the interface name).

Also, another important consideration is that since a node start till the policy
is applied, the node should not be exposed. This is not covered by this
controller.

Building
========

Depending on your architecture you would use one of the commands:

```
ARCH=amd64 docker build -t kinvolk/calico-hostendpoint-controller:v0.0.2-amd64 --build-arg ARCH . && docker push kinvolk/calico-hostendpoint-controller:v0.0.2-amd64
ARCH=arm64 docker build -t kinvolk/calico-hostendpoint-controller:v0.0.2-arm64 --build-arg ARCH . && docker push kinvolk/calico-hostendpoint-controller:v0.0.2-arm64
```

Now make sure you have `"experimental": "enabled"` in your `~/.docker/config.json` (surrounded by `{` and `}` if the file is otherwise empty).

When all images are build on the respective architectures and published they can be combined through a manifest:
```
docker manifest create kinvolk/calico-hostendpoint-controller:v0.0.2 --amend kinvolk/calico-hostendpoint-controller:v0.0.2-amd64 --amend kinvolk/calico-hostendpoint-controller:v0.0.2-arm64
docker manifest annotate kinvolk/calico-hostendpoint-controller:v0.0.2 kinvolk/calico-hostendpoint-controller:v0.0.2-amd64 --arch=amd64 --os=linux
docker manifest annotate kinvolk/calico-hostendpoint-controller:v0.0.2 kinvolk/calico-hostendpoint-controller:v0.0.2-arm64 --arch=arm64 --os=linux
docker manifest push kinvolk/calico-hostendpoint-controller:v0.0.2
```
