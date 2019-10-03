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

unit fbmPGTablePartition_EditSectionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel;

type

  { TfbmPGTablePartition_EditSectionForm }

  TfbmPGTablePartition_EditSectionForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure Localize;
  end;

var
  fbmPGTablePartition_EditSectionForm: TfbmPGTablePartition_EditSectionForm;

implementation
uses rxAppUtils, fbmStrConstUnit;

{$R *.lfm}

{ TfbmPGTablePartition_EditSectionForm }

procedure TfbmPGTablePartition_EditSectionForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmPGTablePartition_EditSectionForm.Localize;
begin
  RadioButton1.Caption:=sDefaultSection;
end;

end.

