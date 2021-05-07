# My Mac Setup

This repo contains a set of instructions and scripts that I use to set up my environment for work and play. It's a fork of https://github.com/ursooperduper/mac-setup.

## Step 1: Install XCode via the App Store

Homebrew relies on build tools that are a part of XCode, so before you do anything else, download that.

* [Xcode](https://developer.apple.com/xcode/)

## Step 2: Download this repo

At this stage, Github access hasn't been set up on the system, so  grab this repo using `curl`.

```
mkdir -p ~/developer
cd ~/developer
curl -O https://github.com/cbennett24/mac-setup/archive/master.zip
```

## Step 3: Run mac-setup.sh

Navigate to the `mac-setup` directory and run the mac-setup script.

```
cd ~/developer/mac-setup
./mac-setup.sh
```

The mac-setup script does the following:

* Checks to see if Xcode is installed (and exits if it's not installed)
* Checks for (and installs Command Line Tools)
* Agrees to the Xcode ToS
* Creates an SSH key (& copies it to the clipboard) and prompts you to add it to Github
* Creates a working directory (~/developer)
* Installs Homebrew and Cask (versions, apps, fonts)
* Installs mas which then lets you install your App Store apps
* Installs Homebrew binaries, Cask binaries, and App Store apps
