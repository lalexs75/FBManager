unit MSSQLParserTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, mssql_engine, fbmSqlParserUnit;

type

  { TMSSQLParserTest }

  TMSSQLParserTest= class(TTestCase)
  private
    FMSSQLEngine:TMSSQLEngine;
  protected
    procedure SetUp; override;
    procedure TearDown; override;

    function GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
    procedure DoTestSQL(ASql: string);
  published
    procedure TestHookUp;
  end;

  TMSSQLParserTestData = class(TDataModule)
  public
  end;

var
  MSSQLParserTestData: TMSSQLParserTestData = nil;
implementation
uses CustApp;
{$R *.lfm}

procedure TMSSQLParserTest.TestHookUp;
begin
  Fail('Напишите ваш тест');
end;

procedure TMSSQLParserTest.SetUp;
begin
  MSSQLParserTestData:=TMSSQLParserTestData.Create(CustomApplication);
  FMSSQLEngine:=TMSSQLEngine.Create;
end;

procedure TMSSQLParserTest.TearDown;
begin
  FreeAndNil(MSSQLParserTestData);
  FreeAndNil(FMSSQLEngine);
end;

function TMSSQLParserTest.GetNextSQLCmd(ASql: string): TSQLCommandAbstract;
begin
  Result:=GetNextSQLCommand(ASql, FMSSQLEngine, true);
end;

procedure TMSSQLParserTest.DoTestSQL(ASql: string);
var
  V: TSQLCommandAbstract;
begin
  ASql:=TrimRight(ASql);

  if ASql = '' then
    raise Exception.CreateFmt('Пустое SQL выражение : %s', [ASql]);
  //AssertTrue('Пустое SQL выражение', ASql <> '');

  V:=GetNextSQLCmd(ASql);
  AssertNotNull('Не найден парсер выражения : '+ASql, V);
  if Assigned(V) then
  begin
    AssertFalse(V.ErrorMessage + '(' + ASql +')', V.ErrorMessage<>'');
    AssertEquals(ASql, Trim(V.AsSQL));
    V.Free;
  end;
end;

initialization
  RegisterTest(TMSSQLParserTest);
end.

