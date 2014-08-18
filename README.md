docker-nagios-client
======================

CentOS6 + nagios nrpe client

This is a node nagios container which allows you to run various checks on
running machine. The main goal is to create nagios alerts container
automatically, just place conf file to `/conf/nagios/nrpe.cfg`.

TODO: generate a server config and send it to server on start and delete it
from server on stop.

### List of environment variables

* `ETCDCTL_PEERS` - address of etcd service to watch reload signal. Optional.
* `ETCDCTL_WATCH` - path inside etcd to watch reload signal. Optional.

### Usage

Run it like that:

```
docker run -d -e ETCDCTL_PEERS="172.17.42.1:4001" -p 5666:5666
--volumes-from=configurator --name nagios varsy/nagios-client
```
where `configurator` is a container which share its volume `/conf/nagios/` with
nrpe.cfg file inside. 

### Reload configuration on the fly

New configuration files should be at `/conf/nagios/` directory then you need to send `reload` string to `ETCDCTL_WATCH` path to initiate reload of nagios.
You may use [`varsy/configurator`](https://registry.hub.docker.com/u/varsy/configurator/) container to manage git based configuration and reload nrpe daemon.
Use templates of configuration from `confd` directory.
