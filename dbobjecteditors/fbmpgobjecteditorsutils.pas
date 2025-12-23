{ Free DB Manager

  Copyright (C) 2005-2025 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbmPgObjectEditorsUtils;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, DB, fdmAbstractEditorUnit, fbmCompillerMessagesUnit, fbmPGLocalVarsEditorFrameUnit;

procedure PGPreParsePlSQL(AOwner:TEditorPage;
    AEditorSQL:string;
    ALocalVars:TfbmPGLocalVarsEditorFrame; AParDS:TDataSet; AParName, AParType, AParIOType:TField);
implementation
uses fbmSqlParserUnit, SQLEngineCommonTypesUnit, sqlObjects;

procedure PGPreParsePlSQL(AOwner: TEditorPage; AEditorSQL: string;
  ALocalVars: TfbmPGLocalVarsEditorFrame; AParDS: TDataSet; AParName, AParType,
  AParIOType: TField);
var
  sLV: TStringList;
  B: TBookMark;
  P: TSQLParser;
  S: String;
  i: Integer;
  J: TSPVarType;
begin
  sLV:=TStringList.Create;
  sLV.Sorted:=true;
  sLV.CaseSensitive:=false;

  ALocalVars.DoPreParse(sLV, AOwner);


  if Assigned(AParDS) then
  begin
    AParDS.DisableControls;
    B:=AParDS.Bookmark;
    AParDS.First;
    while not AParDS.EOF do
    begin
      sLV.AddObject(AParName.AsString, TObject(PtrInt(AParIOType.AsInteger)));

      if (TSQLParser.WordType(nil, AParName.AsString, nil) <> stIdentificator) then
        AOwner.ShowMsg(ppParamNameNotDefined, AParName.AsString, 2, AParDS.RecNo);

      if (Trim(AParType.AsString) = '') then
        AOwner.ShowMsg(ppParamTypeNotDefined, AParType.AsString, 2, AParDS.RecNo);

      AParDS.Next;
    end;
    AParDS.Bookmark:=B;
    AParDS.EnableControls;
  end;


//  if (not IsValidIdent(rxLocalVarsVAR_NAME.AsString)) or (Trim(rxLocalVarsVAR_TYPE.AsString) = '') then

  P:=TSQLParser.Create(Trim(AEditorSQL), AOwner.DBObject.OwnerDB);
  while not P.Eof do
  begin
    S:=P.GetNextWord;
    if S<>'' then
    begin
      if P.WordType(nil, S, nil) = stIdentificator then
      begin
        i:=sLV.IndexOf(S);
        if i > -1 then
          sLV.Delete(i);
      end;
    end;
  end;
  P.Free;

  for i:=0 to sLV.Count-1 do
  begin
    S:=sLV[i];
    J:=TSPVarType(IntPtr(sLV.Objects[i]));

    case J of
      spvtLocal:AOwner.ShowMsg(ppLocalVarNotUsed, S, -1, -1);
      spvtInOut,
      spvtVariadic,
      spvtInput:AOwner.ShowMsg(ppInParamNotUsed,  S, -1, -1);
      spvtTable,
      spvtOutput:AOwner.ShowMsg(ppOutParamNotUsed, S, -1, -1);
    else
      AOwner.ShowMsg(ppNone, S, -1, -1);
    end;
  end;
  sLV.Free;
end;

end.

