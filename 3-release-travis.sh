#!/bin/bash
set -x
set -e
set -u

shopt -s extglob


echo "${INSTALL_DIR}"
echo "${COMMIT_ID}"
echo "${RELEASE_ZIP}"

cd "${INSTALL_DIR}"
# All files except "obj" dir
7z a "../${RELEASE_ZIP}.zip" !(obj)
cd ..

github-release \
  paulthomson/build-angle \
  "v-${COMMIT_ID}" \
  "${COMMIT_ID}" \
  "$(echo -e "Automated build.\n$(git log --graph -n 3 --abbrev-commit --pretty='format:%h - %s <%an>')")" \
  "${RELEASE_ZIP}.zip"

