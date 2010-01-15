set PATH=C:\WinDDK\7600.16385.0\bin\x86;%~dp0tools;%~dp0tools\x86;%PATH%
cd %~dp0..\..\gnICE-drivers
signtool.exe sign /v /ac %~dp0\MSCV-VSClass3.cer /sha1 B61F9B648BB7B0A397809567880A4E90168A1678 /t http://timestamp.verisign.com/scripts/timstamp.dll * i386\* amd64\*
pause
