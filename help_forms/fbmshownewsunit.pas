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

unit fbmShowNewsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, ComCtrls, ActnList,
  Menus, rxtoolbar, IpHtml;

type

  { TfbmShowNewsForm }

  TfbmShowNewsForm = class(TForm)
    MenuItem5: TMenuItem;
    newsRefresh: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    wndClose: TAction;
    Action2: TAction;
    ActionList1: TActionList;
    IpHtmlPanel1: TIpHtmlPanel;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    ToolPanel1: TToolPanel;
    procedure FormCreate(Sender: TObject);
    procedure newsRefreshExecute(Sender: TObject);
    procedure wndCloseExecute(Sender: TObject);
  private
    //
  public
    { public declarations }
  end; 

procedure ShowNews;
implementation
uses fbmFileProviderUnit, fbmToolsUnit, {DOM, XMLRead,} SQLEngineCommonTypesUnit,
  IBManMainUnit;

{$R *.lfm}

var
  fbmShowNewsForm: TfbmShowNewsForm;

procedure ShowNews;
begin
  if not Assigned(fbmShowNewsForm) then
    fbManagerMainForm.ChildWindowsCreate(fbmShowNewsForm, TfbmShowNewsForm)
  else
    fbManagerMainForm.ChildWindowsShow(fbmShowNewsForm);
end;

{ TfbmShowNewsForm }

procedure TfbmShowNewsForm.FormCreate(Sender: TObject);
begin
(*  IpHtmlPanel1.Align:=alClient;
  IpHtmlPanel1.DataProvider:=TFileDataProvider.Create(Self);
  Gate1.CA := AppendPathDelim(ExtractFileDir(ParamStr(0))) + 'ca-bundle';
  Gate1.authorize('test', 'test');
  newsRefreshExecute(nil); *)
end;

procedure TfbmShowNewsForm.newsRefreshExecute(Sender: TObject);
var
  S:string;
  MemF:TMemoryStream;
  ADoc: TXMLDocument;
  AStrList:TStringList;

procedure DoParceItem(Node: TDOMNode);
var
  S:string;
begin
  S:='<H1>'+Node.FindNode('title').TextContent+'<hr></H1>'+LineEnding+
     Node.FindNode('link').TextContent+'<br>'+LineEnding+
     Node.FindNode('pubDate').TextContent+'<br>'+LineEnding+
     Node.FindNode('description').TextContent+'<br>'+LineEnding+
     '<BR><BR>';
  AStrList.Add(SysToUTF8(S));
end;

procedure ParseRSS;
var
  i:integer;
  Node:TDOMNode;
  DOMNodeList:TDOMNodeList;
begin
  Node:=ADoc.FindNode('rss');

  if Assigned(Node) then
    Node:=Node.FindNode('channel');

  if Assigned(Node) then
  begin
    DOMNodeList:=Node.GetChildNodes;

    for i:=0 to DOMNodeList.Count - 1 do
    begin
      Node:=DOMNodeList[i];
      if Assigned(Node) then
      begin
        if Node.NodeName = 'item' then
          DoParceItem(Node);
      end;
    end;
  end;
end;

begin
  S:=LocalCfgFolder+'news.html';
  MemF:=TMemoryStream.Create;
//
//  MemF.LoadFromFile('/home/alexs/aaa.rss');
//
  Gate1.SaveToStream(netProgectRSS, MemF);
  MemF.Position:=0;
  ReadXMLFile(ADoc, MemF);
//  MemF.SaveToFile('/home/alexs/aaa11.rss');
  MemF.Free;

  AStrList:=TStringList.Create;

  AStrList.Add('<html>');
  AStrList.Add('  <head>');
  AStrList.Add('    <title>FBManager - новости</title>');
  AStrList.Add('    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">');
  AStrList.Add('  </head>');
  AStrList.Add('  <body>');

  ParseRSS;
  AStrList.SaveToFile(S);
  AStrList.Free;

  IpHtmlPanel1.OpenURL(S);
end;

procedure TfbmShowNewsForm.wndCloseExecute(Sender: TObject);
begin
  Close;
end;

end.

