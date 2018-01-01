# headphones-plug-controller

headphones-plug-controller - f1u77y/<a href="https://github.com/f1u77y/headphones-plug-detector">headphones-plug-detector</a> implementation in Vala

Pauses mpris2 compatible media players when headphones get plugged out and plays it when they get plugged in 

### Building and Installation

    git clone https://github.com/nvlgit/headphones-plug-controller.git && cd headphones-plug-controller
    meson builddir --prefix=/usr && cd builddir
    ninja
    su -c 'ninja install'
For rpmbuild: <a href="https://github.com/nvlgit/fedora-specs/blob/master/headphones-plug-controller.spec">headphones-plug-controller.spec</a> 

    
### Run

    $ systemctl enable headphones-plug-controller.service --user
    $ systemctl start headphones-plug-controller.service --user

