# 42cursus - Born2beroot

## Table of Contents
- [42cursus - Born2beroot](#42cursus---born2beroot)
	- [Table of Contents](#table-of-contents)
	- [Presentation](#presentation)
	- [Installation](#installation)
	- [*sudo*](#sudo)
		- [Installing *sudo*](#installing-sudo)
		- [Adding User to *sudo* Group](#adding-user-to-sudo-group)
		- [Running *root*-Privileged Commands](#running-root-privileged-commands)
		- [Configuring *sudo*](#configuring-sudo)
	- [SSH](#ssh)
		- [Installing \& Configuring SSH](#installing--configuring-ssh)
		- [Installing \& Configuring UFW](#installing--configuring-ufw)
		- [Connecting to Server via SSH](#connecting-to-server-via-ssh)
	- [User Management](#user-management)
		- [Setting Up a Strong Password Policy](#setting-up-a-strong-password-policy)
			- [Password Age](#password-age)
			- [Password Strength](#password-strength)
		- [Creating a New User](#creating-a-new-user)
		- [Creating a New Group](#creating-a-new-group)
	- [*cron*](#cron)
		- [Setting Up a *cron* Job](#setting-up-a-cron-job)
	- [Bonus](#bonus)
		- [Installation](#installation-1)
		- [Linux Lighttpd MariaDB PHP *(LLMP)* Stack](#linux-lighttpd-mariadb-php-llmp-stack)
			- [Installing Lighttpd](#installing-lighttpd)
			- [Installing \& Configuring MariaDB](#installing--configuring-mariadb)
			- [Installing PHP](#installing-php)
			- [Downloading \& Configuring WordPress](#downloading--configuring-wordpress)
			- [Configuring Lighttpd](#configuring-lighttpd)
		- [File Transfer Protocol *(FTP)*](#file-transfer-protocol-ftp)
			- [Installing \& Configuring FTP](#installing--configuring-ftp)
			- [Connecting to Server via FTP](#connecting-to-server-via-ftp)
	- [Q\&A - Preparing for the defense](#qa---preparing-for-the-defense)
		- [Why Debian?](#why-debian)
		- [What is a virtual machine?](#what-is-a-virtual-machine)
		- [Why a VM?](#why-a-vm)
		- [How does a VM works?](#how-does-a-vm-works)
		- [What is difference between apt and aptitude?](#what-is-difference-between-apt-and-aptitude)
		- [What is AppArmor and SELinux](#what-is-apparmor-and-selinux)
		- [What is SSH?](#what-is-ssh)
		- [How to create a new user?](#how-to-create-a-new-user)
		- [What to check?](#what-to-check)
			- [How to change hostname?](#how-to-change-hostname)
			- [Where is sudo logs in /var/log/sudo?](#where-is-sudo-logs-in-varlogsudo)
			- [How to add and remove port 8080 in UFW?](#how-to-add-and-remove-port-8080-in-ufw)
			- [How to run script every 30 seconds?](#how-to-run-script-every-30-seconds)

## Presentation

This document aims to be a walkthrough of the Born2beroot project at 42
School. It is based on the work of
[hanshazairi](https://github.com/hanshazairi/42-born2beroot) and
[HEADLIGHTER](https://github.com/HEADLIGHTER/Born2BeRoot-42). Its goal is
to unify the two aforementioned sources into one comprehensive guide for
this project.

## Installation
At the time of writing, the latest stable version of
[Debian](https://www.debian.org) is *Debian 11 Bullseye*. Watch *bonus*
installation walkthrough *(no audio)* [here](https://youtu.be/2w-2MX5QrQw).

## *sudo*

### Installing *sudo*
Switch to *root* and its environment via `su -`.
```
$ su -
```
Install *sudo* via `apt install sudo`.
```
$ apt install sudo
```
Verify whether *sudo* was successfully installed via `dpkg -l | grep sudo`.
```
$ dpkg -l | grep sudo
```

### Adding User to *sudo* Group
Add user to *sudo* group via `adduser <username> sudo`.
```
# adduser <username> sudo
```
>Alternatively, add user to *sudo* group via `usermod -aG sudo <username>`.
>```
># usermod -aG sudo <username>
>```
Verify whether user was successfully added to *sudo* group via `getent
group sudo`.
```
$ getent group sudo
```
`reboot` for changes to take effect, then log in and verify *sudopowers*
via `sudo -v`.

### Running *root*-Privileged Commands
From here on out, run *root*-privileged commands via prefix `sudo`. For
instance:
```
$ sudo apt update
```

### Configuring *sudo*
See [this page](https://superuser.com/questions/869144/why-does-the-system-have-etc-sudoers-d-how-should-i-edit-it)
if you want to learn more about sudo and the sudoers.d folder.

Configure *sudo* via `sudo vi /etc/sudoers.d/<filename>`. `<filename>` can
be whatever you want but it shall not end in `~` or contain `.`, let's name
it `config`.
```
$ sudo vi /etc/sudoers.d/config
```
Below are the options you need to change, see the [sudoers man page](https://www.sudo.ws/docs/man/1.8.13/sudoers.man/)
for more information.
```
Defaults passwd_tries=3
Defaults badpass_message="<custom-error-message>"
Defaults logfile="/var/log/sudo/<filename>"
Defaults log_input,log_output
Defaults iolog_dir="/var/log/sudo"
Defaults requiretty
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```

## SSH

### Installing & Configuring SSH
See the [sshd man page](https://man.openbsd.org/sshd_config) for more information.

Install *openssh-server* via `sudo apt install openssh-server`.
```
$ sudo apt install openssh-server
```
Configure SSH via `sudo vi /etc/ssh/sshd_config`.
```
$ sudo vi /etc/ssh/sshd_config
```
To set up SSH using Port 4242, replace below line:
```
#Port 22
```
with:
```
Port 4242
```
To disable SSH login as *root* irregardless of authentication mechanism,
replace below line
```
#PermitRootLogin prohibit-password
```
with:
```
PermitRootLogin no
```
Check SSH status via `sudo service ssh status`.
```
$ sudo service ssh status
```
>Alternatively, check SSH status via `systemctl status ssh`.
>```
>$ systemctl status ssh
>```

### Installing & Configuring UFW
Install *ufw* via `sudo apt install ufw`.
```
$ sudo apt install ufw
```
Verify whether *ufw* was successfully installed via `dpkg -l | grep ufw`.
```
$ dpkg -l | grep ufw
```
Enable Firewall via `sudo ufw enable`.
```
$ sudo ufw enable
```
Allow incoming connections using Port 4242 via `sudo ufw allow 4242`.
```
$ sudo ufw allow 4242
```
Check UFW status via `sudo ufw status`.
```
$ sudo ufw status
```

### Connecting to Server via SSH

**WARNING**: SSHing into the server might not work even if everything is
configured properly. If you have an IP address like the one in the
screenshot below chances are you will get this error:
```
setsockopt SO_KEEPALIVE: Invalid argument
write: Broken pipe
```

You can check the IP address of your machine using the `ip addr` command and
look for the second line beginning with inet:

![IP Screenshot](img/ip_addr.png)

SSH into your virtual machine using Port 4242 via `ssh
<username>@<ip-address> -p 4242`.
```
$ ssh <username>@<ip-address> -p 4242
```
Terminate SSH session at any time via `logout`.
```
$ logout
```
>Alternatively, terminate SSH session via `exit`.
>```
>$ exit
>```

## User Management

### Setting Up a Strong Password Policy

#### Password Age
Configure password age policy via `sudo vi /etc/login.defs`.
```
$ sudo vi /etc/login.defs
```
To set password to expire every 30 days, replace below line
```
PASS_MAX_DAYS   99999
```
with:
```
PASS_MAX_DAYS   30
```
To set minimum number of days between password changes to 2 days, replace
below line
```
PASS_MIN_DAYS   0
```
with:
```
PASS_MIN_DAYS   2
```
To send user a warning message 7 days *(defaults to 7 anyway)* before
password expiry, keep below line as is.
```
PASS_WARN_AGE   7
```

#### Password Strength
Secondly, to set up policies in relation to password strength, install the
*libpam-pwquality* package. See the [man page](https://linux.die.net/man/8/pam_pwquality)
for more informations.
```
$ sudo apt install libpam-pwquality
```
Configure password strength policy via `sudo vi
/etc/pam.d/common-password`, specifically the line containing:
```
pam_pwquality.so retry=3
```
To set password minimum length to 10 characters, add below option to the
above line.
```
minlen=10
```
To require password to contain at least an uppercase character and a
numeric character:
```
ucredit=-1 dcredit=-1
```
To set a maximum of 3 consecutive identical characters:
```
maxrepeat=3
```
To reject the password if it contains `<username>` in some form:
```
reject_username
```
To set the number of changes required in the new password from the old
password to 7:
```
difok=7
```
To implement the same policy on *root*:
```
enforce_for_root
```
Finally, it should look like the below:
```
password        requisite                       pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root
```

### Creating a New User
Create new user via `sudo adduser <username>`.
```
$ sudo adduser <username>
```
Verify whether user was successfully created via `getent passwd
<username>`.
```
$ getent passwd <username>
```
Verify newly-created user's password expiry information via `sudo chage -l
<username>`.
```
$ sudo chage -l <username>
Last password change					: <last-password-change-date>
Password expires					: <last-password-change-date + PASS_MAX_DAYS>
Password inactive					: never
Account expires						: never
Minimum number of days between password change		: <PASS_MIN_DAYS>
Maximum number of days between password change		: <PASS_MAX_DAYS>
Number of days of warning before password expires	: <PASS_WARN_AGE>
```

### Creating a New Group
Create new *user42* group via `sudo addgroup user42`.
```
$ sudo addgroup user42
```
Add user to *user42* group via `sudo adduser <username> user42`.
```
$ sudo adduser <username> user42
```
>Alternatively, add user to *user42* group via `sudo usermod -aG user42
><username>`.
>```
>$ sudo usermod -aG user42 <username>
>```
Verify whether user was successfully added to *user42* group via `getent
group user42`.
```
$ getent group user42
```

## *cron*

### Setting Up a *cron* Job
See the [crontab man page](https://man7.org/linux/man-pages/man5/crontab.5.html) for more information.
Configure *cron* as *root* via `sudo crontab -u root -e`.
```
$ sudo crontab -u root -e
```
To schedule a shell script to run every 10 minutes, replace below line
```
# m h  dom mon dow   command
```
with:
```
*/10 * * * * sh /path/to/script
```
Check *root*'s scheduled *cron* jobs via `sudo crontab -u root -l`.
```
$ sudo crontab -u root -l
```

## Bonus

### Installation
Watch *bonus* installation walkthrough *(no audio)*
[here(https://youtu.be/2w-2MX5QrQw).

### Linux Lighttpd MariaDB PHP *(LLMP)* Stack

#### Installing Lighttpd
Install *lighttpd* via `sudo apt install lighttpd`.
```
$ sudo apt install lighttpd
```
Verify whether *lighttpd* was successfully installed via `dpkg -l | grep
lighttpd`.
```
$ dpkg -l | grep lighttpd
```
Allow incoming connections using Port 80 via `sudo ufw allow 80`.
```
$ sudo ufw allow 80
```

#### Installing & Configuring MariaDB
Install *mariadb-server* via `sudo apt install mariadb-server`.
```
$ sudo apt install mariadb-server
```
Verify whether *mariadb-server* was successfully installed via `dpkg -l |
grep mariadb-server`.
```
$ dpkg -l | grep mariadb-server
```
Start interactive script to remove insecure default settings via `sudo
mysql_secure_installation`.
```
$ sudo mysql_secure_installation
Enter current password for root (enter for none): #Just press Enter (do not confuse database root with system root)
Set root password? [Y/n n
Remove anonymous users? [Y/n Y
Disallow root login remotely? [Y/n Y
Remove test database and access to it? [Y/n Y
Reload privilege tables now? [Y/n Y
```
Log in to the MariaDB console via `sudo mariadb`.
```
$ sudo mariadb
MariaDB [(none)>
```
Create new database via `CREATE DATABASE <database-name>;`.
```
MariaDB [(none)> CREATE DATABASE <database-name>;
```
Create new database user and grant them full privileges on the
newly-created database via `GRANT ALL ON <database-name>.* TO
'<username-2>'@'localhost' IDENTIFIED BY '<password-2>' WITH GRANT
OPTION;`.
```
MariaDB [(none)> GRANT ALL ON <database-name>.* TO '<username-2>'@'localhost' IDENTIFIED BY '<password-2>' WITH GRANT OPTION;
```
Flush the privileges via `FLUSH PRIVILEGES;`.
```
MariaDB [(none)> FLUSH PRIVILEGES;
```
Exit the MariaDB shell via `exit`.
```
MariaDB [(none)> exit
```
Verify whether database user was successfully created by logging in to the
MariaDB console via `mariadb -u <username-2> -p`.
```
$ mariadb -u <username-2> -p
Enter password: <password-2>
MariaDB [(none)>
```
Confirm whether database user has access to the database via `SHOW
DATABASES;`.
```
MariaDB [(none)> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| <database-name>    |
| information_schema |
+--------------------+
```
Exit the MariaDB shell via `exit`.
```
MariaDB [(none)> exit
```

#### Installing PHP
Install *php-cgi* & *php-mysql* via `sudo apt install php-cgi php-mysql`.
```
$ sudo apt install php-cgi php-mysql
```
Verify whether *php-cgi* & *php-mysql* was successfully installed via `dpkg
-l | grep php`.
```
$ dpkg -l | grep php
```

#### Downloading & Configuring WordPress
Install *wget* via `sudo apt install wget`.
```
$ sudo apt install wget
```
Download WordPress to `/var/www/html` via `sudo wget
http://wordpress.org/latest.tar.gz -P /var/www/html`.
```
$ sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
```
Extract downloaded content via `sudo tar -xzvf
/var/www/html/latest.tar.gz`.
```
$ sudo tar -xzvf /var/www/html/latest.tar.gz
```
Remove tarball via `sudo rm /var/www/html/latest.tar.gz`.
```
$ sudo rm /var/www/html/latest.tar.gz
```
Copy content of `/var/www/html/wordpress` to `/var/www/html` via `sudo cp
-r /var/www/html/wordpress/* /var/www/html`.
```
$ sudo cp -r /var/www/html/wordpress/* /var/www/html
```
Remove `/var/www/html/wordpress` via `sudo rm -rf /var/www/html/wordpress`
```
$ sudo rm -rf /var/www/html/wordpress
```
Create WordPress configuration file from its sample via `sudo cp
/var/www/html/wp-config-sample.php /var/www/html/wp-config.php`.
```
$ sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```
Configure WordPress to reference previously-created MariaDB database & user
via `sudo vi /var/www/html/wp-config.php`.
```
$ sudo vi /var/www/html/wp-config.php
```
Replace the below
```
23 define( 'DB_NAME', 'database_name_here' );^M
26 define( 'DB_USER', 'username_here' );^M
29 define( 'DB_PASSWORD', 'password_here' );^M
```
with:
```
23 define( 'DB_NAME', '<database-name>' );^M
26 define( 'DB_USER', '<username-2>' );^M
29 define( 'DB_PASSWORD', '<password-2>' );^M
```

#### Configuring Lighttpd
Enable below modules via `sudo lighty-enable-mod fastcgi; sudo
lighty-enable-mod fastcgi-php; sudo service lighttpd force-reload`.
```
$ sudo lighty-enable-mod fastcgi
$ sudo lighty-enable-mod fastcgi-php
$ sudo service lighttpd force-reload
```

### File Transfer Protocol *(FTP)*

#### Installing & Configuring FTP
Install FTP via `sudo apt install vsftpd`.
```
$ sudo apt install vsftpd
```
Verify whether *vsftpd* was successfully installed via `dpkg -l | grep
vsftpd`.
```
$ dpkg -l | grep vsftpd
```
Allow incoming connections using Port 21 via `sudo ufw allow 21`.
```
$ sudo ufw allow 21
```
Configure *vsftpd* via `sudo vi /etc/vsftpd.conf`.
```
$ sudo vi /etc/vsftpd.conf
```
To enable any form of FTP write command, uncomment below line:
```
31 #write_enable=YES
```
To set root folder for FTP-connected user to `/home/<username>/ftp`, add
below lines:
```
$ sudo mkdir /home/<username>/ftp
$ sudo mkdir /home/<username>/ftp/files
$ sudo chown nobody:nogroup /home/<username>/ftp
$ sudo chmod a-w /home/<username>/ftp
<~~~>
user_sub_token=$USER
local_root=/home/$USER/ftp
<~~~>
```
To prevent user from accessing files or using commands outside the
directory tree, uncomment below line:
```
114 #chroot_local_user=YES
```
To whitelist FTP, add below lines:
```
$ sudo vi /etc/vsftpd.userlist
$ echo <username> | sudo tee -a /etc/vsftpd.userlist
<~~~>
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
<~~~>
```

#### Connecting to Server via FTP
FTP into your virtual machine via `ftp <ip-address>`.
```
$ ftp <ip-address>
```
Terminate FTP session at any time via `CTRL + D`.

## Q&A - Preparing for the defense

This section gives you an overview of what you need to know for the defense.

### Why Debian?
See:
+ https://www.debian.org/
+ https://en.wikipedia.org/wiki/Debian

I chose Debian because it is easier to install and configure than CentOS,
and because I was already familiar with Debian.

### What is a virtual machine?
See:
+ https://en.wikipedia.org/wiki/VirtualBox
+ https://en.wikipedia.org/wiki/QEMU
+ https://en.wikipedia.org/wiki/Virtual_machine

In computing, a virtual machine is the virtualization/emulation of a
computer system. Virtual machines are based on computer architectures and
provide functionality of a physical computer. Their implementations may
involve specialized hardware or software. It allows the user to run several
operating systems on the same host, each VM being separated both from the
host and from other VMs.

### Why a VM?
VMs may be deployed to accommodate different levels of processing power
needs, to run software that requires a different operating system, or to
test applications in a safe, sandboxed environment.

### How does a VM works?
See:
+ https://en.wikipedia.org/wiki/Hardware_virtualization
+ https://en.wikipedia.org/wiki/Hypervisor

Virtual machines relies on virtualization e.g software used to simulate
virtual hardware that allows VMs to run on a single host machine.

### What is difference between apt and aptitude?
See:
+ https://en.wikipedia.org/wiki/APT_(software)
+ https://en.wikipedia.org/wiki/Aptitude_(software)

APT is a collection of tools distributed in a package named apt. A
significant part of APT is defined in a C++ library of functions; APT also
includes command-line programs for dealing with packages, which use the
library. Three such programs are *apt, apt-get and apt-cache*.

Basically apt is a package manager, a piece of software used to manage the
installation of programs, while aptitude is a frontend for apt which aims
to make it easier to use by providing a user interface based on ncurses.

### What is AppArmor and SELinux
See:
+ https://en.wikipedia.org/wiki/AppArmor
+ https://en.wikipedia.org/wiki/Security-Enhanced_Linux

These two programs are modules for the Linux kernel which aims to improve
the security of the system.

### What is SSH?
+ https://en.wikipedia.org/wiki/Secure_Shell

SSH (Secure Shell Protocol)`is a network protocol that gives users,
particularly system administrators, a secure way to access a computer
remotely over an unsecured network.

### How to create a new user?

```
$ sudo adduser username				# creating new user (yes (no))
$ sudo chage -l username			# Verify password expire info for new user
$ sudo adduser username sudo		# assign new user to the sudo group
$ sudo adduser username user42		# assign new user to the user42 group
```

### What to check?

```
$ lsblk									#  1) Check partitions
$ getent group sudo						#  3) sudo group users
$ sudo aa-status						#  2) AppArmor status
$ getent group user42					#  4) user42 group users
$ sudo service ssh status				#  5) ssh status, yep
$ sudo ufw status						#  6) ufw status
$ ssh username@ipadress -p 4242			#  7) connect to VM from your host (physical) machine via SSH
$ vi /etc/sudoers.d/<filename>			#  8) yes, sudo config file. You can $ ls /etc/sudoers.d first
$ vi /etc/login.defs					#  9) password expire policy
$ vi /etc/pam.d/common-password			# 10) password policy
$ sudo crontab -l						# 11) cron schedule
```

#### How to change hostname?
```
$ sudo vi /etc/hostname
```

#### Where is sudo logs in /var/log/sudo?
```
# The directories with names like 01 2B 9S 4D etc. contains the logs we need.
$ cd /var/log/sudo/00/00
$ sudo apt update 				# Now you see that we have a new directory here.
$ cd <nameofnewdirectory> && ls
$ cat log						#  Input log
$ cat ttyout					#  Output log
```

#### How to add and remove port 8080 in UFW?
```
$ sudo ufw allow 8080		# allow
$ sudo ufw status			# check
$ sudo ufw deny 8080		# deny
```

#### How to run script every 30 seconds?
Run `sudo crontab -e` and replace or comment (#) the following line :
```
*/1 * * * * /path/to/monitoring.sh
```
with
```
*/1 * * * * sleep 30s && /path/to/monitoring.sh
```
To stop the script from running on boot you just need to remove or comment
the following line:
```
@reboot /path/to/monitoring.sh
```
