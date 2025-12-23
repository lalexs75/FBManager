{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pgSQLEngineFTS;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, sqlEngineTypes, SQLEngineAbstractUnit, sqlObjects, PostgreSQLEngineUnit,
  fbmSqlParserUnit, SQLEngineInternalToolsUnit, ZDataset;

type
  TPGFTSConfigurationsRoot = class;
  TPGFTSDictionaresRoot = class;
  TPGFTSParsersRoot = class;
  TPGFTSTemplatesRoot = class;

  { TPGFTSRoot }

  TPGFTSRoot = class(TPGDBRootObject)
  private
    FConfigs:TPGFTSConfigurationsRoot;
    FDictionares:TPGFTSDictionaresRoot;
    FParsers:TPGFTSParsersRoot;
    FTemplates:TPGFTSTemplatesRoot;
  protected

  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    procedure Clear;override;
    function GetObjectType: string;override;
  end;

  { TPGFTSConfigurationsRoot }

  TPGFTSConfigurationsRoot = class(TPGDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function GetObjectType: string;override;
  end;

  { TPGFTSDictionaresRoot }

  TPGFTSDictionaresRoot = class(TPGDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function GetObjectType: string;override;
  end;

  { TPGFTSParsersRoot }

  TPGFTSParsersRoot = class(TPGDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function GetObjectType: string;override;
  end;

  { TPGFTSTemplatesRoot }

  TPGFTSTemplatesRoot = class(TPGDBRootObject)
  protected
    function DBMSObjectsList:string; override;
    function DBMSValidObject(AItem:TDBItem):boolean; override;
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    function GetObjectType: string;override;
  end;


  {  TPGFTSConfigurations  }

  TPGFTSConfigurations = class(TDBObject)
  private
    FOID: integer;
    FParserID: integer;
    FParserName: string;
  protected
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    function CreateSQLObject:TSQLCommandDDL; override;
    procedure FillParsersList(const AList: TStrings);
    property OID:integer read FOID;
    property ParserID:integer read FParserID;
    property ParserName:string read FParserName;
    //cfgnamespace,
    //cfgowner,
    //cfgparser
  end;

  TPGFTSDictionares = class(TDBObject)
  private
  protected
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    function CreateSQLObject:TSQLCommandDDL; override;
    procedure SetSqlAssistentData(const List: TStrings);override;
  end;

  TPGFTSParsers = class(TDBObject)
  private
    FOID: integer;
  protected
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch: string; override;
    procedure InternalRefreshStatistic; override;
    function GetEnableRename: boolean; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    function RenameObject(ANewName:string):Boolean; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
    property OID:integer read FOID;
  end;

  TPGFTSTemplate = class(TDBObject)
  private
  protected
    function InternalGetDDLCreate: string; override;
    function GetCaptionFullPatch: string; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    class function DBClassTitle:string;override;
    procedure SetSqlAssistentData(const List: TStrings);override;
  end;
implementation

uses fbmStrConstUnit, pgSqlTextUnit, pg_SqlParserUnit;

{ TPGFTSTemplate }

function TPGFTSTemplate.InternalGetDDLCreate: string;
begin
  Result:=inherited InternalGetDDLCreate;
end;

function TPGFTSTemplate.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName((OwnerRoot as TPGFTSTemplatesRoot).Schema, Self)
end;

constructor TPGFTSTemplate.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TPGFTSTemplate.Destroy;
begin
  inherited Destroy;
end;

procedure TPGFTSTemplate.RefreshObject;
begin
  inherited RefreshObject;
end;

class function TPGFTSTemplate.DBClassTitle: string;
begin
  Result:='Template';
end;

procedure TPGFTSTemplate.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

{ TPGFTSParsers }

function TPGFTSParsers.InternalGetDDLCreate: string;
begin
  Result:=inherited InternalGetDDLCreate;
end;

function TPGFTSParsers.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName((OwnerRoot as TPGFTSParsersRoot).Schema, Self)
end;

procedure TPGFTSParsers.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FOID));
  (*  Statistic.AddValue(sFileFolder, FFolderName);
    Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery('select pg_tablespace_size('+IntToStr(FOID)+') as TableSpaceSize');
    Q.Open;
    if Q.RecordCount>0 then
    begin
      Statistic.AddValue(sTableSpaceSize, RxPrettySizeName(Q.FieldByName('TableSpaceSize').AsLargeInt));
    end;
    Q.Free; *)
end;

function TPGFTSParsers.GetEnableRename: boolean;
begin
  Result:=true;
end;

constructor TPGFTSParsers.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
  begin
    FOID:=ADBItem.ObjId;
  end;
end;

destructor TPGFTSParsers.Destroy;
begin
  inherited Destroy;
end;

procedure TPGFTSParsers.RefreshObject;
begin
  inherited RefreshObject;
end;

function TPGFTSParsers.RenameObject(ANewName: string): Boolean;
var
  FCmd: TPGSQLAlterTextSearch;
begin
  if (State = sdboCreate) then
  begin
    Caption:=ANewName;
    Result:=true;
  end
  else
  begin
    FCmd:=TPGSQLAlterTextSearch.Create(nil);
(*    FCmd.Name:=Caption;
    FCmd.SchemaName:=SchemaName;
    FCmd.NewName:=ANewName;
    FieldsIN.SaveToSQLFields(FCmd.Params);
    Result:=CompileSQLObject(FCmd, [sepInTransaction, sepShowCompForm, sepNotRefresh]);
    FCmd.Free;
    if Result then
    begin
      Caption:=ANewName;
    end; *)
    Result:=False;
  end;
end;

class function TPGFTSParsers.DBClassTitle: string;
begin
  Result:='Parser';
end;

procedure TPGFTSParsers.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

{ TPGFTSDictionares }

function TPGFTSDictionares.InternalGetDDLCreate: string;
var
  R: TSQLCommandDDL;
begin
  R:=CreateSQLObject;

  //TPGSQLCreateTextSearchConfig(R).Params.AddParamEx('PARSER', ParserName);
  R.Description:=Description;

  Result:=R.AsSQL;
  R.Free;
end;

function TPGFTSDictionares.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName((OwnerRoot as TPGFTSDictionaresRoot).Schema, Self)
end;

constructor TPGFTSDictionares.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
end;

destructor TPGFTSDictionares.Destroy;
begin
  inherited Destroy;
end;

procedure TPGFTSDictionares.RefreshObject;
begin
  inherited RefreshObject;
end;

class function TPGFTSDictionares.DBClassTitle: string;
begin
  Result:='Dictionares';
end;

function TPGFTSDictionares.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateTextSearchDictionary.Create(nil);
  Result.Name:=Caption;
  if Assigned(TPGFTSDictionaresRoot(OwnerRoot).Schema) then
    TPGSQLCreateTextSearchDictionary(Result).SchemaName:=TPGFTSConfigurationsRoot(OwnerRoot).Schema.Caption;
end;

procedure TPGFTSDictionares.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

{ TPGFTSConfigurations }

function TPGFTSConfigurations.InternalGetDDLCreate: string;
var
  R: TSQLCommandDDL;
begin
  R:=CreateSQLObject;

  TPGSQLCreateTextSearchConfig(R).Params.AddParamEx('PARSER', ParserName);
  R.Description:=Description;

  Result:=R.AsSQL;
  R.Free;
end;

function TPGFTSConfigurations.GetCaptionFullPatch: string;
begin
  Result:=FmtObjName((OwnerRoot as TPGFTSConfigurationsRoot).Schema, Self)
end;

constructor TPGFTSConfigurations.Create(const ADBItem: TDBItem;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FOID:=ADBItem.ObjId;
end;

destructor TPGFTSConfigurations.Destroy;
begin
  inherited Destroy;
end;

procedure TPGFTSConfigurations.RefreshObject;
var
  Q: TZQuery;
begin
  inherited RefreshObject;
  if State = sdboEdit then
  begin
    Q:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlFts['pgFtsConfig']);
    try
      Q.ParamByName('oid').AsInteger:=FOID;
      Q.ParamByName('namespace').AsInteger:=(OwnerRoot as TPGDBRootObject).SchemaId;

      Q.Open;
      if Q.RecordCount>0 then
      begin
        //FOID:=Q.FieldByName('oid').AsInteger;
        //cfgname
        //cfgnamespace
        FParserID:=Q.FieldByName('cfgparser').AsInteger;
        FParserName:=Q.FieldByName('prsname').AsString;
        FDescription:=Q.FieldByName('description').AsString;
      end;
    finally
      Q.Free;
    end;
  end;
end;

class function TPGFTSConfigurations.DBClassTitle: string;
begin
  Result:='FTS Configurations';
end;

procedure TPGFTSConfigurations.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

function TPGFTSConfigurations.CreateSQLObject: TSQLCommandDDL;
begin
  Result:=TPGSQLCreateTextSearchConfig.Create(nil);
  Result.Name:=Caption;
  if Assigned(TPGFTSConfigurationsRoot(OwnerRoot).Schema) then
    TPGSQLCreateTextSearchConfig(Result).SchemaName:=TPGFTSConfigurationsRoot(OwnerRoot).Schema.Caption;
end;

procedure TPGFTSConfigurations.FillParsersList(const AList: TStrings);
var
  FQuery: TZQuery;
begin
  FQuery:=TSQLEnginePostgre(OwnerDB).GetSQLQuery(pgSqlTextModule.sqlFts['pgFTsParsersList']);
  FQuery.Open;
  while not FQuery.EOF do
  begin
    AList.Add(FQuery.FieldByName('prsname').AsString);
    FQuery.Next;
  end;
  FQuery.Close;
  FQuery.Free;
end;

{ TPGFTSTemplatesRoot }

function TPGFTSTemplatesRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sqlFts['pgFtsTempl'];
end;

function TPGFTSTemplatesRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) {and (AItem.ObjType = 'r') } and (AItem.SchemeID = SchemaId);
end;

constructor TPGFTSTemplatesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  if Assigned(AOwnerRoot) and (AOwnerRoot is TPGFTSRoot) then
    FSchema:=TPGFTSRoot(AOwnerRoot).FSchema;

  FDBObjectKind:=okFTSTemplate;
  FDropCommandClass:=TPGSQLDropTextSearch;
end;

function TPGFTSTemplatesRoot.GetObjectType: string;
begin
  Result:='FTS Templates';
end;

{ TPGFTSParsersRoot }

function TPGFTSParsersRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sqlFts['pgFTsParsers'];
 end;

function TPGFTSParsersRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) {and (AItem.ObjType = 'r') } and (AItem.SchemeID = SchemaId);
end;

