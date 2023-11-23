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

unit fbmFBUserMainEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit, fbmCompillerMessagesUnit,
  ExtCtrls, Menus, DB, RxDBGrid, rxmemds, fdmAbstractEditorUnit,
  SQLEngineAbstractUnit, fbmSqlParserUnit, FBSQLEngineUnit,
  FBSQLEngineSecurityUnit;

type

  { TfbmFBUserMainEditorFrame }

  TfbmFBUserMainEditorFrame = class(TEditorPage)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    dsUserAtribs: TDataSource;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CLabel: TLabel;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxUserAtribs: TRxMemoryData;
    rxUserAtribsATTRIB_KEY: TStringField;
    rxUserAtribsATTRIB_VALUE: TStringField;
    rxUserAtribsIS_DELETED: TBooleanField;
    rxUserAtribsIS_EXISTS: TBooleanField;
    rxUserAtribsOLD_ATTRIB_VALUE: TStringField;
    procedure rxUserAtribsAfterInsert(DataSet: TDataSet);
    procedure rxUserAtribsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    procedure PrintPage;
    procedure LoadUserData;
    function ValidateData:Boolean;
    function ppMsgListDblClick(Sender:TfbmCompillerMessagesFrame;  AInfo:TppMsgRec):Boolean; override;
  public
    procedure Localize;override;
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses LR_Class, fbmStrConstUnit, IBManMainUnit, fb_SqlParserUnit;

{$R *.lfm}

{ TfbmFBUserMainEditorFrame }

procedure TfbmFBUserMainEditorFrame.rxUserAtribsAfterInsert(DataSet: TDataSet);
begin
  rxUserAtribsIS_EXISTS.AsBoolean:=false;
  rxUserAtribsIS_DELETED.AsBoolean:=false;
end;

procedure TfbmFBUserMainEditorFrame.rxUserAtribsFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept:=not rxUserAtribsIS_DELETED.AsBoolean;
end;

function TfbmFBUserMainEditorFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaPrint:PrintPage;
    epaRefresh:
      begin
        DBObject.RefreshObject;
        LoadUserData;
      end;
  end;
end;

function TfbmFBUserMainEditorFrame.ActionEnabled(PageAction: TEditorPageAction
  ): boolean;
begin
  if DBObject.State = sdboCreate then
    Result:=PageAction in [epaPrint, epaCompile]
  else
    Result:=PageAction in [epaPrint, epaCompile, epaRefresh];
end;

procedure TfbmFBUserMainEditorFrame.PrintPage;
begin
  frVariables['DBClassTitle']:=DBObject.DBClassTitle;
  frVariables['ObjectName']:=Edit1.Text;
  fbManagerMainForm.LazReportPrint('DBObject_User');
end;

procedure TfbmFBUserMainEditorFrame.LoadUserData;
var
  F: TFireBirUser;
  i: Integer;
begin
  Edit2.Text:='';
  Edit3.Text:='';
  rxUserAtribs.CloseOpen;
  rxUserAtribs.Filtered:=true;
  if DBObject.State = sdboCreate then Exit;

  Edit1.Text:=DBObject.Caption;
  F:=TFireBirUser(DBObject);
  Edit4.Text:=F.FirstName;
  Edit5.Text:=F.MiddleName;
  Edit6.Text:=F.LastName;
  Edit7.Text:=F.Plugin;
  CheckBox2.Checked:=F.Active;
  CheckBox1.Checked:=F.IsAdmin;

  for i:=0 to F.Params.Count-1 do
  begin
    rxUserAtribs.Append;
    rxUserAtribsATTRIB_KEY.AsString:=F.Params.Names[i];
    rxUserAtribsATTRIB_VALUE.AsString:=F.Params.ValueFromIndex[i];
    rxUserAtribsOLD_ATTRIB_VALUE.AsString:=F.Params.ValueFromIndex[i];
    rxUserAtribsIS_EXISTS.AsBoolean:=true;
    rxUserAtribs.Post;
  end;
  rxUserAtribs.First;
end;

function TfbmFBUserMainEditorFrame.ValidateData: Boolean;
begin
  Result:=true;
  if DBObject.State = sdboCreate then
  begin
    Result:=IsValidIdent(Edit1.Text);
    if not Result then
      ShowMsg(ppNone, sErrorDefineUserName, 1, 0);
    if (Trim(Edit2.Text) = '') or (Edit2.Text<>Edit3.Text) then
    begin
      ShowMsg(ppNone, sErrorDefineUserPassword, 4, 0);
      Exit(false);
    end;
  end
  else
  begin;
    if (Trim(Edit2.Text) <> '') and (Edit2.Text<>Edit3.Text) then
    begin
      ShowMsg(ppNone, sErrorDefineUserPassword, 4, 0);
      Exit(false);
    end;
  end;

  if (Edit7.Text<>'') and not IsValidIdent(Edit7.Text) then
  begin
    ShowMsg(ppNone, sErrorDefineAuthPluginName, 2, 0);
    Exit(false);
  end;

  rxUserAtribs.First;
  while not rxUserAtribs.EOF do
  begin
    if not IsValidIdent(rxUserAtribsATTRIB_KEY.AsString) then
    begin
      ShowMsg(ppNone, Format(sErrorDefineAttributeName, [rxUserAtribsATTRIB_KEY.AsString]), 3, rxUserAtribs.RecNo);
      RxDBGrid1.SelectedField:=rxUserAtribsATTRIB_KEY;
      Exit(false);
    end;
    rxUserAtribs.Next;
  end;
  rxUserAtribs.First;
