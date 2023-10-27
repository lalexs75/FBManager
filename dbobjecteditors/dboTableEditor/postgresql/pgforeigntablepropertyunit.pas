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

unit pgForeignTablePropertyUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, DB, SQLEngineAbstractUnit,
  rxdbgrid, rxmemds, fdmAbstractEditorUnit, fbmSqlParserUnit;

type

  { TpgForeignTablePropertyFrame }

  TpgForeignTablePropertyFrame = class(TEditorPage)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    dsData: TDataSource;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    rxData: TRxMemoryData;
    rxDataKEY: TStringField;
    rxDataValue: TStringField;
    RxDBGrid1: TRxDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure RxDBGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure RxDBGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure UpdateInhLists;
    procedure RefreshObject;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses sqlObjects, rxboxprocs, rxAppUtils, fbmStrConstUnit, PostgreSQLEngineUnit,
  rxstrutils, fbmToolsUnit, IBManDataInspectorUnit, fbmTableEditorFieldsUnit,
  pgSQLEngineFDW, pg_SqlParserUnit;

{$R *.lfm}

{ TpgForeignTablePropertyFrame }

procedure TpgForeignTablePropertyFrame.SpeedButton1Click(Sender: TObject);
begin
  BoxMoveSelectedItems(ListBox1, ListBox2);
  UpdateInhLists;
end;

procedure TpgForeignTablePropertyFrame.Button1Click(Sender: TObject);

function DoFindFS(AFSName:string):TPGForeignServer;
var
  DWR: TPGForeignDataWrapperRoot;
  j, i: Integer;
  DW: TPGForeignDataWrapper;
  Srw: TPGForeignServer;
begin
  Result:=nil;
  DWR:=TSQLEnginePostgre(DBObject.OwnerDB).ForeignDataWrappers as TPGForeignDataWrapperRoot;
  if not Assigned(DWR) then Exit;
  for j:=0 to DWR.CountGroups-1 do
  begin
    DW:=DWR.Groups[j] as TPGForeignDataWrapper;
    for i:=0 to DW.ForeignServers.CountGroups - 1 do
    begin
      Srw:=DW.ForeignServers.Groups[i] as TPGForeignServer;
      if Srw.Caption = AFSName then
        Exit(Srw);
    end;
  end;

end;

var
  FS: TPGForeignServer;
  S: String;
  E:TSQLEngineAbstract;
begin
  if ComboBox1.Text <> '' then
    FS:=DoFindFS(ComboBox1.Text)
  else
    FS:=nil;
  if not Assigned(FS) then
  begin
    ErrorBox('Not selected server');
    Exit;
  end;

  FS.RefreshObject;

  S:=TPGForeignDataWrapper(FS.OwnerRoot.OwnerRoot).Caption;
  //TODO - Плохой метод - может потом переделаем получше...
  if S = 'postgres_fdw' then
    E:=TSQLEnginePostgre.Create;

  if not Assigned(E) then
  begin
    ErrorBox('Uknow data wrape - not retrive tables list');
    Exit;
  end;

  //E.UserName:=false;
  try
    E.ServerName:=FS.Options.Values['host'];
    if StrToIntDef(FS.Options.Values['port'], -1) > 0 then
      E.RemotePort:=StrToIntDef(FS.Options.Values['port'], -1);
    E.DataBaseName:=FS.Options.Values['dbname'];
    /// - temp. for debug only
    E.UserName:=DBObject.OwnerDB.UserName;
    E.Password:=DBObject.OwnerDB.Password;
    ///
    E.Connected:=true;
    InfoBox('Ok!');
  finally
    E.Connected:=false;
  end;

  E.Free;
end;

procedure TpgForeignTablePropertyFrame.RxDBGrid1DragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  Control: TControl;
  FDBTable: TDBDataSetObject;
  F: TDBField;
  F1: TfbmTableEditorFieldsFrame;
  i: Integer;
