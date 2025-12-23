{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbm_ssh_ParamsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn, 
    fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit;

type

  { Tfdbm_ssh_ParamsPage }

  Tfdbm_ssh_ParamsPage = class(TConnectionDlgPage)
    CheckBox1: TCheckBox;
    edtHostName: TEdit;
    edtPort: TEdit;
    edtUser: TEdit;
    edtPassword: TEdit;
    edtIdentifyFile: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure CheckBox1Change(Sender: TObject);
  private
    FSQLEngine:TSQLEngineAbstract;
    procedure InitFrame;
  public
    constructor Create(ASQLEngine:TSQLEngineAbstract; AOwner:TForm);
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
  end;

implementation
uses fbmStrConstUnit, SSHConnectionUnit;

{$R *.lfm}

{ Tfdbm_ssh_ParamsPage }

procedure Tfdbm_ssh_ParamsPage.CheckBox1Change(Sender: TObject);
begin
  Label1.Enabled:=CheckBox1.Checked;
  edtHostName.Enabled:=CheckBox1.Checked;
  Label2.Enabled:=CheckBox1.Checked;
  edtPort.Enabled:=CheckBox1.Checked;
  Label3.Enabled:=CheckBox1.Checked;
  edtUser.Enabled:=CheckBox1.Checked;
  RadioButton1.Enabled:=CheckBox1.Checked;
  edtPassword.Enabled:=CheckBox1.Checked and RadioButton1.Checked;
  RadioButton2.Enabled:=CheckBox1.Checked;
  edtIdentifyFile.Enabled:=CheckBox1.Checked and RadioButton2.Checked;
end;

procedure Tfdbm_ssh_ParamsPage.InitFrame;
begin

end;

constructor Tfdbm_ssh_ParamsPage.Create(ASQLEngine: TSQLEngineAbstract;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngine:=ASQLEngine;

  CheckBox1Change(nil);
end;

procedure Tfdbm_ssh_ParamsPage.Localize;
begin
  CheckBox1.Caption:=sUseSSHTunnel;
  Label1.Caption:=sSSHHost;
  Label2.Caption:=sSSHPort;
  Label3.Caption:=sSSHUser;
  RadioButton1.Caption:=sSSHPassword;
  RadioButton2.Caption:=sSSHIdentifyFile;
end;

procedure Tfdbm_ssh_ParamsPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
var
  P: TSSHConnectionPlugin;
begin
  P:=ASQLEngine.ConnectionPlugins.FindPlugin(TSSHConnectionPlugin) as TSSHConnectionPlugin;
  if Assigned(P) then
  begin
    CheckBox1.Checked:=P.Enabled;
    edtHostName.Text:=P.Host;
    edtPort.Text:=IntToStr(P.Port);
    edtUser.Text:=P.UserName;
    edtPassword.Text:=P.Password;
    RadioButton1.Checked:=P.AuthType = autPassword;
  end;
end;

procedure Tfdbm_ssh_ParamsPage.SaveParams;
var
  P: TSSHConnectionPlugin;
begin
  P:=FSQLEngine.ConnectionPlugins.FindPlugin(TSSHConnectionPlugin) as TSSHConnectionPlugin;
  if Assigned(P) then
  begin
    P.Enabled        := CheckBox1.Checked;
    P.Host           := edtHostName.Text;
    P.Port :=StrToInt(edtPort.Text);
    P.UserName       := edtUser.Text;
    P.Password       := edtPassword.Text;
    if RadioButton1.Checked then
      P.AuthType := autPassword
    else
      P.AuthType := autKey;
  end;
end;

function Tfdbm_ssh_ParamsPage.PageName: string;
begin
  Result:=sConnectViaSSH;
end;

function Tfdbm_ssh_ParamsPage.Validate: boolean;
begin
  Result:=true;
end;

function Tfdbm_ssh_ParamsPage.TestConnection: boolean;
begin
  { TODO : Необходимо реализовать метод проверки подключения через SSH }
  Result:=true;
end;

end.

