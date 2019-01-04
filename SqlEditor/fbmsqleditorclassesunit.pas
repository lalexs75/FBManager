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

unit fbmSQLEditorClassesUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, SynHighlighterSQL, SynEditTypes, DB;

const
  MaxSQLRecentItems = 10;

type
  TSQLEditorPages = class;
  TSQLEditorFolder = class;
  TSQLEditorPagesEnumerator = class;

  { TSqlEditorPage }

  TSqlEditorPage = class
  private
    FCarretPos: TPoint;
    FFolder: TSQLEditorFolder;
    FID: integer;
    FModified: boolean;
    FName: string;
    FSelEnd: integer;
    FSelStart: integer;
    FSortOrder: integer;
    FSqlPageID:integer;
    FOwner:TSQLEditorPages;
    FText: string;
    function GetFolderName: string;
    procedure SetSortOrder(AValue: integer);
  public
    constructor Create(AOwner:TSQLEditorPages; const ASqlName, AFolderName:string);
    destructor Destroy; override;
    procedure Load;
    procedure SaveNew;
    procedure Save;
    procedure Clear;

    property Folder:TSQLEditorFolder read FFolder write FFolder;
    property FolderName:string read GetFolderName;
    property SortOrder:integer read FSortOrder write SetSortOrder;
    property ID:integer read FID;
    property CarretPos:TPoint read FCarretPos write FCarretPos;
    property SelStart:integer read FSelStart write FSelStart;
    property SelEnd:integer read FSelEnd write FSelEnd;
    property Modified:boolean read FModified write FModified;
    property Text:string read FText write FText;
    property Name:string read FName write FName;
  end;

  { TSQLEditorFolder }

  TSQLEditorFolder = class
  private
    FOwner: TSQLEditorPages;
    FFolderDesc: string;
    FFolderID: integer;
    FFolderName: string;
    FFolderSort: integer;
  public
    constructor Create(AOwner:TSQLEditorPages);
    procedure Save;
  public
    property FolderID:integer read FFolderID;
    property FolderSort:integer read FFolderSort;
    property FolderName:string read FFolderName write FFolderName;
    property FolderDesc:string read FFolderDesc write FFolderDesc;
  end;

  { TSQLEditorPages }

  TSQLEditorPages = class
  private
    FPages:TFPList;
    FFolders:TFPList;
    FOwnerDB:TObject;
    procedure Clear;
    function GetCount: integer;
    function GetDataBaseID: integer;
    function GetItem(AIndex: integer): TSqlEditorPage;
    function GetModified: boolean;
  public
    constructor Create(AOwnerDB:TObject);
    destructor Destroy; override;
    procedure Load;
    function FolderByID(AFolderID:integer):TSQLEditorFolder;
    function FolderByName(AFolderName:string):TSQLEditorFolder;

    function Add(const ACaption, AFolderName:string):TSqlEditorPage;
    function AddFolder(const ACaption:string):TSQLEditorFolder;
    procedure DeletePage(P:TSqlEditorPage);
    procedure DeleteFolder(F:TSQLEditorFolder);
    procedure ChangeAll;

    function GetEnumerator: TSQLEditorPagesEnumerator;
  public
    property Item[AIndex:integer]:TSqlEditorPage read GetItem; default;
    property Count:integer read GetCount;
    property Modified:boolean read GetModified;
    property DataBaseID:integer read GetDataBaseID;
  end;

  { TSQLEditorPagesEnumerator }

  TSQLEditorPagesEnumerator = class
  private
    FList: TSQLEditorPages;
    FPosition: Integer;
  public
    constructor Create(AList: TSQLEditorPages);
    function GetCurrent: TSqlEditorPage;
    function MoveNext: Boolean;
    property Current: TSqlEditorPage read GetCurrent;
  end;

type

  { TFBTSynSQLSyn }

  TFBTSynSQLSyn = class(TSynSQLSyn)
  protected
    function GetIdentChars: TSynIdentChars; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


