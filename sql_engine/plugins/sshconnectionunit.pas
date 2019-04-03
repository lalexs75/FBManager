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

type

  { TSSHConnectionPlugin }

  TSSHConnectionPlugin = class(TSQLEngineConnectionPlugin)
  protected
    FSSHModule:TProcessUTF8;
    function GetConnected: boolean;
    procedure SetConnected(AValue: boolean);
  public
    constructor Create(AOwner:TSQLEngineAbstract); override;
    destructor Destroy; override;
  end;

implementation
uses process;

{ TSSHConnectionPlugin }

function TSSHConnectionPlugin.GetConnected: boolean;
begin
  Result:=FSSHModule.Running;
end;

procedure TSSHConnectionPlugin.SetConnected(AValue: boolean);
begin

end;

constructor TSSHConnectionPlugin.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FSSHModule:=TProcessUTF8.Create(nil);
  FSSHModule.Options:=[//poRunSuspended,
                       //poWaitOnExit,
                       //poUsePipes,
                       poStderrToOutPut,
                       poNoConsole,
                       //poNewConsole,
                       poDefaultErrorMode,
                       //poNewProcessGroup,
                       //poDebugProcess,
                       //poDebugOnlyThisProcess,
                       poPassInput];
end;

destructor TSSHConnectionPlugin.Destroy;
begin
  FreeAndNil(FSSHModule);
  inherited Destroy;
end;

end.

