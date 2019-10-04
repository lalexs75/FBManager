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

unit fbmPGTablePartitionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ActnList, Menus, DB, rxdbgrid, rxmemds, rxctrls, DividerBevel,
  fdmAbstractEditorUnit, pg_SqlParserUnit, fbmSqlParserUnit,
  SQLEngineAbstractUnit, PostgreSQLEngineUnit;

type

  { TfbmPGTablePartitionPage }

  TfbmPGTablePartitionPage = class(TEditorPage)
    MenuItem8: TMenuItem;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    sSectionEdit: TAction;
    keyEdit: TAction;
    Edit1: TEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    rxKeysExpression: TStringField;
    rxKeysKeyType: TLongintField;
    rxSectionDEFAULT: TBooleanField;
    rxSectionH_MODULUS: TStringField;
    rxSectionH_REMINDER: TStringField;
    rxSectionNAME: TStringField;
    rxSectionR_FROM: TStringField;
    rxSectionR_IN: TStringField;
    rxSectionR_TO: TStringField;
    sSectionRemove: TAction;
    sSectionAdd: TAction;
    keyRemove: TAction;
    keyAdd: TAction;
    ActionList1: TActionList;
    ComboBox1: TComboBox;
    dsKeys: TDataSource;
    dsSection: TDataSource;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    RxDBGrid2: TRxDBGrid;
    rxKeys: TRxMemoryData;
    rxSection: TRxMemoryData;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure ComboBox1Change(Sender: TObject);
    procedure keyAddExecute(Sender: TObject);
    procedure keyRemoveExecute(Sender: TObject);
    procedure rxKeysKeyTypeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure rxSectionAfterInsert(DataSet: TDataSet);
    procedure sSectionAddExecute(Sender: TObject);
    procedure sSectionRemoveExecute(Sender: TObject);
  private
    procedure RefreshPage;
    procedure LoadSpr;
    procedure UpdateSectionsGrid(APartitionType:TPGSQLPartitionType);
  public
    class function PageExists(ADBObject:TDBObject):Boolean; override;
    function PageName:string; override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

uses rxdbutils, fbmStrConstUnit, pgTypes,
  fbmTableEditorFieldsUnit, fbmPGTablePartition_EditKeyUnit,
  fbmPGTablePartition_EditSectionUnit;

{$R *.lfm}

{ TfbmPGTablePartitionPage }

procedure TfbmPGTablePartitionPage.keyAddExecute(Sender: TObject);
var
  F: TfbmTableEditorFieldsFrame;
begin
  fbmPGTablePartition_EditKeyForm:=TfbmPGTablePartition_EditKeyForm.Create(Application);
  fbmPGTablePartition_EditKeyForm.FEditorFrame.SQLEngine:=DBObject.OwnerDB;

  F:=FindPageByClass(TfbmTableEditorFieldsFrame) as TfbmTableEditorFieldsFrame;
  if Assigned(F) then
    FieldValueToStrings(F.rxFieldList, 'FIELD_NAME', fbmPGTablePartition_EditKeyForm.ComboBox1.Items);

  if (Sender as TComponent).Tag = 1 then
  begin
    fbmPGTablePartition_EditKeyForm.RadioButton1.Checked:=rxKeysKeyType.AsInteger = 0;
    fbmPGTablePartition_EditKeyForm.RadioButton2.Checked:=rxKeysKeyType.AsInteger <> 0;

    if rxKeysKeyType.AsInteger = 0 then
      fbmPGTablePartition_EditKeyForm.ComboBox1.Text:=rxKeysExpression.AsString
    else
      fbmPGTablePartition_EditKeyForm.FEditorFrame.EditorText:=rxKeysExpression.AsString;
  end;

  if fbmPGTablePartition_EditKeyForm.ShowModal = mrOk then
  begin
    if (Sender as TComponent).Tag = 1 then
      rxKeys.Edit
    else
      rxKeys.Append;
    rxKeysKeyType.AsInteger:=Ord(fbmPGTablePartition_EditKeyForm.RadioButton2.Checked);
    if rxKeysKeyType.AsInteger = 0 then
      rxKeysExpression.AsString:=fbmPGTablePartition_EditKeyForm.ComboBox1.Text
    else
      rxKeysExpression.AsString:=fbmPGTablePartition_EditKeyForm.FEditorFrame.EditorText;
    rxKeys.Post;
  end;
  fbmPGTablePartition_EditKeyForm.Free;