type
  { TRecentFiles }

  TRecentFiles = class
  private
    FRecentType:integer;
    FItems:TStringList;
    FMaxFiles: integer;
    FSQLEngine:TSQLEngineAbstract;
    function GetCount: integer;
    function GetData(AIndex: integer): Integer;
    function GetItem(AIndex: integer): String;
  public
    constructor Create(AMaxFiles:integer; ARecentType:integer; ASQLEngine:TSQLEngineAbstract);
    destructor Destroy; override;
    procedure Refresh;
    procedure Add(const AFileName:string);
    property Count:integer read GetCount;
    property MaxFiles:integer read FMaxFiles;
    property Item[AIndex:integer]:String read GetItem; default;
    property Data[AIndex:integer]:Integer read GetData;
  end;

implementation
uses fbmToolsUnit, FileUtil, fbmStrConstUnit, fbmUserDataBaseUnit, Math,
  LazFileUtils, ibmanagertypesunit, LazUTF8;

{ TSQLEditorFolder }

constructor TSQLEditorFolder.Create(AOwner: TSQLEditorPages);
begin
  inherited Create;
  FOwner:=AOwner;
end;

procedure TSQLEditorFolder.Save;
begin
  UserDBModule.quSQLFoldersUpd.ParamByName('sql_editor_folders_name').AsString:=FFolderName;
  UserDBModule.quSQLFoldersUpd.ParamByName('sql_editor_folders_code').AsInteger:=FFolderSort;
  UserDBModule.quSQLFoldersUpd.ParamByName('sql_editor_folders_desc').AsString:=FFolderDesc;
  UserDBModule.quSQLFoldersUpd.ParamByName('db_database_id').AsInteger:=FOwner.DataBaseID;
  if FFolderID > -1 then
    UserDBModule.quSQLFoldersUpd.ParamByName('sql_editor_folders_id').AsInteger:=FFolderID
  else
    UserDBModule.quSQLFoldersUpd.ParamByName('sql_editor_folders_id').Clear;
  UserDBModule.quSQLFoldersUpd.ExecSQL;
  if FFolderID < 0 then
    FFolderID:=UserDBModule.GetLastID;
end;

{ TSQLEditorPagesEnumerator }

constructor TSQLEditorPagesEnumerator.Create(AList: TSQLEditorPages);
begin
  FList := AList;
  FPosition := -1;
end;

function TSQLEditorPagesEnumerator.GetCurrent: TSqlEditorPage;
begin
  Result := FList[FPosition];
end;

function TSQLEditorPagesEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TFBTSynSQLSyn }

function TFBTSynSQLSyn.GetIdentChars: TSynIdentChars;
begin
  Result:=inherited GetIdentChars;
  Include(Result, '$');
end;

constructor TFBTSynSQLSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  (TableNames as TStringList).Sorted:=true;
end;

{ TSqlEditorPage }

function TSqlEditorPage.GetFolderName: string;
begin
  if Assigned(FFolder) then
    Result:=FFolder.FolderName
  else
    Result:='';
end;

procedure TSqlEditorPage.SetSortOrder(AValue: integer);
begin
  if FSortOrder=AValue then Exit;
  FSortOrder:=AValue;

  if Assigned(FFolder) then
    UserDBModule.quSQLPagesUpdSO.ParamByName('sql_editor_folders_id').AsInteger:=FFolder.FFolderID
  else
    UserDBModule.quSQLPagesUpdSO.ParamByName('sql_editor_folders_id').Clear;
  UserDBModule.quSQLPagesUpdSO.ParamByName('sql_editors_sort_order').AsInteger:=FSortOrder;
  UserDBModule.quSQLPagesUpdSO.ParamByName('sql_editors_id').AsInteger:=FID;
  UserDBModule.quSQLPagesUpdSO.ExecSQL;
  Modified:=false;
end;

constructor TSqlEditorPage.Create(AOwner: TSQLEditorPages; const ASqlName,
  AFolderName: string);
begin
  inherited Create;
  FOwner:=AOwner;
  Name:=ASqlName;
  FCarretPos.X:=1;
  FCarretPos.Y:=1;
  SelStart:=0;
  SelEnd:=0;

  if Assigned(FOwner) and (AFolderName <> '') then
    FFolder:=FOwner.FolderByName(AFolderName);

  Modified:=false;
end;

destructor TSqlEditorPage.Destroy;
begin
  if Assigned(FOwner) then
    FOwner.FPages.Remove(Self);
  inherited Destroy;
