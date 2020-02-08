{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pg_con_MainPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, ZConnection, ZDataset, Forms,
  Controls, Graphics, Dialogs, StdCtrls, EditBtn, Spin, Buttons,
  fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit, PostgreSQLEngineUnit;

type

  { Tpg_con_MainPage }

  Tpg_con_MainPage = class(TConnectionDlgPage)
    cbServerName: TComboBox;
    CB_ServerVersion: TComboBox;
    DividerBevel1: TDividerBevel;
    Edit1: TEdit;
    edtUserName: TComboBox;
    edtDBName: TComboBox;
    edtAliasName: TEdit;
    edtPassword: TEdit;
    Label1: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtPort: TSpinEdit;
    pgTest: TZConnection;
    quDBList: TZReadOnlyQuery;
    SpeedButton1: TSpeedButton;
    procedure cbServerNameChange(Sender: TObject);
    procedure cbServerNameExit(Sender: TObject);
    procedure edtDBNameExit(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FSQLEngine:TSQLEnginePostgre;
    procedure InitFrame;
    procedure DoFillServersNames;
    procedure DoTryFillDBList;
    function MakeConnectionStr:string;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
    constructor Create(ASQLEngine:TSQLEnginePostgre; AOwner:TForm);
  end;

implementation
uses rxAppUtils, pgTypes, pg_utils, fbmToolsUnit, IBManDataInspectorUnit, rxdbutils,
  ibmanagertypesunit, fbmStrConstUnit, Clipbrd;

{$R *.lfm}

{ Tpg_con_MainPage }

procedure Tpg_con_MainPage.cbServerNameExit(Sender: TObject);
begin
  DoTryFillDBList;
end;

procedure Tpg_con_MainPage.cbServerNameChange(Sender: TObject);
begin
  Edit1.Text:=MakeConnectionStr;
end;

procedure Tpg_con_MainPage.edtDBNameExit(Sender: TObject);
begin
  if (edtAliasName.Text = '') and (edtDBName.Text <> '') then
    edtAliasName.Text:=Format(sAliasOfDB, [edtDBName.Text]);
end;

procedure Tpg_con_MainPage.SpeedButton1Click(Sender: TObject);
begin
  Clipboard.Open;
  Clipboard.AsText:=Edit1.Text;
  Clipboard.Close;
  InfoBox(sConnectionStringCopied);
end;

procedure Tpg_con_MainPage.InitFrame;
begin
  FillPGVersion(CB_ServerVersion.Items);
end;

procedure Tpg_con_MainPage.DoFillServersNames;
var
  S:String;
  i:integer;
  SqlEng:TSQLEngineAbstract;
begin
  cbServerName.Items.Clear;
  edtUserName.Items.Clear;
  for i:=0 to fbManDataInpectorForm.DBList.Count - 1 do
  begin
    SqlEng:=TDataBaseRecord(fbManDataInpectorForm.DBList[i]).SQLEngine;
    if SqlEng is TSQLEnginePostgre then
    begin
      S:=SqlEng.ServerName;
      if (S<>'') and (cbServerName.Items.IndexOf(S)<0) then
        cbServerName.Items.Add(S);

      S:=SqlEng.UserName;
      if (S<>'') and (edtUserName.Items.IndexOf(S)<0) then
        edtUserName.Items.Add(S);
    end;
  end;
end;

procedure Tpg_con_MainPage.DoTryFillDBList;
begin
  if (LockCount>0) or (cbServerName.Text = '') or (edtUserName.Text = '') or
    ((pgTest.HostName = cbServerName.Text) and (pgTest.User = edtUserName.Text) and (pgTest.Password = edtPassword.Text)) then exit;

  pgTest.HostName:=cbServerName.Text;
  pgTest.Database:='postgres';
  pgTest.User:=edtUserName.Text;
  pgTest.Password:=edtPassword.Text;
  pgTest.Protocol:='postgresql';
  if edtPort.Value <> 0 then
    pgTest.Port:=edtPort.Value;

  try
    pgTest.Connect;
    if pgTest.Connected then
    begin
      edtDBName.Items.Clear;
      quDBList.Open;
      FieldValueToStrings(quDBList, 'datname', edtDBName.Items);
      quDBList.Close;
    end;
  except
  end;
  pgTest.Connected:=false;
end;

function Tpg_con_MainPage.MakeConnectionStr: string;
begin
  Result:=cbServerName.Text;
  if (edtPort.Value <> PostgreSQLDefTCPPort) and (edtPort.Value>0) then
    Result:=Result + '/' + IntToStr(edtPort.Value);
  Result:=Result + ':' + edtDBName.Text;
end;

procedure Tpg_con_MainPage.Localize;
begin
  inherited Localize;
  Label2.Caption:=sServerName1;
  Label3.Caption:=sPort;
  Label4.Caption:=sDatabaseName;
  Label5.Caption:=sDatabaseAlias;
  Label6.Caption:=sUserName1;
  Label7.Caption:=sPassword;
  Label14.Caption:=sServerVersion1;
  DividerBevel1.Caption:=sOtherOptions;
  Label12.Caption:=sConnectionString;
end;

procedure Tpg_con_MainPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  InitFrame;
  edtDBName.Text:=ASQLEngine.DataBaseName;
  edtUserName.Text:=ASQLEngine.UserName;
  edtPassword.Text:=ASQLEngine.Password;
  edtAliasName.Text      := ASQLEngine.AliasName;
  cbServerName.Text:=ASQLEngine.ServerName;
  edtPort.Value:=TSQLEnginePostgre(ASQLEngine).RemotePort;
  CB_ServerVersion.ItemIndex:=Ord(TSQLEnginePostgre(ASQLEngine).ServerVersion);
  cbServerNameChange(nil);
  DoTryFillDBList;
end;

procedure Tpg_con_MainPage.SaveParams;
begin
  FSQLEngine.DataBaseName:=edtDBName.Text;
  FSQLEngine.AliasName:=edtAliasName.Text;
  FSQLEngine.UserName:=edtUserName.Text;
  FSQLEngine.Password:=edtPassword.Text;
  FSQLEngine.ServerName:=cbServerName.Text;
  FSQLEngine.RemotePort:=edtPort.Value;
  FSQLEngine.ServerVersion:=TPGServerVersion(CB_ServerVersion.ItemIndex);
end;

function Tpg_con_MainPage.PageName: string;
begin
  Result:=sConnections;
end;

function Tpg_con_MainPage.Validate: boolean;
begin
  Result:=Trim(edtAliasName.Text)<>'';
  if not Result then
  begin
    ErrorBox(sConnectionNameNotSpecified);
    Exit;
  end;
end;

function Tpg_con_MainPage.TestConnection: boolean;
begin
  Result:=false;
  pgTest.Protocol:='postgresql'; //pgZeosServerVersionProtoStr[FServerVersion];
  pgTest.HostName:=cbServerName.Text;
  pgTest.Database:=edtDBName.Text;
  pgTest.User:=edtUserName.Text;
  pgTest.Password:=edtPassword.Text;
  if edtPort.Value <> 0 then
    pgTest.Port:=edtPort.Value;

  try
    pgTest.Connected:=true;
    Result:=pgTest.Connected;
  except
    on E:Exception do
      ErrorBoxExcpt(E);
  end;
  pgTest.Connected:=false;
end;

constructor Tpg_con_MainPage.Create(ASQLEngine: TSQLEnginePostgre; AOwner: TForm
  );
begin
  inherited Create(AOwner);
  FSQLEngine:=ASQLEngine;
  DoFillServersNames;
end;

end.

