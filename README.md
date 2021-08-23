# KeySpot CLI Tool

KeySpot CLI Tool allows users to interface with the KeySpot secrets manager from the terminal. The tool is primarily used to take secrets stored with KeySpot and inject them into a process or command as environment variables. This is especially useful for CI/CD pipelines that require access to secret-based credentials, such as AWS or Google Cloud Platform's API keys.

# Installation

```bash
curl -s --compressed "https://keyspot.github.io/cli-tool-ppa/KEY.gpg" | sudo apt-key add -
sudo curl -s --compressed -o /etc/apt/sources.list.d/keyspot.list "https://keyspot.github.io/cli-tool-ppa/keyspot.list"
sudo apt update

sudo apt install keyspot
```