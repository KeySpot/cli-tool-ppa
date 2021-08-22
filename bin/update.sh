dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
gpg --default-key "carlschader@gmail.com" -abs -o - Release > Release.gpg
gpg --default-key "carlschader@gmail.com" --clearsign -o - Release > InRelease