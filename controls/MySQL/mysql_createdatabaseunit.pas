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

unit mysql_CreateDatabaseUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, rxmemds, ZDataset, ZConnection,
  Forms, Controls, Graphics, Dialogs, SQLEngineAbstractUnit, ButtonPanel,
  ComCtrls, StdCtrls, Spin, EditBtn, DB, fdbm_SynEditorUnit;

type

  { Tmysql_CreateDatabaseForm }

  Tmysql_CreateDatabaseForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    cbServName: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    DividerBevel3: TDividerBevel;
    edtCodePage: TComboBox;
    edtCollate: TComboBox;
    edtDataBaseName: TEdit;
    edtLogFile: TFileNameEdit;
    edtPort: TSpinEdit;
    edtPwd: TEdit;
    edtUserName: TEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    PageControl1: TPageControl;
    quCharsetsCHARACTER_SET_NAME: TStringField;
    quCharsetsDEFAULT_COLLATE_NAME: TStringField;
    rxCollations: TRxMemoryData;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TestDB: TZConnection;
    quCharsets: TZReadOnlyQuery;
    quCollations: TZReadOnlyQuery;
    procedure edtUserNameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    function GetCreateSQL:string;
    procedure FillItems;
    function CreateDataBase:boolean;
    procedure FillDBConectionParams;
    procedure Localize;
  public

  end;

type

  { TMySQLCreateDBClass }

  TMySQLCreateDBClass = class(TSQLEngineCreateDBAbstractClass)
    function Execute:boolean;override;
    function CreateSQLEngine:TSQLEngineAbstract;override;
  end;

implementation

uses mysql_SqlParserUnit, mysql_engine, IBManDataInspectorUnit, fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

{ Tmysql_CreateDatabaseForm }

procedure Tmysql_CreateDatabaseForm.edtUserNameChange(Sender: TObject);
begin
  try
    FillDBConectionParams;
    if (TestDB.HostName <> '') and (TestDB.User<>'') then
      TestDB.Connected:=true;
    FillItems;
  except
  end;
  TestDB.Connected:=false;
end;

procedure Tmysql_CreateDatabaseForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
    FillDBConectionParams;
end;

procedure Tmysql_CreateDatabaseForm.FormCreate(Sender: TObject);
begin
  Localize;
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=TabSheet2;
  EditorFrame.TextEditor.ReadOnly:=true;
  fbManDataInpectorForm.DBList.FillServerList(cbServName.Items, TSQLEngineMySQL);
  edtPort.Value:=defMySQLPort;
end;

procedure Tmysql_CreateDatabaseForm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = TabSheet2 then
    EditorFrame.EditorText:=GetCreateSQL;
end;

function Tmysql_CreateDatabaseForm.GetCreateSQL: string;
var
  FCmd: TMySQLCreateDatabase;
begin
  FCmd:=TMySQLCreateDatabase.Create(nil);
  FCmd.Name:=edtDataBaseName.Text;
  FCmd.CharsetName:=edtCodePage.Text;
  FCmd.CollationName:=edtCollate.Text;
  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

procedure Tmysql_CreateDatabaseForm.FillItems;
begin
  edtCodePage.Items.Clear;
  if TestDB.Connected then
  begin
    quCharsets.Open;
    while not quCharsets.EOF do
    begin
      edtCodePage.Items.Add(quCharsetsCHARACTER_SET_NAME.AsString);
      quCharsets.Next;
    end;
    quCharsets.Close;
  end;
end;

function Tmysql_CreateDatabaseForm.CreateDataBase: boolean;
begin
  Result:=false;
  FillDBConectionParams;
  try
    TestDB.Connected:=true;
    Result:=TestDB.ExecuteDirect(GetCreateSQL);
    TestDB.Connected:=false;
  except
    on E:Exception do
      ErrorBoxExcpt(E);
  end;
  TestDB.Connected:=false;
end;

procedure Tmysql_CreateDatabaseForm.FillDBConectionParams;
begin
  TestDB.HostName:=cbServName.Text;
  TestDB.User:=edtUserName.Text;
  TestDB.Password:=edtPwd.Text;
//  TestDB.Database:='postgres';
end;

procedure Tmysql_CreateDatabaseForm.Localize;
begin
  Caption:=sCreateMySQLDatabase;

  TabSheet1.Caption:=sCreateParams;
  DividerBevel1.Caption:=sConnectionParams;
  DividerBevel2.Caption:=sDatabaseProperty;
  DividerBevel3.Caption:=sFBManagerOptions;
  Label1.Caption:=sDatabaseName;
  Label2.Caption:=sHostName;
  Label3.Caption:=sPort;
  Label4.Caption:=sUserName1;
  Label5.Caption:=sPassword;
//  Label7.Caption:=sOwner;
  Label8.Caption:=sCodepage;
//  Label9.Caption:=sTableSpace;
//  Label10.Caption:=sConnectionLimit;
  Label11.Caption:=sCollate;
//  Label12.Caption:=sCType;
  CheckBox1.Caption:=sRegisterAfterCreate;
  CheckBox2.Caption:=sSQLMetadataLogFile;
end;

{ TMySQLCreateDBClass }

function TMySQLCreateDBClass.Execute: boolean;
var
  mysql_CreateDatabaseForm: Tmysql_CreateDatabaseForm;
begin
  Result:=false;
  mysql_CreateDatabaseForm:=Tmysql_CreateDatabaseForm.Create(Application);
  if mysql_CreateDatabaseForm.ShowModal = mrOk then
  begin
    if mysql_CreateDatabaseForm.CreateDataBase then
    begin
      FDataBaseName:=mysql_CreateDatabaseForm.edtDataBaseName.Text;
      FServerName:=mysql_CreateDatabaseForm.cbServName.Text;
      FPort:=mysql_CreateDatabaseForm.edtPort.Value;
      FUserName:=mysql_CreateDatabaseForm.edtUserName.Text;
      FPassword:=mysql_CreateDatabaseForm.edtPwd.Text;
      FRegisterAfterCreate:=mysql_CreateDatabaseForm.CheckBox1.Checked;
      FLogFileMetadata:=mysql_CreateDatabaseForm.edtLogFile.Text;
      FLogMetadata:=mysql_CreateDatabaseForm.CheckBox2.Checked;
      FCreateSQL:=mysql_CreateDatabaseForm.GetCreateSQL;
      Result:=true;
    end;
  end;
  mysql_CreateDatabaseForm.Free;
end;

function TMySQLCreateDBClass.CreateSQLEngine: TSQLEngineAbstract;
begin
  Result:=TSQLEngineMySQL.Create;
  Result.UserName:=UserName;
  Result.Password:=Password;
  Result.ServerName:=ServerName;
  Result.DataBaseName:=DataBaseName;
  Result.SQLEngineLogOptions.LogFileMetadata:=LogFileMetadata;
  Result.SQLEngineLogOptions.LogMetadata:=LogMetadata;
  Result.ReportManagerFolder:=ReportManagerFolder;
  Result.SQLEngineLogOptions.LogTimestamp:=true;
  Result.SQLEngineLogOptions.LogMetadata:= LogMetadata;
  Result.SQLEngineLogOptions.LogFileMetadata:=LogFileMetadata;

  TSQLEngineMySQL(Result).RemotePort:=Port;
  //TSQLEnginePostgre(Result).SQLEngineLogOptions.LogSQLEditor:boolean;
  //SQLEngineLogOptions.LogFileSQLEditor:string;
  //SQLEngineLogOptions.HistoryCountSQLEditor:integer;

end;

end.

