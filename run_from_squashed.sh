#!/usr/bin/bash

set -e


# ========================================
# Init
# ========================================

# Uenv
# ----
UENV=${UENV:-"icon/26.2:2592419933"}
SQUASHED_ICON=${SQUASHED_ICON:-"/capstor/scratch/cscs/leclairm/tmp/icon-nwp_add_icon4py_santis.icon4py.nvhpc.squashfs"}


# ========================================
# Link and copy from mounted icon dir
# ========================================

ICON_MOUNT=${ICON_MOUNT:-"$(realpath ./ICON_MOUNT)"}
ICON_RUN=${ICON_RUN:-"$(realpath ./ICON_RUN)"}

rm -rf ${ICON_MOUNT}
mkdir ${ICON_MOUNT}
uenv run ${SQUASHED_ICON}:${ICON_MOUNT} -- ./clone_squash.sh ${ICON_MOUNT} ${ICON_RUN}


# ========================================
# Run
# ========================================

pushd ${ICON_RUN} >/dev/null 2>&1

EXP=mch_icon-ch2_small
uenv run ${SQUASHED_ICON}:${ICON_MOUNT} -- ./make_runscripts ${EXP}

pushd run >/dev/null 2>&1
sbatch --uenv ${UENV},${SQUASHED_ICON}:${ICON_MOUNT} --view default \
    --time 00:30:00 \
    --account cwd01 \
    --partition debug \
    ./exp.${EXP}.run
popd >/dev/null 2>&1

popd >/dev/null 2>&1
