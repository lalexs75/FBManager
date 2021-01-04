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

unit pgForeignDW;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit, fbmToolsUnit,
  sqlObjects, ZDataset;

type

  { TpgForeignDataWrap }

  TpgForeignDataWrap = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    cbOwner: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CLabel: TLabel;
    Label5: TLabel;
    ValueListEditor1: TValueListEditor;
    quHandlers: TZReadOnlyQuery;
    quValidators: TZReadOnlyQuery;
  private
    procedure RefreshObject;
    procedure FillDictionary;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, PostgreSQLEngineUnit, pgSqlEngineSecurityUnit, pgSQLEngineFDW, pg_SqlParserUnit, rxdbutils;

{$R *.lfm}

{ TpgForeignDataWrap }

procedure TpgForeignDataWrap.RefreshObject;
begin
  FillDictionary;
  if DBObject.State = sdboEdit then
  begin
    Edit1.Text:=DBObject.Caption;
    ComboBox1.Text:=TPGForeignDataWrapper(DBObject).Handler;
    ComboBox2.Text:=TPGForeignDataWrapper(DBObject).Validator;
    cbOwner.Text:=TPGForeignDataWrapper(DBObject).Owner;
  end;
end;

procedure TpgForeignDataWrap.FillDictionary;
var
  FSQLE: TSQLEnginePostgre;
begin
  ComboBox1.Items.Clear;
  quHandlers.Open;
  FieldValueToStrings(quHandlers, 'handler_name', ComboBox1.Items);
  quHandlers.Close;

  ComboBox2.Items.Clear;
  quValidators.Open;
  FieldValueToStrings(quValidators, 'validate_name', ComboBox2.Items);
  quValidators.Close;


  FSQLE:=TSQLEnginePostgre(DBObject.OwnerDB);
  cbOwner.Items.Clear;
  TPGSecurityRoot(FSQLE.SecurityRoot).PGUsersRoot.FillListForNames(cbOwner.Items, true);

end;

function TpgForeignDataWrap.PageName: string;
begin
  Result:=sForeignDataWrapper;
end;

constructor TpgForeignDataWrap.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  Edit1.Enabled:=DBObject.State = sdboCreate;
  quValidators.Connection:=TSQLEnginePostgre(ADBObject.OwnerDB).PGConnection;
  quHandlers.Connection:=TSQLEnginePostgre(ADBObject.OwnerDB).PGConnection;
  RefreshObject;
end;

function TpgForeignDataWrap.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited ActionEnabled(PageAction);
end;

function TpgForeignDataWrap.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

procedure TpgForeignDataWrap.Localize;
begin
  Label1.Caption:=sHandlerFunction;
  Label2.Caption:=sValidatorFunction;
  Label3.Caption:=sOptions;
  Label4.Caption:=sOwner;
  CheckBox1.Caption:=sNoHandler;
  CheckBox2.Caption:=sNoValidator;
  Label5.Caption:=sForeignDataWrapperName;

  ValueListEditor1.TitleCaptions.Clear;
  ValueListEditor1.TitleCaptions.Add(sParamName);
  ValueListEditor1.TitleCaptions.Add(sValue);
end;

function TpgForeignDataWrap.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  if ASQLObject is TPGSQLCreateForeignDataWrapper then
  begin
    ASQLObject.Name:=Edit1.Text;
    TPGSQLCreateForeignDataWrapper(ASQLObject).Handler:=ComboBox1.Text;
    TPGSQLCreateForeignDataWrapper(ASQLObject).Validator:=ComboBox2.Text;
    TPGSQLCreateForeignDataWrapper(ASQLObject).NoHandler:=CheckBox1.Checked;
    TPGSQLCreateForeignDataWrapper(ASQLObject).NoValidator:=CheckBox2.Checked;
  end
  else
    Result:=false;
end;

end.

