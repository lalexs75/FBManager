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

unit ibm_loginform;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  fbmToolsUnit, Buttons, LMessages, StdCtrls, ButtonPanel;

type

  { TibmLoginForm }

  TibmLoginForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    edtServerName: TEdit;
    edtUserName: TEdit;
    edtUserPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    procedure Localize;
  public
    { public declarations }
  end; 

var
  ibmLoginForm: TibmLoginForm;

function ShowIBMLoginForm(const ServerName:string; var UserName, UserPassword:string):boolean;
implementation
uses fbmStrConstUnit;

{$R *.lfm}

function ShowIBMLoginForm(const ServerName: string; var UserName,
  UserPassword: string): boolean;
begin
  ibmLoginForm:=TibmLoginForm.Create(Application);
  try
    ibmLoginForm.edtUserName.Text:=UserName;
    ibmLoginForm.edtUserPassword.Text:=UserPassword;
    ibmLoginForm.edtServerName.Text:=ServerName;
    Result:=ibmLoginForm.ShowModal = mrOk;
    if Result then
    begin
      UserName:=ibmLoginForm.edtUserName.Text;
      UserPassword:=ibmLoginForm.edtUserPassword.Text;
    end;
  finally
    ibmLoginForm.Free;
  end;
end;

{ TibmLoginForm }

procedure TibmLoginForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TibmLoginForm.Localize;
begin
  Caption:=sLoginForm;
  Label1.Caption:=sServerName1;
  Label2.Caption:=sUserName1;
  Label3.Caption:=sUserPassword;
end;

end.

