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

unit fbm_VisualEditorsAbstractUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, IniFiles, contnrs, cfAbstractConfigFrameUnit, fdbm_PagedDialogPageUnit,
  SQLEngineAbstractUnit, fdmAbstractEditorUnit, SynHighlighterSQL;

type
  TEditorClassPagesArray = array of TEditorPageClass;

  TOnCreateNewDBObject = procedure(Editor:TForm; DBObject:TDBObject) of object;
  { TMenuItemRec }

  TMenuItemRec = record
    ItemName:string;
    ItemHint:string;
    ImageIndex:integer;
    OnClick:TNotifyEvent;
  end;

  { TDBObjEditorsRec }

  TDBObjEditorsRec = class
  private
    function GetCountPgCreate: integer;
    function GetCountPgEdit: integer;
  public
    FDBObjectClass:TDBObjectClass;
    FPgCreate:TEditorClassPagesArray;
    FPgEdit:TEditorClassPagesArray;
    constructor Create;
    destructor Destroy; override;
    property CountPgCreate:integer read GetCountPgCreate;
    property CountPgEdit:integer read GetCountPgEdit;
  end;

  { TDBVisualTools }

  TDBVisualTools = class
  private
    FSQLEngine:TSQLEngineAbstract;
    FObjEditors:TObjectList;
    function FindDBObjEditorsRec(ADBObject:TDBObject) : TDBObjEditorsRec;
  protected
    function GetConfigPagesCount: integer;virtual; abstract;
    procedure RegisterObjEditor(ADBObjectClass:TDBObjectClass; const APgCreate:array of const; const APgEdit:array of const);

  public
    constructor Create(ASQLEngine:TSQLEngineAbstract);virtual;
    destructor Destroy; override;
    procedure InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);virtual;abstract;

    property ConfigPagesCount:integer read GetConfigPagesCount;
    function GetConfigPage(Index: integer; Owner:TComponent): TFBMConfigPageAbstract;virtual;abstract;

    function EditPageCount(ADBObject:TDBObject):integer;
    function EditPage(ADBObject:TDBObject; AOwner:TComponent; AItem:integer):TFrame;

    //Create connection dialog functions
    class function ConnectionDlgPageCount:integer;virtual;
    class function ConnectionDlgPage(ASQLEngine:TSQLEngineAbstract; APageNum:integer; AOwner:TForm):TPagedDialogPage;virtual;abstract;
    class function ConfigDlgPageCount:integer;virtual;
    class function ConfigDlgPage(APageNum:integer; AOwner:TForm):TFBMConfigPageAbstract;virtual;abstract;
    class function GetObjTemplatePagesCount:integer; virtual;
    class function GetObjTemplate(Index: integer; Owner:TComponent): TFBMConfigPageAbstract;virtual; abstract;
    class function GetCreateObject:TSQLEngineCreateDBAbstractClass; virtual; abstract;
    class function GetMenuItems(Index: integer): TMenuItemRec; virtual; abstract;
    class function GetMenuItemCount:integer; virtual;

    procedure StoreConfig(const Ini:TIniFile); virtual;
    procedure LoadConfig(const Ini:TIniFile); virtual;

    property SQLEngine:TSQLEngineAbstract read FSQLEngine;
  end;

  TDBVisualToolsClass = class of TDBVisualTools;

  TRegisterSQLEngineRecord = record
    VisualToolsClass:TDBVisualToolsClass;
    SQLEngineClass:TSQLEngineAbstractClass;
    Description:string;
  end;

var
  SQLEngineAbstractClassArray : array [0..100] of TRegisterSQLEngineRecord;
  SQLEngineAbstractClassCount : integer = 0;

function CreateSQLEngine(ClassName:string):TSQLEngineAbstract;
procedure RegisterSQLEngine(ASQLEngineAbstractClass:TSQLEngineAbstractClass; ADBVisualToolsclass:TDBVisualToolsClass; ASQLEngineDescription:string);
procedure FillSQLEngineNames(ASQLEngineNames:TStrings);
implementation

function CreateSQLEngine(ClassName: string): TSQLEngineAbstract;
var
  i:integer;
begin
  for i:=0 to  SQLEngineAbstractClassCount-1 do
    if SQLEngineAbstractClassArray[i].SQLEngineClass.ClassName = ClassName then
    begin
      Result:=SQLEngineAbstractClassArray[i].SQLEngineClass.Create;
      exit;
    end;
  Result:=nil;
end;

procedure RegisterSQLEngine(ASQLEngineAbstractClass:TSQLEngineAbstractClass; ADBVisualToolsclass:TDBVisualToolsClass; ASQLEngineDescription:string);
begin
  SQLEngineAbstractClassArray[SQLEngineAbstractClassCount].SQLEngineClass:=ASQLEngineAbstractClass;
  SQLEngineAbstractClassArray[SQLEngineAbstractClassCount].VisualToolsClass:=ADBVisualToolsclass;
  SQLEngineAbstractClassArray[SQLEngineAbstractClassCount].Description:=ASQLEngineDescription;
  inc(SQLEngineAbstractClassCount);
