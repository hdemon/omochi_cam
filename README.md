# Add a user.

```sh
sudo adduser [name]
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,spi,i2c,gpio [name] # make it belongs to the same group as "pi" user
```

# Disable "pi" user for better security.

```sh
sudo usermod -L -s /bin/false -e 1 pi
```

# Disable swap to give microSD longer life.

```sh
sudo swapoff --all
sudo systemctl stop dphys-swapfile
sudo systemctl disable dphys-swapfile
```

# Turn off LEDs

```sh
echo "dtparam=act_led_trigger=none,act_led_activelow=on" | sudo tee -a /boot/config.txt
echo "dtparam=pwr_led_trigger=none,pwr_led_activelow=on" | sudo tee -a /boot/config.txt
```

# Install Docker

```
curl -sSL https://get.docker.com | sh
```

# Fix signature error when running "apt update"

https://askubuntu.com/questions/1263284/apt-update-throws-signature-error-in-ubuntu-20-04-container-on-arm

# https://packages.debian.org/sid/libseccomp2

```
wget http://http.us.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.1-1_armhf.deb
sudo dpkg -i libseccomp2_2.5.1-1_armhf.deb
```

```sh
docker build ./omochi_cam -t omochi_cam
docker run -p 443:443 -p 8088:8088 -p 8089:8089 omochi_cam
```

8088 is for Janus HTTP server, 8089 is for HTTPS one.

--device=/dev/ttyUSB0:/dev/ttyUSB0
