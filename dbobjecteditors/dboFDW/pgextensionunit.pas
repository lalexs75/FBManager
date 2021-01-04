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

unit pgExtensionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, PostgreSQLEngineUnit,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit, ZDataset, sqlObjects;

type

  { TpgExtensionEditor }

  TpgExtensionEditor = class(TEditorPage)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    quAvailExt: TZReadOnlyQuery;
    quExtVers: TZReadOnlyQuery;
    procedure ComboBox1Change(Sender: TObject);
  private
    function RefreshData:boolean;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxdbutils, pg_SqlParserUnit;

{$R *.lfm}

{ TpgExtensionEditor }

procedure TpgExtensionEditor.ComboBox1Change(Sender: TObject);
begin
  ComboBox3.Items.Clear;
  quExtVers.ParamByName('name').AsString:=ComboBox1.Text;
  quExtVers.Open;
  FieldValueToStrings(quExtVers, 'version',ComboBox3.Items);
  quExtVers.Close;
end;

function TpgExtensionEditor.RefreshData: boolean;
begin
  Result:=true;

  ComboBox1.Items.Clear;

  quAvailExt.Open;
  FieldValueToStrings(quAvailExt, 'name',ComboBox1.Items);
  quAvailExt.Close;

  ComboBox2.Items.Clear;
  DBObject.OwnerDB.FillListForNames(ComboBox2.Items, [okScheme]);

  if DBObject.State = sdboEdit then
  begin
    ComboBox1.Enabled:=false;
    ComboBox1.Text:=DBObject.Caption;
    ComboBox1Change(nil);

    ComboBox2.Text:=TPGExtension(DBObject).SchemaName;

    ComboBox3.Text:=TPGExtension(DBObject).Version;
  end;
end;

function TpgExtensionEditor.PageName: string;
begin
  Result:='Extension';
end;

constructor TpgExtensionEditor.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  quAvailExt.Connection:= TSQLEnginePostgre(ADBObject.OwnerDB).PGConnection;
  quExtVers.Connection:= TSQLEnginePostgre(ADBObject.OwnerDB).PGConnection;

  RefreshData;
end;

function TpgExtensionEditor.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaCompile];
end;

function TpgExtensionEditor.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  case PageAction of
    epaRefresh:Result:=RefreshData;
  else
    Result:=inherited DoMetod(PageAction);
  end;
end;

procedure TpgExtensionEditor.Localize;
begin
  inherited Localize;
end;

function TpgExtensionEditor.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  Result:=false;
  if ASQLObject is TPGSQLCreateExtension then
  begin
    ASQLObject.Name:=ComboBox1.Text;
    TPGSQLCreateExtension(ASQLObject).SchemaName:=ComboBox2.Text;
    if ComboBox3.Text<>'' then
      TPGSQLCreateExtension(ASQLObject).Version:='"' + ComboBox3.Text + '"';
    Result:=true;
  end;
end;

end.

