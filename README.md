# headphones-plug-controller

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

headphones-plug-controller - f1u77y/<a href="https://github.com/f1u77y/headphones-plug-detector">headphones-plug-detector</a> implementation in Vala

Pauses playback for mpris2 compatible media players when the headphones plug off and starts playing when they plug in again

### Building and Installation

```bash
git clone https://github.com/nvlgit/headphones-plug-controller.git && cd headphones-plug-controller
meson builddir --prefix=/usr && cd builddir
ninja
su -c 'ninja install'
```
For rpmbuild: <a href="https://github.com/nvlgit/fedora-specs/blob/master/headphones-plug-controller.spec">headphones-plug-controller.spec</a> 

    
### Run
```bash
$ systemctl enable headphones-plug-controller.service --user
$ systemctl start headphones-plug-controller.service --user
```
