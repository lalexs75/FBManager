{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit cfAutoIncFieldUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, DividerBevel, SynHighlighterSQL, fdbm_SynEditorUnit,
  cfAbstractConfigFrameUnit, SQLEngineAbstractUnit;

const
  DUMMY_AutoInc_GenName = '%TABLE_SCHEMA_NAME%.GENID_%TABLE_NAME%';
  DUMMY_AutoInc_GenNameWOS = 'GENID_%TABLE_NAME%';
  DUMMY_AutoInc_TrigName = '%TABLE_NAME%_BI0';
  DUMMY_AutoInc_TrigDescription = 'Auto incremen on insert data';
type

  { TcfAutoIncFieldFrame }

  TcfAutoIncFieldFrame = class(TFBMConfigPageAbstract)
    DividerBevel1: TDividerBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    SynSQLSyn1: TSynSQLSyn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
  private
    EditorFrame:Tfdbm_SynEditorFrame;
    EditorFrameDesc:Tfdbm_SynEditorFrame;
    FDummyTriggerText: string;
    FPageNameStr: string;
    FSQLEngineClass: TSQLEngineAbstractClass;
    FUseSchemas: boolean;
    procedure SetSQLEngineClass(AValue: TSQLEngineAbstractClass);
  public
    constructor Create(TheOwner: TComponent); override;
    function PageName:string;override;
    procedure LoadData;override;
    procedure SaveData;override;
    procedure Localize;override;
    property SQLEngineClass:TSQLEngineAbstractClass read FSQLEngineClass write SetSQLEngineClass;
    property DummyTriggerText:string read FDummyTriggerText write FDummyTriggerText;
    property PageNameStr:string read FPageNameStr write FPageNameStr;
    property UseSchemas:boolean read FUseSchemas write FUseSchemas;
  end;

implementation
uses fbmToolsUnit, fbmStrConstUnit;

{$R *.lfm}

{ TcfAutoIncFieldFrame }

procedure TcfAutoIncFieldFrame.SetSQLEngineClass(AValue: TSQLEngineAbstractClass
  );
begin
  if FSQLEngineClass=AValue then Exit;
  FSQLEngineClass:=AValue;

  Name:=FSQLEngineClass.ClassName + '_AutoIncFieldFrame';
  EditorFrame.Name:=FSQLEngineClass.ClassName + '_SynEditorFrame';
end;

constructor TcfAutoIncFieldFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  EditorFrame:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrame.Name:='EditorFrame';
  EditorFrame.Align:=alClient;
  EditorFrame.Parent:=TabSheet1;
  EditorFrame.ChangeVisualParams;
  EditorFrame.TextEditor.Highlighter:=SynSQLSyn1;

  EditorFrameDesc:=Tfdbm_SynEditorFrame.Create(Self);
  EditorFrameDesc.Name:='EditorFrameDesc';
  EditorFrameDesc.Align:=alClient;
  EditorFrameDesc.Parent:=TabSheet2;
  EditorFrameDesc.ChangeVisualParams;
  EditorFrameDesc.TextEditor.Highlighter:=SynSQLSyn1;
end;

function TcfAutoIncFieldFrame.PageName: string;
begin
  Result:=PageNameStr;
end;

procedure TcfAutoIncFieldFrame.LoadData;
begin
  EditorFrame.EditorText:=ConfigValues.ByNameAsString('AutoIncriment/Trigger/Text/' + FSQLEngineClass.GetEngineName, DummyTriggerText);
  EditorFrameDesc.EditorText:=ConfigValues.ByNameAsString('AutoIncriment/Trigger/Description/' + FSQLEngineClass.GetEngineName, DUMMY_AutoInc_TrigDescription);

  if FUseSchemas then
    Edit1.Text:=ConfigValues.ByNameAsString('AutoIncriment/Generator/Name/' + FSQLEngineClass.GetEngineName, DUMMY_AutoInc_GenName)
  else
    Edit1.Text:=ConfigValues.ByNameAsString('AutoIncriment/Generator/Name/' + FSQLEngineClass.GetEngineName, DUMMY_AutoInc_GenNameWOS);

  Edit2.Text:=ConfigValues.ByNameAsString('AutoIncriment/Trigger/Name/' + FSQLEngineClass.GetEngineName, DUMMY_AutoInc_TrigName);
end;

procedure TcfAutoIncFieldFrame.SaveData;
begin
  ConfigValues.SetByNameAsString('AutoIncriment/Trigger/Text/' + FSQLEngineClass.GetEngineName, EditorFrame.EditorText);
  ConfigValues.SetByNameAsString('AutoIncriment/Trigger/Description/' + FSQLEngineClass.GetEngineName, EditorFrameDesc.EditorText);
  ConfigValues.SetByNameAsString('AutoIncriment/Generator/Name/' + FSQLEngineClass.GetEngineName, Edit1.Text);
  ConfigValues.SetByNameAsString('AutoIncriment/Trigger/Name/' + FSQLEngineClass.GetEngineName, Edit2.Text);
end;

procedure TcfAutoIncFieldFrame.Localize;
begin
  inherited Localize;
  Label3.Caption:=sAvallableTags;
  Label4.Caption:=sToInsertTableName;
  Label5.Caption:=sToInsertFieldName;
  Label7.Caption:=sToInsertTriggerName;
  Label8.Caption:=sToInsertGeneratorName;
  Label9.Caption:=sToInsertTableShemaName;
  DividerBevel1.Caption:=sTemplates;
  Label1.Caption:=sGeneratorNameTemplate;
  Label2.Caption:=sTriggerNameTemplate;
  TabSheet1.Caption:=sTriggerText;
  TabSheet2.Caption:=sDefaultDescription;
end;

end.

