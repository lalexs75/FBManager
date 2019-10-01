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

