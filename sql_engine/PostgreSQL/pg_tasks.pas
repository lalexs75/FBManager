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

unit pg_tasks;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, PostgreSQLEngineUnit, ZDataset, sqlObjects,
  contnrs, SQLEngineInternalToolsUnit;

type
  TPGTask = class;

  { TPGTasksRoot }

  TPGTasksRoot = class(TDBRootObject)
  private
    FJobClassList: TStringList;
  protected
    //
  public
    constructor Create(AOwnerDB : TSQLEngineAbstract; ADBObjectClass:TDBObjectClass; const ACaption:string; AOwnerRoot:TDBRootObject); override;
    destructor Destroy; override;
    function GetObjectType: string;override;
    procedure RefreshGroup; override;
    property JobClassList:TStringList read FJobClassList;
  end;

  { TPGTaskStep }

  TPGTaskStep = class
  private
    FPGTask: TPGTask;
  public
    FID:integer;
    FName:string;
    FBody:string;
    FDesc:string;
    FConnectStr:string; //user=postgres host=192.168.123.4 port=5432 dbname=base_test_analiz
    FDBName:string;
    FEnabled:boolean;
    constructor Create(APGTask:TPGTask);
    procedure Assign(From:TPGTaskStep);
    function IsEqual(From:TPGTaskStep): Boolean;
    function MakeSQL:string;
  end;

  { TPGTaskShedule }

  TPGTaskShedule = class
  private
    FPGTask:TPGTask;
    procedure DoParse(S:string;var A:array of boolean);
    function DoMakeArray(const A:array of boolean):string;
    procedure SetMonth(S:string);
    procedure SetDayMonth(S:string);
    procedure SetDayWeek(S:string);
    procedure SetHours(S:string);
    procedure SetMinutes(S:string);
    //
    function MakeSQL:string;
  public
    FIndex:integer;
    FID:integer;
    FName:string;
    FDesc:string;
    FEnabled:boolean;
    FDateStart:TDateTime;
    FDateStop:TDateTime;
    FMonth:array[1..12] of boolean;
    FDayMonth:array[1..32] of boolean;
    FDayWeek:array[1..7] of boolean;
    FHours:array[0..23] of boolean;
    FMinutes:array[0..59] of boolean;
    constructor Create(APGTask:TPGTask);
    procedure Assign(From:TPGTaskShedule);
  end;

  TPGTask = class(TDBObject)
  private
    FDateCreate: TDateTime;
    FDateModify: TDateTime;
    FDateRunLast: TDateTime;
    FDateRunNext: TDateTime;
    FEnabled: boolean;
    FTaskID: integer;
    FSteps:TObjectList;
    FShedule:TObjectList;
    FClassID:integer;
  protected
//    function InternalGetDDLCreate: string; override;
    procedure SetDescription(const AValue: string); override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;

    function CompileTaskShedule(TS:TPGTaskShedule):boolean;
    function DeleteTaskShedule(TS:TPGTaskShedule):boolean;

    function CompileTaskStep(TS:TPGTaskStep):boolean;
    function DeleteTaskStep(TS:TPGTaskStep):boolean;

    class function DBClassTitle:string;override;
    property TaskID:integer read FTaskID;
    property Steps:TObjectList read FSteps;
    property ClassID:integer read FClassID;
    property Shedule:TObjectList read FShedule;
    property Enabled:boolean read FEnabled;
    property DateCreate:TDateTime read FDateCreate;
    property DateModify:TDateTime read FDateModify;
    property DateRunLast:TDateTime read FDateRunLast;
    property DateRunNext:TDateTime read FDateRunNext;
  end;

implementation
uses SQLEngineCommonTypesUnit, pg_sql_lines_unit, pgSqlTextUnit;

{ TPGTaskShedule }

procedure TPGTaskShedule.DoParse(S: string; var A: array of boolean);
var
  i: Integer;
  j: Integer;
begin
  i:=Low(A);
  j:=1;
  while (i<=High(A)) and (j <= Length(S)) do
  begin
    while (j<=Length(S)) and (S[j] = ',') do inc (j);
    if j<=Length(S) then
    begin
      A[i]:=S[j] in ['t','T'];
      Inc(i);
      Inc(j);
    end
    else
      break;
  end;
end;

function TPGTaskShedule.DoMakeArray(const A: array of boolean): string;
var
  i: Integer;
begin
  Result:='';
  for i:=Low(A) to High(A) do Result:=Result + BoolToStr(A[i], 't', 'f')+',';
  Result:=Copy(Result, 1, Length(Result) - 1);
