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

unit mssql_ObjectsList;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineCommonTypesUnit;


procedure MsSQLFillFieldTypes(Items: TDBMSFieldTypeList);
implementation
uses DB, fbmStrConstUnit;

procedure MsSQLFillFieldTypes(Items: TDBMSFieldTypeList);
begin
  //Точные числа
  Items.Add('bigint', 0, false, false, ftLargeint, '', '', tgNumericTypes);
  Items.Add('int', 0, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('smallint', 0, false, false, ftSmallint, '', '', tgNumericTypes);
  Items.Add('tinyint', 0, false, false, ftInteger, '', '', tgNumericTypes);
  Items.Add('numeric', 0, true, true, ftFloat, 'decimal', '', tgNumericTypes);

  Items.Add('bit', 0, false, false, ftInteger, '', '', tgNumericTypes);

  Items.Add('smallmoney', 0, false, false, ftCurrency, '', '', tgMonetaryTypes);
  Items.Add('money', 0, false, false, ftCurrency, '', '', tgMonetaryTypes);

  //Приблизительные числа
  Items.Add('float', 0, false, false, ftFloat, '', '', tgNumericTypes);
  Items.Add('real', 0, false, false, ftFloat, '', '', tgNumericTypes);

  //Дата и время
  Items.Add('date', 0, false, false, ftDate, '', '', tgDateTimeTypes);
  Items.Add('datetimeoffset', 0, false, false, ftTimeStamp, '', '', tgDateTimeTypes);
  Items.Add('datetime2', 0, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add('smalldatetime', 0, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add('datetime', 0, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add('time', 0, false, false, ftTime, '', '', tgDateTimeTypes);

  //Символьные строки

  Items.Add('char', 0, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('varchar', 0, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('text', 0, true, false, ftString, '', '', tgCharacterTypes);

  //Символьные строки в Юникоде
  Items.Add('nchar', 0, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('nvarchar', 0, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add('ntext', 0, true, false, ftString, '', '', tgCharacterTypes);

(*
  Двоичные данные

  binary

  varbinary

  image
  Прочие типы данных

  курсор

  rowversion

  hierarchyid

  uniqueidentifier

  sql_variant

  xml

  Типы пространственной геометрии

  Типы пространственной географии

  table
  *)
end;
end.

