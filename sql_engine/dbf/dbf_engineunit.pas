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

unit dbf_engineunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, dbf, db, Forms, fdmAbstractEditorUnit,
  SQLEngineCommonTypesUnit, fdbm_PagedDialogPageUnit, sqlObjects, SQLEngineInternalToolsUnit;


type
  TDBFEngine = class;

  { TDbfTablesRoot }

  TDbfTablesRoot = class(TDBRootObject)
  protected
    function DBMSObjectsList:string; override;
  public
    function GetObjectType: string;override;
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
  end;

  TDbfTable = class(TDBTableObject)
  private
    FFileName:string;
  protected
    procedure RefreshFieldList; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot:TDBRootObject); override;
    class function DBClassTitle:string;override;
    function DataSet(ARecCountLimit:Integer):TDataSet;override;
    destructor Destroy; override;
    procedure IndexListRefresh; override;
{
    procedure FieldEdit(const FieldName:string);override;
    function FieldNew:string;override;
    procedure FieldDelete(const FieldName:string);override;
}
  end;
  
  { TDBFEngine }

  TDBFEngine = class(TSQLEngineAbstract)
  private
  protected
    //function GetCountRootObject: integer; override;
    //function GetRootObject(AIndex:integer): TDBRootObject; override;
    //procedure SetConnected(const AValue: boolean);override;
    function InternalSetConnected(const AValue: boolean):boolean; override;
    procedure SetDataBaseName(const AValue: string);override;
    function GetCharSet: string;override;
    procedure SetCharSet(const AValue: string);override;
    class function GetEngineName: string; override;
    procedure InitGroupsObjects; override;
    procedure DoneGroupsObjects; override;
  public
    procedure SetSqlAssistentData(const List: TStrings); override;
    constructor Create; override;
    destructor Destroy; override;
    //Create connection dialog functions
    procedure RefreshObjectsBegin(const ASQLText:string; ASystemQuery:Boolean);override;
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit;

{ TDBFEngine }
(*
function TDBFEngine.GetCountRootObject: integer;
begin
  Result:=1;
end;

function TDBFEngine.GetRootObject(AIndex: integer): TDBRootObject;
begin
  case AIndex of
    0:Result:=FTablesRoot;
  else
    Result:=nil;
  end;
end;
*)
function TDBFEngine.InternalSetConnected(const AValue: boolean): boolean;
begin
  if not DirectoryExists(DataBaseName) then
    raise Exception.CreateFmt(sInvalidPath, [DataBaseName]);
  //inherited SetConnected(AValue);
  Result:=AValue;
end;

procedure TDBFEngine.SetDataBaseName(const AValue: string);
var
  S:string;
begin
  S:=TrimRight(AValue);
  if (S<>'') and (S[Length(S)] = DirectorySeparator) then
    S:=Copy(S, 1, Length(S)-1);
  inherited SetDataBaseName(S);
end;

function TDBFEngine.GetCharSet: string;
begin
  Result:='(none)';
end;

procedure TDBFEngine.SetCharSet(const AValue: string);
begin
  //
end;

class function TDBFEngine.GetEngineName: string;
begin
  Result:='DBF Tables';
end;

procedure TDBFEngine.InitGroupsObjects;
begin

end;

procedure TDBFEngine.DoneGroupsObjects;
begin

end;

procedure TDBFEngine.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
end;

constructor TDBFEngine.Create;
begin
  inherited Create;
  AddObjectsGroup(FTablesRoot, TDbfTablesRoot, TDbfTable, sTables);
  FUIParams:=[upLocal];
end;

destructor TDBFEngine.Destroy;
begin
  FreeAndNil(FTablesRoot);
  inherited Destroy;
end;

procedure TDBFEngine.RefreshObjectsBegin(const ASQLText: string;
  ASystemQuery: Boolean);
var
  DBObj: TDBItems;
  Rec: TRawByteSearchRec;
  Code: LongInt;
  P: TDBItem;
