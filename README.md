# Manifest for GloDroid

Free and opensource AOSP based Android for the world's most accessible development platforms.  

This version is based on [Android 10.0.0 Release 32](https://android.googlesource.com/platform/manifest/+/refs/heads/android-10.0.0_r32).  

## Supported devices:
- Orange PI Plus 2E
- Orange PI PC
- Orange PI 3
- Pinephone
- Pinetab
- Orange PI WIN (not tested)

## You should install additional packages in order to build GloDroid under Ubuntu
- [Google's required packages](https://source.android.com/setup/build/initializing).
- Additional packages:
  
```bash
sudo apt-get install swig repo python-dev python3-dev libssl-dev flex bison device-tree-compiler mtools
sudo pip install Mako
```
  
## Fetching Android sources
```bash
mkdir -p GloDroid
cd GloDroid
repo init -u https://github.com/glodroid/glodroid_manifest
repo sync -cq
```
  
### Building GloDroid
```bash
cd GloDroid
source ./build/envsetup.sh
lunch
# After that you have to select your device from the list
make sdcard
```
  
## Deploying GloDroid to SDCard

After successful build you should see sdcard.img in product output folder: 
(out/target/product/<product>/sdcard.img)
  
Use dd or any other utility to write it to the sdcard:  
(Using dd utility is risky, make sure you are not using your local hard drive device as output)
  
```bash
cd ${ANDROID_ROOT}/
export card=/dev/sdX
dd if=out/target/product/<your device folder>/sdcard.img of=${card} bs=4k count=330000
sync
```
  
After sync command completed you can safely extract your sdcard from the computer.

## Updating using fastbootd
  
In case you already have working Android on your device and you want to update it with some  
modifications, you can do it without having to remove sdcard.  
  
1. Connect your board to PC using micro-usb cable.  
2. Run your board  
3. Execute ` adb reboot fastboot` command from PC shell. After that board will reboot into fastbootd mode.  
4. Change directory to `out/target/product/<your device folder>/`  
5. Run script `./flash-all.sh`  

You may also want to flash only particular partition to save deploy time. To do that - copy and modify flash-all.sh.  
