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
unit fdmAboutUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ButtonPanel, ComCtrls, RxVersInfo;

type

  { TfdmAboutForm }

  TfdmAboutForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    Label1: TLabel;
    Label2: TLabel;
    lblExecutableFile: TLabel;
    lblWidgetName: TLabel;
    lblTargetOS: TLabel;
    lblFPCVersion: TLabel;
    lblLCLVersion: TLabel;
    lblVersion: TLabel;
    lblTargCPU: TLabel;
    lblBuildDate: TLabel;
    Label16: TLabel;
    lblSVNRevision: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    PageControl1: TPageControl;
    RxVersionInfo1: TRxVersionInfo;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure ibmanagerAboutFormCreate(Sender: TObject);
  private
    procedure LoadGPLFile;
    procedure Localize;
  public
    { public declarations }
  end; 

var
  fdmAboutForm: TfdmAboutForm;

const
  appBuildDate = {$I %DATE%};
  fpcVersion = {$I %FPCVERSION%};
  TargetCPU = {$I %FPCTARGETCPU%};
  TargetOS = {$I %FPCTARGETOS%};
  gplFile = 'COPYING.GPL';

  {$I revision.inc}

function LCLVersionStr:string;
implementation
uses LCLVersion, fbmStrConstUnit, InterfaceBase, fbm_VisualEditorsAbstractUnit, LCLPlatformDef, fbmToolsUnit;

{$R *.lfm}

function LCLVersionStr: string; inline;
begin
  Result:=sWidget +  LCLPlatformDisplayNames[WidgetSet.LCLPlatform];
end;

{ TfdmAboutForm }

procedure TfdmAboutForm.ibmanagerAboutFormCreate(Sender: TObject);
begin
  lblTargCPU.Caption:=sLCLVersion + lcl_version;
  FillSQLEngineNames(ListBox1.Items);

  lblVersion.Caption:=sAppVersion + RxVersionInfo1.FileLongVersion;
  lblBuildDate.Caption:=sBuildDate + appBuildDate;
  lblLCLVersion.Caption:=sLCLVersion + LCLVersion;
  lblFPCVersion.Caption:=sFpcVersion + fpcVersion;
  lblTargCPU.Caption:=sTargetCPU + TargetCPU;
  lblTargetOS.Caption:=sTargetOS + TargetOS;
  lblWidgetName.Caption:=LCLVersionStr;
  lblSVNRevision.Caption:=sSrcRevision + RevisionStr;
  lblExecutableFile.Caption:=sExecutableFile + Application.ExeName;

  LoadGPLFile;

  Localize;
end;

procedure TfdmAboutForm.LoadGPLFile;
var
  S:string;
begin
  S:=DocsFolder + gplFile;
  if FileExists(S) then
    Memo1.Lines.LoadFromFile(S);
end;

procedure TfdmAboutForm.Localize;
begin
  Caption:=sAbout;
  Label1.Caption:=sMainCaption;
  Label16.Caption:=sMainSlogan;
  TabSheet1.Caption:=sGeneral;
  TabSheet2.Caption:=sLicense;
end;

end.

