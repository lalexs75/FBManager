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

  TPGForeignDataWrapper = class(TDBRootObject)
  private
    FHandler: string;
    FNoHandler: boolean;
    FNoValidator: boolean;
    FOID: Integer;
    FOwnerID: Integer;
    FValidator: string;
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    destructor Destroy; override;
    function InternalGetDDLCreate: string; override;
    procedure Clear;override;
    function GetObjectType: string;override;
    procedure RefreshObject; override;
    class function DBClassTitle:string; override;

    property OwnerID:Integer read FOwnerID;
    property OID:Integer read FOID;
    property Handler:string read FHandler write FHandler;
    property Validator:string read FValidator write FValidator;
    property NoHandler:boolean read FNoHandler write FNoHandler;
    property NoValidator:boolean read FNoValidator write FNoValidator;
  end;


  { TPGForeignServer }

  TPGForeignServer = class(TDBRootObject)
  private
    FServerID: integer;
    FUserMapping:TPGForeignUserMapping;
  protected
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject);override;
    function InternalGetDDLCreate: string; override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    procedure Clear;override;
    function GetObjectType: string;override;
    class function DBClassTitle:string; override;
    property ServerID:integer read FServerID;
    property UserMapping:TPGForeignUserMapping read FUserMapping;
  end;

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

implementation
uses pg_SqlParserUnit, pgSqlTextUnit, pg_utils;

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
begin
  R:=TPGSQLCreateServer.Create(nil);
  R.Name:=CaptionFullPatch;

{  R.Handler:=FHandler;
  R.Validator:=FValidator;
  R.NoHandler:=FNoHandler;
  R.NoValidator:=FNoValidator;}

  Result:=R.AsSQL;
  R.Free;
end;

constructor TPGForeignServer.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  FDBObjectKind:=okServer;
  FUserMapping:=TPGForeignUserMapping.Create(AOwnerRoot.OwnerDB, TPGForeignUser, 'User mapping', Self);
  if Assigned(ADBItem) then
  begin
    FServerID:=ADBItem.ObjId;
  end;
end;

destructor TPGForeignServer.Destroy;
begin
  inherited Destroy;
end;

procedure TPGForeignServer.RefreshObject;
begin
  inherited RefreshObject;
end;

procedure TPGForeignServer.Clear;
begin
  inherited Clear;
end;

function TPGForeignServer.GetObjectType: string;
begin
  Result:='Foreign server';
end;

class function TPGForeignServer.DBClassTitle: string;
begin
  Result:='Foreign server';
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
  R.NoHandler:=FNoHandler;
  R.NoValidator:=FNoValidator;

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

function TPGForeignDataWrapper.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.pgFServ.Strings.Text;
end;

function TPGForeignDataWrapper.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) and (AItem.SchemeID = FOID);
end;

constructor TPGForeignDataWrapper.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
var
  F1: TSQLEngineAbstract;
begin
  inherited Create(ADBItem, AOwnerRoot);
  FObjectEditable:=true;
  FDBObjectClass:=TPGForeignServer;

  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
  end;
end;

destructor TPGForeignDataWrapper.Destroy;
begin
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
begin
  inherited RefreshObject;
  if State <> sdboEdit then exit;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.pgFDWobj.Strings.Text);
  try
    Q.ParamByName('oid').AsInteger:=FOID;
    Q.Open;
    if Q.RecordCount > 0 then
    begin
//      SchemaId:=Q.FieldByName('oid').AsInteger;
//      FOwnerName:=Q.FieldByName('usename').AsString;
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

