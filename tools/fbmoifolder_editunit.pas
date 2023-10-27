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

unit fbmOIFolder_EditUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel;

type

  { TfbmOIFolder_EditForm }

  TfbmOIFolder_EditForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    procedure Localize;
  public
    { public declarations }
  end;

var
  fbmOIFolder_EditForm: TfbmOIFolder_EditForm;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmOIFolder_EditForm }

procedure TfbmOIFolder_EditForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmOIFolder_EditForm.Localize;
begin
  Caption:=sEnterFolderData;
  Label1.Caption:=sCreateNewFolderText;
  Label2.Caption:=sEditFolderDesc;

end;

end.

