#!/usr/bin/python3

import os

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