[Setup]
AppName=BoomPS Launcher
AppPublisher=BoomPS
UninstallDisplayName=BoomPS
AppVersion=${project.version}
AppSupportURL=https://boom-ps.com/
DefaultDirName={localappdata}\BoomPS

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${project.projectDir}/innosetup/runelite_small.bmp
SetupIconFile=${project.projectDir}/innosetup/runelite.ico
UninstallDisplayIcon={app}\BoomPS.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${project.projectDir}
OutputBaseFilename=BoomPS32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${project.projectDir}\build\win-x86\BoomPS.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x86\BoomPS.jar"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x86\launcher_x86.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x86\config.json"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x86\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\BoomPS\BoomPS"; Filename: "{app}\BoomPS.exe"
Name: "{userprograms}\BoomPS\BoomPS (configure)"; Filename: "{app}\BoomPS.exe"; Parameters: "--configure"
Name: "{userprograms}\BoomPS\BoomPS (safe mode)"; Filename: "{app}\BoomPS.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\BoomPS"; Filename: "{app}\BoomPS.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\BoomPS.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\BoomPS.exe"; Description: "&Open BoomPS"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\BoomPS.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.runelite\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Registry]
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: ""; ValueData: "URL:runelite-jav Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\BoomPS.exe"" ""%1"""; Flags: uninsdeletekey

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"