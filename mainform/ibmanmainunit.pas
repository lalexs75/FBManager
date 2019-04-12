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

unit IBManMainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Dialogs, ComCtrls, ExtCtrls,
  ActnList, Menus, fbmToolsUnit, fbmExtractUnit, fbmReportManagerUnit,
  rxtoolbar, RxSortFBDataSet, RxSortZeos, RxMDI, RxIniPropStorage, fpsexport,
  fpdataexporter, LR_Class, LR_E_TXT, LR_E_HTM, LR_Desgn, LR_BarC, LR_RRect,
  LR_Shape, LR_ChBox, LR_E_CSV, lr_CrossTab, lrAddFunctionLibrary, LR_e_htmldiv,
  LR_e_img, lr_e_cairo, lrEmailExportFilter, LRDialogControls, lrOfficeImport,
  LR_DB_Zeos, lrSpreadSheetExp, lrPDFExport, LazHelpHTML, StdCtrls, Buttons,
  fdbm_SynEditorUnit;

type

  { TfbManagerMainForm }

  TfbManagerMainForm = class(TForm)
    BookmarkImages: TImageList;
    ilDBObjects: TImageList;
    ImageListMain: TImageList;
    lrCrossObject1: TlrCrossObject;
    LRDialogControls1: TLRDialogControls;
    lrEmailExportFilter1: TlrEmailExportFilter;
    lrOfficeImport1: TlrOfficeImport;
    lrPDFExport1: TlrPDFExport;
    lrSpreadSheetExport1: TlrSpreadSheetExport;
    lrZeosData1: TlrZeosData;
    MenuItem35: TMenuItem;
    tmRegister: TPopupMenu;
    tlsReportManager: TAction;
    MenuItem34: TMenuItem;
    tlsExtractMetadata: TAction;
    frHtmlDivExport1: TfrHtmlDivExport;
    frImageExport1: TfrImageExport;
    Label1: TLabel;
    lrCairoExport1: TlrCairoExport;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    InspectorCloseButton: TSpeedButton;
    InspectorPanel: TPanel;
    Panel1: TPanel;
    RxIniPropStorage1: TRxIniPropStorage;
    RxMDICloseButton1: TRxMDICloseButton;
    RxMDIPanel1: TRxMDIPanel;
    RxMDITasks1: TRxMDITasks;
    RxSortFBDataSet1: TRxSortFBDataSet;
    RxSortZeos1: TRxSortZeos;
    Splitter1: TSplitter;
    tlsSearchInMetadata: TAction;
    frCSVExport1: TfrCSVExport;
    lrAddFunctionLibrary1: TlrAddFunctionLibrary;
    MenuItem31: TMenuItem;
    optObjectTemplates: TAction;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    tlsSqlBuilder: TAction;
    MenuItem25: TMenuItem;
    optKeyboardTemplates: TAction;
    hlpVisitToWebSite: TAction;
    hlpSendBugreport: TAction;
    hlpNews: TAction;
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem9: TMenuItem;
    wndCloseAll: TAction;
    dbRefresh: TAction;
    frBarCodeObject1: TfrBarCodeObject;
    frCheckBoxObject1: TfrCheckBoxObject;
    frHTMExport1: TfrHTMExport;
    frReport1: TfrReport;
    frRoundRectObject1: TfrRoundRectObject;
    frShapeObject1: TfrShapeObject;
    frTextExport1: TfrTextExport;
    MenuItem28: TMenuItem;
    tlsSqlScript: TAction;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    optCustomizeToolbar: TAction;
    ImageList2: TImageList;
    WindowItems: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    ToolPanel1: TToolPanel;
    wndReOrder: TAction;
    dbDisconnect: TAction;
    dbConnect: TAction;
    optEnironment: TAction;
    dbRegister: TAction;
    dbUnregister: TAction;
    dbCreate: TAction;
    optEditors: TAction;
    ApplicationProperties1: TApplicationProperties;
    MenuItem12: TMenuItem;
    miCreateDB: TMenuItem;
    miRegisterDB: TMenuItem;
    MenuItem16: TMenuItem;
    StatusBar1: TStatusBar;
    tlsSQLEditor: TAction;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    tlsDBInspector: TAction;
    MenuItem8: TMenuItem;
    hlpAbout: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    sysExit: TAction;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception);
    procedure ApplicationProperties1Hint(Sender: TObject);
    procedure ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
    procedure dbConnectExecute(Sender: TObject);
    procedure dbCreateExecute(Sender: TObject);
    procedure dbDisconnectExecute(Sender: TObject);
    procedure dbRefreshExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure hlpNewsExecute(Sender: TObject);
    procedure hlpSendBugreportExecute(Sender: TObject);
    procedure hlpVisitToWebSiteExecute(Sender: TObject);
    procedure IBManagerMainFormCreate(Sender: TObject);
    procedure InspectorCloseButtonClick(Sender: TObject);
    procedure optKeyboardTemplatesExecute(Sender: TObject);
    procedure optObjectTemplatesExecute(Sender: TObject);
    procedure Speedbutton4Click(Sender: TObject);
    procedure dbRegisterExecute(Sender: TObject);
    procedure dbUnregisterExecute(Sender: TObject);
    procedure hlpAboutExecute(Sender: TObject);
    procedure optCustomizeToolbarExecute(Sender: TObject);
    procedure optEditorsExecute(Sender: TObject);
    procedure optEnironmentExecute(Sender: TObject);
    procedure sysExitExecute(Sender: TObject);
    procedure tlsDBInspectorExecute(Sender: TObject);
    procedure tlsExtractMetadataExecute(Sender: TObject);
    procedure tlsReportManagerExecute(Sender: TObject);
    procedure tlsSearchInMetadataExecute(Sender: TObject);
    procedure tlsSqlBuilderExecute(Sender: TObject);
    procedure tlsSQLEditorExecute(Sender: TObject);
    procedure tlsSqlScriptExecute(Sender: TObject);
    procedure wndCloseAllExecute(Sender: TObject);
  private
    procedure MakeToolsMenu;
    procedure Localize;
    procedure DoLoadPrefs;
  public
    procedure TabsActiveFormChange(Sender: TObject);
    procedure ShowDataInspector;
    procedure LazReportPrint(ReportName:string);
    procedure UpdateEditorInfo(AEditorObj:Tfdbm_SynEditorFrame);
    procedure UpdateActionsToolbar;
  end;

