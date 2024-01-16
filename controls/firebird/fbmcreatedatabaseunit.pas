{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmCreateDataBaseUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Buttons, uib, ButtonPanel,
  SQLEngineAbstractUnit, uiblib, RxIniPropStorage;

type

  { TfbmCreateDataBaseForm }

  TfbmCreateDataBaseForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    cbServName: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    cbProtocol: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    edtUserName: TEdit;
    edtUserPassword: TEdit;
    edtDBName: TFileNameEdit;
    edtLibName: TFileNameEdit;
    edtLogName: TFileNameEdit;
    RxIniPropStorage1: TRxIniPropStorage;
    UIBDataBase1: TUIBDataBase;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbServTypeChange(Sender: TObject);
  private
    procedure Localize;
  public
    procedure CreateDataBase;
  end; 

type

  { TFBEngineCreateDBClass }

  TFBEngineCreateDBClass = class(TSQLEngineCreateDBAbstractClass)
    FProtocol:TUIBProtocol;
    FLibraryName:string;
    FDBPageSize:integer;
    FCharacterSet:TCharacterSet;
    FSQLDialect:integer;
    function Execute:boolean;override;
    function CreateSQLEngine:TSQLEngineAbstract;override;
    constructor Create;override;
  end;

implementation
uses fbmToolsUnit, IBManDataInspectorUnit, fbmStrConstUnit, fb_ConstUnit,
  FBSQLEngineUnit, fb_utils;

{$R *.lfm}

{ TfbmCreateDataBaseForm }

procedure TfbmCreateDataBaseForm.cbServTypeChange(Sender: TObject);
begin
  Label2.Enabled:=cbProtocol.ItemIndex <> 0;
  cbServName.Enabled:=cbProtocol.ItemIndex <> 0;
end;

procedure TfbmCreateDataBaseForm.Localize;
begin
  Caption:=sCreateParams;
  Label2.Caption:=sServerName1;
  Label3.Caption:=sProtocol;
  Label4.Caption:=sDatabaseName;
  Label5.Caption:=sClientLibraryName;
  Label6.Caption:=sUserName1;
  Label7.Caption:=sUserPassword;
  Label8.Caption:=sDatabasePageSize;
  Label9.Caption:=sCodepage;
  Label10.Caption:=sDatabaseDialect;
  Label11.Caption:=sSQLMetadataLogFile;
  CheckBox1.Caption:=sRegisterAfterCreate;
  CheckBox2.Caption:=sMetadataLogingEnable;
end;

procedure TfbmCreateDataBaseForm.CreateDataBase;
begin
  UIBDataBase1.UserName:=edtUserName.Text;
  UIBDataBase1.PassWord:=edtUserPassword.Text;
  case cbProtocol.ItemIndex of
    0:UIBDataBase1.DatabaseName:=edtDBName.Text;
    1:UIBDataBase1.DatabaseName:=cbServName.Text + ':' + edtDBName.Text;
    2:UIBDataBase1.DatabaseName:='\\'+cbServName.Text + '\' + edtDBName.Text;
  end;

//  UIBDataBase1.
//  if edtLibName.Text<>'' then
//    UIBDataBase1.LibraryName:=edtLibName.Text;
  UIBDataBase1.CharacterSet:=StrToCharacterSet(ComboBox3.Text);
  UIBDataBase1.CreateDatabase(UIBDataBase1.CharacterSet, StrToInt(ComboBox2.Text));
  UIBDataBase1.LibraryName:=GetDefaultFB3Lib;
end;

procedure TfbmCreateDataBaseForm.FormCreate(Sender: TObject);
var
  cs:TCharacterSet;
begin
  Localize;
  ComboBox3.Items.Clear;
  for cs:=Low(TCharacterSet) to High(TCharacterSet) do
    ComboBox3.Items.Add(CharacterSetStr[cs]);
  ComboBox3.ItemIndex:=0;

  fbManDataInpectorForm.DBList.FillServerList(cbServName.Items, TSQLEngineFireBird);
  cbProtocol.Items.Clear;
  cbProtocol.Items.Add(sProtokol1);
  cbProtocol.Items.Add(sProtokol2);
  cbProtocol.Items.Add(sProtokol3);
  cbProtocol.ItemIndex:=0;
  cbServTypeChange(nil);
end;

{ TFBEngineCreateDBClass }

function TFBEngineCreateDBClass.Execute: boolean;
var
  fbmCreateDataBaseForm: TfbmCreateDataBaseForm;
begin
  Result:=false;
  fbmCreateDataBaseForm:=TfbmCreateDataBaseForm.Create(Application);

  fbmCreateDataBaseForm.edtUserName.Text                   := FUserName;
  fbmCreateDataBaseForm.edtUserPassword.Text               := FPassword;
  fbmCreateDataBaseForm.CheckBox1.Checked                  := FRegisterAfterCreate;
  fbmCreateDataBaseForm.cbServName.Text                    := FServerName;
  fbmCreateDataBaseForm.edtDBName.Text                     := FDataBaseName;
  fbmCreateDataBaseForm.CheckBox2.Checked                  := FLogMetadata;
  fbmCreateDataBaseForm.edtLogName.Text                    := FLogFileMetadata;
//  TUIBProtocol(fbmCreateDataBaseForm.cbProtocol.ItemIndex) := FProtocol;
  fbmCreateDataBaseForm.edtLibName.Text                    := FLibraryName;
//  StrToInt(fbmCreateDataBaseForm.ComboBox2.Text)           := FDBPageSize;
//  StrToCharacterSet(fbmCreateDataBaseForm.ComboBox3.Text)  := FCharacterSet;
  fbmCreateDataBaseForm.ComboBox4.ItemIndex                := FSQLDialect;

  if fbmCreateDataBaseForm.ShowModal = mrOk then
  begin
    try
      fbmCreateDataBaseForm.CreateDataBase;
      FUserName:=fbmCreateDataBaseForm.edtUserName.Text;
      FPassword:=fbmCreateDataBaseForm.edtUserPassword.Text;
      FRegisterAfterCreate:=fbmCreateDataBaseForm.CheckBox1.Checked;
      FServerName:=fbmCreateDataBaseForm.cbServName.Text;
      FDataBaseName:=fbmCreateDataBaseForm.edtDBName.Text;
      FLogMetadata:=fbmCreateDataBaseForm.CheckBox2.Checked;
      FLogFileMetadata:=fbmCreateDataBaseForm.edtLogName.Text;
      FProtocol:=TUIBProtocol(fbmCreateDataBaseForm.cbProtocol.ItemIndex);
      FLibraryName:=fbmCreateDataBaseForm.edtLibName.Text;
      FDBPageSize:=StrToInt(fbmCreateDataBaseForm.ComboBox2.Text);
      FCharacterSet:=StrToCharacterSet(fbmCreateDataBaseForm.ComboBox3.Text);
      FSQLDialect:=fbmCreateDataBaseForm.ComboBox4.ItemIndex;

      Result:=true;
    except
      on E:Exception do
        ErrorBoxExcpt(E);
    end
  end;
  fbmCreateDataBaseForm.Free;
end;

function TFBEngineCreateDBClass.CreateSQLEngine: TSQLEngineAbstract;
begin
  Result:=TSQLEngineFireBird.Create;

  Result.UserName:=UserName;
  Result.Password:=Password;
  Result.ServerName:=ServerName;
  Result.DataBaseName:=DataBaseName;
  Result.SQLEngineLogOptions.LogFileMetadata:=LogFileMetadata;
  Result.SQLEngineLogOptions.LogMetadata:=LogMetadata;
  Result.ReportManagerFolder:=ReportManagerFolder;

  TSQLEngineFireBird(Result).TranParamData:=ConfigValues.ByNameAsInteger('defTranParamData', 1);
  TSQLEngineFireBird(Result).TranParamMetaData:=ConfigValues.ByNameAsInteger('defTranParamMetaData', 1);


  //  FServerType:=TFBEngineCreateDBClass(CreateClass).FServerType;
  TSQLEngineFireBird(Result).Protocol:=FProtocol;

  //TSQLEngineFireBird(Result).LibraryName:=FLibraryName;
  TSQLEngineFireBird(Result).CharSet:=CharacterSetStr[FCharacterSet];

 //  FDBPageSize:=StrToInt(fbmCreateDataBaseForm.ComboBox2.Text);
//  FCharSet:=TFBEngineCreateDBClass(CreateClass).FCharacterSet;
//  FSQLDialect:=fbmCreateDataBaseForm.ComboBox4.ItemIndex;
end;

constructor TFBEngineCreateDBClass.Create;
begin
  inherited Create;
//  FProtocol:TUIBProtocol;
//  FClntLibName:string;
//  FDBPageSize:integer;
//  FCharacterSet:TCharacterSet;
//  FSQLDialect:integer;
//  FRegisterAfterCreate: boolean;

  FUserName:=''; //fb_defUserName;
  FPassword:=''; //fb_defUserPassword;
//  FServerName:string;
//  FDataBaseName:string;
//  FLogMetadata:boolean;
//  FLogFileMetadata:string;

//  defCharSet         : string = '';
//  defServerVersion   : Integer = 0;

end;

end.