end;

procedure TSqlEditorPage.Load;
begin
  FID:=UserDBModule.quSQLPagessql_editors_id.AsInteger;
  FName:=UserDBModule.quSQLPagessql_editors_caption.AsString;
  FCarretPos.X:=Max(UserDBModule.quSQLPagessql_editors_carret_pos_x.AsInteger, 1);
  FCarretPos.Y:=Max(UserDBModule.quSQLPagessql_editors_carret_pos_y.AsInteger, 1);
  SelStart:=Max(UserDBModule.quSQLPagessql_editors_sel_start.AsInteger, 1);
  SelEnd:=Max(UserDBModule.quSQLPagessql_editors_sel_end.AsInteger, 1);
  FText:=UserDBModule.quSQLPagessql_editors_body.AsString;
  if Assigned(FOwner) then
    FFolder:=FOwner.FolderByID(UserDBModule.quSQLPagessql_editor_folders_id.AsInteger);
  FSortOrder:=UserDBModule.quSQLPagessql_editors_sort_order.AsInteger;
end;


procedure TSqlEditorPage.SaveNew;
var
  AFileName:string;
begin
  UserDBModule.quSQLPagesIns.ParamByName('db_database_id').AsInteger:=FOwner.DataBaseID;
  if Assigned(FFolder) then
    UserDBModule.quSQLPagesIns.ParamByName('sql_editor_folders_id').AsInteger:=FFolder.FFolderID
  else
    UserDBModule.quSQLPagesIns.ParamByName('sql_editor_folders_id').Clear;
  UserDBModule.quSQLPagesIns.ParamByName('sql_editors_caption').AsString:=FName;
  UserDBModule.quSQLPagesIns.ParamByName('sql_editors_sort_order').AsInteger:=FSortOrder;
  UserDBModule.quSQLPagesIns.ParamByName('sql_editors_carret_pos_x').AsInteger:=CarretPos.X;
  UserDBModule.quSQLPagesIns.ParamByName('sql_editors_carret_pos_y').AsInteger:=CarretPos.Y;
  UserDBModule.quSQLPagesIns.ParamByName('sql_editors_sel_start').AsInteger:=SelStart;
  UserDBModule.quSQLPagesIns.ParamByName('sql_editors_sel_end').AsInteger:=SelEnd;
  UserDBModule.quSQLPagesIns.ParamByName('sql_editors_body').AsString:=FText;
  UserDBModule.quSQLPagesIns.ExecSQL;
  FID:=UserDBModule.GetLastID;
  Modified:=false;
end;

procedure TSqlEditorPage.Save;
begin
  UserDBModule.quSQLPagesUpd.ParamByName('db_database_id').AsInteger:=FOwner.DataBaseID;
  if Assigned(FFolder) then
    UserDBModule.quSQLPagesUpd.ParamByName('sql_editor_folders_id').AsInteger:=FFolder.FFolderID
  else
    UserDBModule.quSQLPagesUpd.ParamByName('sql_editor_folders_id').Clear;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_caption').AsString:=FName;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_sort_order').AsInteger:=FSortOrder;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_carret_pos_x').AsInteger:=CarretPos.X;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_carret_pos_y').AsInteger:=CarretPos.Y;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_sel_start').AsInteger:=SelStart;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_sel_end').AsInteger:=SelEnd;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_body').AsString:=FText;
  UserDBModule.quSQLPagesUpd.ParamByName('sql_editors_id').AsInteger:=FID;
  UserDBModule.quSQLPagesUpd.ExecSQL;
  Modified:=false;
end;

procedure TSqlEditorPage.Clear;
begin
  FText:='';
  FCarretPos.SetLocation(1, 1);
  FSelStart:=0;
  FSelEnd:=0;
end;

{ TSQLEditorPages }

procedure TSQLEditorPages.Clear;
var
  P: TSqlEditorPage;
  i: Integer;
  F: TSQLEditorFolder;
begin
  for P in Self do
  begin
    P.FOwner:=nil;
    P.Free;
  end;
  FPages.Clear;

  for i:=0 to FFolders.Count - 1 do
  begin
    F:=TSQLEditorFolder(FFolders[i]);
    F.Free;
  end;
  FFolders.Clear;
