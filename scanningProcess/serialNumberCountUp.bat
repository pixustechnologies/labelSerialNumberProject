@echo off
FOR /F %%i IN (SerialNumberCount.txt) DO set "sn=%%i"
:: this removes leading zeros
cmd /c exit /b %sn%
:: adds one
set /a "sn=%errorlevel%+ 1"
:: counts length, adds back leading zeros
set /a Log=1%sn:~1%-%sn:~1% -0
set /a Len=%Log:0=+1%
IF %Len% leq 8 (
	SET sn=0%sn%
)
echo %sn% >SerialNumberCount.txt