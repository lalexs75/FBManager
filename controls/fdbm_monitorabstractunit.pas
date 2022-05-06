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

unit fdbm_monitorabstractunit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, SQLEngineAbstractUnit;

type

  { TfdbmMonitorAbstractForm }

  TfdbmMonitorAbstractForm = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    MainTimer: TTimer;
    procedure ComboBox1Change(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
  private
    FTimeID: integer;
    FSQLEngine: TSQLEngineAbstract;
  protected
    procedure ConnectToDB(ASQLEngine: TSQLEngineAbstract); virtual;
    procedure Localize; virtual;
    procedure StatTimeTick; virtual;
    procedure DisableTimer;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure DoFillDatabaseList(ASQLEngineClass: TSQLEngineAbstractClass);
    property SQLEngine: TSQLEngineAbstract read FSQLEngine;
    property TimeID:integer read FTimeID;
  end;

var
  fdbmMonitorAbstractForm: TfdbmMonitorAbstractForm;

implementation
uses ibmanagertypesunit, IBManMainUnit, fbmStrConstUnit, IBManDataInspectorUnit;

{$R *.lfm}

{ TfdbmMonitorAbstractForm }

procedure TfdbmMonitorAbstractForm.ComboBox1Change(Sender: TObject);
var
  D: TSQLEngineAbstract;
begin
  MainTimer.Enabled:=false;
  if (ComboBox1.Items.Count > 0) and (ComboBox1.ItemIndex>-1) then
  begin
    D:=TSQLEngineAbstract(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
    if Assigned(D) then
    begin
      ConnectToDB(D);
      MainTimer.Enabled:=true;
    end;
  end;
end;

procedure TfdbmMonitorAbstractForm.MainTimerTimer(Sender: TObject);
begin
  StatTimeTick;
end;

procedure TfdbmMonitorAbstractForm.ConnectToDB(ASQLEngine: TSQLEngineAbstract);
begin
  FSQLEngine:=ASQLEngine;
  FTimeID:=0;
end;

procedure TfdbmMonitorAbstractForm.Localize;
begin
  Caption:=sDatabaseProperty;
  Label1.Caption:=sDatabase;
end;

procedure TfdbmMonitorAbstractForm.StatTimeTick;
begin
  Inc(FTimeID);
end;

procedure TfdbmMonitorAbstractForm.DisableTimer;
begin
  MainTimer.Enabled:=false;
end;

constructor TfdbmMonitorAbstractForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Localize;
end;

procedure TfdbmMonitorAbstractForm.DoFillDatabaseList(
  ASQLEngineClass: TSQLEngineAbstractClass);
var
  FCurDBID: Integer;
begin
  FCurDBID:=fbManDataInpectorForm.DBList.FillDataBaseList(ComboBox1.Items, ASQLEngineClass);
  if ComboBox1.Items.Count > 0 then
  begin
    ComboBox1.ItemIndex:=FCurDBID;
    ComboBox1Change(nil);
  end;

  MainTimer.Enabled:=ComboBox1.Items.Count > 0;
end;

end.

