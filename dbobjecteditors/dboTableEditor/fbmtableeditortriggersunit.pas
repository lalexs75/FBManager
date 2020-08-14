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

unit fbmTableEditorTriggersUnit;

{$I fbmanager_define.inc}

interface

uses
  types, Classes, SysUtils, FileUtil, LResources, Forms, ComCtrls, Graphics,
  Controls, fdmAbstractEditorUnit, SQLEngineAbstractUnit, ibmanagertypesunit,
  ActnList, Menus, ExtCtrls, IniFiles, LMessages, fbmToolsUnit;

type

  { TfbmTableEditorTriggersFrame }

  TfbmTableEditorTriggersFrame = class(TEditorPage)
    HeaderControl1: THeaderControl;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    Splitter1: TSplitter;
    trgDeActivate: TAction;
    edtTriggerDelete: TAction;
    edtTriggerEdit: TAction;
    edtTriggerNew: TAction;
    trgActivate: TAction;
    allTriggerActivate: TAction;
    allTriggerDeactivate: TAction;
    allTriggersRecompile: TAction;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    TreeView1: TTreeView;
    procedure allTriggerActivateExecute(Sender: TObject);
    procedure edtTriggerDeleteExecute(Sender: TObject);
    procedure edtTriggerEditExecute(Sender: TObject);
    procedure edtTriggerNewExecute(Sender: TObject);
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
    procedure trgDeActivateExecute(Sender: TObject);
  private
    function CurrentTrigger:TDBTriggerObject;
    procedure RefreshTriggersTree;
//    procedure SetDBObject(AValue: TDBObject); override;
    procedure LMNotyfyDelObject(var Message: TLMessage); message LM_NOTIFY_OBJECT_DELETE;
  public
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    procedure Localize;override;
    procedure NotyfiDeleted(ADBObject:TDBObject); override;
  end;

implementation
uses fbmStrConstUnit, IBManDataInspectorUnit, Themes,
  fbmDBObjectEditorUnit, LCLIntf, SQLEngineCommonTypesUnit, LCLType, rxstrutils,
  strutils;

{$R *.lfm}

{ TfbmTableEditorTriggersFrame }

procedure TfbmTableEditorTriggersFrame.TreeView1Click(Sender: TObject);
var
  Trigger:TDBTriggerObject;
begin
  Trigger:=CurrentTrigger;
  if Assigned(Trigger) then
  begin
    trgActivate.Enabled:=not Trigger.Active;
    trgDeActivate.Enabled:=Trigger.Active;
  end
  else
  begin
    trgActivate.Enabled:=false;
    trgDeActivate.Enabled:=false;
  end;

  edtTriggerEdit.Enabled:=Assigned(Trigger);
  edtTriggerDelete.Enabled:=edtTriggerEdit.Enabled;
  TfbmDBObjectEditorForm(Owner).CtrlUpdateActions;
  ShowDetailObject(Trigger, Panel1);
end;

procedure TfbmTableEditorTriggersFrame.allTriggerActivateExecute(Sender: TObject
  );
begin
  TDBDataSetObject(DBObject).AllTriggersSetActiveState((Sender as TComponent).Tag = 1);
  TreeView1.Invalidate;
end;

procedure TfbmTableEditorTriggersFrame.edtTriggerDeleteExecute(Sender: TObject);
var
  Tr:TDBTriggerObject;
  i:integer;
  R:TDBObject;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    Tr:=TDBTriggerObject(TreeView1.Selected.Data);
    if Assigned(Tr) then
    begin
      TDBDataSetObject(DBObject).TriggerDelete(Tr);
      RefreshTriggersTree;
    end;
  end
end;

procedure TfbmTableEditorTriggersFrame.edtTriggerEditExecute(Sender: TObject);
begin
  TreeView1DblClick(nil);
end;

procedure TfbmTableEditorTriggersFrame.edtTriggerNewExecute(Sender: TObject);
var
  Tr:TDBTriggerObject;
  T:TTriggerTypes;
  i:integer;
  R:TDBObject;
begin
  T:=[];
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    Tr:=TDBTriggerObject(TreeView1.Selected.Data);
    T:=Tr.TriggerType;
  end
  else
  begin
    if Assigned(TreeView1.Selected) then
    begin
      for i:=0 to TDBDataSetObject(DBObject).TriggersCategoriesCount-1 do
      begin
        if TDBDataSetObject(DBObject).TriggersCategories[i] = TreeView1.Selected.Text then
        begin
          T:=TDBDataSetObject(DBObject).TriggersCategoriesType[i];
          break;
        end;
      end;
    end;
  end;
  R:=TDBDataSetObject(DBObject).TriggerNew(T);

  if Owner is TfbmDBObjectEditorForm then
    TfbmDBObjectEditorForm(Owner).SendCmd(epaRefresh)
  else
    abort;
