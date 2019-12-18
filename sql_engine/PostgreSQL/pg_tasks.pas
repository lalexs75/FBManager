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
  Classes, SysUtils, SQLEngineAbstractUnit, PostgreSQLEngineUnit, ZDataset,
  sqlObjects, contnrs, SQLEngineInternalToolsUnit, fbmSqlParserUnit,
  SQLEngineCommonTypesUnit;

type
  TPGTask = class;
  TPGTaskStepEnumerator = class;
  TPGTaskSheduleListEnumerator = class;
  TPGAlterTaskOperatorsEnumerator = class;

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

  TTaskStepType = (tstSQL, tstBatch);
  TTaskStepResultType = (tsrtFailure, tsrtSuccess, tsrtIgnore);

  TPGTaskStep = class
  private
    FDescription: string;
    FID:integer;
    FName:string;
    FBody:string;
    FConnectStr:string; //user=postgres host=192.168.123.4 port=5432 dbname=base_test_analiz
    FDBName:string;
    FEnabled:boolean;
    FStepResultType: TTaskStepResultType;
    FStepType: TTaskStepType;
  public
    constructor Create;
    procedure Assign(From:TPGTaskStep);
    function IsEqual(From:TPGTaskStep): Boolean;
    property Name:string read FName write FName;
    property Description:string read FDescription write FDescription;
    property Enabled:boolean read FEnabled write FEnabled;
    property StepType:TTaskStepType read FStepType write FStepType;
    property StepResultType:TTaskStepResultType read FStepResultType write FStepResultType;
    property Body:string read FBody write FBody;
    property DBName:string read FDBName write FDBName;
    property ConnectStr:string read FConnectStr write FConnectStr;
    property ID:integer read FID write FID;
  end;

  { TPGTaskSteps }

  TPGTaskSteps = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItem(AIndex: integer): TPGTaskStep;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(ATaskSteps:TPGTaskSteps);
    function GetEnumerator: TPGTaskStepEnumerator;
    function Add:TPGTaskStep;
    function Find(AID:Integer):TPGTaskStep;
    procedure Clear;
    property Item[AIndex:integer]:TPGTaskStep read GetItem; default;
    property Count:integer read GetCount;
  end;

  { TPGTaskStepEnumerator }

  TPGTaskStepEnumerator = class
  private
    FList: TPGTaskSteps;
    FPosition: Integer;
  public
    constructor Create(AList: TPGTaskSteps);
    function GetCurrent: TPGTaskStep;
    function MoveNext: Boolean;
    property Current: TPGTaskStep read GetCurrent;
  end;

  { TPGTaskShedule }
  TMonthArray = array[1..12] of boolean;
  TDayMonthArray = array[1..32] of boolean;
  TDayWeekArray = array[1..7] of boolean;
  THoursArray = array[0..23] of boolean;
  TMinutesArray = array[0..59] of boolean;

  TPGTaskShedule = class
  private
    FDescription: string;
    FIndex:integer;
    FID:integer;
    FName:string;
    FEnabled:boolean;
    FDateStart:TDateTime;
    FDateStop:TDateTime;
    procedure DoParse(S:string;var A:array of boolean);
    procedure SetMonth(S:string);
    procedure SetDayMonth(S:string);
    procedure SetDayWeek(S:string);
    procedure SetHours(S:string);
    procedure SetMinutes(S:string);
    //
    //function MakeSQL:string;
  public
    Month:TMonthArray;
    DayMonth:TDayMonthArray;
    DayWeek:TDayWeekArray;
    Hours:THoursArray;
    Minutes:TMinutesArray;
    constructor Create;
    procedure Assign(From:TPGTaskShedule);

    function MonthStr:string; inline;
    function DayMonthStr:string; inline;
    function DayWeekStr:string; inline;
    function HoursStr:string; inline;
    function MinutesStr:string; inline;

    property Index:integer read FIndex write FIndex;
    property ID:integer read FID write FID;
    property Name:string read FName write FName;
    property Description:string read FDescription write FDescription;
    property Enabled:boolean read FEnabled write FEnabled;
    property DateStart:TDateTime read FDateStart write FDateStart;
    property DateStop:TDateTime read FDateStop write FDateStop;
  end;

  { TPGTaskSheduleList }

  TPGTaskSheduleList = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItem(AIndex: integer): TPGTaskShedule;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(ATaskSteps:TPGTaskSheduleList);
    function GetEnumerator: TPGTaskSheduleListEnumerator;
    function Add:TPGTaskShedule;
    procedure Clear;
    property Item[AIndex:integer]:TPGTaskShedule read GetItem; default;
    property Count:integer read GetCount;
  end;

  { TPGTaskSheduleListEnumerator }

  TPGTaskSheduleListEnumerator = class
  private
    FList: TPGTaskSheduleList;
    FPosition: Integer;
  public
    constructor Create(AList: TPGTaskSheduleList);
    function GetCurrent: TPGTaskShedule;
    function MoveNext: Boolean;
    property Current: TPGTaskShedule read GetCurrent;
  end;

  TPGTask = class(TDBObject)
  private
    FDateCreate: TDateTime;
    FDateModify: TDateTime;
    FDateRunLast: TDateTime;
    FDateRunNext: TDateTime;
    FEnabled: boolean;
    FTaskID: integer;
    FSteps:TPGTaskSteps;
    FShedule:TPGTaskSheduleList;
    FTaskClassID:integer;
    function GetTaskClassName: string;
  protected
    function InternalGetDDLCreate: string; override;
    procedure SetDescription(const AValue: string); override;
    procedure InternalPrepareDropCmd(R: TSQLDropCommandAbstract); override;
    procedure InternalRefreshStatistic; override;
  public
    constructor Create(const ADBItem:TDBItem; AOwnerRoot: TDBRootObject);override;
    destructor Destroy; override;
    procedure RefreshObject; override;
    procedure SetSqlAssistentData(const List: TStrings);override;

    function CreateSQLObject:TSQLCommandDDL; override;
    function CompileSQLObject(ASqlObject:TSQLCommandDDL; ASqlExecParam:TSqlExecParams):boolean; override;

    class function DBClassTitle:string;override;
    property TaskID:integer read FTaskID;
    property Steps:TPGTaskSteps read FSteps;
    property TaskClassID:integer read FTaskClassID;
    property TaskClassName:string read GetTaskClassName;
    property Shedule:TPGTaskSheduleList read FShedule;
    property Enabled:boolean read FEnabled;
    property DateCreate:TDateTime read FDateCreate;
    property DateModify:TDateTime read FDateModify;
    property DateRunLast:TDateTime read FDateRunLast;
    property DateRunNext:TDateTime read FDateRunNext;
  end;

  { TPGSQLTaskCreate }

  TPGSQLTaskCreate = class(TSQLCommandDDL)
  private
    FTaskClass: string;
    FTaskShedule: TPGTaskSheduleList;
    FTaskSteps:TPGTaskSteps;
  protected
    procedure MakeSQL; override;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    destructor Destroy;override;
    procedure Clear;override;
    procedure Assign(ASource:TSQLObjectAbstract);override;
    property TaskSteps:TPGTaskSteps read FTaskSteps;
    property TaskShedule:TPGTaskSheduleList read FTaskShedule;
    property TaskClass:string read FTaskClass write FTaskClass;
  end;

  TPGSQLTaskAlterAction = (pgtaCreateShedule, pgtaCreateTaskItem,
    pgtaAlterShedule, pgtaAlterTaskItem, pgtaDropShedule, pgtaDropTaskItem,
    pgtaAlterTask);

  { TPGAlterTaskOperator }

  TPGAlterTaskOperator = class
  private
    FAlterAction: TPGSQLTaskAlterAction;
    FCaption: string;
    FEnabled: Boolean;
    FID: Integer;
    FShedule: TPGTaskShedule;
    FStep: TPGTaskStep;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(Source: TPGAlterTaskOperator);
    property AlterAction:TPGSQLTaskAlterAction read FAlterAction write FAlterAction;
    property ID:Integer read FID write FID;
    property Step:TPGTaskStep read FStep;
    property Shedule:TPGTaskShedule read FShedule;
    property Caption:string read FCaption write FCaption;
    property Enabled:Boolean read FEnabled write FEnabled;
  end;

  { TPGAlterTaskOperators }

  TPGAlterTaskOperators = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItems(Index: integer): TPGAlterTaskOperator;
  public
    constructor Create;
    destructor Destroy;override;
    function GetEnumerator: TPGAlterTaskOperatorsEnumerator;
    procedure Clear;
    procedure Assign(ASource:TPGAlterTaskOperators);
    function AddItem(AlterAction:TPGSQLTaskAlterAction):TPGAlterTaskOperator;

    property Count:integer read GetCount;
    property Items[Index:integer]:TPGAlterTaskOperator read GetItems;default;
  end;

  { TPGAlterTaskOperatorsEnumerator }

  TPGAlterTaskOperatorsEnumerator = class
  private
    FList: TPGAlterTaskOperators;
    FPosition: Integer;
  public
    constructor Create(AList: TPGAlterTaskOperators);
    function GetCurrent: TPGAlterTaskOperator;
    function MoveNext: Boolean;
    property Current: TPGAlterTaskOperator read GetCurrent;
  end;

  { TPGSQLTaskAlter }

  TPGSQLTaskAlter = class(TSQLCommandDDL)
  private
    FOperators: TPGAlterTaskOperators;
  protected
    procedure MakeSQL; override;
  public
    constructor Create(AParent:TSQLCommandAbstract); override;
    destructor Destroy;override;
    procedure Clear;override;
    procedure Assign(ASource:TSQLObjectAbstract);override;
    function AddOperator(AlterAction: TPGSQLTaskAlterAction): TPGAlterTaskOperator;
    property Operators:TPGAlterTaskOperators read FOperators;
  end;

  { TPGSQLDropTask }

  TPGSQLDropTask = class(TSQLDropCommandAbstract)
  private
    FJobID: Integer;
  protected
    procedure MakeSQL;override;
  public
    property JobID:Integer read FJobID write FJobID;
  end;

