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

unit ibmanagertablefieldeditorArrayBoundunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons, ButtonPanel;

type

  { TibmanagertablefieldeditorArrayBoundForm }

  TibmanagertablefieldeditorArrayBoundForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure FormCreate(Sender: TObject);
  private
    procedure Localize;
  public
    { public declarations }
  end; 

var
  ibmanagertablefieldeditorArrayBoundForm: TibmanagertablefieldeditorArrayBoundForm;

implementation
uses fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

{ TibmanagertablefieldeditorArrayBoundForm }

procedure TibmanagertablefieldeditorArrayBoundForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TibmanagertablefieldeditorArrayBoundForm.Localize;
begin
  Caption:=sArrayBound;
  Label1.Caption:=sUpper;
  Label2.Caption:=sLower;
end;

end.

