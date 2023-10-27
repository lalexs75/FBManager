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

unit fbmCreateProcTableUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxtoolbar, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, CheckLst, ActnList, Menus, {PostgreSQLEngineUnit, fbmpgACLEditUnit}
  SQLEngineAbstractUnit, fdbm_SynEditorUnit;

type

  { TfbmCreateProcTableForm }

  TfbmCreateProcTableForm = class(TForm)
    actCompile: TAction;
    fldInvertSelections: TAction;
    fldSelectAll: TAction;
    fldDeselectAll: TAction;
    ActionList1: TActionList;
    CheckGroup1: TCheckGroup;
    cbSPIU: TCheckListBox;
    cbSPSelect: TCheckListBox;
    cbSPInsert: TCheckListBox;
    CheckListBox4: TCheckListBox;
    cbSPDelete: TCheckListBox;
    edtSPIUName: TEdit;
    edtSPSName: TEdit;
    edtSPIName: TEdit;
    edtSPUName: TEdit;
    edtSPDName: TEdit;
    edtTableName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    tabS: TTabSheet;
    tabU: TTabSheet;
    tabD: TTabSheet;
    tabIU: TTabSheet;
    tabI: TTabSheet;
    TabSheet6: TTabSheet;
    ToolPanel1: TToolPanel;
    procedure actCompileExecute(Sender: TObject);
    procedure cbSPDeleteClickCheck(Sender: TObject);
    procedure cbSPInsertClickCheck(Sender: TObject);
    procedure cbSPIUClickCheck(Sender: TObject);
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure fldSelectAllExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FPGTable:TDBTableObject; //TPGTable;

    FIUSql:Tfdbm_SynEditorFrame;
    FISql:Tfdbm_SynEditorFrame;
    FUSql:Tfdbm_SynEditorFrame;
    FSSql:Tfdbm_SynEditorFrame;
    FDSql:Tfdbm_SynEditorFrame;

    procedure FillFields;
  public
    procedure Localize;
    constructor CreateEditForm(APGTable:TDBTableObject);
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit, SQLEngineCommonTypesUnit, fdmAbstractEditorUnit;

{$R *.lfm}

procedure AddCommaText(var S:string; const AText:string; AWrap:boolean);
var
  B:boolean;
begin
  B:=S<>'';
  if S<>'' then
    S:=S+', ';
  if AWrap and B then
    S:=S+LineEnding;
  S:=S+AText;
end;

{ TfbmCreateProcTableForm }

procedure TfbmCreateProcTableForm.cbSPIUClickCheck(Sender: TObject);
const
  spBody =
  'CREATE OR REPLACE FUNCTION %s ('+LineEnding+
  '%s'+LineEnding+
  '  )'+LineEnding+
  'RETURNS integer'+LineEnding+
  'AS'+LineEnding+
  '$BODY$'+LineEnding+
  '%s'+
  'begin'+LineEnding+
  LineEnding+
  '  --Изменим текущие данные'+LineEnding+
  '  update'+LineEnding+
  '    %s'+LineEnding+
  '  set'+LineEnding+
  '%s'+LineEnding+
  '  where'+LineEnding+
  '    %s;'+LineEnding+
  LineEnding+
  '  --Добавим недостающие'+LineEnding+
  '  if not found then'+LineEnding+
  '    insert into %s'+LineEnding+
  '      (%s)'+LineEnding+
  '    values'+LineEnding+
  '      (%s);'+LineEnding+
  '  end if;'+LineEnding+
  LineEnding+
  '  RETURN 0;'+LineEnding+
  'end;'+LineEnding+
  '$BODY$'+LineEnding+
  'LANGUAGE plpgsql'+LineEnding+
  ' VOLATILE  COST 100';

function MakeSQLWhere:string;
var
  F: TDBField;
begin
  Result:='';
  for F in FPGTable.Fields do
    if F.FieldPK then
    begin
      if Result<>'' then
        Result:=Result + ' and ';
      Result:=Result + '('+F.FieldName +' = a_'+F.FieldName+')';
    end;
end;

var
  S, S_Ins, S_InsVal, S_UpdList, S_ParamList, S_Comment:string;
  i:Integer;
