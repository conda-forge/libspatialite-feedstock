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
# Test if geos basic support is available
db.execute("SELECT ST_Buffer(ST_GeomFromText('POINT (5 5)'), 5) AS geom")
# Test if geos-advanced is available
db.execute("SELECT GEOSMinimumRotatedRectangle(ST_GeomFromText('POINT (5 5)')) AS geom")
# Test if geos 3100 support is available
db.execute("SELECT GeosMakeValid(ST_GeomFromText('POINT (5 5)')) AS geom")
# Test if geos 3110 support is available
sql = """
    SELECT HilbertCode(
               ST_GeomFromText('POINT (5 5)'),
               ST_GeomFromText('POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0))'),
               5
           ) AS geom
"""
db.execute(sql)

db.enable_load_extension(False)
db.close()
