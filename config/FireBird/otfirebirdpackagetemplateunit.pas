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

unit otFirebirdPackageTemplateUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  SynHighlighterSQL, cfAbstractConfigFrameUnit, fdbm_SynEditorUnit;

type

  { TotFirebirdPackageTemplatePage }

  TotFirebirdPackageTemplatePage = class(TFBMConfigPageAbstract)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Splitter1: TSplitter;
    SynSQLSyn1: TSynSQLSyn;
  private
    FLazyMode: Boolean;
    EditorFrameHeader:Tfdbm_SynEditorFrame;
    EditorFrameBody:Tfdbm_SynEditorFrame;
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

{ TotFirebirdPackageTemplatePage }

constructor TotFirebirdPackageTemplatePage.CreateTools(TheOwner: TComponent;
  ALazyMode: boolean);
begin
  inherited Create(TheOwner);
  FLazyMode:=ALazyMode;
  EditorFrameHeader:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrameHeader.Parent:=GroupBox1;
  EditorFrameHeader.ChangeVisualParams;
  EditorFrameHeader.TextEditor.Highlighter:=SynSQLSyn1;
  EditorFrameHeader.Name:='EditorFrameHeader';

  EditorFrameBody:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrameBody.Parent:=GroupBox2;
  EditorFrameBody.ChangeVisualParams;
  EditorFrameBody.TextEditor.Highlighter:=SynSQLSyn1;
  EditorFrameBody.Name:='EditorFrameBody';

  if FLazyMode then
    Name:=Name + 'Lazy'
  else
    Name:=Name + 'Full';
end;

function TotFirebirdPackageTemplatePage.PageName: string;
begin
  if FLazyMode then
    Result:=sFBSqlPackageLazy
  else
    Result:=sFBSqlPackage;
end;

procedure TotFirebirdPackageTemplatePage.LoadData;
begin
  if FLazyMode then
  begin
    EditorFrameHeader.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Package/Lazy', fbSqlModule.fbtPackageLazy.Strings.Text);
    EditorFrameBody.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/PackageBody/Lazy', fbSqlModule.fbtPackageBodyLazy.Strings.Text);
  end
  else
  begin
    EditorFrameHeader.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Package/Normal', fbSqlModule.fbtPackage.Strings.Text);
    EditorFrameBody.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/PackageBody/Normal', fbSqlModule.fbtPackageBody.Strings.Text);
  end
end;

procedure TotFirebirdPackageTemplatePage.SaveData;
begin
  if FLazyMode then
  begin
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Package/Lazy', EditorFrameHeader.EditorText);
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/PackageBody/Lazy', EditorFrameBody.EditorText);
  end
  else
  begin
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/Package/Normal', EditorFrameHeader.EditorText);
    ConfigValues.SetByNameAsString('ObjTemplate/FireBirdSQL/PackageBody/Normal', EditorFrameBody.EditorText);
  end
end;

procedure TotFirebirdPackageTemplatePage.Localize;
begin
  inherited Localize;
  GroupBox1.Caption:=sPackageHeader;
  GroupBox2.Caption:=sPackageBody;
end;

end.

