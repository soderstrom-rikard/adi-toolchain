; Installer for Blackfin Toolchain
; http://blackfin.uclinux.org/

!define PRODUCT_NAME "Blackfin Toolchain"
!define PRODUCT_VERSION "2007R1"
!define PRODUCT_PUBLISHER "Analog Devices, Inc."
!define PRODUCT_WEB_SITE "http://blackfin.uclinux.org/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma
SetCompress off

!include "env-path.nsh"
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "favicon.ico"
!define MUI_UNICON "favicon.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "GPL-2.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

InstallDir "$PROGRAMFILES\${PRODUCT_NAME}\${PRODUCT_VERSION}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "blackfin-toolchain-win32-${PRODUCT_VERSION}.exe"
ShowInstDetails show
ShowUnInstDetails show

!macro BlackfinInstall tuple libc
Section "bfin-${tuple}" Sec${libc}
  SetOutPath "$INSTDIR\${tuple}"
  File /r "out-${tuple}\*"
  Push "$INSTDIR\${tuple}\bin"
  Call AddToPath
SectionEnd
!macroend

!insertmacro BlackfinInstall "elf" "NEWLIB"
!insertmacro BlackfinInstall "uclinux" "FLAT"
!insertmacro BlackfinInstall "linux-uclibc" "FDPIC"

LangString DESC_SecNEWLIB ${LANG_ENGLISH} "Blackfin Toolchain for running on bare metal (no operating system)"
LangString DESC_SecFLAT ${LANG_ENGLISH} "Blackfin Toolchain for generating FLAT binaries to run under Linux"
LangString DESC_SecFDPIC ${LANG_ENGLISH} "Blackfin Toolchain for generating shared FDPIC ELF binaries to run under Linux"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecNEWLIB} $(DESC_SecNEWLIB)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFLAT} $(DESC_SecFLAT)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFDPIC} $(DESC_SecFDPIC)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

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

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true

  Push "$INSTDIR\elf\bin"
  Call un.RemoveFromPath
  Push "$INSTDIR\uclinux\bin"
  Call un.RemoveFromPath
  Push "$INSTDIR\linux-uclibc\bin"
  Call un.RemoveFromPath
SectionEnd
