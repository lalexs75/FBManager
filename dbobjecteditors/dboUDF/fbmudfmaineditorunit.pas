{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmUDFMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, StdCtrls, rxmemds,
  rxdbgrid, LR_DBSet, fdmAbstractEditorUnit, SQLEngineAbstractUnit,
  FBSQLEngineUnit;

type

  { TfbmUDFMainEditorFrame }

  TfbmUDFMainEditorFrame = class(TEditorPage)
    cbFreeIt: TCheckBox;
    cbReturnValue: TComboBox;
    cbReturnMetod: TComboBox;
    dsInputValues: TDatasource;
    edtUdfName: TEdit;
    edtLibName: TEdit;
    edtEntryName: TEdit;
    frInputValues: TfrDBDataSet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RxDBGrid1: TRxDBGrid;
    rxInputValues: TRxMemoryData;
    rxInputValuesINPUT_VALUE: TStringField;
  private
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure PrintPage;
    procedure LoadUdf;
    function CompileUDF:boolean;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
  end;

implementation
uses fbmStrConstUnit, LR_Class, IBManMainUnit, fb_utils;


{$R *.lfm}
{ TfbmUDFMainEditorFrame }

function TfbmUDFMainEditorFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:LoadUdf;
    epaCompile:Result:=CompileUDF;
  end;
end;

function TfbmUDFMainEditorFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaRefresh, epaCompile];
end;

procedure TfbmUDFMainEditorFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=edtUdfName.Text;
  fbManagerMainForm.LazReportPrint('DBObject_UDF');
end;

procedure TfbmUDFMainEditorFrame.LoadUdf;
var
  i:integer;
  Rec:TUDFParamsRecord;
begin
  rxInputValues.CloseOpen;
  Label1.Enabled:=DBObject.State = sdboCreate;
  edtUdfName.Enabled:=DBObject.State = sdboCreate;

  edtUdfName.Text:=DBObject.Caption;
  edtLibName.Text:=TFireBirdUDF(DBObject).LibName;
  edtEntryName.Text:=TFireBirdUDF(DBObject).EntryPoint;

  Rec:=TFireBirdUDF(DBObject).UDFParamByPosition(TFireBirdUDF(DBObject).ReturnArg);
  { TODO : Проверить правильность подстановки типа данных  }
//  cbReturnValue.Text:=FB_SqlTypesToString(Rec.FieldType, 0);

  cbFreeIt.Checked:=Rec.Mechanism = -1;

  case Rec.Mechanism of
    -1:cbReturnMetod.ItemIndex:=1;
    0:cbReturnMetod.ItemIndex:=0;
    2:cbReturnMetod.ItemIndex:=2;
  end;
{By Value
By Reference
By Descriptor}


  for i:=0 to TFireBirdUDF(DBObject).UDFParamCount-1 do
  begin
    Rec:=TFireBirdUDF(DBObject).UDFParams[i];
    if Rec.ArgPosition <> 0 then
    begin
      rxInputValues.Append;
  { TODO : Проверить правильность подстановки типа данных  }
//      rxInputValuesINPUT_VALUE.AsString:=FB_SqlTypesToString(Rec.FieldType, 0);
      rxInputValues.Post;
    end;
  end;
end;

function TfbmUDFMainEditorFrame.CompileUDF: boolean;
begin
  { TODO : Необходимо реализовать компиляцию UDF для FireBird }
  Result:=TFireBirdUDF(DBObject).CompileUDF(edtUdfName.Text,
                     edtLibName.Text,
                     edtEntryName.Text,
                     cbReturnValue.ItemIndex,
                     cbReturnMetod.ItemIndex
                     );
end;

function TfbmUDFMainEditorFrame.PageName: string;
begin
  Result:=sUDF;
end;

constructor TfbmUDFMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  DBObject.OwnerDB.FillStdTypesList(cbReturnValue.Items);
  DBObject.OwnerDB.FillStdTypesList(RxDBGrid1.Columns[0].PickList);
//  FillFieldTypeStr(cbReturnValue.Items);
//  FillFieldTypeStr(RxDBGrid1.Columns[0].PickList);
  FillUdfReturnStr(cbReturnMetod.Items);

  LoadUdf;
end;

end.

