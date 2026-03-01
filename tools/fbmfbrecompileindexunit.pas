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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, CheckLst, ActnList, fdbm_SynEditorUnit,
  StdCtrls, ExtCtrls, ComCtrls, rxtoolbar, uib, FBSQLEngineUnit;

type

  { TfbmFBRecompileIndexForm }

  TfbmFBRecompileIndexForm = class(TForm)
    actExecute: TAction;
    actStop: TAction;
    ActionList1: TActionList;
    CheckListBox1: TCheckListBox;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    Splitter1: TSplitter;
    ToolPanel1: TToolPanel;
    procedure actExecuteExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FFBSQLEngine: TSQLEngineFireBird;
    FEditor:Tfdbm_SynEditorFrame;
    procedure SetFBSQLEngine(const AValue: TSQLEngineFireBird);
    procedure Localize;
    procedure FillIndexList;
  public
    property FBSQLEngine:TSQLEngineFireBird read FFBSQLEngine write SetFBSQLEngine;
  end;

var
  fbmFBRecompileIndexForm: TfbmFBRecompileIndexForm = nil;

procedure ShowRecompileFBIndexForm(AFBSQLEngine:TSQLEngineFireBird);
implementation

uses fbmStrConstUnit, fbmToolsUnit, IBManMainUnit, fbSqlTextUnit,
  SQLEngineCommonTypesUnit, ibmsqltextsunit;

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
  FEditor:=Tfdbm_SynEditorFrame.Create(Self);
  FEditor.Parent:=Panel1;
  ProgressBar1.Visible:=false;
  Localize;
end;

procedure TfbmFBRecompileIndexForm.actExecuteExecute(Sender: TObject);
var
  i: Integer;
begin
  if QuestionBox(sFireBiredRecompileIndexStatQ) then
  begin
    ProgressBar1.Visible:=true;
    ProgressBar1.Max:=CheckListBox1.Items.Count;
    ProgressBar1.Position:=0;
    for i:=0 to CheckListBox1.Items.Count-1 do
    begin
      CheckListBox1.ItemIndex:=i;
      ProgressBar1.Position:=i;
      if CheckListBox1.Checked[i] then
        FFBSQLEngine.ExecSQL(Format(sfbsqlRecompileIndexStat, [CheckListBox1.Items[i]]), [sepNotRefresh, sepSystemExec]);
      Application.ProcessMessages;
    end;
    ProgressBar1.Visible:=false;
  end;
end;

procedure TfbmFBRecompileIndexForm.actStopExecute(Sender: TObject);
begin
  //
end;

procedure TfbmFBRecompileIndexForm.CheckListBox1Click(Sender: TObject);
begin
  if CheckListBox1.ItemIndex>-1 then
    FEditor.EditorText:=Format(sfbsqlRecompileIndexStat, [CheckListBox1.Items[CheckListBox1.ItemIndex]]);
end;

procedure TfbmFBRecompileIndexForm.SetFBSQLEngine(const AValue: TSQLEngineFireBird);
begin
  if FFBSQLEngine=AValue then Exit;
  FFBSQLEngine:=AValue;
  FEditor.SQLEngine:=FFBSQLEngine;
  FillIndexList;
end;

procedure TfbmFBRecompileIndexForm.Localize;
begin
  Caption:=sFireBiredRecompileIndexStat;
  actExecute.Caption:=sExecute;
  actStop.Caption:=sStop;
end;

procedure TfbmFBRecompileIndexForm.FillIndexList;
var
  Q: TUIBQuery;
begin
  CheckListBox1.Items.BeginUpdate;
  CheckListBox1.Clear;
  Q:=FFBSQLEngine.GetUIBQuery(fbSqlModule.sFBIndexs.Strings.Text);
  try
    Q.Open;
    while not Q.Eof do
    begin
      if Q.Fields.ByNameAsInteger['SYSTEM_FLAG'] = 0 then
        CheckListBox1.Items.Add(Trim(Q.Fields.ByNameAsString['rdb$index_name']));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
  CheckListBox1.Items.EndUpdate;
  if CheckListBox1.Items.Count>0 then
  begin
    CheckListBox1.CheckAll(cbChecked);
    CheckListBox1.ItemIndex:=0;
  end;
end;

end.


