{ Free DB Manager

  Copyright (C) 2005-2019 Lagunov Aleksey  alexs75 at yandex.ru

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


unit fbmPGRuleListUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, Menus, ActnList, fdmAbstractEditorUnit, PostgreSQLEngineUnit,
  SQLEngineAbstractUnit, ibmanagertypesunit;

type

  { TPGRuleListPage }

  TPGRuleListPage = class(TEditorPage)
    ActionList1: TActionList;
    edtRuleDelete: TAction;
    edtRuleEdit: TAction;
    edtRuleNew: TAction;
    HeaderControl1: THeaderControl;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    procedure edtRuleDeleteExecute(Sender: TObject);
    procedure edtRuleNewExecute(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure HeaderControl1SectionResize(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure HeaderControl1SectionTrack(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection; AWidth: Integer; State: TSectionTrackState);
    procedure TreeView1AdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    F:array [1..4] of TTreeNode;
    FRuleList:TPGRuleList;
    procedure RefreshRulesTree;
    function CurrentRule:TPGRule;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
  end;

implementation

uses fbmStrConstUnit, fbmToolsUnit, IBManDataInspectorUnit,
  fbmDBObjectEditorUnit, Themes, LCLIntf, LCLType, types, pgTypes;

{$R *.lfm}

{ TPGRuleListPage }

procedure TPGRuleListPage.TreeView1Click(Sender: TObject);
var
  FRule:TPGRule;
begin
  FRule:=CurrentRule;
  edtRuleEdit.Enabled:=Assigned(FRule);
  edtRuleDelete.Enabled:=edtRuleEdit.Enabled;
  TfbmDBObjectEditorForm(Owner).CtrlUpdateActions;
  ShowDetailObject(FRule, Panel1);
end;

procedure TPGRuleListPage.edtRuleNewExecute(Sender: TObject);
var
  RuleAction:TPGRuleAction;
begin
  RuleAction:=raUpdate;
  if Assigned(CurrentRule) then
    RuleAction:=CurrentRule.RuleAction
  else
  begin
    if TreeView1.Selected = F[1] then
      RuleAction:=raSelect
    else
    if TreeView1.Selected = F[2] then
      RuleAction:=raUpdate
    else
    if TreeView1.Selected = F[3] then
      RuleAction:=raInsert
    else
    if TreeView1.Selected = F[4] then
      RuleAction:=raDelete;
  end;
  FRuleList.RuleNew(RuleAction);

  if Owner is TfbmDBObjectEditorForm then
    TfbmDBObjectEditorForm(Owner).SendCmd(epaRefresh)
  else
    abort;
end;

procedure TPGRuleListPage.FrameResize(Sender: TObject);
begin
  HeaderControl1.Sections[1].Width:=TreeView1.Width - HeaderControl1.Sections[0].Width {- HeaderControl1.Sections[1].Width};
end;

procedure TPGRuleListPage.HeaderControl1SectionResize(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  TreeView1.Invalidate;
end;

procedure TPGRuleListPage.HeaderControl1SectionTrack(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection; AWidth: Integer;
  State: TSectionTrackState);
begin
  TreeView1.Invalidate;
end;

procedure TPGRuleListPage.TreeView1AdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
var
  FRule: TPGRule;
  S:string;
  R:TRect;
begin
  if Stage = cdPostPaint then
  begin
    if Assigned(Node) and Assigned(Node.Data) then
    begin
      FRule:=TPGRule(Node.Data);
      R:=Node.DisplayRect(False);
      R.Left:=R.Left + HeaderControl1.Sections[0].Width;
{
      //Draw trigger active checkbox
      if Trigger.Active then
        Details := ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal)
      else
        Details := ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal);
      CSize := ThemeServices.GetDetailSize(Details);

      PaintRect := Bounds(R.Left + ((HeaderControl1.Sections[1].Width - CSize.cx) div 2) , Trunc((R.Top + R.Bottom - CSize.cy)/2), CSize.cx, CSize.cy);
      ThemeServices.DrawElement(TreeView1.Canvas.Handle, Details, PaintRect, nil);
      R.Left:=R.Left + HeaderControl1.Sections[1].Width;
      }
      S:=GetFistString(FRule.Description);
      if S<>'' then
      begin
        TreeView1.Font.Color:=clDefault;
        TreeView1.Font.Bold:=false;
        DrawText(TreeView1.Canvas.Handle, PChar(S), -1, R, DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
      end
    end
  end
  else
  begin
    DefaultDraw:=true;
    TreeView1.Font.Color:=clDefault;
    TreeView1.Font.Bold:=false;
    if Assigned(Node) then
    begin
      FRule:=TPGRule(Node.Data);
      if Assigned(FRule) then
      begin
{        if Trigger.Active then}
          TreeView1.Font.Color:=clDefault;
{        else
          TreeView1.Font.Color:=clSilver;}
      end
      else
        TreeView1.Font.Bold:=true;
    end;
  end;
end;

procedure TPGRuleListPage.edtRuleDeleteExecute(Sender: TObject);
var
  FRule:TPGRule;
begin
  FRule:=CurrentRule;
  if Assigned(FRule) then
    FRuleList.RuleDrop(FRule);
end;

procedure TPGRuleListPage.TreeView1DblClick(Sender: TObject);
var
  FRule:TPGRule;
begin
  FRule:=CurrentRule;
  if Assigned(FRule) then
    fbManDataInpectorForm.EditObject(FRule);
end;

procedure TPGRuleListPage.RefreshRulesTree;

procedure DoCreateNode(var AF:TTreeNode;const AName:string);
begin
  AF:=TreeView1.Items.Add(nil, AName);
  AF.ImageIndex:=60;
  AF.StateIndex:=60;
  AF.SelectedIndex:=60;
end;

var
  i:Integer;
  Node1:TTreeNode;
  Rule:TPGRule;
begin
  //Event type that the rule is for: 1 = SELECT, 2 = UPDATE, 3 = INSERT, 4 = DELETE
  FRuleList.RuleListRefresh;
  TreeView1.Items.Clear;
  TreeView1.Items.BeginUpdate;

  DoCreateNode(F[1], 'SELECT');
  DoCreateNode(F[3], 'INSERT');
  DoCreateNode(F[2], 'UPDATE');
  DoCreateNode(F[4], 'DELETE');

  for i:=0 to FRuleList.Count - 1 do
  begin
    Rule:=TPGRule(FRuleList[i]);
    Node1:=TreeView1.Items.AddChild(F[Ord(Rule.RuleAction)+1], Rule.Caption);
    Node1.Data:=Rule;
    Node1.ImageIndex:=59;
    Node1.StateIndex:=59;
    Node1.SelectedIndex:=59;
  end;
  TreeView1.Items.EndUpdate;
  TreeView1Click(nil);
  F[1].Expanded:=true;
  F[2].Expanded:=true;
  F[3].Expanded:=true;
  F[4].Expanded:=true;
end;

function TPGRuleListPage.CurrentRule: TPGRule;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    Result:=TPGRule(TreeView1.Selected.Data)
  else
    Result:=nil;
end;

function TPGRuleListPage.PageName: string;
begin
  Result:=sRules;
end;

constructor TPGRuleListPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  if Assigned(DBObject) then
  begin
    if DBObject is TPGTable then
      FRuleList:=TPGTable(DBObject).RuleList
    else
    if DBObject is TPGView then
      FRuleList:=TPGView(DBObject).RuleList
    ;

  end;
  RefreshRulesTree;
end;

function TPGRuleListPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

function TPGRuleListPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
{    epaAdd:fldNew.Execute;
    epaEdit:fldEdit.Execute;
    epaDelete:fldDelete.Execute;}
    epaRefresh:RefreshRulesTree;
{    epaPrint:fldPrint.Execute;
    epaCompile:Result:=Compile;}
  else
    Result:=false;
  end;
end;

procedure TPGRuleListPage.Localize;
begin
  inherited Localize;
  edtRuleNew.Caption:=sNewRule;
  edtRuleEdit.Caption:=sModifiRule;
  edtRuleDelete.Caption:=sDeleteRule;
end;

end.

