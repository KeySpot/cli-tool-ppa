#!/usr/bin/python3

# Requires goreleaser and dpkg

from makeDeb import makeDeb
import os
import requests

def getVersion(repoUrl):
    repoDir = repoUrl.split("/")[-1].replace(".git", "")
    os.system("git clone " + repoUrl)

    os.chdir(repoDir)

    os.system("git fetch --all --tags")

    version = os.popen("git tag").read().split("\n")
    version = version[len(version) - 2]

    os.chdir("../")
    os.system("rm -rf " + repoDir)

    return version

email = "carlschader@gmail.com"
repoUrl = "https://github.com/keyspot/cli-tool.git"

binPath = os.path.dirname(os.path.realpath(__file__))
root = binPath + "/../"

os.chdir(root)

os.system("rm -rf *.deb")

version = getVersion(repoUrl)

urls = {
    "arm64": "https://github.com/KeySpot/cli-tool/releases/download/{0}/cli-tool_{1}_Linux_arm64.tar.gz".format(version, version[1:]),
    "i386": "https://github.com/KeySpot/cli-tool/releases/download/{0}/cli-tool_{1}_Linux_i386.tar.gz".format(version, version[1:]),
    "amd64": "https://github.com/KeySpot/cli-tool/releases/download/{0}/cli-tool_{1}_Linux_x86_64.tar.gz".format(version, version[1:])
}

for architecture in urls:
    response = requests.get(urls[architecture], stream=True)
    zipName = architecture + ".tar.gz"
    with open(zipName, "wb") as file:
        file.write(response.raw.read())
    os.system("tar -xf " + zipName)
    makeDeb("cli-tool", version[1:], architecture)
    os.system("rm -rf " + zipName + " cli-tool")

os.system("dpkg-scanpackages --multiversion . > Packages")
os.system("gzip -k -f Packages")

os.system("apt-ftparchive release . > Release")
os.system('gpg --default-key "{}" -abs -o - Release > Release.gpg'.format(email))
os.system('gpg --default-key "{}" --clearsign -o - Release > InRelease'.format(email))

os.system("git add .")
os.system('git commit -m "{}"'.format(version))
os.system('git push origin main')
