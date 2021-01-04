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

unit pgTaskTasksUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxtooledit, RxTimeEdit, rxtoolbar, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, CheckLst, Menus,
  ActnList, SQLEngineAbstractUnit, PostgreSQLEngineUnit, pg_tasks,
  fdmAbstractEditorUnit, fbmSqlParserUnit;

type

  { TpgTaskShedulePage }

  TpgTaskShedulePage = class(TEditorPage)
    Label8: TLabel;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    taskRemove: TAction;
    taskAdd: TAction;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    minEvery5: TAction;
    minEvery30: TAction;
    minEvery10: TAction;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    minUnselectAll: TAction;
    minSelectAll: TAction;
    hrSelectAll: TAction;
    hrUnselectAll: TAction;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mnUnselectAll: TAction;
    mnSelectAll: TAction;
    domSelectAll: TAction;
    domUnSelectAll: TAction;
    dowSelectAll: TAction;
    dowUnSelectAll: TAction;
    ActionList1: TActionList;
    CheckBox1: TCheckBox;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    CheckListBox3: TCheckListBox;
    CheckListBox4: TCheckListBox;
    CheckListBox5: TCheckListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    HeaderControl1: THeaderControl;
    HeaderControl2: THeaderControl;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    PopupMenu5: TPopupMenu;
    PopupMenu6: TPopupMenu;
    RxDateEdit1: TRxDateEdit;
    RxDateEdit2: TRxDateEdit;
    RxTimeEdit1: TRxTimeEdit;
    RxTimeEdit2: TRxTimeEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter5: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ToolPanel1: TToolPanel;
    ToolPanel2: TToolPanel;
    ToolPanel3: TToolPanel;
    ToolPanel4: TToolPanel;
    ToolPanel5: TToolPanel;
    procedure CheckListBox1Click(Sender: TObject);
    procedure dowSelectAllExecute(Sender: TObject);
    procedure HeaderControl1SectionResize(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure HeaderControl2SectionResize(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure ListBox1Click(Sender: TObject);
    procedure minEvery5Execute(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure Panel4Resize(Sender: TObject);
    procedure taskAddExecute(Sender: TObject);
    procedure taskRemoveExecute(Sender: TObject);
  private
    FDelList:TFPList;
    procedure ClearDelList;
    procedure LoadTaskData;
    procedure RefreshTaskData;
    procedure ClearData;
    procedure FillLists;
    procedure AddShedule;
    procedure DelShedule;
    function CurrentItem:TPGTaskShedule;
    procedure UpdateTaskEditor;
  public
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    destructor Destroy; override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit;

{$R *.lfm}

{ TpgTaskShedulePage }

procedure TpgTaskShedulePage.ListBox1Click(Sender: TObject);
var
  i: Integer;
  FCurShedule: TPGTaskShedule;
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex<ListBox1.Items.Count) then
  begin
    LockCntls;
    FCurShedule:=CurrentItem;
    if Assigned(FCurShedule) then
    begin
      Edit1.Text:=FCurShedule.Name;
      Edit2.Text:=IntToStr(FCurShedule.ID);
      Memo1.Text:=FCurShedule.Description;
      CheckBox1.Checked:=FCurShedule.Enabled;
      RxDateEdit1.Date:=FCurShedule.DateStart;
      RxDateEdit2.Date:=FCurShedule.DateStop;
      RxTimeEdit1.Time:=FCurShedule.DateStart;
      RxTimeEdit2.Time:=FCurShedule.DateStop;


      for i:=1 to 7 do
        CheckListBox1.Checked[i-1]:=FCurShedule.DayWeek[i];

      for i:=1 to 32 do
        CheckListBox2.Checked[i-1]:=FCurShedule.DayMonth[i];

      for i:=1 to 12 do
        CheckListBox3.Checked[i-1]:=FCurShedule.Month[i];

      for i:=0 to 23 do
        CheckListBox4.Checked[i]:=FCurShedule.Hours[i];

      for i:=0 to 59 do
        CheckListBox5.Checked[i]:=FCurShedule.Minutes[i];

    end;
    UnLockCntls;
  end;
end;

procedure TpgTaskShedulePage.minEvery5Execute(Sender: TObject);
var
  C: PtrInt;
  i: Integer;
begin
  LockCntls;
  C:=(Sender as TComponent).Tag;
  for i:=0 to CheckListBox5.Items.Count-1 do
    CheckListBox5.Checked[i]:=i mod c = 0;
  UnLockCntls;
  CheckListBox1Click(nil);
end;

procedure TpgTaskShedulePage.HeaderControl1SectionResize(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  case Section.OriginalIndex of
    0:Panel1.Width:=Section.Width;
    2:Panel3.Width:=Section.Width;
  end;
end;

procedure TpgTaskShedulePage.HeaderControl2SectionResize(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  case Section.OriginalIndex of
    0:Panel4.Width:=Section.Width;
  end;
end;

procedure TpgTaskShedulePage.CheckListBox1Click(Sender: TObject);
var
  U: TPGTaskShedule;
  i: Integer;
begin
  U:=CurrentItem;
  if Assigned(U) and (LockCount = 0) then
  begin
    U.Name:=Edit1.Text;
    U.Enabled:=CheckBox1.Checked;
    U.DateStart:=RxDateEdit1.Date + RxTimeEdit1.Time;
    U.DateStop:=RxDateEdit2.Date + RxTimeEdit2.Time;
    U.Description:=Memo1.Lines.Text;

    for i:=0 to CheckListBox1.Items.Count-1 do
      U.DayWeek[i+1]:=CheckListBox1.Checked[i];

    for i:=0 to CheckListBox2.Items.Count-1 do
      U.DayMonth[i+1]:=CheckListBox2.Checked[i];

    for i:=0 to CheckListBox3.Items.Count-1 do
      U.Month[i+1]:=CheckListBox3.Checked[i];

    for i:=0 to CheckListBox4.Items.Count-1 do
      U.Hours[i]:=CheckListBox4.Checked[i];

    for i:=0 to CheckListBox5.Items.Count-1 do
      U.Minutes[i]:=CheckListBox5.Checked[i];
  end;
end;

procedure TpgTaskShedulePage.dowSelectAllExecute(Sender: TObject);
var
  L: TCheckListBox;
  B: PtrInt;
  i: Integer;
begin
  LockCntls;
  B:=(Sender as TComponent).Tag;
  case B of
    1, -1:L:=CheckListBox1;
    2, -2:L:=CheckListBox2;
    3, -3:L:=CheckListBox3;
    4, -4:L:=CheckListBox4;
    5, -5:L:=CheckListBox5;
  end;

  for i:=0 to L.Items.Count-1 do
    L.Checked[i]:=B > 0;
  UnLockCntls;
  CheckListBox1Click(nil);
end;

procedure TpgTaskShedulePage.Panel1Resize(Sender: TObject);
begin
  HeaderControl1.Sections[0].Width:=Panel1.Width;
  HeaderControl1.Sections[1].Width:=Panel2.Width;
  HeaderControl1.Sections[2].Width:=Panel3.Width;
end;

procedure TpgTaskShedulePage.Panel4Resize(Sender: TObject);
begin
  HeaderControl2.Sections[0].Width:=Panel4.Width;
  HeaderControl2.Sections[1].Width:=Panel5.Width;
end;

procedure TpgTaskShedulePage.taskAddExecute(Sender: TObject);
begin
  AddShedule;
end;

procedure TpgTaskShedulePage.taskRemoveExecute(Sender: TObject);
begin
  DelShedule;
end;

procedure TpgTaskShedulePage.ClearDelList;
var
  i: Integer;
begin
  for i:=0 to FDelList.Count-1 do
    TPGTaskShedule(FDelList[i]).Free;
  FDelList.Clear;
end;

procedure TpgTaskShedulePage.LoadTaskData;
var
  U, U1:TPGTaskShedule;
begin
  ClearData;
  ClearDelList;
  for U1 in TPGTask(DBObject).Shedule do
  begin
    U:=TPGTaskShedule.Create;
    U.Assign(U1);

    ListBox1.Items.AddObject(U.Name, U);
  end;

  if ListBox1.Items.Count>0 then
  begin
    ListBox1.ItemIndex:=0;
    ListBox1Click(nil);
  end;
  UpdateTaskEditor;
end;

procedure TpgTaskShedulePage.RefreshTaskData;
begin
  DBObject.RefreshObject;
  LoadTaskData;
end;

procedure TpgTaskShedulePage.ClearData;
var
  i: Integer;
  U:TPGTaskShedule;
begin
  for i:=0 to ListBox1.Items.Count-1 do
  begin
    U:=TPGTaskShedule(ListBox1.Items.Objects[i]);
    ListBox1.Items.Objects[i]:=nil;
    if Assigned(U) then
      U.Free;
  end;
  ListBox1.Items.Clear;
end;

procedure TpgTaskShedulePage.FillLists;
var
  i: Integer;
begin
  CheckListBox1.Items.Clear;
  for i:=1 to 7 do
    CheckListBox1.Items.Add(DefaultFormatSettings.LongDayNames[i]);

  CheckListBox2.Items.Clear;
  for i:=1 to 31 do
    CheckListBox2.Items.Add(IntToStr(i));
  CheckListBox2.Items.Add('Last day');

  CheckListBox3.Items.Clear;
  for i:=1 to 12 do
    CheckListBox3.Items.Add(DefaultFormatSettings.LongMonthNames[i]);

  CheckListBox4.Items.Clear;
  for i:=0 to 23 do
    CheckListBox4.Items.Add(IntToStr(i));

  CheckListBox5.Items.Clear;
  for i:=0 to 59 do
    CheckListBox5.Items.Add(IntToStr(i));
end;

procedure TpgTaskShedulePage.AddShedule;
var
  U: TPGTaskShedule;
begin
  U:=TPGTaskShedule.Create;
  U.Name:=sShedule + ' '+IntToStr(ListBox1.Items.Count + 1);
  ListBox1.Items.AddObject(U.Name, U);
  ListBox1.ItemIndex:=ListBox1.Items.Count-1;
  ListBox1Click(nil);
  UpdateTaskEditor;
  PageControl1.ActivePageIndex:=0;
end;

procedure TpgTaskShedulePage.DelShedule;
var
  U: TPGTaskShedule;
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex < ListBox1.Items.Count)then
  begin
    U:=CurrentItem;
    if (DBObject.State = sdboCreate) or (U.ID < 0) then
      U.Free
    else
      FDelList.Add(U);
    ListBox1.Items.Delete(ListBox1.ItemIndex);

    if ListBox1.Items.Count>0 then
    begin
      ListBox1.ItemIndex:=0;
      ListBox1Click(nil);
    end;
  end;
  UpdateTaskEditor;
end;

function TpgTaskShedulePage.CurrentItem: TPGTaskShedule;
begin
  Result:=nil;
  if (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex < ListBox1.Items.Count) then
    Result:=TPGTaskShedule(ListBox1.Items.Objects[ListBox1.ItemIndex]);
end;

procedure TpgTaskShedulePage.UpdateTaskEditor;
begin
  PageControl1.Visible:=ListBox1.Items.Count > 0;
  Label8.Visible:=ListBox1.Items.Count = 0;
  taskRemove.Enabled:=ListBox1.Items.Count>0;
end;

function TpgTaskShedulePage.PageName: string;
begin
  Result:=sShedule;
end;

function TpgTaskShedulePage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaAdd:AddShedule;
    epaDelete:DelShedule;
    epaRefresh:RefreshTaskData;
  end;
end;

function TpgTaskShedulePage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaCompile, epaAdd, epaDelete ];
end;

procedure TpgTaskShedulePage.Localize;
begin
  inherited Localize;
  TabSheet1.Caption:=sProperty;
  TabSheet2.Caption:=sDays;
  TabSheet3.Caption:=sTimes;
  TabSheet4.Caption:=sExcep;
  HeaderControl1.Sections[0].Text:=sDayOfWeek;
  HeaderControl1.Sections[1].Text:=sDayOfMonth;
  HeaderControl1.Sections[2].Text:=sMonth;

  HeaderControl2.Sections[0].Text:=sHours;
  HeaderControl2.Sections[1].Text:=sMinutes;

  Label1.Caption:=sCaption;
  CheckBox1.Caption:=sEnabled;
  Label3.Caption:=sDateStart;
  Label5.Caption:=sDateFinish;
  Label4.Caption:=sTime;
  Label7.Caption:=sDescription;

  dowSelectAll.Caption:=sSelectAll;
  dowUnSelectAll.Caption:=sUnselectAll;
  domSelectAll.Caption:=sSelectAll;
  domUnSelectAll.Caption:=sUnselectAll;
  mnSelectAll.Caption:=sSelectAll;
  mnUnSelectAll.Caption:=sUnselectAll;
  hrSelectAll.Caption:=sSelectAll;
  hrUnSelectAll.Caption:=sUnselectAll;
  minSelectAll.Caption:=sSelectAll;
  minUnSelectAll.Caption:=sUnselectAll;

  minEvery5.Caption:=sEvery5;
  minEvery10.Caption:=sEvery10;
  minEvery30.Caption:=sEvery30;

  taskAdd.Caption:=sAdd;
  taskRemove.Caption:=sRemove;

  Label8.Caption:=sPressADDtoAddNewShedule;
end;

constructor TpgTaskShedulePage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  FDelList:=TFPList.Create;
  PageControl1.ActivePageIndex:=0;
  FillLists;
  Panel1Resize(nil);
  Panel4Resize(nil);

  LoadTaskData;
end;

destructor TpgTaskShedulePage.Destroy;
begin
  ClearDelList;
  FDelList.Free;
  ClearData;
  inherited Destroy;
end;

function TpgTaskShedulePage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  FCmd: TPGSQLTaskCreate;
  U, U1: TPGTaskShedule;
  I: Integer;
  FCmd1: TPGSQLTaskAlter;
  Op: TPGAlterTaskOperator;
begin
  Result:=true;
  if ASQLObject is TPGSQLTaskCreate then
  begin
    FCmd:=TPGSQLTaskCreate(ASQLObject);
    for I:=0 to ListBox1.Items.Count -1 do
    begin
      U:=FCmd.TaskShedule.Add;
      U.Assign(TPGTaskShedule(ListBox1.Items.Objects[i]));
    end;
  end
  else
  if ASQLObject is TPGSQLTaskAlter then
  begin
    FCmd1:=TPGSQLTaskAlter(ASQLObject);
    FCmd1.TaskID:=TPGTask(DBObject).TaskID;
    for i:=0 to FDelList.Count-1 do
    begin
      Op:=FCmd1.AddOperator(pgtaDropShedule);
      Op.ID:=TPGTaskShedule(FDelList[i]).ID;
    end;

    for i:=0 to ListBox1.Items.Count-1 do
    begin
      U:=TPGTaskShedule(ListBox1.Items.Objects[i]);
      if U.ID < 0 then
      begin
        Op:=FCmd1.AddOperator(pgtaCreateShedule);
        Op.Shedule.Assign(U);
      end
      else
      begin
        U1:=TPGTask(DBObject).Shedule.Find(U.ID);
        if Assigned(U1) and (not U.IsEqual(U1)) then
        begin
          Op:=FCmd1.AddOperator(pgtaAlterShedule);
          Op.Shedule.Assign(U);
        end;
      end;
    end;
  end
  else
    Result:=false;
end;

end.

