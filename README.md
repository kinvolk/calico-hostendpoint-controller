This is a few minutes hack to manage calico hostendpoint controllers when nodes
are added or deleted.

Please note that the code is messy, names were not carefully chosen, directories
for better organization might be missing, has several TODOs, and for now it is
Packet specific (the script uses "bond0" as the interface name).

Also, another important consideration is that since a node start till the policy
is applied, the node should not be exposed. This is not covered by this
controller.
