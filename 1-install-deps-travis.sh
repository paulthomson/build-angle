#!/bin/bash
set -x
set -e
set -u

sudo mkdir -p /data/bin
sudo chmod uga+rwx /data/bin
sudo chmod uga+rwx /data

GITHUB_RELEASE_TOOL_USER="c4milo"
GITHUB_RELEASE_TOOL_VERSION="v1.1.0"


if [ "$(uname)" == "Darwin" ];
then
  brew install p7zip md5sha1sum
  GITHUB_RELEASE_TOOL_ARCH="darwin_amd64"
fi

if [ "$(uname)" == "Linux" ];
then
  sudo apt-get update
  sudo apt-get -y install g++ git wget zip tar p7zip-full libxi-dev libgl1-mesa-dev libpci-dev
  GITHUB_RELEASE_TOOL_ARCH="linux_amd64"
fi

pushd /data
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
git checkout 08faab99d41bd4f1f727267586ff28a227f80cd3
popd

pushd /data/bin
wget "https://github.com/${GITHUB_RELEASE_TOOL_USER}/github-release/releases/download/${GITHUB_RELEASE_TOOL_VERSION}/github-release_${GITHUB_RELEASE_TOOL_VERSION}_${GITHUB_RELEASE_TOOL_ARCH}.tar.gz"
tar xf "github-release_${GITHUB_RELEASE_TOOL_VERSION}_${GITHUB_RELEASE_TOOL_ARCH}.tar.gz"
popd

git clone https://chromium.googlesource.com/angle/angle "${CLONE_DIR}"
cd "${CLONE_DIR}"
git checkout $(cat ../COMMIT_ID)
python scripts/bootstrap.py
gclient sync

# Modify the build to statically link standard libraries on Linux.

cp BUILD.gn _
cat _ | awk '
/config\("external_config"\)/ {
  print $0
  print "  if (is_linux) {"
  print "    ldflags = [ \"-static-libgcc\", \"-static-libstdc++\" ]"
  print "  }"
  next
}

{
  print $0
}
' > BUILD.gn
