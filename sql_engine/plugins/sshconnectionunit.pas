{ Free DB Manager

  Copyright (C) 2005-2019 Lagunov Aleksey  alexs75 at yandex.ru

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}
unit SSHConnectionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, UTF8Process;

const
  {$IFDEF LINUX}
  cmdSSHPasswd  = '/usr/bin/sshpass';
  cmdSSH  = '/usr/bin/ssh';
  {$ELSE}
  cmdSSH  = '';
  cmdSSHPasswd  = '';
  {$ENDIF}
type

  { TSSHConnectionPlugin }

  TSSHConnectionPlugin = class(TSQLEngineConnectionPlugin)
  private
    FHost: string;
    FIdentifyFile: string;
    FPassword: string;
    FPort: integer;
    FUserName: string;
    procedure InternalBuildCommand;
  protected
    FSSHModule:TProcessUTF8;
    function GetConnected: boolean; override;
    procedure SetConnected(AValue: boolean); override;
    procedure InternalLoad; override;
    procedure InternalSave; override;
  public
    constructor Create(AOwner:TSQLEngineAbstract); override;
    destructor Destroy; override;
    property Host:string read FHost write FHost;
    property Port:integer read FPort write FPort;
    property UserName:string read FUserName write FUserName;
    property Password:string read FPassword write FPassword;
    property IdentifyFile:string read FIdentifyFile write FIdentifyFile;
  end;

implementation
uses process, fbmToolsUnit;

{ TSSHConnectionPlugin }

procedure TSSHConnectionPlugin.InternalBuildCommand;
var
  S: String;
begin
  S:=Format('%s -p %s %s -N -L %d:%s:%d %s -v', [
     ConfigValues.ByNameAsString('SSHConnectionPlugin/SSHPassFilePath', cmdSSHPasswd),
     Password,
     ConfigValues.ByNameAsString('SSHConnectionPlugin/SSHFilePath', cmdSSH),
     Owner.RemotePort,
     FHost,
     FPort,
     FUserName]);
  FSSHModule.CommandLine:=S;
end;

function TSSHConnectionPlugin.GetConnected: boolean;
begin
  Result:=FSSHModule.Running;
end;

procedure TSSHConnectionPlugin.SetConnected(AValue: boolean);
var
  S: String;
  C: DWord;
begin
  if AValue = FSSHModule.Running then exit;
  if AValue then
  begin
    InternalBuildCommand;
    FSSHModule.Execute;

    Sleep(5000); //wait for conect- ugly

    C:=FSSHModule.Output.NumBytesAvailable;
    if C>0 then
    begin
      SetLength(S, C);
      FSSHModule.Output.Read(S[1], C);
    end;
//    FSSHModule.Input.Write(FPassword[1], Length(FPassword));

  end
  else
  begin
    FSSHModule.Terminate(0);
  end;
end;

procedure TSSHConnectionPlugin.InternalLoad;
begin
  inherited InternalLoad;
  FHost:=LoadVariable('Host', '');
  FPort:=StrToInt(LoadVariable('Port', '-1'));
  FUserName:=LoadVariable('UserName', '');
  FPassword:=LoadVariable('Password', '');
  FIdentifyFile:=LoadVariable('IdentifyFile', '');
end;

procedure TSSHConnectionPlugin.InternalSave;
begin
  inherited InternalSave;

  SaveVariable('Host', FHost);
  SaveVariable('Port', IntToStr(FPort));
  SaveVariable('UserName', FUserName);
  SaveVariable('Password', FPassword);
  SaveVariable('IdentifyFile', FIdentifyFile);
end;

constructor TSSHConnectionPlugin.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FSSHModule:=TProcessUTF8.Create(nil);
  FSSHModule.Options:=[poUsePipes, poStderrToOutPut {, poNoConsole}];
end;

destructor TSSHConnectionPlugin.Destroy;
begin
  FreeAndNil(FSSHModule);
  inherited Destroy;
end;

end.