end;

function TSQLEditorPages.GetCount: integer;
begin
  Result:=FPages.Count;
end;

function TSQLEditorPages.GetDataBaseID: integer;
begin
  Result:=TDataBaseRecord(FOwnerDB).SQLEngine.DatabaseID;
end;

function TSQLEditorPages.GetItem(AIndex: integer): TSqlEditorPage;
begin
  Result:=TSqlEditorPage(FPages[AIndex]);
end;

function TSQLEditorPages.GetModified: boolean;
var
  P: TSqlEditorPage;
begin
  Result:=false;
  for P in Self do
    if P.Modified then
      Exit(true);
end;

function TSQLEditorPages.FolderByID(AFolderID: integer): TSQLEditorFolder;
var
  i: Integer;
  F: TSQLEditorFolder;
begin
  Result:=nil;
  for i:=0 to FFolders.Count - 1 do
  begin
    F:=TSQLEditorFolder(FFolders[i]);
    if F.FFolderID = AFolderID then
      Exit(F);
  end;
end;

function TSQLEditorPages.FolderByName(AFolderName: string): TSQLEditorFolder;
var
  i: Integer;
  F: TSQLEditorFolder;
begin
  Result:=nil;
  for i:=0 to FFolders.Count - 1 do
  begin
    F:=TSQLEditorFolder(FFolders[i]);
    if UTF8UpperString(F.FFolderName) = UTF8UpperString(AFolderName) then
      Exit(F);
  end;
end;

procedure TSQLEditorPages.DeletePage(P: TSqlEditorPage);
begin
  if Assigned(P) and (P.FOwner = Self) then
  begin
    UserDBModule.quSQLPagesDel.ParamByName('sql_editors_id').AsInteger:=P.ID;
    UserDBModule.quSQLPagesDel.ExecSQL;
    P.Free;
  end;
end;

procedure TSQLEditorPages.DeleteFolder(F: TSQLEditorFolder);
begin

end;

constructor TSQLEditorPages.Create(AOwnerDB: TObject);
begin
  inherited Create;
  FPages:=TFPList.Create;
  FFolders:=TFPList.Create;
  FOwnerDB:=AOwnerDB;
end;

destructor TSQLEditorPages.Destroy;
begin
  Clear;
  FreeAndNil(FPages);
  FreeAndNil(FFolders);
  inherited Destroy;
end;

procedure TSQLEditorPages.Load;
var
  F: TSQLEditorFolder;
  P: TSqlEditorPage;
  C: Integer;
begin
  C:=DataBaseID;
  UserDBModule.quSQLFolders.ParamByName('db_database_id').AsInteger:=DataBaseID;
  UserDBModule.quSQLFolders.Open;
  while not UserDBModule.quSQLFolders.EOF do
  begin
    F:=AddFolder(UserDBModule.quSQLFolderssql_editor_folders_name.AsString);
    F.FFolderID:=UserDBModule.quSQLFolderssql_editor_folders_id.AsInteger;
    F.FFolderDesc:=UserDBModule.quSQLFolderssql_editor_folders_desc.AsString;
    F.FFolderSort:=UserDBModule.quSQLFolderssql_editor_folders_code.AsInteger;
    UserDBModule.quSQLFolders.Next;
  end;
  UserDBModule.quSQLFolders.Close;

  UserDBModule.quSQLPages.ParamByName('db_database_id').AsInteger:=DataBaseID;
  UserDBModule.quSQLPages.Open;
  while not UserDBModule.quSQLPages.EOF do
  begin
    P:=Add(UserDBModule.quSQLPagessql_editors_caption.AsString, '');
    P.Load;
    UserDBModule.quSQLPages.Next;
  end;
  UserDBModule.quSQLPages.Close;
end;
(*
procedure TSQLEditorPages.Save;
var
  i:integer;
  PageName, SQLFile, sNum:string;
  Page:TSqlEditorPage;
begin
(*  Stream.WriteInteger(IniSection, 'SqlPageCount', Count);
  Stream.WriteInteger(IniSection, 'SqlPageVersion', 1);
  for i:=0 to Count-1 do
  begin
    Page:=TSqlEditorPage(Items[i]);
    if Page.Modified then
    begin
      Stream.WriteString(IniSection, 'SQLEdit_Page_'+IntToStr(i+1), Page.FPageName);
      Page.SaveNew(Stream, IniSection, PageName, SaveFolder);
    end;
  end;*)
end;
*)
function TSQLEditorPages.Add(const ACaption, AFolderName: string
  ): TSqlEditorPage;
