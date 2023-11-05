
:: configure step doesn't run on Windows. Set these
:: manually
set CF_FLAGS=/DGEOS_3100=1 /DGEOS_3110=1

nmake /f makefile64.vc
if errorlevel 1 exit 1

nmake /f makefile64.vc install
if errorlevel 1 exit 1

nmake /f makefile64.vc clean
if errorlevel 1 exit 1

nmake /f makefile_mod64.vc
if errorlevel 1 exit 1

nmake /f makefile_mod64.vc install
if errorlevel 1 exit 1

