@chcp 65001

"%ProgramFiles(x86)%\OneScript\bin\oscript.exe" -encoding=utf-8 testrunner.os -runall tests xddReportPath tests

@if %ERRORLEVEL%==2 GOTO good_exit
@if %ERRORLEVEL%==0 GOTO good_exit

exit /B 1

:good_exit
exit /B 0