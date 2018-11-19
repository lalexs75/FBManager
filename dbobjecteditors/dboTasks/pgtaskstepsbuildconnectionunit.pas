{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pgTaskStepsBuildConnectionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ButtonPanel, StdCtrls, Spin;

type

  { TpgTaskStepsBuildConnectionForm }

  TpgTaskStepsBuildConnectionForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PageControl1: TPageControl;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    function GetConnectionString: string;
    procedure SetConnectionString(AValue: string);
    procedure LoadTree;
    procedure LoadDefValues;
    procedure Localize;
  public
    property ConnectionString:string read GetConnectionString write SetConnectionString;
  end;

var
  pgTaskStepsBuildConnectionForm: TpgTaskStepsBuildConnectionForm;

implementation

uses IBManDataInspectorUnit, ibmanagertypesunit, fbmStrConstUnit, strutils,
  PostgreSQLEngineUnit, SQLEngineAbstractUnit;

{$R *.lfm}

{ TpgTaskStepsBuildConnectionForm }

procedure TpgTaskStepsBuildConnectionForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex:=0;
  LoadTree;
  LoadDefValues;
  Localize;
end;

procedure TpgTaskStepsBuildConnectionForm.TreeView1DblClick(Sender: TObject);
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) and Assigned(TDataBaseRecord(TreeView1.Selected.Data).SQLEngine) then
    ModalResult:=mrOk;
end;

function TpgTaskStepsBuildConnectionForm.GetConnectionString: string;
var
  D:TSQLEngineAbstract;
begin
  if PageControl1.ActivePageIndex = 0 then
  begin
    if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) and Assigned(TDataBaseRecord(TreeView1.Selected.Data).SQLEngine) then
    begin
      D:=TDataBaseRecord(TreeView1.Selected.Data).SQLEngine;
      Result:=Format('user=%s host=%s dbname=%s', [D.UserName, D.ServerName, D.DataBaseName]);
      if TSQLEnginePostgre(D).RemotePort <> 0 then
        Result:=Result + 'port='+IntToStr(TSQLEnginePostgre(D).RemotePort);
    end;
  end
  else
    Result:=Format('user=%s host=%s dbname=%s port=%d', [Edit1.Text, ComboBox1.Text, ComboBox2.Text, SpinEdit1.Value]);
end;

procedure TpgTaskStepsBuildConnectionForm.SetConnectionString(AValue: string);
var
  ParName:string;
  ParVal:string;
begin
  while AValue <> '' do
  begin
    AValue:=Trim(AValue);
    ParName:=Copy2SymbDel(AValue, '=');
    ParVal:=Copy2SpaceDel(AValue);
    if (ParName<>'') and (ParVal<>'') then
    begin
      if ParName = 'user' then
        Edit1.Text:=ParVal
      else
      if ParName = 'host' then
        ComboBox1.Text:=ParVal
      else
      if ParName = 'dbname' then
        ComboBox2.Text:=ParVal
      else
      if ParName = 'port' then
        SpinEdit1.Value:=StrToIntDef(ParVal, 0);
    end;
  end;
  PageControl1.ActivePageIndex:=1;
end;

procedure TpgTaskStepsBuildConnectionForm.LoadTree;
var
  i: Integer;
  R: TTreeNode;
begin
  TreeView1.Items.Clear;
  if Assigned(fbManDataInpectorForm) then
  begin
    for i:=0 to fbManDataInpectorForm.DBList.Count - 1 do
    if fbManDataInpectorForm.DBList[i].SQLEngine is TSQLEnginePostgre then
    begin
      R:=TreeView1.Items.Add(nil, fbManDataInpectorForm.DBList[i].Caption);
      R.Data:=fbManDataInpectorForm.DBList[i];
      if fbManDataInpectorForm.DBList[i].Connected then
        R.ImageIndex:=23
      else
        R.ImageIndex:=24;
      R.StateIndex:=R.ImageIndex;
      R.SelectedIndex:=R.ImageIndex;
    end;
  end;
end;

procedure TpgTaskStepsBuildConnectionForm.LoadDefValues;
var
  D: TSQLEngineAbstract;
  i: Integer;
begin
  ComboBox1.Items.Clear;
  ComboBox2.Items.Clear;
  if Assigned(fbManDataInpectorForm) then
  begin
    for i:=0 to fbManDataInpectorForm.DBList.Count - 1 do
    if fbManDataInpectorForm.DBList[i].SQLEngine is TSQLEnginePostgre then
    begin
      D:=fbManDataInpectorForm.DBList[i].SQLEngine;
      if Assigned(D) then
      begin
        if ComboBox1.Items.IndexOf(D.ServerName) < 0 then
          ComboBox1.Items.Add(D.ServerName);
        if ComboBox2.Items.IndexOf(D.DataBaseName) < 0 then
          ComboBox2.Items.Add(D.DataBaseName);
      end;
    end;
  end;
end;

procedure TpgTaskStepsBuildConnectionForm.Localize;
begin
  Caption:=sBuildConnectionString;
  TabSheet1.Caption:=sRegistredDatabase;
  TabSheet2.Caption:=sEnterValues;
  Label1.Caption:=sHostName;
  Label2.Caption:=sDatabaseName;
  Label3.Caption:=sPort;
  Label4.Caption:=sUser;
  Label5.Caption:=sPassword;

end;

end.

