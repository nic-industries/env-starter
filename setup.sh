#!/bin/bash

{ # this ensures the entire script is downloaded #

if [[ "$EUID" -ne 0 ]]; then
    sudo curl -o- https://raw.githubusercontent.com/nic-industries/env-starter/main/setup.sh | bash
    exit 1
fi

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
GRAY='\033[0;37m'
NC='\033[0m'
BOLD='\033[1m'

readonly NODE_VERSION=20.16.0

readonly PHP_VERSION=7.4
readonly PHP_VERSION_FULL=7.4.33_6
readonly PCRE2_VERSION=10.44

readonly ZSH_CONFIG_FILE=$HOME/.zshrc

readonly SSH_KEY_FILE=$HOME/.ssh/id_ed25519
readonly SSH_KEY_FILE_PUB=$HOME/.ssh/id_ed25519.pub
readonly SSH_CONFIG_FILE=$HOME/.ssh/config

readonly GIT_REPO_DIR=$HOME/Development/test

COMMAND_LINE_TOOLS_INSTALLED=false

function should_install_command_line_tools {
    if [[ $(
        xcode-select -p 1>/dev/null
        echo $?
    ) == 0 ]]; then
        return 1
    else
        return 0
    fi
}

# Extract the version number from the string
# Usage: extract_version "git version 2.33.0"
# Output: 2.33.0
function extract_version {
    local version_string=$1
    local version_number=$(echo $version_string | grep -oE "([0-9]+)(\.[0-9]+)(\.[0-9]+)?")
    # Return the first match
    echo "v"$version_number | cut -d ' ' -f 1
}

function press_any_key {
    read -n 1 -s -r -p "Press any key to continue ..."
    echo
}

clear
echo ""
echo -e "${BOLD}NIC Development Environment Setup${NC}"
echo ""
echo -e "${GRAY}Welcome to the NIC Web Development Team!${NC}"
echo -e "${GRAY}This script will guide you through setting up your dev environment.${NC}"
echo -e "${GRAY}Please follow the instructions carefully.${NC}"
echo ""
press_any_key

# ===========================================
# STEP 00. INSTALL XCODE COMMAND LINE TOOLS
# ===========================================

echo ""
echo "==============================================="
echo "Step 00. Xcode Command Line Tools"
echo "==============================================="
echo ""

if should_install_command_line_tools; then
    xcode-select --install
else
    COMMAND_LINE_TOOLS_INSTALLED=true
fi

echo $COMMAND_LINE_TOOLS_INSTALLED

# # ===========================================
# # STEP 01. INSTALL HOMEBREW
# # ===========================================

# echo ""
# echo "==============================================="
# echo "Step 01. Homebrew"
# echo "==============================================="
# echo ""

# echo -ne "🕒 ${YELLOW}Checking if Homebrew is installed ...${NC}"\\r
# sleep 2

# # Check if Homebrew is installed
# if [[ ! $(which brew) ]]; then
#     # Homebrew is not installed
#     echo -ne "🟡 ${YELLOW}Installing Homebrew...${NC}"\\r
#     # Install Homebrew
#     echo "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" | bash
#     echo -e "🟢 ${GREEN}Homebrew $(extract_version "$(brew --version)") has been installed${NC}"
# else
#     # Homebrew is already installed
#     echo -e "🔵 ${BLUE}Homebrew is already installed${NC}${GRAY} ...... $(extract_version "$(brew --version)")${NC}"
# fi

# # ===========================================
# # STEP 02. INSTALL AND CONFIGURE GIT
# # ===========================================
# echo -ne "🕒 ${YELLOW}Checking if Git is installed ...${NC}"\\r
# sleep 2

# # Check if Git is installed
# if [[ ! $(which git) ]]; then
#     # Git is not installed
#     echo -ne "🟡 ${YELLOW}Installing Git...${NC}"\\r
#     # Install Git
#     brew install git
#     echo -e "🟢 ${GREEN}Git installed successfully${NC}"
# else
#     # Git is already installed
#     echo -e "🔵 ${BLUE}Git is already installed${NC}${GRAY} ........... $(extract_version "$(git --version)")${NC}"
# fi

# GIT_USERNAME=$(git config user.name)
# GIT_EMAIL=$(git config user.email)

# if [[ -z $GIT_USERNAME ]]; then
#     echo "Enter your full name: "
#     read GIT_USERNAME
#     git config --global user.name $GIT_USERNAME
#     echo "Git username set to $GIT_USERNAME"
# fi

# if [[ -z $GIT_EMAIL ]]; then
#     echo "Enter your email address: "
#     read GIT_EMAIL
#     git config --global user.email $GIT_EMAIL
#     echo "Git email set to $GIT_EMAIL"
# fi

# if [[ ! $(which gh) ]]; then

#     # Install GitHub CLI
#     brew install gh

#     # Authenticate with GitHub
#     gh auth login --git-protocol ssh --skip-ssh-key --web --scopes admin:ssh_signing_key,admin:public_key

# fi

# # ===========================================
# # STEP 03. INSTALL AND CONFIGURE ZSH
# # ===========================================
# echo -ne "🕒 ${YELLOW}Checking if ZSH is installed ...${NC}"\\r
# sleep 2

# # Check if Zsh is installed
# if [[ ! $(which zsh) ]]; then
#     # Zsh is not installed
#     echo -ne "🟡 ${YELLOW}Installing Zsh...${NC}"\\r
#     # Install Zsh
#     brew install zsh
#     echo -e "🟢 ${GREEN}Zsh installed successfully${NC}"
# else
#     # Zsh is already installed
#     echo -e "🔵 ${BLUE}ZSH is already installed${NC}${GRAY} .............. $(extract_version "$(zsh --version)")${NC}"
# fi

# # ===========================================
# # STEP 04. GENERATE SSH KEY & CONFIGURE SSH
# # ===========================================

# # echo ""
# # echo "==============================================="
# # echo "Step 04. SSH"
# # echo "==============================================="
# # echo ""

# # # Check if SSH key file exists
# # if [[ ! -f $SSH_KEY_FILE ]]; then
# #     # SSH key file does not exist
# #     echo -ne "🟡 ${YELLOW}Generating SSH key file...${NC}"\\r
# #     # echo "ssh-keygen -t ed25519 -C $GIT_EMAIL -f $SSH_KEY_FILE -N \"\"" | bash
# #     sleep 2
# #     echo -e "🟢 ${GREEN}SSH key generated successfully${NC}"
# # else
# #     # SSH key file already exists
# #     echo -e "🔵 ${BLUE}SSH key file already exists${NC}${GRAY} ...... $SSH_KEY_FILE${NC}"
# # fi

# # Create SSH config file if it doesn't exist
# # if [[ ! -f $SSH_CONFIG_FILE ]]; then
# #     touch $SSH_CONFIG_FILE
# # fi

# # ===========================================
# # STEP 05. INSTALL NVM AND NODE.JS
# # ===========================================

# # Check if NVM is installed
# if [[ ! -d $HOME/.nvm ]]; then

#     # NVM is not installed
#     echo -ne "🟡 ${YELLOW}Installing NVM...${NC}"\\r

#     # Install NVM
#     echo "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh)" | bash
#     echo -e "🟢 ${GREEN}SSH key generated successfully${NC}"

#     echo "" > $ZSH_CONFIG_FILE
#     echo "# ====================================" >> $ZSH_CONFIG_FILE
#     echo "# NVM Configuration" >> $ZSH_CONFIG_FILE
#     echo "# ====================================" >> $ZSH_CONFIG_FILE
#     echo "" >> $ZSH_CONFIG_FILE
#     echo "export NVM_DIR=\"$HOME/.nvm\"" >> $ZSH_CONFIG_FILE
#     echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> $ZSH_CONFIG_FILE
#     echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"" >> $ZSH_CONFIG_FILE

#     source $ZSH_CONFIG_FILE

# else

#     # NVM is already installed
#     source $HOME/.nvm/nvm.sh
#     echo -e "🔵 ${BLUE}NVM is already installed${NC}${GRAY} ........... $(extract_version "$(nvm --version)")${NC}"

# fi

# source $HOME/.nvm/nvm.sh
# CURRENT_NODE_VERSION=$(nvm current)

# if [[ $CURRENT_NODE_VERSION != "v${NODE_VERSION}" ]]; then
#     echo "Installing Node version ${NODE_VERSION}"
#     nvm install ${NODE_VERSION}
#     nvm use ${NODE_VERSION}
# fi

# # ===========================================
# # STEP 06. INSTALL & CONFIGURE PNPM
# # ===========================================

# # Check if PNPM is installed
# if [[ ! $(which pnpm) ]]; then
#     brew install pnpm
# fi

# # ===========================================
# # STEP 07. INSTALL & CONFIGURE PHP
# # ===========================================

# # Check if PHP is installed
# if [[ ! $(which php) ]]; then
#     brew tap shivammathur/php
#     brew install shivammathur/php/php@${PHP_VERSION}
#     brew link --overwrite --force shivammathur/php/php@${PHP_VERSION}
# else
#     echo -e "🔵 ${BLUE}PHP is already installed${NC}${GRAY} ........... $(extract_version "$(php --version)")${NC}"
# fi

# # Check if PCRE2 is installed
# if [[ ! $(brew list | grep pcre2) ]]; then
#     brew install pcre2
# fi

# # Copy pcre2.h to PHP include directory
# if [[ -f /opt/homebrew/Cellar/pcre2/${PCRE2_VERSION}/include/pcre2.h ]]; then
#     cp /opt/homebrew/Cellar/pcre2/${PCRE2_VERSION}/include/pcre2.h /opt/homebrew/Cellar/php@${PHP_VERSION}/${PHP_VERSION_FULL}/include/php/ext/pcre
# fi

# # Check if the APCU extension is installed
# if [[ ! $(php -m | grep apcu) ]]; then
#     pecl install apcu
# fi

# # ===========================================
# # STEP 08. INSTALL & CONFIGURE COMPOSER
# # ===========================================

# # Check if Composer is installed
# if [[ ! $(which composer) ]]; then
#     brew install composer
# fi

# # ===========================================
# # STEP 09. INSTALL & CONFIGURE DOCKER
# # ===========================================

# # Check if Docker is installed
# if [[ ! $(which docker) ]]; then
#     brew install --cask docker
# fi

# # ===========================================
# # STEP 10. SET UP GIT REPOSITORIES
# # ===========================================

# # Create the Git repository directory if it doesn't exist
# if [[ ! -d $GIT_REPO_DIR ]]; then
#     mkdir -p $GIT_REPO_DIR
# fi

# # # ===========================================
# # # Development Applications
# # # ===========================================

# # # Install Visual Studio Code
# # brew install --cask visual-studio-code

# # # Install Docker Desktop
# # brew install --cask docker

# # # Install HTTPie
# # brew install --cask httpie

# # # ====================================
# # # Utility Applications
# # # ====================================

# # # Install 1Password
# # brew install --cask 1password

# # # Install Raycast
# # brew install --cask raycast

# # # ====================================
# # # Browser Applications
# # # ====================================

# # # Install Google Chrome
# # brew install --cask google-chrome

# # # Install Firefox
# # brew install --cask firefox

# # # Install Microsoft Edge
# # brew install --cask microsoft-edge

# # # ====================================
# # # Communication Applications
# # # ====================================

# # # Install Slack
# # brew install --cask slack

# # # Install Microsoft Outlook
# # brew install --cask microsoft-outlook

# # # Install Microsoft Teams
# # brew install --cask microsoft-teams

# # # ====================================
# # # Miscellaneous Applications
# # # ====================================

# # # Install Spotify
# # brew install --cask spotify

} # this ensures the entire script is downloaded #