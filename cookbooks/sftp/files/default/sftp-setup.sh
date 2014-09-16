#!/bin/bash
user=$1
if [ ! $user ];then
    exit 1
fi

writeable_dir="public"
#Change the base directory if you want the jail root elsewhere
base_dir="/home/jails"
jails=`/bin/grep jails /etc/group | wc -l`

# Add jails group
if [ $jails == "0" ];then
  groupadd jails
fi
# create user note home dir is relative to chroot jail root
usercheck=`grep -c "$user:" /etc/passwd`
if [ $usercheck != "0" ];then
   exit 1
fi
useradd -g jails -s /bin/false $user
# create user's home directory and writeable_dir directory
mkdir -p $base_dir/$user
# make root owner of user's home
chown root:root $base_dir/$user
# ensure only root can write - required by openssh chroot
chmod 755 $base_dir/$user
# make writeable_dir dir for user
mkdir $base_dir/$user/$writeable_dir
# make public the home dir for user
usermod -d public $user
# change owner of writeable_dir dir to user
chown $user:jails $base_dir/$user/$writeable_dir
# ensure the correct write permissions for user
chmod 0775 $base_dir/$user/$writeable_dir
# check to make sure /bin/false in /etc/shells
shellcheck=`grep -c "/bin/false" /etc/shells`

#Fix from engineyard
#sudo groupmems -a navision -g jails
#sudo chmod 2775 /home/jails/navision/public/to_navision ( I think this was already set, but just to be sure)
#sudo chmod 2775 /home/jails/navision/public/to_navision/archive

if [ $shellcheck == "0" ];then
   echo "/bin/false" >> /etc/shells
fi


#/etc/ssh/sshd_config

exit 0