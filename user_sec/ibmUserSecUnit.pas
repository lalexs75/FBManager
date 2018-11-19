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

unit ibmUserSecUnit;

{$I fbmanager_define.inc}

interface 

uses 
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLType, ComCtrls, StdCtrls, Buttons, ActnList, uib, LMessages,
  IBManagerTypesUnit, fbmToolsUnit, DBGrids, DB, rxdbgrid, rxmemds, rxtoolbar,
  RxIniPropStorage, RxDBGridExportSpreadSheet, RxDBGridPrintGrid,
  RxDBGridFooterTools, Menus, LR_DBSet, LR_Class, FBCustomDataSet,
  FBSQLEngineUnit;

type 

  { TibmUserSecForm }

  TibmUserSecForm = class (TForm)
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu2: TPopupMenu;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    roleCopy: TAction;
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    frUserRoles: TfrDBDataSet;
    RxDBGridExportSpreadSheet1: TRxDBGridExportSpreadSheet;
    RxDBGridFooterTools1: TRxDBGridFooterTools;
    RxDBGridPrint1: TRxDBGridPrint;
    RxIniPropStorage1: TRxIniPropStorage;
    rxRolesListROLE_NAME1: TStringField;
    rxUsersListDescription: TStringField;
    rxUsersListFirstName: TStringField;
    rxUsersListGroupID: TLongintField;
    rxUsersListLastName: TStringField;
    rxUsersListMiddleName: TStringField;
    rxUsersListUserID: TLongintField;
    rxUsersListUserName: TStringField;
    urPrintList: TAction;
    dsUserRoles: TDatasource;
    dsUsersList: TDatasource;
    dsUsersListRoles: TDatasource;
    quUserRoles: TFBDataSet;
    frUserList: TfrDBDataSet;
    frUsersListRoles: TfrDBDataSet;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    RxDBGrid2: TRxDBGrid;
    RxDBGrid3: TRxDBGrid;
    RxDBGrid4: TRxDBGrid;
    rxUsersList: TRxMemoryData;
    rxUsersListRoles: TRxMemoryData;
    Splitter1: TSplitter;
    ToolPanel3: TToolPanel;
    usrPrint: TAction;
    frRolesList: TfrDBDataSet;
    rolePrint: TAction;
    roleDelete: TAction;
    roleNew: TAction;
    dsRolesList: TDatasource;
    UIBSecurity1: TUIBSecurity;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxRolesList: TRxMemoryData;
    ToolPanel1: TToolPanel;
    ToolPanel2: TToolPanel;
    usrEdit: TAction;
    usrDel: TAction;
    usrAdd: TAction;
    srvConnect: TAction;
    ActionList1: TActionList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabRoles: TTabSheet;
    TabMembers: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ibmUserSecFormClose(Sender: TObject; var CloseAction: TCloseAction
      );
    procedure ibmUserSecFormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure quUserRolesFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure RadioButton1Click(Sender: TObject);
    procedure roleCopyExecute(Sender: TObject);
    procedure rolePrintExecute(Sender: TObject);
    procedure urPrintListExecute(Sender: TObject);
    procedure usrDelExecute(Sender: TObject);
    procedure usrAddExecute(Sender: TObject);
    procedure usrEditExecute(Sender: TObject);
    procedure usrPrintExecute(Sender: TObject);
  private
    FCurRec:TSQLEngineFireBird;
    FUserName:string;
    FUserPassword:string;
    FProptocol:TUIBProtocol;
    FServerName:string;
    FDataBaseCaption:string;
    procedure ClearList;
    procedure Localize;
  public
    procedure ShowList;
  end;


procedure ShowFBUserManager;
implementation 
uses IBManDataInspectorUnit, ibmUserSecEditUserUnit,
  IBManMainUnit, ibm_loginform, uibase, Clipbrd, fbmStrConstUnit;

{$R *.lfm}

var
  ibmUserSecForm: TibmUserSecForm = nil;

