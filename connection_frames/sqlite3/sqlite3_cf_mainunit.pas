unit sqlite3_cf_mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, SQLEngineAbstractUnit, fdbm_ConnectionAbstractUnit, SQLite3EngineUnit;

type

  { TConnectionSQLite3MainPage }

  TConnectionSQLite3MainPage = class(TConnectionDlgPage)
    cbShowSystemObjects: TCheckBox;
    EditAliasName: TEdit;
    EditDBName: TFileNameEdit;
    Label1: TLabel;
    Label5: TLabel;
  private
    FSQLEngine:TSQLEngineSQLite3;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
    constructor Create(ASQLEngine:TSQLEngineSQLite3; AOwner:TForm);
  end;

implementation
uses LazUTF8, LazFileUtils, fbmStrConstUnit;

{$R *.lfm}

{ TConnectionSQLite3MainPage }

procedure TConnectionSQLite3MainPage.Localize;
begin
  inherited Localize;
  cbShowSystemObjects.Caption:=sShowSystemObjects;
  Label1.Caption:=sFileName;
  Label5.Caption:=sDatabaseAlias;
end;

procedure TConnectionSQLite3MainPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  EditDBName.Text:=ASQLEngine.DataBaseName;
  EditAliasName.Text      := ASQLEngine.AliasName;
  cbShowSystemObjects.Checked:=ussSystemTable in ASQLEngine.UIShowSysObjects;
end;

procedure TConnectionSQLite3MainPage.SaveParams;
begin
  FSQLEngine.DataBaseName:=EditDBName.Text;
  FSQLEngine.AliasName:=EditAliasName.Text;
  if cbShowSystemObjects.Checked then
    FSQLEngine.UIShowSysObjects:=FSQLEngine.UIShowSysObjects + [ussSystemTable]
  else
    FSQLEngine.UIShowSysObjects:=FSQLEngine.UIShowSysObjects - [ussSystemTable];
end;

function TConnectionSQLite3MainPage.PageName: string;
begin
  Result:=sGeneral;
end;

function TConnectionSQLite3MainPage.Validate: boolean;
begin
  Result:=FileExistsUTF8(EditDBName.Text);
end;

function TConnectionSQLite3MainPage.TestConnection: boolean;
begin
  Result:=true;
end;

constructor TConnectionSQLite3MainPage.Create(ASQLEngine: TSQLEngineSQLite3;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngine:=ASQLEngine;
end;

end.

