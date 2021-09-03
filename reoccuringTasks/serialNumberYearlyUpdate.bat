@echo off
FOR /F %%i IN (SerialNumberCount.txt) DO set "sn=%%i"
:: this removes leading zeros
cmd /c exit /b %sn%
:: counts up the year
set /a "sn=%errorlevel%+ 1000000"
:: resets the count
set /a sn=%sn% / 1000000
set sn=%sn%010101
:: counts length, adds back leading zeros
set /a Log=1%sn:~1%-%sn:~1% -0
set /a Len=%Log:0=+1%
IF %Len% leq 8 (
	SET sn=0%sn%
)
echo %sn% >SerialNumberCount.txt