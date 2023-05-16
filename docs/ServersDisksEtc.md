# Setting up new servers..

## Starting VM's

See https://github.com/metacpan/metacpan-servers


See https://github.com/metacpan/network-infrastructure/pull/114

## Hetzner adding disk volumes

Use the web interface to create a volume and attach it to the server,
note the `/dev/disk/by-id/scsi-0HC_Volume_.......`

We will want the same on ALL Servers.

### Find the name 

### Get the filename to use for the mount point you want
```sh
hz-mc-01 /etc/systemd/system # systemd-escape -p --suffix=mount /mnt/cluster_data/
mnt-cluster_data.mount
```

### Create system file

`/etc/systemd/system/${filename}` eg. `/etc/systemd/system/mnt-cluster_data.mount`

Which looks like this:

```
[Unit]
Description=Cluster Data Volume
Before=k3s.service

[Mount]
What=/dev/disk/by-id/scsi-0HC_Volume_......
Where=/mnt/cluster_data
Type=ext4

[Install]
WantedBy=multi-user.target
```

### Update systemd, enable (so it will start on reboot) and start the service which will perform the mount

```
systemctl daemon-reload
systemctl enable mnt-cluster_data.mount
systemctl start mnt-cluster_data.mount
```

## Changing volume size

Update in Hetzner web ui and then run...

```
resize2fs /dev/disk/by-uuid/51c7d64a-0b23-48ad-802b-373e9915019c
```