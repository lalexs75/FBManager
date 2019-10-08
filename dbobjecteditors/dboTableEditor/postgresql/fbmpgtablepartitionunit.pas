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
  ActnList, Menus, ExtCtrls, DBCtrls, DB, rxdbgrid, rxmemds, rxctrls,
  DividerBevel, fdmAbstractEditorUnit, pg_SqlParserUnit, fbmSqlParserUnit,
  SQLEngineAbstractUnit, PostgreSQLEngineUnit;

type

  { TfbmPGTablePartitionPage }

  TfbmPGTablePartitionPage = class(TEditorPage)
    DBMemo1: TDBMemo;
    MenuItem8: TMenuItem;
    Panel1: TPanel;
    rxSectionDescription: TStringField;
    rxSectionOID: TLongintField;
    rxSectionSchemaID: TLongintField;
    rxSectionTABLE_SPACE_ID: TLongintField;
    rxSectionTABLE_SPACE_NAME: TStringField;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Splitter1: TSplitter;
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
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure RxDBGrid2DblClick(Sender: TObject);
    procedure rxKeysKeyTypeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure rxSectionAfterInsert(DataSet: TDataSet);
    procedure rxSectionAfterPost(DataSet: TDataSet);
    procedure SpeedButton2DblClick(Sender: TObject);
    procedure sSectionAddExecute(Sender: TObject);
    procedure sSectionEditExecute(Sender: TObject);
    procedure sSectionRemoveExecute(Sender: TObject);
  private
    FPartitionType: TPGSQLPartitionType;
    procedure RefreshPage;
    //procedure LoadSpr;
    procedure UpdateSectionsGrid(APartitionType:TPGSQLPartitionType);
    procedure InternalAddSectionCreateOrEdit(AIsEdit:Boolean);
    procedure InternalAddSectionEdit;
    procedure AddSection;
    procedure DelSection;
    function GenerateSectionName:string;
    function TableName:string;
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

uses rxdbutils, fbmStrConstUnit, fbmToolsUnit, pgTypes, StrUtils, pg_sql_lines_unit,
  SQLEngineCommonTypesUnit, rxAppUtils, fbmTableEditorFieldsUnit,
  fbmPGTablePartition_EditKeyUnit, fbmPGTablePartition_EditSectionUnit;

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
  if (rxKeys.RecordCount>0) and QuestionBox(sDeletePartitionKey) then
    rxKeys.Delete;
end;

procedure TfbmPGTablePartitionPage.RxDBGrid1DblClick(Sender: TObject);
begin
  keyEdit.Execute;
end;

procedure TfbmPGTablePartitionPage.RxDBGrid2DblClick(Sender: TObject);
begin
  sSectionEdit.Execute;
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

procedure TfbmPGTablePartitionPage.rxSectionAfterPost(DataSet: TDataSet);
var
  P: TPGTablePartition;
begin
  if DBObject.State <> sdboCreate then
  begin
    P:=TPGTable(DBObject).PartitionList.TablePartitionByOID(rxSectionOID.AsInteger);
    if Assigned(P) then
      P.Description:=rxSectionDescription.AsString;
//  UpdateControls;
  end;
end;

procedure TfbmPGTablePartitionPage.SpeedButton2DblClick(Sender: TObject);
begin
  keyEdit.Execute;
end;

procedure TfbmPGTablePartitionPage.sSectionAddExecute(Sender: TObject);
begin
  AddSection;
end;

procedure TfbmPGTablePartitionPage.sSectionEditExecute(Sender: TObject);
begin
  InternalAddSectionCreateOrEdit(true);
end;

procedure TfbmPGTablePartitionPage.sSectionRemoveExecute(Sender: TObject);
begin
  DelSection;
end;

procedure TfbmPGTablePartitionPage.RefreshPage;
var
  P: TPGTablePartition;
  T: TPGTableSpace;
