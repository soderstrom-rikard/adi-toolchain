; Installer for Windows Blackfin Toolchain
; http://blackfin.uclinux.org/

!define PRODUCT_NAME "Blackfin Toolchain"
!ifndef PRODUCT_VERSION
!define PRODUCT_VERSION "SVN"
!endif
!ifndef VIProductVersion
!define VIProductVersion "0.0.0.0"
!endif
!define PRODUCT_PUBLISHER "Analog Devices, Inc."
!define PRODUCT_WEB_SITE "http://blackfin.uclinux.org/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME} ${PRODUCT_VERSION}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

;SetCompress off
SetCompressor lzma

!define DEFAULT_PATH "Analog Devices\GNU Toolchain\${PRODUCT_VERSION}"
InstallDir "$PROGRAMFILES\${DEFAULT_PATH}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
BrandingText "${PRODUCT_PUBLISHER}"
Name "ADI ${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "blackfin-toolchain-win32-${PRODUCT_VERSION}.exe"
ShowInstDetails show
ShowUnInstDetails show

VIAddVersionKey ProductName "${PRODUCT_NAME}"
VIAddVersionKey CompanyName "${PRODUCT_PUBLISHER}"
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey FileVersion "${PRODUCT_VERSION}"
VIAddVersionKey FileDescription "Open Source Toolchain for Blackfin Processors"
VIAddVersionKey LegalCopyright "© 2007-2009 ${PRODUCT_PUBLISHER}"
VIProductVersion "${VIProductVersion}"

!include "env-path.nsh"
!include "MUI2.nsh"

; http://nsis.sourceforge.net/Docs/Modern%20UI/Readme.html

!define MUI_ABORTWARNING
!define MUI_ICON "favicon.ico"
!define MUI_UNICON "favicon.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "GPL-2.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY

Var StartMenuFolder
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${DEFAULT_PATH}"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu"
!insertmacro MUI_PAGE_STARTMENU StartMenu $StartMenuFolder

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_LINK "Blackfin Open Source Website"
!define MUI_FINISHPAGE_LINK_LOCATION "${PRODUCT_WEB_SITE}"
!define MUI_FINISHPAGE_SHOWREADME "README.txt"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section -Prerequisites
  ; Install additional binaries that may be needed
  SetOutPath "$INSTDIR\extra-bin"
  File /oname=make.exe Prerequisites\mingw32-make-*.exe
  !insertmacro EnvAddToPath "$INSTDIR\extra-bin"

  RMDir /r "$INSTDIR\Prerequisites"
SectionEnd

!macro BlackfinInstall tuple libc
Section "bfin-${tuple}" Sec${libc}
  SetOutPath "$INSTDIR\${tuple}"
  File /r "bfin-${tuple}\*"
  !insertmacro EnvAddToPath "$INSTDIR\${tuple}\bin"
SectionEnd
!macroend
!insertmacro BlackfinInstall "elf" "NEWLIB"
!insertmacro BlackfinInstall "uclinux" "FLAT"
!insertmacro BlackfinInstall "linux-uclibc" "FDPIC"

Section "Drivers" SecDrivers
  SetOutPath "$INSTDIR\gnICE-drivers"
  File /r "gnICE-drivers\*"
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

LangString DESC_SecNEWLIB ${LANG_ENGLISH} "Blackfin Toolchain for running on bare metal (no operating system)"
LangString DESC_SecFLAT ${LANG_ENGLISH} "Blackfin Toolchain for generating FLAT binaries to run under Linux"
LangString DESC_SecFDPIC ${LANG_ENGLISH} "Blackfin Toolchain for generating shared FDPIC ELF binaries to run under Linux"
LangString DESC_SecEclipse ${LANG_ENGLISH} "Eclipse IDE with Blackfin Plugins"
LangString DESC_SecDrivers ${LANG_ENGLISH} "gnICE/gnICE+ USB Drivers"
LangString DESC_SecExamples ${LANG_ENGLISH} "Some simple example programs"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecNEWLIB} $(DESC_SecNEWLIB)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFLAT} $(DESC_SecFLAT)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFDPIC} $(DESC_SecFDPIC)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecEclipse} $(DESC_SecEclipse)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDrivers} $(DESC_SecDrivers)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecExamples} $(DESC_SecExamples)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section -Post
  SetOutPath "$INSTDIR"
  File "GPL-2.txt" "README.txt"

  !insertmacro MUI_STARTMENU_WRITE_BEGIN StartMenu
  CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
  CreateShortCut "$SMPROGRAMS\$StartMenuFolder\README.lnk" "$INSTDIR\README.txt"
  CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Documentation.lnk" "http://docs.blackfin.uclinux.org/" "" "$INSTDIR\uninst.exe"
  IfFileExists "$INSTDIR\Eclipse\Eclipse.exe" 0 +2
  CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Eclipse.lnk" "$INSTDIR\Eclipse\Eclipse.exe" "" "$INSTDIR\Eclipse\Eclipse.exe"
  CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_END

  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\AppMainExe.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  RMDir /r "$INSTDIR"

  !insertmacro MUI_STARTMENU_GETFOLDER StartMenu $StartMenuFolder
  RMDir /r "$SMPROGRAMS\$StartMenuFolder"
  RMDir "$SMPROGRAMS\Analog Devices\GNU Toolchain"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  !insertmacro un.EnvRemoveFromPath "$INSTDIR\extra-bin"
  !insertmacro un.EnvRemoveFromPath "$INSTDIR\elf\bin"
  !insertmacro un.EnvRemoveFromPath "$INSTDIR\uclinux\bin"
  !insertmacro un.EnvRemoveFromPath "$INSTDIR\linux-uclibc\bin"
SectionEnd
