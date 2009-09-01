; Installer for Windows Blackfin Toolchain
; http://blackfin.uclinux.org/

!define PRODUCT_NAME "Blackfin Toolchain"
!ifndef PRODUCT_VERSION
!define PRODUCT_VERSION "SVN"
!endif
!define PRODUCT_PUBLISHER "Analog Devices, Inc."
!define PRODUCT_WEB_SITE "http://blackfin.uclinux.org/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

;SetCompress off
SetCompressor lzma

!include "env-path.nsh"
!include "MUI.nsh"

; http://nsis.sourceforge.net/Docs/Modern%20UI/Readme.html

!define MUI_ABORTWARNING
!define MUI_ICON "favicon.ico"
!define MUI_UNICON "favicon.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "GPL-2.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_LINK "Blackfin Open Source Website"
!define MUI_FINISHPAGE_LINK_LOCATION "http://blackfin.uclinux.org/"
!define MUI_FINISHPAGE_SHOWREADME "README.txt"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

InstallDir "$PROGRAMFILES\Analog Devices\GNU Toolchain\${PRODUCT_VERSION}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
Name "ADI ${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "blackfin-toolchain-win32-${PRODUCT_VERSION}.exe"
ShowInstDetails show
ShowUnInstDetails show

Section -Prerequisites
  ; Install the LibUsb-Win32 package
  SetOutPath "$INSTDIR\Prerequisites"
  IfFileExists "$SYSDIR\libusb0.dll" skip_libusb
  MessageBox MB_YESNO "Your system does not appear to have LibUsb-Win32 installed.$\nYou need to have this installed if you wish to use USB based JTAG tools.$\n$\nDo you wish to install LibUsb-Win32?" \
      /SD IDNO IDNO skip_libusb
  File /oname=libusb-win32-filter-bin.exe Prerequisites\libusb-win32-filter-bin-*.exe
  ExecWait "$INSTDIR\Prerequisites\libusb-win32-filter-bin.exe"
  skip_libusb:

  ; Install additional binaries that may be needed
  SetOutPath "$INSTDIR\extra-bin"
  Push "$INSTDIR\extra-bin"
  Call AddToPath
  File /oname=make.exe Prerequisites\mingw32-make-*.exe

  RMDir /r "$INSTDIR\Prerequisites"
SectionEnd

!macro BlackfinInstall tuple libc
Section "bfin-${tuple}" Sec${libc}
  SetOutPath "$INSTDIR\${tuple}"
  File /r "bfin-${tuple}\*"
  Push "$INSTDIR\${tuple}\bin"
  Call AddToPath
SectionEnd
!macroend
!insertmacro BlackfinInstall "elf" "NEWLIB"
!insertmacro BlackfinInstall "uclinux" "FLAT"
!insertmacro BlackfinInstall "linux-uclibc" "FDPIC"

Section "Drivers" SecDrivers
  SetOutPath "$INSTDIR\gnICE-drivers"
  File gnICE-drivers\*
  ExecWait "$INSTDIR\gnICE-drivers\DPInst.exe"
SectionEnd

!ifndef SKIP_ECLIPSE
Section "Eclipse" SecEclipse
  SetOutPath "$INSTDIR\Eclipse"
  File /r "eclipse\*"
SectionEnd
!endif

Section "Examples" SecExamples
  SetOutPath "$INSTDIR\examples"
  File /r "..\examples\*"
SectionEnd

Section "Shortcuts" SecShortcuts
  CreateDirectory "$SMPROGRAMS\Analog Devices\GNU Toolchain\${PRODUCT_VERSION}"
  CreateShortCut "$SMPROGRAMS\Analog Devices\GNU Toolchain\${PRODUCT_VERSION}\README.lnk" "$INSTDIR\README.txt"
  CreateShortCut "$SMPROGRAMS\Analog Devices\GNU Toolchain\${PRODUCT_VERSION}\Documentation.lnk" "http://docs.blackfin.uclinux.org/" "" "$INSTDIR\uninst.exe"
  IfFileExists "$INSTDIR\Eclipse\Eclipse.exe" 0 +2
  CreateShortCut "$SMPROGRAMS\Analog Devices\GNU Toolchain\${PRODUCT_VERSION}\Eclipse.lnk" "$INSTDIR\Eclipse\Eclipse.exe" "" "$INSTDIR\Eclipse\Eclipse.exe"
  CreateShortCut "$SMPROGRAMS\Analog Devices\GNU Toolchain\${PRODUCT_VERSION}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

LangString DESC_SecNEWLIB ${LANG_ENGLISH} "Blackfin Toolchain for running on bare metal (no operating system)"
LangString DESC_SecFLAT ${LANG_ENGLISH} "Blackfin Toolchain for generating FLAT binaries to run under Linux"
LangString DESC_SecFDPIC ${LANG_ENGLISH} "Blackfin Toolchain for generating shared FDPIC ELF binaries to run under Linux"
LangString DESC_SecEclipse ${LANG_ENGLISH} "Eclipse IDE with Blackfin Plugins"
LangString DESC_SecDrivers ${LANG_ENGLISH} "gnICE/gnICE+ USB Drivers"
LangString DESC_SecExamples ${LANG_ENGLISH} "Some simple example programs"
LangString DESC_SecShortcuts ${LANG_ENGLISH} "Start Menu Shortcuts"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecNEWLIB} $(DESC_SecNEWLIB)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFLAT} $(DESC_SecFLAT)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFDPIC} $(DESC_SecFDPIC)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecEclipse} $(DESC_SecEclipse)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDrivers} $(DESC_SecDrivers)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecExamples} $(DESC_SecExamples)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcuts} $(DESC_SecShortcuts)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section -Misc
  SetOutPath "$INSTDIR"
  File "GPL-2.txt" "README.txt"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\AppMainExe.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  RMDir /r "$INSTDIR"
  RMDir /r "$SMPROGRAMS\Analog Devices\GNU Toolchain\${PRODUCT_VERSION}"
  RMDir "$SMPROGRAMS\Analog Devices\GNU Toolchain"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true

  Push "$INSTDIR\extra-bin"
  Call un.RemoveFromPath
  Push "$INSTDIR\elf\bin"
  Call un.RemoveFromPath
  Push "$INSTDIR\uclinux\bin"
  Call un.RemoveFromPath
  Push "$INSTDIR\linux-uclibc\bin"
  Call un.RemoveFromPath
SectionEnd
