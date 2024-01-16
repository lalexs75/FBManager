{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, sqlEngineTypes,
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
    procedure DoInitCurRootNode(var ACurTrgFucNode: TTreeNode; AShema: TPGSchema; AGroupObj:TDBRootObject);

    procedure DoLoadLostTriggerFunctions;
    procedure DoFKWithoutIndex;
    procedure DoLoadTablesWithoutPK;
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

uses SQLEngineCommonTypesUnit, IBManDataInspectorUnit, fbmStrConstUnit,
  sqlObjects;

{$R *.lfm}

{ TODO -oalexs : Необходимо реализовать анализ статистики и производительности по БД }
(*
1. Список таблиц без PK
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

begin
  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;

  case TabControl1.TabIndex of
    0:DoLoadLostTriggerFunctions;
    1:DoFKWithoutIndex;
    3:DoLoadTablesWithoutPK;
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

procedure TpgObjectAnalysisAndWarningsTools.DoInitCurRootNode(
  var ACurTrgFucNode: TTreeNode; AShema: TPGSchema; AGroupObj: TDBRootObject);
var
  N: TTreeNode;
begin
  N:=TreeView1.Items.Add(nil, AShema.Caption);
  N.ImageIndex:=DBObjectKindImages[AShema.DBObjectKind];
  N.SelectedIndex:=DBObjectKindImages[AShema.DBObjectKind];
  N.StateIndex:=DBObjectKindImages[AShema.DBObjectKind];

  ACurTrgFucNode:=TreeView1.Items.AddChild(N, AGroupObj.Caption);
  ACurTrgFucNode.ImageIndex:=DBObjectKindImages[AGroupObj.DBObjectKind];
  ACurTrgFucNode.SelectedIndex:=DBObjectKindImages[AGroupObj.DBObjectKind];
  ACurTrgFucNode.StateIndex:=DBObjectKindImages[AGroupObj.DBObjectKind];
end;

procedure TpgObjectAnalysisAndWarningsTools.DoLoadLostTriggerFunctions;
var
  D: TSQLEnginePostgre;
  FCurTrgFucNode, NF: TTreeNode;
  Shm: TPGSchema;
  i, j: Integer;
  TF: TPGFunction;
begin
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
          DoInitCurRootNode(FCurTrgFucNode, Shm, Shm.TriggerProc);
        NF:=TreeView1.Items.AddChild(FCurTrgFucNode, TF.Caption);
        NF.ImageIndex:=DBObjectKindImages[TF.DBObjectKind];
        NF.SelectedIndex:=DBObjectKindImages[TF.DBObjectKind];
        NF.StateIndex:=DBObjectKindImages[TF.DBObjectKind];
        NF.Data:=TF;
      end;
    end;
    FCurTrgFucNode:=nil;
  end;
end;

procedure TpgObjectAnalysisAndWarningsTools.DoFKWithoutIndex;
var
  D: TSQLEnginePostgre;
  Shm: TPGSchema;
  i, j, CI, II: Integer;
  T: TPGTable;
  Cntr: TPrimaryKeyRecord;
  FCurTablesNode, NF, NF1: TTreeNode;
  Ind: TPGIndexItem;
  F: Boolean;
begin
  D:=TSQLEnginePostgre(FSQLEngine);
  FCurTablesNode:=nil;
  for i:=0 to D.SchemasRoot.CountGroups-1 do
  begin
    Shm:=TPGSchema(D.SchemasRoot.Groups[i]);

    for j:=0 to Shm.TablesRoot.CountObject-1 do
    begin
      T:=TPGTable(Shm.TablesRoot.Items[j]);
      NF:=nil;

      if T.ConstraintCount = 0 then T.RefreshConstraintForeignKey;
      for CI:=0 to T.ConstraintCount-1 do
      begin
        Cntr:=T.Constraint[CI];
        if Cntr.ConstraintType = ctForeignKey then
        begin
          if Cntr.FieldListArr.Count > 0 then
          begin
            F:=false;
            for II:=0 to T.IndexCount-1 do
            begin
              Ind:=TPGIndexItem(T.IndexItem[II]);
              if Ind.IndexField = Cntr.FieldList then
              begin
                F:=true;
                break;
              end;
            end;

            if not F then
            begin
              if not Assigned(FCurTablesNode) then
                DoInitCurRootNode(FCurTablesNode, Shm, Shm.TablesRoot);

              if not Assigned(NF) then
              begin
                NF:=TreeView1.Items.AddChild(FCurTablesNode, T.Caption);
                NF.ImageIndex:=DBObjectKindImages[T.DBObjectKind];
                NF.SelectedIndex:=DBObjectKindImages[T.DBObjectKind];
                NF.StateIndex:=DBObjectKindImages[T.DBObjectKind];
                NF.Data:=T;
              end;
              NF1:=TreeView1.Items.AddChild(NF, Cntr.Name);
              NF1.ImageIndex:=DBObjectKindImages[okForeignKey];
              NF1.SelectedIndex:=DBObjectKindImages[okForeignKey];
              NF1.StateIndex:=DBObjectKindImages[okForeignKey];
            end;
          end;
        end;
      end;
    end;
    FCurTablesNode:=nil;
  end;
end;

procedure TpgObjectAnalysisAndWarningsTools.DoLoadTablesWithoutPK;
begin

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

  actEditObject.Caption:=sEditObject;
  actShowObjectInTree.Caption:=sShowObjectInTree;
  TabControl1.Tabs[0]:=sLostTriggerFunctions;
  TabControl1.Tabs[1]:=sForeignKeyWithoutIndex;
  TabControl1.Tabs[2]:=sTablesWihoutPrimaryKey;
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
  Result:=sAnalysisAndWarnings;
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

