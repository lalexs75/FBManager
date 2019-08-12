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

unit fbmToolsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LCLType, LMessages, DB, SynEdit, Graphics, DbCtrls, rxdbgrid,
  ExtCtrls, DBGrids, Grids, Forms, contnrs, rxConfigValues,
  SQLEngineCommonTypesUnit,  IniFiles;

const
  LM_EDITOR_CHANGE_PARMAS    = LM_INTERFACELAST + 1;        //Изменение параметров редакторов SQL - необходимо перечитать
  LM_PREF_CHANGE_PARMAS      = LM_EDITOR_CHANGE_PARMAS + 1; //Изменение параметров среды
  LM_OBJECT_TEMPLATE_CHANGE  = LM_PREF_CHANGE_PARMAS + 1;   //Изменение шаблонов объектов
  LM_NOTIFY_OBJECT_DELETE    = LM_OBJECT_TEMPLATE_CHANGE + 1;   //Сообщение об удалении объекта БД
  ConfDBVers                 = 4;


  sFBMConfDirName         = '.fbm';
  sAliasFileName          = 'fbm.lst';
  sConfigFileNameOld      = 'fbm.ini';
  sConfigFileNameNew      = 'fbm.cfg';
  sCodeCopletionsFileName = 'fbm.cci';
  sWindowConfig           = 'Open_Window.ini';
  sFBMDBDesktopConfig     = 'fbm_db_desktop.ini';


  //this name of project on http://shamangrad.net service, don't chage it
  netProgectName    = 'FBManager';
  netProgectURL     = 'http://shamangrad.net/project.php?act=view&prj=FBManager';
  netProgectRSS     = 'http://shamangrad.net/news.php?act=rss&prj=FBManager';
  defEditorFontName = 'Courier New';
  defEditorFontSize = 10;

//procedure InfoBox(Message:string);
//procedure ErrorBox(ErrorStr:string);
procedure ErrorBoxExt(ErrorStr:string; Args:array of const);
procedure ErrorBoxExcpt(E:Exception);
function QuestionBox(QuestionMessage:string):boolean;
function QuestionBoxFmt(QuestionMessage:string; Args:array of const):boolean;
function QuestionBoxExt(QuestionMessage:string): integer;
procedure NotCompleteFunction;

var
//  GlobalCfgFolder    : string = '';
  LocalCfgFolder     : string = '';
  AliasFileName      : string = '';
  ConfigFileName     : string = '';
  ConfigFileNameNew  : string = '';
  LngFolder          : string = '';
  DocsFolder         : string = '';
  ReportsFolder      : string = '';
  DebugLevel         : integer = 0;

var
  ShowDesigner       : boolean = false;
  ConfigValues:TConfigValues = nil;

//procedure LoadParams1;
procedure LoadLocalize(AFileName:string);
procedure InitSysOptions;

procedure SetEditorOptions(SynEdit: TSynEdit);
procedure SetRxDBGridOptions(Grid:TRxDBGrid);
procedure SetDBNavigatorHint(ADBNav:TDBNavigator);

procedure LM_SendToAll(Msg:Cardinal);
procedure LM_SendToAll(Msg:Cardinal; AInfo:Pointer); overload;


function StrToDateDef(const S: string; const Default: TDateTime): TDateTime;
//procedure WriteLog(const S:string);

function NumCountChars(const Char: Char; const S: String): Integer;


procedure SaveTextFile(const AText, AFileName:string);
function LoadFormTextFile(const AFileName:string):string;

function GetFistString(const S:string):string;

procedure SaveRxDBGridState(const SectionName:string; const Ini:TIniFile; const Grid:TRxDBGrid);
procedure RestoreRxDBGridState(const SectionName:string; const Ini:TIniFile; const Grid:TRxDBGrid);
function MenuItemStr(S:string):string;
function StrConvertDesc(const S:string):string;
function SysCommentStyle:string;
procedure AddMacro(var MacroStr:string; const MacroWhere:string);
procedure AddMacroEx(var MacroStr:string; const MacroWhere:string; Params:array of const);
function ValueInteger(const S: string): string;
function ValueString(const S: string): string;
const
{$IFDEF WINDOWS}
  AllFilesMask1 = '*.*';
{$ELSE}
  AllFilesMask1 = '*';
{$ENDIF}

