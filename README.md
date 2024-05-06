# firechip-gumstix-build

## Clone and check-out repositories:

cd ~

mkdir gumstix

repo init -u git://github.com/vpopov-firechip/firechip-gumstix-git -b main

## Build and run docker:

docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag ubuntu_gumstix_image ./firechip-gumstix-build/

docker run -it --rm -v $PWD:/Work ubuntu_gumstix_image

## Set up environment:

export TEMPLATECONF=/Work/poky/meta-gumstix-firechip/conf

. /Work/poky/oe-init-build-env build

## Run build:

bitbake gumstix-console-firechip-image
