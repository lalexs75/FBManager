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

unit fbmFTSConfigUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, fbmSqlParserUnit,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, PostgreSQLEngineUnit, sqlObjects;

type

  { TfbmFTSConfigEditorPage }

  TfbmFTSConfigEditorPage = class(TEditorPage)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure RadioButton1Change(Sender: TObject);
  private
    procedure FillFrame;
  public
    function PageName:string;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
{    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;}
    procedure Localize;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

uses fbmStrConstUnit, pg_SqlParserUnit, pgSQLEngineFTS;

{$R *.lfm}

{ TfbmFTSConfigEditorPage }

procedure TfbmFTSConfigEditorPage.RadioButton1Change(Sender: TObject);
begin
  ComboBox1.Enabled:=RadioButton1.Checked;
  ComboBox2.Enabled:=RadioButton2.Checked;
end;

procedure TfbmFTSConfigEditorPage.FillFrame;
begin
  ComboBox1.Items.Clear;
  TPGFTSConfigurations(DBObject).FillParsersList(ComboBox1.Items);
  DBObject.OwnerDB.FillListForNames(ComboBox2.Items, [okFTSConfig]);

  if DBObject.State <> sdboCreate then
    Edit1.Text:=DBObject.Caption;
end;

function TfbmFTSConfigEditorPage.PageName: string;
begin
  Result:=sProperty;
end;

function TfbmFTSConfigEditorPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

function TfbmFTSConfigEditorPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  if PageAction = epaCompile then
    Result:=true
  else
  if (PageAction = epaRefresh) then
    Result:=DBObject.State = sdboEdit
  else
    Result:=inherited DoMetod(PageAction);
end;

procedure TfbmFTSConfigEditorPage.Localize;
begin
  inherited Localize;
end;

constructor TfbmFTSConfigEditorPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  FillFrame;
  if DBObject.State = sdboEdit then
  begin
    ComboBox1.Text:=(DBObject as TPGFTSConfigurations).ParserName;
  end;
  RadioButton1Change(nil);
end;

function TfbmFTSConfigEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=false;
  if ASQLObject is TPGSQLCreateTextSearchConfig then
  begin
    ASQLObject.Name:=Edit1.Text;
    if RadioButton1.Checked then
      TPGSQLCreateTextSearchConfig(ASQLObject).Params.AddParamEx('PARSER', ComboBox1.Text)
    else
    if RadioButton2.Checked then
      TPGSQLCreateTextSearchConfig(ASQLObject).Params.AddParamEx('COPY', ComboBox2.Text)
    else
      Exit;
    //PARSER = parser_name |
    //COPY = source_config

    Result:=true;
  end;
end;

end.

