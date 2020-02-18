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
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ActnList, Menus, DB,
  rxdbgrid, rxmemds;

type
  TfbmCompillerMessagesFrame = class;
  TppMsgType = (ppNone, ppLocalVarNotUsed,
    ppLocalVarErrorDefine, ppInParamNotUsed, ppOutParamNotUsed);

  TppMsgRec = record

  end;

  TppMsgListDbl = procedure(Sender:TfbmCompillerMessagesFrame) of object;

  { TfbmCompillerMessagesFrame }

  TfbmCompillerMessagesFrame = class(TFrame)
    lvRemoveVar: TAction;
    lvClear: TAction;
    ActionList1: TActionList;
    dsMsgList: TDataSource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    RxDBGrid1: TRxDBGrid;
    rxMsgList: TRxMemoryData;
    rxMsgListID: TLongintField;
    rxMsgListMsgType: TLongintField;
    rxMsgListMsgTypeImg: TLongintField;
    rxMsgListText: TStringField;
    SpeedButton1: TSpeedButton;
    StaticText1: TStaticText;
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure rxMsgListMsgTypeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
  private
    procedure Localize;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure AddMsg(AMsgType:TppMsgType; AMsg:string);
    procedure Clear;
  end;

implementation
uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmCompillerMessagesFrame }

procedure TfbmCompillerMessagesFrame.SpeedButton1Click(Sender: TObject);
begin
  Hide;
end;

procedure TfbmCompillerMessagesFrame.Localize;
begin
  RxDBGrid1.ColumnByFieldName('MsgType').Title.Caption:=sType;
  RxDBGrid1.ColumnByFieldName('Text').Title.Caption:=sText;

  StaticText1.Caption:=sMessages;
end;

constructor TfbmCompillerMessagesFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Localize;
end;

procedure TfbmCompillerMessagesFrame.rxMsgListMsgTypeGetText(Sender: TField;
  var aText: string; DisplayText: Boolean);
begin
  case TppMsgType(rxMsgListMsgType.AsInteger) of
    ppInParamNotUsed, ppOutParamNotUsed,
    ppLocalVarNotUsed:aText:=sWarning;
    ppLocalVarErrorDefine:aText:=sError;
  else
    //ppNone
    aText:='';
  end;
end;

procedure TfbmCompillerMessagesFrame.RxDBGrid1DblClick(Sender: TObject);
begin
  //
end;

procedure TfbmCompillerMessagesFrame.AddMsg(AMsgType: TppMsgType; AMsg: string);
begin
  if not rxMsgList.Active then
    rxMsgList.Open;
  rxMsgList.Append;
  rxMsgListID.AsInteger:=rxMsgList.RecordCount + 1;
  rxMsgListMsgType.AsInteger:=Ord(AMsgType);
  rxMsgListText.AsString:=AMsg;

  case AMsgType of
    ppInParamNotUsed, ppOutParamNotUsed,
    ppLocalVarNotUsed:rxMsgListMsgTypeImg.AsInteger:=1;
    ppLocalVarErrorDefine:rxMsgListMsgTypeImg.AsInteger:=2;
  else
    rxMsgListMsgTypeImg.AsInteger:=0;
    //ppNone
  end;
  rxMsgList.Post;
end;

procedure TfbmCompillerMessagesFrame.Clear;
begin
  rxMsgList.CloseOpen;
end;

end.

