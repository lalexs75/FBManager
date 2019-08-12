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

unit fbmpgACLEditUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LMessages,
  ActnList, ExtCtrls, StdCtrls, db, rxtoolbar, rxmemds, rxdbgrid,
  RxDBGridPrintGrid, LR_PGrid, fdmAbstractEditorUnit, SQLEngineAbstractUnit,
  fbmToolsUnit, pgTypes, DBGrids, Menus;

type

  { TfbmpgACLEditEditor }

  TfbmpgACLEditEditor = class(TEditorPage)
    grVL: TAction;
    grHL: TAction;
    grALL: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu1: TPopupMenu;
    revVL: TAction;
    revHL: TAction;
    revALL: TAction;
    edtPrint: TAction;
    ActionList1: TActionList;
    ComboBox1: TComboBox;
    dsUGList: TDatasource;
    Label1: TLabel;
    Panel1: TPanel;
    RxDBGrid1: TRxDBGrid;
    RxDBGridPrint1: TRxDBGridPrint;
    rxUGList: TRxMemoryData;
    rxUGListogAlter: TBooleanField;
    rxUGListogAlterRoutine: TBooleanField;
    rxUGListogConnect: TBooleanField;
    rxUGListogCreate: TBooleanField;
    rxUGListogCreateRoutine: TBooleanField;
    rxUGListogCreateTablespace: TBooleanField;
    rxUGListogCreateUser: TBooleanField;
    rxUGListogCreateView: TBooleanField;
    rxUGListogDelete: TBooleanField;
    rxUGListogDrop: TBooleanField;
    rxUGListogEvent: TBooleanField;
    rxUGListogExecute: TBooleanField;
    rxUGListogFile: TBooleanField;
    rxUGListogIndex: TBooleanField;
    rxUGListogInsert: TBooleanField;
    rxUGListogLockTables: TBooleanField;
    rxUGListogMembership: TBooleanField;
    rxUGListogProcess: TBooleanField;
    rxUGListogProxy: TBooleanField;
    rxUGListogReference: TBooleanField;
    rxUGListogReload: TBooleanField;
    rxUGListogReplicationClient: TBooleanField;
    rxUGListogReplicationSlave: TBooleanField;
    rxUGListogRule: TBooleanField;
    rxUGListogSelect: TBooleanField;
    rxUGListogShowDatabases: TBooleanField;
    rxUGListogShowView: TBooleanField;
    rxUGListogShutdown: TBooleanField;
    rxUGListogSuper: TBooleanField;
    rxUGListogTemporary: TBooleanField;
    rxUGListogTrigger: TBooleanField;
    rxUGListogTruncate: TBooleanField;
    rxUGListogUpdate: TBooleanField;
    rxUGListogUsage: TBooleanField;
    rxUGListogWGO: TBooleanField;
    rxUGListOWNER_USER: TStringField;
    rxUGListUG_NAME: TStringField;
    rxUGListUG_TYPE: TLongintField;
    ToolPanel1: TToolPanel;
    procedure ComboBox1Change(Sender: TObject);
    procedure edtPrintExecute(Sender: TObject);
    procedure grALLExecute(Sender: TObject);
    procedure grHLExecute(Sender: TObject);
    procedure grVLExecute(Sender: TObject);
    procedure rxUGListAfterPost(DataSet: TDataSet);
    procedure rxUGListFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    FACLList:TACLListAbstract;
    FLockCount:integer;
    FOneLine:boolean;
    procedure LockPost;
    procedure SetACLList(AValue: TACLListAbstract);
    procedure UnLockPost;
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure ChangeVisualParams;
    procedure PrintPage;
    procedure LoadObjACLList;
    procedure DoSetGrLine(E:boolean);
    procedure DoSetGrAll(E:boolean; AllColumns:boolean);
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    property ACLList:TACLListAbstract read FACLList write SetACLList;
  end;

implementation
uses fbmStrConstUnit, SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TfbmpgACLEditEditor }

procedure TfbmpgACLEditEditor.edtPrintExecute(Sender: TObject);
begin
  RxDBGridPrint1.PreviewReport;
