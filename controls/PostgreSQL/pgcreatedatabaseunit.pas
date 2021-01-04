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

unit pgCreateDatabaseUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel, Spin, ComCtrls, EditBtn, DividerBevel,
  ZMacroQuery, ZConnection, ZDataset, SQLEngineAbstractUnit, fdbm_SynEditorUnit,
  DB;

type

  { TpgCreateDatabaseForm }

  TpgCreateDatabaseForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    cbServName: TComboBox;
    edtCollate: TComboBox;
    edtCType: TComboBox;
    edtDBTemplate: TComboBox;
    edtOwner: TComboBox;
    edtCodePage: TComboBox;
    edtTblSpace: TComboBox;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    DividerBevel3: TDividerBevel;
    edtDataBaseName: TEdit;
    edtUserName: TEdit;
    edtPwd: TEdit;
    edtConnectLimit: TEdit;
    edtLogFile: TFileNameEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    CentrLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    edtPort: TSpinEdit;
    quEncodesenc: TStringField;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TestDB: TZConnection;
    quUsers: TZReadOnlyQuery;
    quDBTemplates: TZReadOnlyQuery;
    quTableSpace: TZReadOnlyQuery;
    quEncodes: TZReadOnlyQuery;
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
    { public declarations }
  end; 

type

  { TPGEngineCreateDBClass }

  TPGEngineCreateDBClass = class(TSQLEngineCreateDBAbstractClass)
    function Execute:boolean;override;
    function CreateSQLEngine:TSQLEngineAbstract;override;
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit, PostgreSQLEngineUnit, ibmanagertypesunit,
  IBManDataInspectorUnit, pg_SqlParserUnit;

{$R *.lfm}

{ TpgCreateDatabaseForm }

procedure TpgCreateDatabaseForm.FormCreate(Sender: TObject);
begin
  Localize;
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=TabSheet2;
  EditorFrame.TextEditor.ReadOnly:=true;
  edtPort.Value:=PostgreSQLDefTCPPort;
  fbManDataInpectorForm.DBList.FillServerList(cbServName.Items, TSQLEnginePostgre);
end;

procedure TpgCreateDatabaseForm.edtUserNameChange(Sender: TObject);
begin
  try
    FillDBConectionParams;
    TestDB.Connected:=true;
    FillItems;
  except
  end;
  TestDB.Connected:=false;
end;

procedure TpgCreateDatabaseForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
    FillDBConectionParams;
end;

procedure TpgCreateDatabaseForm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = TabSheet2 then
    EditorFrame.EditorText:=GetCreateSQL;
end;

function TpgCreateDatabaseForm.GetCreateSQL: string;
var
  FCmd: TPGSQLCreateDatabase;
begin
  FCmd:=TPGSQLCreateDatabase.Create(nil);
  FCmd.DatabaseName:=edtDataBaseName.Text;
  if edtOwner.Text<>'' then
    FCmd.Params.AddParamEx('OWNER', edtOwner.Text);

  if edtDBTemplate.Text<>'' then
    FCmd.Params.AddParamEx('TEMPLATE', edtDBTemplate.Text);

  if edtCodePage.Text<>'' then
    FCmd.Params.AddParamEx('ENCODING', edtCodePage.Text);

  if edtCollate.Text<>'' then
    FCmd.Params.AddParamEx('LC_COLLATE', edtCollate.Text);

  if edtCType.Text<>'' then
    FCmd.Params.AddParamEx('LC_CTYPE', edtCType.Text);

  if edtTblSpace.Text<>'' then
    FCmd.Params.AddParamEx('TABLESPACE', edtTblSpace.Text);

  if edtConnectLimit.Text<>'' then
    FCmd.Params.AddParamEx('CONNECTION LIMIT', edtConnectLimit.Text);

  Result:=FCmd.AsSQL;
  FCmd.Free;
end;

procedure TpgCreateDatabaseForm.FillItems;

procedure FillCombo(const CB:TComboBox;const  Q:TDataSet;const AFieldName:string);
begin
  CB.Items.Clear;
  Q.Open;
  while not Q.EOF do
  begin
    CB.Items.Add(Q.FieldByName(AFieldName).AsString);
    Q.Next;
  end;
  Q.Close;
end;

begin
  FillCombo(edtOwner, quUsers, 'usename');
  FillCombo(edtDBTemplate, quDBTemplates, 'datname');
  FillCombo(edtDBTemplate, quDBTemplates, 'datname');
  FillCombo(edtTblSpace, quTableSpace, 'spcname');

  FillCombo(edtCodePage, quEncodes, 'enc');
end;

function TpgCreateDatabaseForm.CreateDataBase:boolean;
var
  S: String;
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

procedure TpgCreateDatabaseForm.FillDBConectionParams;
begin
  TestDB.Protocol:='postgresql'; //pgZeosServerVersionProtoStr[FServerVersion];
  TestDB.HostName:=cbServName.Text;
  TestDB.User:=edtUserName.Text;
  TestDB.Password:=edtPwd.Text;
  TestDB.Database:='postgres';
  TestDB.Port:=edtPort.Value;
end;

procedure TpgCreateDatabaseForm.Localize;
begin
  Caption:=sCreatePostgreDatabase;
  TabSheet1.Caption:=sCreateParams;
  DividerBevel1.Caption:=sConnectionParams;
  DividerBevel2.Caption:=sDatabaseProperty;
  DividerBevel3.Caption:=sFBManagerOptions;
  Label1.Caption:=sDatabaseName;
  Label2.Caption:=sHostName;
  Label3.Caption:=sPort;
  Label4.Caption:=sUserName1;
  Label5.Caption:=sPassword;
  Label6.Caption:=sTemplate;
  Label7.Caption:=sOwner;
  Label8.Caption:=sCodepage;
  Label9.Caption:=sTableSpace;
  Label10.Caption:=sConnectionLimit;
  Label11.Caption:=sCollate;
  Label12.Caption:=sCType;
  CheckBox1.Caption:=sRegisterAfterCreate;
  CheckBox2.Caption:=sSQLMetadataLogFile;
end;

{ TPGEngineCreateDBClass }

function TPGEngineCreateDBClass.Execute: boolean;
var
  pgCreateDatabaseForm: TpgCreateDatabaseForm;
begin
  Result:=false;
  pgCreateDatabaseForm:=TpgCreateDatabaseForm.Create(Application);
  if pgCreateDatabaseForm.ShowModal = mrOk then
  begin
    if pgCreateDatabaseForm.CreateDataBase then
    begin
      FDataBaseName:=pgCreateDatabaseForm.edtDataBaseName.Text;
      FServerName:=pgCreateDatabaseForm.cbServName.Text;
      FPort:=pgCreateDatabaseForm.edtPort.Value;
      FUserName:=pgCreateDatabaseForm.edtUserName.Text;
      FPassword:=pgCreateDatabaseForm.edtPwd.Text;
      FRegisterAfterCreate:=pgCreateDatabaseForm.CheckBox1.Checked;
      FLogFileMetadata:=pgCreateDatabaseForm.edtLogFile.Text;
      FLogMetadata:=pgCreateDatabaseForm.CheckBox2.Checked;
      FCreateSQL:=pgCreateDatabaseForm.GetCreateSQL;
      Result:=true;
    end;
  end;
  pgCreateDatabaseForm.Free;
end;

function TPGEngineCreateDBClass.CreateSQLEngine: TSQLEngineAbstract;
begin
  Result:=TSQLEnginePostgre.Create;
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
  TSQLEnginePostgre(Result).RemotePort:=Port;
end;

end.

