{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit cfKeyboardTemplatesUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ButtonPanel, CheckLst, StdCtrls, ExtCtrls, Buttons, ActnList, Menus,
  SynHighlighterSQL, SynEdit, fdbmSynAutoCompletionsLists;

type

  { TcfKeyboardTemplatesForm }

  TcfKeyboardTemplatesForm = class(TForm)
    Label4: TLabel;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    tpLoadDefault: TAction;
    flSave: TAction;
    flOpen: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SynEdit1: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    tpAdd: TAction;
    tpEdit: TAction;
    tpDelete: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ButtonPanel1: TButtonPanel;
    CheckListBox1: TCheckListBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure CheckListBox1Click(Sender: TObject);
    procedure CheckListBox1ItemClick(Sender: TObject; Index: integer);
    procedure flOpenExecute(Sender: TObject);
    procedure flSaveExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tpAddExecute(Sender: TObject);
    procedure tpDeleteExecute(Sender: TObject);
    procedure tpEditExecute(Sender: TObject);
    procedure tpLoadDefaultExecute(Sender: TObject);
  private
    CurItem:TAutoCompletionItem;
    procedure LoadList;
    procedure SaveCurrentEdit;
    procedure Localize;
  public
    { public declarations }
  end; 

var
  cfKeyboardTemplatesForm: TcfKeyboardTemplatesForm;

implementation
uses fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

{ TcfKeyboardTemplatesForm }

procedure TcfKeyboardTemplatesForm.FormCreate(Sender: TObject);
begin
  Localize;
  SetEditorOptions(SynEdit1);
  LoadList;
end;

procedure TcfKeyboardTemplatesForm.tpAddExecute(Sender: TObject);
var
  S:string;
  R:TAutoCompletionItem;
  k:integer;
begin
  S:='';
  if InputQuery(sTemplateName, sEnterTemplateName, S) then
  begin
    if S<>'' then
    begin
      R:=TAutoCompletionItem.Create;
      R.KeyStr:=S;
      R.Enabled:=true;
      k:=CheckListBox1.Items.Add(S);
      CheckListBox1.Checked[k]:=true;
      CheckListBox1.Items.Objects[k]:=R;
      CheckListBox1.ItemIndex:=k;
      CheckListBox1Click(nil);
    end;
  end;
end;

procedure TcfKeyboardTemplatesForm.tpDeleteExecute(Sender: TObject);
var
  R:TAutoCompletionItem;
begin
  if (CheckListBox1.ItemIndex>=0) and (CheckListBox1.ItemIndex < CheckListBox1.Items.Count) and QuestionBox(sDeleteTemplateQ) then
  begin
    R:=CheckListBox1.Items.Objects[CheckListBox1.ItemIndex] as TAutoCompletionItem;
    R.Free;
    CurItem:=nil;
    CheckListBox1.Items.Delete(CheckListBox1.ItemIndex);
    CheckListBox1Click(nil);
  end;
end;

procedure TcfKeyboardTemplatesForm.tpEditExecute(Sender: TObject);
var
  S:string;
  R:TAutoCompletionItem;
begin
  if (CheckListBox1.ItemIndex>=0) and (CheckListBox1.ItemIndex < CheckListBox1.Items.Count) then
  begin
    R:=CheckListBox1.Items.Objects[CheckListBox1.ItemIndex] as TAutoCompletionItem;
    S:=R.KeyStr;
    if InputQuery(sTemplateName, sEnterTemplateName, S) then
    begin
      if S<>'' then
      begin
        R.KeyStr:=S;
        CheckListBox1.Items[CheckListBox1.ItemIndex]:=S;
      end
    end;
  end
end;

procedure TcfKeyboardTemplatesForm.tpLoadDefaultExecute(Sender: TObject);
begin
  if QuestionBox(sLoadDefaultTemplatesQ) then
  begin
    NotCompleteFunction;
  end;
end;

procedure TcfKeyboardTemplatesForm.CheckListBox1Click(Sender: TObject);
var
  i,k:integer;
begin
  SaveCurrentEdit;
  if (CheckListBox1.ItemIndex>=0) and (CheckListBox1.ItemIndex < CheckListBox1.Items.Count) then
  begin
    SynEdit1.Enabled:=true;
    Edit1.Enabled:=true;
    CurItem:=CheckListBox1.Items.Objects[CheckListBox1.ItemIndex] as TAutoCompletionItem;
    Edit1.Text:=CurItem.Description;
    SynEdit1.Text:=CurItem.CodeText;
  end
  else
  begin
    SynEdit1.Enabled:=false;
    Edit1.Enabled:=false;
    CurItem:=nil;
    Edit1.Text:='';
    SynEdit1.Text:='';
  end;
end;

procedure TcfKeyboardTemplatesForm.CheckListBox1ItemClick(Sender: TObject;
  Index: integer);
var
  R:TAutoCompletionItem;
begin
  if (Index>=0) and (Index < CheckListBox1.Items.Count) then
  begin
    R:=CheckListBox1.Items.Objects[Index] as TAutoCompletionItem;
    R.Enabled:=CheckListBox1.Checked[Index];
  end
end;

procedure TcfKeyboardTemplatesForm.flOpenExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadCompletionFromFile(OpenDialog1.FileName);
end;

procedure TcfKeyboardTemplatesForm.flSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveCompletionToFile(SaveDialog1.FileName);
end;

procedure TcfKeyboardTemplatesForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  i:integer;
begin
  if ModalResult = mrOk then
  begin
    SaveCurrentEdit;
    AutoCompletionList.Clear;
    for i:=0 to CheckListBox1.Items.Count - 1 do
      AutoCompletionList.Add(CheckListBox1.Items.Objects[i]);
    SaveCompletionDefFile;
  end
  else
  begin
    for i:=0 to CheckListBox1.Items.Count - 1 do
      CheckListBox1.Items.Objects[i].Free;
  end;
end;

procedure TcfKeyboardTemplatesForm.LoadList;
var
  i,k:integer;
  R, R1:TAutoCompletionItem;
begin
  CheckListBox1.Items.Clear;
  for i:=0 to AutoCompletionList.Count-1 do
  begin
    R:=AutoCompletionList[i] as TAutoCompletionItem;
    R1:=TAutoCompletionItem.Create;
    R1.Assign(R);
    k:=CheckListBox1.Items.Add(R1.KeyStr);
    CheckListBox1.Items.Objects[k]:=R1;
    CheckListBox1.Checked[k]:=R1.Enabled;
  end;
  if AutoCompletionList.Count > 0 then
    CheckListBox1Click(nil);
end;

procedure TcfKeyboardTemplatesForm.SaveCurrentEdit;
begin
  if Assigned(CurItem) then
  begin
    CurItem.Description:=Edit1.Text;
    CurItem.CodeText:=SynEdit1.Text;
  end;
end;

procedure TcfKeyboardTemplatesForm.Localize;
begin
  Caption:=sKeyboardTemplates;
  Label1.Caption:=sTemplate;
  Label2.Caption:=sDescription;
  Label3.Caption:=sBody;
  Label4.Caption:=sPressShiftSpaceToActivate;
  tpAdd.Caption:=sAddTemplate;
  tpEdit.Caption:=sEditTemplate;
  tpDelete.Caption:=sDeleteTemplate;
  flOpen.Caption:=sOpenFile;
  flSave.Caption:=sSaveToFile;
  tpLoadDefault.Caption:=sLoadDefault;
end;

end.

