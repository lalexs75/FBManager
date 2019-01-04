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

unit fb_ConstUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils; 

const
  //defTranParamData      : integer = 1;
  //defTranParamMetaData  : integer = 1;
  //defTranParamScript    : integer = 1;

  //fb_defUserName        : string = '';
  //fb_defUserPassword    : string = '';

  sCommentFBMStyle        = '$$FBMC$$';
  sCommentIBEStyle        = '$$IBE$$';

  TargetOS = {$I %FPCTARGETOS%};

const
  ssqlCreateTriggerName = 'TR_%TABLE_NAME%_%TRIGGER_TYPE%';
  ssqlCreateTriggerBodyNormal =
      'as' + LineEnding +
      'declare variable_name datatype;' + LineEnding +
      'begin' + LineEnding +
      '  /* Trigger text */' + LineEnding +
      'end';

  ssqlCreateTriggerBodyLazy =
      'begin' + LineEnding +
      '  /* Trigger text */' + LineEnding +
      'end';

  ssqlCreateAutoIncTriggerBody =
      'BEGIN' + LineEnding +
      '  IF (NEW.%FIELD_NAME% IS NULL) THEN' + LineEnding +
      '    NEW.%FIELD_NAME% = GEN_ID(%GENERATOR_NAME%,1);' + LineEnding +
      'END';


  sMySqlCreateTriggerName = 'TR_%TABLE_NAME%_%TRIGGER_TYPE%';
  sMySqlCreateTriggerBodyNormal =
      'as' + LineEnding +
      'declare variable_name datatype;' + LineEnding +
      'begin' + LineEnding +
      '  /* Trigger text */' + LineEnding +
      'end';

  sMySqlCreateTriggerBodyLazy =
      'begin' + LineEnding +
      '  /* Trigger text */' + LineEnding +
      'end';

implementation

end.

