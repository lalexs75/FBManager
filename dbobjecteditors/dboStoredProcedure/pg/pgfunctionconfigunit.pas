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

unit pgFunctionConfigUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DB, rxmemds, rxdbgrid,
  fdmAbstractEditorUnit, SQLEngineAbstractUnit, PostgreSQLEngineUnit, pgTypes,
  fbmSqlParserUnit;

type

  { TpgFunctionConfigFrame }

  TpgFunctionConfigFrame = class(TEditorPage)
    dsData: TDataSource;
    rxDataNAME: TStringField;
    rxDataVALUE: TStringField;
    RxDBGrid1: TRxDBGrid;
    rxData: TRxMemoryData;
  private
    procedure RefreshPage;
  public
    procedure Localize;override;
    function PageName:string;override;
    procedure Activate;override;
    function DoMetod(PageAction: TEditorPageAction): boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean;override;
  end;

implementation
uses StrUtils;

{$R *.lfm}

{ TpgFunctionConfigFrame }

procedure TpgFunctionConfigFrame.RefreshPage;
var
  S: String;
  I: Integer;
begin
  if (DBObject.State <> sdboEdit) or (not (DBObject is TPGFunction)) then Exit;

  rxData.DisableControls;
  rxData.EmptyTable;
  for I:=0 to TPGFunction(DBObject).FunctionConfig.Count-1 do
  begin
    S:=TPGFunction(DBObject).FunctionConfig[i];
    rxData.Append;
    rxDataNAME.AsString:=Copy2SymbDel(S, '=');
    rxDataVALUE.AsString:=S;
    rxData.Post;
  end;

  rxData.First;
  rxData.EnableControls;
end;

procedure TpgFunctionConfigFrame.Localize;
begin

end;

function TpgFunctionConfigFrame.PageName: string;
begin
  Result:='Configuration';
end;

procedure TpgFunctionConfigFrame.Activate;
begin
  inherited Activate;
end;

function TpgFunctionConfigFrame.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=inherited DoMetod(PageAction);
end;

function TpgFunctionConfigFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaRefresh, epaPrint, epaAdd, epaEdit, epaDelete];
end;

constructor TpgFunctionConfigFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  rxData.Open;
  RefreshPage;
end;

function TpgFunctionConfigFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

