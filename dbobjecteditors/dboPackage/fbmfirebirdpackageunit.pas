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

unit fbmFirebirdPackageUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  ExtCtrls, StdCtrls, fdmAbstractEditorUnit, fdbm_SynEditorUnit, sqlEngineTypes,
  SQLEngineAbstractUnit, fbmSqlParserUnit;

type

  { TfbmFirebirdPackageEditor }

  TfbmFirebirdPackageEditor = class(TEditorPage)
    Edit1: TEdit;
    Label1: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
  private
    FMenuDefineVariable: TMenuItem;
    HeaderFrame:Tfdbm_SynEditorFrame;
    BodyFrame:Tfdbm_SynEditorFrame;

    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure PrintPage;

    procedure UpdateEnvOptions;override;
    procedure RefreshObject;
    //procedure SynGetKeyWordList(Sender:Tfdbm_SynEditorFrame; const KeyStartWord:string; const Items:TSynCompletionObjList; ACharCase:TCharCaseOptions);
    function CommentCode:boolean;
    function UnCommentCode:boolean;
    procedure TextEditorChange(Sender: TObject);

    procedure DefinePopupMenu;
    procedure DoTextEditorDefineVariable(Sender: TObject);
    procedure TextEditorPopUpMenu(Sender: TObject);
  public
    procedure Localize;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation

uses fbmStrConstUnit, fbmToolsUnit, sqlObjects, FBSQLEngineUnit, fbSqlTextUnit,
  fb_SqlParserUnit, LR_Class;

{$R *.lfm}

{ TfbmFirebirdPackageEditor }

function TfbmFirebirdPackageEditor.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
  else
    Exit(false);
  end;
end;

function TfbmFirebirdPackageEditor.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=PageAction in [epaPrint, epaCompile]
end;

procedure TfbmFirebirdPackageEditor.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
//  frVariables['ObjectName']:=edtRoleName.Text;
//  fbManagerMainForm.LazReportPrint('DBObject_Package');
end;

procedure TfbmFirebirdPackageEditor.UpdateEnvOptions;
begin
  HeaderFrame.ChangeVisualParams;
  BodyFrame.ChangeVisualParams;
end;

procedure TfbmFirebirdPackageEditor.RefreshObject;
begin
  if DBObject.State <> sdboCreate then
  begin
    HeaderFrame.EditorText:=TFireBirdPackage(DBObject).PackageHeader;
    BodyFrame.EditorText:=TFireBirdPackage(DBObject).PackageBody;
    Edit1.Enabled:=false;
    Edit1.Text:=TFireBirdPackage(DBObject).Caption;
  end
  else
  begin
    HeaderFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/Package/Normal', fbSqlModule.fbtPackage.Strings.Text);
    BodyFrame.EditorText:=ConfigValues.ByNameAsString('ObjTemplate/FireBirdSQL/PackageBody/Normal', fbSqlModule.fbtPackageBody.Strings.Text);
  end;
end;

{procedure TfbmFirebirdPackageEditor.SynGetKeyWordList(
  Sender: Tfdbm_SynEditorFrame; const KeyStartWord: string;
  const Items: TSynCompletionObjList; ACharCase: TCharCaseOptions);
begin

end;
}
function TfbmFirebirdPackageEditor.CommentCode: boolean;
begin

end;

function TfbmFirebirdPackageEditor.UnCommentCode: boolean;
begin

end;

procedure TfbmFirebirdPackageEditor.TextEditorChange(Sender: TObject);
begin
  Modified:=true;
end;

procedure TfbmFirebirdPackageEditor.DefinePopupMenu;
begin
  FMenuDefineVariable:=BodyFrame.CreateCTMenuItem(sDefineVariable, @DoTextEditorDefineVariable, 1);
//  FMenuDefineInParam:=EditorFrame.CreateCTMenuItem(sDefineInParam, @DoTextEditorDefineVariable, 2);
end;

procedure TfbmFirebirdPackageEditor.DoTextEditorDefineVariable(Sender: TObject);
begin
{  S:=Trim(EditorFrame.TextEditor.SelText);
  if (S<>'') and IsValidIdent(S) then
  if (Sender as TComponent).Tag = 1 then
  begin
    if tabLocalVar.TabVisible then
    begin
      VariableFrame.AddVariable(S);
      PageControl1.ActivePage:=tabLocalVar;
    end;
  end
  else
  if (Sender as TComponent).Tag = 2 then
  begin
    InputParFrame.AddVariable(S);
    PageControl1.ActivePage:=tabInputParams;
  end}
end;

procedure TfbmFirebirdPackageEditor.TextEditorPopUpMenu(Sender: TObject);
var
  S: String;
begin
  S:=Trim(BodyFrame.TextEditor.SelText);
  //FMenuDefineVariable.Enabled:=tabLocalVar.TabVisible and (S<>'') and IsValidIdent(S);
  //FMenuDefineInParam.Enabled:=FMenuDefineVariable.Enabled;
end;

procedure TfbmFirebirdPackageEditor.Localize;
begin
  TabSheet1.Caption:=sPackageHeader;
  TabSheet2.Caption:=sPackageBody;
end;

function TfbmFirebirdPackageEditor.PageName: string;
begin
  Result:=sPackage;
end;

constructor TfbmFirebirdPackageEditor.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);

  HeaderFrame:=Tfdbm_SynEditorFrame.Create(Self);
  HeaderFrame.Parent:=TabSheet1;
  HeaderFrame.SQLEngine:=DBObject.OwnerDB;
  //HeaderFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  HeaderFrame.SQLEngine:=DBObject.OwnerDB;
  HeaderFrame.Name:='HeaderFrame';

  BodyFrame:=Tfdbm_SynEditorFrame.Create(Self);
  BodyFrame.Parent:=TabSheet2;
  BodyFrame.SQLEngine:=DBObject.OwnerDB;
  //BodyFrame.OnGetKeyWordList:=@SynGetKeyWordList;
  BodyFrame.SQLEngine:=DBObject.OwnerDB;
  BodyFrame.Name:='BodyFrame';

  RefreshObject;
end;

function TfbmFirebirdPackageEditor.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FCmd : TFBSQLCreatePackage absolute ASQLObject;
  FCmd1 : TFBSQLCreatePackage;
begin
  Result:=false;
  if ASQLObject is TFBSQLCreatePackage then
  begin
    { TODO : Временно - потом перепишем через парсер }
    FCmd.PackageText:=HeaderFrame.EditorText;
    FCmd.Name:=Edit1.Text;
    FCmd1 := TFBSQLCreatePackage.Create(FCmd.Parent);
    FCmd1.ObjectKind:=okPackageBody;
    FCmd.AddChild(FCmd1);
    FCmd1.PackageText:=BodyFrame.EditorText;
    FCmd1.Name:=FCmd.Name;
//    FCmd1.CreateMode:=FCmd.CreateMode;
    Result:=true;
  end;
end;

end.