implementation
uses rxstrutils, pg_sql_lines_unit, pgSqlTextUnit, fbmStrConstUnit, StrUtils;

function DoMakeArray(const A: array of boolean): string;
var
  i: Integer;
begin
  Result:='';
  for i:=Low(A) to High(A) do Result:=Result + BoolToStr(A[i], 't', 'f')+',';
  Result:='{'+Copy(Result, 1, Length(Result) - 1) + '}';
end;

function CreateStepSQL(AJobID:string; AStep:TPGTaskStep; ALeftMargin:Integer):string;
var
  S1, S2, SDBName, SConnStr, S3: String;
begin
  S1:=MakeStr(' ', ALeftMargin);
  if AStep.StepType = tstSQL then
  begin
    S2:='''s''';
    SDBName:=AStep.DBName;
    SConnStr:='';
  end
  else
  begin
    //tstBatch;
    S2:='''b''';
    SDBName:='';
    SConnStr:=AStep.ConnectStr;
  end;

  case AStep.StepResultType of
    tsrtFailure:S3:='''f''';
    tsrtSuccess:S3:='''s''';
    tsrtIgnore:S3:='''i''';
  end;

  Result:=
    S1 + 'INSERT INTO pgagent.pga_jobstep' + LineEnding +
    S1 + '  (jstjobid, jstname, jstdesc, jstenabled, jstkind, jstonerror, jstcode, jstdbname, jstconnstr)' + LineEnding +
    S1 + 'values ' + LineEnding +
    S1 + '  ('+AJobID+', '+
              AnsiQuotedStr(AStep.Name, '''')+', ' +
              AnsiQuotedStr(AStep.Description, '''') + ', '+
              BoolToStr(AStep.Enabled, true)+', '+
              S2 + ', '+
              S3 + ', '+
              AnsiQuotedStr(AStep.Body, '''')+', '+
              AnsiQuotedStr(SDBName, '''') + ', '+
              AnsiQuotedStr(SConnStr, '''') + ');' +LineEnding;
end;

function AlterStepSQL(AStep:TPGTaskStep; ALeftMargin:Integer):string;
var
  S1, S2, SDBName, SConnStr, S3: String;
begin

  if AStep.StepType = tstSQL then
  begin
    S2:='''s''';
    SDBName:=AStep.DBName;
    SConnStr:='';
  end
  else
  begin
    //tstBatch;
    S2:='''b''';
    SDBName:='';
    SConnStr:=AStep.ConnectStr;
  end;

  case AStep.StepResultType of
    tsrtFailure:S3:='''f''';
    tsrtSuccess:S3:='''s''';
    tsrtIgnore:S3:='''i''';
  end;

  S1:=MakeStr(' ', ALeftMargin);
  Result:=
    S1 + 'UPDATE pgagent.pga_jobstep '+
         'SET '+
           'jstname = '+AnsiQuotedStr(AStep.Name, '''') + ', '+
           'jstconnstr = '+ AnsiQuotedStr(SConnStr, '''') + ', '+
           'jstdbname='+AnsiQuotedStr(SDBName, '''')+', '+
           'jstenabled = '+BoolToStr(AStep.Enabled, true) + ', '+
           'jstkind='+S2+', '+
           'jstonerror='+S3+', '+
           'jstdesc=' + AnsiQuotedStr(AStep.Description, '''') + ' '+
         'WHERE '+
           'jstid='+IntToStr(AStep.ID) + ';'+LineEnding;
end;

function CreateSheduleSQL(AJobID:string; AShedule:TPGTaskShedule; ALeftMargin:Integer):string;
var
  S1: String;
begin
  S1:=MakeStr(' ', ALeftMargin);
  Result:=
    S1 + 'INSERT INTO pgagent.pga_schedule (jscjobid, jscname, jscdesc, '+
              'jscminutes, jschours, jscweekdays, jscmonthdays, '+
              'jscmonths, jscenabled, jscstart, jscend)' + LineEnding +
    S1 + 'VALUES('+AJobID+', ' +
              AnsiQuotedStr(AShedule.Name, '''') + ', ' +
              AnsiQuotedStr(AShedule.Description, '''') + ', '+
              AnsiQuotedStr(AShedule.MinutesStr, '''') + ', '+
              AnsiQuotedStr(AShedule.HoursStr, '''') +  ', ' +
              AnsiQuotedStr(AShedule.DayWeekStr, '''') +  ', ' +
              AnsiQuotedStr(AShedule.DayMonthStr, '''') +  ','+
              AnsiQuotedStr(AShedule.MonthStr, '''') + ', ' +
              BoolToStr(AShedule.Enabled, true) + ',' +
              '''' + DateTimeToStr(AShedule.DateStart)+''', '+
              '''' + DateTimeToStr(AShedule.DateStop) + ''');' + LineEnding;
end;

function AlterSheduleSQL(AShedule:TPGTaskShedule; ALeftMargin:Integer):string;
var
  S1: String;
begin
  S1:=MakeStr(' ', ALeftMargin);
  Result:=S1 +
    'UPDATE pgagent.pga_schedule SET '+
      'jscname = ' + AnsiQuotedStr(AShedule.Name, '''') + ',' +
      'jscdesc = ' + AnsiQuotedStr(AShedule.Description, '''')  + ',' +
      'jscenabled = ' +BoolToStr(AShedule.Enabled, true) + ', '+
      'jscweekdays = ''{' + DoMakeArray(AShedule.DayWeek) + '}'', '+
      'jscmonthdays = ''{' + DoMakeArray(AShedule.DayMonth)+'}'', '+
      'jscmonths = ''{' + DoMakeArray(AShedule.Month)+'}'', '+
      'jscminutes = ''{' + DoMakeArray(AShedule.Minutes)+'}'', '+
      'jschours = ''{' + DoMakeArray(AShedule.Hours)+'}'', '+
      'jscstart = ''' + DateTimeToStr(AShedule.DateStart) + ''', ' +
      'jscend = ''' + DateTimeToStr(AShedule.DateStop) + ''' ' +
    'WHERE jscid='+IntToStr(AShedule.ID)+';';
end;

{ TPGAlterTaskOperatorsEnumerator }

constructor TPGAlterTaskOperatorsEnumerator.Create(AList: TPGAlterTaskOperators
  );
begin
  FList := AList;
  FPosition := -1;
end;

function TPGAlterTaskOperatorsEnumerator.GetCurrent: TPGAlterTaskOperator;
begin
  Result := FList[FPosition];
end;

function TPGAlterTaskOperatorsEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TPGAlterTaskOperators }

function TPGAlterTaskOperators.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TPGAlterTaskOperators.GetItems(Index: integer): TPGAlterTaskOperator;
begin
  Result:=TPGAlterTaskOperator(FList[Index]);
end;

constructor TPGAlterTaskOperators.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TPGAlterTaskOperators.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

function TPGAlterTaskOperators.GetEnumerator: TPGAlterTaskOperatorsEnumerator;
begin
  Result:=TPGAlterTaskOperatorsEnumerator.Create(Self);
end;

procedure TPGAlterTaskOperators.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TPGAlterTaskOperator(FList[i]).Free;
  FList.Clear;
end;

procedure TPGAlterTaskOperators.Assign(ASource: TPGAlterTaskOperators);
var
  P: TPGAlterTaskOperator;
begin
  Clear;
  if not Assigned(ASource) then Exit;
  for P in Self do
    AddItem(P.AlterAction).Assign(P);
end;

function TPGAlterTaskOperators.AddItem(AlterAction: TPGSQLTaskAlterAction
  ): TPGAlterTaskOperator;
begin
  Result:=TPGAlterTaskOperator.Create;
  Result.FAlterAction:=AlterAction;
  FList.Add(Result);
end;

{ TPGAlterTaskOperator }

constructor TPGAlterTaskOperator.Create;
begin
  inherited Create;
  FStep:=TPGTaskStep.Create;
  FShedule:=TPGTaskShedule.Create;
end;

destructor TPGAlterTaskOperator.Destroy;
begin
  FreeAndNil(FStep);
  FreeAndNil(FShedule);
  inherited Destroy;
end;

procedure TPGAlterTaskOperator.Assign(Source: TPGAlterTaskOperator);
begin
  if not Assigned(Source) then Exit;
  FAlterAction:=Source.FAlterAction;
  FCaption:=Source.Caption;
  FID:=Source.ID;
  FShedule.Assign(Source.Shedule);
  FStep.Assign(Source.Step);
  FEnabled:=Source.FEnabled;
end;

{ TPGSQLTaskAlter }

procedure TPGSQLTaskAlter.MakeSQL;
var
  Op: TPGAlterTaskOperator;
  S: String;
begin
  S:='';
  for Op in Operators do
  begin
    case Op.AlterAction of
      pgtaDropTaskItem:S:=S + '  DELETE FROM pgagent.pga_jobstep WHERE jstid='+IntToStr(Op.ID) +';'+LineEnding;
      pgtaDropShedule:S:=S + '  DELETE FROM pgagent.pga_schedule WHERE jscid='+IntToStr(Op.ID) +';'+LineEnding;
      pgtaAlterTask:S:=S + '  UPDATE pgagent.pga_job set jobname = '+AnsiQuotedStr(OP.Caption, '''')+
                            ', jobenabled='+BoolToStr(OP.Enabled, true)+' where jobid='+IntToStr(Op.ID) +';'+LineEnding;
      pgtaCreateTaskItem:S:=S + CreateStepSQL(IntToStr(OP.ID), OP.Step, 2);
      pgtaCreateShedule:S:=S + CreateSheduleSQL(IntToStr(OP.ID), OP.Shedule, 2);
      pgtaAlterTaskItem:S:=S + AlterStepSQL(OP.Step, 2);
      pgtaAlterShedule:S:=S + AlterSheduleSQL(OP.Shedule, 2);
    else
      raise Exception.Create('TPGSQLTaskAlter - Unknow operator');
    end;
  end;
  if S<>'' then
    S:='do'+LineEnding+'$tasks$'+LineEnding + 'begin'+LineEnding + S +  'end;'+LineEnding + '$tasks$';
  AddSQLCommand(S);
end;

constructor TPGSQLTaskAlter.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FOperators:=TPGAlterTaskOperators.Create;
end;

destructor TPGSQLTaskAlter.Destroy;
begin
  Clear;
  FOperators.Free;
  inherited Destroy;
end;

procedure TPGSQLTaskAlter.Clear;
begin
  FOperators.Clear;
  inherited Clear;
end;

procedure TPGSQLTaskAlter.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLTaskAlter then
  begin
    FOperators.Assign(TPGSQLTaskAlter(ASource).FOperators);
  end;
  inherited Assign(ASource);
end;

function TPGSQLTaskAlter.AddOperator(AlterAction: TPGSQLTaskAlterAction
  ): TPGAlterTaskOperator;
begin
  Result:=FOperators.AddItem(AlterAction);
end;

{ TPGTaskSheduleListEnumerator }

constructor TPGTaskSheduleListEnumerator.Create(AList: TPGTaskSheduleList);
begin
  FList := AList;
  FPosition := -1;
end;

function TPGTaskSheduleListEnumerator.GetCurrent: TPGTaskShedule;
begin
  Result := FList[FPosition];
end;

function TPGTaskSheduleListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TPGTaskSheduleList }

function TPGTaskSheduleList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TPGTaskSheduleList.GetItem(AIndex: integer): TPGTaskShedule;
begin
  Result:=TPGTaskShedule(FList[AIndex]);
end;

constructor TPGTaskSheduleList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TPGTaskSheduleList.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TPGTaskSheduleList.Assign(ATaskSteps: TPGTaskSheduleList);
var
  P: TPGTaskShedule;
begin
  Clear;
  if not Assigned(ATaskSteps) then Exit;
  for P in ATaskSteps do
    Add.Assign(P);
end;

function TPGTaskSheduleList.GetEnumerator: TPGTaskSheduleListEnumerator;
begin
  Result:=TPGTaskSheduleListEnumerator.Create(Self);
end;

function TPGTaskSheduleList.Add: TPGTaskShedule;
begin
  Result:=TPGTaskShedule.Create;
  FList.Add(Result);
end;

procedure TPGTaskSheduleList.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count - 1 do
    TPGTaskShedule(FList[i]).Free;
  FList.Clear;
end;

{ TPGSQLDropTask }

procedure TPGSQLDropTask.MakeSQL;
begin
  AddSQLCommand(Format('delete from pgagent.pga_job where pga_job.jobid = %d', [FJobID]));
end;

{ TPGTaskStepEnumerator }

constructor TPGTaskStepEnumerator.Create(AList: TPGTaskSteps);
begin
  FList := AList;
  FPosition := -1;
end;

function TPGTaskStepEnumerator.GetCurrent: TPGTaskStep;
begin
  Result := FList[FPosition];
end;

function TPGTaskStepEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TPGTaskSteps }

function TPGTaskSteps.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TPGTaskSteps.GetItem(AIndex: integer): TPGTaskStep;
begin
  Result:=TPGTaskStep(FList[AIndex]);
end;

constructor TPGTaskSteps.Create;
begin
  inherited Create;
  //FOwner:=AOwner;
  FList:=TFPList.Create;
end;

destructor TPGTaskSteps.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TPGTaskSteps.Assign(ATaskSteps: TPGTaskSteps);
var
  T: TPGTaskStep;
begin
  Clear;
  if not Assigned(ATaskSteps) then Exit;
  for T in ATaskSteps do
    Add.Assign(T);
end;

function TPGTaskSteps.GetEnumerator: TPGTaskStepEnumerator;
begin
  Result:=TPGTaskStepEnumerator.Create(Self);
end;

function TPGTaskSteps.Add: TPGTaskStep;
begin
  Result:=TPGTaskStep.Create;
  FList.Add(Result);
end;

function TPGTaskSteps.Find(AID: Integer): TPGTaskStep;
var
  S: TPGTaskStep;
begin
  for S in Self do
    if S.ID = AID then
      Exit(S);
  Result:=nil;
end;

procedure TPGTaskSteps.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count-1 do
    TPGTaskStep(FList[i]).Free;
  FList.Clear;
end;

{ TPGSQLTaskCreate }

procedure TPGSQLTaskCreate.MakeSQL;
var
  S: String;
  T: TPGTaskStep;
  TL: TPGTaskShedule;
begin
  S:='do'+LineEnding+'$tasks$'+LineEnding +
  'declare'+LineEnding +
  '  f_JobId integer;'+LineEnding +
  'begin'+LineEnding +
  '  INSERT INTO pgagent.pga_job (jobjclid, jobname, jobdesc, jobenabled, jobhostagent)'+LineEnding +
  '  SELECT'+LineEnding +
  '    pga_jobclass.jclid,'+LineEnding +
  '    '''+name+''','+LineEnding +
  '    '''+Description+''','+LineEnding +
  '    true,'+LineEnding +
  '    '''''+LineEnding +
  '  FROM'+LineEnding +
  '    pgagent.pga_jobclass'+LineEnding +
  '    WHERE pga_jobclass.jclname='''+TaskClass+''''+LineEnding +
  '  RETURNING'+LineEnding +
  '    jobid'+LineEnding +
  '  into'+LineEnding +
  '    f_JobId;'+LineEnding+LineEnding;

  if FTaskSteps.Count > 0 then
  begin
    S:=S + '  /*------------- JOB STEPS -----------*/' + LineEnding;
    for T in FTaskSteps do
      S:=S + CreateStepSQL('f_JobId', T, 2);
    S:=S + LineEnding + LineEnding;
  end;


  if FTaskShedule.Count > 0 then
  begin
    S:=S + '  /*------------- JOB SHEDULE -----------*/' + LineEnding;
    for TL in FTaskShedule do
      S:=S + CreateSheduleSQL('f_JobId', TL, 2);
    S:=S + LineEnding + LineEnding;
  end;

   S:=S +
  'end;'+LineEnding +
  '$tasks$';
  AddSQLCommand(S);
end;

constructor TPGSQLTaskCreate.Create(AParent: TSQLCommandAbstract);
begin
  inherited Create(AParent);
  FTaskSteps:=TPGTaskSteps.Create;
  FTaskShedule:=TPGTaskSheduleList.Create;
end;

destructor TPGSQLTaskCreate.Destroy;
begin
  FreeAndNil(FTaskShedule);
  FreeAndNil(FTaskSteps);
  inherited Destroy;
end;

procedure TPGSQLTaskCreate.Clear;
begin
  FTaskSteps.Clear;
  inherited Clear;
end;

procedure TPGSQLTaskCreate.Assign(ASource: TSQLObjectAbstract);
begin
  if ASource is TPGSQLTaskCreate then
  begin
    FTaskSteps.Assign(TPGSQLTaskCreate(ASource).TaskSteps);
    FTaskShedule.Assign(TPGSQLTaskCreate(ASource).TaskShedule);
  end;
  inherited Assign(ASource);
end;

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

procedure TPGTaskShedule.SetMonth(S: string);
begin
  if S = '' then
    FillChar(Month, SizeOf(Month), false)
  else
    DoParse(Copy(S, 2, Length(S)-2), Month);
end;

procedure TPGTaskShedule.SetDayMonth(S: string);
begin
  if S = '' then
    FillChar(DayMonth, SizeOf(DayMonth), false)
  else
    DoParse(Copy(S, 2, Length(S)-2), DayMonth);
end;

procedure TPGTaskShedule.SetDayWeek(S: string);
begin
  if S = '' then
    FillChar(DayWeek, SizeOf(DayWeek), false)
  else
    DoParse(Copy(S, 2, Length(S)-2), DayWeek);
end;

procedure TPGTaskShedule.SetHours(S: string);
begin
  if S = '' then
    FillChar(Hours, SizeOf(Hours), false)
  else
    DoParse(Copy(S, 2, Length(S)-2), Hours);
end;

procedure TPGTaskShedule.SetMinutes(S: string);
begin
  if S = '' then
    FillChar(Minutes, SizeOf(Minutes), false)
  else
    DoParse(Copy(S, 2, Length(S)-2), Minutes);
end;
(*
function TPGTaskShedule.MakeSQL: string;
begin
  if FID > -1 then
  begin
    Result:='UPDATE pgagent.pga_schedule SET '+
      'jscname = '''+FName + ''',' +
      'jscdesc = '''+Description + ''',' +
      'jscenabled = ' +BoolToStr(FEnabled, 'true', 'false') + ', '+
      'jscweekdays = ''{' + DoMakeArray(DayWeek) + '}'', '+
      'jscmonthdays = ''{' + DoMakeArray(DayMonth)+'}'', '+
      'jscmonths = ''{' + DoMakeArray(Month)+'}'', '+
      'jscminutes = ''{' + DoMakeArray(Minutes)+'}'', '+
      'jschours = ''{' + DoMakeArray(Hours)+'}'', '+
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
            '''' + Description +''','+
            '''{' + DoMakeArray(Minutes)+'}'', '+
            '''{' + DoMakeArray(Hours)+'}'', '+

            '''{' + DoMakeArray(DayWeek)+'}'', '+
            '''{' + DoMakeArray(DayMonth)+'}'', '+
            '''{' + DoMakeArray(Month)+'}'', '+
            BoolToStr(FEnabled, 'true', 'false') + ', '+
            '''' + DateTimeToStr(FDateStart) + ''',' +
            '''' + DateTimeToStr(FDateStop) + ''')';
  end;
end;
*)
constructor TPGTaskShedule.Create;
begin
  inherited Create;
  FID:=-1;
  FIndex:=-1;
end;

procedure TPGTaskShedule.Assign(From: TPGTaskShedule);
begin
  FID:=From.FID;
  FName:=From.FName;
  Description:=From.Description;
  FEnabled:=From.FEnabled;
  FDateStart:=From.FDateStart;
  FDateStop:=From.FDateStop;

  Month:=From.Month;
  DayMonth:=From.DayMonth;
  DayWeek:=From.DayWeek;
  Hours:=From.Hours;
  Minutes:=From.Minutes;
end;

function TPGTaskShedule.MonthStr: string; inline;
begin
  Result:=DoMakeArray(Month);
end;

function TPGTaskShedule.DayMonthStr: string; inline;
begin
  Result:=DoMakeArray(DayMonth);
end;

function TPGTaskShedule.DayWeekStr: string; inline;
begin
  Result:=DoMakeArray(DayWeek);
end;

function TPGTaskShedule.HoursStr: string; inline;
begin
  Result:=DoMakeArray(Hours);
end;

function TPGTaskShedule.MinutesStr: string; inline;
begin
  Result:=DoMakeArray(Minutes);
end;

{ TPGTaskStep }

constructor TPGTaskStep.Create;
begin
  inherited Create;
  FID:=-1;
//  FIndex:=-1;
  //FPGTask:=APGTask;
end;

procedure TPGTaskStep.Assign(From: TPGTaskStep);
begin
  if not Assigned(From) then Exit;
  FID:=From.FID;
  FName:=From.FName;
  FBody:=From.FBody;
  FDescription:=From.FDescription;
  FDBName:=From.FDBName;
  FConnectStr:=From.FConnectStr;
  FEnabled:=From.FEnabled;
  FStepType:=From.FStepType;
  FStepResultType:=From.FStepResultType;
end;

function TPGTaskStep.IsEqual(From: TPGTaskStep): Boolean;
begin
  Result:=
    (FID = From.FID) and
    (FName = From.FName) and
    (FBody = From.FBody) and
    (FDescription = From.FDescription) and
    (FDBName = From.FDBName) and
    (FConnectStr = From.FConnectStr) and
    (FEnabled = From.FEnabled) and
    (FStepType = From.FStepType) and
    (FStepResultType = From.FStepResultType);
end;

{ TPGTask }

function TPGTask.GetTaskClassName: string;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to TPGTasksRoot(OwnerRoot).JobClassList.Count-1 do
    if PtrInt(TPGTasksRoot(OwnerRoot).JobClassList.Objects[i]) = TaskClassID then
    begin
      Result:=TPGTasksRoot(OwnerRoot).JobClassList[i];
      //ComboBox1.ItemIndex:=i;
      break;
    end;
end;

function TPGTask.InternalGetDDLCreate: string;
var
  FCmd: TPGSQLTaskCreate;
begin
  FCmd:=TPGSQLTaskCreate.Create(nil);
  FCmd.Name:=Caption;
  FCmd.Description:=Description;
  FCmd.TaskClass:=TaskClassName;
  FCmd.TaskSteps.Assign(FSteps);
  FCmd.TaskShedule.Assign(FShedule);
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

procedure TPGTask.SetDescription(const AValue: string);
begin
  if FDescription <> AValue then
  begin
    TSQLEnginePostgre(OwnerDB).ExecSysSQL(Format('UPDATE pgagent.pga_job SET jobdesc = %s WHERE jobid=%d', [AnsiQuotedStr(AValue, ''''), FTaskID]));
    FDescription:=AValue;
  end;
end;

procedure TPGTask.InternalPrepareDropCmd(R: TSQLDropCommandAbstract);
begin
  inherited InternalPrepareDropCmd(R);
  (R as TPGSQLDropTask).FJobID:=TaskID;
end;

procedure TPGTask.InternalRefreshStatistic;
begin
  inherited InternalRefreshStatistic;
  Statistic.AddValue(sOID, IntToStr(FTaskID));
end;


constructor TPGTask.Create(const ADBItem: TDBItem; AOwnerRoot: TDBRootObject);
begin
  { TODO : Необходимо реализовать отображение в дереве запрещённых задач }
  inherited Create(ADBItem, AOwnerRoot);
  FSteps:=TPGTaskSteps.Create;
  FShedule:=TPGTaskSheduleList.Create;
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


  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgSqlTextModule.sqlTasks['pgTasksJobData']);
  Q.ParamByName('jobid').AsInteger:=FTaskID;
  try
    Q.Open;
    if not Q.Eof then
    begin
      Caption:=Q.FieldByName('jobname').AsString;
      FDescription:=Q.FieldByName('jobdesc').AsString;
      FTaskClassID:=Q.FieldByName('jobjclid').AsInteger;
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
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgSqlTextModule.sqlTasks['pgTaskStepList']);
  Q.ParamByName('jstjobid').AsInteger:=FTaskID;
  try
    Q.Open;
    while not Q.Eof do
    begin
      U:=FSteps.Add;
      U.FID:=Q.FieldByName('jstid').AsInteger;
      U.FName:=Q.FieldByName('jstname').AsString;
      U.FDescription:=Q.FieldByName('jstdesc').AsString;
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
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgSqlTextModule.sqlTasks['pgTaskSheduleList']);
  Q.ParamByName('jscjobid').AsInteger:=FTaskID;
  try
    Q.Open;
    while not Q.Eof do
    begin
      Sh:=FShedule.Add;
      Sh.FID:=Q.FieldByName('jscid').AsInteger;
      Sh.FName:=Q.FieldByName('jscname').AsString;
      Sh.Description:=Q.FieldByName('jscdesc').AsString;
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

procedure TPGTask.SetSqlAssistentData(const List: TStrings);
begin
  inherited SetSqlAssistentData(List);
  List.Add(FDescription);
end;

function TPGTask.CreateSQLObject: TSQLCommandDDL;
begin
  if State = sdboCreate then
    Result:=TPGSQLTaskCreate.Create(nil)
  else
    Result:=TPGSQLTaskAlter.Create(nil);
end;

function TPGTask.CompileSQLObject(ASqlObject: TSQLCommandDDL;
  ASqlExecParam: TSqlExecParams): boolean;
begin
  Result:=inherited CompileSQLObject(ASqlObject, ASqlExecParam + [sepSystemExec]);
end;

(*
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
*)
class function TPGTask.DBClassTitle: string;
begin
  Result:='Task';
end;


{ TPGTasksRoot }

function TPGTasksRoot.GetObjectType: string;
begin
 Result:='Tasks';
end;

procedure TPGTasksRoot.RefreshGroup;
var
  Q:TZQuery;
  U:TPGTask;
begin
  FObjects.Clear;
  FJobClassList.Clear;
  Q:=TSQLEnginePostgre(OwnerDB).GetSQLSysQuery(pgSqlTextModule.sqlTasks['pgTaskClassList']);
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
  FDropModeParams:=FDropModeParams + [sepSystemExec];
  FDBObjectKind:=okTasks;
  FDropCommandClass:=TPGSQLDropTask;
  FJobClassList:=TStringList.Create;
end;

destructor TPGTasksRoot.Destroy;
begin
  FreeAndNil(FJobClassList);
  inherited Destroy;
end;

end.

