# Setting up new servers..

## Starting VM's

See https://github.com/metacpan/metacpan-servers


See https://github.com/metacpan/network-infrastructure/pull/114

## Hetzner adding disk volumes

Use the web interface to create a volume and attach it to the server

We will want the same on ALL Servers

### Find the name:

```sh
hz-mc-01 /etc/systemd/system # lsblk | grep disk
sda       8:0    0 19.1G  0 disk
sdb       8:16   0   10G  0 disk
```

So we now know it is `sdb` (same size as the disk volume created)

###  Then get the `uuid` of the mount:

```sh
hz-mc-01 /etc/systemd/system # blkid | grep sdb
/dev/sdb: UUID="51c7d64a-0b23-48ad-802b-373e9915019c" BLOCK_SIZE="4096" TYPE="ext4"
```

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
Before=local-fs.target

[Mount]
What=/dev/disk/by-uuid/51c7d64a-0b23-48ad-802b-373e9915019c
Where=/mnt/cluster_data
Type=ext4

[Install]
WantedBy=local-fs.targe
```

### Update systemd and start the service which will perform the mount

```
systemctl daemon-reload
systemctl start mnt-cluster_data.mount
```

## Changing volume size

Update in Hetzner web ui and then run...

```
resize2fs /dev/disk/by-uuid/51c7d64a-0b23-48ad-802b-373e9915019c
```