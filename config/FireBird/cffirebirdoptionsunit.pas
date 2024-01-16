{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit cfFireBirdOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls,
  cfAbstractConfigFrameUnit;

type

  { TcfFireBirdOptionsFrame }

  TcfFireBirdOptionsFrame = class(TFBMConfigPageAbstract)
    CB_CharSet: TComboBox;
    CB_DefServer: TComboBox;
    ComboBox1: TComboBox;
    edtDefUserName: TEdit;
    edtDefUserPassword: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label2: TLabel;
  private
    { private declarations }
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, uiblib, fb_utils, fb_ConstUnit;

{$R *.lfm}

{ TcfFireBirdOptionsFrame }

procedure TcfFireBirdOptionsFrame.Localize;
begin
  inherited Localize;
  Label10.Caption:=sDefaultCharacterSet;
  Label12.Caption:=sDefaultUserName;
  Label13.Caption:=sDefaultPassword;
  Label16.Caption:=sDefaultServerVersion;

  Label2.Caption:=sShowObjectOnGrantPageDefault;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(sShowAllObjects);
  ComboBox1.Items.Add(sOnlyShowUsers);
  ComboBox1.Items.Add(sOnlyShowGroups);
end;

function TcfFireBirdOptionsFrame.PageName: string;
begin
  Result:=sFireBirdSQLServer;
end;

procedure TcfFireBirdOptionsFrame.LoadData;
var
  i:integer;
  cs:TCharacterSet;
begin
  FillStrServersVer(CB_DefServer.Items);

  edtDefUserName.Text:=ConfigValues.ByNameAsString('fb_defUserName', '');
  edtDefUserPassword.Text:=ConfigValues.ByNameAsString('fb_defUserPassword', '');
  CB_DefServer.ItemIndex:=ConfigValues.ByNameAsInteger('defServerVersion', 0);

  CB_CharSet.Items.Clear;
  for cs:=Low(TCharacterSet) to High(TCharacterSet) do
    CB_CharSet.Items.Add(CharacterSetStr[cs]);
{  I:=CB_CharSet.Items.IndexOf(defCharSet);
  if i<0 then i:=0;
  CB_CharSet.ItemIndex:=I;}

  CB_CharSet.Text:=ConfigValues.ByNameAsString('defCharSet', '');
  ComboBox1.ItemIndex:=ConfigValues.ByNameAsInteger('TSQLEngineFireBird\Initial ACL page', 0);
end;

procedure TcfFireBirdOptionsFrame.SaveData;
begin
  ConfigValues.SetByNameAsString('defCharSet', CB_CharSet.Text);
  ConfigValues.SetByNameAsString('fb_defUserName', edtDefUserName.Text);
  ConfigValues.SetByNameAsString('fb_defUserPassword', edtDefUserPassword.Text);
  ConfigValues.SetByNameAsInteger('defServerVersion', CB_DefServer.ItemIndex);
  //fbShowExecDescription:=CheckBox1.Checked;
  ConfigValues.SetByNameAsInteger('TSQLEngineFireBird\Initial ACL page', ComboBox1.ItemIndex);
end;

end.

