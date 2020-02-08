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

unit fdbm_cf_DbfMainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, fbmConnectionEditUnit,
  SQLEngineAbstractUnit,  dbf_engineunit, StdCtrls, EditBtn,
  fdbm_ConnectionAbstractUnit;

type

  { TfdbmCFDbfMainFrame }

  TfdbmCFDbfMainFrame = class(TConnectionDlgPage)
    edtDirectory: TDirectoryEdit;
    edtAlias: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    FDBFEngine:TDBFEngine;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    constructor Create(ADBFEngine:TDBFEngine; AOwner:TForm);
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfdbmCFDbfMainFrame }

procedure TfdbmCFDbfMainFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sDbfFilesFolder;
  Label1.Caption:=sDatabaseAlias;
end;

procedure TfdbmCFDbfMainFrame.LoadParams(ASQLEngine: TSQLEngineAbstract);
begin
  edtDirectory.Text:=ASQLEngine.DataBaseName;
  edtAlias.Text:=ASQLEngine.AliasName;
end;

procedure TfdbmCFDbfMainFrame.SaveParams;
begin
  FDBFEngine.DataBaseName:=edtDirectory.Text;
  FDBFEngine.AliasName:=edtAlias.Text;
end;

function TfdbmCFDbfMainFrame.PageName: string;
begin
  Result:=sGeneral;
end;

constructor TfdbmCFDbfMainFrame.Create(ADBFEngine: TDBFEngine; AOwner: TForm);
begin
  inherited Create(AOwner);
  FDBFEngine:=ADBFEngine;
end;

end.

