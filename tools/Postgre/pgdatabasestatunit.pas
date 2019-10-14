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

unit pgDataBaseStatUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ActnList,
  Menus, DB, rxdbgrid, rxtoolbar, ZMacroQuery, ZConnection,
  PostgreSQLEngineUnit;

type

  { TpgDataBaseStatForm }

  TpgDataBaseStatForm = class(TForm)
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    ToolPanel1: TToolPanel;
    tsRefresh: TAction;
    ActionList1: TActionList;
    dsTablesStat: TDataSource;
    PageControl1: TPageControl;
    pgStatDB: TZConnection;
    RxDBGrid1: TRxDBGrid;
    TabSheet1: TTabSheet;
    quTablesStat: TZMacroQuery;
  private
    procedure Localize;
  public
    procedure ConnectToDB(ASQLEngine: TSQLEnginePostgre);
  end;

procedure ShowDataBaseStatForm(ASQLEngine: TSQLEnginePostgre);
implementation
uses IBManMainUnit;

{ TODO -oalexs : Необходимо реализовать анализ статистики и производительности по БД }
(*
1. Список таблиц без PK
2. Список FK в таблицах без индексов по соотвутсвующим полям
*)

var
  pgDataBaseStatForm: TpgDataBaseStatForm = nil;

procedure ShowDataBaseStatForm(ASQLEngine: TSQLEnginePostgre);
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(pgDataBaseStatForm, TpgDataBaseStatForm);
  if Assigned(pgDataBaseStatForm) then
    pgDataBaseStatForm.ConnectToDB(ASQLEngine);
end;

{$R *.lfm}

{ TpgDataBaseStatForm }

procedure TpgDataBaseStatForm.Localize;
begin

end;

procedure TpgDataBaseStatForm.ConnectToDB(ASQLEngine: TSQLEnginePostgre);
begin

end;

end.

