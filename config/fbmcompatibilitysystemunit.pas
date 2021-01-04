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

unit fbmCompatibilitySystemUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, 
    cfabstractconfigframeunit;

type

  { TfbmCompatibilitySystemFrame }

  TfbmCompatibilitySystemFrame = class(TFBMConfigPageAbstract)
    RadioGroup1: TRadioGroup;
  private
    //
  public
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TfbmCompatibilitySystemFrame }

function TfbmCompatibilitySystemFrame.PageName: string;
begin
  Result:=sCompatibility;
end;

procedure TfbmCompatibilitySystemFrame.LoadData;
begin
  RadioGroup1.ItemIndex:=ConfigValues.ByNameAsInteger('Compatibility_SystemCommentStyle', 0);
end;

procedure TfbmCompatibilitySystemFrame.SaveData;
begin
  ConfigValues.SetByNameAsInteger('Compatibility_SystemCommentStyle', RadioGroup1.ItemIndex);
end;

procedure TfbmCompatibilitySystemFrame.Localize;
begin
  inherited Localize;
  RadioGroup1.Caption:=sSystemCommentStyle;
  RadioGroup1.Items[0]:=sComFBMStyle;
  RadioGroup1.Items[1]:=sComIBEStyle;
end;

end.

