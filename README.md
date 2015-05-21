Ansible Debian source install script
====================================

This script will help you install an up to date version of ansible on any current Debian release.
It will execute all steps as described in the ansible install documentation, which can be found here: http://docs.ansible.com/intro_installation.html#running-from-source

###Getting started
Simply copy the skript into a directory of your choice and execute it. 
All dependencies should be resolved automatically. The script will clean up anything unneeded after compiling the desired ansible version. 
Re-Installing to another ansible version using this script IS possible, jumping between stable-1.9 and devel worked both ways on deb/jessie and deb/wheezy.

###Command line options
If you want to bypass the version selection inside the script, you can instead call it using:

######install.sh (--stable | --devel)

    --stable: Install the latest stable version. Please understand that this will checkout the sole remote branch listed as "stable"
    --devel: checks out the latest development branch 

###Debian versions

This script has been tested on 
- wheezy (7.6, 7.7, 7.8)
- jessie (8.0)

###License
This script is released under the MIT license, see license.