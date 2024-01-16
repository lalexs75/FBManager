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

unit fdbm_DescriptionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, 
    fdbm_ConnectionAbstractUnit, SQLEngineAbstractUnit;

type

  { Tfdbm_DescriptionConnectionDlgPage }

  Tfdbm_DescriptionConnectionDlgPage = class(TConnectionDlgPage)
    Memo1: TMemo;
  private
    FSQLEngine:TSQLEngineAbstract;
  public
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    constructor CreateDescriptionPage(ASQLEngine:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ Tfdbm_DescriptionConnectionDlgPage }

procedure Tfdbm_DescriptionConnectionDlgPage.LoadParams(
  ASQLEngine: TSQLEngineAbstract);
begin
  Memo1.Text:=ASQLEngine.Description;
end;

procedure Tfdbm_DescriptionConnectionDlgPage.SaveParams;
begin
  FSQLEngine.Description:=Memo1.Text;
end;

function Tfdbm_DescriptionConnectionDlgPage.PageName: string;
begin
  Result:=sDescription;
end;

constructor Tfdbm_DescriptionConnectionDlgPage.CreateDescriptionPage(
  ASQLEngine: TSQLEngineAbstract; AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngine:=ASQLEngine;
end;

end.

