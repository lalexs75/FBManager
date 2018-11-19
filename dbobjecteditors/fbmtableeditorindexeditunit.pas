{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmTableEditorIndexEditUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ButtonPanel, SQLEngineAbstractUnit, ExtCtrls,
  SQLEngineCommonTypesUnit;

type

  { TfbmIndexEditorForm }

  TfbmIndexEditorForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    cbUnique: TCheckBox;
    ComboBox1: TComboBox;
    EditIndexName: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FDBTableObject:TDBTableObject;
    FRec:TIndexItem;
    function GetSelectedFields: string;
    procedure SetSelectedFields(AValue: string);
    procedure UpdateFieldsList;
    procedure FillFieldList;
    procedure CreateIndexName;
    procedure Localize;
  public
    procedure InitVar(ADBTableObject:TDBTableObject; ARec:TIndexItem);
    property SelectedFields:string read GetSelectedFields write SetSelectedFields;
  end;

var
  fbmIndexEditorForm: TfbmIndexEditorForm;

implementation
uses fbmToolsUnit, db, fbmStrConstUnit, strutils;

{$R *.lfm}

{ TfbmIndexEditorForm }

procedure TfbmIndexEditorForm.SpeedButton1Click(Sender: TObject);
begin
  if (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex< ListBox1.Items.Count) then
  begin
    ListBox2.Items.Add(ListBox1.Items[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    UpdateFieldsList;
  end;
end;

procedure TfbmIndexEditorForm.FormActivate(Sender: TObject);
begin
  OnActivate:=nil;
  ComboBox1.Height:=Edit2.Height;
end;

procedure TfbmIndexEditorForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
  begin
    CanClose:=EditIndexName.Text<>'';
    if not CanClose then
    begin
      ErrorBox(sIndexNameIsEmpty);
      exit;
    end;
    
    CanClose:=not Assigned(FDBTableObject.IndexFind(EditIndexName.Text));
    if not CanClose then
    begin
      ErrorBox(sDuplicateIndexName);
      exit;
    end;
  end;
end;

procedure TfbmIndexEditorForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmIndexEditorForm.FormResize(Sender: TObject);
begin
  ListBox1.Width:=(Width - SpeedButton1.Width - 24) div 2;
end;

procedure TfbmIndexEditorForm.SpeedButton2Click(Sender: TObject);
begin
  if (ListBox2.ItemIndex>-1) and (ListBox2.ItemIndex< ListBox2.Items.Count) then
  begin
    ListBox1.Items.Add(ListBox2.Items[ListBox2.ItemIndex]);
    ListBox2.Items.Delete(ListBox2.ItemIndex);
    UpdateFieldsList;
  end;
end;

procedure TfbmIndexEditorForm.UpdateFieldsList;
begin
  SpeedButton1.Enabled:=ListBox1.Items.Count>0;
  SpeedButton2.Enabled:=ListBox2.Items.Count>0;
end;

function TfbmIndexEditorForm.GetSelectedFields: string;
var
  i:integer;
begin
  Result:='';
  for i:=0 to ListBox2.Items.Count-1 do
  begin
    if Result<>'' then
      Result := Result + ', ';
    Result:=Result + ListBox2.Items[i];
  end;
end;

procedure TfbmIndexEditorForm.SetSelectedFields(AValue: string);
var
  c:integer;
  S:string;
begin
  if AValue = '' then exit;
  while AValue<>'' do
  begin
     S:=trim(Copy2SymbDel(AValue, ','));
     if (S<>'') and (S[Length(S)]=',') then
       Delete(S, Length(S), 1);

     ListBox2.Items.Add(S);
     C:=ListBox1.Items.IndexOf(S);
     if C>=0 then
       ListBox1.Items.Delete(C);
  end;
end;

procedure TfbmIndexEditorForm.FillFieldList;
begin
  ListBox1.Items.Clear;
  FDBTableObject.FillFieldList(ListBox1.Items, TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseIdentif', 0)), False);
end;

procedure TfbmIndexEditorForm.CreateIndexName;
var
  i:integer;
begin
  i:=1;
  while Assigned(FDBTableObject.IndexFind(FDBTableObject.Caption+'_idx_'+IntToStr(i))) do
    i:=i+1;
  EditIndexName.Text:=FDBTableObject.Caption+'_idx_'+IntToStr(i);
end;

procedure TfbmIndexEditorForm.Localize;
begin
  Caption:=sNewIndex;
  Label1.Caption:=sIndexName;
  Label2.Caption:=sTableName;
  Label3.Caption:=sSortOrder;
  cbUnique.Caption:=sUnique;
end;

procedure TfbmIndexEditorForm.InitVar(ADBTableObject:TDBTableObject;
  ARec:TIndexItem);
begin
  FDBTableObject:=ADBTableObject;
  FRec:=ARec;
  Edit2.Text:=FDBTableObject.Caption;
  FillFieldList;
  UpdateFieldsList;

  if Assigned(FRec) then
  begin
    SelectedFields:=FRec.IndexField;
    cbUnique.Checked:=FRec.Unique;
    EditIndexName.Text:=FRec.IndexName;
  end;

  CreateIndexName;
end;


end.

