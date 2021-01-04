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

unit dsObjectsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Controls, CheckLst, Graphics, {DOM,} contnrs, Forms,
  StdCtrls, Buttons, Menus, SQLEngineAbstractUnit;

const
  sDesigner = 'Designer';

type
  TMoveType     = (mtNone, mtDrag, mtResize);
  TQBObjectState = (dosNone, dosMinim);
  TLinkType     = (ltEq, ltNEQ, ltLtl, ltGrt, ltLtEQ, ltGtEQ);
  TDrawPanelState = (dpsDesign, dpsCreate, dpsLoad);

  TQBObject = class;
  TQBObjectListEnumerator = class;
  TQBObjectLinkListEnumerator = class;

  { TQBObjectLink }

  TQBObjectLink = class
  private
    FDst: TQBObject;
    FSrc: TQBObject;
    DstName:string;
    DstIndex:integer;
    SrcIndex:integer;

    FAllFieldsSrc:boolean;
    FAllFieldsDst:boolean;
    FLinkType:TLinkType;

    SrcX:integer;
    SrcY:integer;
    DstX:integer;
    DstY:integer;

  public
    SrcField:string;
    DstField:string;
    //procedure Save(const Node:TDOMElement);
    //procedure Load(const Node:TDOMElement);
    procedure Edit;
    constructor Create(ASrc, ADst:TQBObject);

    property Dst:TQBObject read FDst;
    property Src:TQBObject read FSrc;
    property LinkType:TLinkType read FLinkType;
  end;

  { TQBObjectLinkList }

  TQBObjectLinkList = class
  private
    FList:TFPList;
    FOwner: TComponent;
    function GetCount: integer;
    function GetItems(AIndex: integer): TQBObjectLink;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear;
    function Add(ASrc, ADst:TQBObject):TQBObjectLink;
    procedure Remove(AItem:TQBObjectLink);
    function GetEnumerator: TQBObjectLinkListEnumerator;
    property Items[AIndex:integer]:TQBObjectLink read GetItems; default;
    property Count:integer read GetCount;
  end;

  { TQBObjectLinkListEnumerator }

  TQBObjectLinkListEnumerator = class
  private
    FList: TQBObjectLinkList;
    FPosition: Integer;
  public
    constructor Create(AList: TQBObjectLinkList);
    function GetCurrent: TQBObjectLink;
    function MoveNext: Boolean;
    property Current: TQBObjectLink read GetCurrent;
  end;

  { TQBObject }

  TQBObject = class(TCustomControl)
  private
    FLinks:TQBObjectLinkList;
    FDBObject: TDBObject;
    FObjCaption: string;
    FButtonMin:TSpeedButton;
    FButtonClose:TSpeedButton;
    FCheckAll:TCheckBox;
    FState:TQBObjectState;
    FSavedHignt:integer;
    FPMenu:TPopupMenu;
    function GetObjCaption: string;
    function GetObjName: string;
    procedure SetDBObject(const AValue: TDBObject);
    procedure SetObjCaption(const AValue: string);
    procedure MinSpeedButtonClick(Sender: TObject);
    procedure CloseSpeedButtonClick(Sender: TObject);
    procedure CheckAllClick(Sender: TObject);
    procedure RenameTableClick(Sender: TObject);
    procedure UnlinckTableClick(Sender: TObject);
    procedure RemoveLinkedObj(ALinkedObj:TQBObject);
    function IsLinkedTo(AObj:TQBObject):boolean;
    procedure AddLink(AObj:TQBObject; AField:string; Itm:integer);
    procedure CheckListBox1ItemClick(Sender: TObject; Index: integer);
    procedure CreateMenu;
    procedure AfterLoad;
    procedure UpdateLinkPositions;
    procedure DoUpdateFieldList;
  protected
    dX, dY, dX1, dY1, dx2, dy2:integer;
    Moved:TMoveType;
    FList:TCheckListBox;
    StartPoint:TPoint;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure SetBounds(aLeft, aTop, aWidth, aHeight: integer); override;
    procedure ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //procedure Save(ACfg:TXMLDocument; const Node:TDOMElement);
    //procedure Load(ACfg:TXMLDocument; const Node:TDOMElement);
    property ObjCaption:string read GetObjCaption write SetObjCaption;
    property ObjName:string read GetObjName;
    property List:TCheckListBox read FList;
    property Links:TQBObjectLinkList read FLinks;
    property DBObject:TDBObject read FDBObject write SetDBObject;
  end;

  { TQBObjectList }

  TQBObjectList = class
  private
    FList:TFPList;
    FOwner: TComponent;
    function GetCount: integer;
    function GetItems(AIndex: integer): TQBObject;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;override;
    procedure Clear;
    function Add:TQBObject;
    function GetEnumerator: TQBObjectListEnumerator;
    procedure Remove(AItem:TQBObject);
    property Items[AIndex:integer]:TQBObject read GetItems; default;
    property Count:integer read GetCount;
  end;

  { TQBObjectListEnumerator }

  TQBObjectListEnumerator = class
  private
    FList: TQBObjectList;
    FPosition: Integer;
  public
    constructor Create(AList: TQBObjectList);
    function GetCurrent: TQBObject;
    function MoveNext: Boolean;
    property Current: TQBObject read GetCurrent;
  end;


  { TDrawPanel }

  TDrawPanel = class(TScrollBox)
  private
    FGenText: TNotifyEvent;
    FObjectList: TQBObjectList;
    FSQLEngine: TSQLEngineAbstract;
    FState:TDrawPanelState;
    procedure UpdateLinkPositionsDst(AObj:TQBObject);
    procedure FindLinkProp(X, Y: Integer);
    procedure SetMouseCursor(X, Y: Integer);
  protected
    procedure Paint; override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
          var Accept: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateLinks;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    function GetItemName:string;
    function CreateDrawObj(const ADBObj:TDBObject):TQBObject;
    procedure RemoveDrawObj(const AObj:TQBObject);
    procedure UnlinkDrawObj(const AObj:TQBObject);
    function FindObj(AName:string):TQBObject;
    procedure UpdateText;
    //procedure OpenFile(const ADoc:TXMLDocument);
    //procedure SaveFile(const ADoc:TXMLDocument);
    procedure Clear;

    property GenText:TNotifyEvent read FGenText write FGenText;
    property ObjectList:TQBObjectList read FObjectList;
    property SQLEngine:TSQLEngineAbstract read FSQLEngine write FSQLEngine;
  end;

