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

unit fbmTableStatisticUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList, DB,
  rxdbgrid, fdmAbstractEditorUnit, SQLEngineAbstractUnit, IniFiles;

type

  { TfbmTableStatisticFrame }

  TfbmTableStatisticFrame = class(TEditorPage)
    ActionList1: TActionList;
    dsStat: TDataSource;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
  private

  public
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);override;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmTableStatisticFrame }

function TfbmTableStatisticFrame.PageName: string;
begin
  Result:=sStatistic;
end;

procedure TfbmTableStatisticFrame.Activate;
begin
  inherited Activate;
  dsStat.DataSet:=TDBTableObject(DBObject).Statistic.StatData;
end;

function TfbmTableStatisticFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

function TfbmTableStatisticFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited ActionEnabled(PageAction);
end;

constructor TfbmTableStatisticFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
end;

procedure TfbmTableStatisticFrame.SaveState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited SaveState(SectionName, Ini);
end;

procedure TfbmTableStatisticFrame.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  inherited RestoreState(SectionName, Ini);
end;

procedure TfbmTableStatisticFrame.Localize;
begin
  inherited Localize;
end;

end.

