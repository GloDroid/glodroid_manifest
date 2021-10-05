# Manifest for GloDroid

Free and opensource AOSP based Android for the world's most accessible development platforms.  

This version is based on [Android 12.0.0 Release 15](https://android.googlesource.com/platform/manifest/+/refs/heads/android-12.0.0_r15).  

## Supported devices:
### SUNXI platform:
- Orange PI Plus 2 (Not tested)
- Orange PI Plus 2E
- Orange PI Prime (Not tested)
- Orange PI PC
- Orange PI PC Plus
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

## Fetching Android sources
- Installing 'repo' tool:
```bash
sudo apt-get install -y python-is-python3 wget
wget -P ~/bin http://commondatastorage.googleapis.com/git-repo-downloads/repo
chmod a+x ~/bin/repo
```

- Cloning the GloDroid
```bash
mkdir -p GloDroid
cd GloDroid
repo init -u https://github.com/glodroid/glodroid_manifest
repo sync -cq
```

## You should install additional packages in order to build GloDroid
(Ubuntu 20.04 LTS is only supported. Building on other distributions can be done using docker)
<br/>

- [Install AOSP required packages](https://source.android.com/setup/build/initializing).
```bash
sudo apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig
```

<br/>

- Install additional packages
```bash
sudo apt-get install -y swig libssl-dev flex bison device-tree-compiler mtools git gettext libncurses5 libgmp-dev libmpc-dev cpio rsync dosfstools kmod gdisk
```

<br/>

- Install additional packages (for building mesa3d, libcamera and other meson-based components)
```bash
sudo apt-get install -y python3-pip pkg-config python3-dev ninja-build
sudo pip3 install mako meson jinja2 ply
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
  
