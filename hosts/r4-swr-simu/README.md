```sh
curl --fail --silent --show-error --location https://debian.parrot.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/debian.parrot.com.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/debian.parrot.com.gpg] https://debian.parrot.com/ jammy main generic" | sudo tee /etc/apt/sources.list.d/debian.parrot.com.list
sudo apt update
sudo apt install parrot-sphinx

newgrp firmwared
sudo usermod -a -G firmwared me

sudo nano /etc/gdm3/custom.conf
```

```conf
[...]
WaylandEnable=false
[...]
```

```sh
sudo systemctl gdm3
```

Fix color.

```sh
$ shpinx
[...]
```
