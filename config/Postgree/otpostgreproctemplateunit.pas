{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit otPostgreProcTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  SynHighlighterSQL, cfAbstractConfigFrameUnit, fdbm_SynEditorUnit;

type

  { TotPostgreProcTemplatePage }

  TotPostgreProcTemplatePage = class(TFBMConfigPageAbstract)
    Panel1: TPanel;
    SynSQLSyn1: TSynSQLSyn;
  private
    FLazyMode:boolean;
    EditorFrame:Tfdbm_SynEditorFrame;
  public
    constructor CreateTools(TheOwner: TComponent; ALazyMode:boolean);
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmToolsUnit, pg_sql_lines_unit, fbmStrConstUnit;

{$R *.lfm}

{ TotPostgreProcTemplatePage }

constructor TotPostgreProcTemplatePage.CreateTools(TheOwner: TComponent;
  ALazyMode: boolean);
begin
  inherited Create(TheOwner);
  FLazyMode:=ALazyMode;
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.ChangeVisualParams;
  EditorFrame.TextEditor.Highlighter:=SynSQLSyn1;
  if FLazyMode then
    Name:=Name + 'LazyPG'
  else
    Name:=Name + 'FullPG'
    ;
end;

function TotPostgreProcTemplatePage.PageName: string;
begin
  if FLazyMode then
    Result:=sPGPgSqlFunctionLazy
  else
    Result:=sPGPgSqlFunction;
end;

procedure TotPostgreProcTemplatePage.LoadData;
begin
  if FLazyMode then
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate-PostgreSQL-StdFuncion-Lazy', DummyPGFunctionTextLazy)
  else
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate-PostgreSQL-StdFuncion', DummyPGFunctionText);
end;

procedure TotPostgreProcTemplatePage.SaveData;
begin
  if FLazyMode then
    ConfigValues.SetByNameAsString('ObjTemplate-PostgreSQL-StdFuncion-Lazy', EditorFrame.EditorText)
  else
    ConfigValues.SetByNameAsString('ObjTemplate-PostgreSQL-StdFuncion', EditorFrame.EditorText);
end;

procedure TotPostgreProcTemplatePage.Localize;
begin
  inherited Localize;
end;

end.

