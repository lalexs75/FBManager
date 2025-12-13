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

unit fdbmVisualOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, fdbm_PagedDialogUnit;

type

  { TfdbmVisualOptionsForm }

  TfdbmVisualOptionsForm = class(Tfdbm_PagedDialogForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
  protected
    procedure CreatePages;override;
    procedure Localize;override;
  public

  end;

var
  fdbmVisualOptionsForm: TfdbmVisualOptionsForm;

implementation
uses fbmStrConstUnit, fdbmIOConfigPageUnit;

{$R *.lfm}

{ TfdbmVisualOptionsForm }

procedure TfdbmVisualOptionsForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if ModalResult=mrOk then
    SaveConfig;
end;

procedure TfdbmVisualOptionsForm.CreatePages;
begin
  inherited CreatePages;

  AddPage(TfdbmIOConfigPage.Create(Self));

  LoadConfig;
end;

procedure TfdbmVisualOptionsForm.Localize;
begin
  inherited Localize;
  Caption:=sVisualOptions;
end;

end.

