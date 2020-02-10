{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pgObjectAnalysisAndWarningsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, ActnList, Menus, PostgreSQLEngineUnit, SQLEngineAbstractUnit,
  fbmAbstractSQLEngineToolsUnit, fdbm_SynEditorUnit, fbmToolsUnit, LMessages;

type

  { TpgObjectAnalysisAndWarningsTools }

  TpgObjectAnalysisAndWarningsTools = class(TAbstractSQLEngineTools)
    actEditObject: TAction;
    actShowObjectInTree: TAction;
    ActionList1: TActionList;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    TabControl1: TTabControl;
    TreeView1: TTreeView;
    procedure actEditObjectExecute(Sender: TObject);
    procedure actShowObjectInTreeExecute(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    procedure InternalLoadData;
    function DoFindTrigger(TF:TPGFunction):boolean;
  protected
    procedure SetSQLEngine(AValue: TSQLEngineAbstract); override;
    procedure Localize;override;
    procedure LMNotyfyDisconectEngine(var Message: TLMessage); message LM_NOTIFY_DISCONNECT_ENGINE;
    procedure LMNotyfyConectEngine(var Message: TLMessage); message LM_NOTIFY_CONNECT_ENGINE;
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string; override;
    procedure RefreshPage; override;
  end;

implementation

uses SQLEngineCommonTypesUnit, IBManDataInspectorUnit;

{$R *.lfm}

{ TODO -oalexs : Необходимо реализовать анализ статистики и производительности по БД }
(*
1. Список таблиц без PK
2. Список FK в таблицах без индексов по соотвутсвующим полям
3. Список "потерянных тригерных процедур"
*)

{ TpgObjectAnalysisAndWarningsTools }

procedure TpgObjectAnalysisAndWarningsTools.TabControl1Change(Sender: TObject);
begin
  InternalLoadData;
end;

procedure TpgObjectAnalysisAndWarningsTools.actEditObjectExecute(Sender: TObject
  );
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    fbManDataInpectorForm.EditObject(TDBObject(TreeView1.Selected.Data));

end;

procedure TpgObjectAnalysisAndWarningsTools.actShowObjectInTreeExecute(
  Sender: TObject);
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    fbManDataInpectorForm.SelectObject(TDBObject(TreeView1.Selected.Data));
end;

procedure TpgObjectAnalysisAndWarningsTools.TreeView1Click(Sender: TObject);
var
  D: TDBObject;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    D:=TDBObject(TreeView1.Selected.Data)
  else
    D:=nil;

  if Assigned(D) then
    EditorFrame.EditorText:=D.DDLCreate
  else
    EditorFrame.EditorText:='';

  actEditObject.Enabled:=Assigned(D);
  actShowObjectInTree.Enabled:=Assigned(D);
end;

procedure TpgObjectAnalysisAndWarningsTools.TreeView1DblClick(Sender: TObject);
begin
  actEditObject.Execute;
end;

procedure TpgObjectAnalysisAndWarningsTools.InternalLoadData;
var
  D: TSQLEnginePostgre;
  i, j: Integer;
  Shm: TPGSchema;
  TF: TPGFunction;
  FCurTrgFucNode, NF: TTreeNode;

procedure InitCurTrgFucNode;
var
  N: TTreeNode;
begin
  N:=TreeView1.Items.Add(nil, Shm.Caption);
  N.ImageIndex:=DBObjectKindImages[Shm.DBObjectKind];
  N.SelectedIndex:=DBObjectKindImages[Shm.DBObjectKind];
  N.StateIndex:=DBObjectKindImages[Shm.DBObjectKind];

  FCurTrgFucNode:=TreeView1.Items.AddChild(N, Shm.TriggerProc.Caption);
  FCurTrgFucNode.ImageIndex:=DBObjectKindImages[Shm.TriggerProc.DBObjectKind];
  FCurTrgFucNode.SelectedIndex:=DBObjectKindImages[Shm.TriggerProc.DBObjectKind];
  FCurTrgFucNode.StateIndex:=DBObjectKindImages[Shm.TriggerProc.DBObjectKind];
end;

begin
  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;
  D:=TSQLEnginePostgre(FSQLEngine);
  FCurTrgFucNode:=nil;
  for i:=0 to D.SchemasRoot.CountGroups-1 do
  begin
    Shm:=TPGSchema(D.SchemasRoot.Groups[i]);

    for j:=0 to Shm.TriggerProc.CountObject-1 do
    begin
      TF:=TPGFunction(Shm.TriggerProc.Items[j]);
      if not DoFindTrigger(TF) then
      begin
        if not Assigned(FCurTrgFucNode) then
          InitCurTrgFucNode;
        NF:=TreeView1.Items.AddChild(FCurTrgFucNode, TF.Caption);
        NF.ImageIndex:=DBObjectKindImages[TF.DBObjectKind];
        NF.SelectedIndex:=DBObjectKindImages[TF.DBObjectKind];
        NF.StateIndex:=DBObjectKindImages[TF.DBObjectKind];
        NF.Data:=TF;
      end;
    end;
    FCurTrgFucNode:=nil;
  end;
  TreeView1.Items.EndUpdate;
end;

function TpgObjectAnalysisAndWarningsTools.DoFindTrigger(TF: TPGFunction
  ): boolean;
var
  D: TSQLEnginePostgre;
  Sch: TPGSchema;
  i, j: Integer;
  TR: TPGTrigger;
begin
  D:=TSQLEnginePostgre(FSQLEngine);
  Result:=false;
  for i := 0 to D.SchemasRoot.CountGroups-1 do
  begin
    Sch:=TPGSchema(D.SchemasRoot.Groups[i]);
    for j:=0 to Sch.Triggers.CountObject-1 do
    begin
      TR:=TPGTrigger(Sch.Triggers.Items[j]);
      if TR.TriggerFunctionOID = TF.FunctionOID then
        Exit(true);
    end;
  end;
end;

procedure TpgObjectAnalysisAndWarningsTools.SetSQLEngine(
  AValue: TSQLEngineAbstract);
begin
  inherited SetSQLEngine(AValue);
  EditorFrame.SQLEngine:=AValue;
end;

procedure TpgObjectAnalysisAndWarningsTools.Localize;
begin
  inherited Localize;
end;

procedure TpgObjectAnalysisAndWarningsTools.LMNotyfyDisconectEngine(
  var Message: TLMessage);
begin
  if Pointer(IntPtr(Message.WParam)) = Pointer(FSQLEngine) then
    RefreshPage;
end;

procedure TpgObjectAnalysisAndWarningsTools.LMNotyfyConectEngine(
  var Message: TLMessage);
begin
  if Pointer(IntPtr(Message.WParam)) = Pointer(FSQLEngine) then
    RefreshPage;
end;

constructor TpgObjectAnalysisAndWarningsTools.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=TabControl1;
  EditorFrame.Align:=alClient;
  EditorFrame.ReadOnly:=true;

  actEditObject.Enabled:=false;
  actShowObjectInTree.Enabled:=false;
end;

function TpgObjectAnalysisAndWarningsTools.PageName: string;
begin
  Result:='Analysis and Warnings';
end;

procedure TpgObjectAnalysisAndWarningsTools.RefreshPage;
begin
  Label1.Visible:=not FSQLEngine.Connected;
  TabControl1.Visible:=FSQLEngine.Connected;
  EditorFrame.Visible:=FSQLEngine.Connected;
  if TabControl1.Visible then
    InternalLoadData
  else
    TreeView1.Items.Clear;
end;

end.

