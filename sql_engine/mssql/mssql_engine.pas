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
unit mssql_engine;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, DB, Forms, SQLEngineInternalToolsUnit,
  fdmAbstractEditorUnit, fdbm_PagedDialogPageUnit, sqldb, contnrs, ZDataset, ZConnection,
  mssql_ObjectsList, SQLEngineCommonTypesUnit;

type
  TMSSQLEngine = class;
  TMSSQLSSchema = class;

  { TMSSQLSchemasRoot }

  TMSSQLSchemasRoot = class(TDBRootObject)
  private
    FSchemasList:TObjectList;
  protected
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
  end;

  TMSSQLRootObject = class(TDBRootObject)

  end;

  { TMSSQLTablesRoot }

  TMSSQLTablesRoot = class(TDBRootObject)
  private
    FSchemaId: integer;
    FSchema:TMSSQLSSchema;
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    property SchemaId:integer read FSchemaId;
  end;

  { TMSSQLViewsRoot }

  TMSSQLViewsRoot = class(TDBRootObject)
  private
    FSchemaId: integer;
    FSchema:TMSSQLSSchema;
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    property SchemaId:integer read FSchemaId;
  end;

  { TMSSQLStoredProcRoot }

  TMSSQLStoredProcRoot = class(TDBRootObject)
  private
    FSchemaId: integer;
    FSchema:TMSSQLSSchema;
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    property SchemaId:integer read FSchemaId;
  end;

  { TMSSQLTriggerRoot }

  TMSSQLTriggerRoot = class(TDBRootObject)
  private
    FSchemaId: integer;
    FSchema:TMSSQLSSchema;
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    property SchemaId:integer read FSchemaId;
  end;

  { TMSSQLSSchema }

  TMSSQLSSchema = class(TDBRootObject)
  private
    FSchemaId: integer;
    FTablesRoot:TMSSQLTablesRoot;
    FStorepProc:TMSSQLStoredProcRoot;
    FViews:TMSSQLViewsRoot;
    FTriggers:TMSSQLTriggerRoot;
    procedure SetSchemaId(const AValue: integer);
  protected
//    function GetCountGrp: integer;override;
//    function GetImageIndex: integer;override;
  public
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    //function GetGrpObj(AItem:integer):TDBRootObject;override;
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    property SchemaId:integer read FSchemaId write SetSchemaId;
  end;

  {  TMSSQLTable  }
  TMSSQLTable = class(TDBTableObject)
  private
    FSchema:TMSSQLSSchema;
  protected
//    procedure InternalSetDescription;override;
    procedure SetState(const AValue: TDBObjectState); override;
//    procedure FieldListRefresh; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
//    function EditPage(AOwner:TComponent; AItem:integer):TEditorPage;override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
  end;

  {  TMSSQLView  }
  TMSSQLView = class(TDBTableObject)
  private
    FSchema:TMSSQLSSchema;
  protected
//    procedure InternalSetDescription;override;
    procedure SetState(const AValue: TDBObjectState); override;
//    procedure FieldListRefresh; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
//    function EditPage(AOwner:TComponent; AItem:integer):TEditorPage;override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
  end;

  {  TMSSQLStoredProcedure  }

  TMSSQLStoredProcedure = class(TDBTableObject)
  private
    FSchema:TMSSQLSSchema;
  protected
//    procedure InternalSetDescription;override;
    procedure SetState(const AValue: TDBObjectState); override;
//    procedure FieldListRefresh; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
//    function EditPage(AOwner:TComponent; AItem:integer):TEditorPage;override;

    procedure Commit;override;
    procedure RollBack;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
  end;

  { TMSSQLTriger }

  TMSSQLTriger = class(TDBTriggerObject)
  private
    FSchema:TMSSQLSSchema;
  protected
//    procedure InternalSetDescription;override;
    procedure SetState(const AValue: TDBObjectState); override;
    procedure SetActive(const AValue: boolean); override;
    function GetTriggerBody: string;override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    class function DBClassTitle:string;override;
    procedure RefreshObject; override;
