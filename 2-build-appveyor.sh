#!/bin/bash
set -x
set -e
set -u

cd "${CLONE_DIR}"

if [ "${Configuration}" = "Debug" ]; then
  IS_DEBUG="true"
else
  IS_DEBUG="false"
fi

gn gen "out/${Configuration}" "--args=is_debug=${IS_DEBUG} target_cpu=\"x64\" is_clang=false"
ninja -C "out/${Configuration}"

mkdir -p "${INSTALL_DIR}/bin"
mkdir -p "${INSTALL_DIR}/lib"

cp "out/${Configuration}/libEGL"* "${INSTALL_DIR}/lib/"
cp "out/${Configuration}/libGLES"* "${INSTALL_DIR}/lib/"
cp "out/${Configuration}/shader_translator"* "${INSTALL_DIR}/bin/"
