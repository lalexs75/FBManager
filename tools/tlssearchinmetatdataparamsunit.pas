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


unit tlsSearchInMetatDataParamsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, RxIniPropStorage, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ButtonPanel, sqlEngineTypes, SQLEngineAbstractUnit, sqlObjects;

type

  { TtlsSearchInMetatDataParamsForm }

  TtlsSearchInMetatDataParamsForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    dbComboBox: TComboBox;
    edtFind: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    RxIniPropStorage1: TRxIniPropStorage;
    procedure FormCreate(Sender: TObject);
  private
    FStage:boolean;
    FCntObj:integer;
    FCurObj:integer;
    procedure FillDBList;
    procedure FillResultList;
    procedure DoFindObj(Obj:TDBRootObject);
    procedure DoTestObj(Obj:TDBObject);
    procedure Localize;
  public
    { public declarations }
  end;

procedure ShowSearchInMetatDataParamsForm;
implementation

uses IBManDataInspectorUnit, ibmanagertypesunit, tlsSearchInMetatDataResultUnit,
  tlsProgressOperationUnit, SQLEngineCommonTypesUnit, fbmStrConstUnit,
  fbmToolsUnit, fdbm_SynEditorUnit;

{$R *.lfm}

procedure ShowSearchInMetatDataParamsForm;
var
  tlsSearchInMetatDataParamsForm: TtlsSearchInMetatDataParamsForm;
begin
  tlsSearchInMetatDataParamsForm:=TtlsSearchInMetatDataParamsForm.Create(Application);
  if tlsSearchInMetatDataParamsForm.ShowModal = mrOk then
    tlsSearchInMetatDataParamsForm.FillResultList;
  tlsSearchInMetatDataParamsForm.Free;
end;

{ TtlsSearchInMetatDataParamsForm }

procedure TtlsSearchInMetatDataParamsForm.FormCreate(Sender: TObject);
begin
  Localize;
  FillDBList;
end;

procedure TtlsSearchInMetatDataParamsForm.FillDBList;
var
  i, j:integer;
  P:TDataBaseRecord;
begin
  dbComboBox.Items.Clear;
  if not Assigned(fbManDataInpectorForm) then exit;
  for i:=0 to fbManDataInpectorForm.DBList.Count - 1 do
  begin
    P:=TDataBaseRecord(fbManDataInpectorForm.DBList[i]);
    j:=dbComboBox.Items.Add(P.Caption);
    dbComboBox.Items.Objects[j]:=P;
    if fbManDataInpectorForm.CurrentDB = P then
      dbComboBox.ItemIndex:=dbComboBox.Items.Count -1;
  end;
end;

procedure TtlsSearchInMetatDataParamsForm.FillResultList;
var
  P:TDataBaseRecord;
  i:integer;
begin
  sSearchText:=edtFind.Text;

  tlsShowSearchInMetatDataResultForm;
  //tlsSearchInMetatDataResultForm.ClearDBObjectsList;
  tlsSearchInMetatDataResultForm.AddRootNode(edtFind.Text);
  P:=TDataBaseRecord(dbComboBox.Items.Objects[dbComboBox.ItemIndex]);
  tlsSearchInMetatDataResultForm.EditorFrame.SQLEngine:=P.SQLEngine;

  ShowProgress;
  FStage:=false;
  FCntObj:=0;
  FCurObj:=0;

  for i:=0 to P.SQLEngine.Groups.Count - 1 do
    DoFindObj(TDBRootObject(P.SQLEngine.Groups[i]));

  FStage:=true;
  for i:=0 to P.SQLEngine.Groups.Count - 1 do
  begin
    DoFindObj(TDBRootObject(P.SQLEngine.Groups[i]));
    if FStage and tlsProgressOperationForm.OpCancel then
      break;
  end;

  HideProgress;
end;

procedure TtlsSearchInMetatDataParamsForm.DoFindObj(Obj: TDBRootObject);
var
  i:integer;
begin
  DoTestObj(Obj);

  for i:=0 to Obj.CountGroups - 1 do
  begin
    DoFindObj(Obj.Groups[i]);
    if FStage and tlsProgressOperationForm.OpCancel then
      break;
  end;

  for i:=0 to Obj.CountObject - 1 do
  begin
    DoTestObj(Obj.Items[i]);
    if FStage and tlsProgressOperationForm.OpCancel then
      break;
  end;
end;

procedure TtlsSearchInMetatDataParamsForm.DoTestObj(Obj: TDBObject);
var
  S:string;
begin
  if FStage then
  begin
    Inc(FCurObj);
    AddProgres(FCurObj, FCntObj);
    if ((Obj.DBObjectKind = okDomain) and (CheckBox1.Checked))
      or
       ((Obj.DBObjectKind in [okPartitionTable, okTable]) and (CheckBox2.Checked))
      or
       ((Obj.DBObjectKind in [okView, okMaterializedView]) and (CheckBox3.Checked))
      or
       ((Obj.DBObjectKind in [okStoredProc, okFunction]) and (CheckBox4.Checked))
      or
       ((Obj.DBObjectKind = okTrigger) and (CheckBox5.Checked)) then
  {  okSequence, okException, okUDF, okRole, okUser, okScheme, okGroup, okIndex, okTableSpace, okLanguage, okCheckConstraint, okForeignKey, okPrimaryKey, okUniqueConstraint, okOther}
    begin
      try
        if not Obj.Loaded then
          Obj.RefreshObject;
      except
        on E:Exception do
          ErrorBoxExcpt(E);
      end;
      S:=Obj.InternalGetDDLCreate;
      if (S<>'') and (Pos(edtFind.Text, S)>0) then
        tlsSearchInMetatDataResultForm.AddDBObject(Obj);
    end;
  end
  else
    Inc(FCntObj);
end;

procedure TtlsSearchInMetatDataParamsForm.Localize;
begin
  Caption:=sFindInMetatada;
  Label1.Caption:=sFindInDatabase;
  Label2.Caption:=sFindText;
  GroupBox1.Caption:=sFindOptions;
  CheckBox6.Caption:=sCaseSensetive;
  GroupBox2.Caption:=sFindInObjects;
  CheckBox1.Caption:=sDomains;
  CheckBox2.Caption:=sTables;
  CheckBox3.Caption:=sViews;
  CheckBox4.Caption:=sStoredProcedures;
  CheckBox5.Caption:=sTriggers;
end;


end.