implementation
uses fbmStrConstUnit, SynHighlighterSQL, rxAppUtils, rxlogging,
  Translations, LResources, strutils, rxstrutils, SynEditTypes,
  {$IFDEF USE_SHAMANGRAD}
  fbmErrorBoxUnit,
  {$ENDIF}
  FileUtil, LCLProc, LazFileUtils

  { TODO : В дальнейшем код записи констатн специфичный для каждой БД надо вынести через регистрацию }
  , fb_ConstUnit
{$IFNDEF WINDOWS}
//  , iconvenc
{$ENDIF}
  , LazUTF8
  ;
(*
procedure ErrorBox(ErrorStr:string);
begin
  {$IFDEF USE_SHAMANGRAD}
  fbmErrorBoxForm:=TfbmErrorBoxForm.Create(Application);
  fbmErrorBoxForm.Memo1.Text:=ErrorStr;
  fbmErrorBoxForm.ShowModal;
  fbmErrorBoxForm.Free;
  {$ELSE}
  Application.MessageBox(PChar(ErrorStr), PChar(sError), MB_OK + MB_ICONHAND);
  {$ENDIF}
  RxWriteLog(etError, ErrorStr);
end;

procedure InfoBox(Message: string);
begin
  Application.MessageBox(PChar(Message), PChar(sInformation), MB_OK+MB_ICONQUESTION);
end;
*)
procedure LM_SendToAll(Msg:Cardinal);
begin
  LM_SendToAll(Msg, nil);
end;

procedure LM_SendToAll(Msg: Cardinal; AInfo: Pointer); overload;
var
  i, j: Integer;
  F: TForm;
begin
  if Assigned(Screen) then
  begin
    for i:=0 to Screen.FormCount-1 do
    begin
      F:=Screen.Forms[i];
      F.Perform(Msg, PtrInt(AInfo), 0);
      for j:=0 to F.ControlCount-1 do
        F.Controls[j].Perform(Msg, PtrInt(AInfo), 0);
    end;
  end;
end;

