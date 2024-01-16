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

unit otPostgreTriggerTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  SynHighlighterSQL, cfAbstractConfigFrameUnit, fdbm_SynEditorUnit;

type

  { TotPostgreTriggerTemplatePage }

  TotPostgreTriggerTemplatePage = class(TFBMConfigPageAbstract)
    Panel1: TPanel;
    SynSQLSyn1: TSynSQLSyn;
  private
    EditorFrame:Tfdbm_SynEditorFrame;
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
  end;

implementation
uses fbmToolsUnit, pg_sql_lines_unit, fbmStrConstUnit;

{$R *.lfm}

{ TotPostgreTriggerTemplatePage }

constructor TotPostgreTriggerTemplatePage.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.ChangeVisualParams;
  EditorFrame.TextEditor.Highlighter:=SynSQLSyn1;
end;

function TotPostgreTriggerTemplatePage.PageName: string;
begin
  Result:=sPGPgSqlTrigger;
end;

procedure TotPostgreTriggerTemplatePage.LoadData;
begin
  EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate-PostgreSQL-TriggerFuncion', DummyPGTriggerText);
end;

procedure TotPostgreTriggerTemplatePage.SaveData;
begin
  ConfigValues.SetByNameAsString('ObjTemplate-PostgreSQL-TriggerFuncion', EditorFrame.EditorText);
end;

end.

