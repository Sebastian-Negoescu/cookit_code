
#!/bin/bash
################################################################################
##  File:  python.sh
##  Team:  CI-Platform
##  Desc:  Installs Python 2/3 and related tools (pip, pypy)
################################################################################

# Set Home Agent Tools Directory
AGENT_TOOLSDIRECTORY=/home/ansible/myAgent/_work/_tool

# Install Python, Python 3, pip, pip3
sudo apt-get install -y --no-install-recommends python python-dev python-pip python3 python3-dev python3-pip

# Install PyPy 2.7 to $AGENT_TOOLSDIRECTORY
wget -q -P /tmp https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v7.1.0-linux64.tar.bz2
tar -x -C /tmp -f /tmp/pypy2.7-v7.1.0-linux64.tar.bz2
rm /tmp/pypy2.7-v7.1.0-linux64.tar.bz2
mkdir -p $AGENT_TOOLSDIRECTORY/PyPy/2.7.13
mv /tmp/pypy2.7-v7.1.0-linux64 $AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64
touch $AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64.complete

# add pypy to PATH by default
sudo ln -s $AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64/bin/pypy /usr/local/bin/pypy
# pypy will be the python in PATH when its tools cache directory is prepended to PATH
# PEP 394-style symlinking; don't bother with minor version
sudo ln -s $AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64/bin/pypy $AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64/bin/python2
sudo ln -s $AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64/bin/python2 $AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64/bin/python

# Install latest Pip for PyPy2
$AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64/bin/pypy -m ensurepip
$AGENT_TOOLSDIRECTORY/PyPy/2.7.13/x64/bin/pypy -m pip install --ignore-installed pip






# Install PyPy 3.5 to $AGENT_TOOLSDIRECTORY
wget -q -P /tmp https://bitbucket.org/pypy/pypy/downloads/pypy3.5-v7.0.0-linux64.tar.bz2
tar -x -C /tmp -f /tmp/pypy3.5-v7.0.0-linux64.tar.bz2
rm /tmp/pypy3.5-v7.0.0-linux64.tar.bz2
mkdir -p $AGENT_TOOLSDIRECTORY/PyPy/3.5.3
mv /tmp/pypy3.5-v7.0.0-linux64 $AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64
touch $AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64.complete

# add pypy3 to PATH by default
sudo ln -s $AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64/bin/pypy3 /usr/local/bin/pypy3
# pypy3 will be the python in PATH when its tools cache directory is prepended to PATH
# PEP 394-style symlinking; don't bother with minor version
sudo ln -s $AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64/bin/pypy3 $AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64/bin/python3
sudo ln -s $AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64/bin/python3 $AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64/bin/python

# Install latest Pip for PyPy3
$AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64/bin/pypy3 -m ensurepip
$AGENT_TOOLSDIRECTORY/PyPy/3.5.3/x64/bin/pypy3 -m pip install --ignore-installed pip



# MAKE THE ACTUAL PYTHON V3.8.1 BE USED BY THE AGENT
wget -q -P /tmp https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
tar -x -C /tmp -f /tmp/Python-3.8.1.tgz
rm /tmp/Python-3.8.1.tgz
mkdir -p $AGENT_TOOLSDIRECTORY/Python/3.8.1/x64
cd /tmp/Python-3.8.1
sudo apt-get install zlib1-dev
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
./configure --prefix=$AGENT_TOOLSDIRECTORY/Python/3.8.1/x64 --with-zlib=/usr/include
make
make install

# YOU SHOULD NOW BE ABLE TO USE THE AZ DEVOPS PYTHON TASK











# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected, and basic scenarios work"
for cmd in python pip pypy python3 pip3 pypy3; do
    if ! command -v $cmd; then
        echo "$cmd was not installed or not found on PATH"
        exit 1
    fi
done

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "Python ($(python --version 2>&1))"
DocumentInstalledItem "pip ($(pip --version))"
DocumentInstalledItem "Python3 ($(python3 --version))"
DocumentInstalledItem "pip3 ($(pip3 --version))"
DocumentInstalledItem "PyPy2 ($(pypy --version 2>&1 | grep PyPy))"
DocumentInstalledItem "PyPy3 ($(pypy3 --version 2>&1 | grep PyPy))"