procedure SetEditorOptions(SynEdit:TSynEdit);
begin
  if not Assigned(SynEdit) then exit;
  SynEdit.Font.Name:=ConfigValues.ByNameAsString('EditorFontName', defEditorFontName);
  SynEdit.Font.Size:=ConfigValues.ByNameAsInteger('EditorFontSize', defEditorFontSize);

  if ConfigValues.ByNameAsBoolean('EditorDisableAntialiased', false) then
    SynEdit.Font.Quality:=fqDefault
  else
    SynEdit.Font.Quality:=fqAntialiased;

  if ConfigValues.ByNameAsBoolean('EditorAlwaysVisibleCaret', true) then
    SynEdit.Options2:=SynEdit.Options2 + [eoAlwaysVisibleCaret]
  else
    SynEdit.Options2:=SynEdit.Options2 - [eoAlwaysVisibleCaret];

  SynEdit.Gutter.LineNumberPart.Visible:=ConfigValues.ByNameAsBoolean('esqlShowLineNumbers', true);
  SynEdit.Gutter.LineNumberPart.ShowOnlyLineNumbersMultiplesOf:=ConfigValues.ByNameAsInteger('EditorShowOnlyLineNumOf', 5);

  if Assigned(SynEdit.Highlighter) and (SynEdit.Highlighter is TSynSQLSyn) then
  begin
    TSynSQLSyn(SynEdit.Highlighter).TableNameAttri.Foreground:=ConfigValues.ByNameAsInteger('esqlColorFrgTables', clWindow);
    TSynSQLSyn(SynEdit.Highlighter).TableNameAttri.Background:=ConfigValues.ByNameAsInteger('esqlColorBkgTables', clGreen);
    TSynSQLSyn(SynEdit.Highlighter).StringAttri.Foreground:=ConfigValues.ByNameAsInteger('esqlColorFrgString', clAqua);
    TSynSQLSyn(SynEdit.Highlighter).StringAttri.Background:=ConfigValues.ByNameAsInteger('esqlColorBkgString', clBlack);
    TSynSQLSyn(SynEdit.Highlighter).CommentAttribute.Foreground:=ConfigValues.ByNameAsInteger('esqlColorFrgComment', clWindow);
    TSynSQLSyn(SynEdit.Highlighter).CommentAttribute.Background:=ConfigValues.ByNameAsInteger('esqlColorBkgComment', clBlue);
    TSynSQLSyn(SynEdit.Highlighter).NumberAttri.Foreground:=ConfigValues.ByNameAsInteger('esqlColorFrgNumber', clNavy);
    TSynSQLSyn(SynEdit.Highlighter).NumberAttri.Background:=ConfigValues.ByNameAsInteger('esqlColorBkgNumber',clWindow);

    if ConfigValues.ByNameAsBoolean('esqlFontUnderlineTables', false) then
      TSynSQLSyn(SynEdit.Highlighter).TableNameAttri.Style:=TSynSQLSyn(SynEdit.Highlighter).TableNameAttri.Style + [fsUnderline]
    else
      TSynSQLSyn(SynEdit.Highlighter).TableNameAttri.Style:=TSynSQLSyn(SynEdit.Highlighter).TableNameAttri.Style - [fsUnderline];

    if ConfigValues.ByNameAsBoolean('esqlFontUnderlineString', false) then
      TSynSQLSyn(SynEdit.Highlighter).StringAttribute.Style:=TSynSQLSyn(SynEdit.Highlighter).StringAttribute.Style + [fsUnderline]
    else
      TSynSQLSyn(SynEdit.Highlighter).StringAttribute.Style:=TSynSQLSyn(SynEdit.Highlighter).StringAttribute.Style - [fsUnderline];

    if ConfigValues.ByNameAsBoolean('esqlFontUnderlineComment', false) then
      TSynSQLSyn(SynEdit.Highlighter).CommentAttribute.Style:=TSynSQLSyn(SynEdit.Highlighter).CommentAttribute.Style + [fsUnderline]
    else
      TSynSQLSyn(SynEdit.Highlighter).CommentAttribute.Style:=TSynSQLSyn(SynEdit.Highlighter).CommentAttribute.Style - [fsUnderline];

    if ConfigValues.ByNameAsBoolean('esqlFontUnderlineNumbers', false) then
      TSynSQLSyn(SynEdit.Highlighter).NumberAttri.Style:=TSynSQLSyn(SynEdit.Highlighter).NumberAttri.Style + [fsUnderline]
    else
      TSynSQLSyn(SynEdit.Highlighter).NumberAttri.Style:=TSynSQLSyn(SynEdit.Highlighter).NumberAttri.Style - [fsUnderline];
  end;

  SynEdit.RightEdge:=ConfigValues.ByNameAsInteger('EditorRigthBorderPos', 80);

  if ConfigValues.ByNameAsBoolean('EditorShowRigthBorder', false) then
    SynEdit.Options:=SynEdit.Options - [eoHideRightMargin]
  else
    SynEdit.Options:=SynEdit.Options + [eoHideRightMargin];
  { TODO : Доработать настроку на вид выделения текста }
  SynEdit.SelectionMode:=smNormal;
end;

procedure ErrorBoxExt(ErrorStr: string; Args: array of const);
begin
  ErrorBox(Format(ErrorStr, Args));
end;

procedure ErrorBoxExcpt(E: Exception);
begin
  ErrorBox(E.Message);
end;

function QuestionBox(QuestionMessage: string): boolean;
begin
  Result:=Application.MessageBox(PChar(QuestionMessage), PChar(sQuestion), MB_YESNO + MB_ICONQUESTION) = id_Yes;
end;

function QuestionBoxFmt(QuestionMessage: string; Args: array of const): boolean;
begin
  Result:=QuestionBox(Format(QuestionMessage, Args));
