[Setup]
AppName=BoomScapeTestServer Launcher
AppPublisher=BoomScapeTestServer
UninstallDisplayName=BoomScapeTestServer
AppVersion=${project.version}
AppSupportURL=https://boom-scape.com/
DefaultDirName={localappdata}\BoomScapeTestServer

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/innosetup/runelite_small.bmp
SetupIconFile=${basedir}/runelite.ico
UninstallDisplayIcon={app}\BoomScapeTestServer.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=BoomScapeTestServerSetup32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\build\win-x86\BoomScapeTestServer.exe"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\BoomScapeTestServer.jar"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\launcher_x86.dll"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\config.json"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\BoomScapeTestServer\BoomScapeTestServer"; Filename: "{app}\BoomScapeTestServer.exe"
Name: "{userprograms}\BoomScapeTestServer\BoomScapeTestServer (configure)"; Filename: "{app}\BoomScapeTestServer.exe"; Parameters: "--configure"
Name: "{userprograms}\BoomScapeTestServer\BoomScapeTestServer (safe mode)"; Filename: "{app}\BoomScapeTestServer.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\BoomScapeTestServer"; Filename: "{app}\BoomScapeTestServer.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\BoomScapeTestServer.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\BoomScapeTestServer.exe"; Description: "&Open BoomScapeTestServer"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\BoomScapeTestServer.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.runelite\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"