//    function EditPage(AOwner:TComponent; AItem:integer):TEditorPage;override;
  end;

  { TMSSQLQueryControl }

  TMSSQLQueryControl = class(TSQLQueryControl)
  private
    FQuery:TZQuery;
    FParams:TParams;
    procedure SetParamValues;
  protected
    function GetDataSet: TDataSet;override;
    function GetQueryPlan: string;override;
    function GetQuerySQL: string;override;
    procedure SetQuerySQL(const AValue: string);override;
    function GetParam(AIndex: integer): TParam;override;
    function GetParamCount: integer;override;
    procedure SetActive(const AValue: boolean);override;
  public
    constructor Create(AOwner:TSQLEngineAbstract);
    destructor Destroy; override;
    procedure CommitTransaction;override;
    procedure RolbackTransaction;override;
    procedure FetchAll;override;
    procedure Prepare;override;
    procedure ExecSQL;override;
  end;

  { TMSSQLEngine }

  TMSSQLEngine = class(TSQLEngineAbstract)
  private
{    FAuthenticationType: TAuthenticationType; }
    FMSSQLConnection: TZConnection;
//    FServerVersion: TCTServerVersion;
//    FMSSQLTransaction: TTDSCTTransaction;
    //
    FStorepProc:TMSSQLStoredProcRoot;
    FViews:TMSSQLViewsRoot;
    FSchemasRoot:TMSSQLSchemasRoot;
{    FOraUsers:TOraUsersRoot;}
{    FOraSequences:TOraSequencesRoot;
    FOraTriggers:TOraTriggersRoot;}

    procedure InternalInitMSSQLEngine;
//    function ClientMsg(Connection:PCS_CONNECTION; ErrMsg:PCS_CLIENTMSG):CS_RETCODE;
//    function ServerMsg(Connection:PCS_CONNECTION; SrvMsg:PCS_SERVERMSG):CS_RETCODE;
  private
    //
  protected
    function GetImageIndex: integer;override;
//    function GetCountRootObjesct: integer; override;
//    function GetRootObject(AIndex:integer): TDBRootObject; override;
//    function GetConnected: boolean;override;
//    procedure SetConnected(const AValue: boolean);override;
    procedure InitGroupsObjects;override;
    procedure DoneGroupsObjects;override;

    class function GetEngineName: string; override;
//    class function GetCreateObject:TSQLEngineCreateDBAbstractClass; override;
    procedure SetUIShowSysObjects(const AValue: TUIShowSysObjects);override;
    function GetSqlQuery(ASql:string):TZQuery;
    procedure InitKeywords;
//    class function GetDBVisualToolsClass: TDBVisualToolsClass; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(const AData: TDataSet);override;
    procedure Store(const AData: TDataSet);override;
    procedure SetSqlAssistentData(const List: TStrings); override;
{    procedure FillCharSetList(const List: TStrings); override;
    function OpenDataSet(Sql:string; AOwner:TComponent):TDataSet;override;
    function ExecSQL(Sql:string):boolean;override;}
    function SQLPlan(aDataSet:TDataSet):string;override;
    function GetQueryControl:TSQLQueryControl;override;


    procedure RefreshObjectsBeginFull;override;
    procedure RefreshObjectsEndFull;override;

    //Create connection dialog functions
//    function ConnectionDlgPageCount:integer;override;
//    function ConnectionDlgPage(APageNum:integer; AOwner:TForm):TPagedDialogPage;override;
    procedure RefreshObjectsBegin(const ASQLText:string; ASystemQuery:Boolean);override;
    procedure RefreshObjectsEnd(const ASQLText:string);override;

//    property MSSQLConnection: TTDSCTDataBase read FMSSQLConnection ;
//    property ServerVersion:TCTServerVersion read FServerVersion write FServerVersion;
//    property DomainsRoot:TDomainsRoot read FDomainsRoot;
{    property TrigersRoot:TTrigersRoot read FTrigersRoot;
    property GeneratorsRoot:TGeneratorsRoot read FGeneratorsRoot;}
    property StoredProcRoot:TMSSQLStoredProcRoot read FStorepProc;
    property SchemasRoot:TMSSQLSchemasRoot read FSchemasRoot;
{    property ExceptionRoot:TExceptionRoot read FExceptionRoot;
    property UDFRoot:TUDFRoot read FUDFRoot;
    property RoleRoot:TRoleRoot read FRoleRoot;
    property ViewsRoot:TViewsRoot read FViewsRoot;}
  end;

implementation
uses fdbm_cf_LogUnit, cf_mssql_mainUnit, fbmStrConstUnit, mssql_sql_lines_unit,
  fbmToolsUnit;

{ TMSSQLEngine }

procedure TMSSQLEngine.InternalInitMSSQLEngine;
begin
  InitKeywords;
  //FMSSQLConnection:=TTDSCTDataBase.Create(nil);
  //FMSSQLConnection.OnClientMsg:=@ClientMsg;
  //FMSSQLConnection.OnServerMsg:=@ServerMsg;

  FUIParams:=[upSqlEditor, upUserName, upPassword, upLocal, upRemote];
