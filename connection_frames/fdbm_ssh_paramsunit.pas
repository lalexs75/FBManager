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
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    FileNameEdit1: TFileNameEdit;
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

{$R *.lfm}

{ Tfdbm_ssh_ParamsPage }

procedure Tfdbm_ssh_ParamsPage.CheckBox1Change(Sender: TObject);
begin
  Label1.Enabled:=CheckBox1.Checked;
  Edit1.Enabled:=CheckBox1.Checked;
  Label1.Enabled:=CheckBox1.Checked;
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
  //CheckBox3.Visible:=ASQLEngine is TSQLEnginePostgre;
end;

procedure Tfdbm_ssh_ParamsPage.Localize;
begin
  inherited Localize;
end;

procedure Tfdbm_ssh_ParamsPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin

end;

procedure Tfdbm_ssh_ParamsPage.SaveParams;
begin

end;

function Tfdbm_ssh_ParamsPage.PageName: string;
begin
  Result:='Connect via SSH';
end;

function Tfdbm_ssh_ParamsPage.Validate: boolean;
begin
  Result:=inherited Validate;
end;

function Tfdbm_ssh_ParamsPage.TestConnection: boolean;
begin
  Result:=inherited TestConnection;
end;

end.