implementation
uses Dialogs, fbmToolsUnit, dsLinkPropertysUnit, ComCtrls,
  ibmanagertypesunit, fbmStrConstUnit, SQLEngineCommonTypesUnit;

{ TQBObjectLinkListEnumerator }

constructor TQBObjectLinkListEnumerator.Create(AList: TQBObjectLinkList);
begin
  FList := AList;
  FPosition := -1;
end;

function TQBObjectLinkListEnumerator.GetCurrent: TQBObjectLink;
begin
  Result := FList[FPosition];
end;

function TQBObjectLinkListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TQBObjectLinkList }

function TQBObjectLinkList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TQBObjectLinkList.GetItems(AIndex: integer): TQBObjectLink;
begin
  Result:=TQBObjectLink(FList[AIndex])
end;

constructor TQBObjectLinkList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TQBObjectLinkList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TQBObjectLinkList.Clear;
var
  P: TQBObjectLink;
begin
  for P in Self do
    P.Free;
  FList.Clear;
end;

function TQBObjectLinkList.Add(ASrc, ADst: TQBObject): TQBObjectLink;
begin
  Result:=TQBObjectLink.Create(ASrc, ADst);
  FList.Add(Result);
end;

procedure TQBObjectLinkList.Remove(AItem: TQBObjectLink);
begin
  if Assigned(AItem) then
  begin
    FList.Remove(AItem);
    AItem.Free;
  end;
end;

function TQBObjectLinkList.GetEnumerator: TQBObjectLinkListEnumerator;
begin
  Result:=TQBObjectLinkListEnumerator.Create(Self);
end;

{ TQBObjectListEnumerator }

constructor TQBObjectListEnumerator.Create(AList: TQBObjectList);
begin
  FList := AList;
  FPosition := -1;
end;

function TQBObjectListEnumerator.GetCurrent: TQBObject;
begin
  Result := FList[FPosition];
end;

function TQBObjectListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TQBObjectList }

function TQBObjectList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TQBObjectList.GetItems(AIndex: integer): TQBObject;
begin
  Result:=TQBObject(FList[AIndex])
end;

constructor TQBObjectList.Create(AOwner: TComponent);
begin
  inherited Create;
  FList:=TFPList.Create;
  FOwner:=AOwner;
end;

destructor TQBObjectList.Destroy;
begin
//  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TQBObjectList.Clear;
var
  P: TQBObject;
  i: Integer;
begin
  for i:=FList.Count-1 downto 0 do
    Items[i].Free;
  FList.Clear;
end;

