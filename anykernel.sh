# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=sleepy ~ but my college is a serious joke! (By Lacia_chan)
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=sakura
device.name2=daisy
device.name3=sakura_india
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

mount -o remount,rw /vendor

# Check if the revvz script is present if so nuke it
sed -i '/revvz_exec/d' /vendor/bin/init.qcom.sh
sed -i '/revvz_exec/d' /vendor/bin/init.qcom.post_boot.sh
rm -rf /vendor/bin/revvz_exec.sh

# Check if the script is present
is_exist_post_sh=$(grep sleepy_exec /vendor/bin/init.qcom.post_boot.sh)
is_exist_qcom_sh=$(grep sleepy_exec /vendor/bin/init.qcom.sh)

#Scripts may execute twice in most cases, but
#its ok, since this is only executed during boot-time.
#We need to guarantee that it will execute.
if [[ -z "$is_exist_post_sh" ]];then
echo "/vendor/bin/sleepy_exec.sh" >> /vendor/bin/init.qcom.post_boot.sh
fi

if [[ -z "$is_exist_qcom_sh" ]];then
echo "/vendor/bin/sleepy_exec.sh" >> /vendor/bin/init.qcom.sh
fi

cp /tmp/anykernel/tools/sleepy_exec.sh /vendor/bin/
chmod 0755 /vendor/bin/sleepy_exec.sh

## AnyKernel install
dump_boot;

# begin ramdisk changes

# end ramdisk changes

write_boot;
## end install
