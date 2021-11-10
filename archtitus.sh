#!/bin/bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/rei/1-setup.sh
    source /mnt/root/rei/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/rei/2-user.sh
    arch-chroot /mnt /root/rei/3-post-setup.sh