end;

function QuestionBoxExt(QuestionMessage: string): integer;
begin
  Result:=Application.MessageBox(PChar(QuestionMessage), PChar(sQuestion), MB_YESNOCANCEL + MB_ICONQUESTION);
end;

procedure NotCompleteFunction;
begin
  ErrorBox(sFuntionNotComplete);
end;

procedure TranslateLCL(poFileName: String);
var
  UserLang, LCLLngDir, LRLngDir, dbExpLngDir: String;
  Lang, FallbackLang: String;
begin
  LCLLngDir:= lngFolder +DirectorySeparator + 'lcl' + DirectorySeparator;
  LRLngDir:= lngFolder +DirectorySeparator + 'lazreport' + DirectorySeparator;
  dbExpLngDir:=lngFolder +DirectorySeparator + 'dbexport' + DirectorySeparator;

  if NumCountChars('.', poFileName) >= 2 then
  begin
    UserLang:= ExtractDelimited(2, poFileName, ['.']);
    poFileName:= LCLLngDir + Format('lclstrconsts.%s.po', [UserLang]);

    if FileExists(poFileName) then
        Translations.TranslateUnitResourceStrings('LCLStrConsts', poFileName);

    poFileName:= LRLngDir + Format('lr_const.%s.po', [UserLang]);
    if FileExists(poFileName) then
        Translations.TranslateUnitResourceStrings('LR_Const', poFileName);

    poFileName:= LRLngDir + Format('le_e_spreadsheet_consts.%s.po', [UserLang]);
    if FileExists(poFileName) then
        Translations.TranslateUnitResourceStrings('le_e_spreadsheet_consts', poFileName);

    poFileName:= dbExpLngDir + Format('sdb_consts.%s.po', [UserLang]);
    if FileExists(poFileName) then
        Translations.TranslateUnitResourceStrings('sdb_consts', poFileName);

    poFileName:= lngFolder +DirectorySeparator + 'rx' + DirectorySeparator + Format('rxconst.%s.po', [UserLang]);
    if FileExists(poFileName) then
        Translations.TranslateUnitResourceStrings('rxconst', poFileName);

    poFileName:= lngFolder +DirectorySeparator + 'rx' + DirectorySeparator + Format('rxdconst.%s.po', [UserLang]);
    if FileExists(poFileName) then
        Translations.TranslateUnitResourceStrings('rxdconst', poFileName);

    poFileName:= lngFolder +DirectorySeparator + 'fpspreadsheet' + DirectorySeparator + Format('fpsstrings.%s.po', [UserLang]);
    if FileExists(poFileName) then
        Translations.TranslateUnitResourceStrings('fpsstrings', poFileName);
  end;
end;

procedure LoadLocalize(AFileName:string);
begin
  if AFileName<>'' then
  begin
    AFileName:=lngFolder +DirectorySeparator + AFileName;

    if FileExists(AFileName) then
    begin
      TranslateLCL(AFileName);
      Translations.TranslateUnitResourceStrings('fbmStrConstUnit', AFileName);
      Translations.TranslateUnitResourceStrings('pg_utils', AFileName);
    end;
  end;
end;

procedure InitSysOptions;
var
  S: String;
begin
  S:=ExtractQuotedString(ConfigValues.ByNameAsString('ThousandSeparator',  QuotedString(DefaultFormatSettings.ThousandSeparator, '"')), '"');
  if S<>'' then
    DefaultFormatSettings.ThousandSeparator:=S[1];

  S:=ExtractQuotedString(ConfigValues.ByNameAsString('DateSeparator', QuotedString(DefaultFormatSettings.DateSeparator, '"')), '"');
  if S<>'' then
    DefaultFormatSettings.DateSeparator:=S[1];
end;

procedure SetRxDBGridOptions(Grid: TRxDBGrid);
var
  R: TRxColumn;
  GO: TDbGridOptions;
