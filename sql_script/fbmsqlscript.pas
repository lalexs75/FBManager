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
unit fbmsqlscript;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, {XMLConf, }LResources, Forms, Controls, Graphics, Dialogs,
  ActnList, rxtoolbar, Menus, SynEdit, LMessages, StdCtrls, ExtCtrls, LCLType,
  ComCtrls, fbmToolsUnit, fdbm_SynEditorUnit, ibmanagertypesunit, sqlObjects,
  SQLEngineAbstractUnit, SQLEngineCommonTypesUnit;

type
  TStamentRecord = class
    PosStart:TPoint;
    PosEnd:TPoint;
  end;

  { TFBMSqlScripForm }

  TFBMSqlScripForm = class(TForm)
    scriptStop: TAction;
    Label1: TLabel;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    objTreeRefresh: TAction;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    objTreeShowDML: TAction;
    objTreeDeleteCmd: TAction;
    objTreeCommentCmd: TAction;
    CheckBox1: TCheckBox;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    ProgressBar1: TProgressBar;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    TreeView1: TTreeView;
    vShowObjTree: TAction;
    fileSaveAs: TAction;
    dbConnection: TAction;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    scriptRun: TAction;
    fileSave: TAction;
    fileOpen: TAction;
    ActionList1: TActionList;
    Splitter1: TSplitter;
    ToolPanel1: TToolPanel;
    procedure fileOpenExecute(Sender: TObject);
    procedure fileSaveAsExecute(Sender: TObject);
    procedure fileSaveExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure objTreeCommentCmdExecute(Sender: TObject);
    procedure objTreeDeleteCmdExecute(Sender: TObject);
    procedure objTreeRefreshExecute(Sender: TObject);
    procedure objTreeShowDMLExecute(Sender: TObject);
    procedure scriptRunExecute(Sender: TObject);
    procedure scriptStopExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1Deletion(Sender: TObject; Node: TTreeNode);
    procedure vShowObjTreeExecute(Sender: TObject);
  private
    FCurDB:TDataBaseRecord;
    EditorFrame:Tfdbm_SynEditorFrame;
    CurCmd:integer;
    FAbortExecute:Boolean;

    procedure TextEditorKeyPress(Sender: TObject; var Key: char);
    procedure DBMenuClick(Sender: TObject);
    procedure DoFillDatabaseList;
    procedure DoConnectCurrentDB;
    function OnExecuteSqlScriptProcessEvent(const AMsg:string; ALineNum:integer; SQLToken:TSQLToken):boolean;
    procedure AddToRecent(const AFileName:string);
    procedure UpdateRecentMenu(AClearMenu:boolean);
    procedure miRecentClick(Sender: TObject);
    procedure Localize;
    procedure UpdateTreeVisible;
    procedure EditorFrameGetFieldsList(Sender:Tfdbm_SynEditorFrame; const DBObjName:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    procedure EditorFrameGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    function EditorFrameOnGetDBObjectByAlias(Sender:Tfdbm_SynEditorFrame; const ATableAlias:string; out DBObjName:string):TDBObject;
    procedure ReloadTree;
    procedure UpdateFileName;
    procedure UpdateTimer;
    procedure UpdateScriptControls(ARun:boolean);

    function OTSelected:TStamentRecord;
  public
    procedure LMEditorChangeParams(var message: TLMNoParams); message LM_EDITOR_CHANGE_PARMAS;
    procedure ChangeVisualParams;
    procedure SetSQLText(ASQL:string);
  end;

var
  FBMSqlScripForm: TFBMSqlScripForm = nil;

implementation
uses IBManDataInspectorUnit, LCLProc, rxAppUtils, fbmStrConstUnit, rxlogging,
  fbmUserDataBaseUnit, fbmRefreshObjTreeUnit, fbmSqlParserUnit, FBSQLEngineUnit;

{$R *.lfm}

{ TFBMSqlScripForm }

procedure TFBMSqlScripForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FBMSqlScripForm:=nil;
  CloseAction:=caFree;
end;

procedure TFBMSqlScripForm.FormCloseQuery(Sender: TObject; var CanClose: boolean
  );
var
  R:integer;
begin
  if EditorFrame.Modified then
  begin
    R:=QuestionBoxExt(sScriptTextModified);
    case R of
      ID_YES:fileSave.Execute;
      ID_CANCEL:CanClose:=false;
    end;
  end;
end;

procedure TFBMSqlScripForm.fileSaveExecute(Sender: TObject);
begin
  EditorFrame.edtSave.Execute;
  UpdateFileName;
end;

procedure TFBMSqlScripForm.fileOpenExecute(Sender: TObject);
begin
  EditorFrame.edtOpen.Execute;
  AddToRecent(EditorFrame.FileName);
  UpdateFileName;
  if vShowObjTree.Checked then
    Timer1.Enabled:=true;
end;

procedure TFBMSqlScripForm.fileSaveAsExecute(Sender: TObject);
begin
  EditorFrame.edtSaveAs.Execute;
  AddToRecent(EditorFrame.FileName);
  UpdateFileName;
end;

procedure TFBMSqlScripForm.FormCreate(Sender: TObject);
begin
  Localize;
  UpdateScriptControls(false);
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Parent:=Self;
//  EditorFrame.OnLoadFileEdit:=@OnLoadFile;

  EditorFrame.OnGetFieldsList:=@EditorFrameGetFieldsList;

  EditorFrame.OnGetKeyWordList:=@EditorFrameGetKeyWordList;
  EditorFrame.OnGetDBObjectByAlias:=@EditorFrameOnGetDBObjectByAlias;
  EditorFrame.TextEditor.OnKeyPress:=@TextEditorKeyPress;

  Memo1.Lines.Clear;
  DoFillDatabaseList;
  DoConnectCurrentDB;
  ChangeVisualParams;
  UpdateTreeVisible;
end;

procedure TFBMSqlScripForm.objTreeCommentCmdExecute(Sender: TObject);
var
  R: TStamentRecord;
begin
  R:=OTSelected;
  if not Assigned(R) then exit;
  EditorFrame.TextInsert(R.PosEnd.x,R.PosEnd.y, ' ' + SysCommentStyle + '*/');
  EditorFrame.TextInsert(R.PosStart.x,R.PosStart.y, '/*'+SysCommentStyle + ' ');
  ReloadTree;
end;

procedure TFBMSqlScripForm.objTreeDeleteCmdExecute(Sender: TObject);
var
  R: TStamentRecord;
begin
  R:=OTSelected;
  if not Assigned(R) then exit;
  EditorFrame.TextEditor.BeginUpdate;
  EditorFrame.TextEditor.BlockBegin:=TStamentRecord(TreeView1.Selected.Data).PosStart;
  EditorFrame.TextEditor.BlockEnd:=TStamentRecord(TreeView1.Selected.Data).PosEnd;
  EditorFrame.TextEditor.SelText:='';
  EditorFrame.TextEditor.EndUpdate;
  ReloadTree;
end;

procedure TFBMSqlScripForm.objTreeRefreshExecute(Sender: TObject);
begin
  ReloadTree;
end;

procedure TFBMSqlScripForm.objTreeShowDMLExecute(Sender: TObject);
begin
  objTreeShowDML.Checked:=not objTreeShowDML.Checked;
  ReloadTree;
end;

procedure TFBMSqlScripForm.scriptRunExecute(Sender: TObject);
var
  ObjRefresh:TObjTreeRefresh;
procedure DoParseScript(S:string);
var
  P: TSQLParser;
  Stm: TSQLTextStatement;
  i: Integer;
begin
  P:=TSQLParser.Create(S, FCurDB.SQLEngine);
  if (FCurDB.SQLEngine is TSQLEngineFireBird) then
    P.ParserSintax:=siFirebird;
  try
    P.ParseScript;
    for i:=0 to P.StatementCount-1 do
    begin
      Stm:=P.Statements[i];
      ObjRefresh.ProcessCommand(Stm.SQLCommand);
    end;
    ProgressBar1.Max:=P.StatementCount;
  finally
    P.Free;
  end;
end;

var
  S: String;
  FStartTime: TDateTime;
begin
  ObjRefresh:=TObjTreeRefresh.Create(FCurDB);
  FStartTime:=Now;
  if Assigned(FCurDB) then
  begin
    FAbortExecute:=false;
    UpdateScriptControls(true);
    Memo1.Lines.Clear;
    ProgressBar1.Position:=1;
    try
      CurCmd:=1;

      S:=EditorFrame.TextEditor.SelText;
      if S = '' then
        S:=EditorFrame.TextEditor.Text;

      DoParseScript(S);

      EditorFrame.SQLEngine.ExecuteSQLScript(S, @OnExecuteSqlScriptProcessEvent);
      ShowMessageFmt(sExecutionComplete, [TimeToStr(Now - FStartTime)]);
    except
      on E:Exception do
      begin
        Memo1.Text:=E.Message;
      end;
    end;
    UpdateScriptControls(false);
  end;
  UpdateFileName;
  ObjRefresh.Execute;
  ObjRefresh.Free;
end;

procedure TFBMSqlScripForm.scriptStopExecute(Sender: TObject);
begin
  FAbortExecute:=true;
  scriptStop.Enabled:=false;
end;

procedure TFBMSqlScripForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  ReloadTree;
end;

procedure TFBMSqlScripForm.TreeView1Click(Sender: TObject);
var
  R: TStamentRecord;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
  begin
    R:=TStamentRecord(TreeView1.Selected.Data);
    if (EditorFrame.TextEditor.TopLine + EditorFrame.TextEditor.LinesInWindow) < R.PosStart.y then
      EditorFrame.TextEditor.TopLine := R.PosStart.y
    else
    if EditorFrame.TextEditor.TopLine > R.PosEnd.y then
      EditorFrame.TextEditor.TopLine := R.PosStart.y;


    EditorFrame.TextEditor.BeginUpdate;
    EditorFrame.TextEditor.BlockBegin:=R.PosStart;
    EditorFrame.TextEditor.BlockEnd:=R.PosEnd;
    EditorFrame.TextEditor.EndUpdate;
    Memo1.Lines.Add(Format('%d:%d -- %d:%d'#13'%s', [R.PosStart.X,
                                              R.PosStart.y,
                                              R.PosEnd.X,
                                              R.PosEnd.Y,
                                              TreeView1.Selected.Text
                                             ]));
  end;
