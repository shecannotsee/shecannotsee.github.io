System environment: ubuntu22.04

Ignoring c++ related development environments (such as  git, cmake, g++, etc.)

#### 1.get source code

```sh
git clone https://github.com/antimof/UxPlay.git
```

#### 2.Installation dependencies

```sh
# compilation dependency
sudo apt-get install libx11-dev
sudo apt-get install pkg-config
sudo apt install libssl-dev libplist-dev
sudo apt-get install avahi-daemon libavahi-compat-libdnssd-dev
sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-de
cmake -B build
cmake --build build -j 8
# runtime dependency
sudo apt-get install gstreamer1.0-libav gstreamer1.0-plugins-bad
# running
./uxplay
```