constructor TPGFTSParsersRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  if Assigned(AOwnerRoot) and (AOwnerRoot is TPGFTSRoot) then
    FSchema:=TPGFTSRoot(AOwnerRoot).FSchema;

  FDBObjectKind:=okFTSParser;
  FDropCommandClass:=TPGSQLDropTextSearch;
end;

function TPGFTSParsersRoot.GetObjectType: string;
begin
  Result:='FTS Parsers';
end;

{ TPGFTSDictionaresRoot }

function TPGFTSDictionaresRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sqlFts['pgFtsDicts'];
end;

function TPGFTSDictionaresRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) {and (AItem.ObjType = 'r') } and (AItem.SchemeID = SchemaId);
end;

constructor TPGFTSDictionaresRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  if Assigned(AOwnerRoot) and (AOwnerRoot is TPGFTSRoot) then
    FSchema:=TPGFTSRoot(AOwnerRoot).FSchema;

  FDBObjectKind:=okFTSDictionary;
  FDropCommandClass:=TPGSQLDropTextSearch;
end;

function TPGFTSDictionaresRoot.GetObjectType: string;
begin
  Result:='FTS Dictionares';
end;

{ TPGFTSConfigurationsRoot }

function TPGFTSConfigurationsRoot.DBMSObjectsList: string;
begin
  Result:=pgSqlTextModule.sqlFts['pgFtsConfigs'];