function TQBObjectList.Add: TQBObject;
begin
  Result:=TQBObject.Create(FOwner);
  FList.Add(Result);
end;

function TQBObjectList.GetEnumerator: TQBObjectListEnumerator;
begin
  Result:=TQBObjectListEnumerator.Create(Self);
end;

procedure TQBObjectList.Remove(AItem: TQBObject);
begin
  if Assigned(AItem) then
  begin
    FList.Remove(AItem);
    AItem.Free;
  end;
end;

{ TQBObject }

procedure TQBObject.SetObjCaption(const AValue: string);
begin
  if FObjCaption=AValue then exit;
  FObjCaption:=AValue;
end;

function TQBObject.GetObjCaption: string;
begin
  if FObjCaption<>'' then
    Result:=FObjCaption
  else
    Result:=FDBObject.CaptionFullPatch;
end;

function TQBObject.GetObjName: string;
begin
  if Assigned(FDBObject) then
    Result:=FDBObject.CaptionFullPatch
  else
    Result:='';
end;

procedure TQBObject.SetDBObject(const AValue: TDBObject);
begin
  if FDBObject=AValue then exit;
  FDBObject:=AValue;
  DoUpdateFieldList;
{  if Assigned(FDBObject) then
    FDBObject.FillFieldList(FList.Items, ccoNoneCase);}
end;

procedure TQBObject.MinSpeedButtonClick(Sender: TObject);
begin
  if FState = dosNone then
  begin
    FState := dosMinim;
    FSavedHignt:=Height;
    Height:=21;
    FButtonMin.Caption:='-';
  end
  else
  begin
    FState := dosNone;
    Height:=FSavedHignt;
    FButtonMin.Caption:='O';
  end;
  Parent.Invalidate;
end;

procedure TQBObject.CloseSpeedButtonClick(Sender: TObject);
begin
  TDrawPanel(Parent).RemoveDrawObj(Self);
end;

procedure TQBObject.CheckAllClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to FList.Count-1 do
    FList.Checked[i]:=FCheckAll.Checked;
  TDrawPanel(Parent).UpdateText;
end;

procedure TQBObject.RenameTableClick(Sender: TObject);
begin
  FObjCaption:=InputBox('Table name', 'Enter table name', FObjCaption);
  Invalidate;
end;

procedure TQBObject.UnlinckTableClick(Sender: TObject);
begin
  TDrawPanel(Parent).UnlinkDrawObj(Self);
  Links.Clear;
end;

procedure TQBObject.RemoveLinkedObj(ALinkedObj: TQBObject);
var
  L: TQBObjectLink;
begin
  for L in FLinks do
    if L.Dst = ALinkedObj then
      Links.Remove(L);
end;

function TQBObject.IsLinkedTo(AObj: TQBObject): boolean;
var
  i:integer;
begin
  Result:=false;
  for i:=Links.Count-1 downto 0 do
  begin
    if TQBObjectLink(Links[i]).Dst = AObj then
    begin
      Result:=true;
      exit;
    end;
  end;
end;

procedure TQBObject.AddLink(AObj: TQBObject; AField: string; Itm:integer);
var
  L:TQBObjectLink;
begin
  L:=Links.Add(Self, AObj);
  L.DstIndex:=Itm;
  L.DstField:=AField;
  L.SrcIndex:=FList.ItemIndex;
  L.SrcField:=FList.Items[FList.ItemIndex];
end;

procedure TQBObject.Paint;
var
  R:TRect;
  S:string;
  W:integer;
begin
  if Moved<>mtNone then
    Canvas.Brush.Color:=clBlue
  else
    Canvas.Brush.Color:=clSkyBlue;
  Canvas.FillRect( 0, 0, Width-1, List.Top - 1);

  S:=ObjName;
  if FObjCaption<>'' then
    S:=S+' ('+FObjCaption+')';

  W:=Canvas.TextHeight('Wg')+1;

  if FCheckAll.Width > W then
    W:=FCheckAll.Width;

  R.Top:= 1;
  R.Left:= 1;
  R.Bottom:= W;
  R.Right:=Width - 1;
  Canvas.TextRect(R, FCheckAll.Width + 2, 1, S);


  Canvas.Pen.Color:=clBlack;
  Canvas.Line(0, 0, Width-1, 0); //top
  Canvas.Line(0, Height-1, Width, Height-1);//bottom

  Canvas.Line(0, 0, 0, Height-1);//left
  Canvas.Line(Width-1, 0, Width-1, Height-1);//rigth
end;

