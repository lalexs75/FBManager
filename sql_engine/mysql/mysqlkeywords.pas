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
unit MySQLKeywords;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, SQLEngineCommonTypesUnit, db;

const
  CountKeyWords      = 264;
  CountKeyFunctions  = 84;
  CountKeyTypes      = 13;


type
  TKeywordRecords = array [0..CountKeyWords-1] of TKeyWordRecord;
  TKeyFunctionRecords = array [0..CountKeyFunctions-1] of TKeywordRecord;
  TKeyTypesRecords = array [0..CountKeyTypes-1] of TKeywordRecord;

function CreateMyKeyWords:TKeywordList;
function CreateMyKeyFunctions:TKeywordList;
function CreateMyKeyTypes:TKeywordList;

procedure FillMyFieldTypes(Items:TDBMSFieldTypeList);
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
     (Key:'yearday'; SQLToken:stNone)

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
     (Key:'restart'; SQLToken:stNone),
     (Key:'reverse'; SQLToken:stNone),
     (Key:'round'; SQLToken:stNone),
     (Key:'rpad'; SQLToken:stNone),
     (Key:'scalar_array'; SQLToken:stNone),
     (Key:'sequence'; SQLToken:stNone),
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
{
ABS()	Return the absolute value
ACOS()	Return the arc cosine
ADDDATE()	Add time values (intervals) to a date value
ADDTIME()	Add time
AES_DECRYPT()	Decrypt using AES
AES_ENCRYPT()	Encrypt using AES
AND, &&	Logical AND
ASCII()	Return numeric value of left-most character
ASIN()	Return the arc sine
=	Assign a value (as part of a SET statement, or as part of the SET clause in an UPDATE statement)
:=	Assign a value
ATAN2(), ATAN()	Return the arc tangent of the two arguments
ATAN()	Return the arc tangent
AVG()	Return the average value of the argument
BENCHMARK()	Repeatedly execute an expression
BETWEEN ... AND ... 	Check whether a value is within a range of values
BIN()	Return a string containing binary representation of a number
BINARY	Cast a string to a binary string
BIT_AND()	Return bitwise and
BIT_COUNT()	Return the number of bits that are set
BIT_LENGTH()	Return length of argument in bits
BIT_OR()	Return bitwise or
BIT_XOR()	Return bitwise xor
&	Bitwise AND
~	Invert bits
|	Bitwise OR
^	Bitwise XOR
CASE	Case operator
CAST()	Cast a value as a certain type
CEIL()	Return the smallest integer value not less than the argument
CEILING()	Return the smallest integer value not less than the argument
CHAR_LENGTH()	Return number of characters in argument
CHAR()	Return the character for each integer passed
CHARACTER_LENGTH()	A synonym for CHAR_LENGTH()
CHARSET()	Return the character set of the argument
COALESCE()	Return the first non-NULL argument
COERCIBILITY()	Return the collation coercibility value of the string argument
COLLATION()	Return the collation of the string argument
COMPRESS()	Return result as a binary string
CONCAT_WS()	Return concatenate with separator
CONCAT()	Return concatenated string
CONNECTION_ID()	Return the connection ID (thread ID) for the connection
CONV()	Convert numbers between different number bases
CONVERT_TZ()	Convert from one timezone to another
CONVERT()	Cast a value as a certain type
COS()	Return the cosine
COT()	Return the cotangent
COUNT(DISTINCT)	Return the count of a number of different values
COUNT()	Return a count of the number of rows returned
CRC32()	Compute a cyclic redundancy check value
CURDATE()	Return the current date
CURRENT_DATE(), CURRENT_DATE	Synonyms for CURDATE()
CURRENT_TIME(), CURRENT_TIME	Synonyms for CURTIME()
CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP	Synonyms for NOW()
CURRENT_USER(), CURRENT_USER	The authenticated user name and host name
CURTIME()	Return the current time
DATABASE()	Return the default (current) database name
DATE_ADD()	Add time values (intervals) to a date value
DATE_FORMAT()	Format date as specified
DATE_SUB()	Subtract a time value (interval) from a date
DATE()	Extract the date part of a date or datetime expression
DATEDIFF()	Subtract two dates
DAY()	Synonym for DAYOFMONTH()
DAYNAME()	Return the name of the weekday
DAYOFMONTH()	Return the day of the month (0-31)
DAYOFWEEK()	Return the weekday index of the argument
DAYOFYEAR()	Return the day of the year (1-366)
DECODE()	Decodes a string encrypted using ENCODE()
DEFAULT()	Return the default value for a table column
DEGREES()	Convert radians to degrees
DES_DECRYPT()	Decrypt a string
DES_ENCRYPT()	Encrypt a string
DIV	Integer division
/	Division operator
ELT()	Return string at index number
ENCODE()	Encode a string
ENCRYPT()	Encrypt a string
<=>	NULL-safe equal to operator
=	Equal operator
EXP()	Raise to the power of
EXPORT_SET()	Return a string such that for every bit set in the value bits, you get an on string and for every unset bit, you get an off string
EXTRACT()	Extract part of a date
FIELD()	Return the index (position) of the first argument in the subsequent arguments
FIND_IN_SET()	Return the index position of the first argument within the second argument
FLOOR()	Return the largest integer value not greater than the argument
FORMAT()	Return a number formatted to specified number of decimal places
FOUND_ROWS()	For a SELECT with a LIMIT clause, the number of rows that would be returned were there no LIMIT clause
FROM_DAYS()	Convert a day number to a date
FROM_UNIXTIME()	Format UNIX timestamp as a date
GET_FORMAT()	Return a date format string
GET_LOCK()	Get a named lock
>=	Greater than or equal operator
>	Greater than operator
GREATEST()	Return the largest argument
GROUP_CONCAT()	Return a concatenated string
HEX()	Return a hexadecimal representation of a decimal or string value
HOUR()	Extract the hour
IF()	If/else construct
IFNULL()	Null if/else construct
IN()	Check whether a value is within a set of values
INET_ATON()	Return the numeric value of an IP address
INET_NTOA()	Return the IP address from a numeric value
INSERT()	Insert a substring at the specified position up to the specified number of characters
INSTR()	Return the index of the first occurrence of substring
INTERVAL()	Return the index of the argument that is less than the first argument
IS_FREE_LOCK()	Checks whether the named lock is free
IS NOT NULL	NOT NULL value test
IS NOT	Test a value against a boolean
IS NULL	NULL value test
IS_USED_LOCK()	Checks whether the named lock is in use. Return connection identifier if true.
IS	Test a value against a boolean
ISNULL()	Test whether the argument is NULL
LAST_DAY	Return the last day of the month for the argument
LAST_INSERT_ID()	Value of the AUTOINCREMENT column for the last INSERT
LCASE()	Synonym for LOWER()
LEAST()	Return the smallest argument
<<	Left shift
LEFT()	Return the leftmost number of characters as specified
LENGTH()	Return the length of a string in bytes
<=	Less than or equal operator
<	Less than operator
LIKE	Simple pattern matching
LN()	Return the natural logarithm of the argument
LOAD_FILE()	Load the named file
LOCALTIME(), LOCALTIME	Synonym for NOW()
LOCALTIMESTAMP, LOCALTIMESTAMP()	Synonym for NOW()
LOCATE()	Return the position of the first occurrence of substring
LOG10()	Return the base-10 logarithm of the argument
LOG2()	Return the base-2 logarithm of the argument
LOG()	Return the natural logarithm of the first argument
LOWER()	Return the argument in lowercase
LPAD()	Return the string argument, left-padded with the specified string
LTRIM()	Remove leading spaces
MAKE_SET()	Return a set of comma-separated strings that have the corresponding bit in bits set
MAKEDATE()	Create a date from the year and day of year
MAKETIME	MAKETIME()
MASTER_POS_WAIT()	Block until the slave has read and applied all updates up to the specified position
MATCH	Perform full-text search
MAX()	Return the maximum value
MD5()	Calculate MD5 checksum
MICROSECOND()	Return the microseconds from argument
MID()	Return a substring starting from the specified position
MIN()	Return the minimum value
-	Minus operator
MINUTE()	Return the minute from the argument
MOD()	Return the remainder
% or MOD	Modulo operator
MONTH()	Return the month from the date passed
MONTHNAME()	Return the name of the month
NAME_CONST()	Causes the column to have the given name
NOT BETWEEN ... AND ...	Check whether a value is not within a range of values
!=, <>	Not equal operator
NOT IN()	Check whether a value is not within a set of values
NOT LIKE	Negation of simple pattern matching
NOT REGEXP	Negation of REGEXP
NOT, !	Negates value
NOW()	Return the current date and time
NULLIF()	Return NULL if expr1 = expr2
OCT()	Return a string containing octal representation of a number
OCTET_LENGTH()	A synonym for LENGTH()
OLD_PASSWORD()	Return the value of the pre-4.1 implementation of PASSWORD
||, OR	Logical OR
ORD()	Return character code for leftmost character of the argument
PASSWORD()	Calculate and return a password string
PERIOD_ADD()	Add a period to a year-month
PERIOD_DIFF()	Return the number of months between periods
PI()	Return the value of pi
+	Addition operator
POSITION()	A synonym for LOCATE()
POW()	Return the argument raised to the specified power
POWER()	Return the argument raised to the specified power
PROCEDURE ANALYSE()	Analyze the results of a query
QUARTER()	Return the quarter from a date argument
QUOTE()	Escape the argument for use in an SQL statement
RADIANS()	Return argument converted to radians
RAND()	Return a random floating-point value
REGEXP	Pattern matching using regular expressions
RELEASE_LOCK()	Releases the named lock
REPEAT()	Repeat a string the specified number of times
REPLACE()	Replace occurrences of a specified string
REVERSE()	Reverse the characters in a string
>>	Right shift
RIGHT()	Return the specified rightmost number of characters
RLIKE	Synonym for REGEXP
ROUND()	Round the argument
ROW_COUNT()	The number of rows updated
RPAD()	Append string the specified number of times
RTRIM()	Remove trailing spaces
SCHEMA()	A synonym for DATABASE()
SEC_TO_TIME()	Converts seconds to 'HH:MM:SS' format
SECOND()	Return the second (0-59)
SESSION_USER()	Synonym for USER()
SHA1(), SHA()	Calculate an SHA-1 160-bit checksum
SIGN()	Return the sign of the argument
SIN()	Return the sine of the argument
SLEEP()	Sleep for a number of seconds
SOUNDEX()	Return a soundex string
SOUNDS LIKE	Compare sounds
SPACE()	Return a string of the specified number of spaces
SQRT()	Return the square root of the argument
STD()	Return the population standard deviation
STDDEV_POP()	Return the population standard deviation
STDDEV_SAMP()	Return the sample standard deviation
STDDEV()	Return the population standard deviation
STR_TO_DATE()	Convert a string to a date
STRCMP()	Compare two strings
SUBDATE()	A synonym for DATE_SUB() when invoked with three arguments
SUBSTR()	Return the substring as specified
SUBSTRING_INDEX()	Return a substring from a string before the specified number of occurrences of the delimiter
SUBSTRING()	Return the substring as specified
SUBTIME()	Subtract times
SUM()	Return the sum
SYSDATE()	Return the time at which the function executes
SYSTEM_USER()	Synonym for USER()
TAN()	Return the tangent of the argument
TIME_FORMAT()	Format as time
TIME_TO_SEC()	Return the argument converted to seconds
TIME()	Extract the time portion of the expression passed
TIMEDIFF()	Subtract time
*	Multiplication operator
TIMESTAMP()	With a single argument, this function returns the date or datetime expression; with two arguments, the sum of the arguments
TIMESTAMPADD()	Add an interval to a datetime expression
TIMESTAMPDIFF()	Subtract an interval from a datetime expression
TO_DAYS()	Return the date argument converted to days
TRIM()	Remove leading and trailing spaces
TRUNCATE()	Truncate to specified number of decimal places
UCASE()	Synonym for UPPER()
-	Change the sign of the argument
UNCOMPRESS()	Uncompress a string compressed
UNCOMPRESSED_LENGTH()	Return the length of a string before compression
UNHEX()	Return a string containing hex representation of a number
UNIX_TIMESTAMP()	Return a UNIX timestamp
UPPER()	Convert to uppercase
USER()	The user name and host name provided by the client
UTC_DATE()	Return the current UTC date
UTC_TIME()	Return the current UTC time
UTC_TIMESTAMP()	Return the current UTC date and time
UUID()	Return a Universal Unique Identifier (UUID)
VALUES()	Defines the values to be used during an INSERT
VAR_POP()	Return the population standard variance
VAR_SAMP()	Return the sample variance
VARIANCE()	Return the population standard variance
VERSION()	Returns a string that indicates the MySQL server version
WEEK()	Return the week number
WEEKDAY()	Return the weekday index
WEEKOFYEAR()	Return the calendar week of the date (0-53)
XOR	Logical XOR
YEAR()	Return the year
YEARWEEK()	Return the year and week
}

