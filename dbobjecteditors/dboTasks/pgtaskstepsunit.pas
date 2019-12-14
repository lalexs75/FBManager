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
  StdCtrls, EditBtn, ComCtrls, PostgreSQLEngineUnit, pg_tasks, fbmSqlParserUnit,
  fdmAbstractEditorUnit, fdbm_SynEditorUnit, SQLEngineAbstractUnit;

type

  { TpgTaskStepsPage }

  TpgTaskStepsPage = class(TEditorPage)
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    EditButton1: TEditButton;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    PageControl1: TPageControl;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Edit1Change(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    FModified: Boolean;
    FCurStep: TPGTaskStep;
    procedure LoadTaskData;
    procedure ClearData;
    procedure LoadDBList;
    function DeleteTaskStep:boolean;
    function SaveCurrent:boolean;
    function AddNew:boolean;
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
uses ZDataset, pg_sql_lines_unit, pgSqlTextUnit, fbmStrConstUnit,
  pgTaskStepsBuildConnectionUnit;

{$R *.lfm}

{ TpgTaskStepsPage }

procedure TpgTaskStepsPage.ListBox1Click(Sender: TObject);
var
  U: TPGTaskStep;
begin
  if (ListBox1.Items.Count>0) and (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex<ListBox1.Items.Count) then
  begin
    if FModified then
      SaveCurrent;

    U:=TPGTaskStep(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    Edit1.Text:=U.Name;
    EditorFrame.EditorText:=U.Body;
    Memo1.Text:=U.Description;
    RadioButton1.Checked:=U.ConnectStr = '';
    RadioButton2.Checked:=U.ConnectStr <> '';
    ComboBox1.Text:=U.DBName;
    EditButton1.Text:=U.ConnectStr;
    CheckBox1.Checked:=U.Enabled;
    FModified:=false;
    FCurStep:=U;
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

procedure TpgTaskStepsPage.Edit1Change(Sender: TObject);
begin
  FModified:=true;
end;

procedure TpgTaskStepsPage.RadioButton1Change(Sender: TObject);
begin
  ComboBox1.Enabled:=RadioButton1.Checked;
  EditButton1.Enabled:=RadioButton2.Checked;
  Edit1Change(nil);
end;

procedure TpgTaskStepsPage.LoadTaskData;
var
  U, U1:TPGTaskStep;
begin
  ClearData;

  for U in TPGTask(DBObject).Steps do
  begin
    U1:=TPGTaskStep.Create(nil);
    U1.Assign(U);
    ListBox1.Items.AddObject(U1.Name, U1);
  end;

  if ListBox1.Items.Count>0 then
  begin
    ListBox1.ItemIndex:=0;
    FModified:=false;
    ListBox1Click(nil);
  end;
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
begin
{  Result:=false;
  if Assigned(FCurStep) then
  begin
    TPGTask(DBObject).DeleteTaskStep(FCurStep);
    FCurStep:=nil;
    LoadTaskData;
  end; }
end;

function TpgTaskStepsPage.SaveCurrent: boolean;
var
  U:TPGTaskStep;
begin
{  Result:=FModified and Assigned(FCurStep);
  if not Result then exit;
  try
    U:=TPGTaskStep.Create(TPGTask(DBObject));
    U.Assign(FCurStep);
    U.ID:=FCurStep.ID;
    U.Name := Edit1.Text;
    U.Body := EditorFrame.EditorText;
    U.Description := Memo1.Text;
    U.DBName := ComboBox1.Text;
    U.ConnectStr := EditButton1.Text;
    U.Enabled := CheckBox1.Checked;
    if not FCurStep.IsEqual(U) then
      Result:=TPGTask(DBObject).CompileTaskStep(U);
  finally
    U.Free;
  end; }
end;

function TpgTaskStepsPage.AddNew: boolean;
var
  U: TPGTaskStep;
begin
  ListBox1.Items.Add(sStep+' '+IntToStr(ListBox1.Items.Count+1));
  U:=TPGTaskStep.Create(TPGTask(DBObject));
  ListBox1.Items.Objects[ListBox1.Count-1]:=U;
  U.Name:=ListBox1.Items[ListBox1.Count-1];
  ListBox1.ItemIndex:=ListBox1.Count-1;
  ListBox1Click(nil);
end;

function TpgTaskStepsPage.PageName: string;
begin
  Result:=sSteps;
end;

destructor TpgTaskStepsPage.Destroy;
begin
  ClearData;
  inherited Destroy;
end;

function TpgTaskStepsPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  case PageAction of
    epaRefresh:LoadTaskData;
//    epaPrint,
    epaCompile:Result:=SaveCurrent;
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
end;

constructor TpgTaskStepsPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  FCurStep:=nil;
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=TabSheet2;
  EditorFrame.TextEditor.OnChange:=@Edit1Change;
  LoadDBList;
  LoadTaskData;
end;

function TpgTaskStepsPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
var
  FCmd: TPGSQLTaskCreate;
begin
  if ASQLObject is TPGSQLTaskCreate then
  begin
    Result:=true;
    FCmd:=TPGSQLTaskCreate(ASQLObject);
  end
  else
    Result:=false;
end;

end.