procedure ShowFBUserManager;
begin
{  if not Assigned(ibmUserSecForm) then
    ibmUserSecForm:=TibmUserSecForm.Create(Application);
  ibmUserSecForm.Show;}
  fbManagerMainForm.RxMDIPanel1.ChildWindowsCreate(ibmUserSecForm, TibmUserSecForm)
end;

{ TibmUserSecForm }

procedure TibmUserSecForm.ibmUserSecFormCreate(Sender: TObject);
begin
  Localize;
  PageControl1.ActivePageIndex:=0;
  TabRoles.TabVisible:=false;
  TabMembers.TabVisible:=false;
  
  UIBSecurity1.LibraryName:=GDS32DLL;

  ComboBox2.ItemIndex:=fbManDataInpectorForm.DBList.FillDataBaseList(ComboBox2.Items, TSQLEngineFireBird);
  fbManDataInpectorForm.DBList.FillServerList(ComboBox1.Items, TSQLEngineFireBird);

  if ComboBox2.ItemIndex>-1 then
    ComboBox2Change(nil);
end;

procedure TibmUserSecForm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 2 then
  begin
    quUserRoles.DataBase:=FCurRec.FBDatabase;
    quUserRoles.Transaction:=FCurRec.FBTransaction;
    rxUsersListRoles.LoadFromDataSet(rxUsersList, 0, lmAppend);
    quUserRoles.Open;
  end
  else
  begin
    quUserRoles.Close;
    rxUsersListRoles.Close;
  end;
end;


procedure TibmUserSecForm.quUserRolesFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept:=quUserRoles.FieldByName('G').AsInteger=1;
end;

procedure TibmUserSecForm.RadioButton1Click(Sender: TObject);
begin
  ComboBox2.Enabled:=RadioButton1.Checked;
  ComboBox1.Enabled:=RadioButton2.Checked;
  Button1.Enabled:=RadioButton2.Checked;
end;

procedure TibmUserSecForm.roleCopyExecute(Sender: TObject);
begin
  Clipboard.AsText:=rxRolesListROLE_NAME1.AsString;
end;

procedure TibmUserSecForm.rolePrintExecute(Sender: TObject);
begin
  frVariables['Database_name']:=FDataBaseCaption;
  fbManagerMainForm.LazReportPrint('roles_list');
end;

procedure TibmUserSecForm.urPrintListExecute(Sender: TObject);
begin
  frVariables['Database_name']:=FDataBaseCaption;
  try
    quUserRoles.Filtered:=true;
    fbManagerMainForm.LazReportPrint('user_roles_list');
  finally
    quUserRoles.Filtered:=false;
  end;
end;

procedure TibmUserSecForm.usrDelExecute(Sender: TObject);
begin
  if rxUsersList.RecordCount>0 then
  begin
    if MessageDlg(sConfirm, Format(sDelUserConfirm, [rxUsersListUserName.AsString]), mtConfirmation, mbOKCancel, 0)=id_Yes then
    try
      UIBSecurity1.User:=rxUsersListUserName.AsString;
      UIBSecurity1.DeleteUser;
    except
      on E:Exception do
        ErrorBox(E.Message)
    end;
    ShowList;
  end;
end;

procedure TibmUserSecForm.usrAddExecute(Sender: TObject);
begin
  ibmUserSecEditUserForm:=TibmUserSecEditUserForm.Create(Application);
  try
    if ibmUserSecEditUserForm.ShowModal = mrOk then
    begin
      try
        UIBSecurity1.User:=ibmUserSecEditUserForm.Edit1.Text;
        UIBSecurity1.Pass:=ibmUserSecEditUserForm.Edit2.Text;
        UIBSecurity1.FirstName:=ibmUserSecEditUserForm.Edit4.Text;
        UIBSecurity1.MiddleName:=ibmUserSecEditUserForm.Edit5.Text;
        UIBSecurity1.LastName:=ibmUserSecEditUserForm.Edit6.Text;
        UIBSecurity1.AddUser;
      except
        on E:Exception do
          ErrorBox(E.Message)
      end;
    end
  finally
    ibmUserSecEditUserForm.Free;
  end;
  ShowList;
