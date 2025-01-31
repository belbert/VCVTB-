# This file is configured at cmake time, and loaded at cpack time.
# To pass variables to cpack from cmake, they must be configured
# in this file.

if(CPACK_GENERATOR MATCHES "NSIS")
  set(CPACK_PACKAGING_INSTALL_PREFIX "EnergyPlusV8-8-0")
  set(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGING_INSTALL_PREFIX}")
  set(CPACK_NSIS_INSTALL_ROOT "C:")
  set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGING_INSTALL_PREFIX}")
  set(CPACK_NSIS_DEFINES "  
    !define MUI_STARTMENUPAGE_DEFAULTFOLDER \"${CPACK_PACKAGING_INSTALL_PREFIX} Programs\"
    !include \"LogicLib.nsh\"
    !include \"x64.nsh\"
  ")
  set(CPACK_PACKAGING_INSTALL_PREFIX "")

  set(CPACK_NSIS_MENU_LINKS
    "Documentation/index.html" "EnergyPlus Documentation"
    "PostProcess/EP-Compare/EP-Compare.exe" "EP-Compare" 
    "PreProcess/EPDraw/EPDrawGUI.exe" "EPDrawGUI" 
    "EP-Launch.exe" "EP-Launch"
    "ExampleFiles/ExampleFiles.xls" "Example Files Summary Spreadsheet"
    "ExampleFiles/ExampleFiles-ObjectsLink.xls" "ExampleFiles Link to Objects" 
    "PreProcess/IDFEditor/IDFEditor.exe" "IDFEditor"
    "PreProcess/IDFVersionUpdater/IDFVersionUpdater.exe" "IDFVersionUpdater"
    "readme.html" "Readme Notes" 
    "PreProcess/WeatherConverter/Weather.exe" "Weather Statistics and Conversions" 
  )

  set(CPACK_NSIS_PAGE_COMPONENTS "
    !define MUI_FINISHPAGE_RUN
    !define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
    !define MUI_FINISHPAGE_SHOWREADME \"$INSTDIR\\readme.html\"
    !define MUI_FINISHPAGE_RUN_NOTCHECKED
    !define MUI_FINISHPAGE_RUN_TEXT \"Associate *.idf, *.imf, and *.epg files with EP-Launch\"
    !define MUI_FINISHPAGE_RUN_FUNCTION \"AssociateFiles\"

    Function AssociateFiles
      WriteRegStr HKCR \".idf\" \"\" \"EP-Launch.idf\"
      WriteRegStr HKCR \"EP-Launch.idf\" \"\" `EnergyPlus Input Data File`
      WriteRegStr HKCR \"EP-Launch.idf\\shell\" \"\" \"open\"
      WriteRegStr HKCR \"EP-Launch.idf\\shell\\open\" \"\" `Open with EP-Launch`
      WriteRegStr HKCR \"EP-Launch.idf\\shell\\open\\command\" \"\" `$INSTDIR\\EP-Launch.exe %1`
      WriteRegStr HKCR \".imf\" \"\" \"EP-Launch.imf\"
      WriteRegStr HKCR \"EP-Launch.imf\" \"\" `EnergyPlus Input Macro File`
      WriteRegStr HKCR \"EP-Launch.imf\\shell\" \"\" \"open\"
      WriteRegStr HKCR \"EP-Launch.imf\\shell\\open\" \"\" `Open with EP-Launch`
      WriteRegStr HKCR \"EP-Launch.imf\\shell\\open\\command\" \"\" `$INSTDIR\\EP-Launch.exe %1`
      WriteRegStr HKCR \".epg\" \"\" \"EP-Launch.epg\"
      WriteRegStr HKCR \"EP-Launch.epg\" \"\" `EnergyPlus Group File`
      WriteRegStr HKCR \"EP-Launch.epg\\shell\" \"\" \"open\"
      WriteRegStr HKCR \"EP-Launch.epg\\shell\\open\" \"\" `Open with EP-Launch`
      WriteRegStr HKCR \"EP-Launch.epg\\shell\\open\\command\" \"\" `$INSTDIR\\EP-Launch.exe %1`
      WriteRegStr HKCR \".ddy\" \"\" \"IDFEditor.ddy\"
      WriteRegStr HKCR \"IDFEditor.ddy\" \"\" `Location and Design Day Data`
      WriteRegStr HKCR \"IDFEditor.ddy\\shell\" \"\" \"open\"
      WriteRegStr HKCR \"IDFEditor.ddy\\shell\\open\" \"\" `Open with IDFEditor`
      WriteRegStr HKCR \"IDFEditor.ddy\\shell\\open\\command\" \"\" `$INSTDIR\\PreProcess\\IDFEditor\\IDFEditor.exe %1`
      WriteRegStr HKCR \".expidf\" \"\" \"IDFEditor.expidf\"
      WriteRegStr HKCR \"IDFEditor.expidf\" \"\" `EnergyPlus Expand Objects Input Data File`
      WriteRegStr HKCR \"IDFEditor.expidf\\shell\" \"\" \"open\"
      WriteRegStr HKCR \"IDFEditor.expidf\\shell\\open\" \"\" `Open with IDFEditor`
      WriteRegStr HKCR \"IDFEditor.expidf\\shell\\open\\command\" \"\" `$INSTDIR\\PreProcess\\IDFEditor\\IDFEditor.exe %1`
    FunctionEnd
  ")

  set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
    WriteRegStr HKEY_CURRENT_USER \"Software\\VB and VBA Program Settings\\EP-Launch\\UpdateCheck\" \"AutoCheck\" \"True\"
    WriteRegStr HKEY_CURRENT_USER \"Software\\VB and VBA Program Settings\\EP-Launch\\UpdateCheck\" \"CheckURL\" \"http://nrel.github.io/EnergyPlus/epupdate.htm\"
    StrCpy $0 \"#8.7.0-Unknown\"
    WriteRegStr HKEY_CURRENT_USER \"Software\\VB and VBA Program Settings\\EP-Launch\\UpdateCheck\" \"LastAnchor\" $0
    \${If} \${RunningX64}
      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\MSCOMCTL.OCX\"
        CopyFiles \"$INSTDIR\\temp\\MSCOMCTL.OCX\" \"$WINDIR\\SysWOW64\\MSCOMCTL.OCX\"
        RegDLL \"$WINDIR\\SysWOW64\\MSCOMCTL.OCX\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\ComDlg32.OCX\"
        CopyFiles \"$INSTDIR\\temp\\ComDlg32.OCX\" \"$WINDIR\\SysWOW64\\ComDlg32.OCX\"
        RegDLL \"$WINDIR\\SysWOW64\\ComDlg32.OCX\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\Msvcrtd.dll\"
      	CopyFiles \"$INSTDIR\\temp\\Msvcrtd.dll\" \"$WINDIR\\SysWOW64\\Msvcrtd.dll\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\Dforrt.dll\"
      	CopyFiles \"$INSTDIR\\temp\\Dforrt.dll\" \"$WINDIR\\SysWOW64\\Dforrt.dll\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\Gswdll32.dll\"
      	CopyFiles \"$INSTDIR\\temp\\Gswdll32.dll\" \"$WINDIR\\SysWOW64\\Gswdll32.dll\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\Gsw32.exe\"
      	CopyFiles \"$INSTDIR\\temp\\Gsw32.exe\" \"$WINDIR\\SysWOW64\\Gsw32.exe\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\Graph32.ocx\"
      	CopyFiles \"$INSTDIR\\temp\\Graph32.ocx\" \"$WINDIR\\SysWOW64\\Graph32.ocx\"
      	RegDLL \"$WINDIR\\SysWOW64\\Graph32.ocx\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\MSINET.OCX\"
      	CopyFiles \"$INSTDIR\\temp\\MSINET.OCX\" \"$WINDIR\\SysWOW64\\MSINET.OCX\"
      	RegDLL \"$WINDIR\\SysWOW64\\MSINET.OCX\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\Vsflex7L.ocx\"
      	CopyFiles \"$INSTDIR\\temp\\Vsflex7L.ocx\" \"$WINDIR\\SysWOW64\\Vsflex7L.ocx\"
      	RegDLL \"$WINDIR\\SysWOW64\\Vsflex7L.ocx\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\SysWOW64\\Msflxgrd.ocx\"
      	CopyFiles \"$INSTDIR\\temp\\Msflxgrd.ocx\" \"$WINDIR\\SysWOW64\\Msflxgrd.ocx\"
      	RegDLL \"$WINDIR\\SysWOW64\\Msflxgrd.ocx\"
      \${EndIf}
    \${Else}
      \${IfNot} \${FileExists} \"$WINDIR\\System32\\MSCOMCTL.OCX\"
        CopyFiles \"$INSTDIR\\temp\\MSCOMCTL.OCX\" \"$WINDIR\\System32\\MSCOMCTL.OCX\"
        RegDLL \"$WINDIR\\System32\\MSCOMCTL.OCX\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\ComDlg32.OCX\"
        CopyFiles \"$INSTDIR\\temp\\ComDlg32.OCX\" \"$WINDIR\\System32\\ComDlg32.OCX\"
        RegDLL \"$WINDIR\\System32\\ComDlg32.OCX\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\Msvcrtd.dll\"
      	CopyFiles \"$INSTDIR\\temp\\Msvcrtd.dll\" \"$WINDIR\\System32\\Msvcrtd.dll\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\Dforrt.dll\"
      	CopyFiles \"$INSTDIR\\temp\\Dforrt.dll\" \"$WINDIR\\System32\\Dforrt.dll\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\Gswdll32.dll\"
      	CopyFiles \"$INSTDIR\\temp\\Gswdll32.dll\" \"$WINDIR\\System32\\Gswdll32.dll\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\Gsw32.exe\"
      	CopyFiles \"$INSTDIR\\temp\\Gsw32.exe\" \"$WINDIR\\System32\\Gsw32.exe\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\Graph32.ocx\"
      	CopyFiles \"$INSTDIR\\temp\\Graph32.ocx\" \"$WINDIR\\System32\\Graph32.ocx\"
      	RegDLL \"$WINDIR\\System32\\Graph32.ocx\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\MSINET.OCX\"
      	CopyFiles \"$INSTDIR\\temp\\MSINET.OCX\" \"$WINDIR\\System32\\MSINET.OCX\"
      	RegDLL \"$WINDIR\\System32\\MSINET.OCX\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\Vsflex7L.ocx\"
      	CopyFiles \"$INSTDIR\\temp\\Vsflex7L.ocx\" \"$WINDIR\\System32\\Vsflex7L.ocx\"
      	RegDLL \"$WINDIR\\System32\\Vsflex7L.ocx\"
      \${EndIf}

      \${IfNot} \${FileExists} \"$WINDIR\\System32\\Msflxgrd.ocx\"
      	CopyFiles \"$INSTDIR\\temp\\Msflxgrd.ocx\" \"$WINDIR\\System32\\Msflxgrd.ocx\"
      	RegDLL \"$WINDIR\\System32\\Msflxgrd.ocx\"
      \${EndIf}
    \${EndIf}
    RMDir /r $INSTDIR\\temp
  ")
  set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
    MessageBox MB_YESNO|MB_ICONEXCLAMATION \"The installer copied the following files to the system directory during installation:$\\r$\\n$\\r$\\nMSCOMCTL.OCX$\\r$\\nComDlg32.OCX$\\r$\\nMsvcrtd.dll$\\r$\\nDforrt.dll$\\r$\\nGswdll32.dll$\\r$\\nGsw32.exe$\\r$\\nGraph32.ocx$\\r$\\nMSINET.OCX$\\r$\\nVsflex7L.ocx$\\r$\\nMsflxgrd.ocx$\\r$\\n$\\r$\\nThese files may be in use by other programs. Click Yes to remove these files. If you are unsure, click No.\" IDYES true IDNO false
    true:
      \${If} \${RunningX64}
        UnRegDLL \"$WINDIR\\SysWOW64\\MSCOMCTL.OCX\"
        UnRegDLL \"$WINDIR\\SysWOW64\\ComDlg32.OCX\"
        UnRegDLL \"$WINDIR\\SysWOW64\\Graph32.ocx\"
        UnRegDLL \"$WINDIR\\SysWOW64\\MSINET.OCX\"
        UnRegDLL \"$WINDIR\\SysWOW64\\Vsflex7L.ocx\"
        UnRegDLL \"$WINDIR\\SysWOW64\\Msflxgrd.ocx\"
        Delete \"$WINDIR\\SysWOW64\\MSCOMCTL.OCX\"
        Delete \"$WINDIR\\SysWOW64\\ComDlg32.OCX\"
        Delete \"$WINDIR\\SysWOW64\\Msvcrtd.dll\"
        Delete \"$WINDIR\\SysWOW64\\Dforrt.dll\"
        Delete \"$WINDIR\\SysWOW64\\Gswdll32.dll\"
        Delete \"$WINDIR\\SysWOW64\\Gsw32.exe\"
        Delete \"$WINDIR\\SysWOW64\\Graph32.ocx\"
        Delete \"$WINDIR\\SysWOW64\\MSINET.OCX\"
        Delete \"$WINDIR\\SysWOW64\\Vsflex7L.ocx\"
        Delete \"$WINDIR\\SysWOW64\\Msflxgrd.ocx\"
      \${Else}
        UnRegDLL \"$WINDIR\\System32\\MSCOMCTL.OCX\"
        UnRegDLL \"$WINDIR\\System32\\ComDlg32.OCX\"
        UnRegDLL \"$WINDIR\\System32\\Graph32.ocx\"
        UnRegDLL \"$WINDIR\\System32\\MSINET.OCX\"
        UnRegDLL \"$WINDIR\\System32\\Vsflex7L.ocx\"
        UnRegDLL \"$WINDIR\\System32\\Msflxgrd.ocx\"
        Delete \"$WINDIR\\System32\\MSCOMCTL.OCX\"
        Delete \"$WINDIR\\System32\\ComDlg32.OCX\"
        Delete \"$WINDIR\\System32\\Msvcrtd.dll\"
        Delete \"$WINDIR\\System32\\Dforrt.dll\"
        Delete \"$WINDIR\\System32\\Gswdll32.dll\"
        Delete \"$WINDIR\\System32\\Gsw32.exe\"
        Delete \"$WINDIR\\System32\\Graph32.ocx\"
        Delete \"$WINDIR\\System32\\MSINET.OCX\"
        Delete \"$WINDIR\\System32\\Vsflex7L.ocx\"
        Delete \"$WINDIR\\System32\\Msflxgrd.ocx\"
      \${EndIf}
      Goto next
    false:
      MessageBox MB_OK \"Files will not be removed.\"
    next:
  ")
endif()

if("${CPACK_GENERATOR}" STREQUAL "PackageMaker")
  set(CPACK_PACKAGE_RELOCATABLE false)
  set( CPACK_PACKAGE_VENDOR "usdoe" )
  configure_file(/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/cmake/CPack.Info.plist.in.in "/home/data/generic/EnergyPlus/COMPILED/BUILD170718/Modules/CPack.Info.plist.in")
  set(CPACK_RESOURCE_FILE_README "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/release/readme.html")
endif()

