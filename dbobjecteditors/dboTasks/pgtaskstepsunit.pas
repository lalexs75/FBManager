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

unit pgTaskStepsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, EditBtn, ComCtrls, ActnList, Menus, PostgreSQLEngineUnit, pg_tasks,
  fbmSqlParserUnit, fdmAbstractEditorUnit, fdbm_SynEditorUnit,
  SQLEngineAbstractUnit;

type

  { TpgTaskStepsPage }

  TpgTaskStepsPage = class(TEditorPage)
    Label3: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    stepDelete: TAction;
    stepAdd: TAction;
    ActionList1: TActionList;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    edtStepName: TEdit;
    EditButton1: TEditButton;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure edtStepNameChange(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure stepAddExecute(Sender: TObject);
    procedure stepDeleteExecute(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    FDelList:TFPList;
    procedure ClearDelList;
    procedure LoadTaskData;
    procedure ClearData;
    procedure LoadDBList;
    function DeleteTaskStep:boolean;
    function AddNew:boolean;
    procedure UpdateStepEditor;
    function CurrentItem:TPGTaskStep;
  public
    function PageName:string;override;
    destructor Destroy; override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses ZDataset, pg_sql_lines_unit, pgSqlTextUnit, fbmStrConstUnit, fbmToolsUnit,
  pgTaskStepsBuildConnectionUnit;

{$R *.lfm}

{ TpgTaskStepsPage }

procedure TpgTaskStepsPage.ListBox1Click(Sender: TObject);
var
  U: TPGTaskStep;
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex<ListBox1.Items.Count) then
  begin
    U:=CurrentItem;
    LockCntls;
    edtStepName.Text:=U.Name;
    EditorFrame.EditorText:=U.Body;
    Memo1.Text:=U.Description;
    RadioButton1.Checked:=U.ConnectStr = '';
    RadioButton2.Checked:=U.ConnectStr <> '';
    ComboBox1.Text:=U.DBName;
    EditButton1.Text:=U.ConnectStr;
    CheckBox1.Checked:=U.Enabled;
    UnLockCntls;
  end;
end;

procedure TpgTaskStepsPage.EditButton1ButtonClick(Sender: TObject);
begin
  pgTaskStepsBuildConnectionForm:=TpgTaskStepsBuildConnectionForm.Create(Application);
  pgTaskStepsBuildConnectionForm.ConnectionString:=EditButton1.Text;
  if pgTaskStepsBuildConnectionForm.ShowModal = mrOk then
    EditButton1.Text:=pgTaskStepsBuildConnectionForm.ConnectionString;
  pgTaskStepsBuildConnectionForm.Free;
end;

procedure TpgTaskStepsPage.edtStepNameChange(Sender: TObject);
var
  U: TPGTaskStep;
begin
  U:=CurrentItem;
  if Assigned(U) and (LockCount = 0) then
  begin
    U.Name:=edtStepName.Text;
    U.Enabled:=CheckBox1.Checked;
    U.Body := EditorFrame.EditorText;
    U.Description := Memo1.Text;
    U.Enabled := CheckBox1.Checked;

    if RadioButton1.Checked then
    begin
      U.DBName := ComboBox1.Text;
      U.ConnectStr := '';
    end
    else
    begin
      U.ConnectStr := EditButton1.Text;
      U.DBName := '';
    end;
  end;
end;

procedure TpgTaskStepsPage.RadioButton1Change(Sender: TObject);
begin
  ComboBox1.Enabled:=RadioButton1.Checked;
  EditButton1.Enabled:=RadioButton2.Checked;
  edtStepNameChange(nil);
end;

procedure TpgTaskStepsPage.stepAddExecute(Sender: TObject);
begin
  AddNew;
end;

procedure TpgTaskStepsPage.stepDeleteExecute(Sender: TObject);
begin
  DeleteTaskStep;
end;

procedure TpgTaskStepsPage.ClearDelList;
var
  i: Integer;
begin
  for i:=0 to FDelList.Count-1 do
    TPGTaskStep(FDelList[i]).Free;
  FDelList.Clear;
end;

procedure TpgTaskStepsPage.LoadTaskData;
var
  U, U1:TPGTaskStep;
begin
  ClearData;
  ClearDelList;

  for U in TPGTask(DBObject).Steps do
  begin
    U1:=TPGTaskStep.Create(nil);
    U1.Assign(U);
    ListBox1.Items.AddObject(U1.Name, U1);
  end;

  if ListBox1.Items.Count>0 then
  begin
    ListBox1.ItemIndex:=0;
    ListBox1Click(nil);
  end;

  UpdateStepEditor;
end;

procedure TpgTaskStepsPage.ClearData;
var
  i: Integer;
  U:TPGTaskStep;
begin
  for i:=0 to ListBox1.Items.Count-1 do
  begin
    U:=TPGTaskStep(ListBox1.Items.Objects[i]);
    ListBox1.Items.Objects[i]:=nil;
    if Assigned(U) then
      U.Free;
  end;
  ListBox1.Items.Clear;
end;

procedure TpgTaskStepsPage.LoadDBList;
var
  Q:TZQuery;
begin
  ComboBox1.Items.Clear;
  Q:=TSQLEnginePostgre(DBObject.OwnerDB).GetSQLSysQuery(pgSqlTextModule.sqlTasks['pgDBList']);
  try
    Q.Open;
    while not Q.Eof do
    begin
      ComboBox1.Items.Add(Q.FieldByName('datname').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TpgTaskStepsPage.DeleteTaskStep: boolean;
var
  U: TPGTaskStep;
begin
  Result:=true;
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex < ListBox1.Items.Count)then
  begin
    U:=TPGTaskStep(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    if DBObject.State = sdboCreate then
      U.Free
    else
      FDelList.Add(U);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    if ListBox1.Items.Count>0 then
      ListBox1.ItemIndex:=0;
  end;
  UpdateStepEditor;
end;

function TpgTaskStepsPage.AddNew: boolean;
var
  U: TPGTaskStep;
begin
  Result:=true;
  U:=TPGTaskStep.Create(TPGTask(DBObject));
  ListBox1.Items.AddObject(sStep+' '+IntToStr(ListBox1.Items.Count+1), U);
  U.Name:=ListBox1.Items[ListBox1.Count-1];
  ListBox1.ItemIndex:=ListBox1.Count-1;
  ListBox1Click(nil);
  UpdateStepEditor;
end;

procedure TpgTaskStepsPage.UpdateStepEditor;
begin
  PageControl1.Visible:=ListBox1.Items.Count>0;
  Label3.Visible:=ListBox1.Items.Count = 0;
  stepDelete.Enabled:=ListBox1.Items.Count>0;
end;

function TpgTaskStepsPage.CurrentItem: TPGTaskStep;
begin
  Result:=nil;
  if (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex < ListBox1.Items.Count) then
    Result:=TPGTaskStep(ListBox1.Items.Objects[ListBox1.ItemIndex]);
end;

function TpgTaskStepsPage.PageName: string;
begin
  Result:=sSteps;
end;

destructor TpgTaskStepsPage.Destroy;
begin
  ClearDelList;
  FDelList.Free;
  ClearData;
  inherited Destroy;
end;

function TpgTaskStepsPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:LoadTaskData;
//    epaPrint,
//    epaCompile:Result:=SaveCurrent;
    epaAdd:Result:=AddNew;
    epaDelete:Result:=DeleteTaskStep;
  else
    Result:=false;
  end;
end;

function TpgTaskStepsPage.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaCompile, epaAdd, epaDelete];
end;

procedure TpgTaskStepsPage.Localize;
begin
  inherited Localize;
  TabSheet1.Caption:=sProperty;
  TabSheet2.Caption:=sSqlBody;
  Label1.Caption:=sStepName;
  CheckBox1.Caption:=sEnabled;
  RadioButton1.Caption:=sDatabaseOnCurrentServer;
  RadioButton2.Caption:=sConnectionString;
  Label1.Caption:=sDescription;
  stepAdd.Caption:=sAddStep;
  stepDelete.Caption:=sRemoveStep;
  Label3.Caption:=sClickADDForNewStep;
end;

constructor TpgTaskStepsPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  FDelList:=TFPList.Create;
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=TabSheet2;
  EditorFrame.TextEditor.OnChange:=@edtStepNameChange;
  LoadDBList;
  LoadTaskData;
end;

function TpgTaskStepsPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  FCmd: TPGSQLTaskCreate;
  U: TPGTaskStep;
  i: Integer;
  FCmd1: TPGSQLTaskAlter;
  Op: TPGAlterTaskOperator;
begin
  //Result:=(edtStepName.Caption<>'') and ((RadioButton1.Checked and (ComboBox1.Text<>'')) or (RadioButton2.Checked and (EditButton1.Text<>'')));

  Result:=true;
  if not Result then exit;
  if ASQLObject is TPGSQLTaskCreate then
  begin
    Result:=true;
    FCmd:=TPGSQLTaskCreate(ASQLObject);

    for i:=0 to ListBox1.Items.Count-1 do
    begin
      U:=FCmd.TaskSteps.Add;
      U.Assign(TPGTaskStep(ListBox1.Items.Objects[i]));
    end;
  end
  else
  if ASQLObject is TPGSQLTaskAlter then
  begin
    FCmd1:=TPGSQLTaskAlter(ASQLObject);
    for i:=0 to FDelList.Count-1 do
    begin
      Op:=FCmd1.AddOperator(pgtaDropTaskItem);
      Op.ID:=TPGTaskStep(FDelList[i]).ID;
    end;
  end
  else
    Result:=false;
end;

end.

