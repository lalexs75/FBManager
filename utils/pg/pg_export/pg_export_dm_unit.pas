{ Free DB Manager

  Copyright (C) 2005-2014 Lagunov Aleksey  alexs75 at yandex.ru

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

unit pg_export_dm_unit;

{.$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset;

type
  TExportEngine = (eePostgre, eeFireBird, eeFireBird3, eeSqlLite3, eeMySQL);

  { TExportDM }

  TExportDM = class(TDataModule)
    MainDB: TZConnection;
    quS: TZReadOnlyQuery;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ExportDM: TExportDM = nil;

procedure InitData(AEngine:TExportEngine);
implementation
uses CustApp;

{$R *.lfm}

procedure InitData(AEngine: TExportEngine);
begin
  if not Assigned(ExportDM) then
  begin
    ExportDM:=TExportDM.Create(CustomApplication);
    case AEngine of
      eePostgre:ExportDM.MainDB.Protocol:='postgresql-9';
      eeFireBird:ExportDM.MainDB.Protocol:='firebirdd-2.5';
      eeFireBird3:ExportDM.MainDB.Protocol:='firebird-3.0';
      eeSqlLite3:ExportDM.MainDB.Protocol:='sqlite-3';
      eeMySQL:ExportDM.MainDB.Protocol:='mysql-5';
    else
      raise Exception.Create('Unknow export engine');
    end;
  end;
end;


end.

