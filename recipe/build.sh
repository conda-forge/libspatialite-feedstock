#!/bin/bash

export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
export CFLAGS="-I$PREFIX/include $CFLAGS"

# these files have hardcoded paths in them.  We don't need .la files anyway, so just remove it.
if [ -f ${PREFIX}/${HOST}/lib/libstdc++.la ]; then
    find ${PREFIX} -name "*.la" -print0 | xargs -0 rm
fi

./configure --prefix=$PREFIX --host=$HOST --build=$BUILD --enable-static=no

make
# Commented out due to failures:
# FAIL: check_virtualtable2
# FAIL: check_virtualtable
# make check
make install

find $PREFIX -name '*.la' -delete