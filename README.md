# Manifest for GloDroid

Free and opensource AOSP based Android for the world's most accessible development platforms.  

This version is based on [Android 10.0.0 Release 29](https://android.googlesource.com/platform/manifest/+/refs/heads/android-10.0.0_r29).  

## You should install additional packages in order to build GloDroid under Ubuntu
- [Google's required packages](https://source.android.com/setup/build/initializing).
- Additional packages:
  
```bash
sudo apt-get install swig liblz4-tool repo python-dev python3-dev libssl-dev flex bison
pip install Mako
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
lunch orangepi_plus2e-userdebug
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
dd if=out/target/product/plus2e/sdcard.img of=${card} bs=4k
sync
```
  
After sync command compleated you can safely extract your sdcard from the computer.
