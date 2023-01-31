@ECHO OFF
REM usage: append_user_path "path"
SET Key="HKCU\Environment"
FOR /F "usebackq tokens=2*" %%A IN (`REG QUERY %Key% /v PATH`) DO Set CurrPath=%%B
ECHO %CurrPath% > user_path_bak.txt
SETX PATH "%CurrPath%";%1