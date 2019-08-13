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

unit pgForeignTablePropertyUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, DB, SQLEngineAbstractUnit,
  rxdbgrid, rxmemds, fdmAbstractEditorUnit, fbmSqlParserUnit;

type

  { TpgForeignTablePropertyFrame }

  TpgForeignTablePropertyFrame = class(TEditorPage)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    dsData: TDataSource;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    rxData: TRxMemoryData;
    rxDataKEY: TStringField;
    rxDataValue: TStringField;
    RxDBGrid1: TRxDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure UpdateInhLists;
    procedure RefreshObject;
  public
    function PageName:string;override;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); override;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;override;
    function DoMetod(PageAction:TEditorPageAction):boolean;override;
    procedure Localize;override;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; override;
  end;

implementation
uses rxboxprocs, fbmStrConstUnit;

{$R *.lfm}

{ TpgForeignTablePropertyFrame }

procedure TpgForeignTablePropertyFrame.SpeedButton1Click(Sender: TObject);
begin
  BoxMoveSelectedItems(ListBox1, ListBox2);
  UpdateInhLists;
end;

procedure TpgForeignTablePropertyFrame.SpeedButton2Click(Sender: TObject);
begin
  BoxMoveSelectedItems(ListBox2, ListBox1);
  UpdateInhLists;
end;

procedure TpgForeignTablePropertyFrame.UpdateInhLists;
begin
  SpeedButton1.Enabled:=ListBox1.Items.Count>0;
  SpeedButton2.Enabled:=ListBox2.Items.Count>0;
end;

procedure TpgForeignTablePropertyFrame.RefreshObject;
begin
  //
end;

function TpgForeignTablePropertyFrame.PageName: string;
begin
  Result:=sProperty;
end;

constructor TpgForeignTablePropertyFrame.CreatePage(TheOwner: TComponent;
  ADBObject: TDBObject);
begin
  inherited CreatePage(TheOwner, ADBObject);
  RefreshObject;
end;

function TpgForeignTablePropertyFrame.ActionEnabled(
  PageAction: TEditorPageAction): boolean;
begin
  Result:=inherited ActionEnabled(PageAction);
end;

function TpgForeignTablePropertyFrame.DoMetod(PageAction: TEditorPageAction
  ): boolean;
begin
  Result:=true;
  case PageAction of
    epaRefresh:RefreshObject;
  else
    Result:=false;
  end;
end;

procedure TpgForeignTablePropertyFrame.Localize;
begin
  Label4.Caption:=sTableOwner;
  GroupBox1.Caption:=sInheritsTableFrom;
  CheckBox1.Caption:=sWithOIDs;
end;

function TpgForeignTablePropertyFrame.SetupSQLObject(ASQLObject: TSQLCommandDDL
  ): boolean;
begin
  Result:=inherited SetupSQLObject(ASQLObject);
end;

end.

