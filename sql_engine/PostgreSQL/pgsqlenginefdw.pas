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

unit pgSQLEngineFDW;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, sqlObjects, PostgreSQLEngineUnit,
  fbmSqlParserUnit, SQLEngineInternalToolsUnit, ZDataset;

type
  TPGForeignUserMapping = class;

  { TPGForeignUserMapping }

  TPGForeignUserMapping = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem: TDBItem): boolean; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  { TPGForeignUser }

  TPGForeignUser = class(TDBObject)
  private
    FOID: integer;
    FOptions: TStringList;
    FUserID: integer;
  protected
    procedure InternalPrepareDropCmd(R: TSQLDropCommandAbstract); override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject); override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    function InternalGetDDLCreate: string; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property UserID:integer read FUserID;
    property Options:TStringList read FOptions;
    property OID:integer read FOID;
  end;

  { TPGForeignServerRoot }

  TPGForeignServerRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    function GetObjectType: string;override;
  end;

  { TPGForeignServer }

  TPGForeignServer = class(TDBRootObject)
  private
    FOptions: TStringList;
    FOwnerID: integer;
    FServerID: integer;
    FServerType: string;
    FServerVersion: string;
    FUserMapping:TPGForeignUserMapping;
    function GetOwnerName: string;
  protected
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    function InternalGetDDLCreate: string; override;
    procedure RefreshObject; override;
    procedure Clear;override;
    function GetObjectType: string;override;
    class function DBClassTitle:string; override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CreateSQLObject:TSQLCommandDDL; override;

    property ServerID:integer read FServerID;
    property OwnerID:integer read FOwnerID;
    property OwnerName:string read GetOwnerName;
    property UserMapping:TPGForeignUserMapping read FUserMapping;

    property Options:TStringList read FOptions;
    property ServerType:string read FServerType write FServerType;
    property ServerVersion:string read FServerVersion write FServerVersion;
  end;

  { TPGForeignDataWrapperRoot }

  TPGForeignDataWrapperRoot = class(TPGDBRootObject)
  private
  protected
    function DBMSObjectsList:string; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    function GetObjectType: string;override;
  end;

  { TPGForeignDataWrapper }

  TPGForeignDataWrapper = class(TDBRootObject)
  private
    FForeignServers: TPGForeignServerRoot;
    FHandler: string;
    FHandlerID: Integer;
    FOID: Integer;
    FOptions: TStringList;
    FOwnerID: Integer;
    FValidator: string;
    FValidatorID: Integer;
    function GetNoHandler: boolean;
    function GetNoValidator: boolean;
    function GetOwner: string;
  protected
    //function DBMSObjectsList:string; override;
    //function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    function InternalGetDDLCreate: string; override;
    procedure Clear;override;
    function GetObjectType: string;override;
    procedure RefreshObject; override;
    class function DBClassTitle:string; override;

    property OID:Integer read FOID;
    property OwnerID:Integer read FOwnerID;
    property HandlerID:Integer read FHandlerID;
    property ValidatorID:Integer read FValidatorID;
    property Owner:string read GetOwner;
    property Handler:string read FHandler write FHandler;
    property Validator:string read FValidator write FValidator;
    property NoHandler:boolean read GetNoHandler;
    property NoValidator:boolean read GetNoValidator;
    property Options:TStringList read FOptions;

    property ForeignServers:TPGForeignServerRoot read FForeignServers;
  end;

implementation
uses fbmStrConstUnit, pg_SqlParserUnit, pgSqlTextUnit, pg_utils, pgSqlEngineSecurityUnit;

{ TPGForeignServerRoot }

function TPGForeignServerRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgFServ.Strings.Text;
end;

function TPGForeignServerRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = (OwnerRoot as TPGForeignDataWrapper).FOID);
end;

constructor TPGForeignServerRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okForeignServer;

  FDropCommandClass:=TPGSQLDropServer;
end;

destructor TPGForeignServerRoot.Destroy;
begin
  inherited Destroy;
end;

procedure TPGForeignServerRoot.Clear;
begin
  inherited Clear;
end;

function TPGForeignServerRoot.GetObjectType: string;
begin
  Result:='ForeignServer';
end;

{ TPGForeignUserMapping }

function TPGForeignUserMapping.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgFSUserMapping.Strings.Text;
end;

function TPGForeignUserMapping.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = TPGForeignServer(OwnerRoot).FServerID);
end;

function TPGForeignUserMapping.GetObjectType: string;
begin
  Result:='ForeignUserMapping';
end;

constructor TPGForeignUserMapping.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okUserMapping;
  //FDropCommandClass:=TPGSQLDropUser;
  FDropCommandClass:=TPGSQLDropGroup;
end;

{ TPGForeignUser }

