#!/bin/bash

REQUIRED_UTILS="apt-get wget tar python2"
APT_CANDIDATES="git build-essential libqt4-opengl mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract cramfsprogs cramfsswap squashfs-tools zlib1g-dev liblzma-dev liblzo2-dev"
PYTHON2_APT_CANDIDATES="python-lzma python-pip python-opengl python-qt4 python-qt4-gl python-numpy python-scipy"
PYTHON3_APT_CANDIDATES="python3-pip python3-opengl python3-pyqt4 python3-pyqt4.qtopengl python3-numpy python3-scipy"
APT_CANDIDATES="$APT_CANDIDATES $PYTHON2_APT_CANDIDATES"
PIP_COMMANDS="pip"

# Check for root privileges
if [ $UID -eq 0 ]
then
    SUDO=""
else
    SUDO="sudo"
    REQUIRED_UTILS="sudo $REQUIRED_UTILS"
fi

function install_sasquatch
{
    git clone https://github.com/devttys0/sasquatch
    (cd sasquatch && make && $SUDO make install)
    $SUDO rm -rf sasquatch
}

function install_jefferson
{
    $SUDO pip install cstruct
    git clone https://github.com/sviehb/jefferson
    (cd jefferson && $SUDO python2 setup.py install)
    $SUDO rm -rf jefferson
}

function install_unstuff
{
    mkdir -p /tmp/unstuff
    cd /tmp/unstuff
    wget -O - http://my.smithmicro.com/downloads/files/stuffit520.611linux-i386.tar.gz | tar -zxv
    $SUDO cp bin/unstuff /usr/local/bin/
    cd -
    rm -rf /tmp/unstuff
}

function install_pip_package
{
    PACKAGE="$1"

    for PIP_COMMAND in $PIP_COMMANDS
    do
        $SUDO $PIP_COMMAND install $PACKAGE
    done
}

function find_path
{
    FILE_NAME="$1"

    echo -ne "checking for $FILE_NAME..."
    which $FILE_NAME > /dev/null
    if [ $? -eq 0 ]
    then
        echo "yes"
        return 0
    else
        echo "no"
        return 1
    fi
}

# Make sure the user really wants to do this
echo ""
echo "WARNING: This script will download and install all required and optional dependencies for binwalk."
echo "         This script has only been tested on, and is only intended for, Debian based systems."
echo "         Some dependencies are downloaded via unsecure (HTTP) protocols."
echo "         This script requires internet access."
echo "         This script requires root privileges."
echo ""
echo -n "Continue [y/N]? "
read YN
if [ "$(echo "$YN" | grep -i -e 'y' -e 'yes')" == "" ]
then
    echo "Quitting..."
    exit 1
fi

# Check to make sure we have all the required utilities installed
NEEDED_UTILS=""
for UTIL in $REQUIRED_UTILS
do
    find_path $UTIL
    if [ $? -eq 1 ]
    then
        NEEDED_UTILS="$NEEDED_UTILS $UTIL"
    fi
done

if [ "$NEEDED_UTILS" != "" ]
then
    echo "Please install the following required utilities: $NEEDED_UTILS"
    exit 1
fi

# Check to see if we should install modules for python3 as well
find_path python3
if [ $? -eq 0 ]
then
    APT_CANDIDATES="$APT_CANDIDATES $PYTHON3_APT_CANDIDATES"
    PIP_COMMANDS="pip3 $PIP_COMMANDS"
fi

cd /tmp
$SUDO apt-get install -y $APT_CANDIDATES
install_pip_package pyqtgraph
install_pip_package capstone
install_sasquatch
install_jefferson
install_unstuff

