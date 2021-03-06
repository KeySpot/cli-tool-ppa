# KeySpot CLI Tool

KeySpot CLI Tool allows users to interface with the KeySpot secrets manager from the terminal. The tool is primarily used to take secrets stored with KeySpot and inject them into a process or command as environment variables. This is especially useful for CI/CD pipelines that require access to secret-based credentials, such as AWS or Google Cloud Platform's API keys. To store records with KeySpot, go to [keyspot.app](https://keyspot.app)

# Installation

The KeySpot CLI Tool can be installed on Linux, Mac, and Windows.

## Linux (Ubuntu/Debian)

```bash
curl -s --compressed "https://keyspot.github.io/cli-tool-ppa/KEY.gpg" | sudo apt-key add -
sudo curl -s --compressed -o /etc/apt/sources.list.d/keyspot.list "https://keyspot.github.io/cli-tool-ppa/keyspot.list"
sudo apt update

sudo apt install keyspot
```

## Mac

```bash
brew tap keyspot/cli

brew install keyspot
```

## Windows

```bash
scoop bucket add keyspot https://github.com/keyspot/scoop-bucket

scoop install keyspot
```

# Commands

## run

To inject a record into a process/command as environment variables, use "keyspot run".

```bash
keyspot run "npm start" -k <record-access-key>
```

### run options

* -k, --key: Access key of record to be used
* -r, --record: Name of record to be used. Requires the cli tool to be configured to an account, see the configure command.

## configure

When given a cli token from the KeySpot website https://keyspot.app/account, running the configure command with the token will link the token's account to the keyspot cli tool. This allows a user to specify documents by name instead of just by access key, among other features.

```bash
keyspot configure <cli-token>
```

## export

Export a record stored with KeySpot as a file following the .env file syntax. Use one of the options to
specify which KeySpot record to export. <NEW-FILE-PATH> is the name of the new exported file.

```bash
keyspot export <NEW-FILE-PATH> [export command options]
```

### export options

* -k, --key: Access key of record to be used
* -r, --record: Name of record to be used. Requires the cli tool to be configured to an account, see the configure command.

## import

Import a .env file into KeySpot. The FILE-PATH specified is the .env file you want to import while RECORD-NAME is the name of the record in KeySpot to create. If RECORD-NAME already exists in your account then the record will be overwritten. Requires your CLI tool to be configured.

```bash
keyspot import <FILE-PATH> <RECORD-NAME>
```

## version

```bash
keyspot version
```

Prints the current installed version of KeySpot CLI Tool.

## help

At any time you can see all sub-commands keyspot has access to by passing the --help or -h flag.

```bash
keyspot -h
```

Too see the options for a specific sub-command pass the -h flag after that command.

```bash
keyspot run -h
```