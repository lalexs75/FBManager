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

unit fbmCreateConnectionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ButtonPanel, StdCtrls;

type

  { TfbmCreateConnectionForm }

  TfbmCreateConnectionForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    procedure Localize;
  public
    function SQLEngineName:string;
  end; 

var
  fbmCreateConnectionForm: TfbmCreateConnectionForm;

implementation
uses SQLEngineAbstractUnit, fbm_VisualEditorsAbstractUnit, fbmStrConstUnit;

{$R *.lfm}

{ TfbmCreateConnectionForm }

procedure TfbmCreateConnectionForm.FormCreate(Sender: TObject);
begin
  Localize;
  FillSQLEngineNames(ListBox1.Items);
  if ListBox1.Items.Count>0 then
    ListBox1Click(nil);
end;

procedure TfbmCreateConnectionForm.ListBox1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>=0) then
    Memo1.Lines.Add(SQLEngineAbstractClassArray[ListBox1.ItemIndex].Description);
end;

procedure TfbmCreateConnectionForm.ListBox1DblClick(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TfbmCreateConnectionForm.Localize;
begin
  Caption:=sSelectConnectionType;
  Label1.Caption:=sSelectConnectionType;
  Label2.Caption:=sDescription;
end;

function TfbmCreateConnectionForm.SQLEngineName: string;
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>=0) then
    Result:=ListBox1.Items[ListBox1.ItemIndex]
  else
    Result:='';
end;

end.

