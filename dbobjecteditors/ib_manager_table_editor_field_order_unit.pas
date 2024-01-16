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

unit ib_manager_table_editor_field_order_unit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ButtonPanel, Menus, ActnList;

type

  { TfbmTableEditorFieldOrderForm }

  TfbmTableEditorFieldOrderForm = class(TForm)
    fldMoveUp: TAction;
    fldMoveDown: TAction;
    ActionList1: TActionList;
    ButtonPanel1: TButtonPanel;
    ListBox1: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure fldMoveDownExecute(Sender: TObject);
    procedure fldMoveUpExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    procedure Localize;
    procedure UpdateState;
  public
    { public declarations }
  end; 

var
  fbmTableEditorFieldOrderForm: TfbmTableEditorFieldOrderForm;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmTableEditorFieldOrderForm }

procedure TfbmTableEditorFieldOrderForm.fldMoveUpExecute(Sender: TObject);
var
  S:string;
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>0) then
  begin
    S:=ListBox1.Items[ListBox1.ItemIndex];
    ListBox1.Items[ListBox1.ItemIndex]:=ListBox1.Items[ListBox1.ItemIndex - 1];
    ListBox1.Items[ListBox1.ItemIndex - 1]:=S;
    ListBox1.ItemIndex:=ListBox1.ItemIndex - 1;
  end;
  UpdateState;
end;

procedure TfbmTableEditorFieldOrderForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmTableEditorFieldOrderForm.ListBox1Click(Sender: TObject);
begin
  UpdateState;
end;

procedure TfbmTableEditorFieldOrderForm.ListBox1DragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  Ind: Integer;
  S: String;
begin
  Ind:=ListBox1.TopIndex + Y div ListBox1.ItemHeight;

  if (Ind > -1) and (Ind < ListBox1.Items.Count) then
  begin
    S:=ListBox1.Items[ListBox1.ItemIndex];
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    ListBox1.Items.Insert(Ind, S);
    ListBox1.ItemIndex:=Ind;
    UpdateState;
  end;
end;

procedure TfbmTableEditorFieldOrderForm.ListBox1DragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=Source = ListBox1;
end;

procedure TfbmTableEditorFieldOrderForm.Localize;
begin
  Caption:=sFieldsOrder;
  fldMoveUp.Caption:=sMoveUp;
  fldMoveUp.Hint:=sMoveUpHint;
  fldMoveDown.Caption:=sMoveDown;
  fldMoveDown.Hint:=sMoveDownHint;
end;

procedure TfbmTableEditorFieldOrderForm.fldMoveDownExecute(Sender: TObject
  );
var
  S:string;
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex<ListBox1.Items.Count-1) then
  begin
    S:=ListBox1.Items[ListBox1.ItemIndex];
    ListBox1.Items[ListBox1.ItemIndex]:=ListBox1.Items[ListBox1.ItemIndex+1];
    ListBox1.Items[ListBox1.ItemIndex+1]:=S;
    ListBox1.ItemIndex:=ListBox1.ItemIndex + 1;
  end;
  UpdateState;
end;

procedure TfbmTableEditorFieldOrderForm.UpdateState;
begin
  fldMoveUp.Enabled:=(ListBox1.Items.Count>0) and (ListBox1.ItemIndex>0);
  fldMoveDown.Enabled:=(ListBox1.Items.Count>0) and (ListBox1.ItemIndex<ListBox1.Items.Count-1);
end;

end.

