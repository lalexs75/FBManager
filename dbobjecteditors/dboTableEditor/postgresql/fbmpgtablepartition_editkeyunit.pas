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
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    procedure Localize;
  public
    FEditorFrame:Tfdbm_SynEditorFrame;
  end;

var
  fbmPGTablePartition_EditKeyForm: TfbmPGTablePartition_EditKeyForm;

implementation

uses rxAppUtils, fbmStrConstUnit;

{$R *.lfm}

{ TfbmPGTablePartition_EditKeyForm }

procedure TfbmPGTablePartition_EditKeyForm.FormCreate(Sender: TObject);
begin
  FEditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  FEditorFrame.Parent:=Panel1;
  FEditorFrame.Align:=alClient;
  Localize;
end;

procedure TfbmPGTablePartition_EditKeyForm.RadioButton1Change(Sender: TObject);
begin
  ComboBox1.Enabled:=RadioButton1.Checked;
  FEditorFrame.Enabled:=RadioButton1.Checked;
end;

procedure TfbmPGTablePartition_EditKeyForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOK then
  begin
    if RadioButton1.Checked then
    begin
      CanClose:=(ComboBox1.Text<>'') and (ComboBox1.Items.IndexOf(ComboBox1.Text)>=0);
      if not CanClose then
        ErrorBox(sFieldNameReq);
    end
    else
    if RadioButton2.Checked then
    begin
      CanClose:=(Trim(FEditorFrame.EditorText)<>'');
      if not CanClose then
        ErrorBox(sInvalidPartitionExpressison);
    end
  end;
end;

procedure TfbmPGTablePartition_EditKeyForm.Localize;
begin
  FEditorFrame.Localize;

  Caption:=sPartitionKeyValue;
  RadioButton1.Caption:=sTableField;
  RadioButton2.Caption:=sPartitionExpression;
end;

end.

