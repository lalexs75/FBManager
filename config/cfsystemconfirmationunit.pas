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

unit cfSystemConfirmationUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, Forms, Controls, Graphics, Dialogs,
  StdCtrls, cfAbstractConfigFrameUnit;

type

  { TcfSystemConfirmationFrame }

  TcfSystemConfirmationFrame = class(TFBMConfigPageAbstract)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    DividerBevel1: TDividerBevel;
  private
    { private declarations }
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, SQLEngineCommonTypesUnit;

{$R *.lfm}

{ TcfSystemConfirmationFrame }

constructor TcfSystemConfirmationFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

function TcfSystemConfirmationFrame.PageName: string;
begin
  Result:=sConfirmOptions;
end;

procedure TcfSystemConfirmationFrame.LoadData;
begin
  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean('sysConfirmExit', true);;
  CheckBox2.Checked:=ConfigValues.ByNameAsBoolean('sysConfirmCompileDesc', true);
  CheckBox6.Checked:=ConfigValues.ByNameAsBoolean('sysConfirmCompileGrants', true);

  CheckBox3.Checked:=ConfigValues.ByNameAsBoolean('MDI/MidleClickCloseForm', true);
  CheckBox4.Checked:=ConfigValues.ByNameAsBoolean('MDI/ShowFormCaptions', true);
  CheckBox5.Checked:=ConfigValues.ByNameAsBoolean('MDI/ShowCloseButton', true);

  CheckBox7.Checked:=ConfigValues.ByNameAsBoolean('Grant editor/EnableSetWGOFromPopup', false);
end;

procedure TcfSystemConfirmationFrame.SaveData;
begin
  ConfigValues.SetByNameAsBoolean('sysConfirmExit', CheckBox1.Checked);
  ConfigValues.SetByNameAsBoolean('sysConfirmCompileDesc', CheckBox2.Checked);
  ConfigValues.SetByNameAsBoolean('sysConfirmCompileGrants', CheckBox6.Checked);

  ConfigValues.SetByNameAsBoolean('MDI/MidleClickCloseForm', CheckBox3.Checked);
  ConfigValues.SetByNameAsBoolean('MDI/ShowFormCaptions', CheckBox4.Checked);
  ConfigValues.SetByNameAsBoolean('MDI/ShowCloseButton', CheckBox5.Checked);
  ConfigValues.SetByNameAsBoolean('Grant editor/EnableSetWGOFromPopup', CheckBox7.Checked);
end;

procedure TcfSystemConfirmationFrame.Localize;
begin
  inherited Localize;
  CheckBox1.Caption:=sConfirmExit;
  CheckBox2.Caption:=sConfirmCompileObjectsDescription;
  CheckBox6.Caption:=sConfirmCompileObjectGrants;

  DividerBevel1.Caption:=sMDIOptions;
  CheckBox3.Caption:=sMDIMidleClickCloseForm;
  CheckBox4.Caption:=sMDIShowFormCaptions;
  CheckBox5.Caption:=sMDIShowCloseButton;

  CheckBox7.Caption:=sEnableSetWGOFromPopup;
end;

end.