var
  fbManagerMainForm: TfbManagerMainForm;

implementation
uses IBManDataInspectorUnit, fdmAboutUnit, fbmEnvironmentOptionsUnit, rxlogging,
  fbmEditorOptionsUnit, fbmStrConstUnit, fbmUserDataBaseUnit, fbmsqlscript,
  SQLEngineAbstractUnit, fbmCreateConnectionUnit, fbmObjectTemplatesunit,
  LCLIntf, LCLType, rxAppUtils, fdbm_SynEditorCompletionHintUnit,
  fbm_VisualEditorsAbstractUnit, fdbm_PagedDialogUnit, LCLVersion,

  {$IFDEF USE_SHAMANGRAD}
  fbmShowNewUnit,
  fbmErrorSubmitUnit,
  {$ENDIF}
  cfKeyboardTemplatesUnit, dsDesignerUnit, tlsSearchInMetatDataParamsUnit,
  fbmConnectionEditUnit;

{$R *.lfm}

{ TfbManagerMainForm }

procedure TfbManagerMainForm.Speedbutton4Click(Sender: TObject);
begin
  ShowDataInspector;
end;

procedure TfbManagerMainForm.dbRegisterExecute(Sender: TObject);
begin
  //
end;

procedure TfbManagerMainForm.dbUnregisterExecute(Sender: TObject);
begin
  //
end;

procedure TfbManagerMainForm.hlpAboutExecute(Sender: TObject);
begin
  fdmAboutForm:=TfdmAboutForm.Create(Application);
  fdmAboutForm.ShowModal;
  fdmAboutForm.Free;
end;

procedure TfbManagerMainForm.optCustomizeToolbarExecute(Sender: TObject);
begin
  ToolPanel1.Customize(0);
end;

procedure TfbManagerMainForm.optEditorsExecute(Sender: TObject);
begin
  fbmEditorOptionsForm:=TfbmEditorOptionsForm.Create(Application);
  try
    if fbmEditorOptionsForm.ShowModal=mrOk then
      LM_SendToAll(LM_EDITOR_CHANGE_PARMAS);
  finally
    fbmEditorOptionsForm.Free;
  end;
