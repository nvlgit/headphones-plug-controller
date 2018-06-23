# ![icon](https://assets.gitlab-static.net/uploads/-/system/project/avatar/6581165/bitmap.png) headphones-plug-controller

headphones-plug-controller - f1u77y/<a href="https://github.com/f1u77y/headphones-plug-detector">headphones-plug-detector</a> implementation in Vala

Pauses playback for mpris2 compatible media players when the headphones jack unplugs and resumes playback when it is plugged back in. 

### Building and Installation

    git clone https://gitlab.com/nvlgit/headphones-plug-controller.git && cd headphones-plug-controller
    meson builddir --prefix=/usr && cd builddir
    ninja
    su -c 'ninja install'
For rpmbuild: <a href="https://gitlab.com/nvlgit/fedora-specs/blob/master/headphones-plug-controller.spec">headphones-plug-controller.spec</a> 

    
### Run

    $ systemctl enable headphones-plug-controller.service --user
    $ systemctl start headphones-plug-controller.service --user

