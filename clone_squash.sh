#!/usr/bin/bash

ICON_MOUNT=${1}
ICON_RUN=${2}

rm -rf ${ICON_RUN}
mkdir ${ICON_RUN}

pushd ${ICON_RUN} >/dev/null 2>&1

# Link all level 1 items
# ----------------------
for item in ${ICON_MOUNT}/*; do
    ln -s ${item} .
done

# Some files need modifications
# -----------------------------
# setting
rm -f setting
cp ${ICON_MOUNT}/setting .
# Only if using icon4py
echo "export ICON4PY_VENV=$(realpath ./externals/icon4py/.venv)" >> setting
echo "export PYTHONOPTIMIZE=2" >> setting
echo "export GT4PY_BUILD_CACHE_DIR=$(pwd)" >> setting
echo "export GT4PY_BUILD_CACHE_LIFETIME=persistent" >> setting

# set-up.info
rm -rf run
mkdir run
pushd run >/dev/null 2>&1
for item in ${ICON_MOUNT}/run/*; do
    ln -s ${item} .
done
rm -f set-up.info
cp ${ICON_MOUNT}/run/set-up.info .
popd >/dev/null 2>&1
echo "use_builddir=$(pwd)" >> run/set-up.info

popd >/dev/null 2>&1