procedure TQBObject.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  BringToFront;

  if Button = mbLeft then
  begin
    if Cursor <> crDefault then
    begin
      Moved:=mtResize;
      dX1:=Width;
      dY1:=Height;
    end
    else
    begin
      Moved:=mtDrag;
      StartPoint:=ClientToScreen(Point(X, Y));
      dx2:=Left;
      dy2:=Top;
    end;
    dX:=X;
    dY:=Y;
  end;
end;

procedure TQBObject.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  if Moved <> mtNone then
  begin
    if Moved = mtResize then
    begin
      Width := dX1+ (X - dX);
      if FState <> dosMinim then
        Height:= dY1 + (Y - dY);
    end
    else
    begin
      if (X>0) and (Y>0) then
      begin
        Left:=Left+(X-dX);
        Top:=Top+(y-dY);
      end;
    end;
  end
  else
  begin
    if Y > Height - 10 then
    begin
      if (X < 10) then
        Cursor:=crSizeNESW
      else
      if (X > Width - 10) then
        Cursor:=crSizeNWSE
      else
        Cursor:=crDefault;
    end
    else
      Cursor:=crDefault;
  end;
end;

procedure TQBObject.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Moved:=mtNone;
  Invalidate;
  Parent.Invalidate;
end;

procedure TQBObject.SetBounds(aLeft, aTop, aWidth, aHeight: integer);
begin
  if aHeight<20 then
    aHeight:=20;
  if aLeft<0 then
    aLeft:=0;

  if aTop<0 then
    aTop:=0;
  inherited SetBounds(aLeft, aTop, aWidth, aHeight);
  List.Left:=2;
  List.Top:=FCheckAll.Top * 2 + FCheckAll.Height;
  List.Height:=Height - List.Top - 4;
  List.Width:=Width-4;

  FButtonClose.Left:=Width - 21;
  FButtonMin.Left:=Width - 22 - FButtonClose.Width;
  //
  UpdateLinkPositions;
  TDrawPanel(Parent).UpdateLinkPositionsDst(Self);
end;

procedure TQBObject.ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Itm:integer;
  P:TQBObject;
begin
  P:=nil;
  if Assigned(Source) and Assigned(Sender) then
  begin
    if Source is TCheckListBox then
    begin
      if Source<>Sender then
      begin
        P:=TQBObject(TCheckListBox(Source).Parent);
        Itm:=Y div List.ItemHeight;
        if (Itm>=0) and (Itm<FList.Count-1) and (not (IsLinkedTo(P) or P.IsLinkedTo(Self))) then
        begin
          P.AddLink(Self, FList.Items[Itm], Itm);
        end;
      end;
    end;
  end;
  TDrawPanel(Parent).UpdateText;
  if Assigned(P) then
    P.UpdateLinkPositions;
  UpdateLinkPositions;
  Parent.Invalidate;
end;

procedure TQBObject.ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(Source) then
    Accept:=Source is TCheckListBox
  else
    Accept:=false;
end;

procedure TQBObject.CheckListBox1ItemClick(Sender: TObject; Index: integer);
begin
  TDrawPanel(Parent).UpdateText;
end;

procedure TQBObject.CreateMenu;
var
  M:TMenuItem;
begin
  FPMenu:=TPopupMenu.Create(Self);
  FPMenu.Parent:=Self;
  PopupMenu:=FPMenu;

  M:=TMenuItem.Create(Self);
  M.Caption:=sUnlinkTable;
  FPMenu.Items.Add(M);
  M.OnClick:=@UnlinckTableClick;

  M:=TMenuItem.Create(Self);
  M.Caption:=sRenameTable;
  FPMenu.Items.Add(M);
  M.OnClick:=@RenameTableClick;

  M:=TMenuItem.Create(Self);
  M.Caption:='-';
  FPMenu.Items.Add(M);

  M:=TMenuItem.Create(Self);
  M.Caption:=sDeleteTable;
  FPMenu.Items.Add(M);
  M.OnClick:=@CloseSpeedButtonClick;
end;

procedure TQBObject.UpdateLinkPositions;
var
  i:integer;
  P:TQBObjectLink;