end;

procedure TfbmTableEditorTriggersFrame.FrameResize(Sender: TObject);
begin
  HeaderControl1.Sections[2].Width:=TreeView1.Width - HeaderControl1.Sections[0].Width - HeaderControl1.Sections[1].Width;
end;

procedure TfbmTableEditorTriggersFrame.HeaderControl1SectionResize(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  TreeView1.Invalidate;
end;

procedure TfbmTableEditorTriggersFrame.HeaderControl1SectionTrack(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection; AWidth: Integer;
  State: TSectionTrackState);
begin
  TreeView1.Invalidate;
end;

procedure TfbmTableEditorTriggersFrame.TreeView1AdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);

var
  Trigger: TDBTriggerObject;
  S:string;
  R, PaintRect:TRect;
  Details: TThemedElementDetails;
  CSize: TSize;
  TH, Y: Integer;
begin
  if not Assigned(DBObject) then exit;
  if not DBObject.OwnerDB.Connected then exit;

  if Stage = cdPostPaint then
  begin
    if Assigned(Node) and Assigned(Node.Data) then
    begin
      Trigger:=TDBTriggerObject(Node.Data);
      R:=Node.DisplayRect(False);
      R.Left:=R.Left + HeaderControl1.Sections[0].Width;

      if (cdsSelected in State) then
        TreeView1.Canvas.Brush.Color:=TreeView1.SelectionColor
      else
        TreeView1.Canvas.Brush.Color:=TreeView1.BackgroundColor;
      TreeView1.Canvas.FillRect(R);

      //Draw trigger active checkbox
      if Trigger.Active then
        Details := ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal)
      else
        Details := ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal);
      CSize := ThemeServices.GetDetailSize(Details);

      PaintRect := Bounds(R.Left + ((HeaderControl1.Sections[1].Width - CSize.cx) div 2) , (R.Top + R.Bottom - CSize.cy) div 2, CSize.cx, CSize.cy);

      ThemeServices.DrawElement(TreeView1.Canvas.Handle, Details, PaintRect, nil);

      R.Left:=R.Left + HeaderControl1.Sections[1].Width;
      S:=GetFistString(Trigger.Description);
      if S<>'' then
      begin
        TH:=TreeView1.Canvas.TextHeight('Wg');
        Y:=R.Top + (R.Height div 2) - TH div 2;
        TreeView1.Font.Color:=clDefault;
        TreeView1.Font.Bold:=false;
        TreeView1.Canvas.TextRect(R, R.Left, Y, S);
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
      Trigger:=TDBTriggerObject(Node.Data);
      if Assigned(Trigger) then
      begin
        if Trigger.Active then
          TreeView1.Font.Color:=clDefault
        else
          TreeView1.Font.Color:=clSilver;
      end
      else
        TreeView1.Font.Bold:=true;
    end;
  end;
end;

procedure TfbmTableEditorTriggersFrame.TreeView1DblClick(Sender: TObject);
var
  Trigger:TDBTriggerObject;
begin
  Trigger:=CurrentTrigger;
  if Assigned(Trigger) then
    fbManDataInpectorForm.EditObject(Trigger);
end;

procedure TfbmTableEditorTriggersFrame.trgDeActivateExecute(Sender: TObject);
var
  Trigger:TDBTriggerObject;
begin
  Trigger:=CurrentTrigger;
  if Assigned(Trigger) then
  begin
    Trigger.Active:=(Sender as TComponent).Tag = 0;
    TreeView1.Invalidate;
    TreeView1Click(nil);
  end;
end;

function TfbmTableEditorTriggersFrame.CurrentTrigger: TDBTriggerObject;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    Result:=TDBTriggerObject(TreeView1.Selected.Data)
  else
    Result:=nil;
end;

procedure TfbmTableEditorTriggersFrame.RefreshTriggersTree;
var
  i, j:Integer;
  Node, Node1:TTreeNode;
  Trigger:TDBTriggerObject;