end;

procedure TfbManagerMainForm.optEnironmentExecute(Sender: TObject);
var
  S:string;
begin
  S:=ConfigValues.ByNameAsString('lngFileName', '');
  fbmEnvironmentOptionsForm:=TfbmEnvironmentOptionsForm.Create(Application);
  try
    if fbmEnvironmentOptionsForm.ShowModal = mrOk then
    begin
      UserDBModule.SaveConfig;
      LM_SendToAll(LM_EDITOR_CHANGE_PARMAS);
      LM_SendToAll(LM_PREF_CHANGE_PARMAS);
      DoLoadPrefs;
    end
  finally
    fbmEnvironmentOptionsForm.Free;
  end;
  if S<>ConfigValues.ByNameAsString('lngFileName', '') then
    InfoBox(sNeedRestartConfigCh);
end;

procedure TfbManagerMainForm.sysExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfbManagerMainForm.tlsDBInspectorExecute(Sender: TObject);
begin
  ShowDataInspector;
end;

procedure TfbManagerMainForm.tlsExtractMetadataExecute(Sender: TObject);
begin
  ShowExtractForm;

  RxMDITasks1.FlatButton:=not RxMDITasks1.FlatButton;
end;

procedure TfbManagerMainForm.tlsReportManagerExecute(Sender: TObject);
begin
  ShowReportManager;
end;

procedure TfbManagerMainForm.tlsSearchInMetadataExecute(Sender: TObject);
begin
  ShowSearchInMetatDataParamsForm;
end;

procedure TfbManagerMainForm.tlsSqlBuilderExecute(Sender: TObject);
begin
  RxMDIPanel1.ChildWindowsCreate(SQLBuilderForm, TSQLBuilderForm);
end;

procedure TfbManagerMainForm.tlsSQLEditorExecute(Sender: TObject);
begin
  if Assigned(fbManDataInpectorForm) then
    fbManDataInpectorForm.editSQL.Execute;
end;

procedure TfbManagerMainForm.tlsSqlScriptExecute(Sender: TObject);
begin
  RxMDIPanel1.ChildWindowsCreate(FBMSqlScripForm, TFBMSqlScripForm);
end;

procedure TfbManagerMainForm.wndCloseAllExecute(Sender: TObject);
begin
  RxMDIPanel1.CloseAll;
end;

procedure TfbManagerMainForm.TabsActiveFormChange(Sender: TObject);
begin
  if Assigned(fbManDataInpectorForm) then
    fbManDataInpectorForm.UpdateRecentObjects;

  HideCodeContext;
end;

procedure TfbManagerMainForm.MakeToolsMenu;
var
  i,j:integer;
  M:TMenuItem;
  P: TDBVisualToolsClass;
  R: TMenuItemRec;
begin
  for i:=0 to SQLEngineAbstractClassCount-1 do
  begin
    P:=SQLEngineAbstractClassArray[i].VisualToolsClass;
    for j:=0 to P.GetMenuItemCount-1 do
    begin
      M:=TMenuItem.Create(MainMenu1);
      R:=P.GetMenuItems(j);
      M.Caption:=R.ItemName;
      M.Hint:=R.ItemHint;
      M.OnClick:=R.OnClick;
      M.ImageIndex:=R.ImageIndex;
      MenuItem8.Add(M);
    end;
  end;
end;