begin
  for i:= 0 to Links.Count-1 do
  begin
    P:=TQBObjectLink(Links[i]);

    if P.FDst.FState = dosMinim then
      P.DstY:=P.FDst.Top
    else
      P.DstY:=P.FDst.Top + P.FDst.List.ItemHeight * (P.DstIndex - P.FDst.List.TopIndex) + P.FDst.List.Top + P.FDst.List.ItemHeight div 2;

    if FState = dosMinim then
      P.SrcY:=Top
    else
      P.SrcY:=Top + List.ItemHeight * (P.SrcIndex - List.TopIndex) + List.Top + List.ItemHeight div 2;

    if (Left + Width) < P.Dst.Left then
      P.SrcX:=Left + Width
    else
      P.SrcX:=Left;

    if (P.Dst.Left + P.Dst.Width < Left) then
      P.DstX:=P.FDst.Left + P.FDst.Width
    else
      P.DstX:=P.FDst.Left;
  end;
end;

procedure TQBObject.DoUpdateFieldList;
var
  L:TStringList;
  i:integer;
begin
  if Assigned(FDBObject) then
  begin
    L:=TStringList.Create;
    try
      FDBObject.FillFieldList(L, ccoNoneCase, false);
      for i:=List.Items.Count - 1 downto 0 do
      begin
        if L.IndexOf(List.Items[i])<0 then
          List.Items.Delete(i);
      end;

      for i:=0 to L.Count - 1 do
      begin
        if List.Items.IndexOf(L[i])<0 then
          List.Items.Add(L[i]);
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TQBObject.AfterLoad;
begin
  UpdateLinkPositions;
end;

constructor TQBObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtonMin:=TSpeedButton.Create(Self);
  FButtonMin.Parent:=Self;
  FButtonMin.Height:=18;
  FButtonMin.Width:=18;
  FButtonMin.Top:=1;
  FButtonMin.OnClick:=@MinSpeedButtonClick;
  FButtonMin.Caption:='O';

  FButtonClose:=TSpeedButton.Create(Self);
  FButtonClose.Parent:=Self;
  FButtonClose.Height:=18;
  FButtonClose.Width:=18;
  FButtonClose.Top:=1;
  FButtonClose.OnClick:=@CloseSpeedButtonClick;
  FButtonClose.Caption:='X';

  FCheckAll:=TCheckBox.Create(Self);
  FCheckAll.Parent:=Self;
  FCheckAll.Top:=1;
  FCheckAll.Left:=1;
  FCheckAll.OnClick:=@CheckAllClick;

  FLinks:=TQBObjectLinkList.Create;

  FList:=TCheckListBox.Create(Self);
  FList.Parent:=Self;

  FList.DragMode:=dmAutomatic;
  FList.OnDragDrop:=@ListBoxDragDrop;
  FList.OnDragOver:=@ListBoxDragOver;
  FList.OnItemClick:=@CheckListBox1ItemClick;

  CreateMenu;

  FDBObject:=nil;
end;

destructor TQBObject.Destroy;
begin
  FreeAndNil(FLinks);
  inherited Destroy;
end;
(*
procedure TQBObject.Save(ACfg: TXMLDocument; const Node:TDOMElement);
var
  i:integer;
  Node1:TDOMElement;
begin
  if not Assigned(Node) then exit;
  Node.SetAttribute('Top', IntToStr(Top));
  Node.SetAttribute('Left', IntToStr(Left));
  Node.SetAttribute('Width', IntToStr(Width));
  Node.SetAttribute('Height', IntToStr(Height));
  Node.SetAttribute('Caption', FObjCaption);
  Node.SetAttribute('State', IntToStr(Ord(FState)));
  Node.SetAttribute('SavedHignt', IntToStr(FSavedHignt));

  Node.SetAttribute('ObjName', ObjName);

  Node.SetAttribute('CountLinks', IntToStr(FLinks.Count));
  for i:=0 to FLinks.Count-1 do
  begin
    Node1:=ACfg.CreateElement('Link_'+IntToStr(i));
    Node.AppendChild(Node1);
    TQBObjectLink(FLinks[i]).Save(Node1);
  end;

  Node.SetAttribute('CountFields', IntToStr(List.Items.Count));
  for i:=0 to List.Items.Count-1 do
  begin
    Node1:=ACfg.CreateElement('Field_'+IntToStr(i));
    Node.AppendChild(Node1);
    Node1.SetAttribute('Caption', List.Items[i]);
    Node1.SetAttribute('Checked', IntToStr(Ord(List.Checked[i])));
  end;
end;

procedure TQBObject.Load(ACfg: TXMLDocument; const Node:TDOMElement);
var
  i, Cnt:integer;
  Node1:TDOMElement;
  L:TQBObjectLink;
  S:string;
begin
  if not Assigned(Node) then exit;
  Top:=StrToIntDef(Node.GetAttribute('Top'), 0);
  Left:=StrToIntDef(Node.GetAttribute('Left'), 0);
  Width:=StrToIntDef(Node.GetAttribute('Width'), 0);
  Height:=StrToIntDef(Node.GetAttribute('Height'), 0);
  FObjCaption:=Node.GetAttribute('Caption');
  FState:=TQBObjectState(StrToIntDef(Node.GetAttribute('State'), 0));
  FSavedHignt:=StrToIntDef(Node.GetAttribute('SavedHignt'), 20);

  Cnt:=StrToIntDef(Node.GetAttribute('CountLinks'), 0);
  for i:= 0 to Cnt-1 do
  begin
    Node1:=TDOMElement(Node.FindNode('Link_'+IntToStr(i)));
    if Assigned(Node1) then
    begin
      L:=FLinks.Add(Self, nil);
      L.Load(Node1);
    end;
  end;

  Cnt:=StrToIntDef(Node.GetAttribute('CountFields'), 0);
  List.Items.Clear;
  for i:=0 to Cnt-1 do
  begin
    Node1:=TDOMElement(Node.FindNode('Field_'+IntToStr(i)));
    if Assigned(Node1) then
    begin
      List.Items.Add(Node1.GetAttribute('Caption'));
      List.Checked[i]:=Node1.GetAttribute('Checked') = '1';
    end;
  end;

  S:=Node.GetAttribute('ObjName');
  if Assigned(TDrawPanel(Owner).SQLEngine) then
    DBObject:=TDrawPanel(Owner).SQLEngine.DBObjectByName(S);
end;
*)
{ TDrawPanel }

