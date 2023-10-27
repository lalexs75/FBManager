{ Free DB Manager

  Copyright (C) 2005-2023 Lagunov Aleksey  alexs75 at yandex.ru

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

