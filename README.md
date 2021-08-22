# cli-tool
KeySpot CLI tool for accessing records and injecting variables into an environment without needing .env files

```bash
curl -s --compressed "https://keyspot.github.io/cli-tool-ppa/KEY.gpg" | sudo apt-key add -
sudo curl -s --compressed -o /etc/apt/sources.list.d/keyspot.list "https://keyspot.github.io/cli-tool-ppa/keyspot.list"
sudo apt update

sudo apt install keyspot
```