begin
  sSectionEdit.Enabled:=DBObject.State = sdboCreate;

  //LoadSpr;


  Edit1.Visible:=DBObject.State <> sdboCreate;
  ComboBox1.Visible:=DBObject.State = sdboCreate;
  DividerBevel1.Visible:=DBObject.State = sdboCreate;
  RxDBGrid1.Visible:=DBObject.State = sdboCreate;
  keyAdd.Visible:=DBObject.State = sdboCreate;
  keyRemove.Visible:=DBObject.State = sdboCreate;

  if DBObject.State = sdboCreate then
  begin
    if not rxSection.Active then
    begin
      ComboBox1.ItemIndex:=0;
      ComboBox1Change(nil);
      rxSection.Open;
    end
  end
  else
  begin
    rxSection.CloseOpen;
    DividerBevel2.AnchorSideTop.Control:=Edit1;
    Edit1.Text:=TPGTable(DBObject).PartitionedTypeName;
    Label1.AnchorSideBottom.Control:=Edit1;

    UpdateSectionsGrid(TPGTable(DBObject).PartitionedType);

    for P in TPGTable(DBObject).PartitionList do
    begin
      rxSection.Append;
      rxSectionOID.AsInteger:=P.OID;
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
      rxSectionTABLE_SPACE_ID.AsInteger:=P.TableSpaceID;
      rxSectionDescription.AsString:=P.Description;
      rxSectionSchemaID.AsInteger:=P.SchemaID;

      if P.TableSpaceID <> 0 then
      begin
        T:=TSQLEnginePostgre(DBObject.OwnerDB).TableSpaceRoot.TableSpaceByOID(P.TableSpaceID);
        if Assigned(T) then
          rxSectionTABLE_SPACE_NAME.AsString:=T.Caption;
      end;
      rxSection.Post;
    end;
  end;
end;

procedure TfbmPGTablePartitionPage.UpdateSectionsGrid(
  APartitionType: TPGSQLPartitionType);
begin
  FPartitionType:=APartitionType;
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

procedure TfbmPGTablePartitionPage.InternalAddSectionCreateOrEdit(AIsEdit: Boolean);
begin
  fbmPGTablePartition_EditSectionForm:=TfbmPGTablePartition_EditSectionForm.Create(Application);
  fbmPGTablePartition_EditSectionForm.SetEngine(DBObject.OwnerDB as TSQLEnginePostgre, FPartitionType);

  if AIsEdit then
  begin
    fbmPGTablePartition_EditSectionForm.Edit3.Text:=rxSectionNAME.AsString;
    fbmPGTablePartition_EditSectionForm.Edit4.Text:=rxSectionDescription.AsString;
    if rxSectionDEFAULT.AsBoolean then
      fbmPGTablePartition_EditSectionForm.RadioButton1.Checked:=true
    else
    begin
      case FPartitionType of
        ptRange:
          begin
            fbmPGTablePartition_EditSectionForm.Edit1.Text:=rxSectionR_FROM.AsString;
            fbmPGTablePartition_EditSectionForm.Edit2.Text:=rxSectionR_TO.AsString;
          end;
        ptList:
          begin
            fbmPGTablePartition_EditSectionForm.Edit1.Text:=rxSectionR_IN.AsString;
          end;
        //ptHash:FCmdPart.PartitionOfData.PartType:=podtWith;
      end;
    end;

    if rxSectionTABLE_SPACE_NAME.AsString <> '' then
    begin
      fbmPGTablePartition_EditSectionForm.CheckBox1.Checked:=true;
      fbmPGTablePartition_EditSectionForm.ComboBox1.Text:=rxSectionTABLE_SPACE_NAME.AsString;
    end;
  end
  else
  begin
    fbmPGTablePartition_EditSectionForm.Edit3.Text:=GenerateSectionName;
    fbmPGTablePartition_EditSectionForm.Edit4.Text:=
      StringReplace(ConfigValues.ByNameAsString('Template/PostgreSQL/PartitionSectionDesc', DummyPGPartitionSectionDesc), '%TABLE_NAME%', TableName, [rfReplaceAll, rfIgnoreCase]);
  end;

  if fbmPGTablePartition_EditSectionForm.ShowModal = mrOk then
  begin
    rxSection.Append;
    rxSectionNAME.AsString:=fbmPGTablePartition_EditSectionForm.Edit3.Text;
    rxSectionDescription.AsString:=fbmPGTablePartition_EditSectionForm.Edit4.Text;
    if fbmPGTablePartition_EditSectionForm.CheckBox1.Checked then
      rxSectionTABLE_SPACE_NAME.AsString:=fbmPGTablePartition_EditSectionForm.ComboBox1.Text;

    if fbmPGTablePartition_EditSectionForm.RadioButton1.Checked then
      rxSectionDEFAULT.AsBoolean:=true
    else
    case FPartitionType of
      ptRange:
        begin
          rxSectionR_FROM.AsString:=fbmPGTablePartition_EditSectionForm.Edit1.Text;
          rxSectionR_TO.AsString:=fbmPGTablePartition_EditSectionForm.Edit2.Text;
        end;
      ptList:
        begin
          rxSectionR_IN.AsString:=fbmPGTablePartition_EditSectionForm.Edit1.Text;
        end;
      //ptHash:FCmdPart.PartitionOfData.PartType:=podtWith;
    end;

    rxSection.Post;
  end;
  fbmPGTablePartition_EditSectionForm.Free;
end;

procedure TfbmPGTablePartitionPage.InternalAddSectionEdit;
var
  FCmd: TPGSQLCreateTable;
