@echo on
@chcp 65001

set OSCRIPT=%ProgramFiles(x86)%\OneScript

dir .\tests\

@echo .
@echo =======================  =======================  =======================  =======================  
@echo .
@echo .

call 1testrunner -runall tests xddReportPath tests

set TESTLEVEL=%ERRORLEVEL%

@echo .
@echo =======================  =======================  =======================  =======================  
@echo .
@echo .

oscript -encoding=utf-8 src\bdd.os features -junit-out tests/bdd-log.xml

@if %ERRORLEVEL%==2 GOTO good_exit_bdd
@if %ERRORLEVEL%==0 GOTO good_exit_bdd

dir .\tests\

exit /B 1

:good_exit_bdd

dir .\tests\

exit /B %TESTLEVEL%