end;

procedure TFBMSqlScripForm.TreeView1Deletion(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) and Assigned(Node.Data) then
    TStamentRecord(Node.Data).Free;
end;

procedure TFBMSqlScripForm.vShowObjTreeExecute(Sender: TObject);
begin
  vShowObjTree.Checked:=not vShowObjTree.Checked;
  UpdateTreeVisible;
end;

procedure TFBMSqlScripForm.TextEditorKeyPress(Sender: TObject; var Key: char);
begin
  if Assigned(EditorFrame) then
    EditorFrame.TextEditorKeyPress(EditorFrame, Key);
  if CheckBox1.Checked then
    UpdateTimer;;
end;

procedure TFBMSqlScripForm.DBMenuClick(Sender: TObject);
begin
  dbConnection.Caption:=(Sender as TMenuItem).Caption;
  dbConnection.Tag:=(Sender as TMenuItem).Tag;
  FCurDB:=TDataBaseRecord(fbManDataInpectorForm.DBList[dbConnection.Tag]);
  EditorFrame.SQLEngine:=FCurDB.SQLEngine;
  UpdateRecentMenu(true);
end;

procedure TFBMSqlScripForm.DoFillDatabaseList;
var
  i:integer;
  M:TMenuItem;
begin
  PopupMenu1.Items.Clear;
  for i:=0 to fbManDataInpectorForm.DBList.Count - 1 do
  begin
    M:=TMenuItem.Create(Self);
    M.Caption:=TDBInspectorRecord(fbManDataInpectorForm.DBList[i]).Caption;
    M.OnClick:=@DBMenuClick;
    M.Tag:=i;
    M.ImageIndex:=1 +ord(TDataBaseRecord(fbManDataInpectorForm.DBList[i]).Connected);
    PopupMenu1.Items.Add(M);
  end;
