{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmSQLParamValueEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, rxtooledit, Forms, Controls, StdCtrls, Spin, DB;

type

  { TfbmSQLParamValueEditorFrame }

  TfbmSQLParamValueEditorFrame = class(TFrame)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    lblParamName: TLabel;
    RxDateEdit1: TRxDateEdit;
    SpinEdit1: TSpinEdit;
    procedure CheckBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    function GetDataType: integer;
    function GetIsNull: boolean;
    function GetParamName: string;
    function GetTextValue: string;
    procedure SetDataType(AValue: integer);
    procedure SetParamName(AValue: string);
    procedure SetTextValue(AValue: string);
    { private declarations }
  public
    constructor Create(TheOwner: TComponent); override;
    procedure SetParam(AParam:TParam);
    procedure GetParam(AParam:TParam);
    property ParamName:string read GetParamName write SetParamName;
    property TextValue:string read GetTextValue write SetTextValue;
    property DataType:integer read GetDataType write SetDataType;
    property IsNull:boolean read GetIsNull;
  end;

implementation

{$R *.lfm}

{ TfbmSQLParamValueEditorFrame }

procedure TfbmSQLParamValueEditorFrame.ComboBox1Change(Sender: TObject);
begin
  SpinEdit1.Visible:=ComboBox1.ItemIndex = 1;
  FloatSpinEdit1.Visible:=ComboBox1.ItemIndex = 2;
  RxDateEdit1.Visible:=ComboBox1.ItemIndex = 3;
  CheckBox1.Visible:=ComboBox1.ItemIndex = 4;
  Edit1.Visible:=not (ComboBox1.ItemIndex in [1, 2, 3, 4]);
end;

procedure TfbmSQLParamValueEditorFrame.CheckBox2Change(Sender: TObject);
var
  C:TControl;
begin
  ComboBox1.Enabled:=not CheckBox2.Checked;
  case DataType of
    1:C:=SpinEdit1;
    2:C:=FloatSpinEdit1;
    3:C:=RxDateEdit1;
    4:C:=CheckBox1;
  else
    C:=Edit1;
  end;
  C.Enabled:=ComboBox1.Enabled;
end;

function TfbmSQLParamValueEditorFrame.GetDataType: integer;
begin
  Result:=ComboBox1.ItemIndex;
end;

function TfbmSQLParamValueEditorFrame.GetIsNull: boolean;
begin
  Result:=CheckBox2.Checked;
end;

function TfbmSQLParamValueEditorFrame.GetParamName: string;
begin
  Result:=lblParamName.Caption;
end;

function TfbmSQLParamValueEditorFrame.GetTextValue: string;
begin
  case DataType of
    0:Result:=Edit1.Text;
    1:Result:=IntToStr(SpinEdit1.Value);
    2:Result:=FloatToStr(FloatSpinEdit1.Value);
    3:Result:=DateToStr(RxDateEdit1.Date);
    4:Result:=BoolToStr(CheckBox1.Checked);
  else
    Result:=Edit1.Text;
  end;
end;

procedure TfbmSQLParamValueEditorFrame.SetDataType(AValue: integer);
begin
  ComboBox1.ItemIndex:=AValue;
  ComboBox1Change(nil);
end;

procedure TfbmSQLParamValueEditorFrame.SetParamName(AValue: string);
begin
  lblParamName.Caption:=AValue;
  CheckBox1.Caption:=AValue;
end;

procedure TfbmSQLParamValueEditorFrame.SetTextValue(AValue: string);
begin
  case DataType of
    0:Edit1.Text:=AValue;
    1:SpinEdit1.Value:=StrToIntDef(AValue, 0);
    2:FloatSpinEdit1.Value:=StrToFloatDef(AValue, 0);
    3:RxDateEdit1.Date:=StrToDateDef(AValue, Date);
    4:CheckBox1.Checked:=StrToBoolDef(AValue, false);
  else
    Edit1.Text:=AValue;
  end;
end;

constructor TfbmSQLParamValueEditorFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Edit1.Text:='';
end;

{
0 - String
1 - Integer
2 - Float
3 - DateTime
4 - Boolean
}
procedure TfbmSQLParamValueEditorFrame.SetParam(AParam: TParam);
begin
  if not Assigned(AParam) then Exit;
  SpinEdit1.MinValue:= - MaxInt;
  SpinEdit1.MaxValue:=MaxInt;
  FloatSpinEdit1.MaxValue:=9999999999999;
  FloatSpinEdit1.MinValue:=-9999999999999;
  case AParam.DataType of
     ftSmallint,
     ftInteger,
     ftWord,
     ftLargeint:
      begin
        ComboBox1.ItemIndex:=1;
        SpinEdit1.Value:=AParam.AsInteger;
      end;
     ftBoolean:
      begin
        ComboBox1.ItemIndex:=4;
        CheckBox1.Checked:=AParam.AsBoolean;
      end;
     ftFloat,
     ftCurrency,
     ftBCD,
     ftFMTBcd:
       begin
         ComboBox1.ItemIndex:=2;
         FloatSpinEdit1.Value:=AParam.AsFloat;
       end;
     ftDate,
     ftTime,
     ftDateTime,
     ftTimeStamp:
       begin
         ComboBox1.ItemIndex:=3;
         RxDateEdit1.Date:=AParam.AsDateTime;
       end;
  else
//       ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo,
//       ftGraphic, ftFmtMemo, ftParadoxOle, ftDBaseOle,
//       ftTypedBinary, ftCursor, , ftADT, ftArray, ftReference,
//       ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface,
//       ftIDispatch, ftGuid, ftWideMemo);
//       ftUnknown,
//Главное - для строк
//       ftString, ftFixedChar, ftFixedWideChar, ftWideString
    ComboBox1.ItemIndex:=0;
    if not AParam.IsNull then
      Edit1.Text:=AParam.Value;
  end;
  ParamName:=AParam.Name;
  Hint:=AParam.Name;
  ComboBox1Change(nil);
end;

procedure TfbmSQLParamValueEditorFrame.GetParam(AParam: TParam);
var
  S: String;
begin
  if not Assigned(AParam) then Exit;
  S:=AParam.Name;
  if CheckBox2.Checked then
    AParam.Clear
  else
  case ComboBox1.ItemIndex of
    0:AParam.AsString:=Edit1.Text;
    1:AParam.AsInteger:= SpinEdit1.Value;
    2:AParam.AsFloat:= FloatSpinEdit1.Value;
    3:AParam.AsDateTime:= RxDateEdit1.Date;
    4:AParam.AsBoolean:= CheckBox1.Checked; // StrToBool(Edit1.Text);
  else
//    P.
  end;
end;

end.

