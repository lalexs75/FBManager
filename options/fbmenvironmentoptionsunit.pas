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

unit fbmEnvironmentOptionsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, ExtCtrls, RxIniPropStorage,
  fdbm_PagedDialogUnit;

type

  { TfbmEnvironmentOptionsForm }

  TfbmEnvironmentOptionsForm = class(Tfdbm_PagedDialogForm)
    RxIniPropStorage1: TRxIniPropStorage;
    procedure ibmEnvironmentOptionsFormClose(Sender: TObject;
      var CloseAction: TCloseAction);
  private
    procedure DoMakePages;
  protected
    procedure CreatePages;override;
    procedure Localize;override;
  public
    { public declarations }
  end; 

var
  fbmEnvironmentOptionsForm: TfbmEnvironmentOptionsForm;

implementation
uses SQLEngineAbstractUnit, fbm_VisualEditorsAbstractUnit, fbmToolsUnit,
  fbmStrConstUnit, fbmUserDataBaseUnit, cfOIUnit, cfGridOptionsUnit,
  cfReportsOptionsUnit, cfGeneralOptionsUnit, cfSQLEditorOptionsUnit,
  cfSystemConfirmationUnit, fbmCompatibilitySystemUnit, fbmDocsSystemConfigUnit,
  SSHConnectionPluginConfigUnit;

{$R *.lfm}

{ TfbmEnvironmentOptionsForm }


procedure TfbmEnvironmentOptionsForm.ibmEnvironmentOptionsFormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  if ModalResult=mrOk then
    SaveConfig;
end;

procedure TfbmEnvironmentOptionsForm.DoMakePages;
var
  i, j:integer;
begin
  for i:=0 to SQLEngineAbstractClassCount-1 do
  begin
    for j:=0 to SQLEngineAbstractClassArray[i].VisualToolsClass.ConfigDlgPageCount - 1 do
      AddPage(SQLEngineAbstractClassArray[i].VisualToolsClass.ConfigDlgPage(j, self));
  end
end;

procedure TfbmEnvironmentOptionsForm.CreatePages;
begin
  //Add standart pages
  AddPage(TcfGeneralOptionsFrame.Create(Self));
  AddPage(TcfOIFrame.Create(Self));
  AddPage(TcfSystemConfirmationFrame.Create(Self));
  AddPage(TcfSQLEditorOptionsFrame.Create(Self));
  AddPage(TcfGridOptionsFrame.Create(Self));
  AddPage(TcfReportsOptionsFrame.Create(Self));
  AddPage(TfbmCompatibilitySystemFrame.Create(Self));
  //Add pages for SQLEngine's objects
  DoMakePages;
  //
  AddPage(TSSHConnectionPluginConfig.Create(Self));
  AddPage(TfbmDocsSystemConfigFrame.Create(Self));

  //Load param in pages
  LoadConfig;
end;

procedure TfbmEnvironmentOptionsForm.Localize;
begin
  inherited Localize;
  Caption:=sEnvironmentOptions;
end;


end.

