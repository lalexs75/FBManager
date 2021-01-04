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

unit fbm_cf_TransactionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit,
  FBSQLEngineUnit;

type

  { TfbmCFTransactionFrame }

  TfbmCFTransactionFrame = class(TConnectionDlgPage)
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
  private
    FSQLEngineFireBird:TSQLEngineFireBird;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    constructor Create(ASQLEngineFireBird:TSQLEngineFireBird; AOwner:TForm);
  end;

var
  fbmCFTransactionFrame: TfbmCFTransactionFrame;

implementation
uses fbmStrConstUnit, fbmToolsUnit, fb_utils;

{$R *.lfm}

{ TfbmCFTransactionFrame }

procedure TfbmCFTransactionFrame.Localize;
begin
  inherited Localize;
  SetTranStrings(RadioGroup1.Items);
  SetTranStrings(RadioGroup2.Items);
  RadioGroup1.Caption:=sTransactionPropertyForData;
  RadioGroup2.Caption:=sTransactionPropertyForMetadata;
end;

procedure TfbmCFTransactionFrame.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  RadioGroup1.ItemIndex:=TSQLEngineFireBird(ASQLEngine).TranParamData;
  RadioGroup2.ItemIndex:=TSQLEngineFireBird(ASQLEngine).TranParamMetaData;
end;

procedure TfbmCFTransactionFrame.SaveParams;
begin
  FSQLEngineFireBird.TranParamData:=RadioGroup1.ItemIndex;
  FSQLEngineFireBird.TranParamMetaData:=RadioGroup2.ItemIndex;
end;

function TfbmCFTransactionFrame.PageName: string;
begin
  Result:=sFBTransactionProperties;
end;

function TfbmCFTransactionFrame.Validate: boolean;
begin
  Result:=true;
end;

constructor TfbmCFTransactionFrame.Create(
  ASQLEngineFireBird: TSQLEngineFireBird; AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngineFireBird:=ASQLEngineFireBird;
end;

end.

