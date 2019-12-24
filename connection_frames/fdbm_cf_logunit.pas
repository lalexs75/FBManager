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

unit fdbm_cf_LogUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, SQLEngineAbstractUnit,
  fbmConnectionEditUnit, StdCtrls, EditBtn, Spin, fdbm_ConnectionAbstractUnit;

type

  { TfdbmCFLogFrame }

  TfdbmCFLogFrame = class(TConnectionDlgPage)
    cbLogMeta: TCheckBox;
    cbLogEditor: TCheckBox;
    cbWriteTimeStamp: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    edtEditorLogName1: TFileNameEdit;
    edtMetaLogName: TFileNameEdit;
    edtEditorLogName: TFileNameEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtSQLEdtCnt: TSpinEdit;
    Label12: TLabel;
    procedure cbLogEditorClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private
    FSQLEngineAbstract:TSQLEngineAbstract;
  public
    procedure Localize;override;
    procedure Activate;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfdbmCFLogFrame }

procedure TfdbmCFLogFrame.cbLogEditorClick(Sender: TObject);
begin
  Label10.Enabled:=cbLogMeta.Checked;
  edtMetaLogName.Enabled:=cbLogMeta.Checked;

  Label11.Enabled:=cbLogEditor.Checked;
  edtEditorLogName.Enabled:=cbLogEditor.Checked;

  Label12.Enabled:=CheckBox2.Checked;
  edtEditorLogName1.Enabled:=CheckBox2.Checked;
end;

procedure TfdbmCFLogFrame.CheckBox1Change(Sender: TObject);
begin
  ComboBox1.Enabled:=CheckBox1.Checked;
end;

procedure TfdbmCFLogFrame.Localize;
begin
  inherited Localize;
  Label1.Caption:=sSQLEditorHistoryCount;
  Label10.Caption:=sSQLMetadataLogFile;
  Label11.Caption:=sSQLEditorLogFile;
  cbWriteTimeStamp.Caption:=sWriteTimestampIntoLog;
  cbLogMeta.Caption:=sEnableLogginMetadataChanges;
  cbLogEditor.Caption:=sEnableLogginSQLEditor;
  CheckBox1.Caption:=sUseCustomCodepageForLoggin;
  CheckBox2.Caption:=sEnableLogginScriptExecutive;
  Label12.Caption:=sSQLscriptLogFile;
end;

procedure TfdbmCFLogFrame.Activate;
begin
  cbLogEditorClick(nil);
end;

procedure TfdbmCFLogFrame.LoadParams(ASQLEngine:TSQLEngineAbstract);
begin
  cbLogMeta.Checked:=ASQLEngine.SQLEngineLogOptions.LogMetadata;
  cbLogEditor.Checked:=ASQLEngine.SQLEngineLogOptions.LogSQLEditor;
  CheckBox2.Checked:=ASQLEngine.SQLEngineLogOptions.LogSQLScript;

  cbWriteTimeStamp.Checked:=ASQLEngine.SQLEngineLogOptions.LogTimestamp;
  edtMetaLogName.Text:=ASQLEngine.SQLEngineLogOptions.LogFileMetadata;
  edtEditorLogName.Text:=ASQLEngine.SQLEngineLogOptions.LogFileSQLEditor;
  edtEditorLogName1.Text:=ASQLEngine.SQLEngineLogOptions.LogFileSQLScript;

  edtSQLEdtCnt.Value:=ASQLEngine.SQLEngineLogOptions.HistoryCountSQLEditor;
  CheckBox1.Checked:=ASQLEngine.SQLEngineLogOptions.LogFileCodePage <> '';
  ComboBox1.Text:=ASQLEngine.SQLEngineLogOptions.LogFileCodePage;



  CheckBox1Change(nil);
end;

procedure TfdbmCFLogFrame.SaveParams;
begin
  FSQLEngineAbstract.SQLEngineLogOptions.LogMetadata      := cbLogMeta.Checked;
  FSQLEngineAbstract.SQLEngineLogOptions.LogSQLEditor := cbLogEditor.Checked;
  FSQLEngineAbstract.SQLEngineLogOptions.LogTimestamp     := cbWriteTimeStamp.Checked;
  FSQLEngineAbstract.SQLEngineLogOptions.LogFileMetadata  := edtMetaLogName.Text;
  FSQLEngineAbstract.SQLEngineLogOptions.LogFileSQLEditor := edtEditorLogName.Text;
  FSQLEngineAbstract.SQLEngineLogOptions.HistoryCountSQLEditor:=edtSQLEdtCnt.Value;

  FSQLEngineAbstract.SQLEngineLogOptions.LogSQLScript:=CheckBox2.Checked;
  FSQLEngineAbstract.SQLEngineLogOptions.LogFileSQLScript:=edtEditorLogName1.Text;

  if CheckBox1.Checked then
    FSQLEngineAbstract.SQLEngineLogOptions.LogFileCodePage:=ComboBox1.Text
  else
    FSQLEngineAbstract.SQLEngineLogOptions.LogFileCodePage:='';
end;

function TfdbmCFLogFrame.PageName: string;
begin
  Result:=sLogFiles;
end;

function TfdbmCFLogFrame.Validate: boolean;
begin
  Result:=true;
  if cbLogMeta.Checked then
    Result:=edtMetaLogName.Text<>'';
  if Result and cbLogEditor.Checked then
    Result:=edtEditorLogName.Text<>'';
end;

constructor TfdbmCFLogFrame.Create(ASQLEngineAbstract: TSQLEngineAbstract;
  AOwner: TForm);
begin
  inherited Create(AOwner);
  FSQLEngineAbstract:=ASQLEngineAbstract;
end;

end.

