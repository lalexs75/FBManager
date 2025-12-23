unit fbmCFColorMarksPageUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, ColorBox, ExtCtrls, Spin, StdCtrls, SysUtils, Forms, Controls, Graphics, Dialogs, SQLEngineAbstractUnit,
  fdbm_ConnectionAbstractUnit;

type
  TfbmCFColorMarksPage = class(TConnectionDlgPage)
    CheckBox1 : TCheckBox;
    CheckBox2 : TCheckBox;
    CheckGroup1 : TCheckGroup;
    ColorBox1 : TColorBox;
    ColorBox2 : TColorBox;
    ColorBox3 : TColorBox;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    SpinEdit1 : TSpinEdit;
  private

  public
    procedure Localize;override;
    procedure Activate;override;
    procedure LoadParams(ASQLEngine:TSQLEngineAbstract);override;
    procedure SaveParams;override;
    function PageName:string;override;
    function Validate:boolean;override;
    constructor Create(ASQLEngineAbstract:TSQLEngineAbstract; AOwner:TForm);
  end;

implementation

{$R *.lfm}

procedure TfbmCFColorMarksPage.Localize;
begin
  inherited Localize;
end;

procedure TfbmCFColorMarksPage.Activate;
begin
  inherited Activate;
end;

procedure TfbmCFColorMarksPage.LoadParams(ASQLEngine : TSQLEngineAbstract);
begin

end;

procedure TfbmCFColorMarksPage.SaveParams;
begin

end;

function TfbmCFColorMarksPage.PageName : string;
begin

end;

function TfbmCFColorMarksPage.Validate : boolean;
begin
  Result :=true;
end;

constructor TfbmCFColorMarksPage.Create(ASQLEngineAbstract : TSQLEngineAbstract; AOwner : TForm);
begin
  inherited Create(AOwner);
//  FSQLEngineAbstract:=ASQLEngineAbstract;
end;

end.

