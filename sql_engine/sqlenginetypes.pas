{ Free DB Manager

  Copyright (C) 2005-2024 Lagunov Aleksey  alexs75 at yandex.ru

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

unit sqlEngineTypes;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils;

type
  TExportEngine = (eePostgre, eeFireBird, eeFireBird3, eeSqlLite3, eeMySQL);

  TDBObjectKind = (okNone,
                   okDomain, okTable, okView, okTrigger, okStoredProc,
                   okSequence, okException, okUDF, okRole,
                   okUser, okLogin, okScheme,
                   okGroup, okIndex, okTableSpace, okLanguage, okCheckConstraint,
                   okForeignKey, okPrimaryKey, okUniqueConstraint, okField,
                   okRule, okOther, okTasks,

                   okConversion, okDatabase, okType, okServer, okColumn,
                   okCharSet, okCollation, okFilter, okParameter,
                   okAccessMethod, okAggregate, okMaterializedView,
                   okCast,
                   okConstraint,
                   okExtension,

                   okForeignTable,
                   okForeignDataWrapper,
                   okForeignServer,

                   okLargeObject,
                   okPolicy,
                   okFunction, okEventTrigger,

                   okAutoIncFields, //-????
                   okFTSConfig,
                   okFTSDictionary,
                   okFTSParser,
                   okFTSTemplate,

                   okPackage,
                   okPackageBody,
                   okTransform,
                   okOperator,
                   okOperatorClass,
                   okOperatorFamily,
                   okUserMapping,
                   okPartitionTable,
                   okProcedureParametr,
                   okFunctionParametr

                   );

type
  TTableStatisticRecord = record
    sFormat:string;
    RecordCount:Int64;
  end;

implementation

end.

