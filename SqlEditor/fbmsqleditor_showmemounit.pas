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

unit fbmSQLEditor_ShowMemoUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ButtonPanel, DbCtrls, db;

type

  { TfbmSQLEditor_ShowMemoForm }

  TfbmSQLEditor_ShowMemoForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    Datasource1: TDatasource;
    DBImage1: TDBImage;
    DBMemo1: TDBMemo;
    DBNavigator1: TDBNavigator;
    IpHtmlPanel1: TIpHtmlPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TDBNavButtonType
      );
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    procedure Localize;
    procedure LoadHTML;
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
  Localize;
  PageControl1Change(nil);
end;

procedure TfbmSQLEditor_ShowMemoForm.DBNavigator1BeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if PageControl1.ActivePageIndex = 2 then
    LoadHTML;
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
end;

procedure TfbmSQLEditor_ShowMemoForm.LoadHTML;
var
  S1: String;
begin
  S1:='<!DOCTYPE HTML public "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'+
      '<HTML>'+
      '<head>'+
        '<title>Поле</title>'+
        '<meta name="author" content="alexs" >'+
        '<meta http-equiv="content-type" content="text/html; charset=UTF-8">'+
      '</head><body>'+
      DBMemo1.Field.AsString+
      '</body></HTML>';

  IpHtmlPanel1.SetHtmlFromStr(S1);
end;

end.

