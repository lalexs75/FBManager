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

unit fbmPGTablePartition_EditKeyUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, fdbm_SynEditorUnit,
  ButtonPanel;

type

  { TfbmPGTablePartition_EditKeyForm }

  TfbmPGTablePartition_EditKeyForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormCreate(Sender: TObject);
  private
    procedure Localize;
  public
    FEditorFrame:Tfdbm_SynEditorFrame;
  end;

var
  fbmPGTablePartition_EditKeyForm: TfbmPGTablePartition_EditKeyForm;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmPGTablePartition_EditKeyForm }

procedure TfbmPGTablePartition_EditKeyForm.FormCreate(Sender: TObject);
begin
  FEditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  FEditorFrame.Parent:=Panel1;
  FEditorFrame.Align:=alClient;
  Localize;
end;

procedure TfbmPGTablePartition_EditKeyForm.Localize;
begin
  FEditorFrame.Localize;

  Caption:=sPartitionKeyValue;
  RadioButton1.Caption:=sTableField;
  RadioButton2.Caption:=sPartitionExpression;
end;

end.

