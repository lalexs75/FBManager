{ Free DB Manager

  Copyright (C) 2005-2019 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fdbmSynAutoCompletionsLists;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, contnrs, SynCompletion;

const
  FRootName = 'CODE_COMPLETIONS';

type

  { TAutoCompletionItem }

  TAutoCompletionItem = class
    KeyStr:string;
    CodeText:string;
    Description:string;
    Enabled:boolean;
    procedure Assign(Item:TAutoCompletionItem);
  end;

var
  AutoCompletionList:TFPObjectList = nil;

procedure FillAutoCompleteItems(Complete:TSynAutoComplete);
function MakeAutoCompletionItem(const Key, Code:string; const Desc: string = ''):TAutoCompletionItem;

procedure LoadCompletionFromFile(AFileName:string);
procedure SaveCompletionToFile(AFileName:string);
procedure SaveCompletionDefFile;
procedure InitStdAutoCompletions;
implementation
uses DOM, XMLWrite, XMLRead, fbmToolsUnit, LCLProc, fbmStrConstUnit;

procedure FillAutoCompleteItems(Complete: TSynAutoComplete);
var
  i:integer;
  R:TAutoCompletionItem;
begin
  if (not Assigned(AutoCompletionList)) or (not Assigned(Complete)) then exit;
  Complete.AutoCompleteList.BeginUpdate;
  Complete.AutoCompleteList.Clear;
  for i:=0 to AutoCompletionList.Count-1 do
  begin
    R:=TAutoCompletionItem(AutoCompletionList[i]);
    Complete.AutoCompleteList.Add(R.KeyStr);
    Complete.AutoCompleteList.Add('='+R.CodeText);
  end;
  Complete.AutoCompleteList.EndUpdate;
end;

function MakeAutoCompletionItem(const Key, Code: string; const Desc: string = ''): TAutoCompletionItem;
begin
  Result:=TAutoCompletionItem.Create;
  Result.KeyStr:=Key;
  Result.CodeText:=Code;
  Result.Enabled:=true;
  Result.Description:=Desc;
end;

procedure LoadCompletionFromFile(AFileName: string);
var
  Doc:TXMLDocument;
  ItemR, Item:TDOMElement;
  Cnt, i:integer;
  R:TAutoCompletionItem;
begin
  AutoCompletionList.Clear;
  ReadXMLFile(Doc, AFileName);
  ItemR:=Doc.FindNode(FRootName) as TDOMElement;
  Cnt:=StrToIntDef(ItemR.GetAttribute('Count'), 0);
  for i:= 0 to Cnt-1 do
  begin
    Item:=TDOMElement(ItemR.FindNode('Item_'+IntToStr(i)));
    if Assigned(Item) then
    begin
      R:=TAutoCompletionItem.Create;
      AutoCompletionList.Add(R);
      R.KeyStr:=Item.GetAttribute('KeyStr');
      R.CodeText:=Item.GetAttribute('CodeText');
      R.Description:=Item.GetAttribute('Description');
      R.Enabled:=StrToBoolDef(Item.GetAttribute('Enabled'), true);
    end;
  end;
  Doc.Free;
end;

procedure SaveCompletionToFile(AFileName: string);
var
  Doc:TXMLDocument;
  ItemR, Item:TDOMElement;
  i:integer;
  R:TAutoCompletionItem;
begin
  Doc := TXMLDocument.Create;
  try
    ItemR:=Doc.CreateElement(FRootName);
    Doc.AppendChild(ItemR);
    ItemR.SetAttribute('Count', IntToStr(AutoCompletionList.Count));
    for i:=0 to AutoCompletionList.Count-1 do
    begin
      R:=TAutoCompletionItem(AutoCompletionList[i]);
      Item:=Doc.CreateElement('Item_'+IntToStr(i));
      Item.SetAttribute('KeyStr', R.KeyStr);
      Item.SetAttribute('CodeText', R.CodeText);
      Item.SetAttribute('Description', R.Description);
      Item.SetAttribute('Enabled', BoolToStr(R.Enabled));
      ItemR.AppendChild(Item);
    end;
    WriteXML(Doc, AFileName);
  finally
    Doc.Free;
  end
end;

procedure SaveCompletionDefFile;
var
  CCIFileName:string;
begin
  CCIFileName:=LocalCfgFolder + sCodeCopletionsFileName;
  SaveCompletionToFile(CCIFileName);
end;

procedure InitStdAutoCompletions;
var
  CCIFileName:string;
begin
  CCIFileName:=LocalCfgFolder + sCodeCopletionsFileName;
  if FileExists(CCIFileName) then
    LoadCompletionFromFile(CCIFileName);

  if AutoCompletionList.Count = 0 then
  begin
    AutoCompletionList.Add(MakeAutoCompletionItem('dcl', 'declare variable |', sSynComDesDeclVar));
    AutoCompletionList.Add(MakeAutoCompletionItem('..', '/* | */'));
    AutoCompletionList.Add(MakeAutoCompletionItem('/*', '/* | */'));
    AutoCompletionList.Add(MakeAutoCompletionItem('//', '/* | */'));
    AutoCompletionList.Add(MakeAutoCompletionItem('begin', 'begin'#13#10'  |'#13#10'end'));
    AutoCompletionList.Add(MakeAutoCompletionItem('bw', 'between | and'));
    AutoCompletionList.Add(MakeAutoCompletionItem('ct', 'count(|)'));
    AutoCompletionList.Add(MakeAutoCompletionItem('vc', 'varchar(|)'));
    AutoCompletionList.Add(MakeAutoCompletionItem('ut', 'update #'#13#10'set'#13#10'  |'#13#10'where ()'));
    AutoCompletionList.Add(MakeAutoCompletionItem('st', 'select | from #'#13#10'where ()'));
    AutoCompletionList.Add(MakeAutoCompletionItem('ife', 'if (|) then /* if statement at */'#13#10'begin'#13#10#13#10'end'#13#10'else'#13#10'begin'#13#10#13#10'end/* end if statement */'));
    AutoCompletionList.Add(MakeAutoCompletionItem('if', 'if (|) then'));
    AutoCompletionList.Add(MakeAutoCompletionItem('crdm', 'create domain # |;', sSynComDesCreateDomain));
    AutoCompletionList.Add(MakeAutoCompletionItem('ep', 'execute procedure |;', sSynComDesExecProc));
    AutoCompletionList.Add(MakeAutoCompletionItem('fk', 'foreign key (|) references ;', sSynComDesForignKey));
    AutoCompletionList.Add(MakeAutoCompletionItem('fors', 'for /* Iterate for # table */'#13#10'  select'#13#10'    |'#13#10'  from'#13#10'    #'#13#10'  where'#13#10'    ()'#13#10'  into'#13#10'do'#13#10'begin'#13#10#13#10'end /* for # table */',  sSynComDesIterateTable));
    AutoCompletionList.Add(MakeAutoCompletionItem('gpr', 'group by |'#13#10, sSynComDesGroupBy));
    AutoCompletionList.Add(MakeAutoCompletionItem('grant', 'grant select, delete, insert, update on # to |'#13#10, sSynComDesGrantAll));
    AutoCompletionList.Add(MakeAutoCompletionItem('it', 'insert into # (|)'#13#10'values ()'#13#10, sSynComDesInsTable));
    AutoCompletionList.Add(MakeAutoCompletionItem('eb', 'execute block'#13#10'as'#13#10'begin'#13#10'  |'#13#10'end'#13#10, sSynComDesExecBlock));
    AutoCompletionList.Add(MakeAutoCompletionItem('dcli', 'declare variable | integer;'#13#10, sSynComDesDeclIntVar));
    AutoCompletionList.Add(MakeAutoCompletionItem('dclt', 'declare variable | date;'#13#10, sSynComDesDeclDateVar));
  end;
end;

{ TAutoCompletionItem }

procedure TAutoCompletionItem.Assign(Item: TAutoCompletionItem);
begin
  if not Assigned(Item) then exit;
  KeyStr:=Item.KeyStr;
  CodeText:=Item.CodeText;
  Description:=Item.Description;
  Enabled:=Item.Enabled;
end;

initialization
  AutoCompletionList:=TFPObjectList.Create(true);
finalization
  FreeAndNil(AutoCompletionList);
end.

