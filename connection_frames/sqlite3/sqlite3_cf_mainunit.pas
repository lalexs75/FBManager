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

unit sqlite3_cf_mainunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, SQLEngineAbstractUnit, fdbm_ConnectionAbstractUnit, SQLite3EngineUnit;

type

  { TConnectionSQLite3MainPage }

  TConnectionSQLite3MainPage = class(TConnectionDlgPage)
    edtAliasName: TEdit;
    EditDBName: TFileNameEdit;
    Label1: TLabel;
    Label5: TLabel;
    procedure EditDBNameExit(Sender: TObject);
  private
    FSQLEngine:TSQLEngineSQLite3;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
    constructor Create(ASQLEngine:TSQLEngineSQLite3; AOwner:TForm);
  end;

implementation
uses LazUTF8, LazFileUtils, fbmStrConstUnit, rxAppUtils;

{$R *.lfm}

{ TConnectionSQLite3MainPage }

procedure TConnectionSQLite3MainPage.EditDBNameExit(Sender: TObject);
begin
  if (Trim(edtAliasName.Text) = '') and (Trim(EditDBName.Text)<>'') then
    edtAliasName.Text:=ExtractFileNameOnly(Trim(EditDBName.Text));
end;

procedure TConnectionSQLite3MainPage.Localize;
begin
  inherited Localize;
  Label1.Caption:=sFileName;
  Label5.Caption:=sDatabaseAlias;
end;

procedure TConnectionSQLite3MainPage.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  EditDBName.Text:=ASQLEngine.DataBaseName;
  edtAliasName.Text      := ASQLEngine.AliasName;
end;

procedure TConnectionSQLite3MainPage.SaveParams;
begin
  FSQLEngine.DataBaseName:=EditDBName.Text;
  FSQLEngine.AliasName:=edtAliasName.Text;
end;

function TConnectionSQLite3MainPage.PageName: string;
begin
  Result:=sGeneral;
end;

function TConnectionSQLite3MainPage.Validate: boolean;
begin
  Result:=Trim(edtAliasName.Text)<>'';
  if not Result then
  begin
    ErrorBox(sConnectionNameNotSpecified);
    Exit;
  end;
end;

function TConnectionSQLite3MainPage.TestConnection: boolean;
begin
  Result:=true;
end;

constructor TConnectionSQLite3MainPage.Create(ASQLEngine: TSQLEngineSQLite3;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngine:=ASQLEngine;
end;

end.