begin
  case ConfigValues.ByNameAsInteger('goStyle', 0) of
    0:Grid.TitleStyle:=tsLazarus;
    1:Grid.TitleStyle:=tsStandard;
    2:Grid.TitleStyle:=tsNative;
  end;

  GO:=Grid.Options;

  if ConfigValues.ByNameAsBoolean('Grid/Show memo values', true) then
    GO:=GO + [dgDisplayMemoText]
  else
    GO:=GO - [dgDisplayMemoText];

  if ConfigValues.ByNameAsBoolean('Grid/Allow multiselect', true) then
    GO:=GO + [dgMultiselect]
  else
    GO:=GO - [dgMultiselect];

  if ConfigValues.ByNameAsBoolean('Grid/Enable tooltips', true) then
    GO:=GO + [dgTruncCellHints]
  else
    GO:=GO - [dgTruncCellHints];

  Grid.Options:=GO;

  if ConfigValues.ByNameAsBoolean('Grid/Stripy grids', true) then
    Grid.AlternateColor:=ConfigValues.ByNameAsInteger('Grid/Alternate color', clSkyBlue)
  else
    Grid.AlternateColor:=Grid.Color;


  if Grid.Columns.Count>0 then
    for R in Grid.Columns do
      R.Filter.Style:=TRxFilterStyle(ConfigValues.ByNameAsInteger('Grid filter style', 0));
end;

function StrToDateDef(const S: string; const Default: TDateTime): TDateTime;
begin
  if not TryStrToDate(S, Result) then
    Result := Default;
end;

function NumCountChars(const Char: Char; const S: String): Integer;
var
  I : Integer;
begin
  Result := 0;
  if Length(S) > 0 then
    for I := 1 to Length(S) do
      if S[I] = Char then Inc(Result);
end;

function StrConvertDesc(const S: string): string;
var
  I: Integer;
begin
  Result:=S;
  for I:=1 to Length(Result) do
    if Result[i]<' ' then Result[i]:=' ';
end;

function SysCommentStyle: string;
begin
  if ConfigValues.ByNameAsInteger('Compatibility_SystemCommentStyle', 0) = 0 then
    Result:=sCommentFBMStyle
  else
    Result:=sCommentIBEStyle;
end;

procedure AddMacro(var MacroStr: string; const MacroWhere: string);
begin
  if MacroStr<>'' then MacroStr:=MacroStr + ' and ';
  MacroStr:=MacroStr + '('+MacroWhere+')';
end;

procedure AddMacroEx(var MacroStr: string; const MacroWhere: string;
  Params: array of const);
begin
  AddMacro(MacroStr, Format(MacroWhere, Params));
end;

function ValueInteger(const S: string): string;
var
  C:integer;
  I:Int64;
begin
  Val(S, I, C);
  if C=0 then
    Result:=S
  else
    Result:='0';
end;

