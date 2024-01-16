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

unit fbmSQLScriptRunQuestionUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel;

type

  { TfbmSQLScriptRunQuestionForm }

  TfbmSQLScriptRunQuestionForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure FormCreate(Sender: TObject);
  private
    procedure Localize;
  public

  end;

var
  fbmSQLScriptRunQuestionForm: TfbmSQLScriptRunQuestionForm;

implementation

uses fbmStrConstUnit;

{$R *.lfm}

{ TfbmSQLScriptRunQuestionForm }

procedure TfbmSQLScriptRunQuestionForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfbmSQLScriptRunQuestionForm.Localize;
begin
  Caption:=sConfirmExecute;
  RadioButton1.Caption:=sExecuteSelectedPartOnly;
  RadioButton2.Caption:=sExecuteEntireScript;
  RadioButton3.Caption:=sExecuteAllFilesFromList;
end;

end.