begin
  TDBDataSetObject(DBObject).TriggersListRefresh;
  TreeView1.Items.Clear;
  TreeView1.Items.BeginUpdate;
  for i:=0 to TDBDataSetObject(DBObject).TriggersCategoriesCount - 1 do
  begin
    Node:=TreeView1.Items.Add(nil, TDBDataSetObject(DBObject).TriggersCategories[i]);
    Node.ImageIndex:=3;
    Node.StateIndex:=3;
    Node.SelectedIndex:=3;
    for j:=0 to TDBDataSetObject(DBObject).TriggersCount[i] - 1 do
    begin
      Trigger:=TDBDataSetObject(DBObject).Trigger[i, j];
      if Trigger.State = sdboEdit then
      begin
        Node1:=TreeView1.Items.AddChild(Node, Trigger.Caption);
        Node1.ImageIndex:=3;
        Node1.StateIndex:=3;
        Node1.SelectedIndex:=3;
        Node1.Data:=Trigger;
      end;
    end;
    Node.Expand(true);
  end;
  TreeView1.Items.EndUpdate;
  TreeView1Click(nil);
end;

procedure TfbmTableEditorTriggersFrame.LMNotyfyDelObject(var Message: TLMessage
  );
begin
  inherited;
end;

(*
procedure TfbmTableEditorTriggersFrame.SetDBObject(AValue: TDBObject);
begin
  inherited SetDBObject(AValue);
  if AValue = nil then
    TreeView1.Items.Clear;
end;

procedure TfbmTableEditorTriggersFrame.LMNotyfyDelObject(var Message: TLMessage
  );
var
  N: TTreeNode;
  D: Pointer;
  i: Integer;
begin
  inherited;
  D:=Pointer(IntPtr(Message.WParam));
  if not Assigned(D) then Exit;
  for i:=TreeView1.Items.Count-1 to 0 do
  begin
    N:=TreeView1.Items[i];
    if Assigned(N.Data) and (N.Data = D) then
      TreeView1.Items.Delete(N);
  end;
end;
*)

function TfbmTableEditorTriggersFrame.PageName: string;
begin
  Result:=sTriggers;
end;

procedure TfbmTableEditorTriggersFrame.Activate;
begin
  RefreshTriggersTree;
end;

function TfbmTableEditorTriggersFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaAdd:edtTriggerNew.Execute;
    epaEdit:edtTriggerEdit.Execute;
    epaDelete:edtTriggerDelete.Execute;
    epaRefresh:RefreshTriggersTree;
//    epaPrint:fldPrint.Execute;
  end;
end;

function TfbmTableEditorTriggersFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaAdd, epaRefresh, epaPrint];

  if (not Result) and Assigned(CurrentTrigger) then
    Result:=PageAction in [epaDelete, epaEdit];
end;

constructor TfbmTableEditorTriggersFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
end;

procedure TfbmTableEditorTriggersFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited SaveState(SectionName, Ini);
  Ini.WriteInteger(SectionName+'.TriggerPreview', 'Height', Panel1.Height);
end;

procedure TfbmTableEditorTriggersFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited RestoreState(SectionName, Ini);
  Panel1.Height:=Ini.ReadInteger(SectionName+'.TriggerPreview', 'Height', Panel1.Height);
end;

procedure TfbmTableEditorTriggersFrame.Localize;
begin
  inherited Localize;

  trgDeActivate.Caption:=sDeactivateTrigger;
  edtTriggerDelete.Caption:=sDeleteTrigger;
  edtTriggerEdit.Caption:=sModifiTrigger;
  edtTriggerNew.Caption:=sNewTrigger;
  trgActivate.Caption:=sActivateTrigger;
  allTriggerActivate.Caption:=sActivateAllTriggers;
  allTriggerDeactivate.Caption:=sDeactivateAllTrigger;
  allTriggersRecompile.Caption:=sRecompileAllTriggers;

  HeaderControl1.Sections[0].Text:=sTriggers;
  HeaderControl1.Sections[1].Text:=sActive;
  HeaderControl1.Sections[2].Text:=sDescription;
end;

procedure TfbmTableEditorTriggersFrame.NotyfiDeleted(ADBObject: TDBObject);
var
  i: Integer;
  N: TTreeNode;
begin
  inherited NotyfiDeleted(ADBObject);
  if not Assigned(ADBObject) then Exit;
  for i:=TreeView1.Items.Count-1 downto 0 do
  begin
    N:=TreeView1.Items[i];
    if Assigned(N.Data) and (TDBObject(N.Data) = ADBObject) then
      TreeView1.Items.Delete(N);
  end;
end;


end.