end;
(*
function TMSSQLEngine.ClientMsg(Connection: PCS_CONNECTION;
  ErrMsg: PCS_CLIENTMSG): CS_RETCODE;
begin
  WriteLog('');
  WriteLog('ClientMsg:');
  WriteLog('msgstring = '+StrPas(@(ErrMsg^.msgstring[1])));
  WriteLog('osstring = '+StrPas(@ErrMsg^.osstring[1]));
{    severity:CS_INT;
    msgnumber:CS_MSGNUM;
    msgstring:array [1..CS_MAX_MSG] of CS_CHAR;
    msgstringlen:CS_INT;
    osnumber:CS_INT;
    osstring:array [1..CS_MAX_MSG] of CS_CHAR;
    osstringlen:CS_INT;
    status:CS_INT;
    sqlstate:array [1..CS_SQLSTATE_SIZE] of CS_BYTE ;
    sqlstatelen:CS_INT;}
//  WriteLog('




end;

function TMSSQLEngine.ServerMsg(Connection: PCS_CONNECTION;
  SrvMsg: PCS_SERVERMSG): CS_RETCODE;
begin
  WriteLog('');
  WriteLog('ServerMsg:');
  WriteLog('Text = '+StrPas(@SrvMsg^.Text[1]));
  WriteLog('SvrName = '+StrPas(@SrvMsg^.SvrName[1]));
  WriteLog('Proc = '+StrPas(@SrvMsg^.Proc[1]));
{    MsgNumber:CS_MSGNUM;
    State:CS_INT;
    SeverIty:CS_INT;
    Text:array [1..CS_MAX_MSG] of CS_CHAR;
    TextLen:CS_INT;
    SvrName:array [1..CS_MAX_NAME] of CS_CHAR;
    SvrNLen:CS_INT;
    Proc:array [1..CS_MAX_NAME] of CS_CHAR;
    ProcLen:CS_INT;
    Line:CS_INT;
    Status:CS_INT;
    SqlState:array [1..CS_SQLSTATE_SIZE] of CS_BYTE;
    SqlStateLen:CS_INT;}
end;
*)
procedure TMSSQLEngine.RefreshObjectsBegin(const ASQLText: string;
  ASystemQuery: Boolean);
//var
//  FQuery:TTDSCTQuery;
//  P, PriorP:PDBSQLObject;
//  K:integer;
//  DBObj:TDBObjectsItem;
begin
(*
  DBObj:=FCashedItems.AddTypes('AllObjects');
  if DBObj.CountUse=1 then
  begin
    FQuery:=GetSqlQuery(sql_MSSQL_ObjListAll);
    FQuery.Open;
    while not FQuery.Eof do
    begin

      New(P);
      if not Assigned(DBObj.First) then
        DBObj.First:=P
      else
        PriorP^.NextObj:=P;

      P^.NextObj:=nil;
      P^.ObjId:=FQuery.AsInteger[0];    //sys.all_objects.object_id
      P^.ObjName:=FQuery.AsString[1];   //sys.all_objects.[name]
      P^.SchemeID:=FQuery.AsInteger[2]; // sys.all_objects.schema_id
      P^.ObjType:=Trim(FQuery.AsString[3]);   //sys.all_objects.[type]

      FQuery.Next;
      PriorP:=P;
    end;
    FQuery.Close;
    FreeAndNil(FQuery);
  end;
*)
end;

procedure TMSSQLEngine.RefreshObjectsEnd(const ASQLText:string);
begin
  FCashedItems.RelaseTypes('AllObjects');
end;

function TMSSQLEngine.GetImageIndex: integer;
begin
  if GetConnected then
    Result:=21
  else
    Result:=20;
end;
(*
function TMSSQLEngine.GetCountRootObjesct: integer;
begin
  Result:=4;
end;

function TMSSQLEngine.GetRootObject(AIndex: integer): TDBRootObject;
begin
  case AIndex of
    0:Result:=FTablesRoot;
    1:Result:=FViews;
    2:Result:=FStorepProc;
    3:Result:=FSchemasRoot;
  else
    Result:=nil;
  end;
end;

function TMSSQLEngine.GetConnected: boolean;
begin
  Result:=FMSSQLConnection.Connected;
end;

procedure TMSSQLEngine.SetConnected(const AValue: boolean);
begin
  if AValue then
  begin
    FMSSQLConnection.Database:=DataBaseName;
    FMSSQLConnection.UserName:=UserName;
    FMSSQLConnection.Password:=Password;
    FMSSQLConnection.ServerVersion:=FServerVersion;
    FMSSQLConnection.ServerName:=ServerName;

    FMSSQLConnection.Connected:=true;
  end
  else
  begin
    FMSSQLConnection.Connected:=false;
  end;
end;
*)
procedure TMSSQLEngine.InitGroupsObjects;
begin
  //AddObjectsGroup(FTablesRoot, TMSSQLTablesRoot, );
  //AddObjectsGroup(FStorepProc, TMSSQLStoredProcRoot.Create(Self);
  //AddObjectsGroup(FViews, TMSSQLViewsRoot.Create(Self);
  //AddObjectsGroup(FSchemasRoot, TMSSQLSchemasRoot.Create(Self);
