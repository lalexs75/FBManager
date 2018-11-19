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

unit fbmDomainMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls, Spin, ComCtrls,
  SynEdit, LMessages, ExtCtrls, fdmAbstractEditorUnit, SQLEngineAbstractUnit,
  fbmSqlParserUnit, fbmToolsUnit, sqlObjects;

type

  { TfbmDomainMainEditorFrame }

  TfbmDomainMainEditorFrame = class(TEditorPage)
    cbNotNull: TCheckBox;
    CheckBox2: TCheckBox;
    cbDomainType: TComboBox;
    cbCharSets: TComboBox;
    cbCollations: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    edtDomainName: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtTypeDesc: TMemo;
    PageControl1: TPageControl;
    edtSize: TSpinEdit;
    edtScale: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    edtDefaultValue: TSynEdit;
    edtCheck: TSynEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    procedure cbCharSetsChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure ChangeVisualParams;
    procedure PrintPage;
    procedure LoadDomainHeader;
    procedure LoadStdTypes;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, LR_Class, IBManMainUnit, fb_utils,
  SQLEngineCommonTypesUnit, fb_CharSetUtils;

{$R *.lfm}

{ TfbmDomainMainEditorFrame }

procedure TfbmDomainMainEditorFrame.ComboBox1Change(Sender: TObject);
var
  P:TDBMSFieldTypeRecord;
begin
  if (cbDomainType.ItemIndex<0) or (cbDomainType.ItemIndex>=DBObject.OwnerDB.TypeList.Count) then
    exit;
  P:=DBObject.OwnerDB.TypeList[cbDomainType.ItemIndex];
  edtTypeDesc.Text:=P.Description; //Type description

  //Collation and charset for domain
  cbCharSets.Visible:=P.DBType in dbFieldTypesCharacter;
  Label5.Visible:=cbCharSets.Visible;
  cbCollations.Visible:=cbCharSets.Visible;
  Label6.Visible:=cbCharSets.Visible;

  edtSize.Visible:=P.VarLen;
  Label3.Visible:=P.VarLen;

  edtScale.Visible:=P.VarDec;
  Label4.Visible:=P.VarDec;

  if P.VarLen then
  begin
    { TODO : Необходимо ввести константы максимальной длинны и макс. длинно дробной части }
    if P.DBType in dbFieldTypesCharacter then
      edtSize.MaxValue:=65535
    else
      edtSize.MaxValue:=20;
  end;
end;

procedure TfbmDomainMainEditorFrame.cbCharSetsChange(Sender: TObject);
(*var
  Rec:TCharSetItem; *)
begin
  cbCollations.Items.Clear;
  { TODO : Для серверов, поддерживающих кодировки текста - надо переделать }
{  if cbCharSets.ItemIndex>=0 then
  begin
    Rec:=TSQLEngineFireBird(FDBObject.OwnerDB).CharSetList.CharSet[cbCharSets.ItemIndex];
    if Assigned(Rec) then
      Rec.FillCollationStrings(cbCollations.Items);
  end;}
end;

procedure TfbmDomainMainEditorFrame.LMEditorChangeParams(
  var message: TLMNoParams);
begin
  inherited;
  ChangeVisualParams;
end;

procedure TfbmDomainMainEditorFrame.ChangeVisualParams;
begin
  SetEditorOptions(edtDefaultValue);
  SetEditorOptions(edtCheck);
end;

procedure TfbmDomainMainEditorFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtDomainName.Text;
  frVariables['DefaultValue']:=edtDefaultValue.Text;
  fbManagerMainForm.LazReportPrint('DBObject_Domain');
end;

procedure TfbmDomainMainEditorFrame.LoadDomainHeader;
begin
  if not DBObject.Loaded then
    DBObject.RefreshObject;

  edtDomainName.Enabled:=DBObject.State = sdboCreate;
  Label1.Enabled:=DBObject.State = sdboCreate;

{
  if FDBObject.State = sdboCreate then
    cbCharSets.ItemIndex:=TSQLEngineFireBird(FDBObject.OwnerDB).CharSetList.FindItemByName(TSQLEngineFireBird(FDBObject.OwnerDB).CharSet)
  else
    cbCharSets.ItemIndex:=TSQLEngineFireBird(FDBObject.OwnerDB).CharSetList.FindItemByCSID(FDBObject.CharSetID);
}
  edtDomainName.Text:=DBObject.Caption;
  cbNotNull.Checked:=TDBDomain(DBObject).NotNull;

  if Assigned(TDBDomain(DBObject).FieldType) then
    cbDomainType.Text:=TDBDomain(DBObject).FieldType.TypeName;

  edtSize.Value:=TDBDomain(DBObject).FieldLength;
  edtScale.Value:=TDBDomain(DBObject).FieldDecimal;

  edtDefaultValue.Text:=TDBDomain(DBObject).DefaultValue;
  edtCheck.Text:=TDBDomain(DBObject).CheckExpression;

  ComboBox1Change(nil);
  cbCharSetsChange(nil);