end;

procedure TibmUserSecForm.usrEditExecute(Sender: TObject);
begin
  if rxUsersList.RecordCount>0 then
  begin
    ibmUserSecEditUserForm:=TibmUserSecEditUserForm.Create(Application);
    ibmUserSecEditUserForm.Edit1.Text:=rxUsersListUserName.AsString;
    ibmUserSecEditUserForm.Edit1.Enabled:=false;
    ibmUserSecEditUserForm.Edit4.Text:=rxUsersListFirstName.AsString;
    ibmUserSecEditUserForm.Edit5.Text:=rxUsersListMiddleName.AsString;
    ibmUserSecEditUserForm.Edit6.Text:=rxUsersListLastName.AsString;
    ibmUserSecEditUserForm.Memo1.Text:=rxUsersListDescription.AsString;
    ibmUserSecEditUserForm.SpinEdit1.Value:=rxUsersListUserID.AsInteger;
    ibmUserSecEditUserForm.SpinEdit2.Value:=rxUsersListGroupID.AsInteger;
    try
      if ibmUserSecEditUserForm.ShowModal = mrOk then
      begin
        try
          UIBSecurity1.User:=ibmUserSecEditUserForm.Edit1.Text;
          UIBSecurity1.Pass:=ibmUserSecEditUserForm.Edit2.Text;
          UIBSecurity1.FirstName:=ibmUserSecEditUserForm.Edit4.Text;
          UIBSecurity1.MiddleName:=ibmUserSecEditUserForm.Edit5.Text;
          UIBSecurity1.LastName:=ibmUserSecEditUserForm.Edit6.Text;
          UIBSecurity1.UserID:=ibmUserSecEditUserForm.SpinEdit1.Value;
          UIBSecurity1.GroupID:=ibmUserSecEditUserForm.SpinEdit2.Value;
          UIBSecurity1.ModifyUser;
          rxUsersList.Edit;
          rxUsersListFirstName.AsString:=ibmUserSecEditUserForm.Edit4.Text;
          rxUsersListMiddleName.AsString:=ibmUserSecEditUserForm.Edit5.Text;
          rxUsersListLastName.AsString:=ibmUserSecEditUserForm.Edit6.Text;
          rxUsersListDescription.AsString:=ibmUserSecEditUserForm.Memo1.Text;
          rxUsersListUserID.AsInteger:=ibmUserSecEditUserForm.SpinEdit1.Value;
          rxUsersListGroupID.AsInteger:=ibmUserSecEditUserForm.SpinEdit2.Value;
          rxUsersList.Post;
        except
          on E:Exception do
            ErrorBox(E.Message)
        end;
      end
    finally
      ibmUserSecEditUserForm.Free;
    end;
  end;
end;

procedure TibmUserSecForm.usrPrintExecute(Sender: TObject);
begin
  frVariables['Database_name']:=FDataBaseCaption;
  fbManagerMainForm.LazReportPrint('users_list');
end;

procedure TibmUserSecForm.ClearList;
begin
  rxUsersList.CloseOpen;
end;

