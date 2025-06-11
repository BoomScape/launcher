[Setup]
AppName=BoomPS Launcher
AppPublisher=BoomPS
UninstallDisplayName=BoomPS
AppVersion=${project.version}
AppSupportURL=https://boom-ps.com/
DefaultDirName={localappdata}\BoomPS

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=arm64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/innosetup/runelite_small.bmp
SetupIconFile=${basedir}/runelite.ico
UninstallDisplayIcon={app}\BoomPS.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=BoomPSAArch64

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\build\win-aarch64\BoomPS.exe"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\BoomPS.jar"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\launcher_aarch64.dll"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\config.json"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

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

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"