end;

procedure TfbmDomainMainEditorFrame.LoadStdTypes;
var
  i:integer;
  P:TDBMSFieldTypeRecord;
begin
  cbDomainType.Items.Clear;
  for i:=0 to DBObject.OwnerDB.TypeList.Count - 1 do
  begin
    P:=DBObject.OwnerDB.TypeList[i];
    cbDomainType.Items.Add(P.TypeName);
  end;
end;

function TfbmDomainMainEditorFrame.PageName: string;
begin
  Result:=sDomain;
end;

constructor TfbmDomainMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadStdTypes;
  { TODO : Необходимо переделять для общего случая }
  //FillFieldTypeStr(cbDomainType.Items);
  //TSQLEngineFireBird(FDBObject.OwnerDB).CharSetList.FillCSStrings(cbCharSets.Items);

  ChangeVisualParams;
  LoadDomainHeader;
end;

function TfbmDomainMainEditorFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaCompile, epaPrint, epaRefresh];
end;

function TfbmDomainMainEditorFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:if DBObject.State<>sdboCreate then
                 LoadDomainHeader;
  end;
end;

procedure TfbmDomainMainEditorFrame.Localize;
begin
  Label1.Caption:=sDomainName;//
  Label2.Caption:=sType;//
  cbNotNull.Caption:=sNotNull;
  Label3.Caption:=sSize;//
  Label4.Caption:=sScale;//
  Label5.Caption:=sCharSet;
  Label6.Caption:=sCollate;
  TabSheet4.Caption:=sDefault;
  TabSheet5.Caption:=sCheck;
  TabSheet6.Caption:=sArray;
end;

function TfbmDomainMainEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  D: TSQLCreateDomain;
  P: TDBMSFieldTypeRecord;
  DA: TSQLAlterDomain;
begin
  Result:=false;

  if (DBObject.State = sdboCreate) and (ASQLObject is TSQLCreateDomain) then
  begin
    D:=TSQLCreateDomain(ASQLObject);
    D.Name:=edtDomainName.Text;
    D.DomainType:=cbDomainType.Text;
    D.CheckExpression:=TrimRight(edtCheck.Text);
    D.NotNull:=cbNotNull.Checked;
    P:=DBObject.OwnerDB.TypeList.FindType(cbDomainType.Text);
    if Assigned(P) then
    begin
      if P.VarLen then
      begin
        D.TypeLen:=edtSize.Value;
        if P.VarDec then
          D.TypePrec:=edtScale.Value;
      end;
    end;
    D.DefaultValue:=TrimRight(edtDefaultValue.Text);
    Result:=true;
  end
  else
  if (DBObject.State = sdboEdit) and (ASQLObject is TSQLAlterDomain) then
  begin
    DA:=TSQLAlterDomain(ASQLObject);
    if edtDomainName.Text<>DBObject.Caption then
      DA.Operators.AddItem(adaRenameDomain, edtDomainName.Text);

    if cbNotNull.Checked <> TDBDomain(DBObject).NotNull then
    begin
      if cbNotNull.Checked then
        DA.Operators.AddItem(adaSetNotNull)
      else
        DA.Operators.AddItem(adaDropNotNull)
    end;

    if TrimRight(edtDefaultValue.Text) <> TDBDomain(DBObject).DefaultValue then
    begin
      if TrimRight(edtDefaultValue.Text) = '' then
        DA.Operators.AddItem(adaDropDefault)
      else
        DA.Operators.AddItem(adaSetDefault, TrimRight(edtDefaultValue.Text));
    end;

    if TrimRight(edtCheck.Text) <> TDBDomain(DBObject).CheckExpression then
    begin
      if TrimRight(edtCheck.Text) = '' then
        DA.Operators.AddItem(adaDropCheckExpression)
      else
        DA.Operators.AddItem(adaSetCheckExpression, TrimRight(edtCheck.Text));
    end;

    {

    D.DomainType:=cbDomainType.Text;
    P:=DBObject.OwnerDB.TypeList.FindType(cbDomainType.Text);
    if Assigned(P) then
    begin
      if P.VarLen then
      begin
        D.TypeLen:=edtSize.Value;
        if P.VarDec then
          D.TypePrec:=edtScale.Value;
      end;
    end;
    }
    Result:=true;
  end
  else
    raise Exception.Create('TfbmDomainMainEditorFrame.SetupSQLObject');
end;

end.

