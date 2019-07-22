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

unit fbmInsertDefSqlUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls, CheckLst, SynEdit, SynCompletion, RxIniPropStorage,
  ButtonPanel, SQLEngineCommonTypesUnit, SQLEngineAbstractUnit, sqlObjects,
  ibmanagertypesunit, Menus;

type

  { TfbmInsertDefSqlForm }

  TfbmInsertDefSqlForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckListBox1: TCheckListBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    RxIniPropStorage1: TRxIniPropStorage;
    Splitter1: TSplitter;
    SynEdit1: TSynEdit;
    procedure CheckListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBox1Change(Sender: TObject);
    procedure Label3DblClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private
    FObjRec:TDBObject;
    FSQLEngine:TSQLEngineAbstract;
    SynCompletion:TSynCompletion;
    FMarg:integer;
    FDefMargin:integer;
    procedure DoAllCheck(F:boolean);
    ////
    procedure DoFillFieldEx;
    procedure DoFillField(VarPrf:string);
    procedure DoFillSelectSql;
    procedure DoFillSelectIntoSql;
    procedure DoFillSelectForIntoSql;
    procedure DoFillDeleteSQL;
    procedure DoFillInsertSql;
    procedure DoFillPKList;
    procedure DoFillUpdateSql;
    procedure DoFillDDL;
    procedure Localize;
  public
    function ResultText:string;
    constructor CreateInsertDefSQLForm(const DBObject:TDBObject; const ASQLEngine:TSQLEngineAbstract; const TableAlis: string; const ADefMargin:integer);
  end; 


function ShowInsertSQLDefForm( DBObject:TDBObject;
   const ASQLEngine:TSQLEngineAbstract; const ADefMargin:integer; const TableAlis: string; out SqlStr:string):boolean;
implementation
uses rxAppUtils, fbmToolsUnit, rxstrutils, fbmStrConstUnit, IBManDataInspectorUnit, SQLEngineInternalToolsUnit;

{$R *.lfm}

function ShowInsertSQLDefForm(DBObject: TDBObject;
  const ASQLEngine: TSQLEngineAbstract; const ADefMargin: integer;
  const TableAlis: string; out SqlStr: string): boolean;
var
  fbmInsertDefSqlForm: TfbmInsertDefSqlForm;
begin
  fbmInsertDefSqlForm:=TfbmInsertDefSqlForm.CreateInsertDefSQLForm(DBObject, ASQLEngine, TableAlis, ADefMargin);
  Result:=fbmInsertDefSqlForm.ShowModal = mrOk;
  if Result then
    SqlStr:= fbmInsertDefSqlForm.ResultText
  else
    SqlStr:='';
  fbmInsertDefSqlForm.Free;
end;

{ TfbmInsertDefSqlForm }

procedure TfbmInsertDefSqlForm.ComboBox1Change(Sender: TObject);
var
  ID: Integer;
begin
  SynEdit1.Lines.Clear;
  if (ComboBox1.Items.Count = 0) or (ComboBox1.ItemIndex<0) then Exit;

  if Assigned(Sender) then
    FMarg:=0
  else
    FMarg:=FDefMargin;
  ID:=PtrInt(Pointer(ComboBox1.Items.Objects[ComboBox1.ItemIndex]));
  case ComboBox1.ItemIndex of
    0:DoFillDDL;
    1:DoFillFieldEx;
    2:DoFillSelectSql;
    3:DoFillSelectIntoSql;
    4:DoFillSelectForIntoSql;
    5:DoFillInsertSql;
    6:DoFillUpdateSql;
    7:DoFillDeleteSQL;
    //8:'DECLARE VARIABLE'
    //9:'Name + Type'
  else
    ErrorBox('Unknow SQL type');
    exit;
  end
end;

procedure TfbmInsertDefSqlForm.Label3DblClick(Sender: TObject);
begin
  if Assigned(FObjRec) then
  begin
    Edit2.Text:=FObjRec.Caption;
    ComboBox1Change(Sender);
  end;
end;

procedure TfbmInsertDefSqlForm.MenuItem3Click(Sender: TObject);
begin
  DoAllCheck(TComponent(Sender).Tag = 1);
end;

procedure TfbmInsertDefSqlForm.CheckListBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P:TPoint;
begin
  if Button = mbRight then
  begin
    P.X:=X;
    P.Y:=Y;
    P:=CheckListBox1.ClientToScreen(P);
    PopupMenu1.PopUp(P.X, P.Y);
  end
end;


procedure TfbmInsertDefSqlForm.DoAllCheck(F: boolean);
var
  i:integer;
begin
  for i:=0 to CheckListBox1.Items.Count - 1 do
    CheckListBox1.Checked[i]:=F;
  ComboBox1Change(ComboBox1);
end;

procedure TfbmInsertDefSqlForm.DoFillFieldEx;
begin
  if Edit2.Text<>'' then
    DoFillField(FormatStringCase(Edit2.Text, ccoNoneCase)+'.')
  else
    DoFillField('');