end;

procedure TPGTaskShedule.SetMonth(S: string);
begin
  if S = '' then exit;
  DoParse(Copy(S, 2, Length(S)-2), FMonth);
end;

procedure TPGTaskShedule.SetDayMonth(S: string);
begin
  if S = '' then exit;
  DoParse(Copy(S, 2, Length(S)-2), FDayMonth);
end;

procedure TPGTaskShedule.SetDayWeek(S: string);
begin
  if S = '' then exit;
  DoParse(Copy(S, 2, Length(S)-2), FDayWeek);
end;

procedure TPGTaskShedule.SetHours(S: string);
begin
  if S = '' then exit;
  DoParse(Copy(S, 2, Length(S)-2), FHours);
end;

procedure TPGTaskShedule.SetMinutes(S: string);
begin
  if S = '' then exit;
  DoParse(Copy(S, 2, Length(S)-2), FMinutes);
end;

function TPGTaskShedule.MakeSQL: string;
begin
  if FID > -1 then
  begin
    Result:='UPDATE pgagent.pga_schedule SET '+
      'jscname = '''+FName + ''',' +
      'jscdesc = '''+FDesc + ''',' +
      'jscenabled = ' +BoolToStr(FEnabled, 'true', 'false') + ', '+
      'jscweekdays = ''{' + DoMakeArray(FDayWeek) + '}'', '+
      'jscmonthdays = ''{' + DoMakeArray(FDayMonth)+'}'', '+
      'jscmonths = ''{' + DoMakeArray(FMonth)+'}'', '+
      'jscminutes = ''{' + DoMakeArray(FMinutes)+'}'', '+
      'jschours = ''{' + DoMakeArray(FHours)+'}'', '+
      'jscstart = ''' + DateTimeToStr(FDateStart) + ''', ' +
      'jscend = ''' + DateTimeToStr(FDateStop) + ''' ' +
      'WHERE jscid='+IntToStr(FID)+';';
  end
  else
  begin
    Result:='INSERT INTO pgagent.pga_schedule ' +
            '(jscid, ' +
             'jscjobid, jscname, jscdesc, '+
             'jscminutes, jschours, '+
             'jscweekdays, jscmonthdays, jscmonths, '+
             'jscenabled, jscstart, jscend) ' +
            'VALUES( NEXTVAL(''pgagent.pga_schedule_jscid_seq''), ' +
            IntToStr(FPGTask.FTaskID) + ', '+
            '''' + FName + ''', '+
            '''' + FDesc +''','+
            '''{' + DoMakeArray(FMinutes)+'}'', '+
            '''{' + DoMakeArray(FHours)+'}'', '+

            '''{' + DoMakeArray(FDayWeek)+'}'', '+
            '''{' + DoMakeArray(FDayMonth)+'}'', '+
            '''{' + DoMakeArray(FMonth)+'}'', '+
            BoolToStr(FEnabled, 'true', 'false') + ', '+
            '''' + DateTimeToStr(FDateStart) + ''',' +
            '''' + DateTimeToStr(FDateStop) + ''')';
  end;
end;

constructor TPGTaskShedule.Create(APGTask: TPGTask);
begin
  inherited Create;
  FID:=-1;
  FIndex:=-1;
  FPGTask:=APGTask;
end;

procedure TPGTaskShedule.Assign(From: TPGTaskShedule);
begin
  FID:=From.FID;
  FName:=From.FName;
  FDesc:=From.FDesc;
  FEnabled:=From.FEnabled;
  FDateStart:=From.FDateStart;
  FDateStop:=From.FDateStop;

  FMonth:=From.FMonth;
  FDayMonth:=From.FDayMonth;
  FDayWeek:=From.FDayWeek;
  FHours:=From.FHours;
  FMinutes:=From.FMinutes;
end;

{ TPGTaskStep }

constructor TPGTaskStep.Create(APGTask: TPGTask);
begin
  inherited Create;
  FID:=-1;
//  FIndex:=-1;
  FPGTask:=APGTask;
end;

procedure TPGTaskStep.Assign(From: TPGTaskStep);
begin
  FID:=From.FID;
  FName:=From.FName;
  FBody:=From.FBody;
  FDesc:=From.FDesc;
  FDBName:=From.FDBName;
  FConnectStr:=From.FConnectStr;
  FEnabled:=From.FEnabled;
end;

