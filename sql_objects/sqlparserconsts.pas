unit sqlParserConsts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
  sSqlParserErrorBracket    = 'Unexpected )';
  sSqlParserExpected        = 'Expected : ';
  sSqlParserString          = 'string';
  sSqlParserNumber          = 'number';
  sSqlParserIdentificator   = 'identificator';
  sSqlParserUnknowCommand   = 'Unknow command: %s';

implementation

end.

