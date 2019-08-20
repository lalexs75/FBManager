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

unit fbmpgtablepropertysunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ExtCtrls, Spin,
  Buttons, fdmAbstractEditorUnit, PostgreSQLEngineUnit, SQLEngineAbstractUnit,
  sqlObjects, fbmSqlParserUnit;

type

  { TfbmpgTablePropertysFrame }

  TfbmpgTablePropertysFrame = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    cbTableSpace: TComboBox;
    ComboBox2: TComboBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpinEdit1: TSpinEdit;
    procedure CheckBox3Change(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure FillTables;
    //procedure FillTableSpaces;
    procedure RefreshObject;
    procedure UpdateInhLists;
    function Compile:boolean;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, pgSqlEngineSecurityUnit, SQLEngineCommonTypesUnit, pg_SqlParserUnit,
  rxboxprocs;

{$R *.lfm}

{ TfbmpgTablePropertysFrame }

procedure TfbmpgTablePropertysFrame.CheckBox3Change(Sender: TObject);
begin
  SpinEdit1.Enabled:=CheckBox3.Checked;
end;

procedure TfbmpgTablePropertysFrame.RadioGroup3Click(Sender: TObject);
begin
  RadioGroup1.Enabled:=RadioGroup3.Enabled and (RadioGroup3.ItemIndex = 2);
  RadioGroup2.Enabled:=RadioGroup1.Enabled;
end;

procedure TfbmpgTablePropertysFrame.SpeedButton1Click(Sender: TObject);
begin
  BoxMoveSelectedItems(ListBox1, ListBox2);
  UpdateInhLists;
end;

procedure TfbmpgTablePropertysFrame.SpeedButton2Click(Sender: TObject);
begin
  BoxMoveSelectedItems(ListBox2, ListBox1);
  UpdateInhLists;
end;

procedure TfbmpgTablePropertysFrame.FillTables;
var
  i:integer;
begin
  ListBox1.Items.Clear;
  ListBox2.Items.Clear;
  DBObject.OwnerDB.FillListForNames(ListBox1.Items, [okTable]);

  for i:=0 to TPGTable(DBObject).InheritedTablesCount-1 do
    ListBox2.Items.Add(TPGTable(DBObject).InheritedTable(i).CaptionFullPatch);
end;

procedure TfbmpgTablePropertysFrame.RefreshObject;
begin
  FillTables;

  cbTableSpace.Items.Clear;
  ComboBox2.Items.Clear;

  DBObject.OwnerDB.FillListForNames(cbTableSpace.Items, [okTableSpace]);
  DBObject.OwnerDB.FillListForNames(ComboBox2.Items, [okGroup, okUser]);
  cbTableSpace.Text:=TPGTable(DBObject).TablespaceName;

  if TPGTable(DBObject).TableUnloged then
    RadioGroup3.ItemIndex:=1
  else
  if TPGTable(DBObject).TableTemp then
    RadioGroup3.ItemIndex:=2
  else
    RadioGroup3.ItemIndex:=0
  ;
  CheckBox1.Checked:=TPGTable(DBObject).TableHasOIDS;
  CheckBox1.Enabled:=TPGTable(DBObject).State = sdboCreate;
  RadioGroup3Click(nil);
end;

procedure TfbmpgTablePropertysFrame.UpdateInhLists;
begin
  SpeedButton1.Enabled:=ListBox1.Items.Count>0;
  SpeedButton2.Enabled:=ListBox2.Items.Count>0;
end;

function TfbmpgTablePropertysFrame.Compile: boolean;
var
  i:integer;
  T:TPGTable;
  U:TPGUser;
  G:TPGGroup;
  S:string;
begin
  if TPGTable(DBObject).State = sdboCreate then
  begin
    TPGTable(DBObject).InhTables.Clear;
    for i:=0 to ListBox2.Items.Count - 1 do
    begin
      T:=TPGTable(DBObject).OwnerDB.DBObjectByName(ListBox2.Items[i]) as TPGTable;
      TPGTable(DBObject).InhTables.Add(T);
    end;
    //TPGTable(DBObject).;

    S:=Trim(ComboBox2.Text);
    if S<>'' then
    begin
      U:=TPGSecurityRoot(TSQLEnginePostgre(TPGTable(DBObject).OwnerDB).SecurityRoot).PGUsersRoot.ObjByName(S) as TPGUser;
      if Assigned(U) then
        TPGTable(DBObject).OwnerID:=U.UserID
      else
      begin
        G:=TPGSecurityRoot(TSQLEnginePostgre(TPGTable(DBObject).OwnerDB).SecurityRoot).PGGroupsRoot.ObjByName(S) as TPGGroup;
        if Assigned(G) then
          TPGTable(DBObject).OwnerID:=G.ObjID;
      end;
    end;

    Result:=true;
  end
  else
    Result:=false;
end;

function TfbmpgTablePropertysFrame.PageName: string;
begin
  Result:=sProperty;
end;

constructor TfbmpgTablePropertysFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RefreshObject;
end;

function TfbmpgTablePropertysFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  case PageAction of
    epaCompile:Result:=TPGTable(DBObject).State = sdboCreate;
  else
    Result:=PageAction in [epaPrint, epaRefresh];
  end;
end;

function TfbmpgTablePropertysFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshObject;
  else
    Result:=false;
  end;
end;

procedure TfbmpgTablePropertysFrame.Localize;
begin
  Label1.Caption:=sTableSpace;
  Label2.Caption:=sTableOwner;
  CheckBox3.Caption:=sUseDefFillFactor;
  GroupBox1.Caption:=sInheritsTableFrom;
  CheckBox1.Caption:=sWithOIDs;
  RadioGroup3.Items[2]:=sTemporary;
  RadioGroup1.Items.Clear;
  RadioGroup1.Items.Add(sPreserveRows);
  RadioGroup1.Items.Add(sDeleteRows);
  RadioGroup1.Items.Add(sDropTable);
end;

function TfbmpgTablePropertysFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  S: String;
  OP: TAlterTableOperator;
begin
  Result:=false;
  if ASQLObject is TPGSQLCreateTable then
  begin
    TPGSQLCreateTable(ASQLObject).TableSpace:=cbTableSpace.Text;
    if RadioGroup3.ItemIndex = 2 then
    begin
      TPGSQLCreateTable(ASQLObject).Options:=TPGSQLCreateTable(ASQLObject).Options + [ooTemporary];
      case RadioGroup2.ItemIndex of
        0:TPGSQLCreateTable(ASQLObject).VisibleType:=vtGlobal;
        1:TPGSQLCreateTable(ASQLObject).VisibleType:=vtLocal;
      end;
      case RadioGroup1.ItemIndex of
        0:TPGSQLCreateTable(ASQLObject).OnCommitAction:=caPreserveRows;
        1:TPGSQLCreateTable(ASQLObject).OnCommitAction:=caDeleteRows;
        2:TPGSQLCreateTable(ASQLObject).OnCommitAction:=caDrop;
      end
    end;

    if ListBox1.Count > 0 then
      for S in ListBox2.Items do
        TPGSQLCreateTable(ASQLObject).InheritsTables.Add(S);

    if CheckBox1.Checked then
      TPGSQLCreateTable(ASQLObject).PGOptions:=TPGSQLCreateTable(ASQLObject).PGOptions + [pgoWithOids];

    TPGSQLCreateTable(ASQLObject).Owner:=ComboBox2.Text;
    TPGSQLCreateTable(ASQLObject).Unlogged:=RadioGroup3.ItemIndex = 2;
  end
  else
  if ASQLObject is TPGSQLAlterTable then
  begin
    if cbTableSpace.Caption<>TPGTable(DBObject).TablespaceName then
    begin
      OP:=TPGSQLAlterTable(ASQLObject).AddOperator(ataSetTablespace);
      OP.;
    end;
  end
  else
    exit;
  Result:=true;
end;

end.

