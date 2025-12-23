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

unit fbmshadowmanager_editunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons, EditBtn, rxdbgrid, RxIniPropStorage, ButtonPanel;

type

  { TfbmShadowManagerEditForm }

  TfbmShadowManagerEditForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RxDBGrid1: TRxDBGrid;
    RxIniPropStorage1: TRxIniPropStorage;
    SpinEdit1: TSpinEdit;
    procedure RadioButton2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fbmShadowManagerEditForm: TfbmShadowManagerEditForm;

implementation

{$R *.lfm}

{ TfbmShadowManagerEditForm }

procedure TfbmShadowManagerEditForm.RadioButton2Change(Sender: TObject);
begin
  CheckBox1.Enabled:=RadioButton2.Checked;
end;

end.