begin

  S:=spBody;
  S_Ins:='';
  S_InsVal:='';
  S_UpdList:='';
  S_Comment:='';
  S_ParamList:='';
  for i:=0 to cbSPIU.Items.Count-1 do
  begin
    if cbSPIU.Checked[i] then
    begin
       AddCommaText(S_ParamList,  '  a_'+FPGTable.Fields.FieldByName(cbSPIU.Items[i]).DDLTypeStr, true);

       AddCommaText(S_UpdList, '    '+cbSPIU.Items[i] + ' = a_'+cbSPIU.Items[i], true);
       AddCommaText(S_Ins, cbSPIU.Items[i], false);
       AddCommaText(S_InsVal, 'a_'+cbSPIU.Items[i], false);

       if FPGTable.Fields.FieldByName(cbSPIU.Items[i]).FieldDescription<>'' then
         S_Comment:=S_Comment + '--$FBM a_' + cbSPIU.Items[i] +  ' ' + GetFistString(FPGTable.Fields.FieldByName(cbSPIU.Items[i]).FieldDescription) + LineEnding;

    end;
  end;
  FIUSql.EditorText:=Format(spBody, [edtSPIUName.Text,  //SP Name
                                     S_ParamList,                //SP Parmas list
                                     S_Comment,         //Коментарии к параметрам
                                     edtTableName.Text, //Update table name
                                     S_UpdList,         //Update fields list
                                     MakeSQLWhere,                //Update PK list
                                     edtTableName.Text, //Insert table name
                                     S_Ins,             //Insert filed names
                                     S_InsVal           //Insert filed values
                                    ]);
end;

procedure TfbmCreateProcTableForm.CheckGroup1ItemClick(Sender: TObject;
  Index: integer);

procedure DoShowFirstVisible;
var
  i: Integer;
begin
  for i:=0 to PageControl1.PageCount-1 do
  begin
    if PageControl1.Pages[i].TabVisible then
    begin
      PageControl1.ActivePageIndex:=i;
      exit;
    end;
  end;
end;

var
  T: TTabSheet;
begin
  T:=PageControl1.Pages[Index];
  T.TabVisible:=CheckGroup1.Checked[Index];
  if T.TabVisible then
  begin
    PageControl1.ActivePage:=T;
    case Index of
      2:if FISql.EditorText = '' then
         cbSPInsertClickCheck(nil);
      4:if FDSql.EditorText = '' then
         cbSPDeleteClickCheck(nil);
    end;
  end
  else
    DoShowFirstVisible;
end;

procedure TfbmCreateProcTableForm.fldSelectAllExecute(Sender: TObject);
var
  CLB: TCheckListBox;
  T: PtrInt;
  i: Integer;
begin
  CLB:=PopupMenu1.PopupComponent as TCheckListBox;
  if not Assigned(CLB) then exit;
  T:=TComponent(Sender).Tag;

  for i:=0 to CLB.Items.Count-1 do
  begin
    case T of
      0:CLB.Checked[i]:=not CLB.Checked[i];
      1:CLB.Checked[i]:=true;
      -1:CLB.Checked[i]:=false;
    end;
  end;

  if Assigned(CLB.OnClickCheck) then
    CLB.OnClickCheck(nil);
end;

procedure TfbmCreateProcTableForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TfbmCreateProcTableForm.FormDestroy(Sender: TObject);
var
  F: TACLListAbstract;
begin
(*  F:=FAclPAge.ACLList;
  FAclPAge.ACLList:=nil;
  FreeAndNil(F); *)
end;

procedure TfbmCreateProcTableForm.actCompileExecute(Sender: TObject);
var
  R:boolean;
//  P:TPGProcedure;
begin
  { TODO : Необходимо перевести создание процедур на работу через объекты }
  if CheckGroup1.Checked[0] then
  begin
    R:=ExecSQLScript(FIUSql.EditorText, [sepInTransaction, sepShowCompForm], FPGTable.OwnerDB);
    if R then
    begin
      { TODO : Необходимо реализовать открытие редактора вновь созданной процедуры }
