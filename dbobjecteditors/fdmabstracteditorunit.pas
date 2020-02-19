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

unit fdmAbstractEditorUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Forms, SQLEngineAbstractUnit, sqlObjects,
  fbmSqlParserUnit, IniFiles, fbmCompillerMessagesUnit;

type
  TEditorPageAction = (epaAdd, epaEdit, epaDelete, epaRefresh, epaPrint,
                       epaCompile, epaCommit, epaRolback, epaExport, epaRun,
                       epaComment, epaUnComment);

  { TEditorPage }

  TEditorPage = class;
  TEditorPageClass = class of TEditorPage;
  TEditorPage = class(TFrame)
  private
    FDetailPage:TEditorPage;
    FDBObject: TDBObject;
    FLockCount: Integer;
    FModified: boolean;
    procedure SetDBObject(AValue: TDBObject);
    procedure SetModified(AValue: boolean);
  protected
    FReadOnly: boolean;
    FCompillerMessages:TfbmCompillerMessagesFrame;
    FCompillerMessagesSplitter: TSplitter;
    procedure LockCntls;
    procedure UnLockCntls;
    procedure SetReadOnly(AValue: boolean);virtual;
    procedure ShowDetailObject(ADetailDBObject:TDBObject; AParent:TWinControl);
    function FindPageByClass(APageClass:TEditorPageClass):TEditorPage;
    property LockCount:Integer read FLockCount;

    procedure ppMsgListDblClick(Sender:TfbmCompillerMessagesFrame;  AInfo:TppMsgRec); virtual;
    procedure ppMsgListRemoveVar(Sender:TfbmCompillerMessagesFrame;  AInfo:TppMsgRec); virtual;

    procedure ShowMsg(AMsgType:TppMsgType; AMsg:string; AInfo1, AInfo2: Integer);
  public
    FModifiedEvent:TNotifyEvent;
    constructor CreatePage(TheOwner: TComponent; ADBObject:TDBObject); virtual;
    function PageName:string;virtual;abstract;
    function ImageName:string;virtual;
    procedure Activate;virtual;
    procedure DeActivate;virtual;
    function DoMetod(PageAction:TEditorPageAction):boolean;virtual;
    function ActionEnabled(PageAction:TEditorPageAction):boolean;virtual;
    procedure UpdateEnvOptions;virtual;
    procedure SaveState(const SectionName:string; const Ini:TIniFile);virtual;
    procedure RestoreState(const SectionName:string; const Ini:TIniFile);virtual;
    procedure Localize;virtual;
    function SetupSQLObject(ASQLObject:TSQLCommandDDL):boolean; virtual;
    procedure NotyfiDeleted(ADBObject:TDBObject); virtual;
    class function PageExists(ADBObject:TDBObject):Boolean; virtual;
  public
    property ReadOnly:boolean read FReadOnly write SetReadOnly;
    property DBObject:TDBObject read FDBObject write SetDBObject;
    property Modified:boolean read FModified write SetModified;
  end;

function ProcessEditorPageAction(Pages:TStrings; Action:TEditorPageAction; out ErrorPage:integer):boolean;
implementation
uses ibmanagertypesunit, IBManDataInspectorUnit;

{$R *.lfm}

function ProcessEditorPageAction(Pages: TStrings; Action: TEditorPageAction;
  out ErrorPage: integer): boolean;
var
  i:integer;
  EditorPage:TEditorPage;
begin
  Result:=true;
  ErrorPage:=-1;
  if not Assigned(Pages) then exit;
  for i:=0 to Pages.Count - 1 do
  begin
    if Assigned(Pages.Objects[i]) then
    begin
      EditorPage:=Pages.Objects[i] as TEditorPage;
      if not EditorPage.DoMetod(Action) then
      begin
        Result:=false;
        ErrorPage:=i;
        exit;
      end
    end;
  end;
end;


{ TEditorPage }

constructor TEditorPage.CreatePage(TheOwner: TComponent; ADBObject: TDBObject);
begin
  inherited Create(TheOwner);
  FModifiedEvent:=nil;
  FDetailPage:=nil;
  FDBObject:=ADBObject;
  Localize;
end;

procedure TEditorPage.SetDBObject(AValue: TDBObject);
begin
  if FDBObject = AValue then exit;
  FDBObject:=AValue;
end;

procedure TEditorPage.SetModified(AValue: boolean);
begin
  if FModified=AValue then Exit;
  FModified:=AValue;
  if Assigned(FModifiedEvent) then
    FModifiedEvent(Self);
end;

procedure TEditorPage.LockCntls;
begin
  Inc(FLockCount);
end;

