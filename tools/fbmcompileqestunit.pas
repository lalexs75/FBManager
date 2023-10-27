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

unit fbmCompileQestUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, CheckLst, ExtCtrls, SynEdit, RxIniPropStorage, ButtonPanel,
  ActnList, Menus, StdActns;

type

  { TfbmCompileQestForm }

  TfbmCompileQestForm = class(TForm)
    actCopyToBuf: TAction;
    ActionList1: TActionList;
    btnCopy: TBitBtn;
    ButtonPanel1: TButtonPanel;
    CheckListBox1: TCheckListBox;
    RxIniPropStorage1: TRxIniPropStorage;
    Splitter1: TSplitter;
    SynEdit1: TSynEdit;
    procedure actCopyToBufExecute(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure ibmCompileQestFormCreate(Sender: TObject);
  private
    procedure Localize;
  public
    { public declarations }
  end; 

var
  fbmCompileQestForm: TfbmCompileQestForm;

implementation
uses fbmToolsUnit, SQLEngineCommonTypesUnit, Clipbrd, fbmStrConstUnit;

{$R *.lfm}

{ TfbmCompileQestForm }

procedure TfbmCompileQestForm.CheckListBox1Click(Sender: TObject);
begin
  SynEdit1.Text:=CheckListBox1.Items[CheckListBox1.ItemIndex];
end;

procedure TfbmCompileQestForm.actCopyToBufExecute(Sender: TObject);
var
  i:integer;
  S:string;
begin
  S:='';
  for i:=0 to CheckListBox1.Items.Count - 1 do
  begin
    if CheckListBox1.Checked[i] then
    begin
      if S<>'' then
        S:=S + LineEnding;
      S:=S+CheckListBox1.Items[i];
    end;
  end;
  if S<>'' then
  begin
    Clipboard.Open;
    Clipboard.AsText:=S;
    Clipboard.Close;
  end;
end;

procedure TfbmCompileQestForm.ibmCompileQestFormCreate(Sender: TObject);
begin
  Localize;
  SetEditorOptions(SynEdit1);
  btnCopy.AnchorSideLeft.Control:=ButtonPanel1.HelpButton;
  btnCopy.AnchorSideTop.Control:=ButtonPanel1.HelpButton;
  btnCopy.AnchorSideBottom.Control:=ButtonPanel1.HelpButton;

  ActiveControl:=ButtonPanel1.OKButton;
end;

procedure TfbmCompileQestForm.Localize;
begin
  Caption:=sApplyScript;
  actCopyToBuf.Caption:=sCopy;
  actCopyToBuf.Hint:=sCopyHint;
end;

end.

