{ Free DB Manager

  Copyright (C) 2005-2021 Lagunov Aleksey  alexs75 at yandex.ru

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

unit cfReportsOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, EditBtn, Dialogs,
  cfAbstractConfigFrameUnit;

type

  { TcfReportsOptionsFrame }

  TcfReportsOptionsFrame = class(TFBMConfigPageAbstract)
    CheckBox2: TCheckBox;
    EditButton1: TEditButton;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Label2: TLabel;
    procedure EditButton1ButtonClick(Sender: TObject);
  private
    procedure UpdateFontLabel;
  public
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TcfReportsOptionsFrame }

procedure TcfReportsOptionsFrame.EditButton1ButtonClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(EditButton1.Font);
  if FontDialog1.Execute then
  begin
    EditButton1.Font.Assign(FontDialog1.Font);
    UpdateFontLabel;
  end;
end;

procedure TcfReportsOptionsFrame.UpdateFontLabel;
begin
  Label2.Caption:=Format('%s, Size=%d', [EditButton1.Font.Name, EditButton1.Font.Size]);
end;

function TcfReportsOptionsFrame.PageName: string;
begin
  Result:=sReportsOptions;
end;

procedure TcfReportsOptionsFrame.LoadData;
begin
  CheckBox2.Checked:=ShowDesigner;

  EditButton1.Font.Name:=ConfigValues.ByNameAsString('Reports_GridPrintFont_Name', 'Sans');
  EditButton1.Font.Size:=ConfigValues.ByNameAsInteger('Reports_GridPrintFont_Size', 10);

  UpdateFontLabel;
end;

procedure TcfReportsOptionsFrame.SaveData;
begin
  ConfigValues.SetByNameAsString('Reports_GridPrintFont_Name', EditButton1.Font.Name);
  ConfigValues.SetByNameAsInteger('Reports_GridPrintFont_Size', EditButton1.Font.Size);
  ShowDesigner:=CheckBox2.Checked;
end;

procedure TcfReportsOptionsFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sSelectFontForPrint;
  EditButton1.Caption:=sItsExample;
  CheckBox2.Caption:=sShowDesigner;
end;


end.

