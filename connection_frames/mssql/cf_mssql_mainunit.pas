{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit cf_mssql_mainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit,
  mssql_engine, ZConnection, ZDataset;

type

  { Tcf_mssql_main_frame }

  Tcf_mssql_main_frame = class(TConnectionDlgPage)
    Button2: TButton;
    Edit1: TEdit;
    edtAlias: TEdit;
    edtDBName: TComboBox;
    edtPassword: TEdit;
    cbServerName: TComboBox;
    edtSvrVersion: TComboBox;
    edtUserName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CLabel: TLabel;
    quGetDBList: TZQuery;
    ZConnection1: TZConnection;
    procedure Button2Click(Sender: TObject);
    procedure edtDBNameChange(Sender: TObject);
    procedure edtDBNameDropDown(Sender: TObject);
  private
    FSQLEngine:TMSSQLEngine;
    FDataBase:TZConnection;
    procedure LoadConf;
    procedure SetDataBaseProps(ADataBase:TZConnection);
  public
    constructor Create(TheOwner: TComponent); override;
    procedure Activate;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

var
  cf_mssql_main_frame: Tcf_mssql_main_frame;

implementation
uses IniFiles, mssql_FreeTDSConfig_Unit, fbmToolsUnit;

{$R *.lfm}

procedure LoadServerList(const Values: TStrings);
var
  Ini:TIniFile;
  k:integer;
begin
  (*
  Ini:=TIniFile.Create(Utf8to ConfFileName);
  Ini.ReadSections(Values);
  Ini.Free;
  k:=Values.IndexOf('global');
  if k>=0 then
    Values.Delete(k);
*)
end;

{ Tcf_mssql_main_frame }

procedure Tcf_mssql_main_frame.Button2Click(Sender: TObject);
begin
//  ShowTDSConfigForm;
end;

procedure Tcf_mssql_main_frame.edtDBNameChange(Sender: TObject);
begin
  if edtAlias.Text = '' then
    edtAlias.Text:=edtDBName.Text + ' on '+cbServerName.Text;
end;

procedure Tcf_mssql_main_frame.edtDBNameDropDown(Sender: TObject);
begin
  SetDataBaseProps(FDataBase);
  try
    FDataBase.Connected:=true;
    if FDataBase.Connected then
    begin
      edtDBName.Items.Clear;
      quGetDBList.Open;
      while not quGetDBList.Eof do
      begin
        edtDBName.Items.Add(quGetDBList.Fields[0].AsString);
        quGetDBList.Next;
      end;
      quGetDBList.Close;
    end;
  finally
    if quGetDBList.Active then
      quGetDBList.Close;
    FDataBase.Connected:=false;
  end;
end;

procedure Tcf_mssql_main_frame.LoadConf;
//var
//  i:TCTServerVersion;
begin
  //LoadServerList(cbServerName.Items);
  //edtSvrVersion.Items.Clear;
  //for i:= Low(TCTServerVersion) to high(TCTServerVersion) do
  //  edtSvrVersion.Items.Add(ServerNames[i]);
end;

procedure Tcf_mssql_main_frame.SetDataBaseProps(ADataBase: TZConnection);
var
  S: String;
begin
  {$IF (ZEOS_MAJOR_VERSION = 7) and  (ZEOS_MINOR_VERSION < 3)}
  ADataBase.Protocol:='FreeTDS_MsSQL>=2005';
  {$ELSE}
  ADataBase.Protocol:='mssql';
  {$ENDIF}
  S:='/usr/lib64/libsybdb.so';
  ADataBase.LibraryLocation:=S;
  //ADataBase.Database:=edtDBName.Text;
  //ADataBase.UserName:=edtUserName.Text;
  //ADataBase.Password:=edtPassword.Text;
  //ADataBase.ServerName:=cbServerName.Text;

  ADataBase.HostName:=cbServerName.Text;
  ADataBase.Database:=edtDBName.Text;
  ADataBase.User:=edtUserName.Text;
  ADataBase.Password:=edtPassword.Text;

//  ADataBase.ServerVersion:=TCTServerVersion(edtSvrVersion.ItemIndex);
end;

constructor Tcf_mssql_main_frame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FDataBase:=TZConnection.Create(Self);
  quGetDBList.Connection:=FDataBase;
end;

procedure Tcf_mssql_main_frame.Activate;
begin
//  inherited Activate;
end;

procedure Tcf_mssql_main_frame.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  cbServerName.Text:=TMSSQLEngine(ASQLEngine).ServerName;
  edtDBName.Text:=TMSSQLEngine(ASQLEngine).DataBaseName;
  edtUserName.Text:=TMSSQLEngine(ASQLEngine).UserName;
  edtPassword.Text:=TMSSQLEngine(ASQLEngine).Password;
  //edtSvrVersion.ItemIndex:=Ord(TMSSQLEngine(ASQLEngine).ServerVersion);
  edtAlias.Text:=TMSSQLEngine(ASQLEngine).AliasName;
end;

procedure Tcf_mssql_main_frame.SaveParams;
begin
  FSQLEngine.ServerName    := cbServerName.Text;
  FSQLEngine.DataBaseName  := edtDBName.Text;
  FSQLEngine.UserName      := edtUserName.Text;
  FSQLEngine.Password      := edtPassword.Text;
  //FSQLEngine.ServerVersion := TCTServerVersion(edtSvrVersion.ItemIndex);
  FSQLEngine.AliasName     := edtAlias.Text;
end;

function Tcf_mssql_main_frame.PageName: string;
begin
  Result:='Global';
end;

function Tcf_mssql_main_frame.Validate: boolean;
begin
  Result:=true;
end;

function Tcf_mssql_main_frame.TestConnection: boolean;
begin
  Result:=false;
  SetDataBaseProps(FDataBase);
  try
    FDataBase.Connected:=true;
    Result:=FDataBase.Connected;
  except
    on E:Exception do
      ErrorBoxExcpt(E);
  end;
  FDataBase.Connected:=false;
end;

constructor Tcf_mssql_main_frame.Create(ASQLEngineAbstract: TSQLEngineAbstract;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngine:=TMSSQLEngine( ASQLEngineAbstract);
  LoadConf;
end;

end.

