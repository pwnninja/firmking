# br0 interface existence is necessary for successful emulation
sudo ip link add br0 type dummy

# disable ASLR
sudo sh -c "echo 0 > /proc/sys/kernel/randomize_va_space"

# Switch to legacy memory layout. Kernel will use the legacy (2.4) layout for all processes. To mimic the embedded environment because embedded environments usually have old kernels
sudo sh -c "echo 1 > /proc/sys/vm/legacy_va_layout"

# mounting special folders to the existing Debian ARM environment to provide the emulated environment awareness of the Linux surroundings
sudo mount --bind /proc /home/user/US_AC9V1.0BR_V15.03.2.13_multi_TDE01/squashfs-root/proc
sudo mount --bind /sys /home/user/US_AC9V1.0BR_V15.03.2.13_multi_TDE01/squashfs-root/sys
sudo mount --bind /dev /home/user/US_AC9V1.0BR_V15.03.2.13_multi_TDE01/squashfs-root/dev

# automatically triggering the startup of the firmware
sudo chroot /home/user/US_AC9V1.0BR_V15.03.2.13_multi_TDE01/squashfs-root /bin/sh -c "LD_PRELOAD=/hooks.so /etc_ro/init.d/rcS"