end;

procedure TfbmInsertDefSqlForm.DoFillField(VarPrf: string);
var
  i,j:integer;
begin
  j:=0;
  for i:=0 to CheckListBox1.Items.Count-1 do
  begin
    if CheckListBox1.Checked[i] then
    begin
      SynEdit1.Lines.Add(MS(' ', FMarg)+VarPrf+FormatStringCase(CheckListBox1.Items[i], ccoNoneCase)+',');
      j:=SynEdit1.Lines.Count;
    end;
  end;

  if j>0 then
     SynEdit1.Lines[j-1]:=Copy(SynEdit1.Lines[j-1], 1, Length(SynEdit1.Lines[j-1])-1);
end;

procedure TfbmInsertDefSqlForm.DoFillSelectSql;
begin
  SynEdit1.Lines.Add(MS(' ', FMarg) + FormatStringCase('select', TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0))));
  Inc(FMarg, 2);
  if Edit2.Text<>'' then
    DoFillField(FormatStringCase(Edit2.Text, ccoNoneCase)+'.')
  else
    DoFillField('');
  Dec(FMarg, 2);
  SynEdit1.Lines.Add(MS(' ', FMarg) + FormatStringCase('from', TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0))));
  SynEdit1.Lines.Add(MS(' ', FMarg+2) + Edit1.Text+' '+Edit2.Text);
end;

procedure TfbmInsertDefSqlForm.DoFillSelectIntoSql;
begin
  DoFillSelectSql;
  SynEdit1.Lines.Add(MS(' ', FMarg) + FormatStringCase('into', TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0))));
  Inc(FMarg, 2);
  DoFillField(FSQLEngine.MiscOptions.VarPrefix + Edit3.Text);
  Dec(FMarg, 2);
end;