function TPGForeignUser.InternalGetDDLCreate: string;
var
  R: TPGSQLCreateUserMapping;
  i: Integer;
begin
  R:=TPGSQLCreateUserMapping.Create(nil);
  R.Name:=CaptionFullPatch;
  R.ServerName:=SchemaName;
  for i:=0 to Options.Count-1 do
    R.Params.AddParamEx(Options.Names[i], Options.ValueFromIndex[i]);
  Result:=R.AsSQL;
  R.Free;
end;

procedure TPGForeignUser.InternalPrepareDropCmd(R: TSQLDropCommandAbstract);
begin
  inherited InternalPrepareDropCmd(R);
  if R is TPGSQLDropGroup then
  begin
    TPGSQLDropGroup(R).ServerName:=OwnerRoot.OwnerRoot.Caption;
  end;
end;

constructor TPGForeignUser.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FOptions:=TStringList.Create;

  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
  end;
end;

destructor TPGForeignUser.Destroy;
begin
  FreeAndNil(FOptions);
  inherited Destroy;
end;

procedure TPGForeignUser.RefreshObject;
var
  Q: TZQuery;
  S: String;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  FOptions.Clear;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.pgFSUserMapRefresh.Strings.Text);
  try
    Q.ParamByName('umid').AsInteger:=FOID;
    Q.Open;
    if Q.RecordCount > 0 then
    begin
      //oid,
      //umuser,
      //umserver,
      //
      S:=Q.FieldByName('umoptions').AsString;
      ParsePGArrayString(S, FOptions);

//      SchemaId:=Q.FieldByName('oid').AsInteger;
//      FOwnerName:=Q.FieldByName('usename').AsString;
//      FDescription:=Q.FieldByName('description').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;

end;

class function TPGForeignUser.DBClassTitle: string;
begin
  Result:=inherited DBClassTitle;
end;

procedure TPGForeignUser.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TPGForeignUser.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLCreateUserMapping.Create(nil)
  else
    Result:=TPGSQLAlterUserMapping.Create(nil);
end;

{ TPGForeignServer }

function TPGForeignServer.InternalGetDDLCreate: string;
var
  R: TPGSQLCreateServer;
  i: Integer;
  S1, S2: String;
begin
  R:=TPGSQLCreateServer.Create(nil);
  R.Description:=Description;
  R.Name:=CaptionFullPatch;
  R.ServerType:=ServerType;
  R.ServerVersion:=ServerVersion;
  R.ForeignDataWrapper:=(OwnerRoot.OwnerRoot as TPGForeignDataWrapper).Caption;

  for i:=0 to Options.Count-1 do
  begin
    S1:=Options.Names[i];
    S2:=Options.ValueFromIndex[i];
    R.Params.AddParamEx(S1, S2);
  end;
  Result:=R.AsSQL;
  R.Free;
end;

function TPGForeignServer.GetOwnerName: string;
var
  P: TDBObject;
begin
  Result:='';
  if not Assigned(OwnerDB) then Exit;

  for P in TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot.Objects do
    if TPGUser(P).UserID = OwnerID then
      Exit(P.Caption);
end;

procedure TPGForeignServer.InternalRefreshStatistic;
var
  S: String;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sServerOID, IntToStr(FServerID));
  Statistic.AddValue(sServerType, FServerType);
  if FServerVersion<>'' then
    Statistic.AddValue(sServerVersion1, FServerVersion);
  Statistic.AddValue(sOwnerID, IntToStr(FOwnerID));

  for S in FOptions do
    Statistic.AddParamValue(S);
end;

constructor TPGForeignServer.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FOptions:=TStringList.Create;
  FDBObjectKind:=okServer;
  FUserMapping:=TPGForeignUserMapping.Create(AOwnerRoot.OwnerDB, TPGForeignUser, sUserMapping, Self);
  if Assigned(ADBItem) then
  begin
    FServerID:=ADBItem.ObjId;
  end;
end;

destructor TPGForeignServer.Destroy;
begin
  FreeAndNil(FOptions);
  inherited Destroy;
end;

procedure TPGForeignServer.RefreshObject;
var
  Q: TZQuery;
  S: String;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;

  FOptions.Clear;

  if FServerID = 0 then
    S:=Format('pg_foreign_server.srvname = ''%s'' and pg_foreign_server.srvfdw = %d', [Caption, (OwnerRoot.OwnerRoot as TPGForeignDataWrapper).OID])
  else
    S:='pg_foreign_server.oid = '+IntToStr(FServerID); // :oid --33893';
  pgSqlTextModule.pgFServRefresh.MacroByName('Macro1').Value:=S;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.pgFServRefresh.ExpandMacros);
  try
    Q.Open;
    if Q.RecordCount > 0 then
    begin
      //pg_foreign_server.srvname,
      //pg_foreign_server.srvowner,
      //pg_foreign_server.srvfdw,
      //pg_foreign_server.srvacl,
      FServerID:=Q.FieldByName('oid').AsInteger;
      FOwnerID:=Q.FieldByName('srvowner').AsInteger;
      FServerType:=Q.FieldByName('srvtype').AsString;
      FServerVersion:=Q.FieldByName('srvversion').AsString;
      S:=Q.FieldByName('srvoptions').AsString;
      ParsePGArrayString(S, FOptions);
      FDescription:=Q.FieldByName('description').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