end;

procedure TfbmPGTablePartitionPage.keyRemoveExecute(Sender: TObject);
begin
  //
end;

procedure TfbmPGTablePartitionPage.ComboBox1Change(Sender: TObject);
begin
  UpdateSectionsGrid(TPGSQLPartitionType(ComboBox1.ItemIndex));
end;

procedure TfbmPGTablePartitionPage.rxKeysKeyTypeGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  if rxKeysKeyType.AsInteger = 0 then
    aText:=sField
  else
    aText:=sExpression;
end;

procedure TfbmPGTablePartitionPage.rxSectionAfterInsert(DataSet: TDataSet);
begin
  rxSectionDEFAULT.AsBoolean:=false;
end;

procedure TfbmPGTablePartitionPage.sSectionAddExecute(Sender: TObject);
begin
  fbmPGTablePartition_EditSectionForm:=TfbmPGTablePartition_EditSectionForm.Create(Application);
  if fbmPGTablePartition_EditSectionForm.ShowModal = mrOk then
  begin
    ;
  end;
  fbmPGTablePartition_EditSectionForm.Free;
end;

procedure TfbmPGTablePartitionPage.sSectionRemoveExecute(Sender: TObject);
begin
  //
end;

procedure TfbmPGTablePartitionPage.RefreshPage;
var
  P: TPGTablePartition;
begin
  LoadSpr;

  rxSection.CloseOpen;

  Edit1.Visible:=DBObject.State <> sdboCreate;
  ComboBox1.Visible:=DBObject.State = sdboCreate;
  DividerBevel1.Visible:=DBObject.State = sdboCreate;
  RxDBGrid1.Visible:=DBObject.State = sdboCreate;
  keyAdd.Visible:=DBObject.State = sdboCreate;
  keyRemove.Visible:=DBObject.State = sdboCreate;

  if DBObject.State = sdboCreate then
  begin
    ComboBox1.ItemIndex:=0;
    ComboBox1Change(nil);
  end
  else
  begin
    DividerBevel2.AnchorSideTop.Control:=Edit1;
    Edit1.Text:=TPGTable(DBObject).PartitionedTypeName;
    Label1.AnchorSideBottom.Control:=Edit1;

    UpdateSectionsGrid(TPGTable(DBObject).PartitionedType);

    for P in TPGTable(DBObject).PartitionList do
    begin
      rxSection.Append;
      rxSectionNAME.AsString:=P.Name;
      case P.DataType of
        podtDefault:rxSectionDEFAULT.AsBoolean:=true;
        podtIn:rxSectionR_IN.AsString:=P.InExp;
        podtFromTo:begin
            rxSectionR_FROM.AsString:=P.FromExp;
            rxSectionR_TO.AsString:=P.ToExp;
          end;
        //podtWith:rxSectionH_MODULUS.AsString:=P.InExp;
      end;
      rxSection.Post;
    end;
  end;
end;

procedure TfbmPGTablePartitionPage.LoadSpr;
var
  C: TRxColumn;
  F: TfbmTableEditorFieldsFrame;
begin
  if DBObject.State = sdboCreate then
  begin
    C:=RxDBGrid1.ColumnByFieldName('KeyType');
    C.PickList.Clear;
    F:=FindPageByClass(TfbmTableEditorFieldsFrame) as TfbmTableEditorFieldsFrame;
    if Assigned(F) then
      FieldValueToStrings(F.rxFieldList, 'FIELD_NAME', C.PickList);
  end;
end;

procedure TfbmPGTablePartitionPage.UpdateSectionsGrid(
  APartitionType: TPGSQLPartitionType);