procedure TfbManagerMainForm.Localize;
begin
  MenuItem1.Caption:=sMenuSystem;
  sysExit.Caption:=sExit;
  sysExit.Hint:=sExitHint;

  dbCreate.Caption:=sMenuCreateDB;
  dbCreate.Hint:=sMenuCreateDBHint;
  dbRegister.Caption:=sMenuRegisterDB;
  dbRegister.Hint:=sMenuRegisterDBHint;

  dbUnregister.Caption:=sMenuUnRegisterDB;
  dbUnregister.Hint:=sMenuUnRegisterDBHint;
  dbConnect.Caption:=sMenuConnectDB;
  dbConnect.Hint:=sMenuConnectDBHint;
  dbDisconnect.Caption:=sMenuDisconnectDB;
  dbDisconnect.Hint:=sMenuDisconnectDBHint;
  dbRefresh.Caption:=sMenuRefresh;
  dbRefresh.Hint:=sMenuRefreshHint;

  MenuItem8.Caption:=sMenuTools;
  tlsDBInspector.Caption:=sMenuDBInspector;
  tlsDBInspector.Hint:=sMenuDBInspectorHint;
  tlsSQLEditor.Caption:=sMenuSQLEditor;
  tlsSQLEditor.Hint:=sMenuSQLEditorHint;
  tlsSqlScript.Caption:=sMenuSqlScript;
  tlsSqlScript.Hint:=sMenuSqlScriptHint;
  tlsSqlBuilder.Caption:=sMenuSqlBuilder;
  tlsSqlBuilder.Hint:=sMenuSqlBuilderHint;
  tlsSearchInMetadata.Caption:=sMenuSearchInMetadata;
  tlsSearchInMetadata.Hint:=sMenuSearchInMetadataHint;
  tlsExtractMetadata.Caption:=sMenuExtractMetadata;
  tlsExtractMetadata.Hint:=sMenuExtractMetadataHint;
  tlsReportManager.Caption:=sMenuReportManager;
  tlsReportManager.Hint:=sMenuReportManagerHint;

  MenuItem2.Caption:=sMenuOptions;
  optEditors.Caption:=sMenuOptEditors;
  optEditors.Hint:=sMenuOptEditorsHint;
  optEnironment.Caption:=sMenuOptEnironment;
  optEnironment.Hint:=sMenuOptEnironmentHint;
  optCustomizeToolbar.Caption:=sMenuCustomizeToolbar;
  optCustomizeToolbar.Hint:=sMenuCustomizeToolbarHint;
  optKeyboardTemplates.Caption:=sMenuKeyboardTemplates;
  optKeyboardTemplates.Hint:=sMenuKeyboardTemplatesHint;
  optObjectTemplates.Caption:=sMenuObjectTemplates;
  optObjectTemplates.Hint:=sMenuObjectTemplatesHint;

  WindowItems.Caption:=sMenuWindows;
  wndReOrder.Caption:=sMenuReOrder;
  wndReOrder.Hint:=sMenuReOrderHint;
  wndCloseAll.Caption:=sMenuCloseAll;
  wndCloseAll.Hint:=sMenuCloseAllHint;

  MenuItem5.Caption:=sMenuHelp;
  hlpAbout.Caption:=sMenuAbout;
  hlpAbout.Hint:=sMenuAboutHint;
  hlpNews.Caption:=sMenuNews;
  hlpNews.Hint:=sMenuNewsHint;
  hlpSendBugreport.Caption:=sMenuSendBugreport;
  hlpSendBugreport.Hint:=sMenuSendBugreportHint;
  hlpVisitToWebSite.Caption:=sMenuVisitToWebSite;
  hlpVisitToWebSite.Hint:=sMenuVisitToWebSiteHint;

  Label1.Caption:=sObjectInspector;
end;

procedure TfbManagerMainForm.DoLoadPrefs;
var
  FT: TRxMDIPanelOptions;
  FT1: TRxMDITaskOptions;
