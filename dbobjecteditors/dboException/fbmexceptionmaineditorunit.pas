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

unit fbmExceptionMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, StdCtrls,
  fdmAbstractEditorUnit, sqlObjects, SQLEngineAbstractUnit, fbmSqlParserUnit,
  FBSQLEngineUnit;

type

  { TfbmExceptionMainEditorFrame }

  TfbmExceptionMainEditorFrame = class(TEditorPage)
    edtExceptionName: TEdit;
    edtExceptionText: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    procedure LoadExceptionHeader;
    procedure PrintPage;
  public
    procedure Activate;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, LR_Class, IBManMainUnit, fb_SqlParserUnit;

{$R *.lfm}

{ TfbmExceptionMainEditorFrame }

function TfbmExceptionMainEditorFrame.PageName: string;
begin
  Result:=sException;
end;

procedure TfbmExceptionMainEditorFrame.LoadExceptionHeader;
begin
  edtExceptionName.Enabled:=DBObject.State = sdboCreate;
  Label1.Enabled:=DBObject.State = sdboCreate;

  edtExceptionName.Text:=DBObject.Caption;
  edtExceptionText.Text:=TFireBirdException(DBObject).ExceptionMsg;
end;

function TfbmExceptionMainEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=true;
  if (ASQLObject is TFBSQLCreateException) then
  begin
    TFBSQLCreateException(ASQLObject).Name:=edtExceptionName.Text;
    TFBSQLCreateException(ASQLObject).Message:=edtExceptionText.Text;
  end
  else
  begin
    Result:=false;
    raise Exception.Create('TfbmExceptionMainEditorFrame.SetupSQLObject');
  end;
end;

procedure TfbmExceptionMainEditorFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtExceptionName.Text;
  frVariables['ExceptionMsg']:=edtExceptionText.Text;
  fbManagerMainForm.LazReportPrint('DBObject_Exception');
end;

procedure TfbmExceptionMainEditorFrame.Activate;
begin
//  LoadExceptionHeader;
end;

function TfbmExceptionMainEditorFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:LoadExceptionHeader
  end;
end;

function TfbmExceptionMainEditorFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result:=PageAction in [epaPrint, epaCompile, epaRefresh];
end;

constructor TfbmExceptionMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadExceptionHeader;
end;

procedure TfbmExceptionMainEditorFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sExceptionName;
  Label2.Caption:=sExceptionMessage;
end;

end.

