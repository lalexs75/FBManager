unit tlsProgressOperationUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  ComCtrls, StdCtrls;

type

  { TtlsProgressOperationForm }

  TtlsProgressOperationForm = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    OpCancel:boolean;
  end;

var
  tlsProgressOperationForm: TtlsProgressOperationForm = nil;

procedure ShowProgress;
procedure AddProgres(CurValue, MaxValue:integer);
procedure HideProgress;
implementation

procedure ShowProgress;
begin
  if not Assigned(tlsProgressOperationForm) then
  begin
    tlsProgressOperationForm:=TtlsProgressOperationForm.Create(Application);
    tlsProgressOperationForm.ProgressBar1.Style := pbstMarquee
  end;
  tlsProgressOperationForm.Show;
end;

procedure AddProgres(CurValue, MaxValue: integer);
begin
  if Assigned(tlsProgressOperationForm) then
  begin
    if tlsProgressOperationForm.ProgressBar1.Style = pbstMarquee then
      tlsProgressOperationForm.ProgressBar1.Style := pbstNormal;

    tlsProgressOperationForm.ProgressBar1.Max:=MaxValue;
    tlsProgressOperationForm.ProgressBar1.Position:=CurValue;
    Application.ProcessMessages;
  end;
end;

procedure HideProgress;
begin
 if Assigned(tlsProgressOperationForm) then
   FreeAndNil(tlsProgressOperationForm);
end;

{$R *.lfm}

{ TtlsProgressOperationForm }

procedure TtlsProgressOperationForm.BitBtn1Click(Sender: TObject);
begin
  OpCancel:=true;
end;

end.

