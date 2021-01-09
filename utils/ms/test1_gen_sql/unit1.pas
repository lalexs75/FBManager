unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  SynEdit, SynHighlighterSQL;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SynEdit1: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
uses mssql_sql_parser, sqlObjects;

{$R *.lfm}

{ TForm1 }

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
//  Label1.Enabled:=ComboBox1;//Schema
  Label2.Enabled:=ComboBox1.ItemIndex>0;//
  Label4.Enabled:=ComboBox1.ItemIndex>2;//Collumn

  Edit1.Enabled:=Label1.Enabled;
  Edit2.Enabled:=Label2.Enabled;
  Edit3.Enabled:=Label4.Enabled;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  C: TMSSQLCommentOn;
begin
  C:=TMSSQLCommentOn.Create(nil);
  C.Description:=Edit4.Text;
  case ComboBox1.ItemIndex of
    0:begin
        C.ObjectKind:=okScheme;
        C.SchemaName:=Edit1.Text;
      end;
    1:begin
        C.ObjectKind:=okTable;
        C.SchemaName:=Edit1.Text;
        C.TableName:=Edit2.Text;
      end;
    2:begin
        C.ObjectKind:=okView;
        C.SchemaName:=Edit1.Text;
        C.TableName:=Edit2.Text;
      end;
    3:begin
        C.ObjectKind:=okColumn;
        C.SchemaName:=Edit1.Text;
        C.TableName:=Edit2.Text;
        C.Name:=Edit3.Text;
      end;
  else
  end;
  SynEdit1.Text:=C.AsSQL;
  C.Free;
end;

end.