end;

procedure TFBMSqlScripForm.DoConnectCurrentDB;
var
  i:integer;
  M:TMenuItem;
begin
  for i:=0 to fbManDataInpectorForm.DBList.Count - 1 do
    if fbManDataInpectorForm.DBList[i] = fbManDataInpectorForm.CurrentDB then
    begin
      M:=PopupMenu1.Items[i];
      if Assigned(M) then
        M.Click;
    end;
end;

function TFBMSqlScripForm.OnExecuteSqlScriptProcessEvent(const AMsg: string;
  ALineNum: integer; SQLToken: TSQLToken): boolean;
begin
  inc(CurCmd);
  StatusBar1.SimpleText:=IntToStr(ALineNum);
  StatusBar1.Repaint;
  Memo1.Text:=AMsg;
  Result:=not FAbortExecute;
  ProgressBar1.Position:=CurCmd;
  Application.ProcessMessages;
end;

procedure TFBMSqlScripForm.AddToRecent(const AFileName: string);
begin
  if Assigned(FCurDB) and FCurDB.Connected then
    FCurDB.RecentSQLScrip.Add(AFileName);
  UpdateRecentMenu(true);
end;

procedure TFBMSqlScripForm.UpdateRecentMenu(AClearMenu: boolean);
var
  i:integer;
  M:TMenuItem;
