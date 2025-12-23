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

unit otPostgreTableTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, 
    cfAbstractConfigFrameUnit;


type

  { TotPostgreTableTemplateFrame }

  TotPostgreTableTemplateFrame = class(TFBMConfigPageAbstract)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private

  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure Localize;override;
    procedure LoadData;override;
    procedure SaveData;override;
  end;

implementation

uses fbmToolsUnit, fbmStrConstUnit, pg_sql_lines_unit;

{$R *.lfm}

{ TotPostgreTableTemplateFrame }

constructor TotPostgreTableTemplateFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

function TotPostgreTableTemplateFrame.PageName: string;
begin
  Result:=sPGPgSqlTable;
end;

procedure TotPostgreTableTemplateFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sPartitionSectionNameTempate;
  Label2.Caption:=sPartitionSectionDescTempate;
end;

procedure TotPostgreTableTemplateFrame.LoadData;
begin
  Edit1.Text:=ConfigValues.ByNameAsString('Template/PostgreSQL/PartitionSectionName', DummyPGPartitionSectionName);
  Edit2.Text:=ConfigValues.ByNameAsString('Template/PostgreSQL/PartitionSectionDesc', DummyPGPartitionSectionDesc);
end;

procedure TotPostgreTableTemplateFrame.SaveData;
begin
  ConfigValues.SetByNameAsString('Template/PostgreSQL/PartitionSectionName', Edit1.Text);
  ConfigValues.SetByNameAsString('Template/PostgreSQL/PartitionSectionDesc', Edit2.Text);
end;

end.

