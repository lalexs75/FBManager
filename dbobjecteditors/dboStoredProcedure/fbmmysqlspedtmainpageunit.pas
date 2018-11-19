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

unit fbmMySQLSPEdtMainPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxdbgrid, rxmemds, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, ActnList, Menus, StdCtrls, db, SQLEngineCommonTypesUnit,
  fdmAbstractEditorUnit, mysql_engine, fdbm_SynEditorUnit, fbmToolsUnit,
  SQLEngineAbstractUnit;

type

  { TfbmMySQLSPEdtMainPage }

  TfbmMySQLSPEdtMainPage = class(TEditorPage)
    ActionList1: TActionList;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    dsParamList: TDatasource;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lvAdd: TAction;
    lvDelete: TAction;
    lvDown: TAction;
    lvPrintList: TAction;
    lvUp: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    PageControl1: TPageControl;
    parAdd: TAction;
    parDel: TAction;
    parEdit: TAction;
    parMoveDown: TAction;
    parMoveUp: TAction;
    parPrintList: TAction;
    PopupMenu1: TPopupMenu;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RxDBGrid1: TRxDBGrid;
    rxParamList: TRxMemoryData;
    rxParamListDesc: TStringField;
    rxParamListID: TLongintField;
    rxParamListInOut: TLongintField;
    rxParamListOldParName: TStringField;
    rxParamListOldParType: TStringField;
    rxParamListParName: TStringField;
    rxParamListType: TStringField;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
  private
    //FDBStoredProc:TMySQLProcedure;
    FParamModified:boolean;
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure RefreshObject;
  public
    procedure UpdateEnvOptions;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
  end;

implementation

uses fbmStrConstUnit, mysql_SqlParserUnit;

{$R *.lfm}

{ TfbmMySQLSPEdtMainPage }

procedure TfbmMySQLSPEdtMainPage.UpdateEnvOptions;
begin
//  EditorFrame.ChangeVisualParams;
end;

procedure TfbmMySQLSPEdtMainPage.SynGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
begin

end;

procedure TfbmMySQLSPEdtMainPage.RefreshObject;
var
  F: TDBField;
begin
  EditorFrame.EditorText:=TMySQLProcedure(DBObject).ProcedureBody;

  Label2.Visible:=DBObject is TMySQLFunction;
  ComboBox1.Visible:=DBObject is TMySQLFunction;
  if ComboBox1.Visible then
    DBObject.OwnerDB.FillStdTypesList(ComboBox1.Items);

  ComboBox2.Text:='';
  ComboBox2.Items.Add('CURRENT_USER');

  ComboBox1.Text:='';
  ComboBox3.Text:='';

  TSQLEngineMySQL(DBObject.OwnerDB).UsersRoot.FillListForNames(ComboBox2.Items, true);

  if DBObject.State = sdboEdit then
  begin
    EditorFrame.EditorText:=TMySQLProcedure(DBObject).ProcedureBody;
    Edit1.Enabled:=false;
    Label1.Enabled:=False;
    Edit1.Text:=DBObject.Caption;

    if TMySQLProcedure(DBObject).Security = psDefiner then
      RadioGroup1.ItemIndex:=0
    else
      RadioGroup1.ItemIndex:=1;

    if TMySQLProcedure(DBObject).DetermType = ptNotDeterministic then
      RadioGroup2.ItemIndex:=0
    else
      RadioGroup2.ItemIndex:=1;

    ComboBox2.Text:=TMySQLProcedure(DBObject).Definer;
    ComboBox3.ItemIndex:=ord(TMySQLProcedure(DBObject).SqlAccess);

    rxParamList.CloseOpen;
    for F in TMySQLProcedure(DBObject).FieldsIN do
    begin
      rxParamList.Append;
      rxParamListID.AsInteger:=F.FieldNum;
      rxParamListParName.AsString:=F.FieldName;
      rxParamListType.AsString:=F.FieldTypeName;
      rxParamList.Post;
    end;
    rxParamList.First;

    if ComboBox1.Visible then
      ComboBox1.Text:=TMySQLFunction(DBObject).ResultType.FieldTypeName;
  end
  else
  begin
    Edit1.Text:='';
  end;
end;

function TfbmMySQLSPEdtMainPage.PageName: string;
begin
  Result:=sStoredProcedure;
end;

constructor TfbmMySQLSPEdtMainPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.SQLEngine:=DBObject.OwnerDB;
  EditorFrame.OnGetKeyWordList:=@SynGetKeyWordList;

//  TabSheet3.TabVisible:=TSQLEnginePostgre(ADBStoredProc.OwnerDB).SPEditLazzyMode;
  PageControl1.ActivePageIndex:=Ord(DBObject.State <> sdboCreate);
  RefreshObject;
end;

function TfbmMySQLSPEdtMainPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaAdd, epaEdit, epaDelete, epaRefresh, epaPrint,
                         epaCompile];
end;

function TfbmMySQLSPEdtMainPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
(*  Result:=true;
  case PageAction of
    epaAdd:DoAdd;
    epaEdit:DoEdit;
    epaDelete:DoDelete;
    epaPrint:PrintPage;
    epaRefresh:RefreshObject;
    epaCompile:Result:=Compile;
  else       *)
    Result:=false;
//  end;
end;

procedure TfbmMySQLSPEdtMainPage.Localize;
begin
  inherited Localize;
  TabSheet1.Caption:=sDeclaration;
  TabSheet2.Caption:=sParams;

  if DBObject is TMySQLFunction then
  begin
    Label1.Caption:=sFunctionName;
    RadioGroup2.Caption:=sFunctionName;
  end
  else
  begin
    Label1.Caption:=sProcedureName;
    RadioGroup2.Caption:=sProcedureType;
  end;
  RadioGroup1.Caption:=sSQLSecurity;
  RadioGroup1.Items[0]:=sDefiner;
  RadioGroup1.Items[1]:=sInvoker;
  Label2.Caption:=sReturnType;
  Label3.Caption:=sDefiner;
  Label4.Caption:=sSQLDataAcess;
end;

end.

//Not deterministic
//sql security { definer | invoker }
//definer = { user | current_user }]
