ROM=$1

function installDeps(){
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get install bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline6-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk
    sudo apt-get update && sudo apt-get install openjdk-8-jdk && sudo apt-get install openjdk-8-jre &&
    sudo apt-get install bc bison build-essential ccache curl flex \
    g++-multilib gcc-multilib git-core gnupg gperf imagemagick lib32ncurses5-dev \
    lib32z-dev libc6-dev-i386 libgl1-mesa-dev libssl-dev libx11-dev \
    libxml2-utils unzip x11proto-core-dev xsltproc zip zlib1g-dev
    mkdir ~/bin && PATH=~/bin:$PATH && curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo
    git config --global user.name "niteshkumar2000" && git config --global user.email "nitesh156200@gmail.com"
}

function syncSource(){
    if [ "$ROM" == "PE" ]; then
        mkdir PE && cd PE
        repo init -u https://github.com/PixelExperience-FanEdition/manifest -b ten-plus
        repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
        git clone https://github.com/niteshkumar2000/android_device_xiaomi_sdm660-common -b ten device/xiaomi/sdm660-common
        git clone https://github.com/niteshkumar2000/android_device_xiaomi_twolip -b ten device/xiaomi/twolip
        git clone https://github.com/xiaomi-sdm660/android_kernel_xiaomi_sdm660.git -b master kernel/xiaomi/sdm660
        git clone https://github.com/niteshkumar2000/proprietary_vendor_xiaomi.git -b ten vendor/xiaomi
        git clone https://github.com/niteshkumar2000/vendor_MiuiCamera.git vendor/MiuiCamera
        rm -rf vendor/aosp/packages/overlays/NoCutoutOverlay
    else
        mkdir syberia && cd syberia
        repo init -u https://github.com/syberia-project/manifest.git -b 10.0
        repo sync -c -jx --force-sync --no-clone-bundle --no-tags
        git clone https://github.com/SyberiaProject-Devices/platform_device_xiaomi_sdm660-common -b 10.0 device/xiaomi/sdm660-common
        git clone https://github.com/SyberiaProject-Devices/platform_device_xiaomi_tulip -b 10.0 device/xiaomi/tulip
        git clone https://github.com/xiaomi-sdm660/android_kernel_xiaomi_sdm660/ -b master kernel/xiaomi/sdm660
        git clone https://github.com/niteshkumar2000/proprietary_vendor_xiaomi.git -b master vendor/xiaomi
        git clone https://github.com/niteshkumar2000/android_hardware_qcom_thermal -b lineage-17.1 hardware/qcom/thermal
        git clone https://github.com/LineageOS/android_external_json-c -b lineage-17.1  external/json-c
        git clone https://github.com/z3nitsu/hardware_qcom_media-caf_msm8998 hardware/qcom/media-caf/msm8998
        git clone https://github.com/z3nitsu/hardware_qcom_audio-caf_msm8998 hardware/qcom/audio-caf/msm8998
        git clone https://github.com/z3nitsu/syberia_hardware_qcom_display-caf_msm8998 hardware/qcom/display-caf/msm8998
        git clone https://github.com/ConquerOS/device_qcom_sepolicy-legacy-um device/qcom/sepolicy-legacy-um
        git clone https://github.com/LineageOS/android_vendor_qcom_opensource_fm-commonsys -b lineage-17.1 vendor/qcom/opensource/fm-commonsys
        git clone https://github.com/LineageOS/android_vendor_qcom_opensource_libfmjni.git -b lineage-17.1 vendor/qcom/opensource/libfmjni
        git clone https://github.com/LineageOS/android_external_ant-wireless_antradio-library external/ant-wireless/antradio-library
        git clone https://github.com/LineageOS/android_packages_resources_devicesettings.git -b lineage-17.1 packages/resources/devicesettings
        git clone https://github.com/niteshkumar2000/vendor_MiuiCamera.git vendor/MiuiCamera
        rm -rf vendor/syberia/packages/overlays/NoCutoutOverlay
        rm -rf vendor/qcom/opensource/data-ipa-cfg-mg
    fi
}

function enableCcache(){
    echo export USE_CCACHE=1 >> ~/.bashrc
    source ~/.bashrc
    ccache -M 50G
}

function build(){
    . build/envsetup.sh
    if [ "$ROM" == "PE" ]; then
        lunch aosp_twolip-userdebug
        mka bacon -j$(nproc --all)
    else
        brunch syberia_tulip-user
    fi
}

function uploadBuild(){
    cd ~ && wget https://drive.google.com/u/0/uc?id=1ZUtFPOMJs5LF3Dvl51fBKF2p7JUjxFcQ&export=download


    mv uc?* gdrive && chmod +x gdrive && sudo install gdrive /usr/local/bin/gdrive

    if [ "$ROM" == "PE" ]; then
        gdrive out/target/product/twolip/PixelExperience*.zip
    else
        gdrive out/target/product/twolip/syberia_tulip*.zip
    fi
}
installDeps
syncSource
enableCcache
build
