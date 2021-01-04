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

unit fbmConnectionEditUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ButtonPanel, fdbm_PagedDialogUnit, Buttons, StdCtrls, ExtCtrls,
  fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit;

type

  { TfbmConnectionEditForm }

  TfbmConnectionEditForm = class(Tfdbm_PagedDialogForm)
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    FSQLEngine:TSQLEngineAbstract;
    procedure SaveParams;
    procedure CreatePages;override;
    procedure AlignTestBtn;
  protected
    procedure Localize;override;
  public
    constructor Create(ASQLEngine:TSQLEngineAbstract);
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);
  end; 

var
  fbmConnectionEditForm: TfbmConnectionEditForm;

implementation
uses rxAppUtils, fbmToolsUnit, fbmStrConstUnit, fbm_VisualEditorsAbstractUnit;

{$R *.lfm}

{ TfbmConnectionEditForm }

procedure TfbmConnectionEditForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveParams;
end;

procedure TfbmConnectionEditForm.BitBtn1Click(Sender: TObject);
var
  i:integer;
  P:TConnectionDlgPage;
  R:boolean;
begin
  R:=true;
  for i:=0 to PageCount - 1 do
  begin
    P:=Pages[i] as TConnectionDlgPage;
    if not P.TestConnection then
    begin
      PageNumber:=i;
      exit;
    end;
  end;
  InfoBox(sSuccesConnection);
end;

procedure TfbmConnectionEditForm.FormCreate(Sender: TObject);
begin
  BitBtn1.AnchorSideLeft.Control:=ButtonPanel1.HelpButton;
  BitBtn1.AnchorSideBottom.Control:=ButtonPanel1.HelpButton;
  BitBtn1.AnchorSideTop.Control:=ButtonPanel1.HelpButton;
end;

procedure TfbmConnectionEditForm.ListBox1Click(Sender: TObject);
begin
  inherited ListBox1Click(nil);
end;

procedure TfbmConnectionEditForm.SaveParams;
var
  i:integer;
  P:TConnectionDlgPage;
begin
  for i:=0 to PageCount - 1 do
  begin
    P:=Pages[i] as TConnectionDlgPage;
    P.SaveParams;
  end;
end;

procedure TfbmConnectionEditForm.CreatePages;
var
  i, j:integer;
begin
  if Assigned(FSQLEngine) then
    for i:=0 to SQLEngineAbstractClassCount-1 do
    begin
      if SQLEngineAbstractClassArray[i].SQLEngineClass = FSQLEngine.ClassType then
      begin
        for j:=0 to SQLEngineAbstractClassArray[i].VisualToolsClass.ConnectionDlgPageCount-1 do
          AddPage(SQLEngineAbstractClassArray[i].VisualToolsClass.ConnectionDlgPage(FSQLEngine, j, Self));
      end;
    end;
{  if Assigned(FSQLEngine) then
    for i:=0 to FSQLEngine.ConnectionDlgPageCount-1 do
      AddPage(FSQLEngine.ConnectionDlgPage(i, Self));}
end;

procedure TfbmConnectionEditForm.AlignTestBtn;
begin
  BitBtn1.AnchorSideLeft.Control:=ButtonPanel1.HelpButton;
  BitBtn1.AnchorSideTop.Control:=ButtonPanel1.HelpButton;
  BitBtn1.AnchorSideBottom.Control:=ButtonPanel1.HelpButton;
end;

procedure TfbmConnectionEditForm.Localize;
begin
  inherited Localize;
  Caption:=sRegistrationParams;
  BitBtn1.Caption:=sTest;
end;

constructor TfbmConnectionEditForm.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(Application);
  FSQLEngine:=ASQLEngine;
  CreatePages;
  PageNumber:=0;
end;

procedure TfbmConnectionEditForm.LoadParams(ASQLEngine: TSQLEngineAbstract);
var
  i:integer;
  P:TConnectionDlgPage;
begin
  if not Assigned(ASQLEngine) then
    ASQLEngine:=FSQLEngine;
  for i:=0 to ListBox1.Items.Count - 1 do
  begin
    P:=ListBox1.Items.Objects[i] as TConnectionDlgPage;
    P.Lock;
    P.LoadParams(ASQLEngine);
    P.UnLock;
  end;
end;

end.

