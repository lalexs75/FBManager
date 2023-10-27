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

unit otMySQLTriggerTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  SynHighlighterSQL, cfAbstractConfigFrameUnit, fbmStrConstUnit,
  fdbm_SynEditorUnit;

type

  { TotMySQLTriggerTemplateFrame }

  TotMySQLTriggerTemplateFrame = class(TFBMConfigPageAbstract)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    SynSQLSyn1: TSynSQLSyn;
  private
    FLazyMode: Boolean;
    EditorFrame:Tfdbm_SynEditorFrame;
  public
    constructor CreateTools(TheOwner: TComponent; ALazyMode:boolean);
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
  end;

implementation
uses fbmToolsUnit, fb_ConstUnit;

{$R *.lfm}

{ TotMySQLTriggerTemplateFrame }

constructor TotMySQLTriggerTemplateFrame.CreateTools(TheOwner: TComponent;
  ALazyMode: boolean);
begin
  inherited Create(TheOwner);
  FLazyMode:=ALazyMode;
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
  EditorFrame.ChangeVisualParams;
  EditorFrame.TextEditor.Highlighter:=SynSQLSyn1;
  if FLazyMode then
    Name:=Name + 'Lazy'
  else
    Name:=Name + 'Full';
end;

function TotMySQLTriggerTemplateFrame.PageName: string;
begin
  if FLazyMode then
    Result:=sMySQLSqlTriggerLazy
  else
    Result:=sMySQLSqlTrigger;
end;

procedure TotMySQLTriggerTemplateFrame.LoadData;
begin
  if FLazyMode then
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/MySQL/Trigger/Lazy', sMySqlCreateTriggerBodyLazy)
  else
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/MySQL/Trigger/Normal', sMySqlCreateTriggerBodyNormal);

  Edit1.Text:=ConfigValues.ByNameAsString('ObjTemplate/MySQL/Trigger/Name', sMySqlCreateTriggerName);
end;

procedure TotMySQLTriggerTemplateFrame.SaveData;
begin
  if FLazyMode then
    ConfigValues.SetByNameAsString('ObjTemplate/MySQL/Trigger/Lazy', EditorFrame.EditorText)
  else
    ConfigValues.SetByNameAsString('ObjTemplate/MySQL/Trigger/Normal', EditorFrame.EditorText);
  ConfigValues.SetByNameAsString('ObjTemplate/MySQL/Trigger/Name', Edit1.Text);
end;

procedure TotMySQLTriggerTemplateFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sTriggerNameTemplate;
  Label2.Caption:=sTriggerNameTags;
end;

end.

