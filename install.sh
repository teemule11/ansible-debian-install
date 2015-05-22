#!/bin/bash
if [ "$1" == "--devel" ]; then
    choice=0
elif [ "$1" == "--stable" ]; then
    choice=1
else
    echo "+++++++++++++++++++++++++++++++"
    echo "Ansible install script..."
    echo 
    echo "You can choose whether to use the STABLE or the DEVELOPMENT version of ansible:"
    echo
    # Unless you wish to install the latest devel version, choose to switch to the latest stable release:

    PS3='Please choose which version you want to install: '

    select option in "Current stable version" "Active development version"
    do
        case $option in
            "Current stable version") 
                echo;choice=1;break;;
            "Active development version") 
                echo;choice=0;break;;
        esac
    done    
    
fi

apt-get update

# Install dependencies
# be aware: we install everything using --no-recommends. Asciidoc will take long to install otherwise, giving you 600MB of tex stuff
apt-get --no-install-recommends install -y build-essential cdbs debhelper dpkg-dev git-core reprepro asciidoc devscripts sshpass fakeroot

# these are the python dependencies for ansible
apt-get --no-install-recommends install -y python-yaml python-paramiko python-jinja2 python-setuptools python-httplib2 python-support

# It is important to have the --recursive option, otherwise ansible will throw the "ImportError: No module named modules"-message
git clone https://github.com/ansible/ansible.git --recursive

# get version of ansible stable release:
relver=$(sed '1,/Released/d' ansible/RELEASES.txt |  sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,4\}[0-9][^.]\).*/\1/p' | sed '2,$d')
# New as of v1.9: We have one branch named stable - lets find it:
stablever=$(git --git-dir=./ansible/.git branch --list *stable* --remote )
version="${stablever/origin\//}"


if [ $choice -eq 1 ]; then
    res="$version"
    try="$relver"
else
    res="devel"
    try="devel"
fi

(cd ansible; git checkout $res )

cd ansible
make deb

# do the install - and keep config files if present
dpkg --force-confold -i deb-build/unstable/ansible*.deb

# and clean up
cd ..
rm -rf ansible
echo -e "\n\n################################\n"
echo -e "DONE! Please verify that the correct Ansible version is running:"
echo -e "(minor version differences may happen, I tried to install the \n latest version according to ansible/releases.txt)\n"
echo -e ">>> Tried to install: $try\n>>> Really installed ansible version:"
ansible --version
