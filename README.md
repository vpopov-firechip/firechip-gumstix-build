# firechip-gumstix-build
To set up environment:
export TEMPLATECONF=/home/user/poky/meta-gumstix-firechip/conf
. /home/user/poky/oe-init-build-env build_gumstix

To build:
bitbake gumstix-console-firechip-image
