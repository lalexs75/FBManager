{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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
  sshTimeout = 200;

type
  TSSHAuthType = (autPassword, autKey);

  { TSSHConnectionPlugin }

  TSSHConnectionPlugin = class(TSQLEngineConnectionPlugin)
  private
    FAuthType: TSSHAuthType;
    FHost: string;
    FIdentifyFile: string;
    FPassword: string;
    FPort: integer;
    FUserName: string;
    procedure InternalBuildCommandPwd;
    procedure InternalBuildCommandKey;
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
    property AuthType:TSSHAuthType read FAuthType write FAuthType;
  end;

implementation
uses process, fbmToolsUnit, fbmStrConstUnit, rxlogging;

const //Dont translate - standart messages from SSH
  sMsgOk1    = 'debug1: Authentication succeeded';
  sMsgOk2    = 'Authenticated to ';
  sMsgOk3    = 'debug1: Local connections to ';
  sMsgError1 = 'Permission denied, please try again.';

{ TSSHConnectionPlugin }

procedure TSSHConnectionPlugin.InternalBuildCommandPwd;
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

procedure TSSHConnectionPlugin.InternalBuildCommandKey;
var
  S: String;
begin
  S:=Format('%s -N -L %d:%s:%d %s -v', [
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
  S, SLine, S1: String;
  C: DWord;
  FStop: Boolean;
  Tick, k, KStart, j: Integer;
begin
  if AValue = FSSHModule.Running then exit;
  if AValue then
  begin
    if FAuthType = autPassword then
      InternalBuildCommandPwd
    else
      InternalBuildCommandKey;

    FSSHModule.Execute;

    FStop:=false;
    Tick:=0;
    S:='';
    SLine:='';
    while not FStop do
    begin
      Sleep(10);
      C:=FSSHModule.Output.NumBytesAvailable;
      if C>0 then
      begin
        k:=Length(SLine);
        SetLength(S, C);
        FSSHModule.Output.Read(S[1], C);
        SLine:=SLine + S;
        KStart:=1;
        for j:=1 to Length(SLine) do
        begin
          if (SLine[j] in [#13, #10]) then
          begin
            S1:=Trim(Copy(SLine, KStart, j - KStart));
            if S1<>'' then
            begin
              if (Copy(S1, 1, Length(sMsgOk1)) = sMsgOk1) or (Copy(S1, 1, Length(sMsgOk2)) = sMsgOk2) or (Copy(S1, 1, Length(sMsgOk3)) = sMsgOk3) then
              begin
                FStop:=true;
                Tick:=1000;
              end
              else
              if Copy(S1, 1, Length(sMsgError1)) = sMsgError1 then
              begin
                FStop:=true;
                Tick:=2000;
              end;
            end;
            KStart:=j+1;
          end;
        end;
        SLine:=Copy(SLine, KStart, Length(SLine));
      end;
      inc(Tick);
      FStop:=(Tick > sshTimeout) or (not FSSHModule.Running);
    end;

    if ((Tick<1000) or (Tick>2000)) then
    begin
      if FSSHModule.Running then
        FSSHModule.Terminate(0);
      if (Tick<1000) then
        raise Exception.Create(sSSHConnectionTimeout)
      else
        raise Exception.Create(sSSHConnectionLoginFiled)
    end;

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
  FPort:=LoadVariableInt('Port', -1);
  FUserName:=LoadVariable('UserName', '');
  FPassword:=LoadVariable('Password', '');
  FIdentifyFile:=LoadVariable('IdentifyFile', '');
  FAuthType:=TSSHAuthType( LoadVariableInt('IdentifyFile', Ord(autPassword)));
end;

procedure TSSHConnectionPlugin.InternalSave;
begin
  inherited InternalSave;

  SaveVariable('Host', FHost);
  SaveVariableInt('Port', FPort);
  SaveVariable('UserName', FUserName);
  SaveVariable('Password', FPassword);
  SaveVariable('IdentifyFile', FIdentifyFile);
  SaveVariableInt('IdentifyFile', Ord(autPassword));
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

