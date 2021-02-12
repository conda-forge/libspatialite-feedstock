#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

export LDFLAGS="-L${PREFIX}/lib ${LDFLAGS}"
export CFLAGS="-I${PREFIX}/include  ${CFLAGS}"

# these files have hardcoded paths in them.  We don't need .la files anyway, so just remove it.
# if [ -f ${PREFIX}/${HOST}/lib/libstdc++.la ]; then
#    find ${PREFIX} -name "*.la" -print0 | xargs -0 rm
# fi

./configure --prefix=${PREFIX} \
            --host=${HOST} \
            --build=${BUILD} \
            --enable-static=no \
            --enable-minizip=no \
            --enable-rttopo=yes \
            --enable-gcp=yes

make
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi
make install
