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

unit otFirebirdTriggerTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterSQL, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, cfAbstractConfigFrameUnit, fdbm_SynEditorUnit;

type

  { TotFirebirdTriggerTemplatePage }

  TotFirebirdTriggerTemplatePage = class(TFBMConfigPageAbstract)
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
uses fbmToolsUnit, fbmStrConstUnit, fb_ConstUnit;

{$R *.lfm}

{ TotFirebirdTriggerTemplatePage }

constructor TotFirebirdTriggerTemplatePage.CreateTools(TheOwner: TComponent;
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

function TotFirebirdTriggerTemplatePage.PageName: string;
begin
  if FLazyMode then
    Result:=sFBSqlTriggerLazy
  else
    Result:=sFBSqlTrigger;
end;

procedure TotFirebirdTriggerTemplatePage.LoadData;
begin
  if FLazyMode then
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Lazy', ssqlCreateTriggerBodyLazy)
  else
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Normal', ssqlCreateTriggerBodyNormal);

  Edit1.Text:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Name', ssqlCreateTriggerName);
end;

procedure TotFirebirdTriggerTemplatePage.SaveData;
begin
  if FLazyMode then
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Lazy', EditorFrame.EditorText)
  else
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Normal', EditorFrame.EditorText);
  ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Name', Edit1.Text);
end;

procedure TotFirebirdTriggerTemplatePage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sTriggerNameTemplate;
  Label2.Caption:=sTriggerNameTags;
end;

end.

