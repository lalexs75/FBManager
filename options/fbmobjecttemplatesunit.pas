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
unit fbmObjectTemplatesunit;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    fdbm_PagedDialogUnit; 

type

  { TfbmObjectTemplatesForm }

  TfbmObjectTemplatesForm = class(Tfdbm_PagedDialogForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  protected
    procedure CreatePages;override;
    procedure Localize;override;
  public
    { public declarations }
  end; 

var
  fbmObjectTemplatesForm: TfbmObjectTemplatesForm;

implementation
uses SQLEngineAbstractUnit, fbm_VisualEditorsAbstractUnit, fbmStrConstUnit;

{$R *.lfm}

{ TfbmObjectTemplatesForm }

procedure TfbmObjectTemplatesForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveConfig;
end;

procedure TfbmObjectTemplatesForm.CreatePages;

procedure DoMakePages(ADBVisualTools:TDBVisualToolsClass);
var
  i:integer;
begin
  if not Assigned(ADBVisualTools) then exit;
  for i:=0 to ADBVisualTools.GetObjTemplatePagesCount-1 do
    AddPage(ADBVisualTools.GetObjTemplate(I, Self));
end;

var
  i:integer;
begin
  for i:=0 to SQLEngineAbstractClassCount-1 do
    DoMakePages(SQLEngineAbstractClassArray[i].VisualToolsClass);
  LoadConfig;
end;

procedure TfbmObjectTemplatesForm.Localize;
begin
  inherited Localize;
  Caption:=sDatabaseObjectTemplates;
end;

end.

