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

unit fbmErrorBoxUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, ExtCtrls, ButtonPanel, StdCtrls;

type

  { TfbmErrorBoxForm }

  TfbmErrorBoxForm = class(TForm)
    BitBtn1: TBitBtn;
    ButtonPanel1: TButtonPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fbmErrorBoxForm: TfbmErrorBoxForm;

implementation
uses fbmErrorSubmitUnit,
  IBManMainUnit, fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TfbmErrorBoxForm }

procedure TfbmErrorBoxForm.BitBtn1Click(Sender: TObject);
begin
  fbmErrorSubmitForm:=TfbmErrorSubmitForm.Create(Application);
  try
    fbmErrorSubmitForm.InitBugTracker(Memo1.Text);
    fbmErrorSubmitForm.ShowModal;
  finally
    fbmErrorSubmitForm.Free;
  end;
end;

procedure TfbmErrorBoxForm.Label1Click(Sender: TObject);
var
  ErrMsg:string;
begin
  ErrMsg:='';
  fbManagerMainForm.HTMLHelpDatabase1.ShowURL(netProgectURL, sFBManagerWebSite, ErrMsg);
end;

procedure TfbmErrorBoxForm.Label1MouseEnter(Sender: TObject);
begin
  Label1.Font.Color:=clBlue;
  Label1.Font.Style:=Label1.Font.Style + [fsUnderline]
end;

procedure TfbmErrorBoxForm.Label1MouseLeave(Sender: TObject);
begin
  Label1.Font.Color:=clWindowText;
  Label1.Font.Style:=Label1.Font.Style - [fsUnderline]
end;

end.

