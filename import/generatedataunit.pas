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

unit GenerateDataUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, ExtCtrls,
  StdCtrls, Spin, DB, rxmemds, rxdbgrid, SQLEngineAbstractUnit;

type

  { TGenerateDataForm }

  TGenerateDataForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    dsFields: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    RxDBGrid1: TRxDBGrid;
    rxFields: TRxMemoryData;
    rxFieldsCHEKED: TBooleanField;
    rxFieldsFieldName: TStringField;
    rxFieldsFieldType: TStringField;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
  private
    FTable: TDBTableObject;
    procedure Localize;
  public
    constructor CreateGenerateDataForm(ATable:TDBTableObject);
    //function SaveData:boolean;
  end;


procedure ShowGenerateDataForm(ATable:TDBTableObject);
implementation

procedure ShowGenerateDataForm(ATable: TDBTableObject);
var
  GenerateDataForm: TGenerateDataForm;
begin
  GenerateDataForm:=TGenerateDataForm.CreateGenerateDataForm(ATable);
  GenerateDataForm.ShowModal;
  GenerateDataForm.Free;
end;

{$R *.lfm}

{ TGenerateDataForm }

procedure TGenerateDataForm.Localize;
begin

end;

constructor TGenerateDataForm.CreateGenerateDataForm(ATable: TDBTableObject);
begin
  inherited Create(Application);
  Localize;
  FTable:=ATable;
end;

end.