begin
  ApplicationProperties1.HintColor:=defHintColor;
  ApplicationProperties1.ShowButtonGlyphs:=TApplicationShowGlyphs(ConfigValues.ByNameAsInteger('defShowBitBtnGlyph', 0));
  RxMDITasks1.FlatButton:=ConfigValues.ByNameAsBoolean('TaskBar/Flat buttons', true);


  RxMDICloseButton1.ShowInfoLabel:=ConfigValues.ByNameAsBoolean('MDI/ShowFormCaptions', true);
  RxMDIPanel1.HideCloseButton:=not ConfigValues.ByNameAsBoolean('MDI/ShowCloseButton', true);
  RxMDITasks1.FlatButton:=ConfigValues.ByNameAsBoolean('TaskBar/Flat buttons', true);

  FT:=RxMDIPanel1.Options;
  if ConfigValues.ByNameAsBoolean('TaskBar/Close by F4', true) then
    FT:=FT + [rxpoCloseF4]
  else
    FT:=FT - [rxpoCloseF4];

  if ConfigValues.ByNameAsBoolean('TaskBar/Switch by Tab', true) then
    FT:=FT + [rxpoSwithByTab]
  else
    FT:=FT - [rxpoSwithByTab];
  RxMDIPanel1.Options:=FT;


  FT1:=RxMDITasks1.Options;
  if ConfigValues.ByNameAsBoolean('TaskBar/MidleClickCloseForm', true) then
    FT1:=RxMDITasks1.Options + [rxtoMidleClickClose]
  else
    FT1:=RxMDITasks1.Options - [rxtoMidleClickClose];
  if ConfigValues.ByNameAsBoolean('TaskBar/Ask before close all windows', true) then
    FT1:=RxMDITasks1.Options + [rxtoAskCloseAll]
  else
    FT1:=RxMDITasks1.Options - [rxtoAskCloseAll];
  RxMDITasks1.Options:=FT1;
end;

procedure TfbManagerMainForm.IBManagerMainFormCreate(Sender: TObject);
begin
  Localize;
//  WindowState:=wsMaximized;
  fbManagerMainForm:=Self;

  DoLoadPrefs;

  Top:=0;
  Left:=0;
  Width:=Screen.Width-1;
  Height:=Screen.Height-1;

  UpdateEditorInfo(nil);

  sysExit.ImageIndex:=0;

  MakeToolsMenu;
  Screen.OnActiveFormChange:=@TabsActiveFormChange;
end;

procedure TfbManagerMainForm.hlpNewsExecute(Sender: TObject);
begin
  {$IFDEF USE_SHAMANGRAD}
  ShowNews;
  {$ELSE}
  ErrorBox('Эта система собрана без поддержки багтрекера.');
  {$ENDIF}
end;

procedure TfbManagerMainForm.hlpSendBugreportExecute(Sender: TObject);
begin
  {$IFDEF USE_SHAMANGRAD}
  fbmErrorSubmitForm:=TfbmErrorSubmitForm.Create(Application);
  try
    fbmErrorSubmitForm.InitBugTracker('');
    fbmErrorSubmitForm.ShowModal;
  finally
    fbmErrorSubmitForm.Free;
  end;
  {$ELSE}
  ErrorBox('Эта система собрана без поддержки багтрекера.');
  {$ENDIF}
end;

procedure TfbManagerMainForm.hlpVisitToWebSiteExecute(Sender: TObject);
begin
  OpenURL('http://w7site.ru/fpc/fbm/');
end;

procedure TfbManagerMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ConfigValues.ByNameAsBoolean('sysConfirmExit', true) then
  begin
    CanClose:=QuestionBox(sConfirmExitQuestion);
    if not CanClose then
      exit;
  end;

  if Assigned(fbManDataInpectorForm) then
  begin
    fbManDataInpectorForm.CloseAllDB;
    Screen.OnActiveFormChange:=nil;
  end;
end;

procedure TfbManagerMainForm.dbCreateExecute(Sender: TObject);
begin
  fbmCreateConnectionForm:=TfbmCreateConnectionForm.Create(Application);
  if fbmCreateConnectionForm.ShowModal = mrOk then
    fbManDataInpectorForm.CreateNewDB(fbmCreateConnectionForm.SQLEngineName);
  fbmCreateConnectionForm.Free;
end;

procedure TfbManagerMainForm.dbDisconnectExecute(Sender: TObject);
begin
  fbManDataInpectorForm.dbDisconect.Execute;
end;

procedure TfbManagerMainForm.dbRefreshExecute(Sender: TObject);
begin
  fbManDataInpectorForm.objRefresh.Execute;
end;

procedure TfbManagerMainForm.ApplicationProperties1Exception(Sender: TObject;
  E: Exception);
begin
  ErrorBoxExcpt(E);
  rxWriteLog(etError, E.Message);
end;