end;

function TPGFTSConfigurationsRoot.DBMSValidObject(AItem: TDBItem): boolean;
begin
  Result:=Assigned(AItem) {and (AItem.ObjType = 'r') } and (AItem.SchemeID = SchemaId);
end;

constructor TPGFTSConfigurationsRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);

  if Assigned(AOwnerRoot) and (AOwnerRoot is TPGFTSRoot) then
    FSchema:=TPGFTSRoot(AOwnerRoot).FSchema;

  FDBObjectKind:=okFTSConfig;
  FDropCommandClass:=TPGSQLDropTextSearch;
end;

function TPGFTSConfigurationsRoot.GetObjectType: string;
begin
  Result:='FTS Configurations';
end;

{ TPGFTSRoot }
constructor TPGFTSRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);

  FConfigs:=TPGFTSConfigurationsRoot.Create(AOwnerDB, TPGFTSConfigurations, 'FTS Configurations', Self);
  FDictionares:=TPGFTSDictionaresRoot.Create(AOwnerDB, TPGFTSDictionares, 'FTS Dictionares', Self);
  FParsers:=TPGFTSParsersRoot.Create(AOwnerDB, TPGFTSParsers, 'FTS Parser', Self);
  FTemplates:=TPGFTSTemplatesRoot.Create(AOwnerDB, TPGFTSTemplate, 'FTS Templates', Self);
end;

destructor TPGFTSRoot.Destroy;
begin
  FreeAndNil(FConfigs);
  FreeAndNil(FDictionares);
  FreeAndNil(FParsers);
  FreeAndNil(FTemplates);
  inherited Destroy;
end;

procedure TPGFTSRoot.Clear;
begin
  inherited Clear;
end;

function TPGFTSRoot.GetObjectType: string;
begin
  Result:='FTS';
end;

end.

