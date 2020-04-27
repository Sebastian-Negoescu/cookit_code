#!/bin/bash

VERSION="3.8.1" # Or modify it as desired (https://www.python.org/ftp/python/ --> all versions; recommended with x.y.z format)

# assure everything is in place in terms of prereqs
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

echo "[*] Installing Python $VERSION";
AGENT_TOOLSDIRECTORY=/home/ansible/myAgent/_work/_tool
PYTHONFOLDER=$AGENT_TOOLSDIRECTORY/Python/$VERSION/x64

cd /tmp/
wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz
tar -xf Python-$VERSION.tar.xz
cd Python-$VERSION
./configure --prefix=$PYTHONFOLDER

make -j`nproc`
make altinstall
touch $AGENT_TOOLSDIRECTORY/Python/$VERSION/x64.complete

cd ..

rm Python-$VERSION.tar.xz
rm -rf Python-$VERSION

# create symlinks
cd $AGENT_TOOLSDIRECTORY/Python/$VERSION/x64/bin
ln -s $(find -name 'python*' ! -name '*config' ! -name '*m') python
ln -s pip* pip
cd /azp/

echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "Python $VERSION"