end;

procedure TfbmpgACLEditEditor.grALLExecute(Sender: TObject);
begin
  LockPost;
  DoSetGrAll((Sender as TComponent).Tag = 1, true);
  UnLockPost;
end;


procedure TfbmpgACLEditEditor.grHLExecute(Sender: TObject);
var
  P: TBookMark;
begin
  LockPost;
  if RxDBGrid1.SelectedRows.Count>1 then
  begin
    for P in RxDBGrid1.SelectedRows do
    begin
      rxUGList.Bookmark:=P;
      DoSetGrLine((Sender as TComponent).Tag = 1);
    end;
  end
  else
    DoSetGrLine((Sender as TComponent).Tag = 1);
  UnLockPost;
end;

procedure TfbmpgACLEditEditor.grVLExecute(Sender: TObject);
begin
  LockPost;
  if RxDBGrid1.SelectedField.DataType <> ftBoolean then exit;
  DoSetGrAll((Sender as TComponent).Tag = 1, false);
  UnLockPost;
end;

procedure TfbmpgACLEditEditor.rxUGListAfterPost(DataSet: TDataSet);
var
  P:TACLItem;
  OG: TObjectGrants;
  G: TObjectGrant;
  F: TField;
begin
  LockPost;
  P:=FACLList.FindACLItem(rxUGListUG_NAME.AsString);
  if Assigned(P) then
  begin
    P.UserName      := rxUGListUG_NAME.AsString;
    P.UserType      := rxUGListUG_TYPE.AsInteger;
    P.GrantOwnUser  := rxUGListOWNER_USER.AsString;

    OG:=P.Grants;
    for G in TObjectGrant do
    begin
      if G<>ogAll then
      begin
        F:=rxUGList.FieldByName(ObjectGrantNamesReal[G]);
        if Assigned(F) and F.AsBoolean then
          OG:=OG + [G]
        else
          OG:=OG - [G];
      end;
    end;

    if (ogWGO in OG) and not (ogWGO in P.GrantsOld) then
    begin
      for G in OG do
        P.GrantsOld:=P.GrantsOld - [G];
    end;

    P.Grants:=OG;

  end;
  UnLockPost;
end;

procedure TfbmpgACLEditEditor.rxUGListFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept:=rxUGListUG_TYPE.AsInteger=ComboBox1.ItemIndex;
end;

procedure TfbmpgACLEditEditor.LockPost;
begin
  inc(FLockCount)
end;

procedure TfbmpgACLEditEditor.SetACLList(AValue: TACLListAbstract);
var
  G: TObjectGrant;
begin
  if FACLList=AValue then Exit;

  FACLList:=AValue;
  for G in TObjectGrant do
    if G<>ogAll then
      RxDBGrid1.ColumnByFieldName(ObjectGrantNamesReal[G]).Visible:=Assigned(FACLList) and (G in FACLList.ObjectGrants);
end;

procedure TfbmpgACLEditEditor.UnLockPost;

procedure DoApplyGrants;
var
  P:TACLItem;
begin
  if FOneLine then
  begin
    P:=FACLList.FindACLItem(rxUGListUG_NAME.AsString);
    FACLList.ApplyACLList(P);
  end
  else
    FACLList.ApplyACLList(nil);
end;

begin
  Dec(FLockCount);
  if (FLockCount = 0) and Assigned(DBObject) then
  begin
    DoApplyGrants;
    FOneLine:=true;
    LoadObjACLList;
  end;
end;

procedure TfbmpgACLEditEditor.ComboBox1Change(Sender: TObject);
begin
  rxUGList.Filtered:=ComboBox1.ItemIndex<>0;
  rxUGList.First;
end;

procedure TfbmpgACLEditEditor.LMEditorChangeParams(var message: TLMNoParams);
begin

end;

procedure TfbmpgACLEditEditor.ChangeVisualParams;
begin

end;

procedure TfbmpgACLEditEditor.PrintPage;
begin

end;

procedure TfbmpgACLEditEditor.LoadObjACLList;
var
  P: TACLItem;
  G: TObjectGrant;
  FUserName: String;