begin
  fbmPGTablePartition_EditSectionForm:=TfbmPGTablePartition_EditSectionForm.Create(Application);
  fbmPGTablePartition_EditSectionForm.SetEngine(DBObject.OwnerDB as TSQLEnginePostgre, FPartitionType);

  fbmPGTablePartition_EditSectionForm.Edit3.Text:=GenerateSectionName;
  fbmPGTablePartition_EditSectionForm.Edit4.Text:=
    StringReplace(ConfigValues.ByNameAsString('Template/PostgreSQL/PartitionSectionDesc', DummyPGPartitionSectionDesc), '%TABLE_NAME%', TableName, [rfReplaceAll, rfIgnoreCase]);

  if fbmPGTablePartition_EditSectionForm.ShowModal = mrOk then
  begin
    FCmd:=TPGSQLCreateTable.Create(nil);
    FCmd.Name:=fbmPGTablePartition_EditSectionForm.Edit3.Text;
    FCmd.SchemaName:=DBObject.SchemaName;
    FCmd.PartitionOfData.PartitionTableName:=DBObject.CaptionFullPatch;
    if fbmPGTablePartition_EditSectionForm.CheckBox1.Checked then
      FCmd.TableSpace:=fbmPGTablePartition_EditSectionForm.ComboBox1.Text;

    if fbmPGTablePartition_EditSectionForm.RadioButton1.Checked then
      FCmd.PartitionOfData.PartType:=podtDefault
    else
    case FPartitionType of
      ptRange:
        begin
          FCmd.PartitionOfData.PartType:=podtFromTo;
          FCmd.PartitionOfData.Params.AddParam(fbmPGTablePartition_EditSectionForm.Edit1.Text);
          FCmd.PartitionOfData.Params.AddParam(fbmPGTablePartition_EditSectionForm.Edit2.Text);
        end;
      ptList:
        begin
          FCmd.PartitionOfData.PartType:=podtIn;
          FCmd.PartitionOfData.Params.AddParam(fbmPGTablePartition_EditSectionForm.Edit1.Text);
        end;
      //ptHash:FCmdPart.PartitionOfData.PartType:=podtWith;
    end;
    try
      ExecSQLScript(FCmd.AsSQL, [sepInTransaction, sepShowCompForm], DBObject.OwnerDB);
    except
      on E:Exception do
        DBObject.OwnerDB.InternalError(E.Message);
    end;
    FCmd.Free;
    DBObject.RefreshObject;
    RefreshPage;
  end;
  fbmPGTablePartition_EditSectionForm.Free;
end;

procedure TfbmPGTablePartitionPage.AddSection;
begin
  if DBObject.State = sdboCreate then
    InternalAddSectionCreateOrEdit(false)
  else
    InternalAddSectionEdit;
end;

procedure TfbmPGTablePartitionPage.DelSection;
var
  FCmd: TPGSQLDropTable;
  FShm: TPGSchema;
begin
  if (rxSection.RecordCount>0) and QuestionBox(sDeleteSctions) then
  begin
    if DBObject.State = sdboCreate then
    begin
      rxSection.Delete;
    end
    else
    begin
      FCmd:=TPGSQLDropTable.Create(nil);
      FCmd.Name:=rxSectionNAME.AsString;

      FShm:=TSQLEnginePostgre(DBObject.OwnerDB).SchemasRoot.SchemaByOID(rxSectionSchemaID.AsInteger);
      if Assigned(FShm) then
        FCmd.SchemaName:=FShm.Caption;

      try
        ExecSQLScript(FCmd.AsSQL, [sepInTransaction, sepShowCompForm], DBObject.OwnerDB);
      except
        on E:Exception do
          DBObject.OwnerDB.InternalError(E.Message);
      end;
      FCmd.Free;
      DBObject.RefreshObject;
      RefreshPage;
    end;
  end;
end;

function TfbmPGTablePartitionPage.GenerateSectionName: string;
function DoFind(AName:string):boolean;
var
  i: Integer;
  P: TPGTablePartition;
  T: TDBObject;
begin
  AName:=UpperCase(AName);
  Result:=rxSection.Locate('NAME', AName, [loCaseInsensitive]);
  if not Result then
  begin
    for i:=0 to DBObject.OwnerRoot.CountObject-1 do
    begin
      T:=DBObject.OwnerRoot[i];
      Result:=AName = UpperCase(T.Caption);
      if Result then Exit;

      for P in TPGTable(T).PartitionList do
      begin
        if AName = UpperCase(P.Name) then
          Exit(true);
      end;
    end;
  end;
end;

var
  I: Integer;
  S1, S: String;
