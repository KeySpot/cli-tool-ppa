#!/bin/bash

# requires git, wget, dpkg, apt-utls, gnupg

email="carlschader@gmail.com"
packageName="keyspot"
maintainer="Carl Schader"
descriptionShort="Application secrets manager."
descriptionLong="The keyspot CLI tool offers an interface for accessing the KeySpot(https://keyspot.app) web app through the terminal. One of the primary functions of the keyspot CLI tool is the injection of application secrets into a program or command as environment variables."

rm -rf *.deb

version=$(git ls-remote --tags https://github.com/keyspot/cli-tool.git | tail -n 1 | sed 's/.*refs\/tags\///g')

gpg --import private-key.asc

declare -A urls

urls["arm64"]="https://github.com/KeySpot/cli-tool/releases/download/${version}/cli-tool_${version:1}_Linux_arm64.tar.gz"
urls["i386"]="https://github.com/KeySpot/cli-tool/releases/download/${version}/cli-tool_${version:1}_Linux_i386.tar.gz"
urls["amd64"]="https://github.com/KeySpot/cli-tool/releases/download/${version}/cli-tool_${version:1}_Linux_x86_64.tar.gz"

for i in "${!urls[@]}"
do
    wget -O "$i.tar.gz" "${urls[$i]}"
    tar -xf "$i.tar.gz"

    controlString="Package: ${packageName}\nVersion: ${version:1}\nArchitecture: ${i}\nMaintainer: ${maintainer} <${maintainerEmail}>\nDescription: ${descriptionShort}\n ${descriptionLong}\n"
    dirname="${packageName}_${version:1}-1_${i}"

    mkdir -p $dirname/usr/local/bin
    mkdir $dirname/DEBIAN
    
    mv cli-tool $dirname/usr/local/bin/keyspot
    chmod 555 $dirname/usr/local/bin/keyspot

    echo -e $controlString > $dirname/DEBIAN/control

    dpkg-deb --build --root-owner-group ${packageName}_${version:1}-1_${i}

    rm -rf "$i.tar.gz" $dirname
done

dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
echo RedGreenBlue@1 | gpg --passphrase-fd 0 --default-key $email -abs -o - Release > Release.gpg
echo RedGreenBlue@1 | gpg --passphrase-fd 0 --default-key $email --clearsign -o - Release > InRelease

git config --global user.email "carlschader@gmail.com"
git config --global user.name "carlschader"
# git remote add origin https://$GITHUB_TOKEN@github.com/keyspot/cli-tool-ppa.git

git add .
git commit -m $version
git push https://$GITHUB_TOKEN@github.com/keyspot/cli-tool-ppa.git
