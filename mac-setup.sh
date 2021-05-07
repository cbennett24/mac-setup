#!/bin/bash

DEV_FOLDER=~/developer
DROPBOX_FOLDER=~/dropbox
PREFERENCES_FOLDER="${DROPBOX_FOLDER}"/preferences
SUBLIME_PREFERENCES_SOURCE="${PREFERENCES_FOLDER}"/sublime/user
SUBLIME_PREFERENCES_DEST=~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
ALFRED_PREFERENCES_SOURCE="${PREFERENCES_FOLDER}"/alfred/Alfred.alfredpreferences
PERSONAL_FOLDER="${DEV_FOLDER}"/personal
GITHUB_USERNAME=cbennett24
MAC_SETUP_REPO=mac-setup
DOTFILES_REPO=dotfiles

set -e

clear

echo "*************************************************************************"
echo "**                              Mac Setup                              **"
echo "*************************************************************************"
echo -e "\n"

if [ -d /Applications/Xcode.app -o -d ~/Applications/Xcode.app ]; then
  printf "  ✅  Xcode installed.\n"
  if xcode-select --print-path > /dev/null; then
    printf "  ✅  Command Line Tools installed.\n"
  else
    printf "  ❗️  Command Line Tools are not installed.\n"
    printf "  🔶  Attempting to install Command Line Tools...\n"
    xcode-select --install
    printf "  ✅  Command Line Tools installed.\n"
  fi
else
  printf "  ❗️  Xcode is not installed.\n\nPlease install Xcode and then re-run this script."
  open /Applications/App\ Store.app
  return 1
fi

if [ -f ~/.ssh/id_rsa.pub ]; then
  printf "  ✅  SSH Key exists.\n\n"
else
  printf "\n  🔶  Setting up your SSH key...\n"
  read -p "Please enter your email address... carefully: "
  printf "  🔶  Attempting to create SSH key...\n"
  ssh-keygen -t rsa -C "$REPLY"
  printf "  ✅  SSH Key created.\n"
fi

printf "  🔶  Copying public key to the clipboard...\n"
pbcopy < ~/.ssh/id_rsa.pub
printf "  ✅  SSH Key copied to the clipboard.\n\n"

read -p "  🔶  Log on to Github to add your SSH key. When you've done that, return here and press 'C' to continue...  " -n 1 -r

if [[ $REPLY =~ ^[Cc]$ ]]; then
  printf "\n\n  ✅  SSH key added to Github\n"
fi

printf "  🔶  Moving to ${DEV_FOLDER}...\n"
cd "${DEV_FOLDER}"

# mac-setup
if [ ! -d "${DEV_FOLDER}"/"${MAC_SETUP_REPO}" ] ; then
  printf "  🔶  Attempting to clone mac-setup repo...\n"
  git clone git@github.com:"${GITHUB_USERNAME}"/"${MAC_SETUP_REPO}".git
  printf "  ✅  mac-setup repo cloned.\n"
else∏∏
  printf "  ✅  mac-setup repo already exists.\n"
fi

# dotfiles
if [ ! -d "${DEV_FOLDER}"/"${DOTFILES_REPO}" ]; then
  printf "  🔶  Attempting to clone dotfiles repo...\n"
  git clone git@github.com:"${GITHUB_USERNAME}"/"${DOTFILES_REPO}".git
  printf "  ✅  dotfiles repo cloned.\n"
else
  printf "  ✅  dotfiles repo already exists.\n"
fi

# Install Homebrew (package manager).
if ! which -s brew; then
  printf "  🔶  Installing Homebrew...\n"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  printf "  ✅  Homebrew installed\n\n"
fi

# Validate Homebrew dependencies.
if brew config && brew doctor; then
	# Install core Homebrew binaries, casks, and App Store apps.
	printf "  🔶  Installing core Homebrew binaries, casks, and App Store apps...\n"
	brew bundle --file="${MAC_SETUP_REPO}"/brewfiles/Brewfile.core
	printf "  ✅  Brew core apps installed\n"

	# Switch to using brew-installed bash as default shell
	if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
	  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
	  chsh -s /usr/local/bin/bash;
	fi;

	# Remove older versions of formulae from the cellar
	brew cleanup

	printf "\n\nYour Mac set-up is now complete.\n"
else
	printf "\n ❌  Something is wrong with homebrew.\n\n"
	return 1
fi

if [ -d "${SUBLIME_PREFERENCES_DEST}" ]; then
   ln -s "${SUBLIME_PREFERENCES_SOURCE}" "${SUBLIME_PREFERENCES_DEST}"
else
   echo "Sublime preferences have not synced yet. Manually link them in once they have."
fi

return 0
