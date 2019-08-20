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
  ActnList, Menus, DB, rxdbgrid, rxmemds, DividerBevel, fdmAbstractEditorUnit,
  fbmSqlParserUnit, SQLEngineAbstractUnit, PostgreSQLEngineUnit;

type

  { TfbmPGTablePartitionPage }

  TfbmPGTablePartitionPage = class(TEditorPage)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    rxKeysExpression: TStringField;
    rxKeysFieldName: TStringField;
    rxKeysKeyType: TLongintField;
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
    StaticText1: TStaticText;
    StaticText2: TStaticText;
  private
    procedure RefreshPage;
    procedure LoadSpr;
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

uses rxdbutils, fbmStrConstUnit, pgTypes, fbmTableEditorFieldsUnit;

{$R *.lfm}

{ TfbmPGTablePartitionPage }

procedure TfbmPGTablePartitionPage.RefreshPage;
begin
  LoadSpr;

  RxDBGrid1.Enabled:=DBObject.State = sdboCreate;
  keyAdd.Enabled:=DBObject.State = sdboCreate;
  keyRemove.Enabled:=DBObject.State = sdboCreate;
  Label1.Enabled:=DBObject.State = sdboCreate;
  ComboBox1.Enabled:=DBObject.State = sdboCreate;
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

class function TfbmPGTablePartitionPage.PageExists(ADBObject: TDBObject
  ): Boolean;
begin
  Result:=Assigned(ADBObject) and (ADBObject.OwnerDB is TSQLEnginePostgre) and (TSQLEnginePostgre(ADBObject.OwnerDB).ServerVersion >= pgVersion10_0);
end;

function TfbmPGTablePartitionPage.PageName: string;
begin
  Result:=sPartition;
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
  Result:=inherited ActionEnabled(PageAction);
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

//  StaticText1.Caption:=;

  ComboBox1.Items[0]:=sList;
  ComboBox1.Items[1]:=sRange;
  keyAdd.Caption:=sAdd;
  keyRemove.Caption:=sRemove;

  sSectionAdd.Caption:=sAdd;
  sSectionRemove.Caption:=sRemove;
end;

function TfbmPGTablePartitionPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=true;
end;

end.

