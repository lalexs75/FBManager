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

unit fbSqlTextUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, uib, StrHolder, RxTextHolder;

type

  { TfbSqlTextData }

  TfbSqlTextData = class(TDataModule)
    fbtPackage: TStrHolder;
    fbtFunctionLazy: TStrHolder;
    fbtPackageBody: TStrHolder;
    fbtPackageLazy: TStrHolder;
    fbtPackageBodyLazy: TStrHolder;
    sDomainsSQL: TRxTextHolder;
    sGenerators: TRxTextHolder;
    sFBStatistic: TRxTextHolder;
    sFBIndexSegs: TStrHolder;
    sFBIndexs: TStrHolder;
    sFBIndex: TStrHolder;
    sFunction: TStrHolder;
    sPackage: TStrHolder;
    sqlRefreshDomain: TStrHolder;
    ssqlSelectViews: TStrHolder;
    sTabcleCheck: TStrHolder;
    ttt: TStrHolder;
    ssqlStoredProcParams: TStrHolder;
    ssqlCollationsList: TStrHolder;
    ssqlSelectTables: TStrHolder;
    sqlSPParams: TStrHolder;
    ssqlSelectFKList: TStrHolder;
    sSqlGrantForObj: TStrHolder;
    sqlSelectAllFields: TStrHolder;
    sqlSelectIndexFields: TStrHolder;
    ssqlCharSetList: TStrHolder;
    sFbTriggers: TStrHolder;
    sFBGenerators: TStrHolder;
    sFBStoredProc: TStrHolder;
    sFBExceptions: TStrHolder;
    sFBUDF: TStrHolder;
    sFBRoles: TStrHolder;
    sPackages: TStrHolder;
    sFunctions: TStrHolder;
    sFunctionArgs: TStrHolder;
    fbtFunction: TStrHolder;
    ssqlDependOnField: TStrHolder;
  private
    { private declarations }
  public
    { public declarations }
  end;


function fbSqlModule: TfbSqlTextData;
implementation
uses CustApp;

{$R *.lfm}

var
  fbSqlTextData: TfbSqlTextData = nil;

function fbSqlModule: TfbSqlTextData;
begin
  if not Assigned(fbSqlTextData) then
    fbSqlTextData:=TfbSqlTextData.Create(CustomApplication);
  Result:=fbSqlTextData;
end;

end.