end;

procedure TMSSQLEngine.DoneGroupsObjects;
begin
  FStorepProc:=nil;
  FViews:=nil;
  FSchemasRoot:=nil;
end;

class function TMSSQLEngine.GetEngineName: string;
begin
  Result:='MS SQL Server';
end;
(*
class function TMSSQLEngine.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=nil; //inherited GetCreateObject;
end;
*)
procedure TMSSQLEngine.SetUIShowSysObjects(const AValue: TUIShowSysObjects);
begin
  inherited SetUIShowSysObjects(AValue);
end;

function TMSSQLEngine.GetSqlQuery(ASql: string): TZQuery;
begin
  Result:=TZQuery.Create(nil);
  Result.Connection:=FMSSQLConnection;
  Result.SQL.Text:=ASql;
end;

procedure TMSSQLEngine.InitKeywords;
begin
  KeywordsList.Clear;
  FKeywords:=CreateMSSQLKeyWords;
  KeywordsList.Add(FKeywords);

//  KeywordsList.Add(FKeyFunctions);
end;
(*
class function TMSSQLEngine.GetDBVisualToolsClass: TDBVisualToolsClass;
begin
  Result:=TMSSQLVisualTools;
end;
*)
constructor TMSSQLEngine.Create;
begin
  inherited Create;
  FSQLEngileFeatures:=[feDescribeObject];
  InternalInitMSSQLEngine;
end;
(*
constructor TMSSQLEngine.CreateFrom(CreateClass: TSQLEngineCreateDBAbstractClass
  );
begin
  inherited CreateFrom(CreateClass);
  InternalInitMSSQLEngine;
end;
*)
destructor TMSSQLEngine.Destroy;
begin
  FreeAndNil(FMSSQLConnection);
  inherited Destroy;
end;

procedure TMSSQLEngine.Load(const AData: TDataSet);
begin
  inherited;
//  FServerVersion:=TCTServerVersion(IniFile.ReadInteger(IniSection, 'Server version', 2));
end;

procedure TMSSQLEngine.Store(const AData: TDataSet);
begin
  inherited;
//  IniFile.WriteInteger(IniSection, 'Server version', Ord(FServerVersion));
end;

procedure TMSSQLEngine.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  //List.Add('Server version     = '+CTServerVersionStr[FServerVersion]);
end;

function TMSSQLEngine.SQLPlan(aDataSet: TDataSet): string;
begin
  Result:='';
end;

function TMSSQLEngine.GetQueryControl: TSQLQueryControl;
begin
  Result:=TMSSQLQueryControl.Create(Self);
end;

procedure TMSSQLEngine.RefreshObjectsBeginFull;
begin
  //
end;

procedure TMSSQLEngine.RefreshObjectsEndFull;
begin
  //