function CreateMyKeyWords: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktKeyword);
  for i:= 0 to CountKeyWords-1 do
    Result.Add(FBKeywords[i].Key, FBKeywords[i].SQLToken);
end;

function CreateMyKeyFunctions: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktFunction);
  for i:= 0 to CountKeyFunctions-1 do
    Result.Add(FBFunctions[i].Key, stIdentificator);
end;

function CreateMyKeyTypes: TKeywordList;
var
  i:integer;
begin
  Result:=TKeywordList.Create(ktStdTypes);
  for i:= 0 to CountKeyTypes-1 do
    Result.Add(FBKeyTypes[i].Key, stIdentificator);
end;

procedure FillMyFieldTypes(Items: TDBMSFieldTypeList);
begin
  Items.Add( 'INTEGER', 0, true, false, ftInteger, 'INT', '', tgNumericTypes);

  Items.Add( 'VARCHAR', 0, true, false, ftString, '', '', tgCharacterTypes);
  Items.Add( 'CHAR', 0, true, false, ftString, '', '', tgCharacterTypes);

  Items.Add( 'BIGINT', 0, true, false, ftInteger, '', '', tgNumericTypes);
  Items.Add( 'DECIMAL', 0, true, true, ftFloat, '', '', tgNumericTypes);
  Items.Add( 'DOUBLE', 0, true, true, ftFloat, '', '', tgNumericTypes);
  Items.Add( 'FLOAT', 0, true, true, ftFloat, '', '', tgNumericTypes);
  Items.Add( 'BOOLEAN', 0, false, false, ftFloat, '', '', tgBooleanTypes);

  Items.Add( 'TIME', 0, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add( 'DATE', 0, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add( 'DATETIME', 0, false, false, ftDateTime, '', '', tgDateTimeTypes);
  Items.Add( 'TIMESTAMP', 0, false, false, ftDateTime, '', '', tgDateTimeTypes);

  Items.Add( 'SET', 0, true, true, ftFloat, '', '', tgNumericTypes);
  Items.Add( 'ENUM', 0, true, true, ftFloat, '', '', tgNumericTypes);

  Items.Add( 'TINYINT', 0, true, false, ftInteger, '', '', tgNumericTypes);
  Items.Add( 'MEDIUMINT', 0, true, false, ftInteger, '', '', tgNumericTypes);
  Items.Add( 'SMALLINT', 0, true, false, ftInteger, '', '', tgNumericTypes);

  Items.Add( 'TEXT', 0, true, false, ftFloat, '', '', tgCharacterTypes);
  Items.Add( 'TINYTEXT', 0, true, false, ftFloat, '', '', tgCharacterTypes);
  Items.Add( 'LONGTEXT', 0, true, false, ftFloat, '', '', tgCharacterTypes);
  Items.Add( 'MEDIUMTEXT', 0, true, false, ftFloat, '', '', tgCharacterTypes);

  Items.Add( 'BLOB', 0, false, false, ftBlob, '', '', tgBinaryDataTypes);
  Items.Add( 'TINYBLOB', 0, false, true, ftBlob, '', '', tgBinaryDataTypes);
  Items.Add( 'MEDIUMBLOB', 0, false, true, ftBlob, '', '', tgBinaryDataTypes);
  Items.Add( 'LONGBLOB', 0, false, false, ftBlob, '', '', tgBinaryDataTypes);
  Items.Add( 'BINARY', 0, false, false, ftBlob, '', '', tgBinaryDataTypes);
  Items.Add( 'VARBINARY', 0, false, true, ftBlob, '', '', tgBinaryDataTypes);
  Items.Add( 'BIT', 0, true, true, ftFloat, '', '', tgNumericTypes);
  Items.Add( 'YEAR', 0, true, true, ftFloat, '', '', tgNumericTypes);

  Items.Add( 'GEOMETRY', 0, true, true, ftFloat, '', '', tgGeometricTypes);
  Items.Add( 'POINT', 0, true, true, ftFloat, '', '', tgGeometricTypes);
  Items.Add( 'LINESTRING', 0, true, true, ftFloat, '', '', tgGeometricTypes);
  Items.Add( 'POLYGON', 0, true, true, ftFloat, '', '', tgGeometricTypes);
  Items.Add( 'MULTIPOINT', 0, true, true, ftFloat, '', '', tgGeometricTypes);
  Items.Add( 'MULTILINESTRING', 0, true, true, ftFloat, '', '', tgGeometricTypes);
  Items.Add( 'MULTIPOLYGON', 0, true, true, ftFloat, '', '', tgGeometricTypes);
  Items.Add( 'GEOMETRYCOLLECTION', 0, true, true, ftFloat, '', '', tgGeometricTypes);

end;

end.

