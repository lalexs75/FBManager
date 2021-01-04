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

unit fbmManagerTableEditorFKUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ButtonPanel, SQLEngineAbstractUnit, ExtCtrls, ComCtrls, sqlObjects;


type

  { TfbmManagerTableEditorFKForm }

  TfbmManagerTableEditorFKForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    edtIndexName: TEdit;
    edtTableName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListBox2: TListBox;
    ListBox1: TListBox;
    ListBox4: TListBox;
    ListBox3: TListBox;
    edtFKName: TEdit;
    Memo1: TMemo;
    PageControl1: TPageControl;
    RadioGroup1: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure ListBox4DblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    DBTable:TDBTableObject;
    procedure FillFieldList;
    procedure FillTablesList;
    procedure MakeFKName;
    procedure CreateIndexName;
    procedure Localize;
  public
    constructor Create(ADBTable:TDBTableObject);
    function FKFields:string;
    function RefTable:string;
    function RefFields:string;
    function FKIndexName:string;
    function ForeignKeyRuleOnUpdate:TForeignKeyRule;
    function ForeignKeyRuleOnDelete:TForeignKeyRule;
  end;

var
  fbmManagerTableEditorFKForm: TfbmManagerTableEditorFKForm;

implementation
uses rxAppUtils, IBManagerTypesUnit, fbmStrConstUnit, fbmToolsUnit,
  SQLEngineCommonTypesUnit, SQLEngineInternalToolsUnit;

{$R *.lfm}

{ TfbmManagerTableEditorFKForm }

procedure TfbmManagerTableEditorFKForm.ComboBox1Change(Sender: TObject);
var
  T:TDBTableObject;
  i:integer;
begin
  ListBox4.Items.Clear;
  I:=ComboBox1.ItemIndex;
  if (i>=0) and (i<ComboBox1.Items.Count) then
  begin
    T:=TDBTableObject(ComboBox1.Items.Objects[i]);
    ListBox3.Items.Clear;
    T.FillFieldList(ListBox3.Items, ccoNoneCase, False);
    if ListBox3.Items.Count>0 then
      ListBox3.ItemIndex:=0;
  end;
end;

procedure TfbmManagerTableEditorFKForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
  begin
    CanClose:=ListBox2.Items.Count>0;
    if not CanClose then
    begin
      ErrorBox(sFKDlgErr1);
      exit;
    end;
    CanClose:=ListBox4.Items.Count>0;
    if not CanClose then
    begin
      ErrorBox(sFKDlgErr2);
      exit;
    end;
  end;
end;

procedure TfbmManagerTableEditorFKForm.CheckBox1Change(Sender: TObject);
begin
  Label1.Enabled:=CheckBox1.Checked;
  edtIndexName.Enabled:=CheckBox1.Checked;
  RadioGroup1.Enabled:=CheckBox1.Checked;

  if CheckBox1.Checked then
    CreateIndexName;
end;

procedure TfbmManagerTableEditorFKForm.ListBox1DblClick(Sender: TObject);
begin
  SpeedButton2.Click;
end;

procedure TfbmManagerTableEditorFKForm.ListBox2DblClick(Sender: TObject);
begin
  SpeedButton1.Click;
end;

procedure TfbmManagerTableEditorFKForm.ListBox3DblClick(Sender: TObject);
begin
  SpeedButton4.Click;
end;

procedure TfbmManagerTableEditorFKForm.ListBox4DblClick(Sender: TObject);
begin
  SpeedButton3.Click;
end;

procedure TfbmManagerTableEditorFKForm.SpeedButton2Click(Sender: TObject);
var
  i,k:integer;
  P1, P2:TListBox;
  S:string;
begin
  case (Sender as TSpeedButton).Tag of
    1:begin
        P1:=ListBox1;
        P2:=ListBox2;
      end;
    2:begin
        P1:=ListBox2;
        P2:=ListBox1;
      end;
    3:begin
        P1:=ListBox3;
        P2:=ListBox4;
      end;
    4:begin
        P1:=ListBox4;
        P2:=ListBox3;
      end;
  else
    exit;
  end;

  if P1.Items.Count>0 then
  begin
    i:=P1.ItemIndex;
    if (i>=0) and (I<P1.Items.Count) then
    begin
      S:=P1.Items[i];
      P1.Items.Delete(i);
      P2.Items.Add(S);
      if P1.Items.Count>0 then
        P1.ItemIndex:=0;
    end;
  end;
end;

procedure TfbmManagerTableEditorFKForm.FillFieldList;
begin
  ListBox1.Items.Clear;
  DBTable.FillFieldList(ListBox1.Items, ccoNoneCase, False);
  if ListBox1.Items.Count>0 then
    ListBox1.ItemIndex:=0;
end;

procedure TfbmManagerTableEditorFKForm.FillTablesList;
procedure DoFill(P:TDBRootObject);
var
  i:integer;
