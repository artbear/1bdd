@chcp 65001

"%ProgramFiles(x86)%\OneScript\bin\oscript.exe" -encoding=utf-8 c:\projects\1testrunner\testrunner.os -runall tests xddReportPath tests

@if %ERRORLEVEL%==2 GOTO good_exit
@if %ERRORLEVEL%==0 GOTO good_exit

exit /B 1

:good_exit

"%ProgramFiles(x86)%\OneScript\bin\oscript.exe" -encoding=utf-8 src\bdd.os features/core -junit-out tests/bdd-log.xml

@if %ERRORLEVEL%==2 GOTO good_exit_bdd
@if %ERRORLEVEL%==0 GOTO good_exit_bdd

exit /B 1

:good_exit_bdd
exit /B 0