procedure TfbmInsertDefSqlForm.DoFillSelectForIntoSql;
begin
  SynEdit1.Lines.Add(MS(' ', FMarg) + FormatStringCase('for', TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0))));
  inc(FMarg, 2);
  DoFillSelectIntoSql;
  Dec(FMarg, 2);
  SynEdit1.Lines.Add(MS(' ', FMarg) + FormatStringCase('do', TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0))));
  SynEdit1.Lines.Add(MS(' ', FMarg) + FormatStringCase('begin', TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0))));
  SynEdit1.Lines.Add(MS(' ', FMarg) + '');
  SynEdit1.Lines.Add(MS(' ', FMarg) + FormatStringCase('end', TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseKeyword', 0))));
end;

procedure TfbmInsertDefSqlForm.DoFillDeleteSQL;
begin
  SynEdit1.Lines.Add(MS(' ', FMarg) + 'delete');
  SynEdit1.Lines.Add(MS(' ', FMarg) + 'from');
  inc(FMarg, 2);
  SynEdit1.Lines.Add(MS(' ', FMarg+2) + FObjRec.CaptionFullPatch);
  Dec(FMarg, 2);
  if (FObjRec is TDBTableObject) and ((FObjRec as TDBTableObject).ConstraintCount > 0) then
  begin
    SynEdit1.Lines.Add(MS(' ', FMarg) + 'where');
    DoFillPKList;
  end;
end;

procedure TfbmInsertDefSqlForm.DoFillInsertSql;

function MakeFieldLine(const VarPrf:string):string;
var
  i:Integer;
begin
  Result:='';
  for i:=0 to CheckListBox1.Items.Count-1 do
  begin
    if CheckListBox1.Checked[i] then
      Result:=Result +', '+ VarPrf+CheckListBox1.Items[i];
  end;
  if Result<>'' then
    Result:=Copy(Result, 3, Length(Result));
end;

begin
  SynEdit1.Lines.Add(MS(' ', FMarg) + 'insert into '+FObjRec.CaptionFullPatch);
  Inc(FMarg, 2);
  SynEdit1.Lines.Add(MS(' ', FMarg) + '(' + MakeFieldLine('') + ')');
  Dec(FMarg, 2);

  SynEdit1.Lines.Add(MS(' ', FMarg) + 'values');

  Inc(FMarg, 2);
  SynEdit1.Lines.Add(MS(' ', FMarg) + '(' + MakeFieldLine(FSQLEngine.MiscOptions.VarPrefix+Edit3.Text) + ')');
  Dec(FMarg, 2);
end;

procedure TfbmInsertDefSqlForm.DoFillPKList;
var
  i:integer;
  AliasStr:string;
  C:TPrimaryKeyRecord;
  DS:TDBTableObject;
begin
  C:=nil;
  DS:=TDBTableObject(FObjRec);
  for i:=0 to DS.ConstraintCount-1 do
  begin
    C:=DS.Constraint[i];
    if C.ConstraintType = ctPrimaryKey then
      break;
  end;
  if (C = nil) then
    exit;

  if Edit2.Text <> '' then
    AliasStr:=Edit2.Text+'.'
  else
    AliasStr:='';

  if C.FieldList<>'' then
  begin
    for i:=0 to C.CountFields-1 do
    begin
      if i>0 then
        SynEdit1.Lines.Add(MS(' ', FMarg+2) + 'and');
      SynEdit1.Lines.Add(MS(' ', FMarg+2 + 2 * ord(C.CountFields>1)) + '(' + AliasStr+ C.FieldByNum(i)+' = '+FSQLEngine.MiscOptions.VarPrefix+Edit3.Text+C.FieldByNum(i)+ ')');
    end;
  end;
end;

procedure TfbmInsertDefSqlForm.DoFillUpdateSql;

procedure DoMakeFieldList(const VarPrf:string);
var
  i:Integer;
  S:string;
begin
  S:='';
  Inc(FMarg, 2);
  for i:=0 to CheckListBox1.Items.Count-1 do
  begin
    if CheckListBox1.Checked[i] then
    begin
      if S<>'' then
        S:=S+','+LineEnding;
      S:=S + MS(' ', FMarg) + CheckListBox1.Items[i] + ' = '+ VarPrf+CheckListBox1.Items[i];
    end;
  end;
  Dec(FMarg, 2);
  SynEdit1.Lines.Text:=SynEdit1.Lines.Text + S;
end;

begin
  SynEdit1.Lines.Add(MS(' ', FMarg) + 'update');
  Inc(FMarg, 2);
  SynEdit1.Lines.Add(MS(' ', FMarg) + FObjRec.CaptionFullPatch);
  Dec(FMarg, 2);
  SynEdit1.Lines.Add(MS(' ', FMarg) + 'set');
  DoMakeFieldList(FSQLEngine.MiscOptions.VarPrefix+Edit3.Text);

  if (FObjRec is TDBTableObject) and ((FObjRec as TDBTableObject).ConstraintCount > 0) then
  begin
    SynEdit1.Lines.Add(MS(' ', FMarg) + 'where');
    DoFillPKList;
  end;
end;

procedure TfbmInsertDefSqlForm.DoFillDDL;
begin
  SynEdit1.Lines.Text:=FObjRec.DDLCreate;
end;

procedure TfbmInsertDefSqlForm.Localize;
begin
  Caption:=sMakeDefSQLText;
  Label1.Caption:=sObjectName;
  Label2.Caption:=sStatament;
  Label3.Caption:=sAlias;
  Label4.Caption:=sVarPrefix;
  GroupBox1.Caption:=sFieldsParametersList;
end;

function TfbmInsertDefSqlForm.ResultText: string;
begin
  if Assigned(FObjRec) then
  begin
    ComboBox1Change(nil);
    Result:=SynEdit1.Text
  end
  else
    Result:='';
end;

constructor TfbmInsertDefSqlForm.CreateInsertDefSQLForm(
  const DBObject: TDBObject; const ASQLEngine: TSQLEngineAbstract;
  const TableAlis: string; const ADefMargin: integer);
begin
  inherited Create(Application);
  CheckListBox1.Items.Clear;

  if ADefMargin<0 then
    FDefMargin:=0
  else
    FDefMargin:=ADefMargin;

  Localize;
  //SynEdit1.Highlighter:=TDataBaseRecord(ASQLEngine.InspectorRecord).SynSQLSyn;
  SynEdit1.Highlighter:=fbManDataInpectorForm.DBBySQLEngine(ASQLEngine).SynSQLSyn;

  Edit1.Text:=DBObject.CaptionFullPatch;// AObjectName;
  FSQLEngine:=ASQLEngine;
  FObjRec:=DBObject; //FDBRec.GetDBObject(AObjectName);
  if Assigned(FObjRec) then
  begin
    Edit2.Text:=TableAlis;
    ComboBox1.Items.Clear;
    FObjRec.MakeSQLStatementsList(ComboBox1.Items);

    if FObjRec.DBObjectKind in [okTable, okView, okStoredProc, okFunction] then
      FObjRec.FillFieldList(CheckListBox1.Items, ccoNoneCase, false);

    SynCompletion:=TSynCompletion.Create(Self);
    SynCompletion.AddEditor(SynEdit1);

    SetEditorOptions(SynEdit1);

    DoAllCheck(true);
    if ComboBox1.Items.Count>1 then
      ComboBox1.ItemIndex:=1
    else
    if ComboBox1.Items.Count>0 then
      ComboBox1.ItemIndex:=0;

    ComboBox1Change(ComboBox1);
    if ConfigValues.ByNameAsBoolean('Use_table_name_as_alis_in_create_SQL_form', true) and (TableAlis = '') then
      Label3DblClick(Label3);
  end
  else
  begin
    ComboBox1.Enabled:=false;
    Edit2.Enabled:=false;
    Edit3.Enabled:=false;
  end;
end;


end.