(*      FPGTable.Schema.Procedures.RefreshGroup;
      P:=TPGProcedure(FPGTable.OwnerDB.DBObjectByName(edtSPIUName.Text));
      if Assigned(P) then
      begin
        FAclPAge.ACLList.DBObject:=P;
        FAclPAge.ACLList.ApplyACLList(nil);
        P.Edit;
      end; *)
    end;
  end;

  if CheckGroup1.Checked[2] then
  begin
    R:=ExecSQLScript(FISql.EditorText, [sepInTransaction, sepShowCompForm], FPGTable.OwnerDB);
    if R then
    begin
      { TODO : Необходимо реализовать открытие редактора вновь созданной процедуры }
(*      FPGTable.Schema.Procedures.RefreshGroup;
      P:=TPGProcedure(FPGTable.OwnerDB.DBObjectByName(edtSPIName.Text));
      if Assigned(P) then
      begin
        FAclPAge.ACLList.DBObject:=P;
        FAclPAge.ACLList.ApplyACLList(nil);
        P.Edit;
      end; *)
    end;
  end;

  if CheckGroup1.Checked[4] then
  begin
    R:=ExecSQLScript(FDSql.EditorText, [sepInTransaction, sepShowCompForm], FPGTable.OwnerDB);
    if R then
    begin
      { TODO : Необходимо реализовать открытие редактора вновь созданной процедуры }
(*      FPGTable.Schema.Procedures.RefreshGroup;
      P:=TPGProcedure(FPGTable.OwnerDB.DBObjectByName(edtSPDName.Text));
      if Assigned(P) then
      begin
        FAclPAge.ACLList.DBObject:=P;
        FAclPAge.ACLList.ApplyACLList(nil);
        P.Edit;
      end;*)
    end;
  end;
  Close;
end;

procedure TfbmCreateProcTableForm.cbSPDeleteClickCheck(Sender: TObject);
const
  spDelBody =
  'CREATE OR REPLACE FUNCTION %s ('+LineEnding+
  '%s'+LineEnding+
  '  )'+LineEnding+
  'RETURNS integer'+LineEnding+
  'AS'+LineEnding+
  '$BODY$'+LineEnding+
  '%s'+
  'begin'+LineEnding+
  LineEnding+
  '  --Удалим строку из таблицы'+LineEnding+
  '  delete'+LineEnding+
  '  from'+LineEnding+
  '    %s'+LineEnding+
  '  where'+LineEnding+
  '%s;'+LineEnding+
  LineEnding+
  '  RETURN 0;'+LineEnding+
  'end;'+LineEnding+
  '$BODY$'+LineEnding+
  'LANGUAGE plpgsql'+LineEnding+
  ' VOLATILE  COST 100';

{  function MakeSQLWhere:string;
  var
    F: TDBField;
  begin
    Result:='';
    for F in FPGTable.Fields do
      if F.FieldPK then
      begin
        if Result<>'' then
          Result:=Result + ' and ';
        Result:=Result + '('+F.FieldName +' = a_'+F.FieldName+')';
      end;
  end;}

var
  S_ParamList, S_Comment, S_UpdList, S: string;
  i: Integer;
begin
  S:=spDelBody;
  S_ParamList:='';
//  S_Ins:='';
//  S_InsVal:='';
  S_UpdList:='';
  S_Comment:='';
  for i:=0 to cbSPDelete.Items.Count-1 do
  begin
    if cbSPDelete.Checked[i] then
    begin
       AddCommaText(S_ParamList,  '  a_'+FPGTable.Fields.FieldByName(cbSPDelete.Items[i]).DDLTypeStr, true);

       if (S_UpdList<>'') then
         S_UpdList := S_UpdList + LineEnding + '    and'+LineEnding;
       S_UpdList:=S_UpdList + '      '+cbSPDelete.Items[i] + ' = a_'+cbSPDelete.Items[i];

