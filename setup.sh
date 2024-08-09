#!/bin/bash

readonly NODE_VERSION=20.16.0

readonly PHP_VERSION=7.4
readonly PHP_VERSION_FULL=7.4.33_6
readonly PCRE2_VERSION=10.44

readonly ZSH_CONFIG_FILE=$HOME/.zshrc

readonly SSH_KEY_FILE=$HOME/.ssh/id_ed25519
readonly SSH_KEY_FILE_PUB=$HOME/.ssh/id_ed25519.pub
readonly SSH_CONFIG_FILE=$HOME/.ssh/config

readonly GIT_REPO_DIR=$HOME/Development/test

# ===========================================
# STEP 01. INSTALL HOMEBREW
# ===========================================

# Check if Homebrew is installed
if [[ ! $(brew --version) ]]; then
    # Install Homebrew
    echo "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" | bash
fi

printf "✅ Homebrew is installed\n"


# ===========================================
# STEP 02. INSTALL AND CONFIGURE GIT
# ===========================================

# Check if Git is installed
if [[ ! $(git --version) ]]; then
    # Install Git
    brew install git
fi

GIT_USERNAME=$(git config user.name)
GIT_EMAIL=$(git config user.email)

if [[ -z $GIT_USERNAME ]]; then
    echo "Enter your full name: "
    read GIT_USERNAME
    git config --global user.name $GIT_USERNAME
    echo "Git username set to $GIT_USERNAME"
fi

if [[ -z $GIT_EMAIL ]]; then
    echo "Enter your email address: "
    read GIT_EMAIL
    git config --global user.email $GIT_EMAIL
    echo "Git email set to $GIT_EMAIL"
fi

printf "✅ Git is installed\n"


# ===========================================
# STEP 03. INSTALL AND CONFIGURE ZSH
# ===========================================

# Check if Zsh is installed
if [[ ! $(zsh --version) ]]; then
    # Install Zsh
    brew install zsh
fi

printf "✅ ZSH is installed\n"


# ===========================================
# STEP 04. GENERATE SSH KEY & CONFIGURE SSH
# ===========================================

if [[ ! -f $SSH_KEY_FILE ]]; then
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C $GIT_EMAIL -f $SSH_KEY_FILE -N ""
fi

echo "✅ SSH key generated"

# Create SSH config file if it doesn't exist
if [[ ! -f $SSH_CONFIG_FILE ]]; then
    touch $SSH_CONFIG_FILE
fi


# ===========================================
# STEP 05. INSTALL NVM AND NODE.JS
# ===========================================

# Check if NVM is installed
if [[ ! -d $HOME/.nvm ]]; then

    echo "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh)" | bash

    echo "" > $ZSH_CONFIG_FILE
    echo "# ====================================" >> $ZSH_CONFIG_FILE
    echo "# NVM Configuration" >> $ZSH_CONFIG_FILE
    echo "# ====================================" >> $ZSH_CONFIG_FILE
    echo "" >> $ZSH_CONFIG_FILE
    echo "export NVM_DIR=\"$HOME/.nvm\"" >> $ZSH_CONFIG_FILE
    echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> $ZSH_CONFIG_FILE
    echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"" >> $ZSH_CONFIG_FILE

    source $ZSH_CONFIG_FILE

fi

source $HOME/.nvm/nvm.sh
CURRENT_NODE_VERSION=$(nvm current)

if [[ $CURRENT_NODE_VERSION != "v${NODE_VERSION}" ]]; then
    echo "Installing Node version ${NODE_VERSION}"
    nvm install ${NODE_VERSION}
    nvm use ${NODE_VERSION}
fi

printf "✅ NVM is installed\n"


# ===========================================
# STEP 06. INSTALL & CONFIGURE PNPM
# ===========================================

# Check if PNPM is installed
if [[ ! $(pnpm --version) ]]; then
    npm install -g pnpm
fi


# ===========================================
# STEP 07. INSTALL & CONFIGURE PHP
# ===========================================

# Check if PHP is installed
if [[ ! $(php --version) ]]; then
    brew tap shivammathur/php
    brew install shivammathur/php/php@${PHP_VERSION}
    brew link --overwrite --force shivammathur/php/php@${PHP_VERSION}
fi

# Check if PCRE2 is installed
if [[ ! $(brew list | grep pcre2) ]]; then
    brew install pcre2
fi

# Copy pcre2.h to PHP include directory
if [[ -f /opt/homebrew/Cellar/pcre2/${PCRE2_VERSION}/include/pcre2.h ]]; then
    cp /opt/homebrew/Cellar/pcre2/${PCRE2_VERSION}/include/pcre2.h /opt/homebrew/Cellar/php@${PHP_VERSION}/${PHP_VERSION_FULL}/include/php/ext/pcre
fi

# Check if the APCU extension is installed
if [[ ! $(php -m | grep apcu) ]]; then
    pecl install apcu
fi


# ===========================================
# STEP 08. INSTALL & CONFIGURE COMPOSER
# ===========================================

# Check if Composer is installed
if [[ ! $(composer --version) ]]; then
    brew install composer
fi


# ===========================================
# STEP 09. INSTALL & CONFIGURE DOCKER
# ===========================================

# Check if Docker is installed
if [[ ! $(docker --version) ]]; then
    brew install --cask docker
fi


# ===========================================
# STEP 10. SET UP GIT REPOSITORIES
# ===========================================

# Create the Git repository directory if it doesn't exist
if [[ ! -d $GIT_REPO_DIR ]]; then
    mkdir -p $GIT_REPO_DIR
fi


# # ===========================================
# # Development Applications
# # ===========================================

# # Install Visual Studio Code
# brew install --cask visual-studio-code

# # Install Docker Desktop
# brew install --cask docker

# # Install HTTPie
# brew install --cask httpie


# # ====================================
# # Utility Applications
# # ====================================

# # Install 1Password
# brew install --cask 1password

# # Install Raycast
# brew install --cask raycast


# # ====================================
# # Browser Applications
# # ====================================

# # Install Google Chrome
# brew install --cask google-chrome

# # Install Firefox
# brew install --cask firefox

# # Install Microsoft Edge
# brew install --cask microsoft-edge


# # ====================================
# # Communication Applications
# # ====================================

# # Install Slack
# brew install --cask slack

# # Install Microsoft Outlook
# brew install --cask microsoft-outlook

# # Install Microsoft Teams
# brew install --cask microsoft-teams


# # ====================================
# # Miscellaneous Applications
# # ====================================

# # Install Spotify
# brew install --cask spotify