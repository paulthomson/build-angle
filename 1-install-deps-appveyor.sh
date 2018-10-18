#!/bin/bash
set -x
set -e
set -u

GITHUB_RELEASE_TOOL_USER="c4milo"
GITHUB_RELEASE_TOOL_VERSION="v1.1.0"
GITHUB_RELEASE_TOOL_ARCH="windows_amd64"

mkdir temp
cd temp


curl -fsSL -o github-release.tar.gz "https://github.com/${GITHUB_RELEASE_TOOL_USER}/github-release/releases/download/${GITHUB_RELEASE_TOOL_VERSION}/github-release_${GITHUB_RELEASE_TOOL_VERSION}_${GITHUB_RELEASE_TOOL_ARCH}.tar.gz"

7z x github-release.tar.gz
7z x github-release.tar
cd ..

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
git checkout 08faab99d41bd4f1f727267586ff28a227f80cd3
cd ..

git clone https://chromium.googlesource.com/angle/angle "${CLONE_DIR}"
cd "${CLONE_DIR}"
git checkout $(cat ../COMMIT_ID)
python scripts/bootstrap.py
gclient sync