end;
(*
function TMSSQLEngine.ConnectionDlgPageCount: integer;
begin
  Result:=2;
end;

function TMSSQLEngine.ConnectionDlgPage(APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=Tcf_mssql_main_frame.Create(Self, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(Self, AOwner);
  end;
end;
*)
{ TMSSQLTablesRoot }

function TMSSQLTablesRoot.GetObjectType: string;
begin
  Result:='Table';
end;

procedure TMSSQLTablesRoot.RefreshGroup;
//var
//  U:TMSSQLTable;
//  P:PDBSQLObject;
begin
  //FOwnerDB.RefreshObjectsBegin('');
  //P:=TMSSQLEngine(FOwnerDB).CashedItems['AllObjects']; //MSSQLObjectList;
  //while Assigned(P) do
  //begin
  //
  //  if (P^.ObjType = 'U') and (P^.SchemeID = FSchemaId)  then
  //  begin
  //    U:=TMSSQLTable.Create(P^.ObjName, Self);
  //    U.FSchema:=FSchema;
  //  end;
  //  P:=P^.NextObj;
  //end;
  //FOwnerDB.RefreshObjectsEnd('');
end;

constructor TMSSQLTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
//  Caption:=sTables;
//  FDBObjectKind:=okTable;
//  FOwnerDB:=AMSSQLEngine;
end;

{ TMSSQLTable }
(*
procedure TMSSQLTable.InternalSetDescription;
begin
  //inherited InternalSetDescription;
end;
*)
procedure TMSSQLTable.SetState(const AValue: TDBObjectState);
begin
  inherited SetState(AValue);
//  FEditPageCount:=1;
{  if AValue = sdboCreate then
    FEditPageCount:=2
  else
    FEditPageCount:=9;}
end;
(*
procedure TMSSQLTable.FieldListRefresh;
begin
  if not Assigned(FFields) then
    FFields:=TFieldItems.Create;
  FFields.Clear;
//  inherited FieldListRefresh;
end;
  *)
constructor TMSSQLTable.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited;
  //FDataSet:=TTDSCTDataSet.Create(nil);
  //FDataSet.DataBase:=TMSSQLEngine(FOwnerDB).FMSSQLConnection;
end;

destructor TMSSQLTable.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLTable.DBClassTitle: string;
begin
  Result:=sTable;
end;

procedure TMSSQLTable.RefreshObject;
begin
//  inherited Refresh;
end;
(*
function TMSSQLTable.EditPage(AOwner: TComponent; AItem: integer): TEditorPage;
begin
  case AItem of
    0:Result:=TfbmTableEditorDataFrame.CreatePage(AOwner, Self);
  else
    Result:=nil;
  end;
end;
*)
procedure TMSSQLTable.Commit;
begin
//  inherited Commit;
end;

procedure TMSSQLTable.RollBack;
begin
//  inherited RollBack;
end;

function TMSSQLTable.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TZQuery(FDataSet).SQL.Text:='select * from '+FSchema.Caption+'.'+Caption;//MakeSQLSelect(Caption, FBDataSet.DataBase);
{    FDataSet.SQLEdit.Text:=MakeSQLEdit(Caption, FBDataSet.DataBase);
    FDataSet.SQLInsert.Text:=MakeSQLInsert(Caption, FBDataSet.DataBase);
    FDataSet.SQLDelete.Text:=MakeSQLDelete(Caption, FBDataSet.DataBase);
    FDataSet.SQLRefresh.Text:=MakeSQLRefresh(Caption, FBDataSet.DataBase);}

{    if FOwnerDB.DisplayDataOptions.FetchAllData then
      FDataSet.Option := FDataSet.Option + [poFetchAll]
    else
      FDataSet.Option := FDataSet.Option - [poFetchAll];}
  end;
//  FDataSet.Active:=true;
  Result:=FDataSet;
end;

{ TMSSQLStoredProcRoot }

function TMSSQLStoredProcRoot.GetObjectType: string;
begin
  Result:='Stored procedure';
end;

procedure TMSSQLStoredProcRoot.RefreshGroup;
//var
//  P:PDBSQLObject;
//  U:TMSSQLStoredProcedure;
begin
  (*FObjects.Clear;
  FOwnerDB.RefreshObjectsBegin('');
  P:=TMSSQLEngine(FOwnerDB).CashedItems['AllObjects'];
  while Assigned(P) do
  begin
    if (P^.ObjType = 'P') and (P^.SchemeID = FSchemaId) then
    begin
      U:=TMSSQLStoredProcedure.Create(P^.ObjName, Self);
      U.FSchema:=FSchema;
    end;
    P:=P^.NextObj;
  end;
  FOwnerDB.RefreshObjectsEnd('');
  *)
end;

constructor TMSSQLStoredProcRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  //FCaption:=sStoredProcedures;
  //FDBObjectKind:=okStoredProc;
  //FOwnerDB:=AMSSQLEngine;
end;

{ TMSSQLStoredProcedure }
(*
procedure TMSSQLStoredProcedure.InternalSetDescription;
begin
//  inherited InternalSetDescription;
end;
*)
procedure TMSSQLStoredProcedure.SetState(const AValue: TDBObjectState);
begin
  inherited SetState(AValue);
end;
(*
procedure TMSSQLStoredProcedure.FieldListRefresh;
begin
  if not Assigned(FFields) then
    FFields:=TFieldItems.Create;
  FFields.Clear;
end;
*)
constructor TMSSQLStoredProcedure.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
end;

destructor TMSSQLStoredProcedure.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLStoredProcedure.DBClassTitle: string;
begin
  Result:=sStoredProcedure;
end;

procedure TMSSQLStoredProcedure.RefreshObject;
begin
//  inherited Refresh;
end;
(*
function TMSSQLStoredProcedure.EditPage(AOwner: TComponent; AItem: integer
  ): TEditorPage;
begin
  Result:=nil;
end;
*)
procedure TMSSQLStoredProcedure.Commit;
begin
//  inherited Commit;
end;

procedure TMSSQLStoredProcedure.RollBack;
begin
//  inherited RollBack;
end;

function TMSSQLStoredProcedure.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  Result:=nil;
end;

{ TMSSQLViewsRoot }

function TMSSQLViewsRoot.GetObjectType: string;
begin
  Result:='View';
end;

procedure TMSSQLViewsRoot.RefreshGroup;
//var
//  P:PDBSQLObject;
//  U:TMSSQLView;
begin
(*  FObjects.Clear;

  FOwnerDB.RefreshObjectsBegin('');
  P:=TMSSQLEngine(FOwnerDB).CashedItems['AllObjects'];
  while Assigned(P) do
  begin
    if (P^.ObjType = 'V') and (P^.SchemeID = FSchemaId) then
    begin
      U:=TMSSQLView.Create(P^.ObjName, Self);
      U.FSchema:=FSchema;
    end;
    P:=P^.NextObj;
  end;
  FOwnerDB.RefreshObjectsEnd('');
*)
end;

constructor TMSSQLViewsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  //FCaption:=sViews;
  //FDBObjectKind:=okView;
  //FOwnerDB:=AMSSQLEngine;
end;

{ TMSSQLView }
(*
procedure TMSSQLView.InternalSetDescription;
begin
  //inherited InternalSetDescription;
end;
*)
procedure TMSSQLView.SetState(const AValue: TDBObjectState);
begin
  inherited SetState(AValue);
//  FEditPageCount:=1;
end;
(*
procedure TMSSQLView.FieldListRefresh;
begin
  if not Assigned(FFields) then
    FFields:=TFieldItems.Create;
  FFields.Clear;
end;
*)
constructor TMSSQLView.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject
  );
begin
  inherited;
  //FDataSet:=TTDSCTDataSet.Create(nil);
  //FDataSet.DataBase:=TMSSQLEngine(FOwnerDB).FMSSQLConnection;
end;

destructor TMSSQLView.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLView.DBClassTitle: string;
begin
  Result:=sView;
end;

procedure TMSSQLView.RefreshObject;
begin
  //inherited Refresh;
end;
(*
function TMSSQLView.EditPage(AOwner: TComponent; AItem: integer): TEditorPage;
begin
  case AItem of
    0:Result:=TfbmTableEditorDataFrame.CreatePage(AOwner, Self);
  else
    Result:=nil;
  end;
end;
*)
procedure TMSSQLView.Commit;
begin
//  inherited Commit;
end;

procedure TMSSQLView.RollBack;
begin
//  inherited RollBack;
end;

function TMSSQLView.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  if not FDataSet.Active then
  begin
    TZQuery(FDataSet).SQL.Text:='select * from '+FSchema.Caption+'.'+Caption;//MakeSQLSelect(Caption, FBDataSet.DataBase);
{    FDataSet.SQLEdit.Text:=MakeSQLEdit(Caption, FBDataSet.DataBase);
    FDataSet.SQLInsert.Text:=MakeSQLInsert(Caption, FBDataSet.DataBase);
    FDataSet.SQLDelete.Text:=MakeSQLDelete(Caption, FBDataSet.DataBase);
    FDataSet.SQLRefresh.Text:=MakeSQLRefresh(Caption, FBDataSet.DataBase);}

{    if FOwnerDB.DisplayDataOptions.FetchAllData then
      FDataSet.Option := FDataSet.Option + [poFetchAll]
    else
      FDataSet.Option := FDataSet.Option - [poFetchAll];}
  end;
//  FDataSet.Active:=true;
  Result:=FDataSet;
end;

{ TMSSQLQueryControl }

procedure TMSSQLQueryControl.SetParamValues;
var
  i:integer;
begin
  for i:=0 to FParams.Count-1 do
  begin
    case FParams[i].DataType of
      ftString   : FQuery.Params.ParamByName(FParams[i].Name).AsString:=FParams[i].AsString;
      ftInteger  : FQuery.Params.ParamByName(FParams[i].Name).AsInteger:=FParams[i].AsInteger;
      ftFloat    : FQuery.Params.ParamByName(FParams[i].Name).AsFloat:=FParams[i].AsInteger;
      ftDateTime : FQuery.Params.ParamByName(FParams[i].Name).AsDateTime:=FParams[i].AsDateTime;
      ftCurrency : FQuery.Params.ParamByName(FParams[i].Name).AsCurrency:=FParams[i].AsCurrency;
    end;
  end;
end;

function TMSSQLQueryControl.GetDataSet: TDataSet;
begin
  Result:=FQuery;
end;

function TMSSQLQueryControl.GetQueryPlan: string;
begin
{  FBQuery.QuerySelect.Prepare(true);
  Result:=FBQuery.QuerySelect.Plan;}
  Result:='';
end;

function TMSSQLQueryControl.GetQuerySQL: string;
begin
  Result:=FQuery.SQL.Text;
end;

procedure TMSSQLQueryControl.SetQuerySQL(const AValue: string);
var
  P:TParam;
  I:integer;
begin
  FQuery.SQL.Text:=AValue;
(*  FParams.Clear;
  for i:=0 to FQuery.Params.Count - 1 do
  begin
    P:=TParam.Create(FParams);
    case FQuery.Params[i].DataType of
      cptInteger  : P.DataType:=ftInteger;
      cptString   : P.DataType:=ftString;
      cptFloat    : P.DataType:=ftFloat;
      cptDateTime : P.DataType:=ftDateTime;
      cptCurrency : P.DataType:=ftCurrency;
    end;
    P.Name:=FQuery.Params[i].Name;
  end; *)
end;

function TMSSQLQueryControl.GetParam(AIndex: integer): TParam;
begin
  Result:=FParams[AIndex];
end;

function TMSSQLQueryControl.GetParamCount: integer;
begin
  Result:=FParams.Count;
end;

procedure TMSSQLQueryControl.SetActive(const AValue: boolean);
begin
  SetParamValues;
  inherited SetActive(AValue);
end;

constructor TMSSQLQueryControl.Create(AOwner: TSQLEngineAbstract);
begin
  inherited Create(AOwner);
  FQuery:=TZQuery.Create(nil);
  FQuery.Connection:=TMSSQLEngine(Owner).FMSSQLConnection;
//  FQuery.Transaction:=FFBTransaction;
  FParams:=TParams.Create(nil);
end;

destructor TMSSQLQueryControl.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FQuery);
  inherited Destroy;