begin
  DividerBevel2.Visible:=APartitionType <> ptNone;
  RxDBGrid2.Visible:=APartitionType <> ptNone;
  sSectionAdd.Visible:=APartitionType <> ptNone;
  sSectionEdit.Visible:=APartitionType <> ptNone;
  sSectionRemove.Visible:=APartitionType <> ptNone;

  if APartitionType <> ptNone then
  begin
    RxDBGrid2.ColumnByFieldName('R_FROM').Visible:=APartitionType = ptRange;
    RxDBGrid2.ColumnByFieldName('R_TO').Visible:=APartitionType = ptRange;

    RxDBGrid2.ColumnByFieldName('R_IN').Visible:=APartitionType = ptList;

    RxDBGrid2.ColumnByFieldName('H_MODULUS').Visible:=APartitionType = ptHash;
    RxDBGrid2.ColumnByFieldName('H_REMINDER').Visible:=APartitionType = ptHash;
  end;
end;

class function TfbmPGTablePartitionPage.PageExists(ADBObject: TDBObject
  ): Boolean;
begin
  Result:=Assigned(ADBObject) and (ADBObject.OwnerDB is TSQLEnginePostgre) and (TSQLEnginePostgre(ADBObject.OwnerDB).ServerVersion >= pgVersion10_0);
  if Result and (ADBObject.State = sdboEdit) then
    Result:=TPGTable(ADBObject).PartitionedTable;
end;

function TfbmPGTablePartitionPage.PageName: string;
begin
  Result:=sPartitions;
end;

function TfbmPGTablePartitionPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

procedure TfbmPGTablePartitionPage.Activate;
begin
  inherited Activate;
  RefreshPage;
end;

function TfbmPGTablePartitionPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaAdd, epaEdit, epaDelete, epaRefresh, epaPrint, epaCompile];
end;

constructor TfbmPGTablePartitionPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxKeys.Open;
  RefreshPage;
end;

procedure TfbmPGTablePartitionPage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sPartitionType;
  DividerBevel1.Caption:=sPartitionKeys;
  DividerBevel2.Caption:=sPartitionSections;

  RxDBGrid2.ColumnByFieldName('NAME').Title.Caption:=sSectionName;
  RxDBGrid2.ColumnByFieldName('R_FROM').Title.Caption:=sFrom;
  RxDBGrid2.ColumnByFieldName('R_TO').Title.Caption:=sTo;
  RxDBGrid2.ColumnByFieldName('R_IN').Title.Caption:=sIn;
  RxDBGrid2.ColumnByFieldName('DEFAULT').Title.Caption:=sDefault;

//  RxDBGrid2.ColumnByFieldName('H_MODULUS').Title.Caption:=ComboBox1.ItemIndex = 3;
//  RxDBGrid2.ColumnByFieldName('H_REMINDER').Title.Caption:=ComboBox1.ItemIndex = 3;

  //StaticText1.Caption:=;
  //StaticText2.Caption:=;

  ComboBox1.Items[0]:=sNone;
  ComboBox1.Items[1]:=sRange;
  ComboBox1.Items[2]:=sList;
  keyAdd.Caption:=sAdd;
  keyRemove.Caption:=sRemove;

  sSectionAdd.Caption:=sAdd;
  sSectionRemove.Caption:=sRemove;
end;

function TfbmPGTablePartitionPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FCmd: TPGSQLCreateTable;
begin
  Result:=true;
  if DBObject.State = sdboCreate then
  begin
    FCmd:=TPGSQLCreateTable(ASQLObject);
    if ComboBox1.ItemIndex > 0 then
    begin
      rxKeys.DisableControls;
      rxKeys.First;
      while not rxKeys.EOF do
      begin
        FCmd.TablePartition.Params.AddParam(rxKeysExpression.AsString);
        rxKeys.Next;
      end;
      rxKeys.First;
      rxKeys.EnableControls;

      case ComboBox1.ItemIndex of
        1:FCmd.TablePartition.PartitionType:=ptRange;
        2:FCmd.TablePartition.PartitionType:=ptList;
        3:FCmd.TablePartition.PartitionType:=ptHash;
      end;
    end;
  end;
end;

end.

