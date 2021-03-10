#!/bin/bash

export LDFLAGS="-L${PREFIX}/lib ${LDFLAGS}"
export CFLAGS="-I${PREFIX}/include  ${CFLAGS}"

# these files have hardcoded paths in them.  We don't need .la files anyway, so just remove it.
# if [ -f ${PREFIX}/${HOST}/lib/libstdc++.la ]; then
#    find ${PREFIX} -name "*.la" -print0 | xargs -0 rm
# fi

# config.sub and config.guess are very old (and don't support arm64, ppc64 etc)
# so update them
# See https://www.gaia-gis.it/fossil/libspatialite/tktview/6af9a4f1ffef472c11a11a8358ba79d9b70b7ca4
rm config.guess
curl -o config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
rm config.sub
curl -o config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'

./configure --prefix=${PREFIX} \
            --host=${HOST} \
            --build=${BUILD} \
            --enable-static=no \
            --enable-minizip=no \
            --enable-rttopo=yes \
            --enable-gcp=yes

make
make check || (cat test/test-suite.log; exit 1)
make install
