{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmOIFoldersUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, ComCtrls, DB;

type
  TOIFolderListEnumerator = class;
  TOIFolderList = class;

  { TOIFolder }

  TOIFolder = class
  private
    FFolderList:TOIFolderList;
    FDescription: string;
    FFolderID: integer;
    FOwner:TTreeNode;
    FExpanded:boolean;
    FSortOrder:integer;
    function GetName: string;
    procedure SetName(AValue: string);
  public
    constructor Create(AOwner:TTreeNode);
    destructor Destroy; override;
    procedure Save;
    procedure Load;
    function Edit:boolean;
    procedure Delete;
    procedure AfterLoad;

    property Owner:TTreeNode read FOwner;
    property Name:string read GetName write SetName;
    property Description:string read FDescription write FDescription;
    property FolderID:integer read FFolderID;
    property SortOrder:integer read FSortOrder write FSortOrder;
  end;

  { TOIFolderList }

  TOIFolderList = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItem(AIndex: integer): TOIFolder;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AOwner:TTreeNode):TOIFolder;
    function GetEnumerator: TOIFolderListEnumerator;
    function ByName(AFolderName:string):TOIFolder;
    function ByID(AFolderID:integer):TOIFolder;
    procedure SaveAll;
  public
    property Item[AIndex:integer]:TOIFolder read GetItem; default;
    property Count:integer read GetCount;
  end;

  { TOIFolderListEnumerator }

  TOIFolderListEnumerator = class
  private
    FList: TOIFolderList;
    FPosition: Integer;
  public
    constructor Create(AList: TOIFolderList);
    function GetCurrent: TOIFolder;
    function MoveNext: Boolean;
    property Current: TOIFolder read GetCurrent;
  end;

implementation

uses Forms, Controls, LazUTF8, fbmOIFolder_EditUnit, fbmUserDataBaseUnit,
  IBManDataInspectorUnit;

{ TOIFolderListEnumerator }

constructor TOIFolderListEnumerator.Create(AList: TOIFolderList);
begin
  FList := AList;
  FPosition := -1;
end;

function TOIFolderListEnumerator.GetCurrent: TOIFolder;
begin
  Result := FList[FPosition];
end;

function TOIFolderListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TOIFolderList }

function TOIFolderList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TOIFolderList.GetItem(AIndex: integer): TOIFolder;
begin
  Result:=TOIFolder(FList[AIndex]);
end;

procedure TOIFolderList.Clear;
var
  F: TOIFolder;
begin
  for F in Self do
  begin
    F.FFolderList:=nil;
    F.Free;
  end;
  FList.Clear;
end;

constructor TOIFolderList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TOIFolderList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

function TOIFolderList.Add(AOwner: TTreeNode): TOIFolder;
begin
  Result:=TOIFolder.Create(AOwner);
  FList.Add(Result);
  Result.FFolderList:=Self;
  Result.FSortOrder:=FList.Count;
end;

function TOIFolderList.GetEnumerator: TOIFolderListEnumerator;
begin
  Result:=TOIFolderListEnumerator.Create(Self);
end;

function TOIFolderList.ByName(AFolderName: string): TOIFolder;
var
  F: TOIFolder;
begin
  Result:=nil;
  for F in Self do
    if UTF8UpperCase(F.Name) = UTF8UpperCase(AFolderName) then
      Exit(F)
end;

function TOIFolderList.ByID(AFolderID: integer): TOIFolder;
var
  F: TOIFolder;
begin
  Result:=nil;
  for F in Self do
    if F.FFolderID = AFolderID then
      Exit(F)
end;

procedure TOIFolderList.SaveAll;
var
  F: TOIFolder;
begin
  for F in Self do
    F.Save;
end;

{ TOIFolder }

procedure TOIFolder.SetName(AValue: string);
begin
  FOwner.Text:=AValue;
end;

function TOIFolder.GetName: string;
begin
  Result:=FOwner.Text;
end;

constructor TOIFolder.Create(AOwner: TTreeNode);
begin
  inherited Create;
  FOwner:=AOwner;
  FOwner.ImageIndex:=27;
  FOwner.StateIndex:=27;
  FOwner.SelectedIndex:=27;
  FOwner.Data:=Self;
  FFolderID:=-1;
end;

destructor TOIFolder.Destroy;
begin
  if Assigned(FFolderList) then
    FFolderList.FList.Remove(Self);
  inherited Destroy;
end;

procedure TOIFolder.Save;
begin
  UserDBModule.quFoldersItem.ParamByName('db_folders_id').AsInteger:=FFolderID;
  UserDBModule.quFoldersItem.Open;
  if UserDBModule.quFoldersItem.RecordCount > 0 then
    UserDBModule.quFoldersItem.Edit
  else
    UserDBModule.quFoldersItem.Append;
  UserDBModule.quFoldersItemdb_folders_code.AsInteger:=FSortOrder;
  UserDBModule.quFoldersItemdb_folders_name.AsString:=Name;
  UserDBModule.quFoldersItemdb_folders_desc.AsString:=FDescription;
  UserDBModule.quFoldersItemdb_folders_expanded.AsBoolean:=FOwner.Expanded;
  UserDBModule.quFoldersItem.Post;
  if FFolderID < 0 then
    FFolderID:=UserDBModule.GetLastID;
  UserDBModule.quFoldersItem.Close;
end;

procedure TOIFolder.Load;
begin
  FFolderID:=UserDBModule.quFoldersdb_folders_id.AsInteger;
  FSortOrder:=UserDBModule.quFoldersdb_folders_code.AsInteger;
  Name:=UserDBModule.quFoldersdb_folders_name.AsString;
  Description:=UserDBModule.quFoldersdb_folders_desc.AsString;
  FExpanded:=UserDBModule.quFoldersdb_folders_expanded.AsBoolean;
end;

function TOIFolder.Edit: boolean;
begin
  Result:=false;
  fbmOIFolder_EditForm:=TfbmOIFolder_EditForm.Create(Application);
  fbmOIFolder_EditForm.Edit1.Text:=Name;
  fbmOIFolder_EditForm.Memo1.Text:=Description;
  if fbmOIFolder_EditForm.ShowModal = mrOk then
  begin
    Name        := fbmOIFolder_EditForm.Edit1.Text;
    Description := fbmOIFolder_EditForm.Memo1.Text;
    Result:=true;
  end;
  fbmOIFolder_EditForm.Free;
end;

procedure TOIFolder.Delete;
var
  i: Integer;
begin
  fbManDataInpectorForm.TreeView1.BeginUpdate;
  try
    for i:=0 to fbManDataInpectorForm.DBList.Count-1 do
      if fbManDataInpectorForm.DBList[i].OIFolder = Self then
        fbManDataInpectorForm.DBList[i].OIFolder:= nil;
    FOwner.Free;
  finally
    fbManDataInpectorForm.TreeView1.EndUpdate;
  end;

  UserDBModule.quFoldersDel.ParamByName('db_folders_id').AsInteger:=FFolderID;
  UserDBModule.quFoldersDel.ExecSQL;
end;

procedure TOIFolder.AfterLoad;
begin
  FOwner.Expanded:=FExpanded;
end;

end.

