unit fbmUserObjectsGrantUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList,
  DBGrids, ExtCtrls, StdCtrls, rxmemds, rxdbgrid, RxDBGridPrintGrid, rxtoolbar,
  DB, sqlObjects, fdmAbstractEditorUnit, SQLEngineCommonTypesUnit, SQLEngineAbstractUnit,
  fbmToolsUnit;

type
  TRoDBObjTypes = array [TDBObjectKind] of TObjectGrants;

  { TfbmUserObjectsGrantFrame }

  TfbmUserObjectsGrantFrame = class(TEditorPage)
    ActionList1: TActionList;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    dsUGList: TDataSource;
    Edit1: TEdit;
    edtPrint: TAction;
    grALL: TAction;
    grHL: TAction;
    grVL: TAction;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    revALL: TAction;
    revHL: TAction;
    revVL: TAction;
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
    rxUGListUG_EMPTY: TBooleanField;
    rxUGListUG_NAME: TStringField;
    rxUGListUG_TYPE: TLongintField;
    ToolPanel1: TToolPanel;
    procedure Edit1Change(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure RxDBGrid1GetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
    procedure rxUGListAfterPost(DataSet: TDataSet);
    procedure rxUGListAfterScroll(DataSet: TDataSet);
    procedure rxUGListFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    FAllGrants: TObjectGrants;

    FrxCol_UG_TYPE:TRxColumn;
    FrxCol_UG_NAME:TRxColumn;
    FrxCol_OWNER_USER:TRxColumn;
    FrxCol_Select:TRxColumn;
    FrxCol_Insert:TRxColumn;
    FrxCol_Update:TRxColumn;
    FrxCol_Delete:TRxColumn;
    FrxCol_Execute:TRxColumn;
    FrxCol_Reference:TRxColumn;
    FrxCol_Create:TRxColumn;
    FrxCol_Rule:TRxColumn;
    FrxCol_Temporary:TRxColumn;
    FrxCol_Truncate:TRxColumn;
    FrxCol_Trigger:TRxColumn;
    FrxCol_Usage:TRxColumn;
    FrxCol_WGO:TRxColumn;
    FrxCol_Connect:TRxColumn;
    FrxCol_Alter:TRxColumn;
    FrxCol_AlterRoutine:TRxColumn;
    FrxCol_CreateRoutine:TRxColumn;
    FrxCol_CreateTablespace:TRxColumn;
    FrxCol_CreateUser:TRxColumn;
    FrxCol_CreateView:TRxColumn;
    FrxCol_Drop:TRxColumn;
    FrxCol_Event:TRxColumn;
    FrxCol_File:TRxColumn;
    FrxCol_Index:TRxColumn;
    FrxCol_LockTables:TRxColumn;
    FrxCol_Process:TRxColumn;
    FrxCol_Proxy:TRxColumn;
    FrxCol_Reload:TRxColumn;
    FrxCol_ReplicationClient:TRxColumn;
    FrxCol_ReplicationSlave:TRxColumn;
    FrxCol_ShowDatabases:TRxColumn;
    FrxCol_ShowView:TRxColumn;
    FrxCol_Shutdown:TRxColumn;
    FrxCol_Super:TRxColumn;
    FrxCol_Membership:TRxColumn;

    FLockCount:integer;
    FOneLine:boolean;
    FACLItems:TList;

    FRoDBObjTypes:TRoDBObjTypes;
    procedure RefreshPage;
    procedure BindRxDBGridCollumn;
    procedure UpdateFilter;
    procedure LockPost;
    procedure UnLockPost;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    destructor Destroy; override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, IBManDataInspectorUnit, LazUTF8;

{$R *.lfm}

{ TfbmUserObjectsGrantFrame }

procedure TfbmUserObjectsGrantFrame.rxUGListAfterScroll(DataSet: TDataSet);
var
  R: TColumn;
  FG: TObjectGrant;
begin
  for FG in FAllGrants do
  begin
    R:=RxDBGrid1.ColumnByFieldName(ObjectGrantNamesReal[FG]);
    if Assigned(R) then
      R.ReadOnly:=not (FG in FRoDBObjTypes[TDBObjectKind(rxUGListUG_TYPE.AsInteger)]);
  end;
end;

procedure TfbmUserObjectsGrantFrame.rxUGListFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  S: string;
begin
  S:=UTF8UpperCase(Trim(Edit1.Text));
  if (S<>'') then
    Accept:=UTF8Pos(S, UTF8UpperCase(rxUGListUG_NAME.AsString)) > 0;

  if Accept and (ComboBox1.ItemIndex>0) then
    Accept:=rxUGListUG_TYPE.AsInteger = PtrInt(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);

  if Accept and (ComboBox2.ItemIndex>0) then
    Accept:=rxUGListUG_EMPTY.AsBoolean = (ComboBox2.ItemIndex = 2);
end;

procedure TfbmUserObjectsGrantFrame.RxDBGrid1GetCellProps(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor);
begin
  if (Field.Tag <> 0) and (not (TObjectGrant(Field.Tag) in FRoDBObjTypes[TDBObjectKind(rxUGListUG_TYPE.AsInteger)])) then
    Background:=clTeal;
end;

procedure TfbmUserObjectsGrantFrame.Edit1Change(Sender: TObject);
begin
  UpdateFilter;
end;

procedure TfbmUserObjectsGrantFrame.RxDBGrid1DblClick(Sender: TObject);
begin
  if rxUGList.Active and (rxUGList.RecordCount > 0) then
  begin
    if RxDBGrid1.SelectedColumn = FrxCol_UG_NAME then
      fbManDataInpectorForm.EditObject(DBObject.OwnerDB.DBObjectByName(rxUGListUG_NAME.AsString));
  end;
end;

procedure TfbmUserObjectsGrantFrame.rxUGListAfterPost(DataSet: TDataSet);
var
  D: TDBObject;
  P: TACLItem;
  OG: TObjectGrants;
  G: TObjectGrant;
  F: TField;
begin
  LockPost;
  D:=DBObject.OwnerDB.DBObjectByName(rxUGListUG_NAME.AsString);
  if not Assigned(D.ACLList) then Exit;
  P:=D.ACLList.FindACLItem(DBObject.Caption);
  if Assigned(P) then
  begin
    P.UserName      := DBObject.Caption;
    if DBObject.DBObjectKind = okUser then
      P.UserType:=1
    else
      P.UserType:=2;
    P.GrantOwnUser  := DBObject.OwnerDB.UserName;

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

    if FACLItems.IndexOf(P)<0 then
      FACLItems.Add(P);
  end;
  UnLockPost;
end;

procedure TfbmUserObjectsGrantFrame.RefreshPage;
function DoAddRow(D:TDBObject):boolean;
var
  FG: TObjectGrant;
  F: TField;
  P: TACLItem;
  GL: TObjectGrants;
  S: String;
begin
  if not Assigned(D.ACLList) then Exit(false);

  FAllGrants:=FAllGrants + D.ACLList.ObjectGrants;
  rxUGList.Append;
  rxUGListUG_TYPE.AsInteger:=Ord(D.DBObjectKind);
  rxUGListUG_NAME.AsString:=D.CaptionFullPatch;

  FRoDBObjTypes[D.DBObjectKind]:=D.ACLList.ObjectGrants;

  D.ACLList.RefreshList;
  P:=D.ACLList.FindACLItem(DBObject.Caption);
  if Assigned(P) then
  begin
    GL:=P.Grants;
    if GL <> [] then
    begin
      for F in rxUGList.Fields do
        if F.Tag <> 0 then
          F.AsBoolean:=TObjectGrant(F.Tag) in GL;
    end
    else
      rxUGListUG_EMPTY.AsBoolean:=true;
    rxUGListOWNER_USER.AsString:=P.GrantOwnUser;
  end
  else
    rxUGListUG_EMPTY.AsBoolean:=true;

  rxUGList.Post;
  Result:=true;
end;

procedure DoAdd(Grp: TDBRootObject);
var
  i: Integer;
begin
  DoAddRow(Grp);
  for i:=0 to Grp.CountGroups -1 do
    DoAdd(Grp.Groups[i]);

  for i:=0 to Grp.CountObject-1 do
    if not DoAddRow(Grp.Items[i]) then break;
end;

var
  E: TSQLEngineAbstract;
  G: TDBObject;
  FG: TObjectGrant;
  R: TRxColumn;
  S: String;
begin
  ComboBox1.OnChange:=nil;
  FAllGrants:=[];

  E:=DBObject.OwnerDB;
  rxUGList.CloseOpen;
  rxUGList.DisableControls;
  rxUGList.AfterPost:=nil;
  for G in E.Groups do
    if G is TDBRootObject then
      DoAdd(TDBRootObject(G));


  for FG in TObjectGrant do
  begin
    R:=RxDBGrid1.ColumnByFieldName(ObjectGrantNamesReal[FG]);
    if Assigned(R) then
      R.Visible:=FG in FAllGrants;
  end;

  rxUGList.SortOnFields('UG_TYPE;UG_NAME');

  //fill filter combo box
  FrxCol_UG_TYPE.KeyList.Clear;
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add(sAllOobjects);
  rxUGList.First;
  while not rxUGList.EOF do
  begin
    S:=DBObjectKindNames[TDBObjectKind(rxUGListUG_TYPE.AsInteger)];
    if ComboBox1.Items.IndexOf(S)<0 then
    begin
      ComboBox1.Items.AddObject(S, TObject(IntPtr(rxUGListUG_TYPE.AsInteger)));
      FrxCol_UG_TYPE.KeyList.Add(rxUGListUG_TYPE.AsString + '=' + IntToStr(DBObjectKindImages[TDBObjectKind(rxUGListUG_TYPE.AsInteger)]));
    end;
    rxUGList.Next;
  end;

  rxUGList.First;
  rxUGList.EnableControls;
  ComboBox1.ItemIndex:=0;
  ComboBox1.OnChange:=@Edit1Change;
  rxUGList.AfterPost:=@rxUGListAfterPost;
end;

procedure TfbmUserObjectsGrantFrame.BindRxDBGridCollumn;
var
  FG: TObjectGrant;
  F: TField;
begin
  FrxCol_UG_TYPE:=RxDBGrid1.ColumnByFieldName('UG_TYPE');
  FrxCol_UG_NAME:=RxDBGrid1.ColumnByFieldName('UG_NAME');
  FrxCol_OWNER_USER:=RxDBGrid1.ColumnByFieldName('OWNER_USER');
  FrxCol_Select:=RxDBGrid1.ColumnByFieldName('ogSelect');
  FrxCol_Insert:=RxDBGrid1.ColumnByFieldName('ogInsert');
  FrxCol_Update:=RxDBGrid1.ColumnByFieldName('ogUpdate');
  FrxCol_Delete:=RxDBGrid1.ColumnByFieldName('ogDelete');
  FrxCol_Execute:=RxDBGrid1.ColumnByFieldName('ogExecute');
  FrxCol_Reference:=RxDBGrid1.ColumnByFieldName('ogReference');
  FrxCol_Create:=RxDBGrid1.ColumnByFieldName('ogCreate');
  FrxCol_Rule:=RxDBGrid1.ColumnByFieldName('ogRule');
  FrxCol_Temporary:=RxDBGrid1.ColumnByFieldName('ogTemporary');
  FrxCol_Truncate:=RxDBGrid1.ColumnByFieldName('ogTruncate');
  FrxCol_Trigger:=RxDBGrid1.ColumnByFieldName('ogTrigger');
  FrxCol_Usage:=RxDBGrid1.ColumnByFieldName('ogUsage');
  FrxCol_WGO:=RxDBGrid1.ColumnByFieldName('ogWGO');
  FrxCol_Connect:=RxDBGrid1.ColumnByFieldName('ogConnect');
  FrxCol_Alter:=RxDBGrid1.ColumnByFieldName('ogAlter');
  FrxCol_AlterRoutine:=RxDBGrid1.ColumnByFieldName('ogAlterRoutine');
  FrxCol_CreateRoutine:=RxDBGrid1.ColumnByFieldName('ogCreateRoutine');
  FrxCol_CreateTablespace:=RxDBGrid1.ColumnByFieldName('ogCreateTablespace');
  FrxCol_CreateUser:=RxDBGrid1.ColumnByFieldName('ogCreateUser');
  FrxCol_CreateView:=RxDBGrid1.ColumnByFieldName('ogCreateView');
  FrxCol_Drop:=RxDBGrid1.ColumnByFieldName('ogDrop');
  FrxCol_Event:=RxDBGrid1.ColumnByFieldName('ogEvent');
  FrxCol_File:=RxDBGrid1.ColumnByFieldName('ogFile');
  FrxCol_Index:=RxDBGrid1.ColumnByFieldName('ogIndex');
  FrxCol_LockTables:=RxDBGrid1.ColumnByFieldName('ogLockTables');
  FrxCol_Process:=RxDBGrid1.ColumnByFieldName('ogProcess');
  FrxCol_Proxy:=RxDBGrid1.ColumnByFieldName('ogProxy');
  FrxCol_Reload:=RxDBGrid1.ColumnByFieldName('ogReload');
  FrxCol_ReplicationClient:=RxDBGrid1.ColumnByFieldName('ogReplicationClient');
  FrxCol_ReplicationSlave:=RxDBGrid1.ColumnByFieldName('ogReplicationSlave');
  FrxCol_ShowDatabases:=RxDBGrid1.ColumnByFieldName('ogShowDatabases');
  FrxCol_ShowView:=RxDBGrid1.ColumnByFieldName('ogShowView');
  FrxCol_Shutdown:=RxDBGrid1.ColumnByFieldName('ogShutdown');
  FrxCol_Super:=RxDBGrid1.ColumnByFieldName('ogSuper');
  FrxCol_Membership:=RxDBGrid1.ColumnByFieldName('ogMembership');

  for FG in TObjectGrant do
  begin
    F:=rxUGList.FindField(ObjectGrantNamesReal[FG]);
    if Assigned(F) then
      F.Tag:=Ord(FG);
  end;
end;

procedure TfbmUserObjectsGrantFrame.UpdateFilter;
begin
  rxUGList.Filtered:=false;
  rxUGList.Filtered:=(Trim(Edit1.Text)<>'') or (ComboBox1.ItemIndex>0) or (ComboBox2.ItemIndex>0);
end;

procedure TfbmUserObjectsGrantFrame.LockPost;
begin
  inc(FLockCount)
end;

procedure TfbmUserObjectsGrantFrame.UnLockPost;
var
  P:TACLItem;
  i: Integer;
begin
  if FLockCount = 0 then exit;
  Dec(FLockCount);
  if (FLockCount > 0) then Exit;

  for i:=0 to FACLItems.Count-1 do
  begin
    P:=TACLItem(FACLItems[i]);
    P.Owner.ApplyACLList(P);
  end;
  FACLItems.Clear;
end;

function TfbmUserObjectsGrantFrame.PageName: string;
begin
  Result:=sGrant;
end;

constructor TfbmUserObjectsGrantFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  FillChar(FRoDBObjTypes, SizeOf(FRoDBObjTypes), 0);
  RefreshPage;
  ComboBox2.OnChange:=@Edit1Change;
  FACLItems:=TList.Create;
end;

destructor TfbmUserObjectsGrantFrame.Destroy;
begin
  FreeAndNil(FACLItems);
  inherited Destroy;
end;

procedure TfbmUserObjectsGrantFrame.Activate;
begin
  inherited Activate;
end;

function TfbmUserObjectsGrantFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh];
end;

function TfbmUserObjectsGrantFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:edtPrint.Execute;
    epaRefresh:RefreshPage;
  end;
end;

procedure TfbmUserObjectsGrantFrame.Localize;
begin
  BindRxDBGridCollumn;
  inherited Localize;
  ComboBox2.OnChange:=nil;
  Label2.Caption:=sFilter;
  Caption:=sGrantsManager;

  edtPrint.Caption:=sPrint;

  RxDBGrid1.ColumnByFieldName('UG_NAME').Title.Caption:=sNameUserRole;
  RxDBGrid1.ColumnByFieldName('OWNER_USER').Title.Caption:=sGrantOwnUser;

  FrxCol_Select.Title.Caption:=sSelect;
  FrxCol_Insert.Title.Caption:=sInsert;
  FrxCol_Update.Title.Caption:=sUpdate;
  FrxCol_Delete.Title.Caption:=sDelete;
  FrxCol_Execute.Title.Caption:=sExecute;
  FrxCol_Reference.Title.Caption:=sReferences;
  FrxCol_Create.Title.Caption:=sCreate;
  FrxCol_Rule.Title.Caption:=sRule;
  FrxCol_Temporary.Title.Caption:=sTemporary;
  FrxCol_Truncate.Title.Caption:=sTruncate;
  FrxCol_Trigger.Title.Caption:=sTrigger;
  FrxCol_Usage.Title.Caption:=sUsage;
  FrxCol_WGO.Title.Caption:=sWithGrantOptions;
  FrxCol_Connect.Title.Caption:=sConnect;
  FrxCol_Alter.Title.Caption:=sAlter;
  FrxCol_AlterRoutine.Title.Caption:=sAlterRroutine;
  FrxCol_CreateRoutine.Title.Caption:=sCreateRoutine;
  FrxCol_CreateTablespace.Title.Caption:=sCreateTablespace;
  FrxCol_CreateUser.Title.Caption:=sCreateUser;
  FrxCol_CreateView.Title.Caption:=sCreateView;
  FrxCol_Drop.Title.Caption:=sDrop;
  FrxCol_Event.Title.Caption:=sEvent;
  FrxCol_File.Title.Caption:=sFile;
  FrxCol_Index.Title.Caption:=sIndex;
  FrxCol_LockTables.Title.Caption:=sLockTables;
  FrxCol_Process.Title.Caption:=sProcess;
  FrxCol_Proxy.Title.Caption:=sProxy;
  FrxCol_Reload.Title.Caption:=sReload;
  FrxCol_ReplicationClient.Title.Caption:=sReplClient;
  FrxCol_ReplicationSlave.Title.Caption:=sReplSlave;
  FrxCol_ShowDatabases.Title.Caption:=sShowDB;
  FrxCol_ShowView.Title.Caption:=sShowView;
  FrxCol_Shutdown.Title.Caption:=sShutdown;
  FrxCol_Super.Title.Caption:=sSuper;
  FrxCol_Membership.Title.Caption:=sMembership;

  ComboBox2.Items.Clear;
  ComboBox2.Items.Add(sShowAllGrants);
  ComboBox2.Items.Add(sShowOnlyGrants);
  ComboBox2.Items.Add(sShowOnlyNotGrants);
  ComboBox2.ItemIndex:=0;
end;

end.