end;

procedure FillSQLEngineNames(ASQLEngineNames: TStrings);
var
  i:integer;
begin
  ASQLEngineNames.Clear;
  for i:=0 to SQLEngineAbstractClassCount-1 do
    ASQLEngineNames.Add(SQLEngineAbstractClassArray[i].SQLEngineClass.ClassName);
end;

procedure ClearSQLEngineAbstractClassArray;
begin
  SQLEngineAbstractClassCount:=0;
end;

{ TDBObjEditorsRec }

function TDBObjEditorsRec.GetCountPgCreate: integer;
begin
  Result:=Length(FPgCreate);

end;

function TDBObjEditorsRec.GetCountPgEdit: integer;
begin
  Result:=Length(FPgEdit);
end;

constructor TDBObjEditorsRec.Create;
begin
  inherited Create;
  SetLength(FPgCreate, 0);
  SetLength(FPgEdit, 0);
end;

destructor TDBObjEditorsRec.Destroy;
begin
  SetLength(FPgCreate, 0);
  SetLength(FPgEdit, 0);
  inherited Destroy;
end;

{ TDBVisualTools }

class function TDBVisualTools.GetObjTemplatePagesCount: integer;
begin
  Result:=0;
end;

class function TDBVisualTools.GetMenuItemCount: integer;
begin
  Result:=0;
end;

function TDBVisualTools.FindDBObjEditorsRec(ADBObject: TDBObject
  ): TDBObjEditorsRec;
var
  i: Integer;
begin
  Assert(ADBObject = nil, 'TDBVisualTools.FindDBObjEditorsRec - ADBObject = nil');
  Result:=nil;
  for i:=0 to FObjEditors.Count-1 do
  begin
    if TDBObjEditorsRec(FObjEditors[i]).FDBObjectClass = ADBObject.ClassType then
    begin
      Result:=TDBObjEditorsRec(FObjEditors[i]);
      exit;
    end;
  end;
  raise Exception.CreateFmt('Not found object editor for DBObject class: %s', [ADBObject.ClassName]);
end;

procedure TDBVisualTools.RegisterObjEditor(ADBObjectClass: TDBObjectClass;
  const APgCreate: array of const; const APgEdit: array of const);
var
  R: TDBObjEditorsRec;
  i: Integer;
begin
  R:=TDBObjEditorsRec.Create;
  FObjEditors.Add(R);
  R.FDBObjectClass:=ADBObjectClass;

  SetLength(R.FPgCreate, Length(APgCreate));
  for i:=0 to Length(APgCreate)-1 do
    if APgCreate[i].VType = vtClass then
      R.FPgCreate[i]:=TEditorPageClass( APgCreate[i].VClass)
    else
      raise Exception.Create('TDBVisualTools.RegisterObjEditor');

  SetLength(R.FPgEdit, Length(APgEdit));
  for i:=0 to Length(APgEdit)-1 do
    if APgEdit[i].VType = vtClass then
      R.FPgEdit[i]:=TEditorPageClass( APgEdit[i].VClass)
    else
      raise Exception.Create('TDBVisualTools.RegisterObjEditor');
end;

constructor TDBVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create;
  FSQLEngine:=ASQLEngine;
  FObjEditors:=TObjectList.Create;
end;

destructor TDBVisualTools.Destroy;
begin
  FreeAndNil(FObjEditors);
  inherited Destroy;
end;

class function TDBVisualTools.ConnectionDlgPageCount: integer;
begin

end;

function TDBVisualTools.EditPageCount(ADBObject: TDBObject): integer;
var
  R: TDBObjEditorsRec;
begin
  R:=FindDBObjEditorsRec(ADBObject);
  if ADBObject.State = sdboCreate then
    Result:=R.CountPgCreate
  else
    Result:=R.CountPgEdit;
end;

function TDBVisualTools.EditPage(ADBObject: TDBObject; AOwner: TComponent;
  AItem: integer): TFrame;
var
  R: TDBObjEditorsRec;
begin
  R:=FindDBObjEditorsRec(ADBObject);
  if ADBObject.State = sdboCreate then
    Result:=R.FPgCreate[AItem].CreatePage(AOwner, ADBObject)
  else
    Result:=R.FPgEdit[AItem].CreatePage(AOwner, ADBObject);
end;

class function TDBVisualTools.ConfigDlgPageCount: integer;
begin

end;

procedure TDBVisualTools.StoreConfig(const Ini: TIniFile);
begin

end;

procedure TDBVisualTools.LoadConfig(const Ini: TIniFile);
begin

end;


initialization
finalization
  ClearSQLEngineAbstractClassArray;
end.

