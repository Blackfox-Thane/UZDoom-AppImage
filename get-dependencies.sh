#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
  openmp 		\
  openal 		\
  sdl2     	\
  libvpx 		\
  libwebp 	\
  waylandpp

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package zmusic

# If the application needs to be manually built that has to be done down here
echo "Making UZDoom..."
echo "---------------------------------------------------------------"
DIR="UZDoom"
REPO_URL="https://github.com/UZDoom/UZDoom.git"

if [ -d "$DIR" ]; then
  cd "$DIR" && git pull
else
  git clone "$REPO_URL" "$DIR"
fi

if [ -d "$DIR" ]; then
  mkdir -p $DIR/build
  cd "$DIR/build"
else
  mkdir -p $DIR/build
fi

cmake                                \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo  \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DBUILD_SHARED_LIBS=OFF            \
  -G Ninja                           \
  ..

cmake --build .

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
