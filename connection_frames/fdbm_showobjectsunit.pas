{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbm_ShowObjectsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, CheckLst, ExtCtrls, fdbm_ConnectionAbstractUnit,
  SQLEngineAbstractUnit;

type

  { Tfdbm_ShowObjectsPage }

  Tfdbm_ShowObjectsPage = class(TConnectionDlgPage)
    cbShowSystemObjects: TCheckBox;
    CheckBox1: TCheckBox;
  private
    FSQLEngine:TSQLEngineAbstract;
    procedure LoadConf;
  public
    procedure Localize;override;
    procedure Activate;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ Tfdbm_ShowObjectsPage }

procedure Tfdbm_ShowObjectsPage.LoadConf;
begin

end;

procedure Tfdbm_ShowObjectsPage.Localize;
begin
  inherited Localize;
  cbShowSystemObjects.Caption:=sShowSystemObjects;
  CheckBox1.Caption:=sShowAdditionalInformation;
end;

procedure Tfdbm_ShowObjectsPage.Activate;
begin
  //inherited Activate;
end;

procedure Tfdbm_ShowObjectsPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  cbShowSystemObjects.Checked:=ussSystemTable in ASQLEngine.UIShowSysObjects;
  CheckBox1.Checked:=ussExpandObjectDetails in ASQLEngine.UIShowSysObjects;
end;

procedure Tfdbm_ShowObjectsPage.SaveParams;
begin
  if cbShowSystemObjects.Checked then
    FSQLEngine.UIShowSysObjects:=FSQLEngine.UIShowSysObjects + [ussSystemTable]
  else
    FSQLEngine.UIShowSysObjects:=FSQLEngine.UIShowSysObjects - [ussSystemTable];

  if CheckBox1.Checked then
    FSQLEngine.UIShowSysObjects:=FSQLEngine.UIShowSysObjects + [ussExpandObjectDetails]
  else
    FSQLEngine.UIShowSysObjects:=FSQLEngine.UIShowSysObjects - [ussExpandObjectDetails];
end;

function Tfdbm_ShowObjectsPage.PageName: string;
begin
  Result:=sShowObjects;
end;

function Tfdbm_ShowObjectsPage.Validate: boolean;
begin
  Result:=true;
end;

constructor Tfdbm_ShowObjectsPage.Create(
  ASQLEngineAbstract: TSQLEngineAbstract; AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngine:=ASQLEngineAbstract;
  LoadConf;
end;

end.

