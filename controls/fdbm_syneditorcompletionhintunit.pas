{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbm_SynEditorCompletionHintUnit;

{$I fbmanager_define.inc}

interface

uses
  LCLIntf, Classes, SysUtils, Forms, ExtCtrls, LCLType, Controls, SynMemo, Buttons,
  SynEdit, SynEditKeyCmds, Themes, Graphics, fdbm_SynEditorUnit, BasicCodeTools, LMessages,
  SQLEngineAbstractUnit;

type

  { TCodeContextItem }

  TCodeContextItem = class
  public
    //Code: string;
    Hint: string;
    CopyAllButton: TSpeedButton;
    Obj:TDBObject;
    destructor Destroy; override;
  end;

  { TCodeHintInfo }

  TCodeHintInfo = record
    EditorFrame:Tfdbm_SynEditorFrame;
    HintText:string;
    FunctionNamePos:TPoint;
    BracketPos:TPoint;
    DBObject:TDBObject;
  end;

  TCodeXYPosition = packed record
    //Code: TCodeBuffer;
    X, Y: integer;
  end;

  { TCodeContextFrm }

  TCodeContextFrm = class(THintWindow)
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    procedure CopyAllBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
  private
    FHints: TFPList; // list of TCodeContextItem
    FLastParameterIndex: integer;
    FParamListBracketOpenCodeXYPos: TCodeXYPosition;
    FProcNameCodeXYPos: TCodeXYPosition;
    FSourceEditorTopIndex: integer;
    FBtnWidth: integer;
{    procedure CreateHints(const CodeContexts: TCodeContextInfo);
    procedure ClearMarksInHints;}
    function GetHints(Index: integer): TCodeContextItem;
{    procedure MarkCurrentParameterInHints(ParameterIndex: integer); // 0 based}
    procedure CalculateHintsBounds;
    procedure DrawHints(var MaxWidth, MaxHeight: Integer; Draw: boolean);
    procedure CompleteParameters({DeclCode: string} Item: TCodeContextItem);
    procedure ClearHints;
  protected
    FCodeContexts:TCodeHintInfo;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure WMNCHitTest(var Message: TLMessage); message LM_NCHITTEST;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetCodeContexts(const ACodeContexts:TCodeHintInfo);
    procedure UpdateHints;
    procedure Paint; override;
//    property ProcNameCodeXYPos: TCodeXYPosition read FProcNameCodeXYPos;
    property ParamListBracketOpenCodeXYPos: TCodeXYPosition read FParamListBracketOpenCodeXYPos;
//    property SourceEditorTopIndex: integer read FSourceEditorTopIndex;
//    property LastParameterIndex: integer read FLastParameterIndex;
    property Hints[Index: integer]: TCodeContextItem read GetHints;
  end;

function ShowCodeContext(const ACodeContexts:TCodeHintInfo): boolean;
procedure HideCodeContext;

function IsIdentStartChar(C:Char):Boolean;
implementation
uses math, IBManMainUnit, sqlObjects;

var
  CodeContextFrm: TCodeContextFrm = nil;


type
  TWinControlAccess = class(TWinControl);
  TDBStoredProcObjectAccess = class(TDBStoredProcObject);

function ShowCodeContext(const ACodeContexts:TCodeHintInfo): boolean;
begin
  Result := False;
  if not Assigned(ACodeContexts.EditorFrame) then
  begin
    HideCodeContext;
    Exit;
  end;

  if CodeContextFrm = nil then
    CodeContextFrm := TCodeContextFrm.Create(nil);

  CodeContextFrm.DisableAlign;
  try
    CodeContextFrm.SetCodeContexts(ACodeContexts);
    CodeContextFrm.Show;
    Result := True;
  finally
    CodeContextFrm.EnableAlign;
  end;
end;

procedure HideCodeContext;
begin
  if Assigned(CodeContextFrm) then
  begin
    CodeContextFrm.Hide;
    CodeContextFrm.FCodeContexts.EditorFrame:=nil;
  end;
end;

function IsIdentStartChar(C: Char): Boolean;
begin
  Result:=C in ['A'..'z'];
end;

{ TCodeContextItem }

destructor TCodeContextItem.Destroy;
begin
  inherited Destroy;
end;

{ TCodeContextFrm }

procedure TCodeContextFrm.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  if not Visible then exit;
  UpdateHints;
end;

procedure TCodeContextFrm.CopyAllBtnClick(Sender: TObject);
var
  i: Integer;
  Item: TCodeContextItem;
begin
  i:=FHints.Count-1;
  while (i>=0) do
  begin
    Item:=Hints[i];
    if Item.CopyAllButton=Sender then
    begin
      //debugln(['TCodeContextFrm.CopyAllBtnClick Hint="',Item.Code,'"']);
      CompleteParameters(Item{.Code});
      exit;
    end;
    dec(i);
  end;
end;

procedure TCodeContextFrm.FormCreate(Sender: TObject);
begin
  FBtnWidth:=16;
  FHints:=TFPList.Create;
  Application.AddOnIdleHandler(@ApplicationIdle);
end;

procedure TCodeContextFrm.FormDestroy(Sender: TObject);
begin
  ClearHints;
  FreeAndNil(FHints);
end;

procedure TCodeContextFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_ESCAPE) and (Shift=[]) then
    Hide
  else
  if not Assigned(FCodeContexts.EditorFrame) then
      Hide
  else
  begin
    // redirect keys
    TWinControlAccess(FCodeContexts.EditorFrame.TextEditor).KeyDown(Key,Shift);
    SetActiveWindow(FCodeContexts.EditorFrame.TextEditor.Handle);
  end;
end;

procedure TCodeContextFrm.FormPaint(Sender: TObject);
var
  DrawWidth: LongInt;
  DrawHeight: LongInt;
begin
  DrawWidth:=ClientWidth;
  DrawHeight:=ClientHeight;
  DrawHints( DrawWidth, DrawHeight, true);
end;

procedure TCodeContextFrm.FormUTF8KeyPress(Sender: TObject;
  var UTF8Key: TUTF8Char);
begin
  if not Assigned(FCodeContexts.EditorFrame) then
    Hide
  else
    FCodeContexts.EditorFrame.TextEditor.CommandProcessor(ecChar,UTF8Key,nil);
end;

function TCodeContextFrm.GetHints(Index: integer): TCodeContextItem;
begin
  Result:=TCodeContextItem(FHints[Index]);
end;

procedure TCodeContextFrm.CalculateHintsBounds;
var
  DrawWidth: LongInt;
  SrcEdit: TCustomSynEdit;
  NewBounds: TRect;
  CursorTextXY: TPoint;
  ScreenTextXY: TPoint;
  ClientXY: TPoint;
  DrawHeight: LongInt;
  ScreenXY: TPoint;
begin
  if not Assigned(FCodeContexts.EditorFrame) then
    exit;
  SrcEdit:=FCodeContexts.EditorFrame.TextEditor;

  // calculate the position of the context in the source editor
  CursorTextXY:= SrcEdit.CaretXY; //SrcEdit.CursorTextXY;
{  if ProcNameCodeXYPos.Code<>nil then
  begin
    if (ProcNameCodeXYPos.Code=SrcEdit.CodeToolsBuffer)
    and (ProcNameCodeXYPos.Y<=CursorTextXY.Y) then begin
      CursorTextXY:=Point(ProcNameCodeXYPos.X,ProcNameCodeXYPos.Y);
    end;
  end;}
  // calculate screen position
  ScreenTextXY:=SrcEdit.LogicalToPhysicalPos(CursorTextXY);
  ClientXY:=SrcEdit.RowColumnToPixels(ScreenTextXY);

  ScreenXY:=SrcEdit.ClientToScreen(ClientXY);
  FSourceEditorTopIndex:=SrcEdit.TopLine;

  // calculate size of hints
  DrawWidth:=FCodeContexts.EditorFrame.ClientWidth;
  DrawHeight:=ScreenXY.Y-GetParentForm(SrcEdit).Monitor.WorkareaRect.Top-10;
  DrawHints(DrawWidth,DrawHeight,false);
  if DrawWidth<20 then DrawWidth:=20;
  if DrawHeight<5 then DrawHeight:=5;

  // calculate position of hints in editor client area
  if ClientXY.X+DrawWidth>SrcEdit.ClientWidth then
    ClientXY.X:=SrcEdit.ClientWidth-DrawWidth;
  if ClientXY.X<0 then
    ClientXY.X:=0;
  dec(ClientXY.Y,DrawHeight);

  // calculate screen position
  ScreenXY:=SrcEdit.ClientToScreen(ClientXY);
  NewBounds:=Bounds(ScreenXY.X,ScreenXY.Y-4,DrawWidth,DrawHeight);

  // move form
  BoundsRect:=NewBounds;
end;

procedure TCodeContextFrm.DrawHints(var MaxWidth, MaxHeight: Integer;
  Draw: boolean);
var
  LeftSpace, RightSpace: Integer;
  VerticalSpace: Integer;
  BackgroundColor, TextGrayColor, TextColor, PenColor: TColor;
  TextGrayStyle, TextStyle: TFontStyles;

  procedure DrawHint(Index: integer; var AHintRect: TRect);
  var
    ATextRect: TRect;
    TokenStart: Integer;
    TokenRect: TRect;
    TokenSize: TPoint;
    TokenPos: TPoint;
    TokenEnd: LongInt;
    UsedWidth: Integer; // maximum right token position
    LineHeight: Integer; // current line height
    LastTokenEnd: LongInt;
    Line: string;
    Item: TCodeContextItem;
    y: LongInt;
  begin
    Item:=Hints[Index];
    Line:=Item.Hint;
    ATextRect:=Rect(AHintRect.Left+LeftSpace,
                    AHintRect.Top+VerticalSpace,
                    AHintRect.Right-RightSpace,
                    AHintRect.Bottom-VerticalSpace);
    UsedWidth:=0;
    LineHeight:=0;
    TokenPos:=Point(ATextRect.Left,ATextRect.Top);
    TokenEnd:=1;
    while (TokenEnd<=length(Line)) do
    begin
      LastTokenEnd:=TokenEnd;
      ReadRawNextPascalAtom(Line,TokenEnd,TokenStart);
      if TokenEnd<=LastTokenEnd then break;
      if Line[TokenStart]='\' then
      begin
        // mark found
        if TokenStart>LastTokenEnd then
        begin
          // there is a gap between last token and this token -> draw that first
          TokenEnd:=TokenStart;
        end
        else
        begin
          inc(TokenStart);
          if TokenStart>length(Line) then break;
          TokenEnd:=TokenStart+1;
          // the token is a mark
          case Line[TokenStart] of

          '*':
            begin
              // switch to normal font
              if Draw then
              begin
                Canvas.Font.Color:=TextGrayColor;
                Canvas.Font.Style:=TextGrayStyle;
              end;
              //DebugLn('DrawHint gray');
              continue;
            end;

          'b':
            begin
              // switch to normal font
              if Draw then
              begin
                Canvas.Font.Color:=TextColor;
                Canvas.Font.Style:=TextStyle;
              end;
              //DebugLn('DrawHint normal');
              continue;
            end;

          else
            // the token is a normal character -> paint it
          end;
        end;
      end;
      //DebugLn('DrawHint Token="',copy(Line,TokenStart,TokenEnd-TokenStart),'"');

      // calculate token size
      TokenRect:=Bounds(0,0,12345,1234);
      DrawText(Canvas.Handle,@Line[LastTokenEnd],TokenEnd-LastTokenEnd,TokenRect,
               DT_SINGLELINE+DT_CALCRECT+DT_NOCLIP);
      TokenSize:=Point(TokenRect.Right,TokenRect.Bottom);
      {$IFDEF EnableCCFFontMin}
      // workaround for bug 22190
      if TokenSize.y<14 then TokenSize.y:=14;
      {$ENDIF}
      //DebugLn(['DrawHint Draw="',Draw,'" Token="',copy(Line,TokenStart,TokenEnd-TokenStart),'" TokenSize=',dbgs(TokenSize)]);

      if (LineHeight>0) and (TokenPos.X+TokenRect.Right>ATextRect.Right) then
      begin
        // token does not fit into line -> break line
        // fill end of line
        if Draw and (TokenPos.X<AHintRect.Right) then
        begin
          Canvas.FillRect(Rect(TokenPos.X,TokenPos.Y-VerticalSpace,
                          AHintRect.Right,TokenPos.Y+LineHeight+VerticalSpace));
        end;
        TokenPos:=Point(ATextRect.Left,TokenPos.y+LineHeight+VerticalSpace);
        LineHeight:=0;
      end;

      // token fits into line
      // => draw token
      OffsetRect(TokenRect,TokenPos.x,TokenPos.y);
      if Draw then
      begin
        Canvas.FillRect(Rect(TokenRect.Left,TokenRect.Top-VerticalSpace,
                             TokenRect.Right,TokenRect.Bottom+VerticalSpace));
        DrawText(Canvas.Handle,@Line[LastTokenEnd],TokenEnd-LastTokenEnd,
                 TokenRect,DT_SINGLELINE+DT_NOCLIP);
      end;
      // update LineHeight and UsedWidth
      if LineHeight<TokenSize.y then
        LineHeight:=TokenSize.y;
      inc(TokenPos.X,TokenSize.x);
      if UsedWidth<TokenPos.X then
        UsedWidth:=TokenPos.X;
    end;
    // fill end of line
    if Draw and (TokenPos.X<AHintRect.Right) and (LineHeight>0) then begin
      Canvas.FillRect(Rect(TokenPos.X,TokenPos.Y-VerticalSpace,
                      AHintRect.Right,TokenPos.Y+LineHeight+VerticalSpace));
    end;

    if (not Draw) and (UsedWidth>0) then
      AHintRect.Right:=UsedWidth+RightSpace;
    AHintRect.Bottom:=TokenPos.Y+LineHeight+VerticalSpace;

    if Draw and (Item.CopyAllButton<>nil) then
    begin
      // move button at end of first line
      y:=ATextRect.Top;
      if LineHeight>FBtnWidth then
        inc(y,(LineHeight-FBtnWidth) div 2);
      Item.CopyAllButton.SetBounds(AHintRect.Right-RightSpace-1,y,FBtnWidth,FBtnWidth);
      Item.CopyAllButton.Visible:=true;
    end;

    //debugln(['DrawHint ',y,' Line="',dbgstr(Line),'" LineHeight=',LineHeight,' ']);
  end;

var
  i: Integer;
  NewMaxHeight, W, W1: Integer;
  NewMaxWidth: Integer;
  CurHintRect: TRect;
  Details: TThemedElementDetails;
begin
  if Draw then
  begin
    // make colors theme dependent
    BackgroundColor:=clInfoBk;
    TextGrayColor:=clInfoText;
    TextGrayStyle:=[];
    TextColor:=clInfoText;
    TextStyle:=[fsBold];
    PenColor:=clBlack;
  end;
  LeftSpace:=2;
  RightSpace:=2+FBtnWidth;
  VerticalSpace:=2;

  if Draw then
  begin
    Canvas.Brush.Color:=BackgroundColor;
    Canvas.Font.Color:=TextGrayColor;
    Canvas.Font.Style:=TextGrayStyle;
    Canvas.Pen.Color:=PenColor;
    Details := ThemeServices.GetElementDetails(tttStandardLink);
    ThemeServices.DrawElement(Canvas.Handle, Details, Canvas.ClipRect);
  end
  else
  begin
    Canvas.Font.Style:=[fsBold];
  end;

  NewMaxWidth:=0;
  NewMaxHeight:=0;
  for i:=0 to FHints.Count-1 do
  begin
    if Draw and (NewMaxHeight>=MaxHeight) then break;
    CurHintRect:=Rect(0,NewMaxHeight,MaxWidth,MaxHeight);
    DrawHint(i,CurHintRect);
    if CurHintRect.Right>NewMaxWidth then
      NewMaxWidth:=CurHintRect.Right;
    NewMaxHeight:=CurHintRect.Bottom;
  end;
(*
  if Assigned(FCodeContexts.DBObject) and (FCodeContexts.DBObject.Description <> '') then
  begin
    W:=Canvas.TextHeight(FCodeContexts.DBObject.Description);
    W1:=NewMaxHeight + W div 2;
    NewMaxHeight:=W + W1;
    if Draw then
      Canvas.TextOut(5, W1, FCodeContexts.DBObject.Description);

  end;
*)
  // for fractionals add some space
  inc(NewMaxWidth,12);
  //inc(NewMaxHeight,12);
  // add space for the copy all button
  //inc(NewMaxWidth,16);

  if Draw then
  begin
    // fill rest of form
    if NewMaxHeight<MaxHeight then
      Canvas.FillRect(Rect(0,NewMaxHeight,MaxWidth,MaxHeight));
    // draw frame around window
    Canvas.Frame(Rect(0,0,MaxWidth-1,MaxHeight-1));
  end
  else
  begin
    // adjust max width and height
    if NewMaxWidth<MaxWidth then
      MaxWidth:=NewMaxWidth;
    if NewMaxHeight<MaxHeight then
      MaxHeight:=NewMaxHeight;
  end;

end;

procedure TCodeContextFrm.CompleteParameters(Item: TCodeContextItem);

function ReadNextAtom(ASynEdit: TSynEdit; var TokenLine, TokenEnd: integer; out TokenStart: integer): string;
var
  Line: string;
begin
  while TokenLine<=ASynEdit.Lines.Count do begin
    Line:=ASynEdit.Lines[TokenLine-1];
    ReadRawNextPascalAtom(Line,TokenEnd,TokenStart);
    if TokenStart<TokenEnd then begin
      Result:=copy(Line,TokenStart,TokenEnd-TokenStart);
      exit;
    end;
    inc(TokenLine);
    TokenEnd:=1;
  end;
  TokenStart:=TokenEnd;
  Result:='';
end;

procedure AddParameters(ASynEdit: TSynEdit; Y, X: integer; AddComma, AddCLoseBracket: boolean; StartIndex: integer);
var
  NewCode: String;
  TokenStart: Integer;
  BracketLevel: Integer;
  ParameterIndex: Integer;
  TokenEnd, i: integer;
  LastToken: String;
  Indent: LongInt;
  XY: TPoint;
  F: TDBField;
begin
  TokenEnd:=1;
  BracketLevel:=0;
  ParameterIndex:=-1;
  NewCode:='';
  LastToken:='';

  if Item.Obj is TDBStoredProcObject then
  begin
    i:=StartIndex;
    while I < TDBStoredProcObjectAccess(Item.Obj).FieldsIN.Count do
    begin
      F:=TDBStoredProcObjectAccess(Item.Obj).FieldsIN[i];
      if F.IOType in [spvtInput, spvtInOut] then
      begin
        if AddComma then NewCode:=NewCode+', ';
        NewCode:=NewCode + F.FieldName;
        inc(I);
        AddComma:=true;
      end
    end;
  end;
(*
  repeat
    ReadRawNextPascalAtom(DeclCode,TokenEnd,TokenStart);
    if TokenEnd=TokenStart then break;
    case DeclCode[TokenStart] of
    '(','[':
      begin
        inc(BracketLevel);
        if BracketLevel=1 then
          ParameterIndex:=0;
      end;
    ')',']':
      begin
        dec(BracketLevel);
        if BracketLevel=0 then begin
          // closing bracket found
          break;
        end;
      end;
    ',',':':
      if BracketLevel=1 then begin
        //if (LastToken<>'') and (IsIdentStartChar[LastToken[1]])
        if (LastToken<>'') and (IsIdentStartChar(LastToken[1]))
        and (ParameterIndex>=StartIndex) then begin
          // add parameter
          if AddComma then
            NewCode:=NewCode+',';
          NewCode:=NewCode+LastToken;
          AddComma:=true;
        end;
        if DeclCode[TokenStart]=',' then
          inc(ParameterIndex);
      end;
    ';':
      if BracketLevel=1 then
        inc(ParameterIndex);
    else

    end;
    LastToken:=copy(DeclCode,TokenStart,TokenEnd-TokenStart);
  until false;
  *)
  if NewCode='' then exit;
  if AddCLoseBracket then
    NewCode:=NewCode + ')';
  // format insertion
  Indent:=GetLineIndentWithTabs(ASynEdit.Lines[Y-1],X,ASynEdit.TabWidth);
  if Y<>FParamListBracketOpenCodeXYPos.Y then
    dec(Indent, 2);//CodeToolBoss.SourceChangeCache.BeautifyCodeOptions.Indent);
  //NewCode:=CodeToolBoss.SourceChangeCache.BeautifyCodeOptions.BeautifyStatement( NewCode, Indent,[],X);
  delete(NewCode, 1, Indent);
  if NewCode='' then
  begin
    //ShowMessage(lisAllParametersOfThisFunctionAreAlreadySetAtThisCall);
    exit;
  end;
  // insert
  ASynEdit.BeginUndoBlock{$IFDEF SynUndoDebugBeginEnd}('TCodeContextFrm.CompleteParameters'){$ENDIF};
  try
    XY:=Point(X,Y);
    ASynEdit.BlockBegin:=XY;
    ASynEdit.BlockEnd:=XY;
    ASynEdit.LogicalCaretXY:=XY;
    ASynEdit.SelText:=NewCode;
  finally
    ASynEdit.EndUndoBlock{$IFDEF SynUndoDebugBeginEnd}('TCodeContextFrm.CompleteParameters'){$ENDIF};
  end;
end;

var
  SrcEdit: Tfdbm_SynEditorFrame;
  BracketPos: TPoint;
  ASynEdit: TSynEdit;
  Line: string;
  TokenLine, TokenEnd, TokenStart: LongInt;
  LastTokenLine, LastTokenEnd: LongInt;
  BracketLevel: Integer;
  ParameterIndex: Integer;
  Token: String;
  LastToken: String;
  NeedComma: Boolean;
begin
  SrcEdit:=FCodeContexts.EditorFrame;
  if (SrcEdit=nil) {or (SrcEdit.CodeToolsBuffer<>ProcNameCodeXYPos.Code)} then
    exit;
  BracketPos:=Point(ParamListBracketOpenCodeXYPos.X,
                    ParamListBracketOpenCodeXYPos.Y);
  // find out, if cursor is in procedure call and where
  ASynEdit:=SrcEdit.TextEditor as TSynEdit;

  Line:=ASynEdit.Lines[BracketPos.Y-1];
  if (length(Line)<BracketPos.X) or (not (Line[BracketPos.X] in ['(','[']))
  then begin
    // bracket lost -> something changed -> hints became invalid
    exit;
  end;

  // parse the code
  TokenLine:=BracketPos.Y;
  TokenEnd:=BracketPos.X;
  //debugln(['TCodeContextFrm.CompleteParameters START BracketPos=',dbgs(BracketPos)]);
  TokenStart:=TokenEnd;
  BracketLevel:=0;
  ParameterIndex:=-1;
  Token:='';
  repeat
    LastTokenLine:=TokenLine;
    LastTokenEnd:=TokenEnd;
    LastToken:=Token;
    Token:=ReadNextAtom(ASynEdit,TokenLine,TokenEnd,TokenStart);
    //debugln(['TCodeContextFrm.CompleteParameters Token="',Token,'" ParameterIndex=',ParameterIndex]);
    if TokenEnd=TokenStart then break;
    case Token[1] of
    '(','[':
      begin
        inc(BracketLevel);
        if BracketLevel=1 then
          ParameterIndex:=0;
      end;
    ')',']':
      begin
        dec(BracketLevel);
        if BracketLevel=0 then break;
      end;
    ',':
      if BracketLevel=1 then inc(ParameterIndex);
    ';':
      break; // missing close bracket => cursor behind procedure call
    else
      if IsIdentStartChar(Token[1]) then begin
        if CompareIdentifiers(PChar(Token),'end')=0 then
          break;// missing close bracket => cursor behind procedure call
      end;
    end;
  until false;
  NeedComma:=(LastToken<>',') and (LastToken<>'(') and (LastToken<>'[');
  if NeedComma then inc(ParameterIndex);
  //debugln(['TCodeContextFrm.CompleteParameters BracketLevel=',BracketLevel,' NeedComma=',NeedComma,' ParameterIndex=',ParameterIndex]);
  if BracketLevel=0 then
  begin
    // closing bracket found
    //debugln(['TCodeContextFrm.CompleteParameters y=',LastTokenLine,' x=',LastTokenEnd,' ParameterIndex=',ParameterIndex]);
    AddParameters(ASynEdit,LastTokenLine,LastTokenEnd,NeedComma,false,ParameterIndex);
  end
  else if BracketLevel=1 then
  begin
    // missing closing bracket
    AddParameters(ASynEdit,LastTokenLine,LastTokenEnd,NeedComma,true,ParameterIndex);
  end;
end;

procedure TCodeContextFrm.ClearHints;
var
  i:integer;
begin
  for i:=0 to FHints.Count-1 do
    FreeAndNil(Hints[i].CopyAllButton);
  for i:=0 to FHints.Count-1 do
    TObject(FHints[i]).Free;
  FHints.Clear;
end;

procedure TCodeContextFrm.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i: Integer;
begin
  inherited Notification(AComponent, Operation);
  if Operation=opRemove then
  begin
    if FHints<>nil then
      for i:=0 to FHints.Count-1 do
        if Hints[i].CopyAllButton=AComponent then
          Hints[i].CopyAllButton:=nil;
  end;
end;

procedure TCodeContextFrm.WMNCHitTest(var Message: TLMessage);
begin
  Message.Result := HTCLIENT;
end;

constructor TCodeContextFrm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  OnDestroy:=@FormDestroy;
  OnKeyDown:=@FormKeyDown;
  OnUTF8KeyPress:=@FormUTF8KeyPress;
  FormCreate(Self);
end;

destructor TCodeContextFrm.Destroy;
begin
  Application.RemoveAllHandlersOfObject(Self);
  if CodeContextFrm=Self then
    CodeContextFrm:=nil;
  inherited Destroy;
end;

procedure TCodeContextFrm.SetCodeContexts(const ACodeContexts: TCodeHintInfo);//TCodeContextInfo);
var
  Item:TCodeContextItem;
begin
  FillChar(FProcNameCodeXYPos,SizeOf(FProcNameCodeXYPos),0);
  FillChar(FParamListBracketOpenCodeXYPos,SizeOf(FParamListBracketOpenCodeXYPos),0);

//  if ACodeContexts<>nil then
  begin
    FProcNameCodeXYPos.X:=ACodeContexts.FunctionNamePos.X;
    FProcNameCodeXYPos.Y:=ACodeContexts.FunctionNamePos.Y;
    FParamListBracketOpenCodeXYPos.X:=ACodeContexts.BracketPos.X;
    FParamListBracketOpenCodeXYPos.Y:=ACodeContexts.BracketPos.Y;
(*    if (CodeContexts.ProcNameAtom.StartPos>0) then
    begin
      CodeContexts.Tool.MoveCursorToCleanPos(CodeContexts.ProcNameAtom.StartPos);
      CodeContexts.Tool.CleanPosToCaret(CodeContexts.Tool.CurPos.StartPos, FProcNameCodeXYPos);
      CodeContexts.Tool.ReadNextAtom;// read proc name
      CodeContexts.Tool.ReadNextAtom;// read bracket open
      if CodeContexts.Tool.CurPos.Flag in [cafRoundBracketOpen,cafEdgedBracketOpen] then
      begin
        CodeContexts.Tool.CleanPosToCaret(CodeContexts.Tool.CurPos.StartPos,
                                          FParamListBracketOpenCodeXYPos);
      end;
    end;
*)
  end;

  ClearHints;

  FCodeContexts:=ACodeContexts;
  Caption:=FCodeContexts.HintText;

  Item:=TCodeContextItem.Create;
  Item.Obj:=ACodeContexts.DBObject;
  //Item.Code:=ACodeContexts.HintText;
  Item.Hint:=ACodeContexts.HintText;
  Item.CopyAllButton:=TSpeedButton.Create(Self);
  Item.CopyAllButton.Name:='CopyAllSpeedButton'+IntToStr({i+}1);
  Item.CopyAllButton.OnClick:=@CopyAllBtnClick;
  Item.CopyAllButton.Visible:=false;
  //Item.CopyAllButton.LoadGlyphFromLazarusResource('laz_copy');
  Item.CopyAllButton.Images:=fbManagerMainForm.ImageListMain;
  Item.CopyAllButton.ImageIndex:=24;
  Item.CopyAllButton.Flat:=true;
  Item.CopyAllButton.Parent:=Self;
  FHints.Add(Item);
  if Assigned(FCodeContexts.DBObject) and (FCodeContexts.DBObject.Description<>'') then
  begin
    Item:=TCodeContextItem.Create;
//    Item.Code:=FCodeContexts.DBObject.Description;
    Item.Hint:=FCodeContexts.DBObject.Description;
    FHints.Add(Item);
  end;

  CalculateHintsBounds;
end;

procedure TCodeContextFrm.UpdateHints;
begin
  if not Visible then exit;

end;

procedure TCodeContextFrm.Paint;
begin
  FormPaint(Self);
end;


end.

