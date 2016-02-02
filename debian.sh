#!/bin/bash

APP=libdeep
PREV_VERSION=1.00
VERSION=1.00
RELEASE=1
ARCH_TYPE=`uname -m`
DIR=${APP}-${VERSION}

if [ $ARCH_TYPE == "x86_64" ]; then
    ARCH_TYPE="amd64"
fi
if [ $ARCH_TYPE == "i686" ]; then
    ARCH_TYPE="i386"
fi
if [ $ARCH_TYPE == "armv7l" ]; then
    ARCH_TYPE="armhf"
fi


# Update version numbers automatically - so you don't have to
sed -i 's/VERSION='${PREV_VERSION}'/VERSION='${VERSION}'/g' Makefile
sed -i 's/-'${PREV_VERSION}'.so/-'${VERSION}'.so/g' debian/*.links

make clean
make

# change the parent directory name to debian format
mv ../${APP} ../${DIR}

# Create a source archive
make source
if [ ! "$?" = "0" ]; then
    mv ../${DIR} ../${APP}
    exit 2
fi

# Build the package
dpkg-buildpackage -i -F
if [ ! "$?" = "0" ]; then
    mv ../${DIR} ../${APP}
    exit 3
fi

# sign files
#gpg -ba ../${APP}_${VERSION}-1_${ARCH_TYPE}.deb
#gpg -ba ../${APP}_${VERSION}.orig.tar.gz

# restore the parent directory name
mv ../${DIR} ../${APP}

if [ ! -f ../${APP}0_${VERSION}-${RELEASE}_${ARCH_TYPE}.deb ]; then
    echo "Failed to build ../${APP}0_${VERSION}-${RELEASE}_${ARCH_TYPE}.deb"
    exit 1
fi

echo 'Running lintian checks...'
lintian ../${APP}0_${VERSION}-${RELEASE}_${ARCH_TYPE}.deb

echo 'Build complete'
