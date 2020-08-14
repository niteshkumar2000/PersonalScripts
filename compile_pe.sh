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
	repo init --depth=1 -u https://github.com/PixelExperience-FanEdition/manifest -b ten-plus
        repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
        git clone https://github.com/niteshkumar2000/android_device_xiaomi_sdm660-common -b ten device/xiaomi/sdm660-common
        git clone https://github.com/niteshkumar2000/android_device_xiaomi_twolip -b ten device/xiaomi/twolip
        git clone https://github.com/xiaomi-sdm660/android_kernel_xiaomi_sdm660.git -b master kernel/xiaomi/sdm660
        git clone https://github.com/niteshkumar2000/proprietary_vendor_xiaomi.git -b ten vendor/xiaomi
        git clone https://github.com/niteshkumar2000/vendor_MiuiCamera.git vendor/MiuiCamera
        rm -rf vendor/aosp/packages/overlays/NoCutoutOverlay
	echo -e ${grn} "\n[*] Syncing sources completed! [*]" ${txtrst}
}

function build(){
	echo -e ${cya} "\n\n[*] Starting the build... [*]" ${txtrst}
    	. build/envsetup.sh
    	lunch aosp_twolip-userdebug
    	mka bacon -j$(nproc --all)
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
	make clean && rm -rf out
	echo -e ${grn}"\n[*] Clean job completed! [*]" ${txtrst}

fi

if [ "$BUILD" = "true" ]; then
	build
fi

if [ "$UPLOAD" = "true" ]; then
	uploadBuild
fi