{procedure TDrawPanel.FillTableFields(AObj:TQBObject);
var
  P:TDBObject;
begin
  if Assigned(SQLE) and Assigned(AObj) then
  begin
    P:=SQLE.DBObjectByName(AObj.ObjName);
    if Assigned(P) then
      P.FillFieldList(AObj.FList.Items, ccoUpperCase);
  end;
end;}

procedure TDrawPanel.UpdateLinkPositionsDst(AObj: TQBObject);
var
  P: TQBObject;
  L: TQBObjectLink;
begin
  for P in FObjectList do
    for L in P.Links do
      if L.Dst = AObj then
      begin
        P.UpdateLinkPositions;
        exit;
      end;
end;

procedure TDrawPanel.FindLinkProp(X, Y: Integer);
var
  P: TQBObject;
  L: TQBObjectLink;
begin
  for P in FObjectList do
  begin
    for L in P.Links do
    begin
      if ((Abs(X-L.DstX)<10) and (Abs(Y-L.DstY)<10)) or ((Abs(X-L.SrcX)<10) and (Abs(Y-L.SrcY)<10)) then
      begin
        L.Edit;
        exit;
      end;
    end;
  end;
end;

procedure TDrawPanel.SetMouseCursor(X, Y: Integer);
var
  P:TQBObject;
  L:TQBObjectLink;
begin
  for P in FObjectList do
  begin
    for L in P.Links do
    begin
      if ((Abs(X-L.DstX)<10) and (Abs(Y-L.DstY)<10)) or ((Abs(X-L.SrcX)<10) and (Abs(Y-L.SrcY)<10)) then
      begin
        Cursor:=crHandPoint;
        exit;
      end;
    end;
  end;
  Cursor:=crDefault;
end;

procedure TDrawPanel.Paint;
var
  IH: Integer;
  P: TQBObject;
  L: TQBObjectLink;
begin
  inherited Paint;
  Canvas.Pen.Color:=clBlack;
  if FObjectList.Count > 0 then
    IH:=FObjectList[0].List.ItemHeight div 2
  else
    IH:=10;

{  for i:=0 to ObjList.Count-1 do
  begin
    P:=TQBObject(ObjList[i]);
    for j:=0 to P.Links.Count-1 do
    begin

      L:=TQBObjectLink(P.Links[j]);

      if P.FState = dosMinim then
        YS:=P.Top
      else
        YS:=P.Top + 20 + P.List.ItemHeight * (L.SrcIndex - P.List.TopIndex);

      if L.Dst.FState = dosMinim then
        YD := L.Dst.Top
      else
        YD := L.Dst.Top + 20 + L.Dst.List.ItemHeight * (L.DstIndex - L.Dst.List.TopIndex);

      if P.Left + P.Width > L.Dst.Left then
      begin
        X1D:=L.Dst.Left + L.Dst.Width;
        XD:=X1D + 10
      end
      else
      begin
        X1D:=L.Dst.Left;
        XD:=X1D - 10
      end;

      if P.Left + P.Width < L.Dst.Left then
      begin
        X1S:=P.Left + P.Width;
        XS:=X1S + 10;
      end
      else
      begin
        X1S:=P.Left;
        XS:=X1S-10;
      end;

      Canvas.Line(X1S, YS + 8, XS, YS + 8);
      Canvas.Line(X1D, YD + 8, XD, YD + 8);

      Canvas.Line(XS, YS + 8, XD, YD + 8);
    end;
  end;}


  for P in FObjectList  do
  begin
    for L in P.Links do
    begin
      Canvas.Pen.Color:=clRed;
      Canvas.Ellipse(L.SrcX - IH, L.SrcY - IH, L.SrcX + IH, L.SrcY + IH);
      Canvas.Ellipse(L.DstX - IH, L.DstY - IH, L.DstX + IH, L.DstY + IH);
      Canvas.Pen.Color:=clBlack;
      Canvas.Line(L.SrcX, L.SrcY, L.DstX, L.DstY);
    end;
  end;

