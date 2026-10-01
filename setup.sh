#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

echo "Setting up your Mac from dotfiles..."

# 1. Install Homebrew (if not present)
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

# 2. Install packages from Brewfile
echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. Symlink dotfiles
echo "Linking dotfiles..."
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig

# 4. Set up Android SDK (if not present)
if [ ! -d "$HOME/Library/Android/sdk" ]; then
  echo "Installing Android SDK..."
  brew install --cask android-commandlinetools
  yes | sdkmanager --licenses
  sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
fi

# 5. Set up Java (if not present)
if [ -z "$(/usr/libexec/java_home -v 17 2>/dev/null)" ]; then
  echo "Installing Java 17..."
  brew install --cask temurin@17
fi

echo ""
echo "Setup complete! Restart your terminal to apply all changes."
echo ""
echo "Manual steps remaining:"
echo "  - Install Unity Hub from https://unity.com/download"
echo "  - Install Parallels from https://www.parallels.com/"
echo "  - Configure Alfred, Bitwarden, and other GUI apps"
echo "  - Set up SSH keys: ssh-keygen -t ed25519 -C 'your_email'"
