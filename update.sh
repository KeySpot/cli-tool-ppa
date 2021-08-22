#!/bin/bash

# requires git, dpkg, apt-utls, gpg

#!/usr/bin/python3

# def makeDeb(binary, version, architecture):
#     import os
#     from shutil import copyfile
    
#     packageName = "keyspot"
#     maintainer = "Carl Schader"
#     maintainerEmail = "carlschader@gmail.com"
#     descriptionShort = "Application secrets manager."
#     descriptionLong = "The keyspot CLI tool offers an interface for accessing the KeySpot(https://keyspot.app) web app through the terminal. One of the primary functions of the keyspot CLI tool is the injection of application secrets into a program or command as environment variables."

#     controlString = "Package: {packageName}\nVersion: {version}\nArchitecture: {architecture}\nMaintainer: {maintainer} <{maintainerEmail}>\nDescription: {descriptionShort}\n {descriptionLong}\n".format(
#         packageName=packageName,
#         version=version, 
#         architecture=architecture,
#         maintainer=maintainer,
#         maintainerEmail=maintainerEmail,
#         descriptionShort=descriptionShort,
#         descriptionLong=descriptionLong
#     )

#     dirname = "{packageName}_{version}-1_{architecture}".format(
#         packageName=packageName, 
#         version=version, 
#         architecture=architecture
#     )

#     os.mkdir(dirname)
#     os.mkdir("{0}/usr".format(dirname))
#     os.mkdir("{0}/usr/local".format(dirname))
#     os.mkdir("{0}/usr/local/bin".format(dirname))
#     os.mkdir("{0}/DEBIAN".format(dirname))

#     newBinary = "{0}/usr/local/bin/{1}".format(dirname, binary.split('/')[len(binary.split('/')) - 1])

#     copyfile(binary, newBinary)
#     os.chmod(newBinary, 0o755)
    
#     controlFile = open("{0}/DEBIAN/control".format(dirname), 'w')
#     controlFile.write(controlString)
#     controlFile.close()

#     os.system("dpkg-deb --build --root-owner-group {packageName}_{version}-1_{architecture}".format(
#         packageName=packageName,
#         version=version,
#         architecture=architecture
#     ))

#     os.system("rm -rf " + dirname)

# def main():
#     import sys
#     makeDeb(sys.argv[1], sys.argv[2], sys.argv[3])

# if __name__ == "__main__":
#     main()

# 
email="carlschader@gmail.com"
repoUrl="https://github.com/keyspot/cli-tool.git"
repoDir="cli-tool/"
packageName="keyspot"
maintainer="Carl Schader"
descriptionShort="Application secrets manager."
descriptionLong="The keyspot CLI tool offers an interface for accessing the KeySpot(https://keyspot.app) web app through the terminal. One of the primary functions of the keyspot CLI tool is the injection of application secrets into a program or command as environment variables."

rm -rf *.deb

git clone $repoUrl
cd $repoDir
git fetch --all --tags

version=$(git describe --tags --abbrev=0)

cd ../
rm -rf $repoDir

declare -A urls

urls["arm64"]="https://github.com/KeySpot/cli-tool/releases/download/${version}/cli-tool_${version:1}_Linux_arm64.tar.gz"
urls["i386"]="https://github.com/KeySpot/cli-tool/releases/download/${version}/cli-tool_${version:1}_Linux_i386.tar.gz"
urls["amd64"]="https://github.com/KeySpot/cli-tool/releases/download/${version}/cli-tool_${version:1}_Linux_x86_64.tar.gz"

for i in "${!urls[@]}"
do
    wget -O "$i.tar.gz" "${urls[$i]}"
    tar -xf "$i.tar.gz"

    controlString="Package: ${packageName}\nVersion: ${version:1}\nArchitecture: ${architecture}\nMaintainer: ${maintainer} <${maintainerEmail}>\nDescription: ${descriptionShort}\n ${descriptionLong}\n"
    dirname="${packageName}_${version:1}-1_${i}"

    mkdir -p $dirname/usr/local/bin
    mkdir $dirname/DEBIAN
    
    mv keyspot $dirname/usr/local/bin/keyspot
    chmod 555 $dirname/usr/local/bin/keyspot

    echo $controlString > $dirname/DEBIAN/control

    dpkg-deb --build --root-owner-group ${packageName}_${version:1}-1_${i}

    rm -rf "$i.tar.gz" $dirname
done

dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
gpg --default-key $email -abs -o - Release > Release.gpg
gpg --default-key $email --clearsign -o - Release > InRelease

git add .
git commit -m $version
git push origin main
