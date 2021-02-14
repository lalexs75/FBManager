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

unit ibmSqlUtilsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, DB, uib, uibmetadata, uiblib, fb_ConstUnit, ZClasses,
  ZDbcCache, SQLEngineAbstractUnit, ZDataset;

function TEndTransModeToString(Mode:TEndTransMode):string;

function FieldInMetaListConstr(AFieldName:string; MC:TMetaConstraint):boolean;

function CommentSQLCode(var AText:string; ACommentString:string = sCommentFBMStyle):boolean;
function UnCommentSQLCode(var AText:string):boolean;

procedure FillZParams(AFields:TDBFields; RA: TZRowAccessor; quIns: TZQuery);
implementation
uses Dialogs, ibmSqlTextsUnit, fbmSqlParserUnit, rxdbutils, ZCompatibility,
  ZSysUtils;

function TEndTransModeToString(Mode:TEndTransMode):string;
begin
  case Mode of
    etmCommit : Result := ssqlCommit;
    etmCommitRetaining : Result := ssqlCommitRetaining;
    etmRollback : Result := ssqlRollback;
    etmRollbackRetaining : Result := ssqlRollbackRetaining;
  else
    //etmDefault, etmStayIn
    Result:='';
  end;
end;

function FieldInMetaListConstr(AFieldName: string; MC: TMetaConstraint
  ): boolean;
var
  i:integer;
begin
  Result:=false;
  for i:=0 to MC.FieldsCount-1 do
    if MC.Fields[i].Name = AFieldName then
    begin
      Result:=true;
      exit;
    end;
end;

function CommentSQLCode(var AText: string; ACommentString:string = sCommentFBMStyle): boolean;
var
  FTextLen: Integer;
  P:TSQLParser;
  AP: TParserPosition;
  S: String;
begin
  Result:=false;
  FTextLen:=Length(AText);
  while (FTextLen>0) and ((AText[FTextLen] < #32) or (AText[FTextLen] = ';')) do Dec(FTextLen);
  if (FTextLen < 3) or (CompareText(Copy(AText, FTextLen - 2, 3),'end')<>0) then exit;

  P:=TSQLParser.Create(Copy(AText, 1, FTextLen - 3), nil);
  try
    P.WaitWord('begin');

    while not P.Eof do
    begin
      S:=P.GetNextWord;
      AP:=P.WordPosition;
      if not P.Eof then
      begin
        P.Position:=AP;
        P.InsertText('/*' + ACommentString + ' ');
        Result:=true;
        if P.WaitWord('/*') then
          P.IncPos( - 2);
        P.InsertText(' ' + ACommentString + '*/');
      end;
    end;

    if Result then
      AText := P.SQL + 'end';

  finally
    P.Free;
  end;
end;

function UnCommentSQLCode(var AText: string): boolean;
var
  P:TSQLParser;

procedure DoDeleteEndComment(ACmd:string);
var
  S, S1, S2, S3: String;
  L: Integer;
begin
//  P.CurPos:=P.CurPos - 2;
  P.IncPos(-2);
  P.DeleteText(Length('/*' + ACmd)+1);
  S:=ACmd + '*/';
  while not P.Eof do
  begin
    S2:=P.GetNextWord1([]);
    if S2 = '$$' then
    begin
      L:=P.Position.Position - 2;
      S3:=Copy(P.SQL, L, Length(S));
      if CompareText(S3, S)=0 then
      begin
        P.IncPos(-Length(S2));
        if P.SQL[P.Position.Position-1] = ' ' then
        begin
          P.IncPos(-1);
          S:=' ' + S;
        end;
        P.DeleteText(Length(S));
        break;
      end;
    end;
(*
    if P.WaitWord(ACmd) then
    begin
      L:=P.Position.Position - Length(ACmd);
      S1:=Copy(P.SQL, L, Length(S));
      if Copy(P.SQL, L, Length(S)) = S then
      begin
        //P.CurPos:=P.CurPos - Length(ACmd)-1;
        P.IncPos(-Length(ACmd)-1);
        P.DeleteText(Length(S)+1);
        break;
      end;
    end;
*)
  end;
end;

var
  S: String;
begin
  Result:=false;

  P:=TSQLParser.Create(AText, nil);
  try
    P.WaitWord('begin');
    while not P.Eof do
    begin
      if P.WaitWord('/*') then
      begin
        S:=Copy(P.SQL, P.Position.Position, Length(sCommentFBMStyle));
        if (S = sCommentFBMStyle) then
        begin
          DoDeleteEndComment(sCommentFBMStyle);
          Result:=true;
        end
        else
        begin
          S:=Copy(P.SQL, P.Position.Position, Length(sCommentIBEStyle));
          if (S = sCommentIBEStyle) then
          begin
            DoDeleteEndComment(sCommentIBEStyle);
            Result:=true;
          end
          else
            P.WaitWord('*/');
        end;
      end;
    end;
    if Result then
      AText:=P.SQL;

  finally
    P.Free;
  end;
end;

procedure FillZParams(AFields: TDBFields; RA: TZRowAccessor; quIns: TZQuery);
var
  FD: TDBField;
  F: TField;
  {$IF (ZEOS_MAJOR_VERSION = 7) and  (ZEOS_MINOR_VERSION < 3)}
  {$ELSE}
  ZT: TZTime;
  ZTS: TZTimeStamp;
  ZD: TZDate;
  {$ENDIF}
begin
  for FD in AFields do
  begin
    if FD.FieldPK then
    begin
      F:=quIns.FindField(FD.FieldName);
      if Assigned(F) then
      begin
        if F.DataType in IntegerDataTypes then
          RA.SetInt(F.Index+1, F.AsInteger)
        else
        if F.DataType in StringTypes then
          RA.SetString(F.Index+1, F.AsString)
        else
        if F.DataType = ftTime then
        begin
          {$IF (ZEOS_MAJOR_VERSION = 7) and (ZEOS_MINOR_VERSION < 3)}
          RA.SetTime(F.Index+1, F.AsDateTime)
          {$ELSE}
          DecodeDateTimeToTime(F.AsDateTime, ZT);
          RA.SetTime(F.Index+1, ZT)
          {$ENDIF}
        end
        else
        if F.DataType in [ftDateTime, ftTimeStamp] then
        begin
          {$IF (ZEOS_MAJOR_VERSION = 7) and  (ZEOS_MINOR_VERSION < 3)}
          RA.SetTimestamp(F.Index+1, F.AsDateTime)
          {$ELSE}
          DecodeDateTimeToTimeStamp(F.AsDateTime, ZTS);
          RA.SetTimestamp(F.Index+1, ZTS)
          {$ENDIF}
        end
        else
        if F.DataType = ftDate then
        begin
          {$IF (ZEOS_MAJOR_VERSION = 7) and  (ZEOS_MINOR_VERSION < 3)}
          RA.SetDate(F.Index+1, F.AsDateTime)
          {$ELSE}
          DecodeDateTimeToDate(F.AsDateTime, ZD);
          RA.SetDate(F.Index+1, ZD)
          {$ENDIF}
        end
        else
          raise Exception.CreateFmt('Unknow data type for refresh : %s', [Fieldtypenames[F.DataType]]);
      end;
    end;
  end;

end;

end.

