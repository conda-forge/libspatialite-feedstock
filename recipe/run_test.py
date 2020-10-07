import os
import sys
import ctypes
import sqlite3

if sys.platform == 'win32':
    path = os.path.join(sys.prefix, 'Library', 'bin', 'spatialite.dll')
elif sys.platform == 'darwin':
    # LD_LIBRARY_PATH not set on OS X or Linux.
    path = os.path.expandvars('$PREFIX/lib/libspatialite.dylib')
elif sys.platform.startswith('linux'):
    path = os.path.expandvars('$PREFIX/lib/libspatialite.so')
else:
    raise Exception('Cannot recognize platform {!r}'.format(sys.platform))
# make sure the dynamic library can be found and loads
libfreexl = ctypes.CDLL(path)

if sys.platform == 'win32':
    path = os.path.join(sys.prefix, 'Library', 'bin', 'mod_spatialite.dll')
elif sys.platform == 'darwin':
    # LD_LIBRARY_PATH not set on OS X or Linux.
    path = os.path.expandvars('$PREFIX/lib/mod_spatialite.dylib')
elif sys.platform.startswith('linux'):
    path = os.path.expandvars('$PREFIX/lib/mod_spatialite.so')
else:
    raise Exception('Cannot recognize platform {!r}'.format(sys.platform))
# make sure the dynamic library can be found and loads
libfreexl = ctypes.CDLL(path)

# Test loading the resulting SQLite3 extension
db = sqlite3.connect(':memory:')
db.enable_load_extension(True)
db.execute("SELECT load_extension(?)", [path])
db.enable_load_extension(False)
db.close()