begin
  DBObj:=FCashedItems.AddTypes(ASQLText);
  if DBObj.CountUse = 1 then
  begin
    Code:=FindFirst(DataBaseName+DirectorySeparator+AllFilesMask1, faAnyFile, Rec);
    while Code = 0 do
    begin
      if Rec.Attr and faDirectory = 0 then
      begin
        if CompareText(ExtractFileExt(Rec.Name), '.DBF')=0 then
        begin
          P:=DBObj.Add(ExtractFileName(Rec.Name));
          P.ObjDesc:=Rec.Name;
          P.ObjData:=Rec.Name;
        end;
      end;
      Code:=FindNext(Rec);
    end;
    FindClose(Rec);
  end;
end;

{ TDbfTablesRoot }

function TDbfTablesRoot.DBMSObjectsList: string;
begin
  Result:=OwnerDB.DataBaseName;
end;

function TDbfTablesRoot.GetObjectType: string;
begin
  Result:='Table';
end;
(*
procedure TDbfTablesRoot.RefreshGroup;
var
  Rec:TSearchRec;
  Code:integer;
  D:TDbfTable;
  Ext:string;
begin
  FObjects.Clear;
  Code:=FindFirst(OwnerDB.DataBaseName+DirectorySeparator+AllFilesMask1, faAnyFile, Rec);
  while Code = 0 do
  begin
    if Rec.Attr and faDirectory = 0 then
    begin
      Ext:=UpperCase(ExtractFileExt(Rec.Name));
      if Ext = '.DBF' then
      begin
        D:=TDbfTable.Create(ExtractFileName(Rec.Name), Self);
        D.FFileName:=Rec.Name;
      end;
    end;
    Code:=FindNext(Rec);
  end;
  FindClose(Rec);
end;
*)
constructor TDbfTablesRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTable;
end;

{ TDbfTable }

constructor TDbfTable.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  inherited Create(ADBItem, AOwnerRoot);
  if Assigned(ADBItem) then
    FFileName:=ADBItem.ObjData;

  FDataSet:=TDbf.Create(nil);
  TDbf(FDataSet).FilePath:=OwnerDB.DataBaseName;
  TDbf(FDataSet).TableName:=FFileName;
  FDataSet.Active:=true;
end;

class function TDbfTable.DBClassTitle: string;
begin
  Result:=sTable;
end;


function TDbfTable.DataSet(ARecCountLimit: Integer): TDataSet;
begin
  Result:=FDataSet;
end;

destructor TDbfTable.Destroy;
begin
  inherited Destroy;
end;

procedure TDbfTable.IndexListRefresh;
var
  i:integer;
  Rec:TIndexItem;
begin
  IndexArrayClear;
  if Assigned(FDataSet) and FDataSet.Active then
  begin
    for i:=0 to TDbf(FDataSet).IndexDefs.Count-1 do
    begin
      Rec:=IndexItems.Add(Trim(TDbf(FDataSet).IndexDefs[i].Name));
      Rec.Unique:=ixUnique in TDbf(FDataSet).IndexDefs[i].Options;
      Rec.Active:=true;
      Rec.IndexField:=TDbf(FDataSet).IndexDefs[i].IndexFile;
    end;
  end;
end;

procedure TDbfTable.RefreshFieldList;
var
  i:integer;
  Rec: TDBField;
begin
  if State <> sdboEdit then exit;
  Fields.Clear;
  for i:=0 to TDbf(FDataSet).FieldDefs.Count - 1 do
  begin
    Rec:=Fields.Add(TDbf(FDataSet).FieldDefs[i].Name);
//    Rec.FieldTypeDB:=dbf.FieldDefs[i].DataType;
    Rec.FieldSQLTypeInt:=Ord(TDbf(FDataSet).FieldDefs[i].DataType);
    Rec.FieldTypeName:='';
    Rec.FieldTypeDomain:=TDbf(FDataSet).FieldDefs[i].ClassName;
    Rec.FieldSize:=TDbf(FDataSet).FieldDefs[i].Size;
    Rec.FieldPrec:=TDbf(FDataSet).FieldDefs[i].Precision;
    Rec.FieldUNIC:=false;
    Rec.FieldPK:=false;
    Rec.FieldNotNull:=faRequired in TDbf(FDataSet).FieldDefs[i].Attributes;
  end;
end;

initialization
finalization
end.

