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

unit otFirebirdFunctionTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, SynHighlighterSQL, 
    cfAbstractConfigFrameUnit, fdbm_SynEditorUnit;

type

  { TotFirebirdFunctionTemplatePage }

  TotFirebirdFunctionTemplatePage = class(TFBMConfigPageAbstract)
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
uses fbmStrConstUnit, fbmToolsUnit, fbSqlTextUnit;

{$R *.lfm}

{ TotFirebirdFunctionTemplatePage }

constructor TotFirebirdFunctionTemplatePage.CreateTools(TheOwner: TComponent;
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

function TotFirebirdFunctionTemplatePage.PageName: string;
begin
  if FLazyMode then
    Result:=sFBSqlFunctionLazy
  else
    Result:=sFBSqlFunction;
end;

procedure TotFirebirdFunctionTemplatePage.LoadData;
begin
  if FLazyMode then
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Function/Lazy', fbSqlModule.fbtFunctionLazy.Strings.Text)
  else
    EditorFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Function/Normal', fbSqlModule.fbtFunction.Strings.Text);
end;

procedure TotFirebirdFunctionTemplatePage.SaveData;
begin
  if FLazyMode then
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Function/Lazy', EditorFrame.EditorText)
  else
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Function/Normal', EditorFrame.EditorText);
  //ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Trigger/Name', Edit1.Text);
end;

procedure TotFirebirdFunctionTemplatePage.Localize;
begin
  inherited Localize;
end;

end.

