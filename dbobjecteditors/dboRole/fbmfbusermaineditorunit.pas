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

unit fbmFBUserMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit,
  FBSQLEngineUnit;

type

  { TfbmFBUserMainEditorFrame }

  TfbmFBUserMainEditorFrame = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ValueListEditor1: TValueListEditor;
  private

  public
    procedure Localize;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses fbmStrConstUnit, fb_SqlParserUnit;

{$R *.lfm}

{ TfbmFBUserMainEditorFrame }

procedure TfbmFBUserMainEditorFrame.Localize;
begin
  inherited Localize;
end;

function TfbmFBUserMainEditorFrame.PageName: string;
begin
  Result:=sUser;
end;

constructor TfbmFBUserMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
end;

function TfbmFBUserMainEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=false;
  if ASQLObject is TFBSQLCreateUser then
  begin

  end;
end;

end.

