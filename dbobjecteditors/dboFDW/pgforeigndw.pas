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

unit pgForeignDW;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, fbmSqlParserUnit, fbmToolsUnit,
  sqlObjects;

type

  { TpgForeignDataWrap }

  TpgForeignDataWrap = class(TEditorPage)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private

  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

{$R *.lfm}

{ TpgForeignDataWrap }

function TpgForeignDataWrap.PageName: string;
begin
  Result:='Foreign data wrapper';
end;

constructor TpgForeignDataWrap.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

end;

function TpgForeignDataWrap.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited ActionEnabled(PageAction);
end;

function TpgForeignDataWrap.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

procedure TpgForeignDataWrap.Localize;
begin
  inherited Localize;
end;

function TpgForeignDataWrap.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

