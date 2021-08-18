# cli-tool-ppa
PPA for KeySpot CLI Tool

# Installation
```bash
curl -s --compressed "https://keyspot.github.io/cli-tool-ppa/KEY.gpg" | sudo apt-key add -
sudo curl -s --compressed -o /etc/apt/sources.list.d/keyspot-cli-tool.list "https://keyspot.github.io/cli-tool-ppa/keyspot-cli-tool.list"
sudo apt update

sudo apt install keyspot
```

# Setup Instructions for KeySpot Devs
https://assafmo.github.io/2019/05/02/ppa-repo-hosted-on-github.html