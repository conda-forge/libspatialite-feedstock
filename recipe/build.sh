#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

export LDFLAGS="-L${PREFIX}/lib ${LDFLAGS}"
export CFLAGS="-I${PREFIX}/include  ${CFLAGS}"

# The license_family from conda_build_config.yaml defines if RTTOPO is supported.
if [ "$license_family" = "gpl" ]; then
    ENABLE_RTTOPO="yes"
    ENABLE_GCP="yes"
else
    ENABLE_RTTOPO="no"
    ENABLE_GCP="no"
fi
export ENABLE_RTTOPO
export ENABLE_GCP

# these files have hardcoded paths in them.  We don't need .la files anyway, so just remove it.
# if [ -f ${PREFIX}/${HOST}/lib/libstdc++.la ]; then
#    find ${PREFIX} -name "*.la" -print0 | xargs -0 rm
# fi

# config.sub and config.guess are very old (and don't support arm64, ppc64 etc)
# so update them
# See https://www.gaia-gis.it/fossil/libspatialite/tktview/6af9a4f1ffef472c11a11a8358ba79d9b70b7ca4
rm config.guess
rm config.sub
cp "${RECIPE_DIR}/config/config.guess" .
cp "${RECIPE_DIR}/config/config.sub" .

./configure --prefix=${PREFIX} \
            --host=${HOST} \
            --build=${BUILD} \
            --enable-static=no \
            --enable-minizip=no \
            --enable-rttopo=${ENABLE_RTTOPO} \
            --enable-gcp=${ENABLE_GCP}

make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check || (cat test/test-suite.log; exit 1)
fi
make install
