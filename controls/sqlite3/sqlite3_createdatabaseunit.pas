{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit sqlite3_CreateDatabaseUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, Forms, Controls, Graphics, Dialogs,
  StdCtrls, EditBtn, ButtonPanel, SQLEngineAbstractUnit, SQLite3EngineUnit;

type

  { Tsqlite3_CreateDatabaseForm }

  Tsqlite3_CreateDatabaseForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    edtDBName: TFileNameEdit;
    edtLogName: TFileNameEdit;
    Label11: TLabel;
    Label4: TLabel;
    CreateDB: TZConnection;
    procedure FormCreate(Sender: TObject);
  private
    procedure Localize;
  public
    procedure CreateDataBase;
  end;

type

  { TSQLite3CreateDBClass }

  TSQLite3CreateDB = class(TSQLEngineCreateDBAbstractClass)
    function Execute:boolean;override;
    function CreateSQLEngine:TSQLEngineAbstract;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ Tsqlite3_CreateDatabaseForm }

procedure Tsqlite3_CreateDatabaseForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure Tsqlite3_CreateDatabaseForm.Localize;
begin
  Caption:=sCreateParams;
  Label4.Caption:=sDatabaseName;
  Label11.Caption:=sSQLMetadataLogFile;
  CheckBox1.Caption:=sRegisterAfterCreate;
  CheckBox2.Caption:=sMetadataLogingEnable;
end;

procedure Tsqlite3_CreateDatabaseForm.CreateDataBase;
begin
  //CreateDB.CharacterSet:=StrToCharacterSet(ComboBox3.Text);
  CreateDB.Protocol:='sqlite-3';
  CreateDB.Database:=edtDBName.Text;
  CreateDB.Connected:=true;
  CreateDB.Connected:=false;
end;

{ TSQLite3CreateDBClass }

function TSQLite3CreateDB.Execute: boolean;
var
  CreateDatabaseForm: Tsqlite3_CreateDatabaseForm;
begin
  Result:=false;
  CreateDatabaseForm:=Tsqlite3_CreateDatabaseForm.Create(Application);

  CreateDatabaseForm.CheckBox1.Checked                  := FRegisterAfterCreate;
  CreateDatabaseForm.edtDBName.Text                     := FDataBaseName;
  CreateDatabaseForm.CheckBox2.Checked                  := FLogMetadata;
  CreateDatabaseForm.edtLogName.Text                    := FLogFileMetadata;

  if CreateDatabaseForm.ShowModal = mrOk then
  begin
    try
      CreateDatabaseForm.CreateDataBase;
      FRegisterAfterCreate:=CreateDatabaseForm.CheckBox1.Checked;
      FDataBaseName:=CreateDatabaseForm.edtDBName.Text;
      FLogMetadata:=CreateDatabaseForm.CheckBox2.Checked;
      FLogFileMetadata:=CreateDatabaseForm.edtLogName.Text;
      Result:=true;
    except
      on E:Exception do
        ErrorBoxExcpt(E);
    end
  end;
  CreateDatabaseForm.Free;
end;

function TSQLite3CreateDB.CreateSQLEngine: TSQLEngineAbstract;
begin
  Result:=TSQLEngineSQLite3.Create;
  Result.DataBaseName:=DataBaseName;
  Result.SQLEngineLogOptions.LogFileMetadata:=LogFileMetadata;
  Result.SQLEngineLogOptions.LogMetadata:=LogMetadata;
  Result.ReportManagerFolder:=ReportManagerFolder;
end;

end.

