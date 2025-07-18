[Setup]
AppName=BoomPSTestServer Launcher
AppPublisher=BoomPSTestServer
UninstallDisplayName=BoomPSTestServer
AppVersion=${project.version}
AppSupportURL=https://boom-ps.com/
DefaultDirName={localappdata}\BoomPSTestServer

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x64
PrivilegesRequired=lowest

WizardSmallImageFile=${project.projectDir}/innosetup/runelite_small.bmp
SetupIconFile=${project.projectDir}/innosetup/runelite.ico
UninstallDisplayIcon={app}\BoomPSTestServer.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${project.projectDir}
OutputBaseFilename=BoomPSTestServer

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${project.projectDir}\build\win-x64\BoomPSTestServer.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x64\BoomPSTestServer.jar"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x64\launcher_amd64.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x64\config.json"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\BoomPSTestServer\BoomPSTestServer"; Filename: "{app}\BoomPSTestServer.exe"
Name: "{userprograms}\BoomPSTestServer\BoomPSTestServer (configure)"; Filename: "{app}\BoomPSTestServer.exe"; Parameters: "--configure"
Name: "{userprograms}\BoomPSTestServer\BoomPSTestServer (safe mode)"; Filename: "{app}\BoomPSTestServer.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\BoomPSTestServer"; Filename: "{app}\BoomPSTestServer.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\BoomPSTestServer.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\BoomPSTestServer.exe"; Description: "&Open BoomPSTestServer"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\BoomPSTestServer.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.runelite\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Registry]
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: ""; ValueData: "URL:runelite-jav Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\BoomPSTestServer.exe"" ""%1"""; Flags: uninsdeletekey

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"