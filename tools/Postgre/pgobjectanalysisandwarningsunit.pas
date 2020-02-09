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

unit pgObjectAnalysisAndWarningsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, PostgreSQLEngineUnit, SQLEngineAbstractUnit,
  fbmAbstractSQLEngineToolsUnit;

type

  { TpgObjectAnalysisAndWarningsTools }

  TpgObjectAnalysisAndWarningsTools = class(TAbstractSQLEngineTools)
    Label1: TLabel;
    Splitter1: TSplitter;
    TabControl1: TTabControl;
    TreeView1: TTreeView;
    procedure TabControl1Change(Sender: TObject);
  private
    procedure InternalLoadData;
  protected
    procedure SetSQLEngine(AValue: TSQLEngineAbstract); override;
  public
    function PageName:string; override;
    procedure RefreshPage; override;
  end;

implementation

{$R *.lfm}

{ TODO -oalexs : Необходимо реализовать анализ статистики и производительности по БД }
(*
1. Список таблиц без PK
2. Список FK в таблицах без индексов по соотвутсвующим полям
3. Список "потерянных тригерных процедур"
*)

{ TpgObjectAnalysisAndWarningsTools }

procedure TpgObjectAnalysisAndWarningsTools.TabControl1Change(Sender: TObject);
begin
  InternalLoadData;
end;

procedure TpgObjectAnalysisAndWarningsTools.InternalLoadData;
begin

end;

procedure TpgObjectAnalysisAndWarningsTools.SetSQLEngine(
  AValue: TSQLEngineAbstract);
begin
  inherited SetSQLEngine(AValue);
end;

function TpgObjectAnalysisAndWarningsTools.PageName: string;
begin
  Result:='Analysis and Warnings';
end;

procedure TpgObjectAnalysisAndWarningsTools.RefreshPage;
begin
  Label1.Visible:=not FSQLEngine.Connected;
  TabControl1.Visible:=FSQLEngine.Connected;
  if TabControl1.Visible then
    InternalLoadData;
end;

end.

