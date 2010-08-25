set PATH=C:\WinDDK\7600.16385.0\bin\x86;%~dp0tools;%~dp0tools\x86;%PATH%
cd %~dp0..\..\gnICE-drivers
signtool.exe sign /v /ac %~dp0\MSCV-VSClass3.cer /sha1 BBEAD3B9B7BEC23098B752324E418884029FBDD9 /t http://timestamp.verisign.com/scripts/timstamp.dll * i386\* amd64\*
pause
