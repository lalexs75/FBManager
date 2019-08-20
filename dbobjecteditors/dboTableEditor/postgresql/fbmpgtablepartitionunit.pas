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

unit fbmPGTablePartitionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, fdmAbstractEditorUnit, fbmSqlParserUnit,
  SQLEngineAbstractUnit, PostgreSQLEngineUnit;

type

  { TfbmPGTablePartitionPage }

  TfbmPGTablePartitionPage = class(TEditorPage)
  private

  public
    class function PageExists(ADBObject:TDBObject):Boolean; override;

    function PageName:string; override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Activate;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

uses pgTypes;

{$R *.lfm}

{ TfbmPGTablePartitionPage }

class function TfbmPGTablePartitionPage.PageExists(ADBObject: TDBObject
  ): Boolean;
begin
  Result:=Assigned(ADBObject) and (ADBObject.OwnerDB is TSQLEnginePostgre) and (TSQLEnginePostgre(ADBObject.OwnerDB).ServerVersion >= pgVersion10_0);
end;

function TfbmPGTablePartitionPage.PageName: string;
begin
  Result:='aaa';
end;

function TfbmPGTablePartitionPage.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

procedure TfbmPGTablePartitionPage.Activate;
begin
  inherited Activate;
end;

function TfbmPGTablePartitionPage.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=inherited ActionEnabled(PageAction);
end;

constructor TfbmPGTablePartitionPage.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
end;

procedure TfbmPGTablePartitionPage.Localize;
begin
  inherited Localize;
end;

function TfbmPGTablePartitionPage.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

