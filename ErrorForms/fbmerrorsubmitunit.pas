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

unit fbmErrorSubmitUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ButtonPanel, ComCtrls, WSCurlGate, BugTracker, RxVersInfo;

type

  { TfbmErrorSubmitForm }

  TfbmErrorSubmitForm = class(TForm)
    BugTracker1: TBugTracker;
    ButtonPanel1: TButtonPanel;
    cbSection: TComboBox;
    edtUserName: TEdit;
    edtPasswd: TEdit;
    edtSabject: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Gate1: TWSCurlGate;
    RxVersionInfo1: TRxVersionInfo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    FErrorMsg:string;
    function DoSend:boolean;
    function FormatMessageBody:string;
    function UserFrom:string;
  public
    procedure InitBugTracker(const AErrorMsg:string);
  end; 

var
  fbmErrorSubmitForm: TfbmErrorSubmitForm;

implementation
uses fbmToolsUnit, fbmStrConstUnit, SQLEngineCommonTypesUnit, fdmAboutUnit;

{$R *.lfm}

{ TfbmErrorSubmitForm }

procedure TfbmErrorSubmitForm.RadioButton1Change(Sender: TObject);
begin
  Label1.Enabled:=RadioButton2.Checked;
  Label5.Enabled:=RadioButton2.Checked;
  edtUserName.Enabled:=RadioButton2.Checked;
  edtPasswd.Enabled:=RadioButton2.Checked;
end;

procedure TfbmErrorSubmitForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if ModalResult = mrOk then
    CanClose:=DoSend;
end;

procedure TfbmErrorSubmitForm.FormCreate(Sender: TObject);
begin
  Gate1.CA := AppendPathDelim(ExtractFileDir(ParamStr(0))) + 'ca-bundle';
end;

procedure TfbmErrorSubmitForm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage= TabSheet2 then
  begin
    StaticText1.Caption:=UserFrom;
    StaticText2.Caption:=edtSabject.Text;
    StaticText3.Caption:=FormatMessageBody;
    FormatMessageBody;
  end;
end;

function TfbmErrorSubmitForm.DoSend: boolean;
var
  SectionId:integer;
begin
  Result:=false;
  if cbSection.Items.Count<=0 then exit;

  if RadioButton2.Checked then
    Gate1.authorize(edtUserName.Text, edtPasswd.Text);

  try
    SectionId := Integer(cbSection.Items.Objects[cbSection.ItemIndex]);
    BugTracker1.Report(SectionId, edtSabject.Text, FormatMessageBody);
    Result:=true;
  finally
  end;
end;

function TfbmErrorSubmitForm.FormatMessageBody:string;
begin
  Result:=FErrorMsg + LineEnding + LineEnding + Memo1.Text +
    LineEnding + LineEnding +
    sBuildDate + appBuildDate + LineEnding +
    sAppVersion + RxVersionInfo1.FileLongVersion + LineEnding +
    sFpcVersion + fpcVersion + LineEnding +
    sTargetCPU + TargetCPU + LineEnding +
    sTargetOS + TargetOS + LineEnding +
    LCLVersionStr;
end;

function TfbmErrorSubmitForm.UserFrom: string;
begin
  if RadioButton1.Checked then
    Result:=sBugTrackerServName
  else
    Result:=edtUserName.Text;
end;

procedure TfbmErrorSubmitForm.InitBugTracker(const AErrorMsg:string);
var
  Sections: TSectionList;
  i, len:integer;
begin
  Memo1.Text:='';
  RadioButton1Change(nil);
  FErrorMsg:=AErrorMsg;
  Gate1.authorize('test', 'test');
  cbSection.Clear;
  try
    Sections := BugTracker1.GetSectionList(netProgectName);
    Len := Length(Sections);
    for i := 0 to Len-1 do
      cbSection.AddItem(Sections[i].name, TObject(Sections[i].id));
    if cbSection.Items.Count>0 then
      cbSection.ItemIndex:=0;
  except
    //
  end
end;

end.

