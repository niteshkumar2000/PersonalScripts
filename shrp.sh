CLEAN=$1

function sync(){
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
}

function build(){
    . build/envsetup.sh
    lunch omni_tulip-eng
    make recoveryimage
}

sync
export USE_CCACHE=1
if [ $CLEAN == "true" ]; then
make clean && rm -rf out/
build
else
build
