#!/bin/bash
# https://man7.org/linux/man-pages/man1/free.1.html
# https://man7.org/linux/man-pages/man1/df.1.html
# https://man7.org/linux/man-pages/man1/top.1.html
KERNEL_VERSION=$(uname -a | fold -w 75 -s)
PHYSICAL_CPU=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
VIRTUAL_CPU=$(grep "^processor" /proc/cpuinfo | wc -l)
# Print the second column of the line containing "Mem:"
TOTAL_RAM=$(free -m | awk '$1 == "Mem:" {print $2}')
USED_RAM=$(free -m | awk '$1 == "Mem:" {print $3}')
PERCENT_RAM=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
TOTAL_DISK=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
USED_DISK=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
PERCENT_DISK=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
LOAD_CPU=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}') #-bn1 -> batch mode / number of frame
LAST_BOOT=$(who -b | awk '$1 == "system" {print $3 " " $4}')
LVM=$(lsblk | grep "lvm" | wc -l)
LVM_USED=$(if [ $LVM -eq 0 ]; then echo no; else echo yes; fi)
# You need to `sudo apt install net-tools' for the next step to work.
TCP=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
USER_LOG=$(users | wc -w)
IP=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
CMDS=$(journalctl _COMM=sudo | grep COMMAND | wc -l) # journalctl should be running as sudo but our script is running as root so we don't need in sudo here
wall "
	+ Architecture: $KERNEL_VERSION
	+ Physical CPU(s): $PHYSICAL_CPU
	+ Virtual CPU(s): $VIRTUAL_CPU
	+ Memory Usage: $USED_RAM/${TOTAL_RAM}MB ($PERCENT_RAM%)
	+ Disk Usage: $USED_DISK/${TOTAL_DISK}GB ($PERCENT_DISK%)
	+ CPU Load: $LOAD_CPU
	+ Last Boot: $LAST_BOOT
	+ LVM in Use: $LVM_USED
	+ TCP Connections: $TCP ESTABLISHED
	+ User Log: $USER_LOG
	+ Network: IP $IP ($MAC)
	+ Sudo: $CMDS cmd" # broadcast our system information on all terminals
