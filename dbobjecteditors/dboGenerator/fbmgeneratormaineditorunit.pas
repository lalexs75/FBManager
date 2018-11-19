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

unit fbmGeneratorMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Buttons, StdCtrls, Spin,
  fdmAbstractEditorUnit, sqlObjects, SQLEngineAbstractUnit, fbmSqlParserUnit,
  FBSQLEngineUnit;

type

  { TfbmGeneratorMainEditorFrame }

  TfbmGeneratorMainEditorFrame = class(TEditorPage)
    edtGeneratorName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtGeneratorValue: TSpinEdit;
  private
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure LoadGenerator;
    procedure PrintPage;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, LR_Class, IBManMainUnit, fb_SqlParserUnit;

{$R *.lfm}

{ TfbmGeneratorMainEditorFrame }

function TfbmGeneratorMainEditorFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:begin
                 DBObject.RefreshObject;
                 LoadGenerator;
               end;
  else
    exit;
  end;
end;

function TfbmGeneratorMainEditorFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaCompile, epaRefresh, epaPrint];
end;

procedure TfbmGeneratorMainEditorFrame.LoadGenerator;
begin
  Label1.Enabled:=DBObject.State = sdboCreate;
  edtGeneratorName.Enabled:=DBObject.State = sdboCreate;

  edtGeneratorName.Text:=DBObject.Caption;
  edtGeneratorValue.Value:=TFireBirdGenerator(DBObject).GeneratorValue;
end;

procedure TfbmGeneratorMainEditorFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtGeneratorName.Text;
  frVariables['GeneratorValue']:=edtGeneratorValue.Value;
  fbManagerMainForm.LazReportPrint('DBObject_Generator');
end;

function TfbmGeneratorMainEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=false;
  ASqlObject.Name:=edtGeneratorName.Text;
  if (ASqlObject is TFBSQLCreateGenerator) then
  begin
    TFBSQLCreateGenerator(ASqlObject).CurrentValue:=edtGeneratorValue.Value;
    Result:=true;
  end
  else
    raise Exception.Create('TfbmGeneratorMainEditorFrame.SetupSQLObject');
end;

function TfbmGeneratorMainEditorFrame.PageName: string;
begin
  Result:=sGenerator;
end;

constructor TfbmGeneratorMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  edtGeneratorValue.MaxValue:=High(edtGeneratorValue.MaxValue);
  LoadGenerator;
end;

procedure TfbmGeneratorMainEditorFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sGeneratorName;
  Label2.Caption:=sGeneratorValue;
end;

end.

