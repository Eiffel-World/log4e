@echo off

rem Compile message resources
rem 

@echo Compiling event message code resources...

MC EventLogCategories.mc
RC -r -fo EventLogCategories.res EventLogCategories.rc

link -dll -noentry -out:NTEventLogAppender.dll EventLogCategories.res

del EventLogCategories.res 
del EventLogCategories.rc
del *.bin

@echo .
@echo You must now make sure the NTEventLogAppender.dll is somewhere on your
@echo path otherwise you will receive an "unsatisfied link error".
@echo .