begin
  if not Assigned(FACLList) then exit;
  FLockCount:=0;

  if rxUGList.Active and (rxUGList.RecordCount>0) then
    FUserName:=rxUGListUG_NAME.AsString
  else
    FUserName:='';


  rxUGList.AfterPost:=nil;
  rxUGList.DisableControls;
  FACLList.DBObject.RefreshObject;
  FACLList.RefreshList;

  rxUGList.CloseOpen;
  rxUGList.Filtered:=false;
  for P in FACLList do
  begin
    rxUGList.Append;
    rxUGListUG_NAME.AsString:=P.UserName;
    rxUGListUG_TYPE.AsInteger:=P.UserType;
    rxUGListOWNER_USER.AsString:=P.GrantOwnUser;

    for G in FACLList.ObjectGrants do
      rxUGList.FieldByName(ObjectGrantNamesReal[G]).AsBoolean:=G in P.Grants;
    rxUGList.Post;
  end;

  rxUGList.AfterPost:=@rxUGListAfterPost;
  rxUGList.EnableControls;

  ComboBox1Change(nil);

  if FUserName<>'' then
    rxUGList.Locate('UG_NAME', FUserName, [])
  else
    rxUGList.First;

end;

procedure TfbmpgACLEditEditor.DoSetGrLine(E: boolean);
var
  G: TObjectGrant;
begin
  if not Assigned(FACLList) then Exit;
  LockPost;
  rxUGList.Edit;
  for G in FACLList.ObjectGrants do
  begin
    if (G<>ogWGO) or (ConfigValues.ByNameAsBoolean('Grant editor/EnableSetWGOFromPopup', false)) then
      rxUGList.FieldByName(ObjectGrantNamesReal[G]).AsBoolean:=E;
  end;
  rxUGList.Post;
  UnLockPost;
end;

procedure TfbmpgACLEditEditor.DoSetGrAll(E: boolean; AllColumns:boolean);
var
  P:TBookmark;
begin
  LockPost;
  {$IFDEF NoAutomatedBookmark}
  P:=rxUGList.GetBookmark;
  {$ELSE}
  P:=rxUGList.Bookmark;
  {$ENDIF}

  rxUGList.DisableControls;
  try
    rxUGList.First;
    while not rxUGList.EOF do
    begin
      if AllColumns then
        DoSetGrLine(E)
      else
      begin
        rxUGList.Edit;
        RxDBGrid1.SelectedField.AsBoolean:=E;
        rxUGList.Post;
      end;
      rxUGList.Next;
    end;
  finally
    {$IFDEF NoAutomatedBookmark}
    rxUGList.GotoBookmark(P);
    rxUGList.FreeBookmark(P);
    {$ELSE}
    rxUGList.Bookmark:=P;
    {$ENDIF}

    rxUGList.EnableControls;
  end;
  FOneLine:=false;
  UnLockPost;
end;

function TfbmpgACLEditEditor.PageName: string;
begin
  Result:=sRoleGrantForObjects;;
end;

constructor TfbmpgACLEditEditor.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  if Assigned(ADBObject) then
    ACLList:=ADBObject.ACLList;
  //ComboBox1.ItemIndex:=ConfigValues.ByNameAsInteger('ACL_List_User_Roles_Style', 0);
  ComboBox1.ItemIndex:=ConfigValues.ByNameAsInteger(DBObject.OwnerDB.ClassName + '\Initial ACL page', 0);
end;

procedure TfbmpgACLEditEditor.Activate;
begin
  LoadObjACLList;
end;

function TfbmpgACLEditEditor.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh];
end;

function TfbmpgACLEditEditor.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:edtPrint.Execute;
    epaRefresh:LoadObjACLList;
  end;
end;

