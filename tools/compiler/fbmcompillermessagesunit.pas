{ Free DB Manager

  Copyright (C) 2005-2020 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmCompillerMessagesUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, DB, rxdbgrid, rxmemds;

type

  { TfbmCompillerMessagesFrame }

  TfbmCompillerMessagesFrame = class(TFrame)
    dsMsgList: TDataSource;
    RxDBGrid1: TRxDBGrid;
    rxMsgList: TRxMemoryData;
    rxMsgListID: TLongintField;
    rxMsgListText: TStringField;
    SpeedButton1: TSpeedButton;
    StaticText1: TStaticText;
    procedure SpeedButton1Click(Sender: TObject);
  private

  public
    procedure AddMsg(AMsg:string);
    procedure Clear;
  end;

implementation

{$R *.lfm}

{ TfbmCompillerMessagesFrame }

procedure TfbmCompillerMessagesFrame.SpeedButton1Click(Sender: TObject);
begin
  Hide;
end;

procedure TfbmCompillerMessagesFrame.AddMsg(AMsg: string);
begin
  if not rxMsgList.Active then
    rxMsgList.Open;
  rxMsgList.Append;
  rxMsgListID.AsInteger:=rxMsgList.RecordCount + 1;
  rxMsgListText.AsString:=AMsg;
  rxMsgList.Post;
end;

procedure TfbmCompillerMessagesFrame.Clear;
begin
  rxMsgList.CloseOpen;
end;

end.

