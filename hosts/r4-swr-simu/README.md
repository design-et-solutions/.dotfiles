# Setup

## Pre Setup

### SSH

```sh
sudo apt install openssh-server
```

### GPU

```sh
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt search nvidia
```

```sh
nvidia-detector
```

Got driver XXX.

```sh
sudo apt install nvidia-utils-XXX nvidia-driver-XXX
```

Reboot.\
To check if it working:

```sh
nvidia-smi
```

### X11

```sh
sudo nano /etc/gdm3/custom.conf
```

```conf
[...]
WaylandEnable=false
[...]
```

Reboot.\
Then, fix color.

### Docker

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world

sudo usermod -aG docker $USER
```

Reboot.

## Dependencies

```sh
sudo apt install curl gstreamer1.0-plugins-bad
```

## Install

```sh
curl --fail --silent --show-error --location https://debian.parrot.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/debian.parrot.com.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/debian.parrot.com.gpg] https://debian.parrot.com/ jammy main generic" | sudo tee /etc/apt/sources.list.d/debian.parrot.com.list
sudo apt update
sudo apt install parrot-sphinx
sudo apt update
sudo apt install parrot-ue4-forest
cd /home/me/
wget https://firmware.parrot.com/Versions/anafi2/pc/%23latest/images/anafi2-pc.ext2.zip
unzip anafi2-pc.ext2.zip
```

## Test

### Shell 1

```sh
sphinx "/opt/parrot-sphinx/usr/share/sphinx/drones/anafi_ai.drone"::firmware="/home/me/anafi2-pc.ext2"
```

### Shell 2

```sh
parrot-ue4-forest
```

### Shell 3

```sh
gst-launch-1.0 rtspsrc location=rtsp://10.202.0.1/live ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink
```

---

```sh
cd /home/me
unzip vivatech-thales.zip
```

---

```sh
cd /home/me
wget https://github.com/bluenviron/mediamtx/releases/download/v1.11.3/mediamtx_v1.11.3_linux_amd64.tar.gz
tar -xvzf mediamtx_v1.11.3_linux_amd64.tar.gz
/home/me/mediamtx /home/me/vivatech-thales/mediamtx.yml
```

---

```sh
cd /home/me/vivatech-thales/
unzip anafi-bridge-docker.zip
cd anafi-bridge-docker
docker load -i anafi-bridge-51-simu-default-image.tar.gz
./start_anafi_bridge_stream_simu.sh
```
