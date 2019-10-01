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

unit cfPostgreeConfigMiskUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    cfAbstractConfigFrameUnit; 

type

  { TcfPostgreeConfigMiskFrame }

  TcfPostgreeConfigMiskFrame = class(TFBMConfigPageAbstract)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    { private declarations }
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit, pg_utils;

{$R *.lfm}

{ TcfPostgreeConfigMiskFrame }

constructor TcfPostgreeConfigMiskFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

function TcfPostgreeConfigMiskFrame.PageName: string;
begin
  Result:='PostgreSQL\Параметры';
end;

procedure TcfPostgreeConfigMiskFrame.LoadData;
begin
  ComboBox1.ItemIndex:=ConfigValues.ByNameAsInteger('TSQLEnginePostgre\Initial ACL page', 0);
  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean('TSQLEnginePostgre\CreateIndexAfterCreateFK', false);
  CheckBox2.Checked:=ConfigValues.ByNameAsBoolean('TSQLEnginePostgre\Show table partiotions', PGShowTtablePartiotions);
  Edit1.Text:=IntToStr(ConfigValues.ByNameAsInteger('TSQLEnginePostgre\Initial value for new sequence', 0));
end;

procedure TcfPostgreeConfigMiskFrame.SaveData;
begin
  ConfigValues.SetByNameAsInteger('TSQLEnginePostgre\Initial ACL page', ComboBox1.ItemIndex);
  ConfigValues.SetByNameAsBoolean('TSQLEnginePostgre\CreateIndexAfterCreateFK', CheckBox1.Checked);
  ConfigValues.SetByNameAsBoolean('TSQLEnginePostgre\Show table partiotions', CheckBox2.Checked);
  ConfigValues.SetByNameAsInteger('TSQLEnginePostgre\Initial value for new sequence', StrToInt64Def(Edit1.Text, 0));

  PGShowTtablePartiotions:=CheckBox2.Checked;
end;

procedure TcfPostgreeConfigMiskFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sShowObjectOnGrantPageDefault;
  Label2.Caption:=sInitialValueForNewSequence;
  CheckBox1.Caption:=sCreateIndexAfterCreateFK;
  CheckBox2.Caption:=sShowTtablePartiotions;

  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(sShowAllObjects);
  ComboBox1.Items.Add(sOnlyShowUsers);
  ComboBox1.Items.Add(sOnlyShowGroups);
end;

end.