function TPGTaskStep.IsEqual(From: TPGTaskStep): Boolean;
begin
  Result:=
    (FID = From.FID) and
    (FName = From.FName) and
    (FBody = From.FBody) and
    (FDesc = From.FDesc) and
    (FDBName = From.FDBName) and
    (FConnectStr = From.FConnectStr) and
    (FEnabled = From.FEnabled);
end;

function TPGTaskStep.MakeSQL: string;
var
  S: String;
begin
  Result:='';
  if FID > -1 then
    Result:=
      'UPDATE '+
      '  pgagent.pga_jobstep '+
      'SET '+
      '  jstname = '''+FName + ''', '+
      '  jstconnstr = '''+ FConnectStr + ''', '+
      '  jstdbname='''+FDBName+''', '+
      '  jstenabled = '+BoolToStr(FEnabled, 'true', 'false') + ', '+
//      '  jstkind='s',
      '  jstdesc=''' + FDesc + ''' '+
      'WHERE '+
      '  jstid='+IntToStr(FID)
  else
    Result:=
      'INSERT INTO pgagent.pga_jobstep '+
        '(jstid, '+
        'jstjobid, '+
        'jstname, '+
        'jstdesc, '+
        'jstenabled, '+
        'jstkind, '+
        'jstonerror, '+
        'jstcode, '+
        'jstdbname, '+
        'jstconnstr)'+
      'values '+
        '(NEXTVAL(''pgagent.pga_schedule_jscid_seq''), ' +//!!
        IntToStr(FPGTask.FTaskID) + ', '+
        '''' +FName + ''', '+
        '''' + FDesc + ''', '+
        BoolToStr(FEnabled, 'true', 'false') + ', '+
        '''s'', '+
        '''f'', ' + //jstonerror,
        '''' + FBody + ''', ' +
        '''' + FDBName + ''', '+
        '''' + FConnectStr + ''')';
end;

{ TPGTask }

procedure TPGTask.SetDescription(const AValue: string);
begin
  if FDescription <> AValue then
  begin
    TSQLEnginePostgre(OwnerDB).ExecSysSQL(Format('UPDATE pgagent.pga_job SET jobdesc = ''%s'' WHERE jobid=%d', [FDescription, FTaskID]));
     FDescription:=AValue;
  end;
end;


constructor TPGTask.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  { TODO : Необходимо реализовать отображение в дереве запрещённых задач }
  inherited Create(ADBItem, AOwnerRoot);
  FSteps:=TObjectList.Create(true);
  FShedule:=TObjectList.Create(true);
end;

destructor TPGTask.Destroy;
begin
  FreeAndNil(FShedule);
  FreeAndNil(FSteps);
  inherited Destroy;
end;

procedure TPGTask.RefreshObject;
var
  Q:TZQuery;
  U:TPGTaskStep;
  Sh:TPGTaskShedule;
begin
  if State <> sdboEdit then exit;
  inherited RefreshObject;


  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgTasksJobData);
  Q.ParamByName('jobid').AsInteger:=FTaskID;
  try
    Q.Open;
    if not Q.Eof then
    begin
      Caption:=Q.FieldByName('jobname').AsString;
      FDescription:=Q.FieldByName('jobdesc').AsString;
      FClassID:=Q.FieldByName('jobjclid').AsInteger;
      FEnabled:=Q.FieldByName('jobenabled').AsBoolean;

      FDateCreate:=Q.FieldByName('jobcreated').AsDateTime;
      FDateModify:=Q.FieldByName('jobchanged').AsDateTime;

      FDateRunLast:=Q.FieldByName('joblastrun').AsDateTime;
      FDateRunNext:=Q.FieldByName('jobnextrun').AsDateTime;