procedure TfbmpgACLEditEditor.Localize;
begin
  inherited Localize;
  Caption:=sACLEdit;
  Label1.Caption:=sUsersGroups;
  edtPrint.Caption:=sPrint;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(sUsersAndGroups);
  ComboBox1.Items.Add(sOnlyUsers);
  ComboBox1.Items.Add(sOnlyGroups);

  RxDBGrid1.ColumnByFieldName('UG_NAME').Title.Caption:=sNameUserRole;
  RxDBGrid1.ColumnByFieldName('OWNER_USER').Title.Caption:=sGrantOwnUser;

  RxDBGrid1.ColumnByFieldName('ogSelect').Title.Caption:=sSelect;
  RxDBGrid1.ColumnByFieldName('ogInsert').Title.Caption:=sInsert;
  RxDBGrid1.ColumnByFieldName('ogUpdate').Title.Caption:=sUpdate;
  RxDBGrid1.ColumnByFieldName('ogDelete').Title.Caption:=sDelete;
  RxDBGrid1.ColumnByFieldName('ogExecute').Title.Caption:=sExecute;
  RxDBGrid1.ColumnByFieldName('ogReference').Title.Caption:=sReferences;
  RxDBGrid1.ColumnByFieldName('ogCreate').Title.Caption:=sCreate;
  RxDBGrid1.ColumnByFieldName('ogRule').Title.Caption:=sRule;
  RxDBGrid1.ColumnByFieldName('ogTemporary').Title.Caption:=sTemporary;
  RxDBGrid1.ColumnByFieldName('ogTruncate').Title.Caption:=sTruncate;
  RxDBGrid1.ColumnByFieldName('ogTrigger').Title.Caption:=sTrigger;
  RxDBGrid1.ColumnByFieldName('ogUsage').Title.Caption:=sUsage;
  RxDBGrid1.ColumnByFieldName('ogWGO').Title.Caption:=sWithGrantOptions;
  RxDBGrid1.ColumnByFieldName('ogConnect').Title.Caption:=sConnect;
  //ogAll
  RxDBGrid1.ColumnByFieldName('ogAlter').Title.Caption:=sAlter;
  RxDBGrid1.ColumnByFieldName('ogAlterRoutine').Title.Caption:=sAlterRroutine;
  RxDBGrid1.ColumnByFieldName('ogCreateRoutine').Title.Caption:=sCreateRoutine;
  RxDBGrid1.ColumnByFieldName('ogCreateTablespace').Title.Caption:=sCreateTablespace;
  RxDBGrid1.ColumnByFieldName('ogCreateUser').Title.Caption:=sCreateUser;
  RxDBGrid1.ColumnByFieldName('ogCreateView').Title.Caption:=sCreateView;
  RxDBGrid1.ColumnByFieldName('ogDrop').Title.Caption:=sDrop;
  RxDBGrid1.ColumnByFieldName('ogEvent').Title.Caption:=sEvent;
  RxDBGrid1.ColumnByFieldName('ogFile').Title.Caption:=sFile;
  RxDBGrid1.ColumnByFieldName('ogIndex').Title.Caption:=sIndex;
  RxDBGrid1.ColumnByFieldName('ogLockTables').Title.Caption:=sLockTables;
  RxDBGrid1.ColumnByFieldName('ogProcess').Title.Caption:=sProcess;
  RxDBGrid1.ColumnByFieldName('ogProxy').Title.Caption:=sProxy;
  RxDBGrid1.ColumnByFieldName('ogReload').Title.Caption:=sReload;
  RxDBGrid1.ColumnByFieldName('ogReplicationClient').Title.Caption:=sReplClient;
  RxDBGrid1.ColumnByFieldName('ogReplicationSlave').Title.Caption:=sReplSlave;
  RxDBGrid1.ColumnByFieldName('ogShowDatabases').Title.Caption:=sShowDB;
  RxDBGrid1.ColumnByFieldName('ogShowView').Title.Caption:=sShowView;
  RxDBGrid1.ColumnByFieldName('ogShutdown').Title.Caption:=sShutdown;
  RxDBGrid1.ColumnByFieldName('ogSuper').Title.Caption:=sSuper;
  RxDBGrid1.ColumnByFieldName('ogMembership').Title.Caption:=sMembership;

  { TODO : Доработать локализацию }
{  grVL
  grHL
  grALL
  revVL
  revHL
  revALL }
end;

end.

