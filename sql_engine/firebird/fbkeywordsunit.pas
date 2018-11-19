{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

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

unit fbKeywordsUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineCommonTypesUnit;

const
  CountKeyWords      = 266;
  CountKeyFunctions  = 82;
  CountKeyTypes      = 13;


type
{  TKeywordRecord = record
    Key:string;
  end;}

  TKeywordRecords = array [0..CountKeyWords-1] of TKeyWordRecord;
  TKeyFunctionRecords = array [0..CountKeyFunctions-1] of TKeywordRecord;
  TKeyTypesRecords = array [0..CountKeyTypes-1] of TKeywordRecord;

function CreateFBKeyWords:TKeywordList;
function CreateFBKeyFunctions:TKeywordList;
function CreateFBKeyTypes:TKeywordList;
implementation

const
  FBKeyTypes : TKeyTypesRecords =
    (
     (Key:'blob'; SQLToken:stNone),
     (Key:'char'; SQLToken:stNone),
     (Key:'character'; SQLToken:stNone),
     (Key:'date'; SQLToken:stNone),
     (Key:'decimal'; SQLToken:stNone),
     (Key:'double'; SQLToken:stNone),
     (Key:'float'; SQLToken:stNone),
     (Key:'integer'; SQLToken:stNone),
     (Key:'numeric'; SQLToken:stNone),
     (Key:'smallint'; SQLToken:stNone),
     (Key:'time'; SQLToken:stNone),
     (Key:'timestamp'; SQLToken:stNone),
     (Key:'varchar'; SQLToken:stNone)
    );

const
  FBKeywords : TKeywordRecords =
    (
     (Key:'active'; SQLToken:stNone),
     (Key:'add'; SQLToken:stNone),
     (Key:'after'; SQLToken:stNone),
     (Key:'all'; SQLToken:stNone),
//     (Key:'alter'; SQLToken:stAlter),
     (Key:'alter'; SQLToken:stNone),
     (Key:'and'; SQLToken:stNone),
     (Key:'any'; SQLToken:stNone),
     (Key:'as'; SQLToken:stNone),
     (Key:'asc'; SQLToken:stNone),
     (Key:'ascending'; SQLToken:stNone),
     (Key:'at'; SQLToken:stNone),
     (Key:'auto'; SQLToken:stNone),
     (Key:'autoddl'; SQLToken:stNone),
     (Key:'based'; SQLToken:stNone),
     (Key:'basename'; SQLToken:stNone),
     (Key:'base_name'; SQLToken:stNone),
     (Key:'before'; SQLToken:stNone),
     (Key:'begin'; SQLToken:stNone),
     (Key:'between'; SQLToken:stNone),
     (Key:'blobedit'; SQLToken:stNone),
     (Key:'block'; SQLToken:stNone),
     (Key:'both'; SQLToken:stNone),
     (Key:'buffer'; SQLToken:stNone),
     (Key:'by'; SQLToken:stNone),
     (Key:'cache'; SQLToken:stNone),
     (Key:'case'; SQLToken:stNone),
     (Key:'character_length'; SQLToken:stNone),
     (Key:'char_length'; SQLToken:stNone),
     (Key:'check'; SQLToken:stNone),
     (Key:'check_point_len'; SQLToken:stNone),
     (Key:'check_point_length'; SQLToken:stNone),
     (Key:'close'; SQLToken:stNone),
     (Key:'collate'; SQLToken:stNone),
     (Key:'collation'; SQLToken:stNone),
     (Key:'column'; SQLToken:stNone),
     (Key:'commit'; SQLToken:stNone),
     (Key:'commited'; SQLToken:stNone),
     (Key:'compiletime'; SQLToken:stNone),
     (Key:'computed'; SQLToken:stNone),
     (Key:'conditional'; SQLToken:stNone),
     (Key:'connect'; SQLToken:stNone),
     (Key:'constraint'; SQLToken:stNone),
     (Key:'containing'; SQLToken:stNone),
     (Key:'continue'; SQLToken:stNone),
     (Key:'create'; SQLToken:stNone),
     (Key:'cross'; SQLToken:stNone),
     (Key:'current'; SQLToken:stNone),
     (Key:'current_date'; SQLToken:stNone),
     (Key:'current_time'; SQLToken:stNone),
     (Key:'current_timestamp'; SQLToken:stNone),
     (Key:'current_user'; SQLToken:stNone),
     (Key:'cursor'; SQLToken:stNone),
     (Key:'database'; SQLToken:stNone),
     (Key:'day'; SQLToken:stNone),
     (Key:'db_key'; SQLToken:stNone),
     (Key:'debug'; SQLToken:stNone),
     (Key:'dec'; SQLToken:stNone),
     (Key:'declare'; SQLToken:stNone),
     (Key:'default'; SQLToken:stNone),
     (Key:'delete'; SQLToken:stNone),
     (Key:'desc'; SQLToken:stNone),
     (Key:'descending'; SQLToken:stNone),
     (Key:'describe'; SQLToken:stNone),
     (Key:'descriptor'; SQLToken:stNone),
     (Key:'disconnect'; SQLToken:stNone),
     (Key:'distinct'; SQLToken:stNone),
     (Key:'do'; SQLToken:stNone),
     (Key:'domain'; SQLToken:stNone),
     (Key:'drop'; SQLToken:stNone),
     (Key:'echo'; SQLToken:stNone),
     (Key:'edit'; SQLToken:stNone),
     (Key:'else'; SQLToken:stNone),
     (Key:'end'; SQLToken:stNone),
     (Key:'entry_point'; SQLToken:stNone),
     (Key:'escape'; SQLToken:stNone),
     (Key:'event'; SQLToken:stNone),
     (Key:'exception'; SQLToken:stNone),
     (Key:'execute'; SQLToken:stNone),
     (Key:'exists'; SQLToken:stNone),
     (Key:'exit'; SQLToken:stNone),
     (Key:'external'; SQLToken:stNone),
     (Key:'extract'; SQLToken:stNone),
     (Key:'fetch'; SQLToken:stNone),
     (Key:'file'; SQLToken:stNone),
     (Key:'filter'; SQLToken:stNone),
     (Key:'first'; SQLToken:stNone),
     (Key:'for'; SQLToken:stNone),
     (Key:'foreign'; SQLToken:stNone),
     (Key:'found'; SQLToken:stNone),
     (Key:'from'; SQLToken:stNone),
     (Key:'full'; SQLToken:stNone),
     (Key:'function'; SQLToken:stNone),
     (Key:'gdscode'; SQLToken:stNone),
     (Key:'generator'; SQLToken:stNone),
     (Key:'global'; SQLToken:stNone),
     (Key:'goto'; SQLToken:stNone),
     (Key:'grant'; SQLToken:stNone),
     (Key:'group'; SQLToken:stNone),
     (Key:'group_commit_wait'; SQLToken:stNone),
     (Key:'group_commit_wait_time'; SQLToken:stNone),
     (Key:'having'; SQLToken:stNone),
     (Key:'help'; SQLToken:stNone),
     (Key:'hour'; SQLToken:stNone),
     (Key:'if'; SQLToken:stNone),
     (Key:'immediate'; SQLToken:stNone),
     (Key:'in'; SQLToken:stNone),
     (Key:'inactive'; SQLToken:stNone),
     (Key:'index'; SQLToken:stNone),
     (Key:'indicator'; SQLToken:stNone),
     (Key:'init'; SQLToken:stNone),
     (Key:'inner'; SQLToken:stNone),
     (Key:'input'; SQLToken:stNone),
     (Key:'input_type'; SQLToken:stNone),
     (Key:'insensitive'; SQLToken:stNone),
     (Key:'insert'; SQLToken:stNone),
     (Key:'int'; SQLToken:stNone),
     (Key:'into'; SQLToken:stNone),
     (Key:'is'; SQLToken:stNone),
     (Key:'isolation'; SQLToken:stNone),
     (Key:'isql'; SQLToken:stNone),
     (Key:'join'; SQLToken:stNone),
     (Key:'key'; SQLToken:stNone),
     (Key:'lc_messages'; SQLToken:stNone),
     (Key:'lc_type'; SQLToken:stNone),
     (Key:'leading'; SQLToken:stNone),
     (Key:'left'; SQLToken:stNone),
     (Key:'length'; SQLToken:stNone),
     (Key:'lev'; SQLToken:stNone),
     (Key:'level'; SQLToken:stNone),
     (Key:'like'; SQLToken:stNone),
     (Key:'logfile'; SQLToken:stNone),
     (Key:'log_buffer_size'; SQLToken:stNone),
     (Key:'log_buf_size'; SQLToken:stNone),
     (Key:'long'; SQLToken:stNone),
     (Key:'manual'; SQLToken:stNone),
     (Key:'maximum'; SQLToken:stNone),
     (Key:'maximum_segment'; SQLToken:stNone),
     (Key:'max_segment'; SQLToken:stNone),
     (Key:'merge'; SQLToken:stNone),
     (Key:'message'; SQLToken:stNone),
     (Key:'minimum'; SQLToken:stNone),
     (Key:'minute'; SQLToken:stNone),
     (Key:'module_name'; SQLToken:stNone),
     (Key:'month'; SQLToken:stNone),
     (Key:'names'; SQLToken:stNone),
     (Key:'national'; SQLToken:stNone),
     (Key:'natural'; SQLToken:stNone),
     (Key:'nchar'; SQLToken:stNone),
     (Key:'no'; SQLToken:stNone),
     (Key:'noauto'; SQLToken:stNone),
     (Key:'not'; SQLToken:stNone),
     (Key:'null'; SQLToken:stNone),
     (Key:'num_log_buffers'; SQLToken:stNone),
     (Key:'num_log_buffs'; SQLToken:stNone),
     (Key:'octet_length'; SQLToken:stNone),
     (Key:'of'; SQLToken:stNone),
     (Key:'on'; SQLToken:stNone),
     (Key:'only'; SQLToken:stNone),
     (Key:'open'; SQLToken:stNone),
     (Key:'option'; SQLToken:stNone),
     (Key:'or'; SQLToken:stNone),
     (Key:'order'; SQLToken:stNone),
     (Key:'outer'; SQLToken:stNone),
     (Key:'output'; SQLToken:stNone),
     (Key:'output_type'; SQLToken:stNone),
     (Key:'overflow'; SQLToken:stNone),
     (Key:'page'; SQLToken:stNone),
     (Key:'pagelength'; SQLToken:stNone),
     (Key:'pages'; SQLToken:stNone),
     (Key:'page_size'; SQLToken:stNone),
     (Key:'parameter'; SQLToken:stNone),
     (Key:'password'; SQLToken:stNone),
     (Key:'plan'; SQLToken:stNone),
     (Key:'position'; SQLToken:stNone),
     (Key:'post_event'; SQLToken:stNone),
     (Key:'precision'; SQLToken:stNone),
     (Key:'prepare'; SQLToken:stNone),
     (Key:'primary'; SQLToken:stNone),
     (Key:'privileges'; SQLToken:stNone),
     (Key:'procedure'; SQLToken:stNone),
     (Key:'protected'; SQLToken:stNone),
     (Key:'public'; SQLToken:stNone),
     (Key:'quit'; SQLToken:stNone),
     (Key:'raw_partitions'; SQLToken:stNone),
     (Key:'read'; SQLToken:stNone),
     (Key:'real'; SQLToken:stNone),
     (Key:'record_version'; SQLToken:stNone),
     (Key:'recreate'; SQLToken:stNone),
     (Key:'references'; SQLToken:stNone),
     (Key:'release'; SQLToken:stNone),
     (Key:'reserv'; SQLToken:stNone),
     (Key:'reserving'; SQLToken:stNone),
     (Key:'retain'; SQLToken:stNone),
     (Key:'return'; SQLToken:stNone),
     (Key:'returning'; SQLToken:stNone),
     (Key:'returning_values'; SQLToken:stNone),
     (Key:'returns'; SQLToken:stNone),
     (Key:'revoke'; SQLToken:stNone),
     (Key:'right'; SQLToken:stNone),
     (Key:'rollback'; SQLToken:stNone),
     (Key:'rows'; SQLToken:stNone),
     (Key:'row_count'; SQLToken:stNone),
     (Key:'runtime'; SQLToken:stNone),
     (Key:'schema'; SQLToken:stNone),
     (Key:'second'; SQLToken:stNone),
     (Key:'segment'; SQLToken:stNone),
     (Key:'select'; SQLToken:stNone),
     (Key:'set'; SQLToken:stNone),
     (Key:'shadow'; SQLToken:stNone),
     (Key:'shared'; SQLToken:stNone),
     (Key:'shell'; SQLToken:stNone),
     (Key:'show'; SQLToken:stNone),
     (Key:'singular'; SQLToken:stNone),
     (Key:'size'; SQLToken:stNone),
     (Key:'snapshot'; SQLToken:stNone),
     (Key:'some'; SQLToken:stNone),
     (Key:'sort'; SQLToken:stNone),
     (Key:'sql'; SQLToken:stNone),
     (Key:'sqlcode'; SQLToken:stNone),
     (Key:'sqlerror'; SQLToken:stNone),
     (Key:'sqlwarning'; SQLToken:stNone),
     (Key:'stability'; SQLToken:stNone),
     (Key:'start'; SQLToken:stNone),
     (Key:'starting'; SQLToken:stNone),
     (Key:'starts'; SQLToken:stNone),
     (Key:'statement'; SQLToken:stNone),
     (Key:'static'; SQLToken:stNone),
     (Key:'statistics'; SQLToken:stNone),
     (Key:'sub_type'; SQLToken:stNone),
     (Key:'suspend'; SQLToken:stNone),
     (Key:'table'; SQLToken:stNone),
     (Key:'terminator'; SQLToken:stNone),
     (Key:'then'; SQLToken:stNone),
     (Key:'to'; SQLToken:stNone),
     (Key:'trailing'; SQLToken:stNone),
     (Key:'transaction'; SQLToken:stNone),
     (Key:'translate'; SQLToken:stNone),
     (Key:'translation'; SQLToken:stNone),
     (Key:'trigger'; SQLToken:stNone),
     (Key:'trim'; SQLToken:stNone),
     (Key:'type'; SQLToken:stNone),
     (Key:'uncommitted'; SQLToken:stNone),
     (Key:'union'; SQLToken:stNone),
     (Key:'unique'; SQLToken:stNone),
     (Key:'update'; SQLToken:stNone),
     (Key:'user'; SQLToken:stNone),
     (Key:'using'; SQLToken:stNone),
     (Key:'value'; SQLToken:stNone),
     (Key:'values'; SQLToken:stNone),
     (Key:'variable'; SQLToken:stNone),
     (Key:'varying'; SQLToken:stNone),
     (Key:'version'; SQLToken:stNone),
     (Key:'view'; SQLToken:stNone),
     (Key:'wait'; SQLToken:stNone),
     (Key:'weekday'; SQLToken:stNone),
     (Key:'when'; SQLToken:stNone),
     (Key:'whenever'; SQLToken:stNone),
     (Key:'where'; SQLToken:stNone),
     (Key:'while'; SQLToken:stNone),
     (Key:'with'; SQLToken:stNone),
     (Key:'work'; SQLToken:stNone),
     (Key:'write'; SQLToken:stNone),
     (Key:'year'; SQLToken:stNone),
     (Key:'yearday'; SQLToken:stNone),
     (Key:'sequence'; SQLToken:stNone),
     (Key:'restart'; SQLToken:stNone)
     );

  FBFunctions : TKeyFunctionRecords =
    (
     (Key:'abs'; SQLToken:stNone),
     (Key:'accent'; SQLToken:stNone),
     (Key:'acos'; SQLToken:stNone),
     (Key:'always'; SQLToken:stNone),
     (Key:'ascii_char'; SQLToken:stNone),
     (Key:'ascii_val'; SQLToken:stNone),
     (Key:'asin'; SQLToken:stNone),
     (Key:'atan'; SQLToken:stNone),
     (Key:'atan2'; SQLToken:stNone),
     (Key:'avg'; SQLToken:stNone),
     (Key:'backup'; SQLToken:stNone),
     (Key:'bin_and'; SQLToken:stNone),
     (Key:'bin_or'; SQLToken:stNone),
     (Key:'bin_shl'; SQLToken:stNone),
     (Key:'bin_shr'; SQLToken:stNone),
     (Key:'bin_xor'; SQLToken:stNone),
     (Key:'bit_length'; SQLToken:stNone),
     (Key:'cast'; SQLToken:stNone),
     (Key:'ceil'; SQLToken:stNone),
     (Key:'character_length'; SQLToken:stNone),
     (Key:'char_length'; SQLToken:stNone),
     (Key:'coalesce'; SQLToken:stNone),
     (Key:'collation'; SQLToken:stNone),
     (Key:'comment'; SQLToken:stNone),
     (Key:'connect'; SQLToken:stNone),
     (Key:'cos'; SQLToken:stNone),
     (Key:'cosh'; SQLToken:stNone),
     (Key:'cot'; SQLToken:stNone),
     (Key:'count'; SQLToken:stNone),
     (Key:'dateadd'; SQLToken:stNone),
     (Key:'datediff'; SQLToken:stNone),
     (Key:'decode'; SQLToken:stNone),
     (Key:'difference'; SQLToken:stNone),
     (Key:'disconnect'; SQLToken:stNone),
     (Key:'exp'; SQLToken:stNone),
     (Key:'floor'; SQLToken:stNone),
     (Key:'generated'; SQLToken:stNone),
     (Key:'gen_id'; SQLToken:stNone),
     (Key:'gen_uuid'; SQLToken:stNone),
     (Key:'hash'; SQLToken:stNone),
     (Key:'iif'; SQLToken:stNone),
     (Key:'list'; SQLToken:stNone),
     (Key:'ln'; SQLToken:stNone),
     (Key:'log'; SQLToken:stNone),
     (Key:'log10'; SQLToken:stNone),
     (Key:'lower'; SQLToken:stNone),
     (Key:'lpad'; SQLToken:stNone),
     (Key:'matched'; SQLToken:stNone),
     (Key:'matching'; SQLToken:stNone),
     (Key:'max'; SQLToken:stNone),
     (Key:'maxvalue'; SQLToken:stNone),
     (Key:'millisecond'; SQLToken:stNone),
     (Key:'min'; SQLToken:stNone),
     (Key:'minvalue'; SQLToken:stNone),
     (Key:'mod'; SQLToken:stNone),
     (Key:'next'; SQLToken:stNone),
     (Key:'octet_length'; SQLToken:stNone),
     (Key:'overlay'; SQLToken:stNone),
     (Key:'pad'; SQLToken:stNone),
     (Key:'pi'; SQLToken:stNone),
     (Key:'placing'; SQLToken:stNone),
     (Key:'power'; SQLToken:stNone),
     (Key:'preserve'; SQLToken:stNone),
     (Key:'rand'; SQLToken:stNone),
     (Key:'replace'; SQLToken:stNone),
     (Key:'reverse'; SQLToken:stNone),
     (Key:'round'; SQLToken:stNone),
     (Key:'rpad'; SQLToken:stNone),
     (Key:'scalar_array'; SQLToken:stNone),
//     (Key:'sequence'; SQLToken:stNone),
     (Key:'sign'; SQLToken:stNone),
     (Key:'sin'; SQLToken:stNone),
     (Key:'sinh'; SQLToken:stNone),
     (Key:'space'; SQLToken:stNone),
     (Key:'sqrt'; SQLToken:stNone),
     (Key:'sum'; SQLToken:stNone),
     (Key:'tan'; SQLToken:stNone),
     (Key:'tanh'; SQLToken:stNone),
     (Key:'temporary'; SQLToken:stNone),
     (Key:'trim'; SQLToken:stNone),
     (Key:'trunc'; SQLToken:stNone),
     (Key:'upper'; SQLToken:stNone),
     (Key:'week'; SQLToken:stNone)
     );

function CreateFBKeyWords: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktKeyword);
  for i:= 0 to CountKeyWords-1 do
    Result.Add(FBKeywords[i].Key, FBKeywords[i].SQLToken);

  for i:= 0 to CountKeyTypes-1 do
    Result.Add(FBKeyTypes[i].Key, stStdKeyType);
end;

function CreateFBKeyFunctions: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktFunction);
  for i:= 0 to CountKeyFunctions-1 do
    Result.Add(FBFunctions[i].Key, stIdentificator);
end;

function CreateFBKeyTypes: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktStdTypes);
  for i:= 0 to CountKeyTypes-1 do
    Result.Add(FBKeyTypes[i].Key, stStdKeyType);
end;

end.