begin
  if AClearMenu then
  begin
    PopupMenu2.Items.Clear;
  end;

  if Assigned(FCurDB) and FCurDB.Connected then
  begin
    if FCurDB.RecentSQLScrip.Count = 0 then
      FCurDB.RecentSQLScrip.Refresh;

    while (PopupMenu2.Items.Count<FCurDB.RecentSQLScrip.Count) do
    begin
      M:=TMenuItem.Create(PopupMenu2);
      M.OnClick:=@miRecentClick;
      PopupMenu2.Items.Add(M);
    end;

    for i:=0 to FCurDB.RecentSQLScrip.Count-1 do
    begin
      PopupMenu2.Items[i].Caption:=FCurDB.RecentSQLScrip[i];
      PopupMenu2.Items[i].Tag:=i; //FCurDB.RecentSQLScrip.Data[i];
    end;
  end;
end;

procedure TFBMSqlScripForm.miRecentClick(Sender: TObject);
var
  i:integer;
begin
  i:=(Sender as TComponent).Tag;
  if (i>=0) and (i <= FCurDB.RecentSQLScrip.Count) then
    EditorFrame.OpenFile(FCurDB.RecentSQLScrip[i]);
  UpdateFileName;
end;

procedure TFBMSqlScripForm.Localize;
begin
  Caption:=sMenuSqlScript;
  fileOpen.Caption:=sOpenFile;
  fileOpen.Hint:=sOpenFileHint;
  scriptRun.Caption:=sRun;
  scriptRun.Hint:=sRunScriptHint;
  scriptStop.Caption:=sStop;
  scriptStop.Hint:=sStopHint;

  fileSave.Caption:=sSaveFile;
  fileSave.Hint:=sSaveFileHint;
  fileSaveAs.Caption:=sSaveAs;
  fileSaveAs.Hint:=sSaveAsHint;
  dbConnection.Caption:=sDatabase;
  dbConnection.Hint:=sDatabaseHint;
  vShowObjTree.Caption:=sShowObjTree;
  vShowObjTree.Hint:=sShowObjTreeHint;
  objTreeCommentCmd.Caption:=sCommentCmd;
  objTreeCommentCmd.Hint:=sCommentCmdHint;
  objTreeDeleteCmd.Caption:=sDeleteCmd;
  objTreeDeleteCmd.Hint:=sDeleteCmdHint;
  objTreeShowDML.Caption:=sShowDML;
  objTreeShowDML.Hint:=sShowDMLHint;
  objTreeRefresh.Caption:=sRefresh;
  objTreeRefresh.Hint:=sRefreshHint;
