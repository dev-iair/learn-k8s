
- Error
  - Install kubenetes with kubespray, Hostname error

- Solve
  
  - DNS Setting
    ```bash
    sudo su
    #Set Hostname with inventory.ini Hostname
    hostnamectl set-hostname {{hostname}}
    ```

</br>
</br>

- Error
  - After install kubenetes, internet not working

- Solve
  
  - DNS Setting
    ```bash
    sudo vim /etc/systemd/resolved.conf
    ```
    ```ini
    #Google DNS
    DNS=8.8.8.8
    ```
    ```bash
    systemctl restart systemd-resolved
    ```

</br>
</br>


- Error
  - After kubespray clustering, calico pod not working
    - The issue arises from either the Linux kernel being too recent or not matching the ipset version
      ```
      Kernel and userspace incompatible
      ```

- Solve
  
  - ubuntu-mainline-kernel install
    ```bash
    wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
    chmod +x ubuntu-mainline-kernel.sh
    sudo mv ubuntu-mainline-kernel.sh /usr/local/bin/
    ubuntu-mainline-kernel.sh -r
    sudo ubuntu-mainline-kernel.sh -i v5.15.148
    ```
  
  - change default kernel
    ```bash
    grep submenu /boot/grub/grub.cfg
    grep gnulinux /boot/grub/grub.cfg
    sudo vim /etc/default/grub
    ```
    ```ini
    #Change With Your Value
    GRUB_DEFAULT="gnulinux-advanced-318fd28d-f3a3-4758-a6a2-dc65a353591a>gnulinux-5.15.148-0515148-generic-advanced-318fd28d-f3a3-4758-a6a2-dc65a353591a"
    ```
    ```bash
    sudo update-grub
    sudo reboot
    ```