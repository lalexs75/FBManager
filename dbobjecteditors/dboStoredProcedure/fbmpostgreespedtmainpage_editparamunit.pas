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

unit fbmPostGreeSPedtMainPage_EditParamUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel;

type

  { TfbmPostGreeSPedtMainPage_EditParamForm }

  TfbmPostGreeSPedtMainPage_EditParamForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    cbType: TComboBox;
    cbInOut: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    procedure Localize;
  public
    { public declarations }
  end; 

var
  fbmPostGreeSPedtMainPage_EditParamForm: TfbmPostGreeSPedtMainPage_EditParamForm;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmPostGreeSPedtMainPage_EditParamForm }

procedure TfbmPostGreeSPedtMainPage_EditParamForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmPostGreeSPedtMainPage_EditParamForm.Localize;
begin
  Caption:=sParamProp;
  Label1.Caption:=sParamName;
  Label2.Caption:=sParamType;
  Label3.Caption:=sInputOutput;
  Label4.Caption:=sDefaultValue;
  Label5.Caption:=sDescription;
end;

end.

