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
unit fbmpgTableCheckConstaint_EditUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  StdCtrls, ExtCtrls, ComCtrls, fdbm_SynEditorUnit, SQLEngineAbstractUnit;

type

  { TfbmpgTableCheckConstaint_EditForm }

  TfbmpgTableCheckConstaint_EditForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    edtDescr: TMemo;
    edtName: TEdit;
    lblCaption: TLabel;
    PageControl1: TPageControl;
    tabCode: TTabSheet;
    tabDescription: TTabSheet;
  private
    FTable:TDBTableObject;
    FNewConstraint:boolean;
    procedure MakeConstraintName;
    procedure Localize;
  public
    EditorFrame:Tfdbm_SynEditorFrame;
    constructor CreateEditForm(ATable:TDBTableObject; ANewConstraint:boolean);
  end;

var
  fbmpgTableCheckConstaint_EditForm: TfbmpgTableCheckConstaint_EditForm;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmpgTableCheckConstaint_EditForm }

const
  sCheckConstraintNameMask = 'chk_%s_%d';

procedure TfbmpgTableCheckConstaint_EditForm.MakeConstraintName;
var
  i:integer;
  S:string;
begin
  i:=0;
  repeat
    inc(i);
    S:=Format(sCheckConstraintNameMask, [FTable.Caption, i]);
  until not Assigned(FTable.ConstraintFind(S));
  edtName.Text:=S;
end;

procedure TfbmpgTableCheckConstaint_EditForm.Localize;
begin
  Caption:=sTableCheckConstraint;
  lblCaption.Caption:=sCheckName;
  tabCode.Caption:=sCheckBody;
  tabDescription.Caption:=sDescription;
end;

constructor TfbmpgTableCheckConstaint_EditForm.CreateEditForm(ATable: TDBTableObject;
  ANewConstraint: boolean);
begin
  inherited Create(Application);
  FTable:=ATable;
  PageControl1.ActivePageIndex:=0;

  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=tabCode;
  EditorFrame.Align:=alClient;
  EditorFrame.EditorText:='';
  EditorFrame.SQLEngine:=FTable.OwnerDB;

  FNewConstraint:=ANewConstraint;
  edtName.Text:='';
  edtDescr.Text:='';
  Localize;

  if FNewConstraint then
    MakeConstraintName;

  if Assigned(ATable) and Assigned(ATable.OwnerDB) then
    tabDescription.TabVisible:=feDescribeTableConstraint in ATable.OwnerDB.SQLEngileFeatures;
end;

end.

