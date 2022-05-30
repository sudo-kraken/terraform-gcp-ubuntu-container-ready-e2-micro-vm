apt-get -y update
fsck.ext4 -tvy /dev/sdb || mkfs.ext4 /dev/sdb
mkdir -p /mnt/diskd/docker
mount -o defaults -t ext4 /dev/sdb /mnt/disks/docker
mkdir -p /mnt/docker/projects/app