end;

procedure TMSSQLQueryControl.CommitTransaction;
begin
//  inherited CommitTransaction;
end;

procedure TMSSQLQueryControl.RolbackTransaction;
begin
//  inherited RolbackTransaction;
end;

procedure TMSSQLQueryControl.FetchAll;
var
  P:TBookmark;
begin
  P:=FQuery.GetBookmark;
  try
    FQuery.Last;
  finally
    FQuery.GotoBookmark(P);
    FQuery.FreeBookmark(P);
  end;
end;

procedure TMSSQLQueryControl.Prepare;
begin
  FQuery.Prepare;
end;

procedure TMSSQLQueryControl.ExecSQL;
begin
  SetParamValues;
  FQuery.ExecSQL;
end;

{ TMSSQLSchemasRoot }
(*
function TMSSQLSchemasRoot.GetCountGrp: integer;
begin
  Result:=FSchemasList.Count;
end;

function TMSSQLSchemasRoot.GetImageIndex: integer;
begin
  Result:=21;
end;
*)
function TMSSQLSchemasRoot.GetObjectType: string;
begin
  Result:='Schema';
end;
(*
function TMSSQLSchemasRoot.GetGrpObj(AItem: integer): TDBRootObject;
begin
  Result:=TDBRootObject(FSchemasList[AItem]);
end;
*)
procedure TMSSQLSchemasRoot.RefreshGroup;
//var
//  Q:TTDSCTQuery;
//  U:TMSSQLSSchema;
begin
  FObjects.Clear;
  //Q:=TMSSQLEngine(FOwnerDB).GetSqlQuery(sql_MSSQL_Schemas);
  //Q.CommandType:=ctDynamic;
  //try
  //  Q.Open;
  //  while not Q.Eof do
  //  begin
  //    U:=TMSSQLSSchema.Create(Q.AsString[1], FOwnerDB as TMSSQLEngine);
  //    U.SchemaId:=Q.AsInteger[0];
  //    FSchemasList.Add(U);
  //    Q.Next;
  //  end;
  //finally
  //  Q.Free;
  //end;
