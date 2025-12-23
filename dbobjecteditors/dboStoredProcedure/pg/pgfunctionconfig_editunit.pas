{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pgFunctionConfig_EditUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel,
  PostgreSQLEngineUnit, pgTypes;

type

  { TpgFunctionConfig_EditForm }

  TpgFunctionConfig_EditForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure ComboBox1Change(Sender: TObject);
  private
    FCurParam: TPGSettingParam;
    FPGFunction:TPGFunction;
    procedure DoUpdateCrls;
    function GetParamValue: string;
    procedure InitParamList;
    procedure SetCurParam(AValue: TPGSettingParam);
    procedure SetParamValue(AValue: string);
  public
    constructor CreateEditForm(APGFunction:TPGFunction);
    procedure Localize;
    property CurParam:TPGSettingParam read FCurParam write SetCurParam;
    property ParamValue:string read GetParamValue write SetParamValue;
  end;

var
  pgFunctionConfig_EditForm: TpgFunctionConfig_EditForm;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TpgFunctionConfig_EditForm }

procedure TpgFunctionConfig_EditForm.ComboBox1Change(Sender: TObject);
begin
  if (ComboBox1.ItemIndex <0) or (ComboBox1.ItemIndex > ComboBox1.Items.Count-1) then
    FCurParam:=nil
  else
    FCurParam:=TPGSettingParam(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  DoUpdateCrls;
end;

procedure TpgFunctionConfig_EditForm.InitParamList;
var
  E: TSQLEnginePostgre;
  P: TPGSettingParam;
begin
  ComboBox1.Items.Clear;
  E:=FPGFunction.OwnerDB as TSQLEnginePostgre;
  for P in E.PGSettingParams do
    ComboBox1.Items.AddObject(P.ParamName, P);
  CurParam:=nil;
  DoUpdateCrls;
end;

procedure TpgFunctionConfig_EditForm.DoUpdateCrls;
begin
  Label2.Visible:=Assigned(FCurParam) and (FCurParam.ParamType in [pgstEnum,
    pgstInteger, pgstReal, pgstString]);
  ComboBox2.Visible:=Assigned(FCurParam) and (FCurParam.ParamType = pgstEnum);
  Edit1.Visible:=Assigned(FCurParam) and (FCurParam.ParamType in [pgstInteger,
    pgstReal, pgstString]);
  CheckBox1.Visible:=Assigned(FCurParam) and (FCurParam.ParamType = pgstBool);

  if ComboBox2.Visible then
    ComboBox2.Items.Assign(FCurParam.EnumValues);
end;

function TpgFunctionConfig_EditForm.GetParamValue: string;
begin
  if not Assigned(FCurParam) then Exit('');
  case FCurParam.ParamType of
    pgstBool:Result:=BoolToStr(CheckBox1.Checked, true);
    pgstEnum:Result:=ComboBox2.Text
  else
    //pgstString
    //pgstInteger,
    //pgstReal,
    Result:=Edit1.Text;
  end;
end;

procedure TpgFunctionConfig_EditForm.SetCurParam(AValue: TPGSettingParam);
begin
  if FCurParam=AValue then Exit;
  FCurParam:=AValue;
  if Assigned(AValue) then
    ComboBox1.Text:=AValue.ParamName
  else
    ComboBox1.ItemIndex:=-1;
  DoUpdateCrls;
end;

procedure TpgFunctionConfig_EditForm.SetParamValue(AValue: string);
begin
  if not Assigned(FCurParam) then Exit;
  case FCurParam.ParamType of
    pgstBool:CheckBox1.Checked:=StrToBool(AValue);
    pgstEnum:ComboBox2.Text:=AValue;
  else
    //pgstString
    //pgstInteger,
    //pgstReal,
    Edit1.Text:=AValue;
  end;
end;

constructor TpgFunctionConfig_EditForm.CreateEditForm(APGFunction: TPGFunction);
begin
  inherited Create(Application);
  FPGFunction:=APGFunction;

  InitParamList;

  Localize;
end;

procedure TpgFunctionConfig_EditForm.Localize;
begin
  Label1.Caption:=sParamName;
  Label2.Caption:=sParamValue;
  CheckBox1.Caption:=sParamValue;
  Caption:=sEditConfigValue;
end;

end.

