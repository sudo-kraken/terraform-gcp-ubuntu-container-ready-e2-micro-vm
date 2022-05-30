# Mount App Data
fsck.ext4 -tvy /dev/sdb || mkfs.ext4 /dev/sdb
mkdir -p /mnt/disks/docker
mount -o defaults -t ext4 /dev/sdb /mnt/disks/docker
mkdir -p /mnt/disks/docker/projects/app
sudo chmod 777 /mnt/disks/docker/projects/app

# Allow user account access to sudo without password for these actions - update the username to your own
sudo echo "USERNAMEHERE ALL=(ALL) NOPASSWD:/bin/mkdir,/bin/mv" >> /etc/sudoers

# Install Docker Compose - manually add your username to the path
sudo mkdir -p /home/USERNAMEHERE/.docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /home/USERNAMEHERE/.docker/cli-plugins/docker-compose
sudo chmod +x /home/USERNAMEHERE/.docker/cli-plugins/docker-compose
sudo chown USERNAMEHERE:docker /home/USERNAMEHERE/.docker/cli-plugins/docker-compose
sleep 30

# Move compose file - again update the username here
sudo mv /home/USERNAMEHERE/docker-compose.yaml /mnt/disks/docker/projects/app/docker-compose.yaml