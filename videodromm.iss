; -- Videodromm.iss --

[Setup]
AppName=Videodromm
AppVersion=0.1
RestartIfNeededByRun=False
ShowLanguageDialog=no
LanguageDetectionMethod=none
AppPublisher=Bruce Lane
DefaultDirName={sd}\Videodromm
WizardImageFile=F:\cpp\Videodromm\setup\videodromm-large.bmp
WizardSmallImageFile=F:\cpp\Videodromm\setup\videodromm-small.bmp
RestartApplications=False
CloseApplications=False
VersionInfoVersion=0.1
VersionInfoCompany=Bruce Lane
VersionInfoDescription=Shader mixer with effects
VersionInfoCopyright=Bruce Lane
VersionInfoProductName=Videodromm
VersionInfoProductVersion=0.1
AppCopyright=Bruce Lane
DisableProgramGroupPage=yes
UsePreviousSetupType=False
UsePreviousTasks=False
UsePreviousLanguage=False
FlatComponentsList=False
AlwaysShowComponentsList=False
ShowComponentSizes=False
AppPublisherURL=http://www.videodromm.com/
AppSupportURL=http://www.videodromm.com/
AppContact=http://www.videodromm.com/
LicenseFile=license.txt
UsePreviousAppDir=False
DisableReadyPage=True
DisableDirPage=Yes
AlwaysShowDirOnReadyPage=False
DisableFinishedPage=True

[Types]

[Components]

[Files]
Source: "license.txt"; DestDir: "{app}"; Flags: ignoreversion;
Source: "Spout.dll"; DestDir: "{app}\app"; Flags: ignoreversion;
Source: "SpoutPanel.exe"; DestDir: "{app}\app"; Flags: ignoreversion;
Source: "videodromm.exe"; DestDir: "{app}\app"; Flags: ignoreversion;
Source: "0.jpg"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "0.frag"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "animation.json"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "mixes.xml"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "mixfbo.frag"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "passthru.vert"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "pupilles640x480.hap.mov"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "session.json"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "shadertoy.inc"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "texture0.frag"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "texture1.frag"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "textures.xml"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "warps.json"; DestDir: "{app}\assets"; Flags: ignoreversion;
Source: "readme.txt"; DestDir: "{app}"; Flags: isreadme
; VS2013 runtime
Source: "vcredist_x64.exe"; DestDir: {tmp}; Flags: deleteafterinstall
Source: "vcredist_x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall

[Dirs]
Name: "{app}\assets";
Name: "{app}\app";

[Icons]
Name: "{group}\Videodromm"; Filename: "{app}\app\videodromm.exe"

[Run]
Check: VC64install; Filename: "{tmp}\vcredist_x64.exe"; Parameters: "/q /norestart"; StatusMsg: "Installing 64 bit VS2013 redistributable. Please wait ....";
Check: VC32install; Filename: "{tmp}\vcredist_x86.exe"; Parameters: "/q /norestart"; StatusMsg: "Installing 32 bit VS2013 redistributable. Please wait ....";
Check: not VC32restart; Filename: "explorer.exe"; Parameters: "{app}"; WorkingDir: "{app}"


[Code]

var
    doVC32install: Boolean;

function VC64install: Boolean;

var
    version: cardinal;
    msgstring: string;

begin
    RegQueryDWordValue(HKLM, 'SOFTWARE\Wow6432Node\Microsoft\VisualStudio\12.0\VC\Runtimes\x64', 'Installed', version);
    if (version = 1) then
        begin
            // MsgBox('64bit found', mbInformation, MB_OK);
            Result := False;
        end
    else
        begin
            // MsgBox('64bit not found', mbInformation, MB_OK);
            msgstring := 'VS2013 runtime is not installed.' + #13#10 + 'Install it now ?'
            if MsgBox(msgstring, mbConfirmation, MB_YESNO) = IDYES then
                // user clicked Yes
                begin
                    // MsgBox('Clicked Yes', mbInformation, MB_OK);
                    doVC32install := True;
                    // RestartIfNeededByRun : = True;
                    Result := True;
                end
            else
                // user clicked No
                begin
                    // MsgBox('Clicked NO', mbInformation, MB_OK);
                    doVC32install := False;
                    Result := False;
                end
        end
end;


function VC32install: Boolean;

begin
    Result := doVC32install;
end;


function VC32restart: Boolean;

var
    msgstring: string;
    intResultCode: Integer;

begin
    if(doVC32install = True) Then
        begin
          msgstring := 'VS2013 runtime installed.' + #13#10 + 'Restart is required.' + #13#10 + 'Restart now ?'
          if MsgBox(msgstring, mbConfirmation, MB_YESNO) = IDYES then
              begin
                Exec('shutdown.exe', '-r -t 0', '', SW_HIDE, ewNoWait, intResultCode);
                Result := True;
              end
          else
            begin
              Result := False;
            end
        end
    else
        begin
            Result := False;
        end

end;