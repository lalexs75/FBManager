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

unit fbmSQLEditor_ShowMemoUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Ipfilebroker, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ButtonPanel, DbCtrls, Buttons, ActnList, Menus, db;

type
  TMyIPHtml = class(TIpHtml)
  public
    property OnGetImageX;
  end;

  { TfbmSQLEditor_ShowMemoForm }

  TfbmSQLEditor_ShowMemoForm = class(TForm)
    actOpen: TAction;
    actSave: TAction;
    ActionList1: TActionList;
    ButtonPanel1: TButtonPanel;
    Datasource1: TDatasource;
    DBImage1: TDBImage;
    DBMemo1: TDBMemo;
    DBNavigator1: TDBNavigator;
    IpHtmlPanel1: TIpHtmlPanel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    OpenDialog3: TOpenDialog;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    SaveDialog3: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TDBNavButtonType
      );
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    FIPHtml: TMyIPHtml;
    procedure Localize;
    procedure LoadHTML;
    procedure IpHtmlDataGetImageEvent(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
  public
  end;

var
  fbmSQLEditor_ShowMemoForm: TfbmSQLEditor_ShowMemoForm;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmSQLEditor_ShowMemoForm }

procedure TfbmSQLEditor_ShowMemoForm.FormCreate(Sender: TObject);
begin
  FIPHtml:=TMyIPHtml.Create;
  FIPHtml.OnGetImageX:=@IpHtmlDataGetImageEvent;
  IpHtmlPanel1.SetHtml(FIPHtml);
  Localize;
  PageControl1.ActivePageIndex:=0;
//  PageControl1Change(nil);}
end;

procedure TfbmSQLEditor_ShowMemoForm.FormDestroy(Sender: TObject);
begin
  //FIPHtml.Free;
end;

procedure TfbmSQLEditor_ShowMemoForm.DBNavigator1BeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if PageControl1.ActivePageIndex = 2 then
    LoadHTML;
end;

procedure TfbmSQLEditor_ShowMemoForm.actOpenExecute(Sender: TObject);
var
  DS: TDataSet;
  F: TField;
  S: String;
begin
  DS:=Datasource1.DataSet;
  F:=DBMemo1.Field;
  if not (Assigned(DS) and Assigned(F)) then Exit;
  if not (F is TBlobField) then Exit;
  case PageControl1.ActivePageIndex of
    0:begin
        if not OpenDialog1.Execute then Exit;
        S:=OpenDialog1.FileName;
      end;
    1:begin
        if not OpenDialog2.Execute then Exit;
        S:=OpenDialog2.FileName;
      end;
    2:begin
        if not OpenDialog3.Execute then Exit;
        S:=OpenDialog3.FileName;
      end;
  else
    Exit;
  end;


  if DS.State = dsBrowse then
  begin
    if DS.RecordCount>0 then
      DS.Edit
    else
      DS.Append;
  end;
  TBlobField(F).LoadFromFile(S);
  if PageControl1.ActivePageIndex = 1 then
    DBImage1.LoadPicture
  else
  if PageControl1.ActivePageIndex = 2 then
    LoadHTML;
end;

procedure TfbmSQLEditor_ShowMemoForm.actSaveExecute(Sender: TObject);
var
  DS: TDataSet;
  F: TField;
  S: String;
begin
  DS:=Datasource1.DataSet;
  F:=DBMemo1.Field;
  if not (Assigned(DS) and Assigned(F)) then Exit;
  if not (F is TBlobField) then Exit;
  if DS.RecordCount = 0 then Exit;

  case PageControl1.ActivePageIndex of
    0:begin
        if not OpenDialog1.Execute then Exit;
        S:=OpenDialog1.FileName;
      end;
    1:begin
        if not OpenDialog2.Execute then Exit;
        S:=OpenDialog2.FileName;
      end;
    2:begin
        if not OpenDialog3.Execute then Exit;
        S:=OpenDialog3.FileName;
      end;
  else
    Exit;
  end;

  TBlobField(F).SaveToFile(S);

end;

procedure TfbmSQLEditor_ShowMemoForm.PageControl1Change(Sender: TObject);
begin
  DBMemo1.AutoDisplay:=PageControl1.ActivePage = TabSheet1;
  DBImage1.AutoDisplay:=PageControl1.ActivePage = TabSheet2;

  if PageControl1.ActivePageIndex = 2 then
    LoadHTML;
end;

procedure TfbmSQLEditor_ShowMemoForm.Localize;
begin
  Caption:=sMemoValue;
  TabSheet1.Caption:=sAsText;
  TabSheet2.Caption:=sAsImage;
  actOpen.Caption:=sOpen;
  actSave.Caption:=sSave;

  OpenDialog1.Filter:=sTextFilesFilter;
  SaveDialog1.Filter:=sTextFilesFilter;

  OpenDialog2.Filter:=sImagesFilesFilter;
  SaveDialog2.Filter:=sImagesFilesFilter;

  OpenDialog3.Filter:=sHtmlFilesFilter;
  SaveDialog3.Filter:=sHtmlFilesFilter;
end;

procedure TfbmSQLEditor_ShowMemoForm.LoadHTML;
var
  S1: String;
  Strm: TStringStream;
begin
  S1:=DBMemo1.Field.AsString;
  if Pos('<HTML>', UpperCase(S1)) = 0 then
    S1:='<!DOCTYPE HTML public "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'+
      '<HTML>'+
      '<head>'+
        '<title>Поле</title>'+
        '<meta name="author" content="alexs" >'+
        '<meta http-equiv="content-type" content="text/html; charset=UTF-8">'+
      '</head><body>'+
      S1+
      '</body></HTML>';

  Strm := TStringStream.Create(S1);
  FIPHtml.LoadFromStream(Strm);
  Strm.Free;
  //IpHtmlPanel1.SetHtmlFromStr(S1);
end;

procedure TfbmSQLEditor_ShowMemoForm.IpHtmlDataGetImageEvent(
  Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
begin
  //
end;

end.

