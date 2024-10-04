; https://gist.github.com/mattiasghodsian/a30f50568792939e35e93e6bc2084c2a
; https://qiita.com/yuki_nishina/items/176d6d77911f2b54bd75
; https://nsis.sourceforge.io/EnVar_plug-in
; https://stackoverflow.com/questions/719631/how-do-i-require-user-to-uninstall-previous-version-with-nsis

!define RELEASE_TAG "2.4.0-1"
!define LNK_NAME "WebCFace Desktop ${RELEASE_TAG} (${ARCH})"
!define UNINSTALL_REG "Software\Microsoft\Windows\CurrentVersion\Uninstall\webcface_${ARCH}"
!define INSTALLDIR_REG "Software\webcface_${ARCH}"

!include "MUI2.nsh"
!include "logiclib.nsh"

Name "WebCFace ${RELEASE_TAG} (${ARCH})"
OutFile "webcface_${RELEASE_TAG}_windows_${ARCH}.exe"
InstallDir "${INSTALL_DIR}"
InstallDirRegKey HKLM "${INSTALLDIR_REG}" ""
RequestExecutionLevel admin

!define MUI_ICON "icon-128t.ico"
!define MUI_WELCOMEPAGE_TITLE "WebCFace ${RELEASE_TAG} (${ARCH}) Setup"

; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "webcface\share\doc\webcface\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
;!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Set UI language
!insertmacro MUI_LANGUAGE "English"

Function .onInit
  ${If} ${Silent}
    ReadRegStr $R0 HKLM "${UNINSTALL_REG}" "QuietUninstallString"
  ${Else}
    ReadRegStr $R0 HKLM "${UNINSTALL_REG}" "UninstallString"
  ${EndIf}
  ExecWait "$R0"
FunctionEnd

Section
;  SectionIn RO
  SetOutPath "$INSTDIR"
  File /r "webcface\*"

  CreateShortcut "$SMPROGRAMS\${LNK_NAME}.lnk" "$INSTDIR\webcface-desktop\webcface-desktop.exe"

  WriteRegStr HKLM "${INSTALLDIR_REG}" "" $INSTDIR
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  WriteRegStr HKLM "${UNINSTALL_REG}" "DisplayName" "WebCFace ${RELEASE_TAG} (${ARCH})"
  WriteRegStr HKLM "${UNINSTALL_REG}" "DisplayVersion" "${RELEASE_TAG}"
  WriteRegStr HKLM "${UNINSTALL_REG}" "Publisher" "na-trium-144@users.noreply.github.com"
  WriteRegStr HKLM "${UNINSTALL_REG}" "UninstallString" '"$INSTDIR\Uninstall.exe" _?=$INSTDIR'
  WriteRegStr HKLM "${UNINSTALL_REG}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S _?=$INSTDIR'

  EnVar::SetHKLM
  EnVar::AddValue "Path" "$INSTDIR\bin"

SectionEnd

;Section "Desktop Shortcut"
;  CreateShortCut "$DESKTOP\${LNK_NAME}.lnk" "$INSTDIR\webcface-desktop\webcface-desktop.exe"
;SectionEnd

Section "Uninstall"

  ;Delete Shortcut
  ;Delete "$DESKTOP\${LNK_NAME}.lnk"
  Delete "$SMPROGRAMS\${LNK_NAME}.lnk"

  ;Delete Uninstall
  Delete "$INSTDIR\Uninstall.exe"

  ;Delete Folder
  RMDir /r "$INSTDIR"
  ;${RMDirUP} "$INSTDIR"

  DeleteRegKey /ifempty HKLM "${INSTALLDIR_REG}"
  DeleteRegKey HKLM "${UNINSTALL_REG}"

  EnVar::SetHKLM
  EnVar::DeleteValue "Path" "$INSTDIR"

SectionEnd
