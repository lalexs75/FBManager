{ Free DB Manager

  Copyright (C) 2005-2021 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbm_cf_mainunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, FBSQLEngineUnit,
  fbmConnectionEditUnit, StdCtrls, Buttons, SQLEngineAbstractUnit, EditBtn,
  Spin, Controls, uib, fdbm_ConnectionAbstractUnit;

type

  { TfbmCFMainFrame }

  TfbmCFMainFrame = class(TConnectionDlgPage)
    CB_CharSet: TComboBox;
    cbProtocol: TComboBox;
    CB_ServerVersion: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    edtAliasName: TEdit;
    edtDBName: TFileNameEdit;
    EditPassword: TEdit;
    EditRole: TEdit;
    cbServerName: TComboBox;
    EditUserName: TEdit;
    edtPort: TSpinEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpeedButton1: TSpeedButton;
    UIBDataBaseTest: TUIBDataBase;
    procedure cbProtocolChange(Sender: TObject);
    procedure edtDBNameChange(Sender: TObject);
    procedure edtDBNameExit(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FSQLEngineFireBird:TSQLEngineFireBird;
  protected
    procedure InitFrame;
    function MakeConnectionStr:string;
  public
    procedure Localize;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    function TestConnection:boolean;override;
    constructor Create(ASQLEngineFireBird:TSQLEngineFireBird; AOwner:TForm);
  end;

implementation
uses rxAppUtils, rxlogging, StrUtils, fbmStrConstUnit, IBManDataInspectorUnit,
  ibmanagertypesunit, SQLEngineCommonTypesUnit, fbmToolsUnit, Clipbrd, fb_utils;

{$R *.lfm}

{ TfbmCFMainFrame }

procedure TfbmCFMainFrame.edtDBNameExit(Sender: TObject);
var
  S, sServName: string;
  L: Integer;
begin
  S:=edtDBName.Text;
  L:=Pos(':', S);
  if L>0 then
  begin
    sServName:=Copy2SymbDel(S, ':');
    if sServName<>'' then
    begin
      edtDBName.Text:=S;
      cbServerName.Text:=sServName;
      cbProtocol.ItemIndex:=1;
      cbProtocolChange(nil);
    end;
  end;
  if edtAliasName.Text = '' then
    edtAliasName.Text:=Format(sAliasOfDB, [edtDBName.Text]);
end;

procedure TfbmCFMainFrame.SpeedButton1Click(Sender: TObject);
begin
  Clipboard.Open;
  Clipboard.AsText:=Edit1.Text;
  Clipboard.Close;
  InfoBox(sConnectionStringCopied);
end;

procedure TfbmCFMainFrame.cbProtocolChange(Sender: TObject);
begin
  cbServerName.Enabled:=cbProtocol.ItemIndex<>0;
  Label2.Enabled:=cbProtocol.ItemIndex<>0;
  edtPort.Enabled:=cbProtocol.ItemIndex<>0;
  Label11.Enabled:=cbProtocol.ItemIndex<>0;

  edtDBNameChange(nil);
end;

procedure TfbmCFMainFrame.edtDBNameChange(Sender: TObject);
begin
  Edit1.Text:=MakeConnectionStr;
end;

procedure TfbmCFMainFrame.InitFrame;
begin
  fbManDataInpectorForm.DBList.FillServerList(cbServerName.Items, TSQLEngineFireBird);
  cbProtocol.Items.Clear;
  cbProtocol.Items.Add(sProtokol1);
  cbProtocol.Items.Add(sProtokol2);
  cbProtocol.Items.Add(sProtokol3);
  cbProtocol.ItemIndex:=0;
  cbProtocolChange(nil);
  FSQLEngineFireBird.FillCharSetList(CB_CharSet.Items);
end;

function TfbmCFMainFrame.MakeConnectionStr: string;
begin
  Result:='';
  case cbProtocol.ItemIndex of
    1:begin
        Result:=cbServerName.Text;
        if edtPort.Value <> FireBirdDefTCPPort then
          Result:=Result + '/' + IntToStr(edtPort.Value);
        Result:=Result + ':' + edtDBName.Text;
      end;
    2:Result:='\\'+cbServerName.Text+'\'+edtDBName.Text;
  else
    Result:=edtDBName.Text;
  end;
end;

procedure TfbmCFMainFrame.Localize;
begin
  inherited Localize;
  Label2.Caption:=sServerName1;
  Label3.Caption:=sProtocol;
  Label4.Caption:=sDatabaseFile;
  Label5.Caption:=sDatabaseAlias;
  Label6.Caption:=sUserName1;
  Label7.Caption:=sPassword;
  Label8.Caption:=sRole;
  Label9.Caption:=sCharSet;
  Label14.Caption:=sServerVersion1;
  Label10.Caption:=sClientLibraryName;
  Label11.Caption:=sPort;
  CheckBox1.Caption:=sAutoGrantOnCompileObject;
  CheckBox2.Caption:=sAlwaysCapitalizeDBObjectsNames;
  Label12.Caption:=sConnectionString;
  SpeedButton1.Hint:=sCopyConnectionString;
end;

procedure TfbmCFMainFrame.LoadParams(ASQLEngine:TSQLEngineAbstract);
begin
  InitFrame;

  edtDBName.Text:=ASQLEngine.DataBaseName;
  EditUserName.Text:=ASQLEngine.UserName;
  EditPassword.Text:=ASQLEngine.Password;
  edtAliasName.Text      := ASQLEngine.AliasName;
  cbServerName.Text:=ASQLEngine.ServerName;

  EditRole.Text           := TSQLEngineFireBird(ASQLEngine).RoleName;
  CB_CharSet.Text         := TSQLEngineFireBird(ASQLEngine).CharSet;

  cbProtocol.ItemIndex:=Ord(TSQLEngineFireBird(ASQLEngine).Protocol);
  CB_ServerVersion.ItemIndex:=Ord(TSQLEngineFireBird(ASQLEngine).ServerVersion);

  CheckBox1.Checked:=TSQLEngineFireBird(ASQLEngine).AutoGrantObject;
  FileNameEdit1.FileName:=TSQLEngineFireBird(ASQLEngine).LibraryName;
  CheckBox2.Checked:=ASQLEngine.MiscOptions.ObjectNamesCharCase = ccoUpperCase;
  edtPort.Value:=ASQLEngine.RemotePort;
  cbProtocolChange(nil);
end;

procedure TfbmCFMainFrame.SaveParams;
begin
  FSQLEngineFireBird.DataBaseName:=edtDBName.Text;
  FSQLEngineFireBird.AliasName:=edtAliasName.Text;
  FSQLEngineFireBird.UserName:=EditUserName.Text;
  FSQLEngineFireBird.RoleName:=EditRole.Text;
  FSQLEngineFireBird.Password:=EditPassword.Text;
  FSQLEngineFireBird.ServerName:=cbServerName.Text;
  FSQLEngineFireBird.CharSet:=CB_CharSet.Text;
  FSQLEngineFireBird.RemotePort:=edtPort.Value;
  FSQLEngineFireBird.Protocol:=TUIBProtocol(cbProtocol.ItemIndex);
  FSQLEngineFireBird.ServerVersion:=TFBServerVersion(CB_ServerVersion.ItemIndex);

  FSQLEngineFireBird.AutoGrantObject:=CheckBox1.Checked;
  //FSQLEngineFireBird.LibraryName:=FileNameEdit1.FileName;
  if CheckBox2.Checked then
    FSQLEngineFireBird.MiscOptions.ObjectNamesCharCase:=ccoUpperCase
  else
    FSQLEngineFireBird.MiscOptions.ObjectNamesCharCase:=ccoNoneCase;
end;

function TfbmCFMainFrame.PageName: string;
begin
  Result:=sGeneral;
end;

function TfbmCFMainFrame.Validate: boolean;
begin
  Result:=Trim(edtAliasName.Text)<>'';
  if not Result then
  begin
    ErrorBox(sConnectionNameNotSpecified);
    Exit;
  end;
end;

function TfbmCFMainFrame.TestConnection: boolean;
begin
  RxWriteLog(etDebug, 'TfbmCFMainFrame.TestConnection');

  UIBDataBaseTest.UserName:=EditUserName.Text;
  UIBDataBaseTest.PassWord:=EditPassword.Text;
  UIBDataBaseTest.Role:=EditRole.Text;
  UIBDataBaseTest.DatabaseName:=MakeConnectionStr;
  UIBDataBaseTest.LibraryName:=GetDefaultFB3Lib;

  Result:=false;
  try
    UIBDataBaseTest.Connected:=true;
    UIBDataBaseTest.Connected:=false;
    Result:=true;
  except
    on E:Exception do
      ErrorBoxExcpt(E);
  end;
end;

constructor TfbmCFMainFrame.Create(ASQLEngineFireBird: TSQLEngineFireBird; AOwner:TForm);
begin
  inherited Create(AOwner);
  FSQLEngineFireBird:=ASQLEngineFireBird;
  fbManDataInpectorForm.DBList.FillServerList(cbServerName.Items, TSQLEngineFireBird);
  FillStrServersVer(CB_ServerVersion.Items);
  cbProtocolChange(nil);
end;

end.

