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

unit fbmCFColorMarksPageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, ColorBox, ExtCtrls, Spin, StdCtrls, SysUtils, Forms, Controls,
  Graphics, Dialogs, DividerBevel, SQLEngineAbstractUnit,
  fdbm_ConnectionAbstractUnit;

type

  { TfbmCFColorMarksPage }

  TfbmCFColorMarksPage = class(TConnectionDlgPage)
    CheckBox1 : TCheckBox;
    CheckBox2 : TCheckBox;
    CheckGroup1 : TCheckGroup;
    ColorBox1 : TColorBox;
    ColorBox2 : TColorBox;
    ColorBox3 : TColorBox;
    DividerBevel1: TDividerBevel;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    SpinEdit1 : TSpinEdit;
  private

  public
    procedure Localize;override;
    procedure Activate;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation

uses fbmStrConstUnit, IBManDataInspectorUnit;

{$R *.lfm}

procedure TfbmCFColorMarksPage.Localize;
begin
  inherited Localize;
end;

procedure TfbmCFColorMarksPage.Activate;
begin
  inherited Activate;
end;

procedure TfbmCFColorMarksPage.LoadParams(ASQLEngine : TSQLEngineAbstract);
begin

end;

procedure TfbmCFColorMarksPage.SaveParams;
begin

end;

function TfbmCFColorMarksPage.PageName : string;
begin
  Result:=sColorMark;
end;

function TfbmCFColorMarksPage.Validate : boolean;
begin
  Result :=true;
end;

constructor TfbmCFColorMarksPage.Create(ASQLEngineAbstract : TSQLEngineAbstract; AOwner : TForm);
begin
  inherited Create(AOwner);
//  FSQLEngineAbstract:=ASQLEngineAbstract;
end;

end.

