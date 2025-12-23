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

unit mssql_FreeTDSConfig_Unit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Menus, ActnList, ComCtrls, StdCtrls, EditBtn, ExtCtrls, IBManMainUnit,
  rxtoolbar;

const
{$IFNDEF WINDOWS}
  ConfFileName = '/usr/local/etc/freetds.conf';
{$ELSE}
  ConfFileName = '';
{$ENDIF}

type

  { TmssqlFreeTDSConfigForm }

  TmssqlFreeTDSConfigForm = class(TForm)
    alDel: TAction;
    alAdd: TAction;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    FileNameEdit1: TFileNameEdit;
    flSaveAs: TAction;
    flOpen: TAction;
    flSave: TAction;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolPanel1: TToolPanel;
    ToolPanel2: TToolPanel;
    wndClose: TAction;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    procedure alAddExecute(Sender: TObject);
    procedure alDelExecute(Sender: TObject);
    procedure flOpenExecute(Sender: TObject);
    procedure flSaveAsExecute(Sender: TObject);
    procedure flSaveExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure wndCloseExecute(Sender: TObject);
  private
    FConfigFileName:string;
    procedure OpenConfigFile(const AFileName:string);
    procedure SaveConfigFile(const AFileName:string);
    procedure ClearList;
  public
    { public declarations }
  end; 

var
  mssqlFreeTDSConfigForm: TmssqlFreeTDSConfigForm;

procedure ShowTDSConfigForm;
implementation
uses IniFiles, fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

type
  TAliasItem = class
    HostName:string;
    Port:integer;
    TdsVersion:string;
    ClientCharset:string;
{	host = bear.bank\ndoc
	port = 1433
	tds version = 7.0
	client charset = UTF8}

  end;

procedure ShowTDSConfigForm;
begin
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(mssqlFreeTDSConfigForm, TmssqlFreeTDSConfigForm)
end;

{ TmssqlFreeTDSConfigForm }

procedure TmssqlFreeTDSConfigForm.wndCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TmssqlFreeTDSConfigForm.OpenConfigFile(const AFileName: string);
var
  Ini:TIniFile;
  i:integer;
  P:TAliasItem;
  S:string;
begin
(*
  if not FileExistsUTF8(AFileName) then exit;
  FConfigFileName:=AFileName;
  ClearList;
  Ini:=TIniFile.Create(ss AFileName);
  Ini.ReadSections(ListBox1.Items);

  FileNameEdit1.FileName:=Ini.ReadString('global', 'dump file', '');
  Edit4.Text:=Ini.ReadString('global', 'debug flags', '');
  Edit2.Text:=Ini.ReadString('global', 'timeout', '');
  Edit3.Text:=Ini.ReadString('global', 'connect timeout', '');
  Edit1.Text:=Ini.ReadString('global', 'text size', '');

  //Секцию глобальных настроек читать не надо
  i:=ListBox1.Items.IndexOf('global');
  if i>=0 then
    ListBox1.Items.Delete(i);

  //Прочитаем данные по алиасам и запомним их
  for i:=0 to ListBox1.Items.Count - 1 do
  begin
    S:=ListBox1.Items[i];
    P:=TAliasItem.Create;
    ListBox1.Items.Objects[i]:=P;
    P.HostName:=Ini.ReadString(S, 'host', '');
    P.Port:=Ini.ReadInteger(S, 'port', 0);
    P.TdsVersion:=Ini.ReadString(S, 'tds version', '');
    P.ClientCharset:=Ini.ReadString(S, 'client charset', '');
  end;

  Ini.Free;
  //Если алиасы загружены - то выберем первый
  if ListBox1.Items.Count>0 then
  begin
    ListBox1.ItemIndex:=0;
    ListBox1Click(nil);
  end;
*)
end;

procedure TmssqlFreeTDSConfigForm.SaveConfigFile(const AFileName: string);
begin
  FConfigFileName:=AFileName;
end;

procedure TmssqlFreeTDSConfigForm.ClearList;
var
  I:integer;
  P:TAliasItem;
begin
  for i:=0 to ListBox1.Items.Count - 1 do
  begin
    P:=ListBox1.Items.Objects[i] as TAliasItem;
    ListBox1.Items.Objects[i]:=nil;
    if Assigned(P) then
      P.Free;
  end;
  ListBox1.Items.Clear;
end;

procedure TmssqlFreeTDSConfigForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  mssqlFreeTDSConfigForm:=nil;
end;

procedure TmssqlFreeTDSConfigForm.alDelExecute(Sender: TObject);
begin
  if QuestionBox(sFreeTdsDeleteAlias) then
  begin
     //
  end;
end;

procedure TmssqlFreeTDSConfigForm.flOpenExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    OpenConfigFile(OpenDialog1.FileName);
end;

procedure TmssqlFreeTDSConfigForm.flSaveAsExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveConfigFile(SaveDialog1.FileName);
end;

procedure TmssqlFreeTDSConfigForm.flSaveExecute(Sender: TObject);
begin
  SaveConfigFile(FConfigFileName);
end;

procedure TmssqlFreeTDSConfigForm.alAddExecute(Sender: TObject);
begin
//
end;

procedure TmssqlFreeTDSConfigForm.FormCreate(Sender: TObject);
begin
  OpenDialog1.Filter:=sFilesFilterCfg;
  SaveDialog1.Filter:=sFilesFilterCfg;
  OpenConfigFile(ConfFileName);
end;

procedure TmssqlFreeTDSConfigForm.ListBox1Click(Sender: TObject);
var
  P:TAliasItem;
begin
  if (ListBox1.ItemIndex>=0) and (ListBox1.ItemIndex < ListBox1.Items.Count) then
  begin
    P:=ListBox1.Items.Objects[ListBox1.ItemIndex] as TAliasItem;
    Edit5.Text:=P.HostName;
    Edit6.Text:=IntToStr(P.Port);
    ComboBox3.Text:=P.TdsVersion;
    ComboBox2.Text:=P.ClientCharset;
  end
  else
  begin
    Edit5.Text:='';
    Edit6.Text:='';
    ComboBox3.Text:='';
    ComboBox2.Text:='';
  end;
end;

end.

