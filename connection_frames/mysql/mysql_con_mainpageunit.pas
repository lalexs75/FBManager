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

unit MySQL_con_MainPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset, Forms, Controls, StdCtrls,
  Spin, DB, fdbm_ConnectionAbstractUnit, mysql_engine,
  SQLEngineAbstractUnit;

type

  { TMySQL_con_MainPage }

  TMySQL_con_MainPage = class(TConnectionDlgPage)
    cbServerName: TComboBox;
    CB_ServerVersion: TComboBox;
    CB_CharSet: TComboBox;
    edtDBName: TComboBox;
    edtAliasName: TEdit;
    edtPassword: TEdit;
    edtPort: TSpinEdit;
    edtUserName: TEdit;
    Label1: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    dbTest: TZConnection;
    quCharsets: TZReadOnlyQuery;
    quDatabases: TZReadOnlyQuery;
    quCharsets2: TZReadOnlyQuery;
    quCharsetsCHARACTER_SET_NAME: TStringField;
    quCharsetsDEFAULT_COLLATE_NAME: TStringField;
    quDatabasesSCHEMA_NAME: TStringField;
    procedure cbServerNameExit(Sender: TObject);
    procedure edtDBNameExit(Sender: TObject);
  private
    FSQLEngine:TSQLEngineMySQL;
    procedure InitFrame;
    procedure FillServerData;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
    constructor CreateConnectForm(ASQLEngine:TSQLEngineMySQL; AOwner:TForm);
  end;

implementation

uses IBManDataInspectorUnit, ibmanagertypesunit, fbmToolsUnit, mysql_types, fbmStrConstUnit, rxAppUtils;

{$R *.lfm}

{ TMySQL_con_MainPage }

procedure TMySQL_con_MainPage.cbServerNameExit(Sender: TObject);
begin
  FillServerData;
end;

procedure TMySQL_con_MainPage.edtDBNameExit(Sender: TObject);
begin
  if (edtAliasName.Text = '') and (edtDBName.Text <> '') then
    edtAliasName.Text:=Format(sAliasOfDB, [edtDBName.Text]);
end;

procedure TMySQL_con_MainPage.InitFrame;
begin

end;

procedure TMySQL_con_MainPage.FillServerData;
begin
  dbTest.Database:='information_schema';
  dbTest.HostName:=cbServerName.Text;
  if edtPort.Value <> 0 then
    dbTest.Port:=edtPort.Value;
  dbTest.User:=edtUserName.Text;
  dbTest.Password:=edtPassword.Text;
  try
    dbTest.Connected:=true;
    if dbTest.Connected then
    begin
      edtDBName.Items.Clear;
      quDatabases.Open;
      while not quDatabases.EOF do
      begin
        edtDBName.Items.Add(quDatabasesSCHEMA_NAME.AsString);
        quDatabases.Next;
      end;
      quDatabases.Close;

      CB_CharSet.Items.Clear;
      quCharsets.Open;
      while not quCharsets.EOF do
      begin
        CB_CharSet.Items.Add(quCharsetsCHARACTER_SET_NAME.AsString);
        quCharsets.Next;
      end;
      quCharsets.Close;
    end;
  finally
    dbTest.Connected:=false;
  end;
end;

procedure TMySQL_con_MainPage.Localize;
begin
  inherited Localize;
  Label2.Caption:=sServerName1;
  Label3.Caption:=sPort;
  Label4.Caption:=sDatabaseName;
  Label5.Caption:=sDatabaseAlias;
  Label6.Caption:=sUserName1;
  Label7.Caption:=sPassword;
  Label14.Caption:=sServerVersion1;
end;

procedure TMySQL_con_MainPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  InitFrame;

  edtDBName.Text:=ASQLEngine.DataBaseName;
  edtUserName.Text:=ASQLEngine.UserName;
  edtPassword.Text:=ASQLEngine.Password;
  edtAliasName.Text      := ASQLEngine.AliasName;
  cbServerName.Text:=ASQLEngine.ServerName;

  CB_CharSet.Text         := TSQLEngineMySQL(ASQLEngine).CharSet;

  edtPort.Value:=Ord(TSQLEngineMySQL(ASQLEngine).RemotePort);
  CB_ServerVersion.ItemIndex:=Ord(TSQLEngineMySQL(ASQLEngine).ServerVersion);

end;

procedure TMySQL_con_MainPage.SaveParams;
begin
  FSQLEngine.DataBaseName:=edtDBName.Text;
  FSQLEngine.AliasName:=edtAliasName.Text;
  FSQLEngine.UserName:=edtUserName.Text;
  FSQLEngine.Password:=edtPassword.Text;
  FSQLEngine.ServerName:=cbServerName.Text;
  FSQLEngine.CharSet:=CB_CharSet.Text;
  FSQLEngine.RemotePort:=edtPort.Value;
  FSQLEngine.ServerVersion:=TMySQLServerVersion(CB_ServerVersion.ItemIndex);

//  FSQLEngine.AutoGrantObject:=cbShowSystemObjects.Checked;
end;

function TMySQL_con_MainPage.PageName: string;
begin
  Result:='Connections';
end;

function TMySQL_con_MainPage.Validate: boolean;
begin
  Result:=Trim(edtAliasName.Text)<>'';
  if not Result then
  begin
    ErrorBox(sConnectionNameNotSpecified);
    Exit;
  end;
end;

function TMySQL_con_MainPage.TestConnection: boolean;
begin
  Result:=false;
  dbTest.HostName:=cbServerName.Text;
  dbTest.Database:=edtDBName.Text;
  dbTest.User:=edtUserName.Text;
  dbTest.Password:=edtPassword.Text;
  if edtPort.Value <> 0 then
    dbTest.Port:=edtPort.Value;

  try
    dbTest.Connected:=true;
    Result:=dbTest.Connected;
  except
    on E:Exception do
      ErrorBoxExcpt(E);
  end;
  dbTest.Connected:=false;
end;

constructor TMySQL_con_MainPage.CreateConnectForm(ASQLEngine: TSQLEngineMySQL;
  AOwner: TForm);
var
  R: TMySQLServerVersion;
begin
  inherited Create(AOwner);
  CB_ServerVersion.Clear;
  for R in TMySQLServerVersion do
    CB_ServerVersion.Items.Add(MySQLServerVersionNames[R]);
  FSQLEngine:=ASQLEngine;

  fbManDataInpectorForm.DBList.FillServerList(cbServerName.Items, TSQLEngineMySQL);
end;

end.

