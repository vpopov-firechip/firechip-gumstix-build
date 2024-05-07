firechip-gumstix-build
======================

Build
-----

**Clone and check-out repositories**

    $ mkdir -p ~/gumstix/1 && cd "$_"
    $ repo init -u git://github.com/vpopov-firechip/firechip-gumstix-git -b main
    $ repo sync

**Build and run docker**

    $ docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag ubuntu_gumstix_image ./firechip-gumstix-build/
    $ docker run -it --rm -v $PWD:/Work ubuntu_gumstix_image

**Set up environment and run build**

    $ export TEMPLATECONF=/Work/poky/meta-gumstix-firechip/conf
    $ . /Work/poky/oe-init-build-env build
    $ bitbake gumstix-console-firechip-image

**Create bootable card**

    $ sudo ./mk2partsd /dev/sdb
    $ sudo mkdir /media/{boot,rootfs}
    $ sudo mount -t vfat /dev/sdb1 /media/boot
    $ sudo mount -t ext4 /dev/sdb2 /media/rootfs
    $ cd ./tmp/deploy/images/overo/
    $ cp MLO /media/boot/
    $ cp u-boot.img /media/boot/
    $ sudo tar -xjvf gumstix-console-firechip-image-overo.tar.bz2 -C /media/rootfs/
    $ sync
    $ sudo umount /media/boot
    $ sudo umount /media/rootfs

How-To
------

**Starting fresh**
1) Clean sstate: bitbake -c cleansstate
2) Re-download packages: bitbake -c cleanall
3) Remove everything but downloads: rm -rf build/sstate-cache build/tmp
4) Remove all: rm -rf build

**Modify repo manifest locally**

Clone:

    $ git clone git clone git@github.com:vpopov-firechip/firechip-gumstix-build.git
    
Modify and commit locally, then init repo using local repository:

    $ repo init -u <file:///path/to/your/git/repository.git>

**References**
1) https://github.com/bstubert/dr-yocto/
2) https://github.com/gumstix/yocto-manifest/
3) https://kickstartembedded.com/2021/12/19/yocto-part-1-a-definitive-introduction/
4) https://www.hackgnar.com/2015/03/building-yocto-linux-images-for-gumstix.html
