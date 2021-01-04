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

unit cf_mssql_mainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, {TDSCTDataBase, }fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit,
  mssq_engine, ZConnection, ZDataset;
(*
const
  ServerNames : array [TCTServerVersion] of string =
    ('MS SQL 6.0', 'MS SQL 6.5', 'MS SQL 7.0', 'MS SQL 2000',
     'MS SQL 2005', 'MS SQL 2008', 'Sybase SQL 10', 'Sybase SQL 9');
*)
type

  { Tcf_mssql_main_frame }

  Tcf_mssql_main_frame = class(TConnectionDlgPage)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    edtAlias: TEdit;
    edtDataBase: TComboBox;
    edtPass: TEdit;
    edtServer: TComboBox;
    edtSvrVersion: TComboBox;
    edtUserName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    quGetDBList: TZQuery;
    TDSCTDataBase1: TZConnection;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure edtDataBaseChange(Sender: TObject);
    procedure edtDataBaseDropDown(Sender: TObject);
  private
    FSQLEngine:TMSSQLEngine;
    FDataBase:TZConnection;
    procedure LoadConf;
    procedure SetDataBaseProps(ADataBase:TZConnection);
  public
    procedure Activate;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

var
  cf_mssql_main_frame: Tcf_mssql_main_frame;

implementation
uses IniFiles, mssql_FreeTDSConfig_Unit;

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
  ShowTDSConfigForm;
end;

procedure Tcf_mssql_main_frame.edtDataBaseChange(Sender: TObject);
begin
  if edtAlias.Text = '' then
    edtAlias.Text:=edtDataBase.Text + ' on '+edtServer.Text;
end;

procedure Tcf_mssql_main_frame.edtDataBaseDropDown(Sender: TObject);
begin
(*
  SetDataBaseProps(TDSCTDataBase1);
  try
    TDSCTDataBase1.Connected:=true;
    if TDSCTDataBase1.Connected then
    begin
      edtDataBase.Items.Clear;
      quGetDBList.Open;
      while not quGetDBList.Eof do
      begin
        edtDataBase.Items.Add(quGetDBList.AsString[0]);
        quGetDBList.Next;
      end;
      quGetDBList.Close;
    end;
  finally
    if quGetDBList.Active then
      quGetDBList.Close;
    TDSCTDataBase1.Connected:=false;
  end;
*)
end;

procedure Tcf_mssql_main_frame.LoadConf;
//var
//  i:TCTServerVersion;
begin
  //LoadServerList(edtServer.Items);
  //edtSvrVersion.Items.Clear;
  //for i:= Low(TCTServerVersion) to high(TCTServerVersion) do
  //  edtSvrVersion.Items.Add(ServerNames[i]);
end;

procedure Tcf_mssql_main_frame.SetDataBaseProps(ADataBase: TZConnection);
begin
  //ADataBase.Database:=edtDataBase.Text;
  //ADataBase.UserName:=edtUserName.Text;
  //ADataBase.Password:=edtPass.Text;
  //ADataBase.ServerName:=edtServer.Text;
  //ADataBase.ServerVersion:=TCTServerVersion(edtSvrVersion.ItemIndex);
end;

procedure Tcf_mssql_main_frame.Button1Click(Sender: TObject);
begin
  SetDataBaseProps(TDSCTDataBase1);
  try
    TDSCTDataBase1.Connected:=true;
    ShowMessage('sreg_succes_connected');
  except
    on E:Exception do
      ShowMessage('sreg_connection_error' + ' : ' +  E.Message);
  end;
  TDSCTDataBase1.Connected:=false;
end;

procedure Tcf_mssql_main_frame.Activate;
begin
//  inherited Activate;
end;

procedure Tcf_mssql_main_frame.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  //edtServer.Text:=TMSSQLEngine(ASQLEngine).ServerName;
  //edtDataBase.Text:=TMSSQLEngine(ASQLEngine).DataBaseName;
  //edtUserName.Text:=TMSSQLEngine(ASQLEngine).UserName;
  //edtPass.Text:=TMSSQLEngine(ASQLEngine).Password;
  //edtSvrVersion.ItemIndex:=Ord(TMSSQLEngine(ASQLEngine).ServerVersion);
  //edtAlias.Text:=TMSSQLEngine(ASQLEngine).AliasName;
end;

procedure Tcf_mssql_main_frame.SaveParams;
begin
  //FSQLEngine.ServerName    := edtServer.Text;
  //FSQLEngine.DataBaseName  := edtDataBase.Text;
  //FSQLEngine.UserName      := edtUserName.Text;
  //FSQLEngine.Password      := edtPass.Text;
  //FSQLEngine.ServerVersion := TCTServerVersion(edtSvrVersion.ItemIndex);
  //FSQLEngine.AliasName     := edtAlias.Text;
end;

function Tcf_mssql_main_frame.PageName: string;
begin
  Result:='Global';
end;

function Tcf_mssql_main_frame.Validate: boolean;
begin
  Result:=true;
end;

constructor Tcf_mssql_main_frame.Create(ASQLEngineAbstract: TSQLEngineAbstract;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngine:=TMSSQLEngine( ASQLEngineAbstract);
  LoadConf;
end;

end.