procedure TfbManagerMainForm.ApplicationProperties1Hint(Sender: TObject);
begin
  { TODO : Необходимо выделить в отдульную процедуру убирание служебных символов }
  StatusBar1.Panels[3].Text:=StringReplace(StringReplace(Application.Hint, #13, ' ', [rfReplaceAll]), #10, ' ', [rfReplaceAll]);
end;

procedure TfbManagerMainForm.ApplicationProperties1Idle(Sender: TObject;
  var Done: Boolean);
begin
{  if (WindowTabs.LockCount = 0) and not Assigned(Screen.OnActiveFormChange) then
  begin
    Screen.OnActiveFormChange:=@(fbManagerMainForm.TabsActiveFormChange);
    if Assigned(fbManDataInpectorForm) then
      fbManDataInpectorForm.listWindows.OnClick:=@(fbManDataInpectorForm.listWindowsClick);
  end;}
end;

procedure TfbManagerMainForm.dbConnectExecute(Sender: TObject);
begin
  fbManDataInpectorForm.dbConnect.Execute;
end;

procedure TfbManagerMainForm.InspectorCloseButtonClick(Sender: TObject);
begin
  InspectorPanel.Hide;
end;

{*** Вызов окна настроек клавиатурных макросов ***}
procedure TfbManagerMainForm.optKeyboardTemplatesExecute(Sender: TObject);
begin
  cfKeyboardTemplatesForm:=TcfKeyboardTemplatesForm.Create(Application);
  if cfKeyboardTemplatesForm.ShowModal = mrOk then
  begin
    LM_SendToAll(LM_EDITOR_CHANGE_PARMAS);
    //StoreParams;
  end;
  cfKeyboardTemplatesForm.Free;
end;

{*** Вызов окна настроек шаблонов объектов ***}
procedure TfbManagerMainForm.optObjectTemplatesExecute(Sender: TObject);
begin
  fbmObjectTemplatesForm:=TfbmObjectTemplatesForm.Create(Application);
  if fbmObjectTemplatesForm.ShowModal = mrOk then
  begin
    LM_SendToAll(LM_OBJECT_TEMPLATE_CHANGE);
    UserDBModule.SaveConfig;
    //StoreParams;
  end;
  fbmObjectTemplatesForm.Free;
end;

procedure TfbManagerMainForm.ShowDataInspector;
begin
  InspectorPanel.Visible:=true;
  ShowfbManDataInpectorForm(Self);

  fbManDataInpectorForm.UpdateDBManagerState;
end;

procedure TfbManagerMainForm.LazReportPrint(ReportName: string);
var
  RepFileName:string;
begin
  RepFileName:=ExtractFileDir(ParamStr(0)) + DirectorySeparator + 'reports' + DirectorySeparator + ReportName + '.lrf';
  frReport1.Pages.Clear;
  if FileExists(RepFileName) then
    frReport1.LoadFromFile(RepFileName)
  else
    frReport1.FileName:=RepFileName;
  frReport1.Title:=ReportName;

  if ShowDesigner then
    frReport1.DesignReport
  else
    frReport1.ShowReport;
end;

procedure TfbManagerMainForm.UpdateEditorInfo(AEditorObj: Tfdbm_SynEditorFrame);
begin
  if Assigned(AEditorObj) then
  begin
    StatusBar1.Panels[0].Text:=Format('%-5d:%-3d', [AEditorObj.TextEditor.CaretY, AEditorObj.TextEditor.CaretX]);

    if AEditorObj.Modified then
      StatusBar1.Panels[1].Text:=sModified
    else
      StatusBar1.Panels[1].Text:='';

    if AEditorObj.TextEditor.InsertMode then
      StatusBar1.Panels[2].Text:=sINS
    else
      StatusBar1.Panels[2].Text:=sREPL;
  end
  else
  begin
    StatusBar1.Panels[0].Text:='';
    StatusBar1.Panels[1].Text:='';
    StatusBar1.Panels[2].Text:='';
  end;
end;

procedure TfbManagerMainForm.UpdateActionsToolbar;
begin
  if not Assigned(fbManDataInpectorForm) then Exit;
  dbConnect.Enabled:=fbManDataInpectorForm.dbConnect.Enabled;
  dbDisconnect.Enabled:=fbManDataInpectorForm.dbDisconect.Enabled;
  dbRefresh.Enabled:=fbManDataInpectorForm.objRefresh.Enabled;
  tlsSQLEditor.Enabled:=fbManDataInpectorForm.editSQL.Enabled;

end;



end.

