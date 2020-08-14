SYNC=$1
CLEAN=$2
BUILD=$3
UPLOAD=$4

function syncSource(){
	repo init --depth=1 -u https://github.com/PixelExperience-FanEdition/manifest -b ten-plus
        repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
        git clone https://github.com/niteshkumar2000/android_device_xiaomi_sdm660-common -b ten device/xiaomi/sdm660-common
        git clone https://github.com/niteshkumar2000/android_device_xiaomi_twolip -b ten device/xiaomi/twolip
        git clone https://github.com/xiaomi-sdm660/android_kernel_xiaomi_sdm660.git -b master kernel/xiaomi/sdm660
        git clone https://github.com/niteshkumar2000/proprietary_vendor_xiaomi.git -b ten vendor/xiaomi
        git clone https://github.com/niteshkumar2000/vendor_MiuiCamera.git vendor/MiuiCamera
        rm -rf vendor/aosp/packages/overlays/NoCutoutOverlay
}

function build(){
    	. build/envsetup.sh
    	lunch aosp_twolip-userdebug
    	mka bacon -j$(nproc --all)
}

function uploadBuild(){
   	gdrive put out/target/product/twolip/PixelExperience*.zip
}


if [ $SYNC == "true" ]; then
	syncSource
fi

if [ $CLEAN == "true" ]; then
	make clean && rm -rf out
fi

if [ $BUILD == "true" ]; then
	build
fi

if [ $UPLOAD = "true" ]; then
	uploadBuild
fi
