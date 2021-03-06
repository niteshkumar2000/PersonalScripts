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
	repo init --depth=1 -u https://github.com/FreakyOS/manifest.git -b still_alive
        repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
	echo -e ${grn} "\n[*] Syncing sources completed! [*]" ${txtrst}
}

function build(){
	echo -e ${cya} "\n\n[*] Starting the build... [*]" ${txtrst}
    	. build/envsetup.sh
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
	make clean && rm -rf out
	echo -e ${grn}"\n[*] Clean job completed! [*]" ${txtrst}

fi

if [ "$BUILD" = "true" ]; then
	build
fi

if [ "$UPLOAD" = "true" ]; then
	uploadBuild
fi
