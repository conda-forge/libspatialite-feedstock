
nmake /f makefile.vc
if errorlevel 1 exit 1

nmake /f makefile.vc install
if errorlevel 1 exit 1

nmake /f makefile.vc clean
if errorlevel 1 exit 1

nmake /f makefile_mod.vc
if errorlevel 1 exit 1

nmake /f makefile_mod.vc install
if errorlevel 1 exit 1