end;

procedure TFBMSqlScripForm.UpdateTreeVisible;
begin
  Splitter2.Visible:=vShowObjTree.Checked;
  TreeView1.Visible:=vShowObjTree.Checked;

  Timer1.Enabled:=vShowObjTree.Checked;
{  if TreeView1.Visible then
    ReloadTree;}
end;

procedure TFBMSqlScripForm.EditorFrameGetFieldsList(
  Sender: Tfdbm_SynEditorFrame; const DBObjName: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
  P: TSQLParser;
  i:integer;
  DBObj:TDBObject;
  FSt: TSQLTextStatement;
  F: TDBField;
begin
  P:=TSQLParser.Create(EditorFrame.EditorText, FCurDB.SQLEngine);
  P.ParseScript;
  FSt:=P.StatementAtXY(EditorFrame.TextEditor.CaretX, EditorFrame.TextEditor.CaretY);
  if Assigned(FSt) and Assigned(FSt.SQLCommand) and (FSt.SQLCommand is TSQLCommandAbstractSelect) then
  begin
    for i:=0 to TSQLCommandAbstractSelect(FSt.SQLCommand).Tables.Count - 1 do
    begin
      if UpperCase(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].TableAlias) = UpperCase(DBObjName) then
      begin
        DBObj:=FCurDB.GetDBObject(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].Name);
        if Assigned(DBObj) and (DBObj.DBObjectKind in [okTable, okView, okStoredProc]) then
          Items.FillFieldList(DBObj);
      end;
    end;
  end;
  P.Free;
end;

procedure TFBMSqlScripForm.EditorFrameGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
var
//  B:TSQLCommandExecuteBlock;
  S:string;
  i:integer;
  DBObj:TDBObject;
  L:TLocalVariable;
  P: TSQLParser;
  FSt: TSQLTextStatement;
begin
  if not Assigned(FCurDB) then exit;
  P:=TSQLParser.Create(EditorFrame.EditorText, FCurDB.SQLEngine);
  P.ParseScript;
  FSt:=P.StatementAtXY(EditorFrame.TextEditor.CaretX, EditorFrame.TextEditor.CaretY);

  if Assigned(FSt) and Assigned(FSt.SQLCommand) then
  begin
    S:=FSt.SQLCommand.AsSQL;

    rxWriteLog(etDebug, S);

    if (FSt.SQLCommand is TSQLCommandAbstractSelect) then
    begin
      for i:=0 to TSQLCommandAbstractSelect(FSt.SQLCommand).Tables.Count - 1 do
      begin
        DBObj:=FCurDB.GetDBObject(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].Name);
{        if Assigned(DBObj) and (DBObj.DBObjectKind in [okTable, okView, okStoredProc]) then
             DBObj.FillFieldList(Items, ACharCase, false)}
        if Assigned(DBObj) then
          Items.FillFieldList(DBObj);
      end;
    end
{    else
    if FSt.SQLCommand is TSQLCommandExecuteBlock then
    begin
      B:=TSQLCommandExecuteBlock(FSt.SQLCommand);
      for i:=0 to B.ParamsCount - 1 do
      begin
        L:=TLocalVariable.CreateFrom(B.Params[i]);
        Items.Add(L.VarName);
        Items.Objects[Items.Count-1]:=L;
      end;
      for i:=0 to B.Fields.Count - 1 do
      begin
        L:=TLocalVariable.CreateFrom(B.Fields[i]);
        Items.Add(L.VarName);
        Items.Objects[Items.Count-1]:=L;
      end;
    end;}
  end;
  P.Free;
end;

function TFBMSqlScripForm.EditorFrameOnGetDBObjectByAlias(
  Sender: Tfdbm_SynEditorFrame; const ATableAlias: string; out DBObjName: string
  ): TDBObject;
var
  i:integer;
  P: TSQLParser;
  FSt: TSQLTextStatement;
