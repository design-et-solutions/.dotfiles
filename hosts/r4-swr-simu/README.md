# Setup

## Dependencies

```sh
sudo apt install curl gstreamer1.0-plugins-hard
```

## Pre Setup

### GPU

```sh
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
nvidia-detector
sudo apt search nvidia
```

```sh
sudo apt install nvida-XXX
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

## Install

```sh
curl --fail --silent --show-error --location https://debian.parrot.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/debian.parrot.com.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/debian.parrot.com.gpg] https://debian.parrot.com/ jammy main generic" | sudo tee /etc/apt/sources.list.d/debian.parrot.com.list
sudo apt update
sudo apt install parrot-sphinx
sudo apt update
sudo apt install parrot-ue4-forest
```

## Test

### Shell 1

```sh
sphinx "/opt/parrot-sphinx/usr/share/sphinx/drones/anafi_ai.drone"::firmware="https://firmware.parrot.com/Versions/anafi2/pc/%23latest/images/anafi2-pc.ext2.zip"
```

### Shell 2

```sh
parrot-ue4-forest
```

### Shell 3

```sh
gst-launch-1.0 rtspsrc location=rtsp://10.202.0.1/live ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink
```