end;

procedure TDrawPanel.DragDrop(Source: TObject; X, Y: Integer);
var
  P:TQBObject;
  LB:TListBox absolute Source;
  TR:TTreeView absolute Source;
  Itm:TDBInspectorRecord;
  DBObj:TDBObject;
begin
  if Assigned(Source) then
  begin
    DBObj:=nil;
    if (Source is TListBox) then
    begin
      if (LB.Items.Count > 0) and (LB.ItemIndex >= 0) and (LB.ItemIndex < LB.Items.Count) then
        DBObj:=TDBObject(LB.Items.Objects[LB.ItemIndex]);
    end
    else
    if (Source is TTreeView) then
    begin
      if Assigned(Tr.Selected) and Assigned(Tr.Selected.Data) then
      begin
        Itm:=TDBInspectorRecord(Tr.Selected.Data);
        if Itm.RecordType = rtDBObject then
          DBObj:=Itm.DBObject;
      end;
    end;

    if Assigned(DBObj) then
    begin
      P:=CreateDrawObj(DBObj);
      P.Left:=X;
      P.Top:=Y;
      UpdateText;
    end;
  end;
end;

procedure TDrawPanel.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Assigned(Source) then
    Accept:=(Source is TListBox) or (Source is TTreeView)
  else
    Accept:=false;
end;

procedure TDrawPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and (ssDouble in Shift) then
    FindLinkProp(X,Y);
end;

procedure TDrawPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  SetMouseCursor(X, Y);
end;

constructor TDrawPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjectList:=TQBObjectList.Create(AOwner);
  FState:=dpsDesign;
end;

destructor TDrawPanel.Destroy;
begin
  FreeAndNil(FObjectList);
  inherited Destroy;
end;

procedure TDrawPanel.UpdateLinks;
var
  P:TQBObject;
  L:TQBObjectLink;
begin
  for P in FObjectList do
  begin
    for L in P.Links do
    begin
      if not Assigned(L.Dst) then
        L.FDst:=FindObj(L.DstName);
    end;
    P.AfterLoad;
  end;
end;

function TDrawPanel.GetItemName: string;
function DoTest(AName:string):boolean;
var
  P: TQBObject;
begin
  Result:=true;
  for P in FObjectList  do
  begin
    if P.ObjName = AName then
    begin
      Result:=false;
      exit;
    end;
  end;
end;
var
  i:integer;
begin
  i:=0;
  repeat
    inc(i);
  until DoTest('Item_'+IntToStr(i));
  Result:='Item_'+IntToStr(i);
end;

function TDrawPanel.CreateDrawObj(const ADBObj: TDBObject): TQBObject;
begin
  Result:=ObjectList.Add;
  Result.Parent:=Self;
  Result.Top:=10;
  Result.Width:=100;
  Result.Height:=100;
  Result.Left:=10;
  Result.DBObject:=ADBObj;
  if FState = dpsDesign then
    UpdateText;
end;

procedure TDrawPanel.RemoveDrawObj(const AObj: TQBObject);
var
  i:integer;
begin
  FObjectList.Remove(AObj);
  Invalidate;
  UpdateText;
end;

procedure TDrawPanel.UnlinkDrawObj(const AObj: TQBObject);
var
  P: TQBObject;
begin
  for P in FObjectList do
    P.RemoveLinkedObj(AObj);
  Invalidate;
  UpdateText;
end;

function TDrawPanel.FindObj(AName: string): TQBObject;
var
  P: TQBObject;
begin
  Result:=nil;
  for P in FObjectList do
  begin
    if P.ObjName = AName then
    begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure TDrawPanel.UpdateText;