function ValueString(const S: string): string;
begin
  Result:=StringReplace(S, '''', '''''', [rfReplaceAll]);
  Result:=StringReplace(Result, '\', '\\', [rfReplaceAll]);
end;


procedure SetDBNavigatorHint(ADBNav: TDBNavigator);
begin
  ADBNav.Hints.Clear;
  ADBNav.Hints.Add(sDBNavHintFirst);
  ADBNav.Hints.Add(sDBNavHintPrior);
  ADBNav.Hints.Add(sDBNavHintNext);
  ADBNav.Hints.Add(sDBNavHintLast);
  ADBNav.Hints.Add(sDBNavHintInsert);
  ADBNav.Hints.Add(sDBNavHintDelete);
  ADBNav.Hints.Add(sDBNavHintEdit);
  ADBNav.Hints.Add(sDBNavHintPost);
  ADBNav.Hints.Add(sDBNavHintCancel);
  ADBNav.Hints.Add(sDBNavHintRefresh);
end;

procedure SaveTextFile(const AText, AFileName: string);
var
  F:TFileStream;
begin
  F:=TFileStream.Create(UTF8ToSys(AFileName), fmCreate);
  F.Write(AText[1], Length(AText));
  F.Free;
end;

function LoadFormTextFile(const AFileName: string): string;
var
  ASize:Longint;
  F:TFileStream;
begin
  Result:='';
  if not FileExistsUTF8(AFileName) then exit;

  F:=TFileStream.Create(UTF8ToSys(AFileName), fmOpenRead);
  if F.Size>0 then
  begin
    SetLength(Result, F.Size);
    F.Read(Result[1], F.Size);
  end;
  F.Free;
end;



function GetFistString(const S: string): string;
var
  i:integer;
begin
  i:=posset([#13,#10], S);
  if i= 0 then
    Result:=S
  else
    Result:=Copy(S, 1, I-1);
end;

procedure SaveRxDBGridState(const SectionName: string; const Ini: TIniFile;
  const Grid: TRxDBGrid);
var
  i:integer;
  C:TRxColumn;
begin
  if Assigned(Grid) and Assigned(Ini) then
  begin
    Ini.WriteInteger(SectionName, 'Columns.Count', Grid.Columns.Count);
    for i:=0 to Grid.Columns.Count - 1 do
    begin
      C:=Grid.Columns[i] as TRxColumn;
      Ini.WriteString(SectionName, 'Column_'+IntToStr(i)+'.FieldName', C.FieldName);
      Ini.WriteInteger(SectionName, 'Column_'+IntToStr(i)+'.Width', C.Width);
    end;
  end;
end;

procedure RestoreRxDBGridState(const SectionName: string; const Ini: TIniFile;
  const Grid: TRxDBGrid);
var
  i, Cnt:integer;
  C:TRxColumn;
  FieldName:string;
begin
  if Assigned(Grid) and Assigned(Ini) then
  begin
    Cnt:=Ini.ReadInteger(SectionName, 'Columns.Count', 0);
    for i:=0 to Cnt - 1 do
    begin
      FieldName:=Ini.ReadString(SectionName, 'Column_'+IntToStr(i)+'.FieldName', '');
      if FieldName<>'' then
      begin
        C:=Grid.ColumnByFieldName(FieldName);
        if Assigned(C) then
          C.Width:=Ini.ReadInteger(SectionName, 'Column_'+IntToStr(i)+'.Width', C.Width);
      end;
    end;
  end;
end;

function MenuItemStr(S:string):string;
var
  i:integer;
begin
  Result:=Copy2Symb(ExtractFileName(S), '.');
  if Result='' then exit;
  for i:=1 to Length(Result) do
  begin
    if Result[i]='\' then Result[i]:='/' else
    if Result[i]='_' then Result[i]:='.';
  end;
end;

{$IFDEF LINUX}
const
  sEtcFolder = '/etc/';
  sEtcCfgFolder = '/usr/share/fbmanager/';
{$ENDIF}

procedure InitFolders;
var
  GlobalCfgFolder, FAppDir, FAppResDir: String;
begin
  FAppDir:=AppendPathDelim(ExtractFileDir(ParamStr(0)));
  GlobalCfgFolder:=SysToUTF8(RxGetAppConfigDir(true));
  LocalCfgFolder:=SysToUTF8(RxGetAppConfigDir(false));
  ForceDirectoriesUTF8(LocalCfgFolder);

  AliasFileName:=LocalCfgFolder+sAliasFileName;
  ConfigFileName:=LocalCfgFolder+sConfigFileNameOld;

  {$IFDEF LINUX}
  if Copy(FAppDir, 1, Length(sEtcFolder)) = sEtcFolder then
    FAppResDir := sEtcCfgFolder
  else
  {$ENDIF}
    FAppResDir := FAppDir;

  LngFolder:=AppendPathDelim(FAppResDir + 'languages');
  DocsFolder:=AppendPathDelim(FAppResDir+'docs');
  ReportsFolder:=AppendPathDelim(FAppResDir+'reports');

  ConfigFileNameNew:=LocalCfgFolder+sConfigFileNameNew;
end;

initialization
  ConfigValues:=TConfigValues.Create;
  InitFolders;
finalization
  FreeAndNil(ConfigValues);
end.

