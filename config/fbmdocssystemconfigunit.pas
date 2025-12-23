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

unit fbmDocsSystemConfigUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, 
    cfAbstractConfigFrameUnit;

type

  { TfbmDocsSystemConfigFrame }

  TfbmDocsSystemConfigFrame = class(TFBMConfigPageAbstract)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private

  public
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TfbmDocsSystemConfigFrame }

function TfbmDocsSystemConfigFrame.PageName: string;
begin
  Result:=sConfigHelpPage;
end;

procedure TfbmDocsSystemConfigFrame.LoadData;
begin
  inherited LoadData;
  Edit1.Text:=ConfigValues.ByNameAsString('Help/PostgreSQL docs URL', sPostgreSQLHelpURL);
end;

procedure TfbmDocsSystemConfigFrame.SaveData;
begin
  inherited SaveData;
  ConfigValues.SetByNameAsString('Help/PostgreSQL docs URL', Edit1.Text);
end;

procedure TfbmDocsSystemConfigFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sPostgreSQLHelpURLLabel;
  Label2.Caption:=sPostgreSQLHelpURLHint;
end;

end.

