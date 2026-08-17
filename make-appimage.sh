#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(wget -qO- https://api.github.com/repos/UZDoom/UZDoom/releases/latest | grep -oP '"tag_name": "\K[^"]+')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/UZDoom/UZDoom/refs/heads/trunk/src/posix/freedesktop/org.zdoom.UZDoom.svg
export DESKTOP=https://raw.githubusercontent.com/UZDoom/UZDoom/refs/heads/trunk/src/posix/freedesktop/org.zdoom.UZDoom.desktop
export DEPLOY_VULKAN=1
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
