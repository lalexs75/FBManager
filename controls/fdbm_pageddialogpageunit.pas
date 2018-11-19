{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbm_PagedDialogPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms;

type
  { TPagedDialogPage }

  TPagedDialogPage = class(TFrame)
  public
    constructor Create(TheOwner: TComponent); override;
  public
    procedure Localize;virtual;
    procedure LoadData;virtual;
    procedure SaveData;virtual;
    procedure Activate;virtual;
    function PageName:string;virtual;abstract;
    function Validate:boolean;virtual;
  end;

implementation

{$R *.lfm}

{ TPagedDialogPage }

constructor TPagedDialogPage.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Localize;
end;

procedure TPagedDialogPage.Localize;
begin

end;

procedure TPagedDialogPage.LoadData;
begin

end;

procedure TPagedDialogPage.SaveData;
begin

end;

procedure TPagedDialogPage.Activate;
begin
  //
end;

function TPagedDialogPage.Validate: boolean;
begin
  Result:=true;
end;

end.

