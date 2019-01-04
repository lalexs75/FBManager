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

unit fbmMySQLTablePropsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SQLEngineAbstractUnit, fdmAbstractEditorUnit, mysql_engine;

type

  { TfbmMySQLTablePropsFrame }

  TfbmMySQLTablePropsFrame = class(TEditorPage)
    CheckBox1: TCheckBox;
    cbEngineName: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    //FDBDataSetObject:TMySQLTable;
  protected
    procedure RefreshObject;
    function Compile:boolean;
    procedure UpdateControls;
  public
    procedure Localize;override;
    function PageName:string;override;
{    function ImageName:string;override;
    procedure Activate;override;}
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
{    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;}
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmMySQLTablePropsFrame }

procedure TfbmMySQLTablePropsFrame.RefreshObject;
begin
  cbEngineName.Text:=TMySQLTable(DBObject).Engine;
end;

function TfbmMySQLTablePropsFrame.Compile: boolean;
begin
  Result:=true;
  if DBObject.State <> sdboCreate then
  begin
{    if rxFieldList.State = dsEdit then
       rxFieldList.Post;}
  end
  else
    TMySQLTable(DBObject).Engine:=cbEngineName.Text;
end;

procedure TfbmMySQLTablePropsFrame.UpdateControls;
begin

end;

procedure TfbmMySQLTablePropsFrame.Localize;
begin
  inherited Localize;
end;

function TfbmMySQLTablePropsFrame.PageName: string;
begin
  Result:=sProperty;
end;

function TfbmMySQLTablePropsFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
{    epaAdd:fldNew.Execute;
    epaEdit:fldEdit.Execute;
    epaDelete:fldDelete.Execute;}
    epaRefresh:RefreshObject;
//    epaPrint:fldPrint.Execute;
    epaCompile:Result:=Compile;
  end;
end;

constructor TfbmMySQLTablePropsFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  UpdateControls;
  RefreshObject;
end;

end.

