; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply 
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there. 

;--------------------------------

; The name of the installer
Name "SimpleSwitcher"

; The file to write
OutFile "SimpleSwitcher.exe"

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"

; The default installation directory
InstallDir $PROGRAMFILES\SimpleSwitcher

; Request admin privileges for Windows Vista
RequestExecutionLevel Admin

;--------------------------------

; для показа в списке установленных программ
!define Uninstall_key "Software\Microsoft\Windows\CurrentVersion\Uninstall\SimpleSwitcher"
; версия программы
!define Version "2.0.7.2"
; Автор
!define Author "Aleksandr Shipaev"
; Папка в меню программ
!define The_program "$SMPROGRAMS\SimpleSwitcher"
; Имя файла установленной программы
!define Exe_file "$INSTDIR\SimpleSwitcher.exe"

;--------------------------------
;Version Information

 VIProductVersion ${Version}
 VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "SimpleSwitcher"
 VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "https://vk.com/simpleswitcher https://github.com/alexzh2/SimpleSwitcher/releases"
 VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "alexzh2"
 VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "SimpleSwitcher is a trademark of ${Author}"
 VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "GPL v3"
 VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Program for quickly switching the layout of text. Author https://vk.com/alshipaev"
 VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" ${Version}

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "SimpleSwitcher (required)" ;No components page, name is not important

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File SimpleSwitcher\SimpleSwitcher.exe
  File SimpleSwitcher\license.txt
  File SimpleSwitcher\config.lua

  ; копировать файлы конфигурации, если есть
  CopyFiles /SILENT $EXEDIR\settings.ini $INSTDIR
  CopyFiles /SILENT $EXEDIR\config.lua $INSTDIR

  ; Write the uninstall keys for Windows
  ; http://nsis.sourceforge.net/Add_uninstall_information_to_Add/Remove_Programs
  ; https://msdn.microsoft.com/en-us/library/windows/desktop/aa372105(v=vs.85).aspx
  WriteRegStr HKLM ${Uninstall_key} "DisplayName" "SimpleSwitcher"
  WriteRegStr HKLM ${Uninstall_key} "DisplayVersion" ${Version}
  WriteRegStr HKLM ${Uninstall_key} "DisplayIcon" "${Exe_file}"
  WriteRegStr HKLM ${Uninstall_key} "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKLM ${Uninstall_key} "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
  WriteRegDWORD HKLM ${Uninstall_key} "NoModify" 1
  WriteRegDWORD HKLM ${Uninstall_key} "NoRepair" 1
  WriteRegStr HKLM ${Uninstall_key} "Publisher" "${Author}"
  WriteRegStr HKLM ${Uninstall_key} "HelpLink" "https://vk.com/simpleswitcher"
  WriteRegDWORD HKLM ${Uninstall_key} "EstimatedSize" 640
  WriteUninstaller "uninstall.exe"

  
SectionEnd ; end the section



;--------------------------------
; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  ; В меню для всех пользователей
  SetShellVarContext all

  CreateDirectory "${The_program}"
  CreateShortcut "${The_program}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortcut "${The_program}\SimpleSwitcher.lnk" "${Exe_file}" "" "${Exe_file}" 0
  
SectionEnd

;--------------------------------

; Optional section (can be disabled by the user)
Section "AutoRun (for all users)"

  ; Автозагрузка для всех пользователей
  SetShellVarContext all

  CreateShortcut "$SMSTARTUP\SimpleSwitcher.lnk" "${Exe_file}" "" "${Exe_file}" 0
  
SectionEnd

;--------------------------------


; Uninstaller

Section "Uninstall"
  
  ; Автозагрузка для всех пользователей
  SetShellVarContext all

  ; Remove registry keys
  ; удалить из списка установленных программ
  DeleteRegKey HKLM ${Uninstall_key}
  ; Удалить ремаппинг клавиш
  DeleteRegKey HKLM "SYSTEM\CurrentControlSet\Control\Keyboard Layout\Scancode Map"

  ; Remove files and uninstaller
  Delete "$INSTDIR\*.*"


  ; Remove shortcuts, if any
  Delete "${The_program}\*.*"
  Delete "$SMSTARTUP\SimpleSwitcher.lnk"

  ; Remove directories used
  RMDir "${The_program}"
  RMDir "$INSTDIR"

SectionEnd