end;

function TfbmFBUserMainEditorFrame.ppMsgListDblClick(
  Sender: TfbmCompillerMessagesFrame; AInfo: TppMsgRec): Boolean;
begin
  case AInfo.Info1 of
    1:Edit1.SetFocus;
    2:Edit7.SetFocus;
    3:begin
        RxDBGrid1.SetFocus;
        RxDBGrid1.SelectedField:=rxUserAtribsATTRIB_KEY;
        rxUserAtribs.RecNo:=AInfo.Info2;
      end;
    4:Edit2.SetFocus;
  end;
end;

procedure TfbmFBUserMainEditorFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sUserName1;
  Label2.Caption:=sPassword;
  Label3.Caption:=sConfirmPassword; //!!

  Label4.Caption:=sFirstName;
  Label5.Caption:=sMiddleName;
  Label6.Caption:=sLastName;

  Label7.Caption:=sPlugin;
//  Label8.Caption:=satPlugin;

  CheckBox1.Caption:=sAdminRole;
  CheckBox2.Caption:=sActive;
  RxDBGrid1.ColumnByFieldName('ATTRIB_KEY').Title.Caption:=sAttributeName;
  RxDBGrid1.ColumnByFieldName('ATTRIB_VALUE').Title.Caption:=sAttributeValue;

end;

function TfbmFBUserMainEditorFrame.PageName: string;
begin
  Result:=sUser;
end;

constructor TfbmFBUserMainEditorFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  LoadUserData;
end;

function TfbmFBUserMainEditorFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
var
  FC: TFBSQLCreateUser;
  FA: TFBSQLAlterUser;
  i: Integer;
  FO: TFireBirUser;
begin
  Result:=false;
  if not ValidateData then Exit;

  if ASQLObject is TFBSQLCreateUser then
  begin
    FC:=TFBSQLCreateUser(ASQLObject);
    FC.Name:=Edit1.Text;
    FC.FirstName:=Edit4.Text;
    FC.MiddleName:=Edit5.Text;
    FC.LastName:=Edit6.Text;
    FC.Password:=Edit2.Text;
    FC.PluginName:=Edit7.Text;

    if CheckBox1.Checked then
      FC.GrantOptions:=goGrant;

    if CheckBox2.Checked then
      FC.State:=trsActive
    else
      FC.State:=trsInactive;

    rxUserAtribs.Filtered:=false;
    rxUserAtribs.First;
    while not rxUserAtribs.EOF do
    begin
      FC.Params.AddParamEx(rxUserAtribsATTRIB_KEY.AsString, rxUserAtribsATTRIB_VALUE.AsString);
      rxUserAtribs.Next;
    end;
    rxUserAtribs.First;
    rxUserAtribs.Filtered:=true;
    Result:=true;
  end
  else
  if ASQLObject is TFBSQLAlterUser then
  begin
    FA:=ASQLObject as TFBSQLAlterUser;
    FO:=TFireBirUser(DBObject);


    if Edit2.Text<>'' then
    begin
      FA.Password:=Edit2.Text;
      Result:=true;
    end;

    if Edit4.Text<>FO.FirstName then
    begin
      FA.FirstName:=Edit4.Text;
      Result:=true;
    end;

    if Edit5.Text<>FO.MiddleName then
    begin
      FA.MiddleName:=Edit5.Text;
      Result:=true;
    end;

    if Edit6.Text<>FO.LastName then
    begin
      FA.LastName:=Edit6.Text;
      Result:=true;
    end;

    if CheckBox2.Checked <> FO.Active then
    begin
      Result:=true;
      if CheckBox2.Checked then
        FA.State := trsActive
      else
        FA.State := trsInactive;
    end;

    if CheckBox1.Checked <> FO.IsAdmin then
    begin
      Result:=true;
      if CheckBox1.Checked then
        FA.GrantOptions := goGrant
      else
        FA.GrantOptions := goRevoke;
    end;

    if Edit7.Text<>FO.Plugin then
    begin
      FA.PluginName:=Edit7.Text;
      Result:=true;
    end;
  end;
end;

end.