begin
  Result:=TSqlEditorPage.Create(Self, ACaption, AFolderName);
  FPages.Add(Result);
  Result.Modified:=true;
end;

function TSQLEditorPages.AddFolder(const ACaption: string): TSQLEditorFolder;
begin
  Result:=TSQLEditorFolder.Create(Self);
  FFolders.Add(Result);
  Result.FFolderName:=ACaption;
  Result.FFolderID:=-1;
end;

procedure TSQLEditorPages.ChangeAll;
var
  P: TSqlEditorPage;
begin
  for P in Self do P.Modified:=true;
end;

function TSQLEditorPages.GetEnumerator: TSQLEditorPagesEnumerator;
begin
  Result:=TSQLEditorPagesEnumerator.Create(Self);
end;

{ TRecentFiles }

function TRecentFiles.GetItem(AIndex: integer): String;
begin
  Result:=FItems[AIndex];
end;

function TRecentFiles.GetCount: integer;
begin
  Result:=FItems.Count;
end;

function TRecentFiles.GetData(AIndex: integer): Integer;
begin
  Result:=PtrInt(FItems.Objects[AIndex]);
end;

constructor TRecentFiles.Create(AMaxFiles: integer; ARecentType: integer;
  ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create;
  FItems:=TStringList.Create;
  FMaxFiles:=AMaxFiles;
  FSQLEngine:=ASQLEngine;
  FRecentType:=ARecentType;
end;

destructor TRecentFiles.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TRecentFiles.Refresh;
begin
  FItems.Clear;
  UserDBModule.quRecentItems.ParamByName('db_database_id').AsInteger:=FSQLEngine.DatabaseID;
  UserDBModule.quRecentItems.ParamByName('db_recent_objects_type').AsInteger:=FRecentType;
  UserDBModule.quRecentItems.Open;
  while not UserDBModule.quRecentItems.EOF do
  begin
    FItems.AddObject(UserDBModule.quRecentItemsdb_recent_objects_name.AsString,  TObject( Pointer(UserDBModule.quRecentItemsdb_recent_objects_id.AsInteger)));
    UserDBModule.quRecentItems.Next;
  end;
  UserDBModule.quRecentItems.Close;
end;

procedure TRecentFiles.Add(const AFileName: string);
var
  i:integer;
begin
  UserDBModule.quRecentItems.ParamByName('db_database_id').AsInteger:=FSQLEngine.DatabaseID;
  UserDBModule.quRecentItems.ParamByName('db_recent_objects_type').AsInteger:=FRecentType;
  UserDBModule.quRecentItems.Open;
  if UserDBModule.quRecentItems.Locate('db_recent_objects_name', AFileName, []) then
  begin
    UserDBModule.quRecentItems.Edit;
    UserDBModule.quRecentItemsdb_recent_objects_date.AsDateTime:=Now;
    UserDBModule.quRecentItems.Post;
    i:=FItems.IndexOf(AFileName);

    if I > 0 then
      FItems.Delete(i);
    if i <> 0 then
      FItems.Insert(0, AFileName);
  end
  else
  begin
    while (UserDBModule.quRecentItems.RecordCount > 0) and (UserDBModule.quRecentItems.RecordCount > FMaxFiles) do
      UserDBModule.quRecentItems.Delete;
    UserDBModule.quRecentItems.Append;
    UserDBModule.quRecentItemsdb_recent_objects_date.AsDateTime:=Now;
    UserDBModule.quRecentItemsdb_recent_objects_name.AsString:=AFileName;
    UserDBModule.quRecentItemsdb_database_id.AsInteger:=FSQLEngine.DatabaseID;
    UserDBModule.quRecentItemsdb_recent_objects_type.AsInteger:=FRecentType;
    UserDBModule.quRecentItems.Post;
    FItems.Insert(0, AFileName);
  end;
  UserDBModule.quRecentItems.Close;
end;

end.