begin
  if Assigned(P) then
  begin
    for i:=0 to p.CountGroups-1 do
      DoFill(P.Groups[i]);

    if (P.DBObjectKind in [okPartitionTable, okTable]) {and (p.CountGrp > 0)} then
    begin
      for i:=0 to P.CountObject - 1 do
      begin
        ComboBox1.Items.AddObject(P.Items[i].CaptionFullPatch, P.Items[i]);
        //ComboBox1.Items.Objects[k]:=P.Items[i];
      end;
    end;

  end;
end;

var
  P: TDBObject;
begin
  ComboBox1.Items.Clear;
  for P in DBTable.OwnerDB.Groups do
    DoFill(P as TDBRootObject);

  if ComboBox1.Items.Count>0 then
  begin
    ComboBox1.ItemIndex:=0;
    ComboBox1Change(nil);
  end;
end;

procedure TfbmManagerTableEditorFKForm.MakeFKName;
var
  i:integer;
  S:string;
begin
  i:=0;
  repeat
    inc(i);
    S:=FormatStringCase(Format(sFKNameMask, [DBTable.Caption,i]), DBTable.OwnerDB.MiscOptions.ObjectNamesCharCase);
  until not Assigned(DBTable.ConstraintFind(S));
  edtFKName.Text:=S;
end;

procedure TfbmManagerTableEditorFKForm.CreateIndexName;
var
  i:integer;
  s:string;
begin
  DBTable.IndexListRefresh;
  i:=0;
  repeat
    Inc(i);
    S:=FormatStringCase(Format(sFKIndexNameMask,[DBTable.Caption, i]), DBTable.OwnerDB.MiscOptions.ObjectNamesCharCase);
  until not Assigned(DBTable.IndexFind(S));
  edtIndexName.Text:=S;
end;

procedure TfbmManagerTableEditorFKForm.Localize;
begin
  Caption:=sForeignKeys;
  Label3.Caption:=sTableName;
  Label2.Caption:=sFKName;
  RadioGroup1.Caption:=sSortOrder;
  RadioGroup1.Items[0]:=sAscending;
  RadioGroup1.Items[1]:=sDescending;
  CheckBox1.Caption:=sCreateIndex;
  Label1.Caption:=sIndexName;
  Label4.Caption:=sOnField;
  Label5.Caption:=sOnUpdate;
  Label6.Caption:=sOnDelete;
  TabSheet2.Caption:=sDescription;
  TabSheet1.Caption:=sForeignKeyRule;
end;

constructor TfbmManagerTableEditorFKForm.Create(ADBTable:TDBTableObject);
begin
  inherited Create(Application);
  Localize;
  PageControl1.ActivePageIndex:=0;
  RadioGroup1.Items.Clear;
  RadioGroup1.Items.Add(sAscending);
  RadioGroup1.Items.Add(sDescending);

  DBTable:=ADBTable;
  edtTableName.Text:=DBTable.Caption;
  FillTablesList;
  FillFieldList;
  MakeFKName;

  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean(DBTable.OwnerDB.ClassName + '_CreateIndexAfterCreateFK', false);;
  CheckBox1Change(nil);

  if Assigned(ADBTable) and Assigned(ADBTable.OwnerDB) then
    TabSheet2.TabVisible:=feDescribeTableConstraint in ADBTable.OwnerDB.SQLEngileFeatures
  else
    TabSheet2.TabVisible:=false;
end;

function TfbmManagerTableEditorFKForm.FKFields: string;
var
  i:integer;
begin
  Result:='';
  for i:=0 to ListBox2.Items.Count-1 do
    Result:=Result+', '+ DoFormatName(ListBox2.Items[i]);
  Result:=Copy(Result, 3, Length(Result))
end;

function TfbmManagerTableEditorFKForm.RefTable: string;
begin
  Result:=ComboBox1.Text;
end;

function TfbmManagerTableEditorFKForm.RefFields: string;
var
  i:integer;
begin
  Result:='';
  for i:=0 to ListBox4.Items.Count - 1 do
    Result:=Result + ', ' + DoFormatName(ListBox4.Items[i]);
  Result:=Copy(Result, 3, Length(Result))
end;

function TfbmManagerTableEditorFKForm.FKIndexName: string;
begin
  if CheckBox1.Checked then
    Result:=edtIndexName.Text
  else
    Result:='';
end;

function TfbmManagerTableEditorFKForm.ForeignKeyRuleOnUpdate: TForeignKeyRule;
begin
  case ComboBox2.ItemIndex of
    1:Result:=fkrCascade;
    2:Result:=fkrSetNull;
    3:Result:=fkrSetDefault;
  else
    Result:=fkrNone
  end;
end;

function TfbmManagerTableEditorFKForm.ForeignKeyRuleOnDelete: TForeignKeyRule;
begin
  case ComboBox3.ItemIndex of
    1:Result:=fkrCascade;
    2:Result:=fkrSetNull;
    3:Result:=fkrSetDefault;
  else
    Result:=fkrNone
  end;
end;

end.

