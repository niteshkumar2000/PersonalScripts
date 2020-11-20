SYNC=$1
CCACHE=$2
CLEAN=$3
BUILD=$4
UPLOAD=$5

# Colors makes things beautiful
export TERM=xterm
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
blu=$(tput setaf 4)             #  blue
cya=$(tput setaf 6)             #  cyan
txtrst=$(tput sgr0)             #  Reset

function syncSource(){
	git config --global user.name "niteshkumar2000" && git config --global user.email "nitesh156200@gmail.com"
	echo -e ${blu} "\n[*] Syncing sources... This will take a while [*]" ${txtrst}
	repo init --depth=1 -u https://github.com/PixelExtended/manifest -b r
	repo sync -c -q --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
	git clone --depth=1 https://github.com/xiaomi-sdm660/android_device_xiaomi_tulip -b eleven device/xiaomi/tulip
	git clone --depth=1 https://github.com/xiaomi-sdm660/android_device_xiaomi_sdm660-common -b eleven device/xiaomi/sdm660-common
	git clone --depth=1 https://github.com/xiaomi-sdm660/android_vendor_xiaomi_sdm660-common -b eleven vendor/xiaomi/sdm660-common
	git clone --depth=1 https://github.com/xiaomi-sdm660/android_vendor_xiaomi_tulip -b eleven vendor/xiaomi/tulip
	git clone --depth=1 https://github.com/Divyanshu-Modi/Atom-X-Kernel -b kernel.lnx.4.4.r38-rel kernel/xiaomi/sdm660
        rm -rf vendor/aosp/packages/overlays/NoCutoutOverlay
	echo -e ${grn} "\n[*] Syncing sources completed! [*]" ${txtrst}
}

function build(){
	export PEX_BUILD_TYPE=OFFICIAL
	echo -e ${cya} "\n\n[*] Starting the build... [*]" ${txtrst}
    	. b*/e*
    	brunch tulip
}

function uploadBuild(){
	echo -e ${grn} "\n[*] Uploading the build! [*]" ${txtrst}
   	gdrive put out/target/product/twolip/PixelExperience*.zip
}

function useCcache(){
	echo -e ${blu} "\n\n[*] Enabling cache... [*]" ${txtrst}
	export CCACHE_DIR=/var/lib/jenkins/workspace/jenkins-ccache
	ccache -M 50G
      	export CCACHE_EXEC=$(which ccache)
      	export USE_CCACHE=1
	echo -e ${grn} "\n[*] Yumm! ccache enabled! [*]" ${txtrst}
}

if [ "$SYNC" = "true" ]; then
	syncSource
fi

if [ "$CCACHE" = "true" ]; then
	useCcache
fi

if [ "$CLEAN" = "true" ]; then
	echo -e ${blu} "\n\n[*] Running clean job - full [*]" ${txtrst}
	. b*/e*
	make clean && rm -rf out
	echo -e ${grn}"\n[*] Clean job completed! [*]" ${txtrst}

fi

if [ "$BUILD" = "true" ]; then
	build
fi

if [ "$UPLOAD" = "true" ]; then
	uploadBuild
fi
