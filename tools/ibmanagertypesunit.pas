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

unit ibmanagertypesunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, ComCtrls, Forms, Contnrs, SynHighlighterSQL, ZDataset, ZSqlUpdate,
  Graphics, SQLEngineCommonTypesUnit, SQLEngineAbstractUnit, fbmSqlParserUnit,
  DB, rxmemds, fbmSQLEditorClassesUnit, fbmToolsUnit, fbmOIFoldersUnit,
  fbm_VisualEditorsAbstractUnit, fdmAbstractEditorUnit, sqlObjects;

const
  CountRecentObject = 30;

type
  TDBInspectorRecordType = (rtDBObject, rtDBGroup, rtDataBase);

  TDBInspectorRecord = class;
  TDataBaseRecord = class;
  TDBInspectorRecordListEnumerator = class;

  { TDBInspectorRecordList }

  TDBInspectorRecordList = class
  private
    FList:TFPList;
    FDataBase:TDataBaseRecord;
    function GetCount: integer;
    function GetItems(AIndex: integer): TDBInspectorRecord;
  public
    constructor Create(ADataBase:TDataBaseRecord);
    destructor Destroy; override;
    function GetEnumerator: TDBInspectorRecordListEnumerator;
    function AddObject(aOwner:TTreeNode; ADBObject:TDBObject):TDBInspectorRecord;
    procedure Clear;
    property Count:integer read GetCount;
    property Items[AIndex:integer]:TDBInspectorRecord read GetItems; default;
  end;

  { TDBInspectorRecordListEnumerator }

  TDBInspectorRecordListEnumerator = class
  private
    FList: TDBInspectorRecordList;
    FPosition: Integer;
  public
    constructor Create(AList: TDBInspectorRecordList);
    function GetCurrent: TDBInspectorRecord;
    function MoveNext: Boolean;
    property Current: TDBInspectorRecord read GetCurrent;
  end;

  { TDBInspectorRecord }

  TDBInspectorRecord = class
  private
    FOwnerList:TDBInspectorRecordList;
    FImageIndex:integer;
    FRecordType: TDBInspectorRecordType;
    function GetCaptionFullPatch: string;
    function GetItem(const AName: string): TDBInspectorRecord;
    function GetObjectCount: integer;virtual;
    function GetObjectName(I: integer): string;virtual;
  protected
    FObjectList:TObjectList;
    FObjectListNew:TDBInspectorRecordList;
    FDBGroup:TDBRootObject;

    FCaption: string;
    function GetImageIndex:integer;virtual;
    function GetObjectType: string;virtual;
    function GetCaption: string;virtual;
    procedure SetCaption(const AValue: string);virtual;
    function GetDescription: string;virtual;
  public
    FOwner:TTreeNode;
    OwnerDB:TDataBaseRecord;
    ObjectEditor:TForm;
    CaptionColor:TColor;
    DBObject:TDBObject;
    constructor CreateObject(aOwner:TTreeNode; AOwnerDB:TDataBaseRecord; ADBObject:TDBObject);
    constructor CreateGroup(aOwner:TTreeNode; AOwnerDB:TDataBaseRecord; ADBGroup:TDBRootObject);
    destructor Destroy; override;
    function NewObject:TDBObject;virtual;
    function Edit:boolean;virtual;
    procedure ShowObject;virtual;
    procedure Refresh;virtual;
    procedure UpdateCaption;
    procedure UpdateCaption1;
    procedure ShowSQLEditor;virtual;
    procedure SetSqlAssistentData(List:TStrings);virtual;
    procedure ObjectEditorSave;
    procedure ObjectEditorRestore;
    procedure SetFocus;
    procedure FillListForNames(AList:TStrings);
    procedure DropObject(AItem:TDBInspectorRecord);
    procedure DropObject(AObjectName:string); overload;
    function SelectObject(AObjectName: string):boolean;
    procedure OnCreateNewDBObject(Edt:TForm; ADBObject:TDBObject);
    procedure RenameTo(const ANewName:string);

    function EnableDropped:boolean;virtual;
    function EnableRename:boolean;virtual;
    function IncludedFields:boolean;virtual;
    procedure FillFieldList(List:TStrings);virtual;

    property Caption:string read GetCaption write SetCaption;
    property CaptionFullPatch:string read GetCaptionFullPatch;

    property Description:string read GetDescription {write SetDescription};
    property ObjectType:string read GetObjectType;

    property Item[AName:string]:TDBInspectorRecord read GetItem;
    property ObjectCount:integer read GetObjectCount;
    property ObjectName[I:integer]:string read GetObjectName;
    property RecordType:TDBInspectorRecordType read FRecordType;
  end;
  
  //DataBase main object

  { TDataBaseRecord }

  TDataBaseRecord = class(TDBInspectorRecord)
  private
    FRestoreDesctopState:boolean;
    FOIFolder: TOIFolder;
    FSortOrder: integer;
    FSqlEditors: TSQLEditorPages;
    FSynSQLSyn: TSynSQLSyn;
    FSQLEngine:TSQLEngineAbstract;
    FRootObjects:TList;
    FSQLEditorHistory1:TZQuery;
    FUpdateSQLEditorHistory1:TZUpdateSQL;
    FDBVisualTools:TDBVisualTools;
    function GetConnected: boolean;
    procedure SetConnected(const AValue: boolean);
    procedure MakeObjectTree;
    procedure DeleteObjectTree;
    procedure MakeSQLHistoryTable;
    procedure InitInternalObjects;
    procedure SetOIFolder(AValue: TOIFolder);
    procedure SQLBodyGetTextEvent(Sender: TField; var aText: string; DisplayText: Boolean);
    procedure InternalError(const S:string);
    function OnDeleteDBObject(ADBObject:TDBObject):boolean;
    procedure SQLEngineAfterConnect(const ASQLEngine: TSQLEngineAbstract);
    procedure SQLEngineAfterDisconnect(const ASQLEngine: TSQLEngineAbstract);
  protected
    function GetImageIndex:integer; override;
    procedure SaveDesktop;
    procedure LoadDesktop;
    procedure AddToRecent(AItem:TDBInspectorRecord);

    procedure InitSQLEngine(ASQLEngine:TSQLEngineAbstract);
    function GetDescription: string; override;
  public
    ProgectID:integer;

    FSQLEditorForm: TForm;
    RecentDBItems:TRecentFiles;
    RecentSQLScrip:TRecentFiles;

    constructor Create(aOwner:TTreeNode; ASQLEngine:TSQLEngineAbstract);
    constructor Load(aOwner:TTreeNode; ADB, ADBPlugins:TDataSet);
    destructor Destroy; override;
    procedure WriteSQLFile(FileName, LogString:string);
    procedure Save;
    function Edit:boolean;override;
    procedure ShowObject;override;
    procedure SetSqlAssistentData(List:TStrings);override;
    procedure ShowSQLEditor;override;
    procedure Refresh;override;
    function NewObject:TDBObject;override;
    procedure ObjectShowEditor(const AObjName:string);
    function EnableDropped:boolean;override;
    function StrTranslate(aFromDB:boolean; const S:string):string;
    function NewObjectByKind(AOwnerRoot: TDBRootObject; ADBObjectKind: TDBObjectKind):TDBObject;

    function EditObject(ADBObject:TDBObject):boolean;
    function RefreshObject(ADBObject:TDBObject):boolean;
    function CreateObject(ADBObjectKind: TDBObjectKind; AOwnerObject:TDBObject):TDBObject;

    function AliasFileItemName:string;

    function ObjectGroup(AObj:TDBInspectorRecord):TDBInspectorRecord;
    function FindDBObject(ADBObject:TDBObject):TDBInspectorRecord;
    function ExecSQLEditor(const Line, Plan:string; AExecTime:TDateTime; ASQLCommand:TSQLCommandAbstract; AEdtPageName:string):boolean;
    function GetDBObject(AObjName:string):TDBObject;
  public
    property Connected:boolean read GetConnected write SetConnected;
    property SQLEditorForm:TForm read FSQLEditorForm;
    property SynSQLSyn: TSynSQLSyn read FSynSQLSyn;
    property SQLEngine:TSQLEngineAbstract read FSQLEngine;
    property SQLEditorHistory:TZQuery read FSQLEditorHistory1;
    property OIFolder:TOIFolder read FOIFolder write SetOIFolder;
    property DBVisualTools:TDBVisualTools read FDBVisualTools;
    property SqlEditors:TSQLEditorPages read FSqlEditors;
    property SortOrder:integer read FSortOrder write FSortOrder;
  end;

function ExecSQLScript(List:TStrings; const ExecParams:TSqlExecParams; const ASQLEngine:TSQLEngineAbstract):boolean;
procedure WriteSQLGlobal(FileName, LogString, UserName:string; LogTimestamp:boolean);
implementation
uses Controls, fbmSQLEditorUnit, fbmCompileQestUnit, FileUtil, rxAppUtils,
  {$IFDEF DEBUG_LOG}rxlogging,{$ENDIF}
  IBManDataInspectorUnit, fbmRefreshObjTreeUnit,
  fbmDBObjectEditorUnit, typinfo, fbmConnectionEditUnit, fbmUserDataBaseUnit,
  IBManMainUnit, LazUTF8, LazFileUtils, Variants, fbmStrConstUnit
  {$IFNDEF WINDOWS}
  , iconvenc
  {$ENDIF}
  ;

function ExecSQLScript(List: TStrings; const ExecParams: TSqlExecParams;
  const ASQLEngine: TSQLEngineAbstract): boolean;
var
  i, j:integer;
  S:string;
  R: TDataBaseRecord;
  ObjRefresh:TObjTreeRefresh;
  P: TSQLParser;
  Stm: TSQLTextStatement;
begin
  Result:=false;
  R:=fbManDataInpectorForm.DBBySQLEngine(ASQLEngine);
  if not Assigned(R) then exit;

  ObjRefresh:=TObjTreeRefresh.Create(R);
  S:='';
  P:=TSQLParser.Create(S, R.SQLEngine);

  fbmCompileQestForm:=TfbmCompileQestForm.Create(Application);
  fbmCompileQestForm.CheckListBox1.Items.Clear;
  for i:=0 to List.Count-1 do
  begin
    S:=List[i];
    if S<>'' then
    begin
      J:=fbmCompileQestForm.CheckListBox1.Items.Add(S);
      fbmCompileQestForm.CheckListBox1.Checked[j]:=true;
    end;
  end;
  fbmCompileQestForm.SynEdit1.Highlighter:=R.SynSQLSyn;
  if fbmCompileQestForm.CheckListBox1.Items.Count>0 then
  begin
    fbmCompileQestForm.CheckListBox1.ItemIndex:=0;
    fbmCompileQestForm.CheckListBox1Click(fbmCompileQestForm.CheckListBox1);
  end;

  for i:=0 to fbmCompileQestForm.CheckListBox1.Count-1 do
  begin
    fbmCompileQestForm.CheckListBox1.Checked[i]:=true;
  end;

  if (not (sepShowCompForm in ExecParams)) or (fbmCompileQestForm.ShowModal=mrOk) then
  begin
    Result:=true;
    for i:=0 to fbmCompileQestForm.CheckListBox1.Items.Count-1 do
    begin
      if fbmCompileQestForm.CheckListBox1.Checked[i] then
      begin
        if R.SQLEngine.ExecSQL(fbmCompileQestForm.CheckListBox1.Items[i], ExecParams) then
        begin
          S:=TrimRight(fbmCompileQestForm.CheckListBox1.Items[i]);
          if (S<>'') and (S[Length(S)]<>';') then
            S:=S+';';

          P.SetSQL(S);
          P.ParseScript;
          for j:=0 to P.StatementCount-1 do
          begin
            Stm:=P.Statements[j];
            ObjRefresh.ProcessCommand(Stm.SQLCommand);
          end;

          if R.SQLEngine.SQLEngineLogOptions.LogMetadata then
          begin
            R.WriteSQLFile(R.SQLEngine.SQLEngineLogOptions.LogFileMetadata, S);
          end;
        end
        else
        begin
          Result:=false;
          break;
        end;
      end;
    end;
  end
  else
    Result:=false;
  fbmCompileQestForm.Free;

  if Result then;
    ObjRefresh.Execute;
  P.Free;
  ObjRefresh.Free;
end;

procedure WriteSQLGlobal(FileName, LogString, UserName: string; LogTimestamp: boolean);
var
  F:TextFile;
  S: String;
  B: Boolean;
begin
  S:=ExtractFileDir(FileName);
  B:=DirectoryIsWritable(S);
  if FileExistsUTF8(FileName) then
    B:=FileIsWritable(FileName);
  if B then
  begin
    AssignFile(F, FileName);
    try
      if FileExists( FileName) then Append(F)
      else Rewrite(F);
      if LogTimestamp then
      begin
        writeln(f);
        writeln(f, '/*------ '+UserName+' '+DateTimeToStr(Now)+' ------*/');
      end;
      writeln(f);
      writeln(f, LogString)
    finally
       CloseFile(F);
    end;
  end
  else
    ErrorBox(sErrorWriteLogFile, [FileName]);
end;

{ TDBInspectorRecordListEnumerator }

constructor TDBInspectorRecordListEnumerator.Create(
  AList: TDBInspectorRecordList);
begin
  FList := AList;
  FPosition := -1;
end;

function TDBInspectorRecordListEnumerator.GetCurrent: TDBInspectorRecord;
begin
  Result := FList[FPosition];
end;

function TDBInspectorRecordListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TDBInspectorRecordList }

function TDBInspectorRecordList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TDBInspectorRecordList.GetItems(AIndex: integer): TDBInspectorRecord;
begin
  Result:=TDBInspectorRecord(FList[AIndex]);
end;

constructor TDBInspectorRecordList.Create(ADataBase: TDataBaseRecord);
begin
  inherited Create;
  FDataBase:=ADataBase;
  FList:=TFPList.Create;
end;

destructor TDBInspectorRecordList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

function TDBInspectorRecordList.GetEnumerator: TDBInspectorRecordListEnumerator;
begin
  Result:=TDBInspectorRecordListEnumerator.Create(Self);
end;

function TDBInspectorRecordList.AddObject(aOwner: TTreeNode;
  ADBObject: TDBObject): TDBInspectorRecord;
begin
  Result:=TDBInspectorRecord.CreateObject(aOwner, FDataBase, ADBObject);
  Result.FOwnerList:=Self;
end;

procedure TDBInspectorRecordList.Clear;
var
  P: TDBInspectorRecord;
begin
  for P in Self do
  begin
    FList.Remove(P);
    P.FOwnerList:=nil;
    P.Free;
  end;
  FList.Clear;
end;

{ TDataBaseRecord }

function TDataBaseRecord.GetConnected: boolean;
begin
  Result:=FSQLEngine.Connected;
end;

procedure TDataBaseRecord.SetConnected(const AValue: boolean);
begin
  if FSQLEngine.Connected = AValue then exit;
  if not AValue then
    SaveDesktop; //Сохранять рабочий стол надо пока её всё живо

  FSQLEngine.Connected:=AValue;
  if FSQLEngine.Connected then
  begin
    {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'FSQLEngine.RefreshObjectsBeginFull');{$ENDIF}
    FSQLEngine.RefreshObjectsBeginFull;
    {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'MakeObjectTree');{$ENDIF}
    MakeObjectTree;
    {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'FOwner.Expanded:=true');{$ENDIF}
    FOwner.Expand(false);
    FOwner.Expanded:=true;
    {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'Refresh;');{$ENDIF}
    Refresh;
    {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'FSQLEngine.RefreshObjectsEndFull;');{$ENDIF}
    FSQLEngine.RefreshObjectsEndFull;
    if ConfigValues.ByNameAsBoolean('RestoreDBDesktop', true) then
    begin
      {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'LoadDesktop;');{$ENDIF}
      LoadDesktop; //Загружать надо - когда уже всё живо
    end;

    {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'FSQLEditorHistory1.Open;');{$ENDIF}
    FSQLEditorHistory1.ParamByName('db_database_id').AsInteger:=FSQLEngine.DatabaseID;
    FSQLEditorHistory1.Open;
    FSQLEditorHistory1.FieldByName('sql_editors_history_sql_text').OnGetText:=@SQLBodyGetTextEvent;
    {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'Connected=true');{$ENDIF}
  end
  else
  begin
    FSQLEditorHistory1.Close;
    if Assigned(FSQLEditorForm) then
      FSQLEditorForm.Close;
    DeleteObjectTree;
  end;
  UpdateCaption;
end;

procedure TDataBaseRecord.MakeObjectTree;
var
  Grp:TDBInspectorRecord;
  P: TDBObject;
begin
  if not Assigned(FSQLEngine) then exit;
  FOwner.TreeView.BeginUpdate;
  try
    for P in FSQLEngine.Groups do
    begin
      Grp:=TDBInspectorRecord.CreateGroup((FOwner.TreeView as TTreeView).Items.AddChild(FOwner, P.Caption), Self, P as TDBRootObject);
      FRootObjects.Add(Grp);
      Grp.Refresh;
    end;
    FOwner.TreeView.EndUpdate;
  except
    FOwner.TreeView.EndUpdate;
    raise;
  end;
end;

procedure TDataBaseRecord.DeleteObjectTree;
var
  i:integer;
  Grp:TDBInspectorRecord;
begin
  FOwner.TreeView.BeginUpdate;
  for i:=0 to FRootObjects.Count-1 do
  begin
    Grp:=TDBInspectorRecord(FRootObjects[i]);
    Grp.Free;
  end;
  FOwner.TreeView.EndUpdate;
  FRootObjects.Clear;
end;

procedure TDataBaseRecord.WriteSQLFile(FileName, LogString: string);
  {$IFNDEF WINDOWS}
var
  S:String;
  {$ENDIF}
begin
{$IFNDEF WINDOWS}
  if SQLEngine.SQLEngineLogOptions.LogFileCodePage <> '' then
  begin
    Iconvert(LogString, S, 'UTF8', SQLEngine.SQLEngineLogOptions.LogFileCodePage);
    LogString:=TrimRight(S);
  end;
{$ENDIF}
  WriteSQLGlobal(FileName, LogString, SQLEngine.UserName, SQLEngine.SQLEngineLogOptions.LogTimestamp);
end;

procedure TDataBaseRecord.MakeSQLHistoryTable;
begin
  FUpdateSQLEditorHistory1:=TZUpdateSQL.Create(nil);
  FUpdateSQLEditorHistory1.DeleteSQL.Assign(UserDBModule.usSQLHistory.DeleteSQL);
  FUpdateSQLEditorHistory1.InsertSQL.Assign(UserDBModule.usSQLHistory.InsertSQL);
  FUpdateSQLEditorHistory1.ModifySQL.Assign(UserDBModule.usSQLHistory.ModifySQL);
  FSQLEditorHistory1:=TZQuery.Create(nil);

  FSQLEditorHistory1.Connection:=UserDBModule.UserDB;
  FSQLEditorHistory1.UpdateObject:=FUpdateSQLEditorHistory1;
  FSQLEditorHistory1.SQL.Assign(UserDBModule.quSQLHistory.SQL);
end;

procedure TDataBaseRecord.InitInternalObjects;
begin
  FSqlEditors:=TSQLEditorPages.Create(Self);
  FRootObjects:=TList.Create;
  FSynSQLSyn:=TFBTSynSQLSyn.Create(nil);
  FSynSQLSyn.Enabled:=true;
  FSynSQLSyn.TableNameAttri.Foreground:=clGreen;
  FSynSQLSyn.TableNameAttri.Style:=FSynSQLSyn.TableNameAttri.Style + [fsUnderline];
  FSynSQLSyn.CommentAttri.Foreground:=clBlue;
end;

procedure TDataBaseRecord.SetOIFolder(AValue: TOIFolder);
begin
  if FOIFolder=AValue then Exit;
  FOIFolder:=AValue;

  if Assigned(FOIFolder) then
    FOwner.MoveTo(FOIFolder.Owner, naAddChild)
  else
    FOwner.MoveTo(nil, naAdd);
end;

procedure TDataBaseRecord.SQLBodyGetTextEvent(Sender: TField;
  var aText: string; DisplayText: Boolean);
var
  i:integer;
begin
  aText:=FSQLEditorHistory1.FieldByName('sql_editors_history_sql_text').AsString;
  if DisplayText then
    for i:=1 to Length(aText) do
      if aText[i] in [#13, #10] then
        aText[i]:=' ';
end;

procedure TDataBaseRecord.InternalError(const S: string);
begin
  ErrorBox(S);
end;

function TDataBaseRecord.OnDeleteDBObject(ADBObject: TDBObject): boolean;
var
  R, G: TDBInspectorRecord;
begin
  LM_SendToAll(LM_NOTIFY_OBJECT_DELETE, ADBObject);
//  fbManDataInpectorForm.NotifyDestroyObject(ADBObject);
  R:=FindDBObject(ADBObject);
  if Assigned(R) then
  begin
    G:=ObjectGroup(R);
    if Assigned(G) then
    begin
      G.FObjectList.Extract(R);
      R.DBObject:=nil;
      //G.DBObject:=nil;
    end;
    R.Free;
  end;
  Result:=true;
end;

procedure TDataBaseRecord.SQLEngineAfterConnect(
  const ASQLEngine: TSQLEngineAbstract);
begin
  LM_SendToAll(LM_NOTIFY_CONNECT_ENGINE, FSQLEngine);
end;

procedure TDataBaseRecord.SQLEngineAfterDisconnect(
  const ASQLEngine: TSQLEngineAbstract);
begin
  LM_SendToAll(LM_NOTIFY_DISCONNECT_ENGINE, FSQLEngine);
end;

function TDataBaseRecord.AliasFileItemName: string;
var
  i:integer;
begin
  i:=fbManDataInpectorForm.DBList.IndexOf(Self);
  Result:='Item_'+IntToStr(i);
end;

function TDataBaseRecord.GetImageIndex: integer;
begin
  Result:=SQLEngine.ImageIndex;
end;

procedure TDataBaseRecord.SaveDesktop;

procedure DoSaveGrp(P:TDBInspectorRecord);
var
  i:integer;
begin
  if Assigned(P.ObjectEditor) then
    UserDBModule.SaveDesktop(P.CaptionFullPatch, SQLEngine.DatabaseID, 0);
  for i:=0 to P.ObjectCount-1 do
    DoSaveGrp(TDBInspectorRecord(P.FObjectList[i]));
end;

var
  Grp:TDBInspectorRecord;
  i, j:integer;
begin
  UserDBModule.ClearDesktop(SQLEngine.DatabaseID);
  for i:=0 to FRootObjects.Count-1 do
  begin
    Grp:=TDBInspectorRecord(FRootObjects[i]);
    for j:=0 to Grp.ObjectCount-1 do
      DoSaveGrp(Grp.FObjectList[j] as TDBInspectorRecord);
  end;
  if Assigned(FSQLEditorForm) then
    UserDBModule.SaveDesktop('FBM SQL EDITOR', SQLEngine.DatabaseID, 5);
end;

procedure TDataBaseRecord.LoadDesktop;
begin
  if not Assigned(FSQLEngine) then exit;
  FRestoreDesctopState:=true;
  UserDBModule.quRecentItems.ParamByName('db_database_id').AsInteger:=FSQLEngine.DatabaseID;
  UserDBModule.quRecentItems.ParamByName('db_recent_objects_type').AsInteger:=5;
  UserDBModule.quRecentItems.Open;
  try
    if UserDBModule.quRecentItems.RecordCount > 0 then
      ShowSQLEditor;
  finally
    UserDBModule.quRecentItems.Close;
  end;

  UserDBModule.quRecentItems.ParamByName('db_recent_objects_type').AsInteger:=0;
  try
    UserDBModule.quRecentItems.Open;
    while not UserDBModule.quRecentItems.EOF do
    begin
      ObjectShowEditor(UserDBModule.quRecentItemsdb_recent_objects_name.AsString);
      UserDBModule.quRecentItems.Next;
    end;
  finally
    UserDBModule.quRecentItems.Close;
  end;
  FRestoreDesctopState:=false;
end;

procedure TDataBaseRecord.AddToRecent(AItem: TDBInspectorRecord);
begin
  if not FRestoreDesctopState then
    RecentDBItems.Add(AItem.Caption);
end;

procedure TDataBaseRecord.InitSQLEngine(ASQLEngine: TSQLEngineAbstract);
var
  i: Integer;
begin
  FSQLEngine:=ASQLEngine;
  if Assigned(FSQLEngine) then
  begin
    RecentDBItems:=TRecentFiles.Create(CountRecentObject, 2, FSQLEngine);
    RecentSQLScrip:=TRecentFiles.Create(MaxSQLRecentItems, 4, FSQLEngine);

    Caption:=FSQLEngine.AliasName;
    FSQLEngine.OnNewObjectByKind:=@NewObjectByKind;
    FSQLEngine.OnEditObject:=@EditObject;
    FSQLEngine.OnRefreshObject:=@RefreshObject;
    FSQLEngine.OnCreateObject:=@CreateObject;
    FSQLEngine.OnInternalError:=@InternalError;
    FSQLEngine.OnDestroyObject:=@OnDeleteDBObject;
    FSQLEngine.OnAfterDisconnect:=@SQLEngineAfterDisconnect;
    FSQLEngine.OnAfterConnect:=@SQLEngineAfterConnect;


    for i:=0 to SQLEngineAbstractClassCount-1 do
    begin
      if SQLEngineAbstractClassArray[i].SQLEngineClass = FSQLEngine.ClassType then
      begin
        FDBVisualTools:=SQLEngineAbstractClassArray[i].VisualToolsClass.Create(ASQLEngine);
        Break;
      end;
    end;

    if Assigned(FDBVisualTools) then
    begin
      //FSynSQLSyn.SQLDialect:= FSQLEngine.SQLDialect;
      FDBVisualTools.InitSQLSyn(FSynSQLSyn);
    end;
  end;
end;

function TDataBaseRecord.GetDescription: string;
begin
  Result:=FSQLEngine.Description;
end;

constructor TDataBaseRecord.Create(aOwner: TTreeNode; ASQLEngine:TSQLEngineAbstract);
begin
  inherited CreateObject(aOwner, Self, nil);
  FRestoreDesctopState:=false;
  InitInternalObjects;
  InitSQLEngine(ASQLEngine);
  MakeSQLHistoryTable;
end;

constructor TDataBaseRecord.Load(aOwner: TTreeNode; ADB, ADBPlugins: TDataSet);
var
  SQLEngineName: String;
  i: Integer;
begin
  inherited CreateObject(aOwner, Self, nil);
  InitInternalObjects;
  SQLEngineName:=ADB.FieldByName('db_database_sql_engine').AsString;
  InitSQLEngine(CreateSQLEngine(SQLEngineName));

  if Assigned(FSQLEngine) then
  begin
    FSQLEngine.Properties.Clear;
    UserDBModule.quDBOptions.First;
    while not UserDBModule.quDBOptions.EOF do
    begin
      if UserDBModule.quDBOptionsdb_database_id.AsInteger = ADB.FieldByName('db_database_id').AsInteger then
        FSQLEngine.Properties.Values[UserDBModule.quDBOptionsdb_connection_options_name.AsString]:=UserDBModule.quDBOptionsdb_connection_options_value.AsString;
      UserDBModule.quDBOptions.Next;
    end;

    FSQLEngine.Load(ADB);
    for i:=0 to FSQLEngine.ConnectionPlugins.Count-1 do
      FSQLEngine.ConnectionPlugins.Load(ADBPlugins);

    Caption:=FSQLEngine.AliasName;
    FSortOrder:=ADB.FieldByName('db_database_sort_order').AsInteger;
  end
  else
    raise Exception.CreateFmt('Unknow SQL engine - %s',[SQLEngineName]);

  MakeSQLHistoryTable;

  OIFolder:=fbManDataInpectorForm.Folders.ByID(ADB.FieldByName('db_folders_id').AsInteger);
  FSqlEditors.Load;
end;

destructor TDataBaseRecord.Destroy;
begin
  FreeAndNil(FSqlEditors);
  FreeAndNil(FSynSQLSyn);
  FreeAndNil(FRootObjects);
  FreeAndNil(FSQLEditorHistory1);
  FreeAndNil(FUpdateSQLEditorHistory1);

  FreeAndNil(RecentDBItems);
  FreeAndNil(RecentSQLScrip);
  inherited Destroy;
  { TODO : Не верно работает очистка ресурсов }
  //FreeAndNil(FSQLEngine);
end;

procedure TDataBaseRecord.Save;
var
  SName, SValue: String;
  i: Integer;
begin
  if not Assigned(SQLEngine) then exit;
  if SQLEngine.DatabaseID > 0 then
    UserDBModule.quDatabasesItem.ParamByName('db_database_id').AsInteger:=SQLEngine.DatabaseID
  else
    UserDBModule.quDatabasesItem.ParamByName('db_database_id').Clear;
  UserDBModule.quDatabasesItem.Open;
  if UserDBModule.quDatabasesItem.RecordCount > 0 then
    UserDBModule.quDatabasesItem.Edit
  else
    UserDBModule.quDatabasesItem.Append;
  UserDBModule.quDatabasesItemdb_database_sql_engine.AsString:=FSQLEngine.ClassName;
  FSQLEngine.Store(UserDBModule.quDatabasesItem);

  if Assigned(OIFolder) then
    UserDBModule.quDatabasesItemdb_folders_id.AsInteger:=OIFolder.FolderID
  else
    UserDBModule.quDatabasesItemdb_folders_id.Clear;
  UserDBModule.quDatabasesItemdb_database_sort_order.AsInteger:=FSortOrder;
  UserDBModule.quDatabasesItem.Post;

  if SQLEngine.DatabaseID <= 0 then
    SQLEngine.DatabaseID:=UserDBModule.GetLastID;

  UserDBModule.quDatabasesItem.Close;

  UserDBModule.quConnectionPlugins.ParamByName('db_database_id').AsInteger:=SQLEngine.DatabaseID;
  UserDBModule.quConnectionPlugins.Open;
  FSQLEngine.ConnectionPlugins.Save(UserDBModule.quConnectionPlugins);
  UserDBModule.quConnectionPlugins.Close;


  UserDBModule.quDBOptionsItems.ParamByName('db_database_id').AsInteger:=SQLEngine.DatabaseID;
  UserDBModule.quDBOptionsItems.Open;
  for i:=0 to FSQLEngine.Properties.Count-1 do
  begin
    SName:=FSQLEngine.Properties.Names[i];
    SValue:=FSQLEngine.Properties.ValueFromIndex[i];
    if UserDBModule.quDBOptionsItems.Locate('db_database_id;db_connection_options_name', VarArrayOf([SQLEngine.DatabaseID, SName]), []) then
      UserDBModule.quDBOptionsItems.Edit
    else
    begin
      UserDBModule.quDBOptionsItems.Append;
      UserDBModule.quDBOptionsItemsdb_database_id.AsInteger:=SQLEngine.DatabaseID;
      UserDBModule.quDBOptionsItemsdb_connection_options_name.AsString:=SName;
    end;
    UserDBModule.quDBOptionsItemsdb_connection_options_value.AsString:=SValue;
    UserDBModule.quDBOptionsItems.Post;
  end;
  UserDBModule.quDBOptionsItems.Close;
end;

function TDataBaseRecord.Edit:boolean;
begin
  Result:=false;
  fbmConnectionEditForm:=TfbmConnectionEditForm.Create(SQLEngine);
  fbmConnectionEditForm.LoadParams(nil);
  if fbmConnectionEditForm.ShowModal = mrOk then
  begin
    Save;
    Caption:=FSQLEngine.AliasName;
    Result:=true;
  end;
  fbmConnectionEditForm.Free;
end;

procedure TDataBaseRecord.ShowObject;
begin
  Connected:=not Connected;
end;

procedure TDataBaseRecord.SetSqlAssistentData(List: TStrings);
begin
  SQLEngine.SetSqlAssistentData(List);
end;

procedure TDataBaseRecord.ShowSQLEditor;
begin
  if Connected and (upSqlEditor in SQLEngine.UIParams) then
  begin
    if not Assigned(FSQLEditorForm) then
    begin
      FSQLEditorForm:=TfbmSQLEditorForm.CreateSqlEditor(Self);
      fbManagerMainForm.RxMDIPanel1.ChildWindowsAdd(FSQLEditorForm);
    end
    else
      fbManagerMainForm.RxMDIPanel1.ShowWindow(FSQLEditorForm);
  end;
end;

procedure TDataBaseRecord.Refresh;

procedure DoRefresh(D:TDBRootObject);
var
  i:integer;
begin
  if not Assigned(D) then exit;

  for i:=0 to D.CountGroups - 1 do
    DoRefresh(D.Groups[i]);

  if D.DBObjectKind = okScheme then
    SynSQLSyn.TableNames.Add(D.Caption);

  if D.DBObjectKind in [
        {okDomain,} okTable, okPartitionTable, okView, {okTrigger,} okStoredProc, okMaterializedView,
        okSequence, okException, okUDF, okScheme{, okRole, okOther}, okFunction,
        okPackage] then
  begin
    for i:=0 to D.CountObject - 1 do
      SynSQLSyn.TableNames.Add(D.Items[i].Caption);
  end
end;

var
  P: TDBObject;
begin
  SynSQLSyn.TableNames.Clear;
  SynSQLSyn.TableNames.BeginUpdate;

  for P in FSQLEngine.Groups do
    DoRefresh(P as TDBRootObject);

  SynSQLSyn.TableNames.EndUpdate;
end;

function TDataBaseRecord.NewObject:TDBObject;
begin
  Result:=nil;
end;

procedure TDataBaseRecord.ObjectShowEditor(const AObjName: string);

function DoFindAndEditObj(AGrp:TDBInspectorRecord):boolean;
var
  Rec:TDBInspectorRecord;
begin
  Rec:=AGrp.Item[AObjName];
  Result:=Assigned(Rec);
  if Result then
    Rec.Edit;
end;
var
  P:TDBObject;
begin
  if AObjName='' then exit;
  P:=GetDBObject(AObjName);
  if Assigned(P) then
    P.Edit;
end;

function TDataBaseRecord.EnableDropped: boolean;
begin
  Result:=false;
end;

function TDataBaseRecord.StrTranslate(aFromDB: boolean; const S:string): string;
begin
  Result:=S
end;

function TDataBaseRecord.NewObjectByKind(AOwnerRoot: TDBRootObject;
  ADBObjectKind: TDBObjectKind): TDBObject;
var
  Grp:TDBInspectorRecord;
begin
  Result:=nil;
  Grp:=FindDBObject(AOwnerRoot);
  if Assigned(Grp) and (Grp.FDBGroup.DBObjectKind = ADBObjectKind) then
    Result:=Grp.NewObject;
end;

function TDataBaseRecord.EditObject(ADBObject: TDBObject): boolean;
var
  R: TDBInspectorRecord;
begin
  R:=FindDBObject(ADBObject);
  if Assigned(R) then
    Result:=R.Edit
  else
    Result:=false;
end;

function TDataBaseRecord.RefreshObject(ADBObject: TDBObject): boolean;
var
  R: TDBInspectorRecord;
begin
  R:=FindDBObject(ADBObject);
  if Assigned(R) then
  begin
    if Assigned(R.ObjectEditor) then
      TfbmDBObjectEditorForm(R.ObjectEditor).SendCmd(epaRefresh);
    Result:=true;
  end
  else
    Result:=false;
end;

function TDataBaseRecord.CreateObject(ADBObjectKind: TDBObjectKind;
  AOwnerObject: TDBObject): TDBObject;
var
  G:TDBInspectorRecord;
begin
  Result:=nil;
  G:=FindDBObject(AOwnerObject);
  if Assigned(G) then
    Result:=G.NewObject;
end;

{ this function return pointer to group class, contained selected item }
function TDataBaseRecord.ObjectGroup(AObj: TDBInspectorRecord
  ): TDBInspectorRecord;

procedure DoFind(P:TDBInspectorRecord);
var
  j:integer;
begin
  if P.FObjectList.IndexOf(AObj)>=0 then
  begin
    Result:=P;
    exit;
  end;

  for j:=0 to P.FObjectList.Count - 1 do
  begin
    DoFind(TDBInspectorRecord(P.FObjectList[j]));
    if Assigned(Result) then
      exit;
  end;
end;

var
  i:integer;
begin
  Result:=nil;
  for i:=0 to FRootObjects.Count-1 do
  begin
    DoFind(TDBInspectorRecord(FRootObjects[i]));
    if Assigned(Result) then
      exit;
  end;
end;

function TDataBaseRecord.FindDBObject(ADBObject: TDBObject): TDBInspectorRecord;

function DoFind(G:TDBInspectorRecord):TDBInspectorRecord;
var
  i:integer;
begin
  Result:=nil;
  if G.DBObject = ADBObject then
  begin
    Result:=G;
    exit;
  end;
  for i:=0 to G.ObjectCount - 1 do
  begin
    Result:=DoFind(TDBInspectorRecord(G.FObjectList[i]));
    if Assigned(Result) then exit;
  end;
end;

var
  Grp:TDBInspectorRecord;
  i:integer;
begin
  Result:=nil;
  if not Assigned(ADBObject) then exit;
  for i:=0 to FRootObjects.Count-1 do
  begin
    Grp:=TDBInspectorRecord(FRootObjects[i]);
    Result:=DoFind(Grp);
    if Assigned(Result) then exit
  end;
end;

function TDataBaseRecord.ExecSQLEditor(const Line, Plan: string;
  AExecTime: TDateTime; ASQLCommand: TSQLCommandAbstract; AEdtPageName: string
  ): boolean;
begin
  Result:=true;
  if FSQLEngine.SQLEngineLogOptions.LogSQLEditor then
    WriteSQLFile(FSQLEngine.SQLEngineLogOptions.LogFileSQLEditor, Line + ';');

  FSQLEditorHistory1.DisableControls;
  try
    while (FSQLEditorHistory1.RecordCount >= FSQLEngine.SQLEngineLogOptions.HistoryCountSQLEditor) and (FSQLEditorHistory1.RecordCount>1) do
    begin
      FSQLEditorHistory1.First;
      FSQLEditorHistory1.Delete;
    end;
    FSQLEditorHistory1.Append;
    FSQLEditorHistory1.FieldByName('db_database_id').AsInteger:=FSQLEngine.DatabaseID;
    FSQLEditorHistory1.FieldByName('sql_editors_history_date').AsDateTime:=Now;
    FSQLEditorHistory1.FieldByName('sql_editors_history_sql_text').AsString:=Line;
    FSQLEditorHistory1.FieldByName('sql_editors_history_sql_plan').AsString:=Plan;
    FSQLEditorHistory1.FieldByName('sql_editors_history_exec_time').AsDateTime:=AExecTime;
    FSQLEditorHistory1.FieldByName('sql_editors_history_sql_page_name').AsString:=AEdtPageName;

    if Assigned(ASQLCommand) then
      FSQLEditorHistory1.FieldByName('sql_editors_history_sql_type').AsInteger:=ord(ASQLCommand.SQLToken)-1;

    FSQLEditorHistory1.Post;
  finally
    FSQLEditorHistory1.EnableControls;
  end;
end;

function TDataBaseRecord.GetDBObject(AObjName: string): TDBObject;
var
  i:integer;
begin
  Result:=nil;
  AObjName:=UpperCase(AObjName);
  for i:=0 to FSQLEngine.Groups.Count - 1 do
  begin
    Result:=TDBRootObject(FSQLEngine.Groups[i]).ObjByName(AObjName);
    if Assigned(Result) then
      exit;
  end
end;

{ TDBInspectorRecord }

procedure TDBInspectorRecord.SetCaption(const AValue: string);
begin
  if FCaption=AValue then exit;
  FCaption:=AValue;
  UpdateCaption;
end;

function TDBInspectorRecord.GetCaption: string;
begin
  Result:=FCaption;
  if (RecordType = rtDBGroup) and Assigned(FObjectList) then
  begin
    if FObjectList.Count>0 then
      Result:=Result+' ('+IntToStr(FObjectList.Count)+')';
  end;
end;
(*
procedure TDBInspectorRecord.EditorFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(DBObject) then
    ObjectEditorSave;
  ObjectEditor:=nil;
  if Assigned(DBObject) and OwnerDB.Connected then
  begin
    //DBObject.Info:=nil;
    DBObject.OnCloseEditorWindow;
  end;
end;
*)
function TDBInspectorRecord.GetCaptionFullPatch: string;
begin
  if Assigned(DBObject) then
    Result:=DBObject.CaptionFullPatch
  else
    Result:=FCaption;
end;

function TDBInspectorRecord.GetItem(const AName: string): TDBInspectorRecord;
var
  i:integer;
begin
  for i:=0 to FObjectList.Count-1 do
    if CompareText(TDBInspectorRecord(FObjectList[i]).Caption, AName)=0 then
    begin
      Result:=TDBInspectorRecord(FObjectList[i]);
      exit;
    end;
  Result:=nil;
end;

function TDBInspectorRecord.GetObjectCount: integer;
begin
  Result:=FObjectList.Count;
end;

function TDBInspectorRecord.GetObjectName(I: integer): string;
begin
  if (I>=0) and (I<FObjectList.Count) then
    Result:=TDBInspectorRecord(FObjectList[i]).Caption
  else
    Result:='';
end;

procedure TDBInspectorRecord.OnCreateNewDBObject(Edt: TForm;
  ADBObject: TDBObject);
var
  Rec:TDBInspectorRecord;
begin
  Rec:=OwnerDB.FindDBObject(ADBObject);
  Rec.FOwner:=(FOwner.TreeView as TTreeView).Items.AddChild(FOwner, '');
  Rec.FOwner.Data:=Rec;
  Rec.Caption:=ADBObject.Caption;

  FOwner.TreeView.Selected:=nil;
  FOwner.TreeView.Selected:=Rec.FOwner;

  if ADBObject is TDBRootObject then
  begin
    Rec.FDBGroup:=ADBObject as TDBRootObject;
    Rec.FRecordType:=rtDBGroup;
    Rec.Refresh;
  end;

  if ADBObject.DBObjectKind in [ okTable, okPartitionTable, okView, okStoredProc, okSequence, okException, okUDF] then
    OwnerDB.SynSQLSyn.TableNames.Add(ADBObject.Caption);
  UpdateCaption;
  (Edt as TfbmDBObjectEditorForm).OnCreateNewDBObject:=nil;
end;

procedure TDBInspectorRecord.RenameTo(const ANewName: string);
begin
//  if not DBIsValidIdent(ANewName) then Exit;

  if Assigned(DBObject) then
  begin
    if not DBObject.RenameObject(ANewName) then Exit;
    DBObject.RefreshObject;
    Caption:=DBObject.Caption;
    if Assigned(ObjectEditor) then
      TfbmDBObjectEditorForm(ObjectEditor).RefreshPages;
  end
  else
    Caption:=ANewName;
  Refresh;
end;

function TDBInspectorRecord.GetDescription: string;
begin
  if Assigned(DBObject) then
  begin
    Result:=
      ObjectKindToStr(DBObject.DBObjectKind) + ' ' + DBObject.CaptionFullPatch + LineEnding;
(*
    if DBObject.DBObjectKind in [okStoredProc, okFunction] then
    begin
      St:=DBObject.MakeChildList;
      if Assigned(St) then
      begin
        Result:=Result + St.Text + LineEnding;
        St.Free;
      end;
    end;
*)
    Result:=Result + DBObject.Description
  end
  else
    Result:='';
end;

constructor TDBInspectorRecord.CreateObject(aOwner: TTreeNode;
  AOwnerDB: TDataBaseRecord; ADBObject: TDBObject);
begin
  inherited Create;
  FOwner:=aOwner;
  OwnerDB:=AOwnerDB;
  CaptionColor:=clWindowText;
  DBObject:=ADBObject;
  FObjectList:=TObjectList.Create;

  if Assigned(FOwner) then
    FOwner.Data:=Self;

  if Assigned(DBObject) then
  begin
    FImageIndex:=DBObjectKindImages[DBObject.DBObjectKind];
    if DBObject.SystemObject then
      CaptionColor:=clRed;
  end
  else
    FImageIndex:=-1;
  FRecordType:=rtDBObject;
end;

constructor TDBInspectorRecord.CreateGroup(aOwner: TTreeNode;
  AOwnerDB: TDataBaseRecord; ADBGroup: TDBRootObject);
begin
  inherited Create;
  FOwner:=aOwner;
  OwnerDB:=AOwnerDB;
  CaptionColor:=clWindowText;
  FObjectList:=TObjectList.Create;
  FDBGroup:=ADBGroup;
  Caption:=FDBGroup.Caption;

  if Assigned(FOwner) then
    FOwner.Data:=Self;

  if FDBGroup.SystemObject then
    CaptionColor:=clRed;

  FRecordType:=rtDBGroup;

  DBObject:=FDBGroup;
end;


function TDBInspectorRecord.GetObjectType: string;
begin
  if RecordType = rtDBGroup then
  begin
    if Assigned(FDBGroup) then
      Result:=FDBGroup.GetObjectType
    else
      Result:='';
  end
  else
  begin
    if Assigned(DBObject) then
      Result:=DBObject.OwnerRoot.GetObjectType
    else
      Result:='';
  end;
end;
(*
procedure TDBInspectorRecord.SetDescription(const AValue: string);
begin
  DBObject.Description:=AValue;
  UpdateCaption;
end;
*)
function TDBInspectorRecord.GetImageIndex: integer;
begin
  if RecordType = rtDBObject then
    Result:=FImageIndex
  else
    Result:=DBObjectKindFolderImages[FDBGroup.DBObjectKind];// ImageIndex;
end;

destructor TDBInspectorRecord.Destroy;

procedure DoFree;
var
  i:integer;
begin
  for i:=FOwner.Count -1 downto 0 do
    if Assigned(FOwner.Items[i].Data) then
      TDBInspectorRecord(FOwner.Items[i].Data).Free;
  FOwner.Delete;
end;

begin
  if Assigned(FObjectList) then
    FreeAndNil(FObjectList);
  if Assigned(ObjectEditor) then
  begin
    TfbmDBObjectEditorForm(ObjectEditor).InspectorRecord:=nil;
    ObjectEditor.Close;
  end;

  if Assigned(FOwner) then
    DoFree;

  if Assigned(FOwnerList) then
    FOwnerList.FList.Remove(Self);
  inherited Destroy;
end;

function TDBInspectorRecord.NewObject:TDBObject;
var
  DBO_NewEditor:TfbmDBObjectEditorForm;
  Rec: TDBInspectorRecord;
begin
  if (RecordType = rtDBGroup) and (FDBGroup.State = sdboVirtualObject) then
  begin
    Result:=FDBGroup.NewDBObject;
    if Assigned(Result) then
    begin
      Rec:=TDBInspectorRecord.CreateObject(nil, OwnerDB, Result);
      Rec.Caption:=Result.Caption;
      Rec.FImageIndex:=GetImageIndex;
      FObjectList.Add(Rec);

      DBO_NewEditor:=TfbmDBObjectEditorForm.CreateObjectEditor(Rec);
      DBO_NewEditor.OnCreateNewDBObject:=@OnCreateNewDBObject;
      Rec.ObjectEditor:=DBO_NewEditor;

      //      DBO_NewEditor.OnClose:=@OnCloseNewCanselEditor;
//----
      fbManagerMainForm.RxMDIPanel1.ChildWindowsAdd(DBO_NewEditor);
      //Result.Info:=DBO_NewEditor;
    end;
  end
  else
  begin
    if (ObjectType<>'') and Assigned(OwnerDB) then
      Result:=OwnerDB.ObjectGroup(Self).NewObject
    else
      Result:=nil;
  end;
end;

function TDBInspectorRecord.Edit: boolean;
begin
  if not Assigned(DBObject) then exit(false);
  Result:=true;
  if not Assigned(ObjectEditor) then
  begin
    DBObject.RefreshObject;
    ObjectEditor:=TfbmDBObjectEditorForm.CreateObjectEditor(Self);
    //DBObject.Info:=ObjectEditor;
    //ObjectEditor.AddHandlerClose(@EditorFormClose);
    ObjectEditorRestore;
    OwnerDB.AddToRecent(Self);
    fbManagerMainForm.RxMDIPanel1.ChildWindowsAdd(ObjectEditor);
  end
  else
    fbManagerMainForm.RxMDIPanel1.ShowWindow(ObjectEditor);
end;

procedure TDBInspectorRecord.ShowObject;
begin
  if (FRecordType = rtDBGroup) and (not FDBGroup.ObjectEditable) then
    Refresh
  else
    Edit;
end;

procedure TDBInspectorRecord.Refresh;
var
  i:integer;
  Rec:TDBInspectorRecord;
  A:boolean;
  FList, FNewList: TStringList;
  G: TDBRootObject;
  D: TDBObject;
  CL: TStrings;
  RN: TTreeNode;
begin
  if RecordType = rtDBGroup then
  begin
    A:=FOwner.Expanded;
    FList:=TStringList.Create;
    FNewList:=TStringList.Create;
    FOwner.TreeView.BeginUpdate;

    for i:=0 to FObjectList.Count - 1 do
    begin
      D:=TDBInspectorRecord(FObjectList[i]).DBObject;
      if Assigned(D) then
        FList.Add(D.Caption);
    end;

    try
      {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'FDBGroup.RefreshGroup;');{$ENDIF}
      FDBGroup.RefreshGroup;
      {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'FDBGroup.RefreshGroup; - end');{$ENDIF}

      for i:=0 to FDBGroup.CountGroups - 1 do
      begin
        G:=FDBGroup.Groups[i];
        if Assigned(G) then
        begin
          FNewList.Add(G.Caption);
          if FList.IndexOf(G.Caption) < 0 then
          begin
            {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'G[%d].%s (%s).Refresh; - start', [i, G.Caption, G.ClassName]);{$ENDIF}
            Rec:=TDBInspectorRecord.CreateGroup(TTreeView(FOwner.TreeView).Items.AddChild(FOwner, ''), OwnerDB, G);
            Rec.Caption:=G.Caption;
            FObjectList.Add(Rec);
            Rec.Refresh;
            {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'G[%d].%s.Refresh; - end', [i, G.Caption]);{$ENDIF}
          end;
        end;
      end;

      for i:=0 to FDBGroup.CountObject - 1 do
      begin
        FNewList.Add(FDBGroup[i].Caption);
        if FList.IndexOf(FDBGroup[i].Caption) < 0 then
        begin
          Rec:=TDBInspectorRecord.CreateObject((FOwner.TreeView as TTreeView).Items.AddChild(FOwner, ''), OwnerDB, FDBGroup[i]);
          Rec.Caption:=FDBGroup.ObjName[i];
          {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'Rec[%d].%s (%s).Refresh; - start', [i, Rec.Caption, FDBGroup[i].ClassName]);{$ENDIF}
          FObjectList.Add(Rec);
          Rec.Refresh;
          {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'Rec[%d].%s.Refresh; - end', [i, Rec.Caption]);{$ENDIF}
        end
      end;

      for i:=FObjectList.Count - 1 downto 0 do
      begin
        if FNewList.IndexOf(TDBInspectorRecord(FObjectList[i]).FCaption) < 0 then
          FObjectList.Delete(i);
      end;

      FOwner.TreeView.EndUpdate;
      UpdateCaption;
      FOwner.Expanded:=A;
    except
      FOwner.TreeView.EndUpdate;
      raise;
    end;
    FList.Free;
    FNewList.Free;
  end
  else
  if Assigned(DBObject) and (ussExpandObjectDetails in DBObject.OwnerDB.UIShowSysObjects) then
  begin
    if DBObject.DBObjectKind in [okTable, okPartitionTable, okStoredProc, okFunction] then
    begin
      {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'DBObject.MakeChildList; - start');{$ENDIF}
      FOwner.DeleteChildren;
      CL:=DBObject.MakeChildList;
      if Assigned(CL) then
      begin
        for i:=0 to CL.Count-1 do
        begin
          RN:=(FOwner.TreeView as TTreeView).Items.AddChild(FOwner, CL[i]);
          RN.ImageIndex:=IntPtr(CL.Objects[i]);
          RN.SelectedIndex:=IntPtr(CL.Objects[i]);
          RN.StateIndex:=IntPtr(CL.Objects[i]);
        end;
        CL.Free;
      end;
      {$IFDEF DEBUG_LOG}RxWriteLog(etDebug, 'DBObject.MakeChildList; - end');{$ENDIF}
    end;
  end;
end;

procedure TDBInspectorRecord.UpdateCaption;
begin
  if Assigned(FOwner) then
  begin
    FOwner.Text:=Caption;
    FOwner.ImageIndex:=GetImageIndex;
    FOwner.SelectedIndex:=GetImageIndex;
    FOwner.StateIndex:=GetImageIndex;
  end;
end;

procedure TDBInspectorRecord.UpdateCaption1;
begin
  if Assigned(DBObject) and (DBObject.Caption <> FCaption) then
    SetCaption(DBObject.Caption);
end;

procedure TDBInspectorRecord.ShowSQLEditor;
begin
  if Assigned(OwnerDB) and OwnerDB.Connected then
    OwnerDB.ShowSQLEditor;
end;

procedure TDBInspectorRecord.SetSqlAssistentData(List: TStrings);
var
  i:integer;
begin
  if RecordType = rtDBGroup then
  begin
    List.Clear;
    for i:=0 to ObjectCount-1 do
      List.Add(ObjectName[i]);
  end
  else
  if Assigned(DBObject) then
    DBObject.SetSqlAssistentData(List);
end;

procedure TDBInspectorRecord.ObjectEditorSave;
begin
{  if Assigned(OwnerDB) and Assigned(ObjectEditor) then
    OwnerDB.FormSavePosition(Caption, ObjectEditor);}
end;

procedure TDBInspectorRecord.ObjectEditorRestore;
begin
{  if Assigned(OwnerDB) and Assigned(ObjectEditor) then
    OwnerDB.FormLoadPosition(Caption, ObjectEditor);}
end;

procedure TDBInspectorRecord.SetFocus;
begin
  if Assigned(fbManDataInpectorForm) then
  begin
    fbManDataInpectorForm.TreeView1.Items.ClearMultiSelection(true);
    fbManDataInpectorForm.TreeView1.Selected:=FOwner;
  end;
end;

procedure TDBInspectorRecord.FillListForNames(AList: TStrings);
var
  i:integer;
begin
  if Assigned(AList) then
  begin
    for i:=0 to FObjectList.Count-1 do
      AList.Add(TDBInspectorRecord(FObjectList[i]).Caption);
  end
end;

procedure TDBInspectorRecord.DropObject(AItem: TDBInspectorRecord);
var
  i:integer;
begin
  I:=FObjectList.IndexOf(AItem);
  if I>=0 then
  begin
    if FDBGroup.DropObject(AItem.DBObject) then
      UpdateCaption;
  end;
end;

procedure TDBInspectorRecord.DropObject(AObjectName: string);
begin
  //
end;

function TDBInspectorRecord.SelectObject(AObjectName: string): boolean;
var
  i:integer;
  Rec:TDBInspectorRecord;
begin
  Result:=false;
  for i:=0 to FObjectList.Count-1 do
    if TDBInspectorRecord(FObjectList[i]).Caption = AObjectName then
    begin
      Rec:=TDBInspectorRecord(FObjectList[i]);
      Rec.FOwner.Owner.Owner.Selected:=Rec.FOwner;
      Result:=true;
      exit;
    end;
end;

function TDBInspectorRecord.EnableDropped: boolean;
begin
  if Assigned(DBObject) then
    Result:=DBObject.EnableDropped
  else
    Result:=false;
end;

function TDBInspectorRecord.EnableRename: boolean;
begin
  if Assigned(DBObject) then
    Result:=DBObject.EnableRename
  else
    Result:=false;
end;

function TDBInspectorRecord.IncludedFields: boolean;
begin
  Result:=false;
end;

procedure TDBInspectorRecord.FillFieldList(List: TStrings);
begin
  DBObject.FillFieldList(List, TCharCaseOptions(ConfigValues.ByNameAsInteger('ectCharCaseIdentif', 0)), false);
end;

initialization
  FExecSQLScriptEvent:=@ExecSQLScript;
end.