procedure TibmUserSecForm.Localize;
begin
  Caption:=sFireBiredUserManag;
  RadioButton1.Caption:=sDatabase;
  RadioButton2.Caption:=sServerName1;
  srvConnect.Caption:=sConnect;
  TabSheet1.Caption:=sUserList;
  TabRoles.Caption:=sRoles;
  TabMembers.Caption:=sMembers;
  usrAdd.Caption:=sAdd;
  usrAdd.Hint:=sAddUserHint;
  usrEdit.Caption:=sEdit;
  usrEdit.Hint:=sEditUserInList;
  usrDel.Caption:=sDelete;
  usrDel.Hint:=sDeleteUserFromServerUserList;
  roleNew.Caption:=sNewRole;
  roleDelete.Caption:=sDeleteRole;
  rolePrint.Caption:=sPrint;
  usrPrint.Caption:=sPrint;
  usrPrint.Hint:=sPrintUserList;
  urPrintList.Caption:=sPrintList;
  urPrintList.Hint:=sPrintListOfAllUserAndRoles;
  roleCopy.Caption:=sCopy;
  roleCopy.Hint:=sCopyRoleNameToClipboard;
  RxDBGrid2.ColumnByFieldName('UserName').Title.Caption:=sUserName1;
  RxDBGrid2.ColumnByFieldName('FirstName').Title.Caption:=sFirstName;
  RxDBGrid2.ColumnByFieldName('MiddleName').Title.Caption:=sMiddleName;
  RxDBGrid2.ColumnByFieldName('LastName').Title.Caption:=sLastName;

  RxDBGrid1.ColumnByFieldName('ROLE_NAME').Title.Caption:=sRoleName1;

  RxDBGrid3.ColumnByFieldName('UserName').Title.Caption:=sUserName1;

  RxDBGrid4.ColumnByFieldName('ROLE_NAME').Title.Caption:=sRoleName1;
end;

procedure TibmUserSecForm.Button1Click(Sender: TObject);
begin
  if ComboBox1.Text <> '' then
  begin
    ShowList;
  end;
end;

procedure TibmUserSecForm.ComboBox2Change(Sender: TObject);
var
  i:integer;
begin
  FCurRec:=ComboBox2.Items.Objects[ComboBox2.ItemIndex] as TSQLEngineFireBird;
  FUserName:=FCurRec.UserName;
  FUserPassword:=FCurRec.Password;
  FProptocol:=FCurRec.Protocol;
  FServerName:=FCurRec.ServerName;
  PageControl1.ActivePageIndex:=0;

  ShowList;

  TabRoles.TabVisible:=FCurRec.Connected;
  TabMembers.TabVisible:=FCurRec.Connected;
  FDataBaseCaption:='';
  if FCurRec.Connected then
  begin
    FDataBaseCaption:=FCurRec.AliasName;
    rxRolesList.CloseOpen;
    for i:=0 to FCurRec.RoleRoot.CountObject-1 do
    begin
      rxRolesList.Append;
      rxRolesList.FieldByName('ROLE_NAME').AsString:=FCurRec.RoleRoot.Items[i].Caption;
      rxRolesList.Post;
    end;
  end;
end;

procedure TibmUserSecForm.ibmUserSecFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  ibmUserSecForm:=nil;
end;

procedure TibmUserSecForm.ShowList;
var
  i:integer;
begin
  rxUsersList.CloseOpen;
  try
    UIBSecurity1.Protocol:=FProptocol;
    UIBSecurity1.UserName:=FUserName;
    UIBSecurity1.PassWord:=FUserPassword;
    UIBSecurity1.Host:=FServerName;
    UIBSecurity1.DisplayUsers;
    for i:=0 to UIBSecurity1.UserInfoCount-1 do
    begin
      rxUsersList.Append;
      rxUsersList.FieldByName('UserName').AsString:=UIBSecurity1.UserInfo[i].UserName;
      rxUsersList.FieldByName('FirstName').AsString:=UIBSecurity1.UserInfo[i].FirstName;
      rxUsersList.FieldByName('MiddleName').AsString:=UIBSecurity1.UserInfo[i].MiddleName;
      rxUsersList.FieldByName('LastName').AsString:=UIBSecurity1.UserInfo[i].LastName;
//      rxUsersList.FieldByName('Description').AsString:=UIBSecurity1.UserInfo[i].UserName;
      rxUsersList.FieldByName('UserID').AsInteger:=UIBSecurity1.UserInfo[i].UserID;
      rxUsersList.FieldByName('GroupID').AsInteger:=UIBSecurity1.UserInfo[i].GroupID;
      rxUsersList.Post;
    end;
  except
    on E:Exception do
      ErrorBox(E.Message);
  end;
end;

end.