procedure TEditorPage.UnLockCntls;
begin
  if FLockCount > 0 then
    Dec(FLockCount);
end;

procedure TEditorPage.SetReadOnly(AValue: boolean);
begin
  if FReadOnly=AValue then Exit;
  FReadOnly:=AValue;
end;

procedure TEditorPage.ShowDetailObject(ADetailDBObject: TDBObject;
  AParent: TWinControl);
var
  D: TDataBaseRecord;
begin
  if Assigned(FDetailPage) then
  begin
    if FDetailPage.DBObject = ADetailDBObject then
      exit;
    FreeAndNil(FDetailPage);
  end;

  if Assigned(ADetailDBObject) then
  begin
    ADetailDBObject.RefreshObject;
    D:=fbManDataInpectorForm.DBBySQLEngine(ADetailDBObject.OwnerDB);
    if Assigned(D) then
    begin
      FDetailPage:=TEditorPage(D.DBVisualTools.EditPage(ADetailDBObject, Owner, 0));
      FDetailPage.Parent:=AParent;
      FDetailPage.ReadOnly:=true;
      FDetailPage.Align:=alClient;
    end;
  end;
end;

function TEditorPage.FindPageByClass(APageClass: TEditorPageClass): TEditorPage;
var
  I: Integer;
  C: TComponent;
begin
  Result:=nil;
  for I:=0 to Owner.ComponentCount-1 do
  begin
    C:=Owner.Components[I];
    if C is APageClass then
      Exit(C as TEditorPage);
  end;
end;

procedure TEditorPage.ppMsgListDblClick(Sender: TfbmCompillerMessagesFrame;
  AInfo: TppMsgRec);
begin

end;

procedure TEditorPage.ppMsgListRemoveVar(Sender: TfbmCompillerMessagesFrame;
  AInfo: TppMsgRec);
begin

end;

procedure TEditorPage.ShowMsg(AMsgType: TppMsgType; AMsg: string; AInfo1,
  AInfo2: Integer);
begin
  if not Assigned(FCompillerMessages) then
  begin
    FCompillerMessages:=TfbmCompillerMessagesFrame.Create(Self);
    FCompillerMessages.Parent:=Self;
    FCompillerMessages.Align:=alBottom;
    FCompillerMessages.AnchorSideBottom.Control:=Self;
    FCompillerMessages.AnchorSideLeft.Control:=Self;
    FCompillerMessages.AnchorSideRight.Control:=Self;
    FCompillerMessages.Anchors:=[akLeft, akRight, akBottom];
    FCompillerMessages.OnMsgListDblClick:=@ppMsgListDblClick;
    FCompillerMessages.OnMsgListRemoveNotUsedVar:=@ppMsgListRemoveVar;
    FCompillerMessagesSplitter:=TSplitter.Create(Self);
    FCompillerMessagesSplitter.Parent:=Self;
    FCompillerMessagesSplitter.Align:=alBottom;
    FCompillerMessagesSplitter.Visible:=true;
    FCompillerMessagesSplitter.Top:=FCompillerMessages.Top - FCompillerMessagesSplitter.Height;
  end
  else
  if not FCompillerMessages.Visible then
  begin
    FCompillerMessages.Visible:=true;
    FCompillerMessagesSplitter.Visible:=true;
    FCompillerMessagesSplitter.Top:=FCompillerMessages.Top - FCompillerMessagesSplitter.Height;
    FCompillerMessages.Clear;
  end;

  FCompillerMessages.AddMsg(AMsgType, AMsg, AInfo1, AInfo2);
end;

function TEditorPage.ImageName: string;
begin
  Result:='';
end;

procedure TEditorPage.Activate;
begin
  //
end;

procedure TEditorPage.DeActivate;
begin
  //
end;

function TEditorPage.DoMetod(PageAction: TEditorPageAction): boolean;
begin
  Result:=true;
end;

function TEditorPage.ActionEnabled(PageAction: TEditorPageAction): boolean;
begin
  Result:=false;
end;

procedure TEditorPage.UpdateEnvOptions;
begin
  //
end;

procedure TEditorPage.SaveState(const SectionName: string; const Ini: TIniFile
  );
begin
  //
end;

procedure TEditorPage.RestoreState(const SectionName: string;
  const Ini: TIniFile);
begin
  //
end;

procedure TEditorPage.Localize;
begin
  //
end;

function TEditorPage.SetupSQLObject(ASQLObject: TSQLCommandDDL): boolean;
begin
  Result:=true;
end;

procedure TEditorPage.NotyfiDeleted(ADBObject: TDBObject);
begin

end;

class function TEditorPage.PageExists(ADBObject: TDBObject): Boolean;
begin
  Result:=true;
end;

end.

