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

unit ibmUserSecEditUserUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, LCLType, Spin, ButtonPanel, RxIniPropStorage;

type

  { TibmUserSecEditUserForm }

  TibmUserSecEditUserForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    RxIniPropStorage1: TRxIniPropStorage;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure ibmUserSecEditUserFormCloseQuery(Sender: TObject;
      var CanClose: boolean);
  private
    procedure Localize;
  public
    { public declarations }
  end; 

var
  ibmUserSecEditUserForm: TibmUserSecEditUserForm;

implementation
uses rxAppUtils, fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

{ TibmUserSecEditUserForm }

procedure TibmUserSecEditUserForm.ibmUserSecEditUserFormCloseQuery(
  Sender: TObject; var CanClose: boolean);
begin
  if ModalResult=mrOk then
  begin
    CanClose:=Edit2.Text=Edit3.Text;
    if not CanClose then
      ErrorBox(sPasswordmismath);
  end;
end;

procedure TibmUserSecEditUserForm.Localize;
begin
  Caption:=sEditUser;
  Label1.Caption:=sUserName1;
  Label2.Caption:=sPassword;
  Label3.Caption:=sConfirmPassword;
  Label4.Caption:=sFirstName;
  Label5.Caption:=sMiddleName;
  Label6.Caption:=sLastName;
  Label7.Caption:=sDescription;
  Label8.Caption:=sUserID;
  Label9.Caption:=sGroupID;
end;

procedure TibmUserSecEditUserForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

end.

