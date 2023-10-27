{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit SSHConnectionPluginConfigUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn, 
    cfAbstractConfigFrameUnit;

type

  { TSSHConnectionPluginConfig }

  TSSHConnectionPluginConfig = class(TFBMConfigPageAbstract)
    FileNameEdit1: TFileNameEdit;
    FileNameEdit2: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
  private

  public
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, SSHConnectionUnit;

{$R *.lfm}

{ TSSHConnectionPluginConfig }

function TSSHConnectionPluginConfig.PageName: string;
begin
  Result:=sSSHConnectionPlugin;
end;

procedure TSSHConnectionPluginConfig.LoadData;
begin
  FileNameEdit1.Text:=ConfigValues.ByNameAsString('SSHConnectionPlugin/SSHFilePath', cmdSSH);
  FileNameEdit2.Text:=ConfigValues.ByNameAsString('SSHConnectionPlugin/SSHPassFilePath', cmdSSHPasswd);
end;

procedure TSSHConnectionPluginConfig.SaveData;
begin
  ConfigValues.ByNameAsString('SSHConnectionPlugin/SSHFilePath', FileNameEdit1.Text);
  ConfigValues.ByNameAsString('SSHConnectionPlugin/SSHPassFilePath', FileNameEdit2.Text);
end;

procedure TSSHConnectionPluginConfig.Localize;
begin
  inherited Localize;
  Label1.Caption:=sSSHFilePath;
  Label2.Caption:=sSSHPassFilePath;
end;

end.

