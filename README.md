# Manifest for GloDroid

Free and opensource AOSP based Android for the world's most accessible development platforms.  

This version is based on [Android 10.0.0 Release 46](https://android.googlesource.com/platform/manifest/+/refs/heads/android-10.0.0_r46).  

## Supported devices:
### SUNXI platform:
- Orange PI Plus 2 (Not tested)
- Orange PI Plus 2E
- Orange PI Prime (Not tested)
- Orange PI PC
- Orange PI PC 2 (Not tested)
- Orange PI 3
- Pinephone
- Pinetab (Not tested)
- Orange PI WIN (Not tested)
### Broadcom platform:
- Raspberry PI 4b

**Not tested remark means that GloDroid team does not have real device to test before publishing release.
We maintain them in buildable state and can accept requests to fix bugs,
but reporter is responsible for testing**

## You should install additional packages in order to build GloDroid under Ubuntu
- [Google's required packages](https://source.android.com/setup/build/initializing).
- Installing repo:
```bash
wget -P ~/bin/repo http://commondatastorage.googleapis.com/git-repo-downloads/repo
chmod a+x ~/bin/repo
```
- Additional packages:
### Ubuntu 18.04
```bash
sudo apt-get install swig python-dev python3-dev libssl-dev flex bison device-tree-compiler mtools python3-pip git gettext
sudo pip install Mako
```

### Ubuntu 20.04
```bash
sudo apt-get install swig python-dev-is-python2 python3-dev libssl-dev flex bison device-tree-compiler mtools python3-pip git gettext libncurses5
sudo pip install Mako
```
  
## Fetching Android sources
```bash
mkdir -p GloDroid
cd GloDroid
repo init -u https://github.com/glodroid/glodroid_manifest -b refs/tags/v0.4.0
repo sync -cq
```
  
### Building GloDroid
```bash
cd GloDroid
source ./build/envsetup.sh
lunch
# After that you have to select your device from the list
make images
```
  
## Deploying GloDroid

After successful build you should see **images.tar.gz** in product output folder: 
(*out/target/product/<name\>/images.tar.gz*)  
  
### Content of archive:
* Utilities: **adb**, **fastboot**. **mke2fs**  
* Partition images: **bootloader-sd.img**, **bootloader-emmc.img**, **env.img**, **boot.img**, **boot_dtbo.img**, **super.img**  
* Recovery GPT image: **deploy-gpt.img**  
* Recovery sdcard images: **deploy-sd.img**, **deploy-sd-for-emmc.img**  
* Scripts: **flash-sd.sh**, **flash-emmc.sh**  
  
### Step 1
Using any available iso-to-usb utility prepare recovery SDCARD.  
In case you want to flash Android on sdcard, use *deploy-sd.img*  
In case you want to flash Android on eMMC, use *deploy-sd-for.emmc.img*  
  
### Step 2
Insert recovery sdcard into the target board.  
Connect microusb cable to OTG connector and your PC.  
Power-up the board.  
  
### Step 3
Ensure you have installed adb package: ```$ sudo apt install adb``` (required to setup udev rules)  
Run .*/flash-sd.sh* utility for flashing Android to sdcard or *./flash-emmc.sh* for flashing Android to eMMC  
  
*After several minutes flashing should complete and Android should boot*  
  
#### NOTE: Monitor has to be connected to the board and powered-up during flashing!
  