begin
  Result:=nil;
  DBObjName:='';

  P:=TSQLParser.Create(EditorFrame.EditorText, FCurDB.SQLEngine);
  P.ParseScript;
  FSt:=P.StatementAtXY(EditorFrame.TextEditor.CaretX, EditorFrame.TextEditor.CaretY);
  if Assigned(FSt) and Assigned(FSt.SQLCommand) and (FSt.SQLCommand is TSQLCommandAbstractSelect) then
  begin
    for i:=0 to TSQLCommandAbstractSelect(FSt.SQLCommand).Tables.Count - 1 do
    begin
      if UpperCase(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].TableAlias) = UpperCase(ATableAlias) then
      begin
        Result:=FCurDB.GetDBObject(TSQLCommandAbstractSelect(FSt.SQLCommand).Tables[i].Name);
        if Assigned(Result) then
        begin
          DBObjName:=Result.Caption;
          break;
        end;
      end;
    end;
  end;
  P.Free;
end;

procedure TFBMSqlScripForm.ReloadTree;
var
  P: TSQLParser;
  i: Integer;
  FSt: TSQLTextStatement;
  S: String;
  T: TTreeNode;
  R: TStamentRecord;
begin
  if not Assigned(FCurDB) then exit;
  TreeView1.Items.Clear;
  try
    P:=TSQLParser.Create(EditorFrame.EditorText, FCurDB.SQLEngine);
    if (FCurDB.SQLEngine is TSQLEngineFireBird) then
      P.ParserSintax:=siFirebird;
    P.ParseScript;
    for i:=0 to P.StatementCount-1 do
    begin
      FSt:=P.Statements[i];
      if Assigned(FSt) and Assigned(FSt.SQLCommand) then
      begin
        if objTreeShowDML.Checked or not (FSt.SQLCommand is TSQLCommandAbstractSelect) then
        begin
          S:=TrimRight(FSt.SQLCommand.AsSQL);
          T:=TreeView1.Items.Add(nil, S);
          R:=TStamentRecord.Create;
          R.PosStart:=FSt.PosStart;
          R.PosEnd:=FSt.PosEnd;
          T.Data:=R;
        end;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure TFBMSqlScripForm.UpdateFileName;
begin
  StatusBar1.SimpleText:=EditorFrame.FileName;
end;

procedure TFBMSqlScripForm.UpdateTimer;
begin
  if not CheckBox1.Checked then exit;
  Timer1.Enabled:=false;
  Timer1.Enabled:=true;
end;

procedure TFBMSqlScripForm.UpdateScriptControls(ARun: boolean);
begin
  scriptRun.Enabled:=not ARun;
  scriptStop.Enabled:=ARun;
  ProgressBar1.Visible:=ARun;
  CheckBox1.Visible:=not ARun;
  fileOpen.Enabled:=not ARun;
  fileSave.Enabled:=not ARun;
  fileSaveAs.Enabled:=not ARun;
  dbConnection.Enabled:=not ARun;
  vShowObjTree.Enabled:=not ARun;
  objTreeCommentCmd.Enabled:=not ARun;
  objTreeDeleteCmd.Enabled:=not ARun;
  objTreeShowDML.Enabled:=not ARun;
  objTreeRefresh.Enabled:=not ARun;
end;

function TFBMSqlScripForm.OTSelected: TStamentRecord;
begin
  if Assigned(TreeView1.Selected) and Assigned(TreeView1.Selected.Data) then
    Result:=TStamentRecord(TreeView1.Selected.Data)
  else
    Result:=nil;
end;

procedure TFBMSqlScripForm.LMEditorChangeParams(var message: TLMNoParams);
begin
  inherited;
  ChangeVisualParams;
end;

procedure TFBMSqlScripForm.ChangeVisualParams;
begin
  EditorFrame.ChangeVisualParams;
end;

procedure TFBMSqlScripForm.SetSQLText(ASQL: string);
begin
  EditorFrame.EditorText:=ASQL;
end;

end.