procedure TPGForeignServer.Clear;
begin
  inherited Clear;
end;

function TPGForeignServer.GetObjectType: string;
begin
  Result:=sForeignServer;
end;

class function TPGForeignServer.DBClassTitle: string;
begin
  Result:='Foreign server';
end;

procedure TPGForeignServer.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TPGForeignServer.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLCreateServer.Create(nil)
  else
    Result:=TPGSQLAlterServer.Create(nil);
end;

{ TPGForeignDataWrapper }

function TPGForeignDataWrapper.InternalGetDDLCreate: string;
var
  R: TPGSQLCreateForeignDataWrapper;
begin
  R:=TPGSQLCreateForeignDataWrapper.Create(nil);
  R.Name:=CaptionFullPatch;

  R.Handler:=FHandler;
  R.Validator:=FValidator;
  R.NoHandler:=NoHandler;
  R.NoValidator:=NoValidator;

  Result:=R.AsSQL;
  R.Free;
(*
  ACL:=TStringList.Create;
  try
    FACLList.RefreshList;
    FACLList.MakeACLListSQL(nil, ACL, true);
    Result:=Result + LineEnding + LineEnding + ACL.Text;
  finally
    ACL.Free;
  end; *)
end;

function TPGForeignDataWrapper.GetNoHandler: boolean;
begin
  Result:=FHandlerID = 0;
end;

function TPGForeignDataWrapper.GetNoValidator: boolean;
begin
  Result:=FValidatorID = 0;
end;

function TPGForeignDataWrapper.GetOwner: string;
var
  P: TDBObject;
begin
  Result:='';
  if not Assigned(OwnerDB) then Exit;

  for P in TPGSecurityRoot(TSQLEnginePostgre(OwnerDB).SecurityRoot).PGUsersRoot.Objects do
    if TPGUser(P).UserID = OwnerID then
      Exit(P.Caption);
end;
(*
function TPGForeignDataWrapper.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgFServ.Strings.Text;
end;

function TPGForeignDataWrapper.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = FOID);
end;
*)
constructor TPGForeignDataWrapper.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
var
  F1: TSQLEngineAbstract;
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
  end;

  FObjectEditable:=true;
  FDBObjectClass:=TPGForeignServer;
  FOptions:=TStringList.Create;
  FForeignServers:=TPGForeignServerRoot.Create(OwnerDB, TPGForeignServer, sForeignServer, Self);

end;

destructor TPGForeignDataWrapper.Destroy;
begin
  FreeAndNil(FOptions);
  inherited Destroy;
end;

procedure TPGForeignDataWrapper.Clear;
begin
  inherited Clear;
end;

function TPGForeignDataWrapper.GetObjectType: string;
begin
  Result:='Foreign data wrapper';
end;

procedure TPGForeignDataWrapper.RefreshObject;
var
  Q: TZQuery;
  S: String;
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  FOptions.Clear;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.pgFDWobj.Strings.Text);
  try
    Q.ParamByName('oid').AsInteger:=FOID;
    Q.Open;
    if Q.RecordCount > 0 then
    begin
      //oid,
      //fdwname,
      FOwnerID:=Q.FieldByName('fdwowner').AsInteger;
      FValidatorID:=Q.FieldByName('fdwvalidator').AsInteger;
      FHandlerID:=Q.FieldByName('fdwhandler').AsInteger;

//      fdwacl,
      S:=Q.FieldByName('fdwoptions').AsString;
      ParsePGArrayString(S, FOptions);
//
      FDescription:=Q.FieldByName('description').AsString;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

class function TPGForeignDataWrapper.DBClassTitle: string;
begin
  Result:='Foreign data wrapper';
end;

{ TPGForeignDataWrapperRoot }

function TPGForeignDataWrapperRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgFDW.Strings.Text;
end;

constructor TPGForeignDataWrapperRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okForeignDataWrapper;

  FDropCommandClass:=TPGSQLDropForeignDataWrapper;
end;

destructor TPGForeignDataWrapperRoot.Destroy;
begin
  inherited Destroy;
end;

procedure TPGForeignDataWrapperRoot.Clear;
begin
  inherited Clear;
end;

function TPGForeignDataWrapperRoot.GetObjectType: string;
begin
  Result:='Foreign data wrapper';
end;

end.

