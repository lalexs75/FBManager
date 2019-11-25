;------------------------------------------------------------------------------
;
;       Утановочного скрипты для Inno Setup 5.5.5 для установки FBManager
;       (c) alexs, 17.07.2019
;
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;   Определяем некоторые константы
;------------------------------------------------------------------------------

; Имя приложения
#define   Name       "FreeDataBaseManager"
; Версия приложения
#define   Version    "0.9.1"
; Фирма-разработчик
#define   Publisher  "alexs"
; Сафт фирмы разработчика
#define   URL        "http://w7site.ru"
; Имя исполняемого модуля
#define   ExeName    "IBManager.exe"

;------------------------------------------------------------------------------
;   Устанавливаем языки для процесса установки
;------------------------------------------------------------------------------
[Languages]
;Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "License_ENG.txt"
;Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; LicenseFile: "License_RUS.txt"
Name: "english"; MessagesFile: "compiler:Default.isl"; 
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; 

;------------------------------------------------------------------------------
;   Параметры установки
;------------------------------------------------------------------------------
[Setup]

; Уникальный идентификатор приложения, 
;сгенерированный через Tools -> Generate GUID
AppId={{3A838A8A-75B3-40B7-B704-AA1242EBD769}

; Прочая информация, отображаемая при установке
AppName={#Name}
AppVersion={#Version}
AppPublisher={#Publisher}
AppPublisherURL={#URL}
AppSupportURL={#URL}
AppUpdatesURL={#URL}

; Путь установки по-умолчанию
DefaultDirName={pf}\{#Name}
; Имя группы в меню "Пуск"
DefaultGroupName={#Name}

; Каталог, куда будет записан собранный setup и имя исполняемого файла
OutputDir=c:\test-setup
OutputBaseFileName=FBM-setup
           
; Файл иконки
;SetupIconFile=W:\FBManager\IBManager.ico

; Параметры сжатия
Compression=lzma
SolidCompression=yes

;------------------------------------------------------------------------------
;   Опционально - некоторые задачи, которые надо выполнить при установке
;------------------------------------------------------------------------------
[Tasks]
; Создание иконки на рабочем столе
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked


;------------------------------------------------------------------------------
;   Файлы, которые надо включить в пакет установщика
;------------------------------------------------------------------------------
[Files]

; Исполняемый файл
Source: "W:\FBManager\IBManager.exe"; DestDir: "{app}"; Flags: ignoreversion

; Прилагающиеся ресурсы
Source: "W:\FBManager\docs\COPYING.GPL"; DestDir: "{app}\docs\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "W:\FBManager\reports\*"; DestDir: "{app}\reports"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "W:\FBManager\languages\*"; DestDir: "{app}\languages"; Flags: ignoreversion recursesubdirs createallsubdirs

Source: "W:\FBManager\dlls\freetype6.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\iconv.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\intl.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libcairo-2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libcurl.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libfontconfig-1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libfreetype-6.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libglib-2.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libgmodule-2.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libgobject-2.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libgthread-2.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libiconv.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libidn-11.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libintl.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\liblzma-5.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libmariadb.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libpango-1.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libpangocairo-1.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libpangoft2-1.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libpangowin32-1.0-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libpng14-14.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libssh2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libssl32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libxml2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\libxml2-2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\zlib1.dll"; DestDir: "{app}"; Flags: ignoreversion

Source: "W:\FBManager\dlls\sqlite3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\fblib\fbclient.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\fblib\firebird.msg"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\FBManager\dlls\fblib\msvcr100.dll"; DestDir: "{app}"; Flags: ignoreversion

Source: "W:\sto\dll\libeay32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\sto\dll\libiconv-2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\sto\dll\libintl-8.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\sto\dll\libpq.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\sto\dll\msvcr120.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "W:\sto\dll\ssleay32.dll"; DestDir: "{app}"; Flags: ignoreversion

;------------------------------------------------------------------------------
;   Указываем установщику, где он должен взять иконки
;------------------------------------------------------------------------------ 
[Icons]

Name: "{group}\{#Name}"; Filename: "{app}\{#ExeName}"
Name: "{commondesktop}\{#Name}"; Filename: "{app}\{#ExeName}"; Tasks: desktopicon