begin
  I:=0;
  S1:=StringReplace(ConfigValues.ByNameAsString('Template/PostgreSQL/PartitionSectionName', DummyPGPartitionSectionName), '%TABLE_NAME%', TableName, [rfReplaceAll, rfIgnoreCase]);
  repeat
    Inc(i);
    S:=StringReplace(S1, '%COUNT%', IntToStr(i), [rfReplaceAll, rfIgnoreCase]);
  until not DoFind(S);
  Result:=S;
end;

function TfbmPGTablePartitionPage.TableName: string;
var
  F: TfbmTableEditorFieldsFrame;
begin
  if DBObject.State = sdboEdit then
    Result:=DBObject.Caption
  else
  begin
    F:=FindPageByClass(TfbmTableEditorFieldsFrame) as TfbmTableEditorFieldsFrame;
    if Assigned(F) then
    begin
      Result:=F.edtTableName.Text;
      //if DBObject.SchemaName<>'' then Result:=DBObject.SchemaName+'.';
      //Result:=Result + F.edtTableName.Text;
    end
    else
    Result:='';
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
  Result:=false;
  case PageAction of
    epaAdd:AddSection;
    epaEdit:InternalAddSectionCreateOrEdit(true);
    epaDelete:DelSection;
    epaRefresh:RefreshPage;
//    epaPrint
//    epaCompile
  else
    Result:=inherited DoMetod(PageAction);
  end;
end;

procedure TfbmPGTablePartitionPage.Activate;
begin
  inherited Activate;
  RefreshPage;
end;

function TfbmPGTablePartitionPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  if PageAction = epaEdit then
    Result:=DBObject.State <> sdboEdit
  else
    Result:=PageAction in [epaAdd, epaDelete, epaRefresh, epaPrint, epaCompile];
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
  RxDBGrid2.ColumnByFieldName('TABLE_SPACE_NAME').Title.Caption:=sTableSpace;

//  RxDBGrid2.ColumnByFieldName('H_MODULUS').Title.Caption:=ComboBox1.ItemIndex = 3;
//  RxDBGrid2.ColumnByFieldName('H_REMINDER').Title.Caption:=ComboBox1.ItemIndex = 3;

  ComboBox1.Items[0]:=sNone;
  ComboBox1.Items[1]:=sRange;
  ComboBox1.Items[2]:=sList;
  keyAdd.Caption:=sAdd;
  keyRemove.Caption:=sRemove;
  keyEdit.Caption:=sEdit;

  sSectionAdd.Caption:=sAdd;
  sSectionRemove.Caption:=sRemove;
  sSectionEdit.Caption:=sEdit;
end;

function TfbmPGTablePartitionPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FCmd, FCmdPart: TPGSQLCreateTable;
begin
  Result:=true;
  if DBObject.State = sdboCreate then
  begin

    FCmd:=TPGSQLCreateTable(ASQLObject);
    if ComboBox1.ItemIndex > 0 then
    begin
      rxKeys.DisableControls;
      rxSection.DisableControls;
      rxKeys.First;

      while not rxKeys.EOF do
      begin
        FCmd.TablePartition.Params.AddParam(rxKeysExpression.AsString);
        rxKeys.Next;
      end;
      rxKeys.First;

      case ComboBox1.ItemIndex of
        1:FCmd.TablePartition.PartitionType:=ptRange;
        2:FCmd.TablePartition.PartitionType:=ptList;
        3:FCmd.TablePartition.PartitionType:=ptHash;
      end;
    end;

    rxSection.First;
    while not rxSection.EOF do
    begin
      FCmdPart:=TPGSQLCreateTable.Create(FCmd);
      FCmd.AddChild(FCmdPart);
      FCmdPart.Name:=rxSectionNAME.AsString;
      FCmdPart.Description:=rxSectionDescription.AsString;
      FCmdPart.SchemaName:=FCmd.SchemaName;
      FCmdPart.PartitionOfData.PartitionTableName:=FCmd.FullName;
      if rxSectionDEFAULT.AsBoolean then
        FCmdPart.PartitionOfData.PartType:=podtDefault
      else
      case FPartitionType of
        ptRange:
          begin
            FCmdPart.PartitionOfData.PartType:=podtFromTo;
            FCmdPart.PartitionOfData.Params.AddParam(rxSectionR_FROM.AsString);
            FCmdPart.PartitionOfData.Params.AddParam(rxSectionR_TO.AsString);
          end;
        ptList:
          begin
            FCmdPart.PartitionOfData.PartType:=podtIn;
            FCmdPart.PartitionOfData.Params.AddParam(rxSectionR_IN.AsString);
          end;
        ptHash:FCmdPart.PartitionOfData.PartType:=podtWith;
      end;

      rxSection.Next;
    end;
    rxSection.First;

    rxSection.EnableControls;
    rxKeys.EnableControls;
  end;
end;

end.

