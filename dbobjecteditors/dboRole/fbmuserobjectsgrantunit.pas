unit fbmUserObjectsGrantUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList,
  rxmemds, rxdbgrid, RxDBGridPrintGrid, rxtoolbar, DB, fdmAbstractEditorUnit,
  SQLEngineAbstractUnit, fbmToolsUnit;

type

  { TfbmUserObjectsGrantFrame }

  TfbmUserObjectsGrantFrame = class(TEditorPage)
    ActionList1: TActionList;
    dsUGList: TDataSource;
    edtPrint: TAction;
    grALL: TAction;
    grHL: TAction;
    grVL: TAction;
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
    rxUGListUG_NAME: TStringField;
    rxUGListUG_TYPE: TLongintField;
    ToolPanel1: TToolPanel;
  private

  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TfbmUserObjectsGrantFrame }

function TfbmUserObjectsGrantFrame.PageName: string;
begin
  Result:=sGrant;
end;

constructor TfbmUserObjectsGrantFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
end;

procedure TfbmUserObjectsGrantFrame.Activate;
begin
  inherited Activate;
end;

function TfbmUserObjectsGrantFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited ActionEnabled(PageAction);
end;

function TfbmUserObjectsGrantFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

procedure TfbmUserObjectsGrantFrame.Localize;
begin
  inherited Localize;
end;

end.