end;

constructor TMSSQLSchemasRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  //FCaption:=sSchemes;
  //FDBObjectKind:=okScheme;
  //FOwnerDB:=AMSSQLEngine;
  //FSchemasList:=TObjectList.Create(true);
end;

destructor TMSSQLSchemasRoot.Destroy;
begin
  FreeAndNil(FSchemasList);
  inherited Destroy;
end;

{ TMSSQLSSchema }

procedure TMSSQLSSchema.SetSchemaId(const AValue: integer);
begin
  FSchemaId:=AValue;
  FTablesRoot.FSchemaId:=AValue;
  FStorepProc.FSchemaId:=AValue;
  FViews.FSchemaId:=AValue;
  FTriggers.FSchemaId:=AValue;
end;
(*
function TMSSQLSSchema.GetCountGrp: integer;
begin
  Result:=4;
end;

function TMSSQLSSchema.GetImageIndex: integer;
begin
  Result:=21;
end;
*)
function TMSSQLSSchema.GetObjectType: string;
begin
  Result:='Schema';
end;

procedure TMSSQLSSchema.RefreshGroup;
begin
  FTablesRoot.RefreshGroup;
  FStorepProc.RefreshGroup;
  FViews.RefreshGroup;
end;
(*
function TMSSQLSSchema.GetGrpObj(AItem: integer): TDBRootObject;
begin
  case AItem of
    0:Result:=FTablesRoot;
    1:Result:=FStorepProc;
    2:Result:=FViews;
    3:Result:=FTriggers;
  else
    Result:=nil;
  end;
end;
*)
constructor TMSSQLSSchema.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
(*
  FCaption:=ACaption;
  FDBObjectKind:=okScheme;
  FOwnerDB:=AMSSQLEngine;

  FTablesRoot:=TMSSQLTablesRoot.Create(AMSSQLEngine);
  FStorepProc:=TMSSQLStoredProcRoot.Create(AMSSQLEngine);
  FViews:=TMSSQLViewsRoot.Create(AMSSQLEngine);
  FTriggers:=TMSSQLTriggerRoot.Create(AMSSQLEngine);

  FTablesRoot.FSchema:=Self;
  FStorepProc.FSchema:=Self;
  FViews.FSchema:=Self;
  FTriggers.FSchema:=Self;
*)
end;

