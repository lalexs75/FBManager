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

unit pgToolsFindDuplicateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, ComCtrls, ExtCtrls, Controls,
  SQLEngineAbstractUnit, fbmAbstractSQLEngineToolsUnit, LMessages, ActnList,
  Menus, fdbm_SynEditorUnit, fbmToolsUnit;

type

  { TpgToolsFindDuplicateFrame }

  TpgToolsFindDuplicateFrame = class(TAbstractSQLEngineTools)
    actEditObject: TAction;
    actShowObjectInTree: TAction;
    ActionList1: TActionList;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    procedure actEditObjectExecute(Sender: TObject);
    procedure actShowObjectInTreeExecute(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  protected
    EditorFrame:Tfdbm_SynEditorFrame;
    function DoFindDups(P:TDBRootObject):TFPList;
    procedure SetSQLEngine(AValue: TSQLEngineAbstract); override;
    procedure DoLoadData;
    procedure LMNotyfyDisconectEngine(var Message: TLMessage); message LM_NOTIFY_DISCONNECT_ENGINE;
    procedure LMNotyfyConectEngine(var Message: TLMessage); message LM_NOTIFY_CONNECT_ENGINE;
    procedure Localize;override;
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string; override;
    procedure RefreshPage; override;
  end;

implementation
uses SQLEngineCommonTypesUnit, IBManDataInspectorUnit, fbmStrConstUnit;

{$R *.lfm}

{ TpgToolsFindDuplicateFrame }

procedure TpgToolsFindDuplicateFrame.TreeView1Click(Sender: TObject);
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

procedure TpgToolsFindDuplicateFrame.actEditObjectExecute(Sender: TObject);
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    fbManDataInpectorForm.EditObject(TDBObject(TreeView1.Selected.Data));
end;

procedure TpgToolsFindDuplicateFrame.actShowObjectInTreeExecute(Sender: TObject
  );
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    fbManDataInpectorForm.SelectObject(TDBObject(TreeView1.Selected.Data));
end;

procedure TpgToolsFindDuplicateFrame.TreeView1DblClick(Sender: TObject);
begin
  actEditObject.Execute;
end;

function TpgToolsFindDuplicateFrame.DoFindDups(P: TDBRootObject): TFPList;
var
  i, j: Integer;
  P1, P2: TDBObject;
  N, M, MR: TTreeNode;
  P3: TDBRootObject;
  A: TFPList;
  St:TStringList;
begin
  St:=TStringList.Create;
  St.Sorted:=true;
  Result:=nil;
  MR:=nil;
  for i:=0 to P.CountObject-2 do
  begin
    P1:=P.Objects[i];
    if (P1.State <> sdboVirtualObject) and (ST.IndexOf(P1.Caption) < 0) then
    begin
      for j:=i+1 to P.CountObject-1 do
      begin
        P2:=P.Objects[j];
        if (P2.State <> sdboVirtualObject) and (P1.Caption = P2.Caption) then
        begin
          if not Assigned(Result) then
            Result:=TFPList.Create;
          if not Assigned(MR) then
          begin
            ST.Add(P1.Caption);
            MR:=TreeView1.Items.Add(nil, P1.Caption);
            Result.Add(MR);
            N:=TreeView1.Items.AddChild(MR, P1.CaptionFullPatch);
            N.ImageIndex:=DBObjectKindImages[P1.DBObjectKind];
            N.SelectedIndex:=DBObjectKindImages[P1.DBObjectKind];
            N.StateIndex:=DBObjectKindImages[P1.DBObjectKind];
            N.Data:=P1;
          end;

          N:=TreeView1.Items.AddChild(MR, P2.CaptionFullPatch);
          N.ImageIndex:=DBObjectKindImages[P2.DBObjectKind];
          N.SelectedIndex:=DBObjectKindImages[P2.DBObjectKind];
          N.StateIndex:=DBObjectKindImages[P2.DBObjectKind];
          N.Data:=P2;
        end;
      end;
    end;
    MR:=nil;
  end;
  St.Free;


  for i:=0 to P.CountGroups-1 do
  begin
    P3:=P.Groups[i];
    A:=DoFindDups(P3);
    if Assigned(A) then
    begin
      if not Assigned(Result) then
        Result:=TFPList.Create;
      N:=TreeView1.Items.Add(nil, P3.Caption);
      N.ImageIndex:=DBObjectKindImages[P3.DBObjectKind];
      N.StateIndex:=DBObjectKindImages[P3.DBObjectKind];
      N.SelectedIndex:=DBObjectKindImages[P3.DBObjectKind];
      for j:=0 to A.Count-1 do
      begin
        M:=TTreeNode(A[j]);
        M.MoveTo(N, naAddChild);
      end;
      N.Expanded:=true;
      Result.Add(N);
      FreeAndNil(A);
    end;
  end;
end;

procedure TpgToolsFindDuplicateFrame.SetSQLEngine(AValue: TSQLEngineAbstract);
begin
  inherited SetSQLEngine(AValue);
  EditorFrame.SQLEngine:=AValue;
end;

procedure TpgToolsFindDuplicateFrame.DoLoadData;
var
  P: TDBObject;
  N, M: TTreeNode;
  A:TFPList;
  i: Integer;
begin
  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;

  if Assigned(FSQLEngine) then
  begin
    for P in FSQLEngine.Groups do
    begin
      if P is TDBRootObject then
      begin
        A:=DoFindDups(TDBRootObject(P));
        if Assigned(A) then
        begin
          N:=TreeView1.Items.Add(nil, P.Caption);
          N.ImageIndex:=DBObjectKindImages[P.DBObjectKind];
          N.SelectedIndex:=DBObjectKindImages[P.DBObjectKind];
          N.StateIndex:=DBObjectKindImages[P.DBObjectKind];
          for i:=0 to A.Count-1 do
          begin
            M:=TTreeNode(A[i]);
            M.MoveTo(N, naAddChild);
          end;
          N.Expanded:=true;
          FreeAndNil(A);
        end;
      end;
    end;
  end;
  TreeView1.Items.EndUpdate;
end;

procedure TpgToolsFindDuplicateFrame.LMNotyfyDisconectEngine(
  var Message: TLMessage);
var
  D: Pointer;
begin
  D:=Pointer(IntPtr(Message.WParam));
  if D = Pointer(FSQLEngine) then
    RefreshPage;
end;

procedure TpgToolsFindDuplicateFrame.LMNotyfyConectEngine(var Message: TLMessage
  );
var
  D: Pointer;
begin
  D:=Pointer(IntPtr(Message.WParam));
  if D = Pointer(FSQLEngine) then
    RefreshPage;
end;

procedure TpgToolsFindDuplicateFrame.Localize;
begin
  inherited Localize;
  actEditObject.Caption:=sEditObject;
  actShowObjectInTree.Caption:=sShowObjectInTree;
end;

constructor TpgToolsFindDuplicateFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.Align:=alClient;
  EditorFrame.ReadOnly:=true;

  actEditObject.Enabled:=false;
  actShowObjectInTree.Enabled:=false;
end;

function TpgToolsFindDuplicateFrame.PageName: string;
begin
  Result:=sDuplicateObjects;
end;

procedure TpgToolsFindDuplicateFrame.RefreshPage;
begin
  Label1.Visible:=not FSQLEngine.Connected;
  TreeView1.Visible:=FSQLEngine.Connected;
  Splitter1.Visible:=FSQLEngine.Connected;
  EditorFrame.Visible:=FSQLEngine.Connected;

  if FSQLEngine.Connected then
    DoLoadData
  else
    TreeView1.Items.Clear;
end;

end.

