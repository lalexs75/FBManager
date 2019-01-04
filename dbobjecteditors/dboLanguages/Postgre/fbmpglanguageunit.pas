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
unit fbmPGLanguageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    fdmAbstractEditorUnit, SQLEngineAbstractUnit;

type

  { TfbmPGLanguagePage }

  TfbmPGLanguagePage = class(TEditorPage)
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    { private declarations }
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmPGLanguagePage }

function TfbmPGLanguagePage.PageName: string;
begin
  Result:=sLanguage;
end;

constructor TfbmPGLanguagePage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
end;

procedure TfbmPGLanguagePage.Activate;
begin
  inherited Activate;
end;

function TfbmPGLanguagePage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited ActionEnabled(PageAction);
end;

function TfbmPGLanguagePage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

procedure TfbmPGLanguagePage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sLanguageName;
  Label2.Caption:=sHandlerFunction;
  Label3.Caption:=sValidatorFuncation;
  CheckBox1.Caption:=sTrusted;
end;

end.

