##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Update
sudo apt update

# Mount App Data
fsck.ext4 -tvy /dev/sdb || mkfs.ext4 /dev/sdb
mkdir -p /mnt/disks/docker
mount -o defaults -t ext4 /dev/sdb /mnt/disks/docker
mkdir -p /mnt/disks/docker/projects/app
sudo chmod 777 /mnt/disks/docker/projects/app

# Allow user account access to sudo without password for these actions - update the username to your own
sudo echo "USERNAMEHERE ALL=(ALL) NOPASSWD:/bin/mkdir,/bin/mv,/bin/cat,/bin/rm,/bin/nano" >> /etc/sudoers

# Install Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg --batch --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce nano -y

# Install Docker Compose - manually add your username to the path
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -L https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo usermod -aG sudo USERNAMEHERE
sudo usermod -aG docker USERNAMEHERE
sleep 30

# Move compose file - again update the username here
sudo mv /home/USERNAMEHERE/docker-compose.yaml /mnt/disks/docker/projects/app/docker-compose.yaml
