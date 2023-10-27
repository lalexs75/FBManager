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

unit fbmReportManagerUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, rxtoolbar, LR_View, LR_Class, Forms, Controls,
  Graphics, Dialogs, ComCtrls, ExtCtrls, ActnList, StdCtrls, Menus,
  IBManDataInspectorUnit, SQLEngineAbstractUnit;

type
  TReportFile = class
    FileName:string;
    Loaded:boolean;
    ReportName:string;
    ReportDesc:string;
    ReportCreated:TDateTime;
    ReportModif:TDateTime;
    ReportAutor:string;
    ReportVersion:string;
  end;

type

  { TfbmReportManagerForm }

  TfbmReportManagerForm = class(TForm)
    actDesign: TAction;
    actRefresh: TAction;
    actSelectRoot: TAction;
    actRun: TAction;
    ActionList1: TActionList;
    frPreview1: TfrPreview;
    frReport1: TfrReport;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu1: TPopupMenu;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Splitter1: TSplitter;
    ToolPanel1: TToolPanel;
    TreeView1: TTreeView;
    procedure actDesignExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actSelectRootExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1Deletion(Sender: TObject; Node: TTreeNode);
    procedure TreeView1SelectionChanged(Sender: TObject);
  private
    FShowDesign:boolean;
    FSQLEngine:TSQLEngineAbstract;
    procedure DoRescanReportTree(AFolder: string; AOwner: TTreeNode);
    procedure InternalPrintRecentReport(RepFile:TReportFile);
    procedure DoLoadReportDesc(RepFile:TReportFile);
    procedure SetSQLEngine(AValue: TSQLEngineAbstract);
    procedure Localize;
  public
    property SQLEngine:TSQLEngineAbstract read FSQLEngine write SetSQLEngine;
  end;

procedure ShowReportManager;

implementation
uses fbmToolsUnit, LazUTF8, LazFileUtils, fbmStrConstUnit, IBManMainUnit;


{$R *.lfm}

var
  RMList:TList;

procedure ShowReportManager;
var
  Edt:TfbmReportManagerForm;
  i: Integer;
begin
  if not Assigned(fbManDataInpectorForm.CurrentDB) or not Assigned(fbManDataInpectorForm.CurrentDB.SQLEngine) then exit;
  Edt:=nil;
  for i:=0 to RMList.Count - 1 do
  begin
    if TfbmReportManagerForm(RMList[i]).FSQLEngine = fbManDataInpectorForm.CurrentDB.SQLEngine then
    begin
      exit;
    end;
  end;
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(Edt, TfbmReportManagerForm);
  Edt.SQLEngine:=fbManDataInpectorForm.CurrentDB.SQLEngine;
  Edt.Show;
end;

{ TfbmReportManagerForm }