destructor TMSSQLSSchema.Destroy;
begin
  FreeAndNil(FTablesRoot);
  FreeAndNil(FStorepProc);
  FreeAndNil(FViews);
  FreeAndNil(FTriggers);
  inherited Destroy;
end;

{ TMSSQLTriggerRoot }

function TMSSQLTriggerRoot.GetObjectType: string;
begin
  Result:='Trigger';
end;

procedure TMSSQLTriggerRoot.RefreshGroup;
//var
//  P:PDBSQLObject;
//  T:TMSSQLTriger;
begin
  FObjects.Clear;
(*  FOwnerDB.RefreshObjectsBegin('');
  P:=TMSSQLEngine(FOwnerDB).CashedItems['AllObjects'];
  while Assigned(P) do
  begin
    if (P^.ObjType = 'TR') and (P^.SchemeID = FSchemaId) then
    begin
      T:=TMSSQLTriger.Create(P^.ObjName, Self);
      T.FSchema:=FSchema;
    end;
    P:=P^.NextObj;
  end;
  FOwnerDB.RefreshObjectsEnd(''); *)
end;

constructor TMSSQLTriggerRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
  //FCaption:=sTriggers;
  //FDBObjectKind:=okTrigger;
  //FOwnerDB:=AMSSQLEngine;
end;

{ TMSSQLTriger }
(*
procedure TMSSQLTriger.InternalSetDescription;
begin
//  inherited InternalSetDescription;
end;
*)
procedure TMSSQLTriger.SetState(const AValue: TDBObjectState);
begin
  inherited SetState(AValue);
end;

procedure TMSSQLTriger.SetActive(const AValue: boolean);
begin
//  inherited SetActive(AValue);
end;

function TMSSQLTriger.GetTriggerBody: string;
begin
  Result:='';//inherited GetTriggerBody;
end;

constructor TMSSQLTriger.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited;
end;

destructor TMSSQLTriger.Destroy;
begin
  inherited Destroy;
end;

class function TMSSQLTriger.DBClassTitle: string;
begin
  Result:=sTrigger;
end;

procedure TMSSQLTriger.RefreshObject;
begin
//  inherited Refresh;
end;
(*
function TMSSQLTriger.EditPage(AOwner: TComponent; AItem: integer
  ): TEditorPage;
begin
  Result:=nil; //inherited EditPage(AOwner, AItem);
end;
*)
initialization
//  RegisterSQLEngine(TMSSQLEngine, sMSSQLServer);
end.

