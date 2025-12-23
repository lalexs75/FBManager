{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbm_PagedDialogUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ButtonPanel, StdCtrls, ExtCtrls, fdbm_PagedDialogPageUnit;

type

  { Tfdbm_PagedDialogForm }

  Tfdbm_PagedDialogForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    ListBox1: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBox1Click(Sender: TObject);
  private
    FCurPage:TPagedDialogPage;
    function GetPageCount: integer;
    function GetPageNumber: integer;
    function GetPages(AIndex: integer): TPagedDialogPage;
    procedure SetPageNumber(const AValue: integer);
  protected
    procedure AddPage(P:TPagedDialogPage);
    procedure CreatePages;virtual;
    procedure LoadConfig;
    procedure SaveConfig;
    procedure Localize;virtual;
  public
    constructor Create(TheOwner: TComponent); override;
    property PageNumber:integer read GetPageNumber write SetPageNumber;
    property PageCount:integer read GetPageCount;
    property Page:TPagedDialogPage read FCurPage;
    property Pages[AIndex:integer]:TPagedDialogPage read GetPages;
  end;

var
  fdbm_PagedDialogForm: Tfdbm_PagedDialogForm;

implementation
uses LCLType;

{$R *.lfm}

{ Tfdbm_PagedDialogForm }

procedure Tfdbm_PagedDialogForm.ListBox1Click(Sender: TObject);
var
  OldEditor:TPagedDialogPage;
begin
  //При щелчке по элементу списка страниц необходимо отобразить соответсвующую страницу
  if (ListBox1.ItemIndex>-1) and (ListBox1.ItemIndex<ListBox1.Items.Count) then
  begin
    OldEditor:=FCurPage;
    FCurPage:=ListBox1.Items.Objects[ListBox1.ItemIndex] as TPagedDialogPage;
    if Assigned(FCurPage) then
    begin
      if Assigned(OldEditor) then
        OldEditor.Visible:=false;
      FCurPage.Visible:=true;
      FCurPage.Activate;
    end;
  end;
end;

function Tfdbm_PagedDialogForm.GetPageCount: integer;
begin
  Result:=ListBox1.Items.Count;
end;

function Tfdbm_PagedDialogForm.GetPageNumber: integer;
begin
  Result:=ListBox1.ItemIndex;
end;

function Tfdbm_PagedDialogForm.GetPages(AIndex: integer): TPagedDialogPage;
begin
  Result:=ListBox1.Items.Objects[AIndex] as TPagedDialogPage;
end;

procedure Tfdbm_PagedDialogForm.SetPageNumber(const AValue: integer);
begin
  if (AValue>-1) and (AValue < ListBox1.Items.Count) then
  begin
    ListBox1.ItemIndex:=AValue;
    ListBox1Click(nil);
  end;
end;

procedure Tfdbm_PagedDialogForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case Key of
      VK_PRIOR:begin
                 if PageNumber = 0 then
                   PageNumber:=PageCount - 1
                 else
                   PageNumber:=PageNumber - 1;
               end;
      VK_NEXT:begin
                 if PageNumber = PageCount - 1 then
                   PageNumber:=0
                 else
                   PageNumber:=PageNumber + 1;
               end;
    end;
  end;
end;

procedure Tfdbm_PagedDialogForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
var
  i:integer;
  P:TPagedDialogPage;
begin
  if ModalResult = mrOk then
  begin
    for i:=0 to ListBox1.Items.Count - 1 do
    begin
      P:=ListBox1.Items.Objects[i] as TPagedDialogPage;
      CanClose:=P.Validate;
      if not CanClose then
      begin
        PageNumber:=i;
        exit;
      end;
    end;
  end;
end;

procedure Tfdbm_PagedDialogForm.AddPage(P: TPagedDialogPage);
begin
  //Метод добавляет новую страницу в окно редактора
  if Assigned(P) then
  begin
    ListBox1.Items.AddObject(P.PageName, P);
    P.Parent:=Panel1;
    P.Align:=alClient;
    P.Visible:=false;
  end;
end;

procedure Tfdbm_PagedDialogForm.CreatePages;
begin
//
end;

procedure Tfdbm_PagedDialogForm.Localize;
begin

end;

procedure Tfdbm_PagedDialogForm.LoadConfig;
var
  i:integer;
  P:TPagedDialogPage;
begin
  for i:=0 to ListBox1.Items.Count - 1 do
  begin
    P:=ListBox1.Items.Objects[i] as TPagedDialogPage;
    if Assigned(P) then
      P.LoadData;
  end;
end;

procedure Tfdbm_PagedDialogForm.SaveConfig;
var
  i:integer;
  P:TPagedDialogPage;
begin
  for i:=0 to ListBox1.Items.Count - 1 do
  begin
    P:=ListBox1.Items.Objects[i] as TPagedDialogPage;
    if Assigned(P) then
      P.SaveData;
  end;
end;


constructor Tfdbm_PagedDialogForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Localize;
  CreatePages;
  PageNumber:=0;
end;


end.

