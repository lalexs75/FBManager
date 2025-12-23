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


unit cfOIUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls,
  cfAbstractConfigFrameUnit;

type

  { TcfOIFrame }

  TcfOIFrame = class(TFBMConfigPageAbstract)
    CheckBox1: TCheckBox;
    io_cbDisableResize: TCheckBox;
    io_cbShowOIHint: TCheckBox;
  private
    { private declarations }
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TcfOIFrame }

procedure TcfOIFrame.Localize;
begin
  inherited Localize;
  io_cbShowOIHint.Caption:=sShowObjectDescriptionsAsHint;
  io_cbDisableResize.Caption:=sDisableResize;
  CheckBox1.Caption:=sHotTrack;
end;

function TcfOIFrame.PageName: string;
begin
  Result:=sObjectInspector;
end;

procedure TcfOIFrame.LoadData;
begin
  {OI}
  io_cbDisableResize.Checked:=ConfigValues.ByNameAsBoolean('oiDisableResize', false);
  io_cbShowOIHint.Checked:=ConfigValues.ByNameAsBoolean('oiShowObjDescAsHint', true);
  CheckBox1.Checked:=ConfigValues.ByNameAsBoolean('oiHotTrack', false);
end;

procedure TcfOIFrame.SaveData;
begin
  ConfigValues.SetByNameAsBoolean('oiDisableResize', io_cbDisableResize.Checked);
  ConfigValues.SetByNameAsBoolean('oiShowObjDescAsHint', io_cbShowOIHint.Checked);
  ConfigValues.SetByNameAsBoolean('oiHotTrack', CheckBox1.Checked);
end;

end.

