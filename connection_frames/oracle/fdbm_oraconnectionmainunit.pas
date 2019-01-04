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

unit fdbm_OraConnectionMainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, fbmConnectionEditUnit,
  StdCtrls, SQLEngineAbstractUnit, OracleSQLEngine, ExtCtrls,
  fdbm_ConnectionAbstractUnit;

type

  { TfdbmOraConnectionMainFrame }

  TfdbmOraConnectionMainFrame = class(TConnectionDlgPage)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    edtDBName: TComboBox;
    edtUserName: TEdit;
    edtPasswd: TEdit;
    edtAliasName: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure edtDBNameExit(Sender: TObject);
  private
    FSQLEngineOracle:TSQLEngineOracle;
  public
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation
uses fbmStrConstUnit, SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TfdbmOraConnectionMainFrame }

procedure TfdbmOraConnectionMainFrame.edtDBNameExit(Sender: TObject);
begin
  if edtAliasName.Text = '' then
    edtAliasName.Text:=Format(sAliasOfDB, [edtDBName.Text]);
end;


procedure TfdbmOraConnectionMainFrame.LoadParams(ASQLEngine: TSQLEngineAbstract
  );
begin
  edtAliasName.Text:= FSQLEngineOracle.AliasName;
  edtDBName.Text:= FSQLEngineOracle.DataBaseName;
  edtUserName.Text:= FSQLEngineOracle.UserName;
  edtPasswd.Text:= FSQLEngineOracle.Password;
  RadioButton1.Checked:= FSQLEngineOracle.AuthenticationType = atOS;
  RadioButton2.Checked:= FSQLEngineOracle.AuthenticationType = atServer;
end;

procedure TfdbmOraConnectionMainFrame.SaveParams;
begin
  if Assigned(FSQLEngineOracle) then
  begin
    FSQLEngineOracle.AliasName:=edtAliasName.Text;
    FSQLEngineOracle.DataBaseName:=edtDBName.Text;
    FSQLEngineOracle.UserName:=edtUserName.Text;
    FSQLEngineOracle.Password:=edtPasswd.Text;
    FSQLEngineOracle.AuthenticationType:=TAuthenticationType(RadioButton2.Checked);
  end
end;

function TfdbmOraConnectionMainFrame.PageName: string;
begin
  Result:=sLogFiles;
end;

constructor TfdbmOraConnectionMainFrame.Create(
  ASQLEngineAbstract: TSQLEngineAbstract; AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngineOracle:=TSQLEngineOracle(ASQLEngineAbstract);
end;

end.

