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

unit fb_VisualToolsCallUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineAbstractUnit, FBSQLEngineUnit, Forms,
  fbm_VisualEditorsAbstractUnit, fdbm_PagedDialogPageUnit, SynHighlighterSQL,
  cfAbstractConfigFrameUnit;

type

   { TFireBirdVisualTools }

  TFireBirdVisualTools = class(TDBVisualTools)
  private
    procedure tlsBackupExecute(Sender: TObject);
    procedure tlsRestoreExecute(Sender: TObject);
    procedure tlsDBShadowManagerExecute(Sender: TObject);
    procedure tlsTranMonitorExecute(Sender: TObject);
    procedure tlsShowUserManagerExecute(Sender: TObject);
  protected
  public
    constructor Create(ASQLEngine:TSQLEngineAbstract);override;
    procedure InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);override;

    class function ConnectionDlgPageCount:integer;override;
    class function ConnectionDlgPage(ASQLEngine:TSQLEngineAbstract; APageNum:integer; AOwner:TForm):TPagedDialogPage; override;

    class function GetMenuItems(Index: integer): TMenuItemRec; override;
    class function GetMenuItemCount:integer; override;
    class function ConfigDlgPageCount:integer;override;
    class function ConfigDlgPage(APageNum:integer; AOwner:TForm):TFBMConfigPageAbstract; override;
    class function GetCreateObject:TSQLEngineCreateDBAbstractClass; override;

    class function GetObjTemplatePagesCount: integer;override;
    class function GetObjTemplate(Index: integer; Owner:TComponent): TFBMConfigPageAbstract;override;
  end;

implementation
uses fbmStrConstUnit, fbmTransactionMonitorUnit, fb_ConstUnit,
  ibmUserSecUnit, fbmshadowmanagerunit, fbmrestoreunit, fbmbuckupunit,
  fbmCreateDataBaseUnit,
  pg_con_EditorPrefUnit,
  fbm_cf_mainunit,           //Модуль содержит 1-ю страницу окна подключения к БД (имя БД и рег. инфа)
  fdbm_cf_LogUnit,           //Модуль содержит 2-ю страницу окна подключения к БД (протоколирование операций с БД)
  fbm_cf_BuckupUnit,         //Модуль содержит 3-ю страницу окна подключения к БД (параметры архивации БД)
  fbm_cf_RestoreUnit,        //Модуль содержит 4-ю страницу окна подключения к БД (параметры востановления БД)
  fdbm_cf_DisplayDataParamsUnit, fdbm_DescriptionUnit,//Модуль содержит страницу окна подключения к БД (параметры отображения данных в таблице)
  fbmpgTableCheckConstaintUnit,

  cfFireBirdOptionsUnit,     //Модуль содержит окно параметров работы с FireBird - общие настройки программы
  cfFirebirdTransactionsParamsUnit, //Модуль содержит общие параметры транзакция для FireBird
  fbm_cf_TransactionUnit, otFirebirdTriggerTemplateUnit,
  otFirebirdFunctionTemplateUnit, otFirebirdPackageTemplateUnit,
  cfAutoIncFieldUnit,

  fbmDBObjectEditorUnit,     //Модуль содежит окно редактора объекта БД

//  ibmRolesEditorUnit,        //модуль содержит окно редактора роли
  //fbmTableEditorIndexEditUnit, //Редактор индекса
  //fbmTableFieldEditorUnit,     //Редактор поля
  fbmFBIndexEditorUnit,

  //Страницы редактора объектов
  fbmObjectEditorDescriptionUnit,
  fbmTableEditorDataUnit,
  fbmTableEditorTriggersUnit,
  fbmViewEditorMainUnit,
  fbmTableEditorFieldsUnit,
  fbTriggerHeaderEditUnit,
  fbmdboDependenUnit,          //Модуль содержит страницу зависимостей
  fbmSPEdtMainPageUnit, fbmFBFunctionUnit,        //Модуль содежит окно редактирования текста хранимой процедуры
  fbmDomainMainEditorUnit,     //Главная страница редактора домена

  fbmRoleMainEditorUnit,       //Главная страница редактора роли
  fbmRoleGrantUsersUnit,       //Редактор роли - раздача прав для операторов
  fbmRolesDBObjectsGrantUnit,  //Редактор роли - раздача прав на объекты

  fbmExceptionMainEditorUnit,  //Главная страница редактора исключения
  fbmGeneratorMainEditorUnit,  //Главная страница редактора генератора

  fbmTableEditorIndexUnit,     //Страница редактора индексов
  fdbmTableEditorPKListUnit,   //Страница редактора первичного ключа
  fdbmTableEditorForeignKeyUnit,//Страница редактора внешнего ключа
  fbmUDFMainEditorUnit,        //Главная страница редактора UDF
  fbmDDLPageUnit, fbmFirebirdPackageUnit,              //Страница DDL
  fbmpgACLEditUnit,
  fdbmTableEditorUniqueUnit,
  fbmFirebirdTablePropsUnit
  ;