//       AddCommaText(S_UpdList, '    '+cbSPIU.Items[i] + ' = a_'+cbSPIU.Items[i], true);
//       AddCommaText(S_Ins, cbSPIU.Items[i], false);
//       AddCommaText(S_InsVal, 'a_'+cbSPIU.Items[i], false);

       if FPGTable.Fields.FieldByName(cbSPDelete.Items[i]).FieldDescription<>'' then
         S_Comment:=S_Comment + '--$FBM a_' + cbSPDelete.Items[i] +  ' ' + GetFistString(FPGTable.Fields.FieldByName(cbSPDelete.Items[i]).FieldDescription) + LineEnding;

    end;
  end;
  FDSql.EditorText:=Format(spDelBody,
                                    [edtSPDName.Text,  //SP Name
                                     S_ParamList,                //SP Parmas list
                                     S_Comment,         //Коментарии к параметрам
                                     edtTableName.Text, //Update table name
                                     S_UpdList{,         //Update fields list
                                     MakeSQLWhere,                //Update PK list
                                     edtTableName.Text, //Insert table name
                                     S_Ins,             //Insert filed names
                                     S_InsVal           //Insert filed values}
                                    ]);
end;

procedure TfbmCreateProcTableForm.cbSPInsertClickCheck(Sender: TObject);
const
  spBodyIns =
  'CREATE OR REPLACE FUNCTION %s ('+LineEnding+
  '%s'+LineEnding+
  '  )'+LineEnding+
  'RETURNS integer'+LineEnding+
  'AS'+LineEnding+
  '$BODY$'+LineEnding+
  '%s'+
  'declare'+LineEnding+
  '%s'+
  'begin'+LineEnding+
  LineEnding+
  '  --Добавим данные'+LineEnding+
  '  insert into %s'+LineEnding+
  '    (%s)'+LineEnding+
  '  values'+LineEnding+
  '    (%s)'+LineEnding+
  '  returning'+LineEnding+
  '    %s'+LineEnding+
  '  into'+LineEnding+
  '    %s;'+LineEnding+
  LineEnding+
  '  RETURN %s;'+LineEnding+
  'end;'+LineEnding+
  '$BODY$'+LineEnding+
  'LANGUAGE plpgsql'+LineEnding+
  ' VOLATILE  COST 100';

  function MakePKField(APref:string; WT:boolean):string;
  var
    F: TDBField;
  begin
    Result:='';
    for F in FPGTable.Fields do
      if F.FieldPK then
      begin
        if Result<>'' then
        begin
          if not WT then
            Result:=Result + ',';
        end;

        if WT then
        begin
          Result:=Result + '  ' + APref + F.FieldName + ' ' + F.FieldTypeName + ';' + LineEnding;
        end
        else
          Result:=Result + APref + F.FieldName;
      end;
  end;

var
  S, S_Ins, S_InsVal, S_Comment, S_ParamList: String;
  i: Integer;
begin
  S_Ins:='';
  S_InsVal:='';
  S_Comment:='';
  S_ParamList:='';
  for i:=0 to cbSPInsert.Items.Count-1 do
  begin
    if cbSPInsert.Checked[i] then
    begin
       AddCommaText(S_ParamList,  '  a_'+FPGTable.Fields.FieldByName(cbSPInsert.Items[i]).DDLTypeStr, true);

       AddCommaText(S_Ins, cbSPInsert.Items[i], false);
       AddCommaText(S_InsVal, 'a_'+cbSPInsert.Items[i], false);

       if FPGTable.Fields.FieldByName(cbSPInsert.Items[i]).FieldDescription<>'' then
         S_Comment:=S_Comment + '--$FBM a_' + cbSPInsert.Items[i] +  ' ' + GetFistString(FPGTable.Fields.FieldByName(cbSPInsert.Items[i]).FieldDescription) + LineEnding;

    end;
  end;
  FISql.EditorText:=Format(spBodyIns, [edtSPIName.Text,  //SP Name
                                     S_ParamList,                //SP Parmas list
                                     S_Comment,         //Коментарии к параметрам
                                     MakePKField('f_',true),                //Update PK list

                                     edtTableName.Text, //Insert table name
                                     S_Ins,             //Insert filed names
                                     S_InsVal,           //Insert filed values

                                     MakePKField('', false),                //Update PK list
                                     MakePKField('f_', false),                //Update PK list,
                                     MakePKField('f_', false)
                                    ]);
end;

procedure TfbmCreateProcTableForm.FillFields;
var
  i: Integer;
  F: TDBField;
begin
  cbSPIU.Items.Clear;
  FPGTable.FillFieldList(cbSPIU.Items, ccoLowerCase, false);
  cbSPSelect.Items.Assign(cbSPIU.Items);
  cbSPInsert.Items.Assign(cbSPIU.Items);
  CheckListBox4.Items.Assign(cbSPIU.Items);
  cbSPDelete.Items.Assign(cbSPIU.Items);
  cbSPIU.CheckAll(cbChecked, false, false);
  cbSPSelect.CheckAll(cbChecked, false, false);
  cbSPInsert.CheckAll(cbChecked, false, false);
  CheckListBox4.CheckAll(cbChecked, false, false);

  for i:=0 to cbSPDelete.Items.Count-1 do
  begin
    F:=FPGTable.Fields.FieldByName(cbSPDelete.Items[i]);
    if Assigned(F) then
      cbSPDelete.Checked[i]:=F.FieldPK;
  end;
end;

procedure TfbmCreateProcTableForm.Localize;
begin
  Caption:=sCreateNewprocedure;
  actCompile.Caption:=sCompile;
  Label1.Caption:=sTableName;
  tabIU.Caption:=sInsertOrUpdate;
  tabS.Caption:=sSelect;
  tabI.Caption:=sInsert;
  tabU.Caption:=sUpdate;
  tabD.Caption:=sDelete;
  TabSheet6.Caption:=sGrant;
  Label2.Caption:=sProcedureName;
  Label3.Caption:=sProcedureName;
  Label4.Caption:=sProcedureName;
  Label5.Caption:=sProcedureName;
  Label6.Caption:=sProcedureName;
  fldSelectAll.Caption:=sSelectAll;
  fldDeselectAll.Caption:=sUnselectAll;
  fldInvertSelections.Caption:=sInvertSelections;

  CheckGroup1.Caption:=sObjectTypes;
  CheckGroup1.Items[0]:=sCreateINSERTorUPDATEProcedure;
  CheckGroup1.Items[1]:=sCreateSELECTProcedure;
  CheckGroup1.Items[2]:=sCreateINSERTProcedure;
  CheckGroup1.Items[3]:=sCreateUPDATEProcedure;
  CheckGroup1.Items[4]:=sCreateDELETEProcedure;
  CheckGroup1.Items[5]:=sGrantExecuteTo;
end;

constructor TfbmCreateProcTableForm.CreateEditForm(APGTable: TDBTableObject);

procedure CreatePageEdt(var Ed:Tfdbm_SynEditorFrame; aTab:TTabSheet; const aEdName:string);
begin
  Ed:=Tfdbm_SynEditorFrame.Create(Self);
  Ed.Name:=aEdName;
  Ed.Parent:=aTab;
  Ed.Align:=alClient;
  Ed.SQLEngine:=FPGTable.OwnerDB;
end;

var
  S: String;
begin
  inherited Create(Application);
  Localize;
  PageControl1.ActivePageIndex:=0;
  FPGTable:=APGTable;
  edtTableName.Text:=FPGTable.CaptionFullPatch;

  CreatePageEdt(FIUSql, tabIU, 'FIUSql');
  CreatePageEdt(FISql, tabI, 'FISql');
  CreatePageEdt(FUSql, tabU, 'FUSql');
  CreatePageEdt(FDSql, tabD, 'FDSql');
  CreatePageEdt(FSSql, tabS, 'FSSql');

  if FPGTable.SchemaName<>'' then
    S:=FPGTable.SchemaName + '.';
  edtSPIUName.Text:=S+'sp_'+FPGTable.Caption+'_ins_or_upd';
  edtSPSName.Text:=S+'sp_'+FPGTable.Caption+'_sel';
  edtSPIName.Text:=S+'sp_'+FPGTable.Caption+'_ins';
  edtSPUName.Text:=S+'sp_'+FPGTable.Caption+'_upd';
  edtSPDName.Text:=S+'sp_'+FPGTable.Caption+'_del';
(*
  FAclPAge:=TfbmpgACLEditEditor.CreatePage(Self, nil);
  FAclPAge.Parent:=TabSheet6;
  FAclPAge.Align:=alClient;
  FAclPAge.ACLList:=MakeACLList;
  FAclPAge.DoMetod(epaRefresh);
  *)
  FillFields;

  cbSPIUClickCheck(nil);

  tabS.TabVisible:=false;
  tabI.TabVisible:=false;
  tabU.TabVisible:=false;
  tabD.TabVisible:=false;
  TabSheet6.TabVisible:=false;
end;

end.

