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

unit assistMainUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, StdCtrls, DB, RxDBGrid, rxmemds, ibmanagertypesunit,
  rxdbverticalgrid;

type

  { TassistMainFrame }

  TassistMainFrame = class(TFrame)
    dsFields: TDataSource;
    dsProps: TDataSource;
    Memo1: TMemo;
    PageControl1: TPageControl;
    RxDBGrid1: TRxDBGrid;
    RxDBVerticalGrid1: TRxDBVerticalGrid;
    rxFields: TRxMemoryData;
    rxProps: TRxMemoryData;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
  private
    procedure ClearAssistData;
  public
    procedure UpdateAssistent(ARec:TDBInspectorRecord);
  end;

implementation
uses assistTypesUnit;

{$R *.lfm}

{ TassistMainFrame }

procedure TassistMainFrame.ClearAssistData;
begin
  rxFields.CloseOpen;
  rxProps.CloseOpen;
  Memo1.Clear;
end;

procedure TassistMainFrame.UpdateAssistent(ARec: TDBInspectorRecord);
begin
  ClearAssistData;
  if not Assigned(ARec) then Exit;
  ARec.

end;

end.

