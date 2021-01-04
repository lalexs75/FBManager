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

unit fbmCompillerMessagesUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, ActnList, Menus, DB,
  rxdbgrid, rxmemds;

type
  TfbmCompillerMessagesFrame = class;
  TppMsgType = (ppNone, ppLocalVarNotUsed,
    ppLocalVarErrorDefine, ppInParamNotUsed, ppOutParamNotUsed, ppParamNameNotDefined,
    ppParamTypeNotDefined, ppLocalVarNameNotDefined, ppLocalVarTypeNotDefined,
    ppTableNotHavePK);

  TppMsgRec = record
    MsgType:TppMsgType;
    InfoMsg:string;
    Info1:Integer;
    Info2:Integer;
    OwnerPageName:string;
  end;

  TppMsgListEvent = function(Sender:TfbmCompillerMessagesFrame;  AInfo:TppMsgRec):Boolean of object;

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
    rxMsgListInfo1: TLongintField;
    rxMsgListInfo2: TLongintField;
    rxMsgListInfoMsg: TStringField;
    rxMsgListMsgOwner: TStringField;
    rxMsgListMsgType: TLongintField;
    rxMsgListMsgTypeImg: TLongintField;
    rxMsgListText: TStringField;
    SpeedButton1: TSpeedButton;
    StaticText1: TStaticText;
    procedure lvClearExecute(Sender: TObject);
    procedure lvRemoveVarExecute(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure rxMsgListAfterScroll(DataSet: TDataSet);
    procedure rxMsgListMsgTypeGetText(Sender: TField; var aText: string;
      DisplayText: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FIsError: boolean;
    FOnMsgListDblClick: TppMsgListEvent;
    FOnMsgListRemoveNotUsedVar: TppMsgListEvent;
    procedure Localize;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure AddMsg(AOwnerName:string; AMsgType:TppMsgType; AMsg:string; AInfo1, AInfo2:Integer);
    procedure Clear;
    property IsError:boolean read FIsError;

    property OnMsgListDblClick:TppMsgListEvent read FOnMsgListDblClick write FOnMsgListDblClick;
    property OnMsgListRemoveNotUsedVar:TppMsgListEvent read FOnMsgListRemoveNotUsedVar write FOnMsgListRemoveNotUsedVar;
  end;

implementation
uses fbmStrConstUnit, fbmToolsUnit, fbmDBObjectEditorUnit;

{$R *.lfm}

{ TfbmCompillerMessagesFrame }

procedure TfbmCompillerMessagesFrame.SpeedButton1Click(Sender: TObject);
begin
  if (Owner is TfbmDBObjectEditorForm) then
    TfbmDBObjectEditorForm(Owner).HideMsg;
end;

procedure TfbmCompillerMessagesFrame.Localize;
begin
  RxDBGrid1.ColumnByFieldName('MsgType').Title.Caption:=sType;
  RxDBGrid1.ColumnByFieldName('Text').Title.Caption:=sText;

  StaticText1.Caption:=sMessages;
  lvClear.Caption:=sClearMesaages;
  lvRemoveVar.Caption:=sRemoveVariable;
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
    ppTableNotHavePK,
    ppInParamNotUsed, ppOutParamNotUsed,
    ppLocalVarNotUsed:aText:=sWarning;
    ppParamNameNotDefined,
    ppParamTypeNotDefined,
    ppLocalVarNameNotDefined,
    ppLocalVarTypeNotDefined,
    ppLocalVarErrorDefine:aText:=sError;
  else
    //ppNone
    aText:='';
  end;
end;

procedure TfbmCompillerMessagesFrame.RxDBGrid1DblClick(Sender: TObject);
var
  RecInfo: TppMsgRec;
begin
  if (rxMsgList.Active) and (rxMsgList.RecordCount>0) and Assigned(FOnMsgListDblClick) then
  begin
    RecInfo.MsgType:=TppMsgType(rxMsgListMsgType.AsInteger);
    RecInfo.InfoMsg:=rxMsgListInfoMsg.AsString;
    RecInfo.Info1:=rxMsgListInfo1.AsInteger;
    RecInfo.Info2:=rxMsgListInfo2.AsInteger;
    RecInfo.OwnerPageName:=rxMsgListMsgOwner.AsString;
    FOnMsgListDblClick(Self, RecInfo)
  end;
end;

procedure TfbmCompillerMessagesFrame.rxMsgListAfterScroll(DataSet: TDataSet);
begin
  lvRemoveVar.Enabled:=TppMsgType(rxMsgListMsgType.AsInteger) in [ppLocalVarNotUsed] //, ppInParamNotUsed, ppOutParamNotUsed];
end;

procedure TfbmCompillerMessagesFrame.lvClearExecute(Sender: TObject);
begin
  if QuestionBox(sClearMessageListQuestion) then
    rxMsgList.CloseOpen;
end;

procedure TfbmCompillerMessagesFrame.lvRemoveVarExecute(Sender: TObject);
var
  RecInfo: TppMsgRec;
begin
  if (rxMsgList.Active) and (rxMsgList.RecordCount>0) and Assigned(FOnMsgListRemoveNotUsedVar) then
  begin
    RecInfo.MsgType:=TppMsgType(rxMsgListMsgType.AsInteger);
    RecInfo.InfoMsg:=rxMsgListInfoMsg.AsString;
    RecInfo.Info1:=rxMsgListInfo1.AsInteger;
    RecInfo.Info2:=rxMsgListInfo2.AsInteger;
    RecInfo.OwnerPageName:=rxMsgListMsgOwner.AsString;
    if FOnMsgListRemoveNotUsedVar(Self, RecInfo) then
      rxMsgList.Delete;
  end;
end;

procedure TfbmCompillerMessagesFrame.AddMsg(AOwnerName: string;
  AMsgType: TppMsgType; AMsg: string; AInfo1, AInfo2: Integer);
begin
  if not rxMsgList.Active then
    rxMsgList.Open;
  rxMsgList.Append;
  rxMsgListMsgOwner.AsString:=AOwnerName;
  rxMsgListID.AsInteger:=rxMsgList.RecordCount + 1;
  rxMsgListMsgType.AsInteger:=Ord(AMsgType);
  rxMsgListInfoMsg.AsString:=AMsg;

  case AMsgType of
    ppLocalVarNameNotDefined:rxMsgListText.AsString:=Format(sLocalVariableNameNotDefined, [AMsg]);
    ppLocalVarTypeNotDefined:rxMsgListText.AsString:=Format(sLocalVariableTypeNotDefined, [AMsg]);
    ppParamNameNotDefined:rxMsgListText.AsString:=Format(sParamNameNotDefined, [AMsg]);
    ppParamTypeNotDefined:rxMsgListText.AsString:=Format(sParamTypeNotDefined, [AMsg]);
    ppLocalVarNotUsed:rxMsgListText.AsString:=Format(sLocalVariableNotUsed, [AMsg]);
    ppInParamNotUsed:rxMsgListText.AsString:=Format(sInputParamNotUsed, [AMsg]);
    ppOutParamNotUsed:rxMsgListText.AsString:=Format(sOutputParamNotUsed, [AMsg]);
    ppTableNotHavePK:rxMsgListText.AsString:=Format(sTableNotHavePK, [AMsg]);
  else
    rxMsgListText.AsString:=AMsg;
  end;

  rxMsgListInfo1.AsInteger:=AInfo1;
  rxMsgListInfo2.AsInteger:=AInfo2;

  case AMsgType of
    ppTableNotHavePK,
    ppInParamNotUsed, ppOutParamNotUsed,
    ppLocalVarNotUsed:rxMsgListMsgTypeImg.AsInteger:=1;
    ppParamNameNotDefined,
    ppParamTypeNotDefined,
    ppLocalVarNameNotDefined,
    ppLocalVarTypeNotDefined,
    ppLocalVarErrorDefine:rxMsgListMsgTypeImg.AsInteger:=2;
  else
    rxMsgListMsgTypeImg.AsInteger:=0;
    //ppNone
  end;
  rxMsgList.Post;

  FIsError:=FIsError or (rxMsgListMsgTypeImg.AsInteger=2);
end;

procedure TfbmCompillerMessagesFrame.Clear;
begin
  rxMsgList.CloseOpen;
  FIsError:=false;
end;

end.

