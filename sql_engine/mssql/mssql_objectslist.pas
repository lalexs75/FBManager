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

unit mssql_ObjectsList;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, fbm_VisualEditorsAbstractUnit, Forms;

type

  TMSSQLVisualTools = class(TDBVisualTools)
  private
    procedure tlsShowTdsCfgManagerExecute(Sender: TObject);
  protected
    class function GetMenuItems(Index: integer): TMenuItemRec; override;
    class function GetMenuItemCount:integer; override;
  end;

implementation
uses fbmStrConstUnit{, mssql_FreeTDSConfig_Unit};

{ TMSSQLVisualTools }

procedure TMSSQLVisualTools.tlsShowTdsCfgManagerExecute(Sender: TObject);
begin
  //ShowTDSConfigForm;
end;

class function TMSSQLVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin
  FillChar(Result, Sizeof(Result), 0);
  Result.ImageIndex:=-1;
  case Index of
    0:begin
        Result.ItemName:=sFreeTdsConfigEditor;
//        Result.OnClick:=@tlsShowTdsCfgManagerExecute;
      end;
  end;
end;

class function TMSSQLVisualTools.GetMenuItemCount: integer;
begin
  Result:=1;
end;

end.

