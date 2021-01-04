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

unit cfFirebirdTransactionsParamsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, LResources, Forms, ExtCtrls,
  StdCtrls, uib, cfAbstractConfigFrameUnit;

type

  { TcfFirebirdTransactionsParamsFrame }

  TcfFirebirdTransactionsParamsFrame = class(TFBMConfigPageAbstract)
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    DividerBevel3: TDividerBevel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
  private
    { private declarations }
  public
    constructor Create(TheOwner: TComponent); override;
    procedure Localize;override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
  end;

implementation
uses fbmStrConstUnit, fb_utils, fbmToolsUnit, fb_ConstUnit;

{$R *.lfm}

{ TcfFirebirdTransactionsParamsFrame }

constructor TcfFirebirdTransactionsParamsFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  SetTranStrings(RadioGroup1.Items);
  SetTranStrings(RadioGroup2.Items);
  SetTranStrings(RadioGroup3.Items);
end;

procedure TcfFirebirdTransactionsParamsFrame.Localize;
begin
  inherited Localize;
  DividerBevel1.Caption:=sTransactionPropertyForData;
  DividerBevel2.Caption:=sTransactionPropertyForMetadata;
  DividerBevel3.Caption:=sTransactionPropertyForScriptEditor;
end;

function TcfFirebirdTransactionsParamsFrame.PageName: string;
begin
  Result:=sFBGloballTransactionProperties;
end;

procedure TcfFirebirdTransactionsParamsFrame.LoadData;
begin
  RadioGroup1.ItemIndex:=ConfigValues.ByNameAsInteger('defTranParamData', 1);
  RadioGroup2.ItemIndex:=ConfigValues.ByNameAsInteger('defTranParamMetaData', 1);
  RadioGroup3.ItemIndex:=ConfigValues.ByNameAsInteger('defTranParamScript', 1);
end;

procedure TcfFirebirdTransactionsParamsFrame.SaveData;
begin
  ConfigValues.SetByNameAsInteger('defTranParamData', RadioGroup1.ItemIndex);
  ConfigValues.SetByNameAsInteger('defTranParamMetaData', RadioGroup2.ItemIndex);
  ConfigValues.SetByNameAsInteger('defTranParamScript', RadioGroup3.ItemIndex);
end;

end.

