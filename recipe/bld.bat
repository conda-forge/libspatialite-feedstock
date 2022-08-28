
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