begin
  if Assigned(FGenText) then
    FGenText(Self);
end;
(*
procedure TDrawPanel.OpenFile(const ADoc:TXMLDocument);
procedure LoadDoc(const Doc:TXMLDocument);
var
  Root, Node:TDOMElement;
  Cnt, i:integer;
  P:TQBObject;
begin
  Root:=Doc.FindNode(sDesigner) as TDOMElement;
  Cnt:=StrToIntDef(Root.GetAttribute('Count'), 0);
  for i:= 0 to Cnt-1 do
  begin
    Node:=TDOMElement(Root.FindNode('Item_'+IntToStr(i)));
    if Assigned(Node) then
    begin
      begin
        { TODO : Необходимо переработать сохранение и загрузку документов }
        P:=CreateDrawObj(nil);
        P.Parent:=Self;
        P.Load(Doc, Node);
{        if P.ObjName = '' then
          P.ObjName:=GetItemName;}
      end;
    end;
  end;
end;

begin
  FState:=dpsLoad;
  Clear;
  LoadDoc(ADoc);
  UpdateLinks;
  FState:=dpsDesign;
  Invalidate;
end;

procedure TDrawPanel.SaveFile(const ADoc:TXMLDocument);
var
  i:integer;
  Root, Node:TDOMElement;
begin
  (*
  { TODO : Необходимо переработать сохранение и загрузку документов }
  Root:=ADoc.FindNode(sDesigner) as TDOMElement;
  Root.SetAttribute('Count', IntToStr(ObjList.Count));
  for i:=0 to ObjList.Count-1 do
  begin
    Node:=ADoc.CreateElement('Item_'+IntToStr(i));
    TQBObject(ObjList[i]).Save(ADoc, Node);
    Root.AppendChild(Node);
  end;
  *)
end;
*)
procedure TDrawPanel.Clear;
begin
  ObjectList.Clear;
  if FState = dpsDesign then
  begin
    UpdateText;
    Invalidate;
  end;
end;

{ TQBObjectLink }
(*
procedure TQBObjectLink.Save(const Node: TDOMElement);
begin
  Node.SetAttribute('DstName', Dst.ObjName);
  Node.SetAttribute('SrcField', SrcField);
  Node.SetAttribute('DstField', DstField);

  Node.SetAttribute('SrcIndex', IntToStr(SrcIndex));
  Node.SetAttribute('DstIndex', IntToStr(DstIndex));
end;

procedure TQBObjectLink.Load(const Node: TDOMElement);
begin
  DstName:=Node.GetAttribute('DstName');
  SrcField:=Node.GetAttribute('SrcField');
  DstField:=Node.GetAttribute('DstField');

  SrcIndex:=StrToIntDef(Node.GetAttribute('SrcIndex'), 0);
  DstIndex:=StrToIntDef(Node.GetAttribute('DstIndex'), 0);
end;
*)
procedure TQBObjectLink.Edit;
begin
  dsLinkPropertysForm:=TdsLinkPropertysForm.Create(Application);
  dsLinkPropertysForm.Label1.Caption:=Format(sLinkPropLabel1, [ FSrc.ObjName, FDst.ObjName]);
  dsLinkPropertysForm.CheckBox1.Caption:=Format(sLinkPropIncludeAllFrom, [FSrc.ObjName]);
  dsLinkPropertysForm.CheckBox2.Caption:=Format(sLinkPropIncludeAllFrom, [FDst.ObjName]);
  dsLinkPropertysForm.Label2.Caption:=FSrc.ObjName+'.'+SrcField;
  dsLinkPropertysForm.Label3.Caption:=FDst.ObjName+'.'+DstField;

  dsLinkPropertysForm.CheckBox1.Checked:=FAllFieldsSrc;
  dsLinkPropertysForm.CheckBox2.Checked:=FAllFieldsDst;
  dsLinkPropertysForm.ComboBox1.ItemIndex:=ord(FLinkType);

  if dsLinkPropertysForm.ShowModal = mrOk then
  begin
    FAllFieldsSrc:=dsLinkPropertysForm.CheckBox1.Checked;
    FAllFieldsDst:=dsLinkPropertysForm.CheckBox2.Checked;
    FLinkType:=TLinkType(dsLinkPropertysForm.ComboBox1.ItemIndex);
  end;
  dsLinkPropertysForm.Free;
end;

constructor TQBObjectLink.Create(ASrc, ADst: TQBObject);
begin
  inherited Create;
  FDst:=ADst;
  FSrc:=ASrc;
end;

end.

