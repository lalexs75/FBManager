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

unit otPostgreTableTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, 
    cfAbstractConfigFrameUnit;

type

  { TotPostgreTableTemplateFrame }

  TotPostgreTableTemplateFrame = class(TFBMConfigPageAbstract)
  private

  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
  end;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TotPostgreTableTemplateFrame }

constructor TotPostgreTableTemplateFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

function TotPostgreTableTemplateFrame.PageName: string;
begin
  Result:=sPGPgSqlTable;
end;

procedure TotPostgreTableTemplateFrame.LoadData;
begin
  inherited LoadData;
end;

procedure TotPostgreTableTemplateFrame.SaveData;
begin
  inherited SaveData;
end;

end.