procedure TfbmReportManagerForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TfbmReportManagerForm.actSelectRootExecute(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    TreeView1.Items.Clear;
    DoRescanReportTree(SelectDirectoryDialog1.FileName, nil);
  end;
end;

procedure TfbmReportManagerForm.actRefreshExecute(Sender: TObject);
begin
  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;
  if Assigned(FSQLEngine) then
    DoRescanReportTree(FSQLEngine.ReportManagerFolder, nil);
  TreeView1.Items.EndUpdate;
  TreeView1SelectionChanged(nil);
end;

procedure TfbmReportManagerForm.actDesignExecute(Sender: TObject);
begin
  try
    FShowDesign:=true;
    TreeView1DblClick(nil);
  finally
    FShowDesign:=false;
  end;
end;

procedure TfbmReportManagerForm.actRunExecute(Sender: TObject);
begin
  FShowDesign:=false;
  TreeView1DblClick(nil);
end;

procedure TfbmReportManagerForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmReportManagerForm.TreeView1DblClick(Sender: TObject);
var
  fData:TReportFile;
begin
  if Assigned(TreeView1.Selected) and (TreeView1.Selected.Data<>nil) then
  begin
    fData:=TReportFile(TreeView1.Selected.Data);
    InternalPrintRecentReport(fData);
  end;
end;

procedure TfbmReportManagerForm.TreeView1Deletion(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.Data<>nil then
  begin
    TReportFile(Node.Data).Free;
    Node.Data:=nil;
  end;
end;

procedure TfbmReportManagerForm.TreeView1SelectionChanged(Sender: TObject);
var
  fData:TReportFile;
begin
  if Assigned(TreeView1.Selected) and (TreeView1.Selected.Data<>nil) then
  begin
    actRun.Enabled:=true;
//    Memo1.Lines.Clear;
    fData:=TReportFile(TreeView1.Selected.Data);
    if not fData.Loaded then
      DoLoadReportDesc(fData);
(*
    Memo1.Lines.Add('Автор   :  '+fData.ReportAutor);
    { TODO : Необходимо доделать в FastReport-е поддержку даты создания и даты изменения отчёта }
{    Memo1.Lines.Add('Создан  : '+DateTimeToStr(fData.ReportCreated));
    Memo1.Lines.Add('Изменён : '+DateTimeToStr(fData.ReportModif));}
    Memo1.Lines.Add('Версия  : '+fData.ReportVersion);
    Memo1.Lines.Add('Описание:');
    Memo1.Lines.Add(fData.ReportDesc);
*)
  end
  else
  begin
//    Memo1.Lines.Clear;
    actRun.Enabled:=false;
  end;
end;

procedure TfbmReportManagerForm.DoRescanReportTree(AFolder: string;
  AOwner: TTreeNode);
var
  Rec:TSearchRec;
  Code:integer;
  Node:TTreeNode;
  fData:TReportFile;
  S:string;
begin
  S:=AFolder + DirectorySeparator + AllFilesMask1;
  Code:= FindFirst(S, faAnyFile, Rec);
  while Code = 0 do
  begin
    if (Rec.Attr and faHidden) = 0 then
    begin
      if (Rec.Attr and faDirectory)<>0 then
      begin
        if (Rec.Name<>'.') and (Rec.Name<>'..') then
        begin
          Node:=TreeView1.Items.AddChild(AOwner, MenuItemStr(SysToUTF8(Rec.Name)));
          Node.ImageIndex:=26;
          Node.SelectedIndex:=26;
          Node.StateIndex:=26;
          S:=AFolder + DirectorySeparator + Rec.Name;
          DoRescanReportTree(S, Node);
        end;
      end
      else
      begin
        if CompareText(ExtractFileExt(Rec.Name), '.LRF')=0 then
        begin
          Node:=TreeView1.Items.AddChild(AOwner,  MenuItemStr(SysToUTF8(Rec.Name))); //Copy(Rec.Name, 1, Length(Rec.Name)+4));
          Node.ImageIndex:=8;
          Node.SelectedIndex:=8;
          Node.StateIndex:=8;
          fData:=TReportFile.Create;
          Node.Data:=fData;
          fData.FileName:=SysToUTF8(AFolder + DirectorySeparator + Rec.Name);
          if not Assigned(TreeView1.Selected) then
            TreeView1.Selected:=Node;
        end;
      end;
    end;
    Code:=FindNext(Rec);
  end;
  FindClose(Rec);
end;

procedure TfbmReportManagerForm.InternalPrintRecentReport(RepFile: TReportFile);
begin
  frReport1.Pages.Clear;
  if FileExists(RepFile.FileName) then
    frReport1.LoadFromFile(RepFile.FileName)
  else
    frReport1.FileName:=RepFile.FileName;
  frReport1.Title:=RepFile.FileName;

  if FShowDesign then
    frReport1.DesignReport
  else
    frReport1.ShowReport;

  if FShowDesign then
  begin
    RepFile.Loaded:=false;
    TreeView1SelectionChanged(nil);
  end;
end;

procedure TfbmReportManagerForm.DoLoadReportDesc(RepFile: TReportFile);
var
  XML: TLrXMLConfig;
  Path:string;
begin
  Path:='LazReport/';
  XML:=TLrXMLConfig.Create(nil);
  try
    XML.Filename :=RepFile.FileName;

    RepFile.ReportName:= XML.GetValue(Path+'Title/Value', '');
    RepFile.ReportDesc:=XML.GetValue(Path+'Comments/Value', '');
{    RepFile.ReportCreated:=frReportTmp.ReportCreateDate;
    RepFile.ReportModif:=frReportTmp.ReportLastChange;}
    RepFile.ReportAutor:=XML.GetValue(Path+'ReportAutor/Value'{%H-}, '');
    RepFile.ReportVersion:=XML.GetValue(Path+'ReportVersionMajor/Value', '') + '.'+
                         XML.GetValue(Path+'ReportVersionMinor/Value', '') + '.'+
                         XML.GetValue(Path+'ReportVersionRelease/Value', '') + '.'+
                         XML.GetValue(Path+'ReportVersionBuild/Value', '');
    RepFile.Loaded:=true;
  finally
    XML.Free;
  end;
end;

procedure TfbmReportManagerForm.SetSQLEngine(AValue: TSQLEngineAbstract);
begin
  if FSQLEngine=AValue then Exit;
  FSQLEngine:=AValue;
  if DirectoryExistsUTF8(FSQLEngine.ReportManagerFolder) then
  begin
    TreeView1.Items.Clear;
    DoRescanReportTree(FSQLEngine.ReportManagerFolder, nil);
  end;
end;

procedure TfbmReportManagerForm.Localize;
begin
  Caption:=sReportManager;
  actRun.Caption:=sRun;
  actDesign.Caption:=sDesignReport;
  actSelectRoot.Caption:=sSelectRootFolder;
  actRefresh.Caption:=sRefresh;
end;

initialization
  RMList:=TList.Create;
finalization
  FreeAndNil(RMList);
end.