{ TFireBirdVisualTools }

procedure TFireBirdVisualTools.tlsBackupExecute(Sender: TObject);
begin
  ShowFBBackupForm;
end;

procedure TFireBirdVisualTools.tlsRestoreExecute(Sender: TObject);
begin
  ShowFBRestoreForm;
end;

procedure TFireBirdVisualTools.tlsDBShadowManagerExecute(Sender: TObject);
begin
  ShowShadowManagerForm;
end;

procedure TFireBirdVisualTools.tlsTranMonitorExecute(Sender: TObject);
begin
  ShowTransMonitor;
end;

procedure TFireBirdVisualTools.tlsShowUserManagerExecute(Sender: TObject);
begin
  ShowFBUserManager;
end;

class function TFireBirdVisualTools.GetCreateObject: TSQLEngineCreateDBAbstractClass;
begin
  Result:=TFBEngineCreateDBClass.Create;
end;

class function TFireBirdVisualTools.GetObjTemplatePagesCount: integer;
begin
  Result:=7;
end;

class function TFireBirdVisualTools.GetObjTemplate(Index: integer;
  Owner: TComponent): TFBMConfigPageAbstract;
begin
  case Index of
    0:Result:=TotFirebirdTriggerTemplatePage.CreateTools(Owner, false);
    1:Result:=TotFirebirdTriggerTemplatePage.CreateTools(Owner, true);
    2:Result:=TotFirebirdFunctionTemplatePage.CreateTools(Owner, false);
    3:Result:=TotFirebirdFunctionTemplatePage.CreateTools(Owner, true);
    4:Result:=TotFirebirdPackageTemplatePage.CreateTools(Owner, false);
    5:Result:=TotFirebirdPackageTemplatePage.CreateTools(Owner, true);
    6:begin
        Result:=TcfAutoIncFieldFrame.Create(Owner);
        TcfAutoIncFieldFrame(Result).SQLEngineClass:=TSQLEngineFireBird;
        TcfAutoIncFieldFrame(Result).PageNameStr:='FB : AutoIncParams';
        TcfAutoIncFieldFrame(Result).DummyTriggerText:=ssqlCreateAutoIncTriggerBody;
      end
  else
    Result:=nil;
  end;
end;

class function TFireBirdVisualTools.GetMenuItems(Index: integer): TMenuItemRec;
begin
//  Result:=inherited GetMenuItems(Index);
  FillChar(Result, Sizeof(Result), 0);
  Result.ImageIndex:=-1;
  case Index of
    0:begin
        Result.ItemName:=sFireBiredDBBackup;
        Result.OnClick:=@tlsBackupExecute;
        Result.ImageIndex:=14;
      end;
    1:begin
        Result.ItemName:=sFireBiredDBRestore;
        Result.OnClick:=@tlsRestoreExecute;
        Result.ImageIndex:=15;
      end;
    2:begin
        Result.ItemName:=sFireBiredDBShadMan;
        Result.OnClick:=@tlsDBShadowManagerExecute;
      end;
    3:begin
        Result.ItemName:=sFireBiredDBStat;
        Result.OnClick:=@tlsTranMonitorExecute;
      end;
    4:begin
        Result.ItemName:=sFireBiredUserManag;
        Result.OnClick:=@tlsShowUserManagerExecute;
        Result.ImageIndex:=3;
      end;
  end;
end;

class function TFireBirdVisualTools.GetMenuItemCount: integer;
begin
  Result:=5;
end;

class function TFireBirdVisualTools.ConfigDlgPageCount: integer;
begin
  Result:=2;
end;

class function TFireBirdVisualTools.ConfigDlgPage(APageNum: integer;
  AOwner: TForm): TFBMConfigPageAbstract;
begin
  case APageNum of
    0:Result:=TcfFireBirdOptionsFrame.Create(AOwner);
    1:Result:=TcfFirebirdTransactionsParamsFrame.Create(AOwner);
  else
    Result:=nil;
  end;
end;