//      '  pga_job.jobagentid, '+
{      U.FBody:=Q.FieldByName('jstcode').AsString;
      U.FConnectStr:=Q.FieldByName('jstconnstr').AsString;
      U.FDBName:=Q.FieldByName('jstdbname').AsString;
      }
    end;
    Q.Close;
  finally
    Q.Free;
  end;


  FSteps.Clear;
  FShedule.Clear;

  //Load step list
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgTaskStepList);
  Q.ParamByName('jstjobid').AsInteger:=FTaskID;
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=TPGTaskStep.Create(Self);
      FSteps.Add(U);
      U.FID:=Q.FieldByName('jstid').AsInteger;
      U.FName:=Q.FieldByName('jstname').AsString;
      U.FDesc:=Q.FieldByName('jstdesc').AsString;
      U.FBody:=Q.FieldByName('jstcode').AsString;
      U.FConnectStr:=Q.FieldByName('jstconnstr').AsString;
      U.FDBName:=Q.FieldByName('jstdbname').AsString;
      U.FEnabled:=Q.FieldByName('jstenabled').AsBoolean;
      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;

  //Load Shedule list
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgTaskSheduleList);
  Q.ParamByName('jscjobid').AsInteger:=FTaskID;
  try
    Q.Open;
    while not Q.Eof do
    begin
      Sh:=TPGTaskShedule.Create(Self);
      FShedule.Add(Sh);
      Sh.FID:=Q.FieldByName('jscid').AsInteger;
      Sh.FName:=Q.FieldByName('jscname').AsString;
      Sh.FDesc:=Q.FieldByName('jscdesc').AsString;
      Sh.FEnabled:=Q.FieldByName('jscenabled').AsBoolean;
      Sh.FDateStart:=Q.FieldByName('jscstart').AsDateTime;
      Sh.FDateStop:=Q.FieldByName('jscend').AsDateTime;
      Sh.SetMonth(Trim(Q.FieldByName('jscmonths').AsString));
      Sh.SetDayMonth(Trim(Q.FieldByName('jscmonthdays').AsString));
      Sh.SetDayWeek(Trim(Q.FieldByName('jscweekdays').AsString));

      Sh.SetMinutes(Trim(Q.FieldByName('jscminutes').AsString));
      Sh.SetHours(Trim(Q.FieldByName('jschours').AsString));

      Q.Next;
    end;
    Q.Close;
  finally
    Q.Free;
  end;
end;

function TPGTask.CompileTaskShedule(TS: TPGTaskShedule): boolean;
var
  sSQL:string;
begin
  Result:=false;
  sSQL:=TS.MakeSQL;
  if sSQL <> '' then
  begin
    TSQLEnginePostgre(OwnerDB).ExecSysSQL(TS.MakeSQL);
    RefreshObject;
    Result:=true;
  end;
end;

function TPGTask.DeleteTaskShedule(TS: TPGTaskShedule): boolean;
begin
  if Assigned(TS) and (TS.FID>-1) then
  begin
    TSQLEnginePostgre(OwnerDB).ExecSysSQL('DELETE FROM pgagent.pga_schedule WHERE jscid='+IntToStr(TS.FID));
    RefreshObject;
  end;
end;

function TPGTask.CompileTaskStep(TS: TPGTaskStep): boolean;
var
  sSQL:string;
begin
  Result:=false;
  sSQL:=TS.MakeSQL;
  if sSQL <> '' then
  begin
    TSQLEnginePostgre(OwnerDB).ExecSysSQL(sSQL);
    RefreshObject;
    Result:=true;
  end;
end;

function TPGTask.DeleteTaskStep(TS: TPGTaskStep): boolean;
begin
  Result:=false;
end;

class function TPGTask.DBClassTitle: string;
begin
  Result:='Task';
end;


{ TPGTasksRoot }
(*
function TPGTasksRoot.GetCountGrp: integer;
begin
  Result:=0;
end;

function TPGTasksRoot.GetImageIndex: integer;
begin
  Result:=61;
end;
*)
function TPGTasksRoot.GetObjectType: string;
begin
 Result:='Tasks';
end;
(*
function TPGTasksRoot.GetGrpObj(AItem: integer): TDBRootObject;
begin
  Result:=nil;
end;
*)
procedure TPGTasksRoot.RefreshGroup;
var
  Q:TZQuery;
  U:TPGTask;
begin
  FObjects.Clear;
  FJobClassList.Clear;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgTaskClassList);
  try
    Q.Open;
    while not Q.Eof do
    begin
      FJobClassList.AddObject(Q.FieldByName('jclname').AsString, TObject(Pointer(Q.FieldByName('jclid').AsInteger)));
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgSqlTextModule.sPGTasks.Strings.Text);
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=TPGTask.Create(nil, Self);
      U.Caption:=Q.FieldByName('jobname').AsString;
      U.FTaskID:=Q.FieldByName('jobid').AsInteger;
      U.FDescription:=Q.FieldByName('jobdesc').AsString;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

constructor TPGTasksRoot.Create(AOwnerDB: TSQLEngineAbstract;
  ADBObjectClass: TDBObjectClass; const ACaption: string;
  AOwnerRoot: TDBRootObject);
begin
  inherited Create(AOwnerDB, ADBObjectClass, ACaption, AOwnerRoot);
  FDBObjectKind:=okTasks;
  FJobClassList:=TStringList.Create;
end;

destructor TPGTasksRoot.Destroy;
begin
  FreeAndNil(FJobClassList);
  inherited Destroy;
end;

end.

