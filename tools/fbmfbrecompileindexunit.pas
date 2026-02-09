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

unit fbmFBRecompileIndexUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, CheckLst, ActnList,
  ExtCtrls, rxtoolbar, uib, FBSQLEngineUnit;

type

  { TfbmFBRecompileIndexForm }

  TfbmFBRecompileIndexForm = class(TForm)
    actExecute: TAction;
    ActionList1: TActionList;
    CheckListBox1: TCheckListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    ToolPanel1: TToolPanel;
    UIBQuery1: TUIBQuery;
    procedure actExecuteExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FFBSQLEngine: TSQLEngineFireBird;
    procedure SetFBSQLEngine(const AValue: TSQLEngineFireBird);
    procedure Localize;

  public
    property FBSQLEngine:TSQLEngineFireBird read FFBSQLEngine write SetFBSQLEngine;
  end;

var
  fbmFBRecompileIndexForm: TfbmFBRecompileIndexForm = nil;

procedure ShowRecompileFBIndexForm(AFBSQLEngine:TSQLEngineFireBird);
implementation

uses fbmStrConstUnit, fbmToolsUnit, IBManMainUnit;

procedure ShowRecompileFBIndexForm(AFBSQLEngine: TSQLEngineFireBird);
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(fbmFBRecompileIndexForm, TfbmFBRecompileIndexForm);
  fbmFBRecompileIndexForm.FBSQLEngine:=AFBSQLEngine;
end;

{$R *.lfm}

{ TfbmFBRecompileIndexForm }

procedure TfbmFBRecompileIndexForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  fbmFBRecompileIndexForm:=nil;
end;

procedure TfbmFBRecompileIndexForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmFBRecompileIndexForm.actExecuteExecute(Sender: TObject);
begin
  if QuestionBox(sFireBiredRecompileIndexStatQ) then
end;

procedure TfbmFBRecompileIndexForm.SetFBSQLEngine(const AValue: TSQLEngineFireBird);
begin
  if FFBSQLEngine=AValue then Exit;
  FFBSQLEngine:=AValue;
end;

procedure TfbmFBRecompileIndexForm.Localize;
begin
  Caption:=sFireBiredRecompileIndexStat;
  actExecute.Caption:=sExecute;
end;

end.