begin
  Control:=DoAcceptDrag(Source);
  if (Control <> fbManDataInpectorForm.TreeView1) or (not Assigned(fbManDataInpectorForm.CurrentObject))
    or (not Assigned(fbManDataInpectorForm.CurrentObject.DBObject))
    or (not (fbManDataInpectorForm.CurrentDB.SQLEngine <> DBObject.OwnerDB))
    or (not (fbManDataInpectorForm.CurrentObject.DBObject.DBObjectKind in [okTable])) then Exit;

  if not QuestionBox(sCopyFields) then Exit;

  FDBTable:=fbManDataInpectorForm.CurrentObject.DBObject as TDBDataSetObject;

  rxData.AppendRecord(['schema_name', FDBTable.SchemaName]);
  rxData.AppendRecord(['table_name', FDBTable.Caption]);

  F1:=FindPageByClass(TfbmTableEditorFieldsFrame) as TfbmTableEditorFieldsFrame;
  if Assigned(F1)  then
  begin
    F1:=Owner.Components[i] as TfbmTableEditorFieldsFrame;
    F1.FieldListGridDragDrop(Sender, Source, X, Y);
    F1.edtTableName.Text:=FDBTable.Caption;
  end;
end;

procedure TpgForeignTablePropertyFrame.RxDBGrid1DragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  Control: TControl;
begin
  Control:=DoAcceptDrag(Source);
  Accept:=(DBObject.State = sdboCreate)
    and (Control = fbManDataInpectorForm.TreeView1) and Assigned(fbManDataInpectorForm.CurrentObject)
    and Assigned(fbManDataInpectorForm.CurrentDB)
    and (fbManDataInpectorForm.CurrentDB.SQLEngine <> DBObject.OwnerDB)
    and Assigned(fbManDataInpectorForm.CurrentObject.DBObject)
    and (fbManDataInpectorForm.CurrentObject.DBObject.DBObjectKind in [okTable]);
end;

procedure TpgForeignTablePropertyFrame.SpeedButton2Click(Sender: TObject);
begin
  BoxMoveSelectedItems(ListBox2, ListBox1);
  UpdateInhLists;
end;

procedure TpgForeignTablePropertyFrame.UpdateInhLists;
begin
  SpeedButton1.Enabled:=ListBox1.Items.Count>0;
  SpeedButton2.Enabled:=ListBox2.Items.Count>0;
end;

procedure TpgForeignTablePropertyFrame.RefreshObject;
var
  I: Integer;
begin
  ComboBox2.Items.Clear;
  DBObject.OwnerDB.FillListForNames(ComboBox2.Items, [okGroup, okUser]);
  if DBObject.State = sdboEdit then
  begin
    rxData.CloseOpen;
    for I:=0 to TPGForeignTable(DBObject).ForeignTableOptions.Count-1 do
      rxData.AppendRecord([TPGForeignTable(DBObject).ForeignTableOptions.Names[i], TPGForeignTable(DBObject).ForeignTableOptions.ValueFromIndex[i]]);
    rxData.First;

    ComboBox1.Text:=TPGForeignTable(DBObject).ForeignServer;
    ComboBox2.Text:=TPGForeignTable(DBObject).OwnerName;

  end
  else
  begin
    ComboBox1.Items.Clear;
    DBObject.OwnerDB.FillListForNames(ComboBox1.Items, [okForeignServer]);
  end;
end;

function TpgForeignTablePropertyFrame.PageName: string;
begin
  Result:=sProperty;
end;

constructor TpgForeignTablePropertyFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxData.Open;
  RefreshObject;

  Label2.Enabled:=DBObject.State = sdboCreate;
  Button1.Enabled:=DBObject.State = sdboCreate;
  ComboBox1.Enabled:=DBObject.State = sdboCreate;
  RxDBGrid1.ReadOnly:=DBObject.State <> sdboCreate;
  Label5.Enabled:=DBObject.State = sdboCreate;
end;

function TpgForeignTablePropertyFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaCompile];
{  case PageAction of
    epaRefresh:RefreshObject;
  else
    Result:=false;
  end;}
end;

function TpgForeignTablePropertyFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshObject;
  else
    Result:=false;
  end;
end;

procedure TpgForeignTablePropertyFrame.Localize;
begin
  Label4.Caption:=sTableOwner;
  GroupBox1.Caption:=sInheritsTableFrom;
  CheckBox1.Caption:=sWithOIDs;
end;

function TpgForeignTablePropertyFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  if ASQLObject is TPGSQLCreateForeignTable then
  begin
    TPGSQLCreateForeignTable(ASQLObject).ServerName:=ComboBox1.Text;
    rxData.First;
    while not rxData.EOF do
    begin
      TPGSQLCreateForeignTable(ASQLObject).Params.AddParamEx(rxDataKEY.AsString, QuotedString(rxDataValue.AsString, ''''));
      rxData.Next;
    end;
    rxData.First;

    //todo - inherited table and partition
    //todo - with OIDs
    //todo - Set table owner
    Result:=true;
  end
  else
    Result:=false;
end;

end.