constructor TFireBirdVisualTools.Create(ASQLEngine: TSQLEngineAbstract);
begin
  inherited Create(ASQLEngine);
  //Domains
  RegisterObjEditor(TFireBirdDomain,
    [TfbmDomainMainEditorFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmDomainMainEditorFrame, TDependenciesFrame, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  //Tables
  RegisterObjEditor(TFireBirdTable,
    [TfbmTableEditorFieldsFrame, TfbmFirebirdTablePropsPage, TfbmObjectEditorDescriptionFrame],
    [TfbmTableEditorFieldsFrame, TfbmTableEditorDataFrame,
     TfdbmTableEditorPKListFrame,
     TfdbmTableEditorForeignKeyFrame, TfdbmTableEditorUniqueFrame, TfbmpgTableCheckConstaintPage,
     TfbmTableEditorTriggersFrame, TfbmTableEditorIndexFrame,
     TDependenciesFrame,
     TfbmpgACLEditEditor, TfbmFirebirdTablePropsPage, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  //Views
  RegisterObjEditor(TFireBirdView,
    [TfbmViewEditorMainFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmViewEditorMainFrame, TfbmTableEditorFieldsFrame,
     TfbmTableEditorDataFrame, TDependenciesFrame, TfbmTableEditorTriggersFrame,
     TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  //Triggers
  RegisterObjEditor(TFireBirdTriger,
    [TfbTriggerHeaderEditFrame, TfbmObjectEditorDescriptionFrame],
    [TfbTriggerHeaderEditFrame, TDependenciesFrame, TfbmObjectEditorDescriptionFrame,
     TfbmDDLPage]);

  //Generators
  RegisterObjEditor(TFireBirdGenerator,
    [TfbmGeneratorMainEditorFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmGeneratorMainEditorFrame,
     TfbmpgACLEditEditor,
     TDependenciesFrame, TfbmObjectEditorDescriptionFrame,
     TfbmDDLPage]);

  //Stored procedures
  RegisterObjEditor(TFireBirdStoredProc,
    [TfbmSPEdtMainPageFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmSPEdtMainPageFrame, TDependenciesFrame, TfbmpgACLEditEditor, TfbmObjectEditorDescriptionFrame,
     TfbmDDLPage]);

  //Exceptions
  RegisterObjEditor(TFireBirdException,
    [TfbmExceptionMainEditorFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmExceptionMainEditorFrame, TDependenciesFrame, TfbmObjectEditorDescriptionFrame,
     TfbmDDLPage]);

  //Index
  RegisterObjEditor(TFireBirdIndex,
    [TfbmFBIndexEditorPage, TfbmObjectEditorDescriptionFrame],
    [TfbmFBIndexEditorPage, TDependenciesFrame, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  //UDF
  RegisterObjEditor(TFireBirdUDF,
    [TfbmUDFMainEditorFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmUDFMainEditorFrame, TfbmObjectEditorDescriptionFrame, TDependenciesFrame,
     TfbmDDLPage]);

  //Roles
  RegisterObjEditor(TFireBirdRole,
    [TfbmRoleMainEditorFrame, TfbmObjectEditorDescriptionFrame],
    [TfbmRoleMainEditorFrame, TfbmRoleGrantUsersFrame, TfbmRolesDBObjectsGrantForm,
     TDependenciesFrame, TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  //Packages
  RegisterObjEditor(TFireBirdPackage,
    [TfbmFirebirdPackageEditor, TfbmObjectEditorDescriptionFrame],
    [TfbmFirebirdPackageEditor, TDependenciesFrame,
    TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

  //Functions
  RegisterObjEditor(TFireBirdFunction,
    [TfbmFBFunctionEditor, TfbmObjectEditorDescriptionFrame],
    [TfbmFBFunctionEditor, TDependenciesFrame, TfbmpgACLEditEditor,
      TfbmObjectEditorDescriptionFrame, TfbmDDLPage]);

end;

procedure TFireBirdVisualTools.InitSQLSyn(const ASynSQLSyn: TSynSQLSyn);
begin
  ASynSQLSyn.SQLDialect:=sqlInterbase6;
end;

class function TFireBirdVisualTools.ConnectionDlgPageCount: integer;
begin
  Result:=8;
end;

class function TFireBirdVisualTools.ConnectionDlgPage(
  ASQLEngine: TSQLEngineAbstract; APageNum: integer; AOwner: TForm
  ): TPagedDialogPage;
begin
  case APageNum of
    0:Result:=TfbmCFMainFrame.Create(ASQLEngine as TSQLEngineFireBird, AOwner);
    1:Result:=TfdbmCFLogFrame.Create(ASQLEngine as TSQLEngineFireBird, AOwner);
    2:Result:=TfbmCFBackupFrame.Create(ASQLEngine as TSQLEngineFireBird, AOwner);
    3:Result:=TfbmCFRestoreFrame.Create(ASQLEngine as TSQLEngineFireBird, AOwner);
    4:Result:=TfbmCFTransactionFrame.Create(ASQLEngine as TSQLEngineFireBird, AOwner);
    5:Result:=TfdbmCFDisplayDataParamsPage.Create(ASQLEngine as TSQLEngineFireBird, AOwner);
    6:Result:=Tpg_con_EditorPrefPage.Create(ASQLEngine as TSQLEngineFireBird, AOwner);
    7:Result:=Tfdbm_DescriptionConnectionDlgPage.CreateDescriptionPage(ASQLEngine, AOwner);
  else
    Result:=nil;
  end;
end;

initialization
  RegisterSQLEngine(TSQLEngineFireBird, TFireBirdVisualTools, sFireBirdSQLServer);
end.

