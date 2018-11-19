{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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
    CheckListBox1: TCheckListBox;
    Memo1: TMemo;
    Splitter1: TSplitter;
  private
    FSQLEngine:TSQLEngineAbstract;
    procedure LoadConf;
  public
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

procedure Tfdbm_ShowObjectsPage.Activate;
begin
  //inherited Activate;
end;

procedure Tfdbm_ShowObjectsPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
var
  i:integer;
  S:string;
  B:Boolean;
begin
  CheckListBox1.Items.Clear;
  for i:=0 to FSQLEngine.ShowObjectItem - 1 do
  begin
    FSQLEngine.ShowObjectGetItem(i, S, B);
    CheckListBox1.Items.Add(S);
    CheckListBox1.Checked[i]:=B;
  end;
end;

procedure Tfdbm_ShowObjectsPage.SaveParams;
var
  i:integer;
begin
  for i:=0 to CheckListBox1.Items.Count - 1 do
    FSQLEngine.ShowObjectSetItem(i, CheckListBox1.Checked[i]);
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

