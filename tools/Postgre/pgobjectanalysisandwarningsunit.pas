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

unit pgObjectAnalysisAndWarningsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, 
  PostgreSQLEngineUnit, SQLEngineAbstractUnit, fbmAbstractSQLEngineToolsUnit;

type

  { TpgObjectAnalysisAndWarningsTools }

  TpgObjectAnalysisAndWarningsTools = class(TAbstractSQLEngineTools)
  private

  protected
    procedure SetSQLEngine(AValue: TSQLEngineAbstract); override;
  public
    function PageName:string; override;
    procedure RefreshPage; override;
  end;

implementation

{$R *.lfm}

{ TpgObjectAnalysisAndWarningsTools }

procedure TpgObjectAnalysisAndWarningsTools.SetSQLEngine(
  AValue: TSQLEngineAbstract);
begin
  inherited SetSQLEngine(AValue);
end;

function TpgObjectAnalysisAndWarningsTools.PageName: string;
begin
  Caption:=;
  Result:='Analysis and Warnings';
end;

procedure TpgObjectAnalysisAndWarningsTools.RefreshPage;
begin

end;

end.

