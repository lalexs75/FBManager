{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbmIOConfigPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  cfAbstractConfigFrameUnit;

type

  { TfdbmIOConfigPage }

  TfdbmIOConfigPage = class(TFBMConfigPageAbstract)
    RadioGroup1: TRadioGroup;
  private

  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation

uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TfdbmIOConfigPage }

constructor TfdbmIOConfigPage.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

function TfdbmIOConfigPage.PageName: string;
begin
  Result:=sObjectInspector;
end;

procedure TfdbmIOConfigPage.LoadData;
begin
  RadioGroup1.ItemIndex:=ConfigValues.ByNameAsInteger('VO/OI/ScrollBars', Ord(ssAutoBoth));
end;

procedure TfdbmIOConfigPage.SaveData;
begin
  ConfigValues.SetByNameAsInteger('VO/OI/ScrollBars', RadioGroup1.ItemIndex);
end;

procedure TfdbmIOConfigPage.Localize;
begin
  inherited Localize;
  RadioGroup1.Caption:=sScrollBarStyle;
  RadioGroup1.Items[0]:=sNone;
  RadioGroup1.Items[1]:=sHorizontal;
  RadioGroup1.Items[2]:=sVertical;
  RadioGroup1.Items[3]:=sBoth;
  RadioGroup1.Items[4]:=sAutoHorizontal;
  RadioGroup1.Items[5]:=sAutoVertical;
  RadioGroup1.Items[6]:=sAutoBoth;
end;


end.

