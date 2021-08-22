#!/usr/bin/python3

def makeDeb(binary, version, architecture):
    import os
    from shutil import copyfile
    
    packageName = "keyspot"
    maintainer = "Carl Schader"
    maintainerEmail = "carlschader@gmail.com"
    descriptionShort = "Application secrets manager."
    descriptionLong = "The keyspot CLI tool offers an interface for accessing the KeySpot(https://keyspot.app) web app through the terminal. One of the primary functions of the keyspot CLI tool is the injection of application secrets into a program or command as environment variables."

    controlString = "Package: {packageName}\nVersion: {version}\nArchitecture: {architecture}\nMaintainer: {maintainer} <{maintainerEmail}>\nDescription: {descriptionShort}\n {descriptionLong}\n".format(
        packageName=packageName,
        version=version, 
        architecture=architecture,
        maintainer=maintainer,
        maintainerEmail=maintainerEmail,
        descriptionShort=descriptionShort,
        descriptionLong=descriptionLong
    )

    dirname = "{packageName}_{version}-1_{architecture}".format(
        packageName=packageName, 
        version=version, 
        architecture=architecture
    )

    os.mkdir(dirname)
    os.mkdir("{0}/usr".format(dirname))
    os.mkdir("{0}/usr/local".format(dirname))
    os.mkdir("{0}/usr/local/bin".format(dirname))
    os.mkdir("{0}/DEBIAN".format(dirname))

    newBinary = "{0}/usr/local/bin/{1}".format(dirname, binary.split('/')[len(binary.split('/')) - 1])

    copyfile(binary, newBinary)
    os.chmod(newBinary, 0o755)
    
    controlFile = open("{0}/DEBIAN/control".format(dirname), 'w')
    controlFile.write(controlString)
    controlFile.close()

    os.system("dpkg-deb --build --root-owner-group {packageName}_{version}-1_{architecture}".format(
        packageName=packageName,
        version=version,
        architecture=architecture
    ))

    os.system("rm -rf " + dirname)

def main():
    import sys
    makeDeb(sys.argv[1], sys.argv[2], sys.argv[3])

if __name__ == "__main__":
    main()