# Defines
!define PRODUCT_LONG_NAME "openEHR Archetype Editor"
!define PRODUCT_SHORT_NAME "ArchetypeEditor"
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 2.2
!define BUILD 0.0
!define COMPANY "openEHR Foundation"
!define URL www.openehr.org

# MUI defines
!define MUI_ICON "openEHR.ico"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of the $(^Name).\r\n\r\nClick Next to continue."
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "openEHR\Archetype Editor"
!define MUI_UNICON "openEHR.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "birds_vertical.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "openEHR.bmp"
!define MUI_FINISHPAGE_RUN "$INSTDIR\ArchetypeEditor.exe"
!define MUI_FINISHPAGE_SHOWREADME "http://www.openehr.org/downloads/archetypeeditor/release_notes"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show Release Notes"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include Sections.nsh
!include MUI.nsh

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "Archetype Editor Licence Agreement.rtf"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
Name "${PRODUCT_LONG_NAME} ${VERSION}"

!ifdef OUTFILE_DIR
    OutFile "${OUTFILE_DIR}\${PRODUCT_SHORT_NAME}Setup_${VERSION}.${BUILD}.exe"
!else
    OutFile "${PRODUCT_SHORT_NAME}Setup_${VERSION}.${BUILD}.exe"
!endif

InstallDir "$PROGRAMFILES\openEHR\Archetype Editor"
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion ${VERSION}.${BUILD}
VIAddVersionKey ProductName "${PRODUCT_LONG_NAME}"
VIAddVersionKey ProductVersion "${VERSION}.${BUILD}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}.${BUILD}"
VIAddVersionKey FileDescription "Archetype Editor Installer"
VIAddVersionKey LegalCopyright "Copyright � 2015 openEHR Foundation"
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show
BrandingText "Archetype Editor Installer"

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File ..\ArchetypeEditor\bin\*.exe.config
    File ..\ArchetypeEditor\bin\*.exe
    File ..\ArchetypeEditor\bin\*.dll
    File ..\ArchetypeEditor\bin\*.xml

    SetOutPath $INSTDIR\Help
    File ..\ArchetypeEditor\bin\Help\ArchetypeEditor.chm

    SetOutPath $INSTDIR\HTML
    File ..\ArchetypeEditor\bin\HTML\adlxml-to-html.xsl

    SetOutPath $INSTDIR\HTML\Images
    File ..\ArchetypeEditor\bin\HTML\Images\*

    SetOutPath $INSTDIR\PropertyUnits
    File ..\ArchetypeEditor\bin\PropertyUnits\*

    SetOutPath $INSTDIR\Terminology
    File ..\ArchetypeEditor\bin\Terminology\*

    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    SetOutPath $INSTDIR
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\uninstall.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Archetype Editor.lnk" $INSTDIR\ArchetypeEditor.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}.${BUILD}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

Section
    DeleteRegKey HKCR ".adl"
    WriteRegStr HKCR ".adl" "" "AdlFile"

    WriteRegStr HKCR "AdlFile" "" "ADL File Type"
    WriteRegStr HKCR "AdlFile\DefaultIcon" "" "$INSTDIR\ArchetypeEditor.exe,0"
    WriteRegStr HKCR "AdlFile\shell" "" "open"
    WriteRegStr HKCR "AdlFile\shell\open\command" "" '$INSTDIR\ArchetypeEditor.exe "%1"'

    System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o un.Main UNSEC0000

    Delete /REBOOTOK $INSTDIR\*
    RMDir /r /REBOOTOK $INSTDIR\Help
    RMDir /r /REBOOTOK $INSTDIR\HTML
    RMDir /r /REBOOTOK $INSTDIR\PropertyUnits
    RMDir /r /REBOOTOK $INSTDIR\Terminology
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section un.post UNSEC0001
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Archetype Editor.lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
FunctionEnd


# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd
