program fbm_export;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  interfaces,
  Classes,
  SysUtils,
  zcomponent,
  CustApp,
  rxstrutils,
  strutils,
  db,
  pg_export_dm_unit,
  fbmMakeSQLFromDataSetUnit;

type

  { TMyApplication }

  TFBMExportApplication = class(TCustomApplication)
  private
    FSqlFile:string;
    FFile:TextFile;
    FDeleteSQL:Boolean;
    FTableName:string;
    FFields:string;
    FWhere:string;
    FEngine: TExportEngine;
    function InitDB:boolean;
    procedure OpenSQLFile;
    procedure WriteSQL(S:string);
    procedure CloseSQLFile;
    procedure ExportdData;
    procedure DeleteData;
    procedure DoExportRow;
    procedure DoMakeHeader;
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TFBMExportApplication }

function TFBMExportApplication.InitDB: boolean;
var
  S, FEngineStr:string;
begin
  Result:=false;
  FSqlFile:=GetOptionValue('o','sqlfile');
  S:=GetOptionValue('d','database');
  FDeleteSQL:=HasOption('delete');
  FTableName:=GetOptionValue('t','table');
  FWhere:=GetOptionValue('w','where');
  FEngineStr:=GetOptionValue('e','engine');

  FEngine:=eePostgre;
  if FEngineStr = 'PG' then
    FEngine:=eePostgre
  else
  if FEngineStr = 'FB' then
    FEngine:=eeFireBird
  else
  if FEngineStr = 'FB3' then
    FEngine:=eeFireBird3
  else
  if FEngineStr = 'SQLite' then
    FEngine:=eeSqlLite3
  else
  if FEngineStr = 'MySQL' then
    FEngine:=eeMySQL;

  InitData(FEngine);

  if FTableName = '' then
  begin
    WriteLn('Error - Not defined table name');
    WriteLn;
    WriteHelp;
  end
  else
  begin
    ExportDM.MainDB.HostName:=Copy2SymbDel(S, ':');
    ExportDM.MainDB.Database:=S;
    ExportDM.MainDB.User:=GetOptionValue('u','user');
    ExportDM.MainDB.Password:=GetOptionValue('p','password');
    ExportDM.MainDB.Connect;
    Result:=ExportDM.MainDB.Connected;
  end;
end;

procedure TFBMExportApplication.OpenSQLFile;
begin
  AssignFile(FFile, FSqlFile);
  if FileExists(FSqlFile) then
    Append(FFile)
  else
    Rewrite(FFile)
end;

procedure TFBMExportApplication.WriteSQL(S: string);
begin
  WriteLn(FFile, S);
end;

procedure TFBMExportApplication.CloseSQLFile;
begin
  CloseFile(FFile);
end;

procedure TFBMExportApplication.ExportdData;
begin
  ExportDM.quS.SQL.Text:='select * from '+FTableName;
  ExportDM.quS.Open;
{  DoMakeHeader;
  while not ExportDM.quS.EOF do
  begin
    DoExportRow;
    ExportDM.quS.Next;
  end;}
  WriteSQL(MakeSQLInsert(ExportDM.quS, FTableName));
  ExportDM.quS.Close;
end;

procedure TFBMExportApplication.DeleteData;
begin
  WriteSQL('delete from '+FTableName+';');
  WriteSQL('');
end;

procedure TFBMExportApplication.DoExportRow;
var
  i:integer;
  S:string;
begin
  S:='';
  for i:=0 to ExportDM.quS.Fields.Count - 1 do
  begin
    if S<>'' then
      S:=S+', ';
    if ExportDM.quS.Fields[i].IsNull then
      S:=S + 'null'
    else
    if ExportDM.quS.Fields[i].DataType in [ftString, ftTime, ftDate, ftDateTime, ftMemo] then
      S:=S + QuotedString(ExportDM.quS.Fields[i].AsString, '''')
    else
      S:=S + ExportDM.quS.Fields[i].AsString;
  end;
  WriteSQL(Format(FFields, [S]));
end;

procedure TFBMExportApplication.DoMakeHeader;
var
  i:integer;
begin
  FFields:='';
  for i:=0 to ExportDM.quS.Fields.Count - 1 do
  begin
    if FFields<>'' then
      FFields:=FFields+', ';
    FFields:=FFields + ExportDM.quS.Fields[i].FieldName;
  end;
  FFields:='insert into '+FTableName + '('+FFields+')'+LineEnding+'values (%s);'+LineEnding;
end;

procedure TFBMExportApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('hduptoew:', ['help','database','user','password', 'table', 'sqlfile','delete', 'engine','where:']);
  if ErrorMsg<>'' then
  begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then
  begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if FWhere <> '' then
    writeln('Where = "'+FWhere + '"');

  if InitDB then
  begin
    OpenSQLFile;

    if FDeleteSQL then
      DeleteData;

    ExportdData;
    CloseSQLFile;
  end;

  Terminate;
end;

constructor TFBMExportApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TFBMExportApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TFBMExportApplication.WriteHelp;
begin
  writeln('FBM Export data');
  writeln('Export data from PostgreSQL/FireBirdSQL/MySQL/SQLite3 tables to sql text file');
  writeln;
  writeln('Usage: ',ExeName,' -h');
  writeln('-d <host:database>');
  writeln('-u <user>');
  writeln('-p <password>');
  writeln('-o <file_name>');
  writeln('-t <table_name>');
  writeln('-w (--where) <"Where expression">'#7'- where expression');
  writeln('--delete '#7'- Delete records before insert');
  writeln('-e <PG|FB|FB3|SQLite|MySQL> '#7'- Type database to export. Default "PG"');
end;

var
  Application: TFBMExportApplication;

{$R *.res}

begin
  Application:=TFBMExportApplication.Create(nil);
  Application.Title:='PGExportData';
  Application.Run;
  Application.Free;
end.

