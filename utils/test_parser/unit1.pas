unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynHighlighterSQL, Forms, Controls,
  Graphics, Dialogs, SynEditTypes, TreeFilterEdit, StdCtrls, ExtCtrls, ComCtrls,
  ActnList, Menus, Buttons, PairSplitter, RxIniPropStorage, rxtoolbar, LR_Class,
  IniFiles,

  PostgreSQLEngineUnit,
  FBSQLEngineUnit,
  SQLite3EngineUnit,
  mysql_engine,

  fbmSqlParserUnit
  ;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    cbFireBirdVersion: TComboBox;
    Label3: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Panel4: TPanel;
    Splitter2: TSplitter;
    SynEdit5: TSynEdit;
    SynSQLSyn4: TSynSQLSyn;
    TabSheet4: TTabSheet;
    tAdd: TAction;
    tDel: TAction;
    chAdd: TAction;
    chDel: TAction;
    actGenCode: TAction;
    actRefresh: TAction;
    actLoad: TAction;
    actSave: TAction;
    ActionList1: TActionList;
    Button1: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Panel1: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    cgTokenType: TCheckGroup;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    RadioGroup2: TRadioGroup;
    RxIniPropStorage1: TRxIniPropStorage;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    SynEdit1: TSynEdit;
    SynEdit2: TSynEdit;
    SynEdit3: TSynEdit;
    SynEdit4: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    SynSQLSyn2: TSynSQLSyn;
    SynSQLSyn3: TSynSQLSyn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    ToolPanel1: TToolPanel;
    TreeFilterEdit1: TTreeFilterEdit;
    TreeView1: TTreeView;
    procedure actLoadExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chAddExecute(Sender: TObject);
    procedure chDelExecute(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SynEdit1Enter(Sender: TObject);
    procedure SynEdit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure SynEdit1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure tAddExecute(Sender: TObject);
    procedure tDelExecute(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    FEditCMD: TSQLStatmentRecord;
    FModifiedData:boolean;
    FB: TSQLEngineFireBird;
    PG: TSQLEnginePostgre;
    SQ3: TSQLEngineSQLite3;
    MySQL:TSQLEngineMySQL;
    procedure DoLoad(P: TSQLTokenRecord);
    procedure UpdateStatus(FSynEdit: TSynEdit);
    procedure LoadEditorStates;
    procedure SaveEditorStates;
  public

  end;

var
  Form1: TForm1;

function AppIniFile:TIniFile;
implementation
uses SQLEngineAbstractUnit, SQLEngineCommonTypesUnit, fb_utils, fb_SqlParserUnit,
  TreeAddChildTokenUnit, rxAppUtils, base64;

function AppIniFile: TIniFile;
var
  S: String;
begin
  S:=RxGetAppConfigDir(false) + 'fbm_test_parser.cfg';
  Result:=TIniFile.Create(S);
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);

procedure DoCommand(ASQLEngine:TSQLEngineAbstract; AMemo:TSynEdit);
var
  V: TSQLCommandAbstract;
  V1: TObject;
  S1: String;
begin
  Memo1.Text:='';
  V:=GetNextSQLCommand(AMemo.Text, ASQLEngine, CheckBox1.Checked);
  if Assigned(V) then
  begin
    if V is TFBSQLAlterTable then
      TFBSQLAlterTable(V).ServerVersion:=StrToFBServersVersion(cbFireBirdVersion.Text)
    else
    if V is TFBSQLCreateTable then
      TFBSQLCreateTable(V).ServerVersion:=StrToFBServersVersion(cbFireBirdVersion.Text)
    ;
    SynEdit2.Text:=V.AsSQL;
    if V.State = cmsError then
    begin
      Memo1.Text:=V.ErrorMessage;
      AMemo.SetFocus;
      AMemo.CaretXY:=V.ErrorPosition;
    end;
    V1:=V.ClassType.Create;
    if Assigned(V1) then
    begin
      if V1 is TSQLCommandAbstract then
      begin
        TSQLCommandAbstract(V1).Create(nil);
        try
          TSQLCommandDDL(V1).Assign(V);
          S1:=TSQLCommandAbstract(V1).AsSQL;
          SynEdit2.Text:=SynEdit2.Text + LineEnding + '-- copy --' + LineEnding + S1;
        finally
        end;
      end;
      V1.Free;
    end;
    Memo1.Lines.Add('Type: ' + V.ClassName);
    V.Free;
  end
  else
  begin
    Memo1.Text:='Неизвестная команда';
    SynEdit2.Text:='';
  end;
end;

begin
  if PageControl1.ActivePage = TabSheet1 then
    DoCommand(FB, SynEdit1)
  else
  if PageControl1.ActivePage = TabSheet2 then
    DoCommand(PG, SynEdit3)
  else
  if PageControl1.ActivePage = TabSheet3 then
    DoCommand(SQ3, SynEdit4)
  else
  if PageControl1.ActivePage = TabSheet4 then
    DoCommand(MySQL, SynEdit5)
end;

procedure TForm1.chAddExecute(Sender: TObject);
begin
  TreeAddChildTokenForm:=TTreeAddChildTokenForm.Create(Application);
  TreeAddChildTokenForm.CheckListBox1.Items.Assign(ListBox2.Items);
  if TreeAddChildTokenForm.ShowModal = mrOk then
  begin
    Edit3Change(nil);
  end;
  TreeAddChildTokenForm.Free;
end;

procedure TForm1.chDelExecute(Sender: TObject);
begin
  Edit3Change(nil);
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  FModifiedData:=true;
end;

procedure TForm1.actRefreshExecute(Sender: TObject);
var
  FCmdReg: TSQLStatmentRecord;
  R, N: TTreeNode;
  i: Integer;
  S: String;
begin
  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;
  for i:=0 to SQLStatmentRecordArray.Count - 1 do
  begin
    FCmdReg:=SQLStatmentRecordArray.Items[i];
    S:=FCmdReg.SQLEngineClass.ClassName;
    R:=TreeView1.Items.FindNodeWithText(S);
    if not Assigned(R) then
    begin
      R:=TreeView1.Items.AddChild(nil, S);
      R.Data:=nil;
      R.ImageIndex:=63;
      R.StateIndex:=63;
      R.SelectedIndex:=63;
    end;

    S:=FCmdReg.Signature;
    N:=TreeView1.Items.AddChild(R, S);
    N.Data:=FCmdReg;
    N.ImageIndex:=26;
    N.StateIndex:=26;
    N.SelectedIndex:=26;
  end;
  TreeView1.Items.EndUpdate;

  DoLoad(nil);
end;

procedure TForm1.actLoadExecute(Sender: TObject);
var
  S: String;
begin
(*  if OpenDialog1.Execute then
    LoadParserTree(OpenDialog1.FileName); *)
end;

procedure TForm1.actSaveExecute(Sender: TObject);
var
  S: String;
begin
(*  S:=ChangeFileExt(ParamStr(0), '.tree');
  SaveParserTree(S); *)
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SaveEditorStates;
  FB.Free;
  PG.Free;
  SQ3.Free;
  MySQL.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  S: String;
begin
  SynEdit2.Text:='';
  FB:=TSQLEngineFireBird.Create;
  PG:=TSQLEnginePostgre.Create;
  SQ3:=TSQLEngineSQLite3.Create;
  MySQL:=TSQLEngineMySQL.Create;

  Memo1.Text:='';

  ComboBox1.Items.Clear;
  for S in DBObjectKindNames do
    ComboBox1.Items.Add(S);


  actRefresh.Execute;

  FillStrServersVer(cbFireBirdVersion.Items);
  if cbFireBirdVersion.Items.Count > 0 then
    cbFireBirdVersion.Text:=StrServersVer[gds_verFirebird3_0];

  LoadEditorStates;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  P: TObject;
  S: String;
  I: Integer;
begin
  //
  S:=ListBox1.Items[ListBox1.ItemIndex];
  P:=ListBox1.Items.Objects[ListBox1.ItemIndex];

  I:=ListBox2.Items.IndexOfObject(P);

  if I>-1 then
  begin
    ListBox2.ItemIndex:=i;
    ListBox2Click(nil);
  end;
{  for i:=0 to
        K:=ListBox2.Items.Add( Format('%d. %s : %s', [i, SQLTokenStr[P.Token], P.SQLCommand]));
      ListBox2.Items.Objects[K]:=P;}
end;

procedure TForm1.DoLoad(P:TSQLTokenRecord);
var
  Ch: TSQLTokenRecord;
  i, K: Integer;
begin
  ListBox1.Items.Clear;

  if Assigned(P) then
  begin
    Edit3.Text:=P.SQLCommand;
    Edit4.Text:=IntToStr(P.Tag);
    cgTokenType.Checked[0]:=toFindWordLast in P.Options;    //Элемент используется для идентификации SQL запроса в спискедоступных
    cgTokenType.Checked[1]:=toFirstToken in P.Options;       //Корень дерева разбора
    cgTokenType.Checked[2]:=toOptional in P.Options;
    RadioGroup2.ItemIndex:=Ord(P.Token);
    ComboBox1.ItemIndex:=Ord(P.DBObjectKind);
    for i:=0 to P.Child.Count - 1 do
    begin
      Ch:=P.Child[i];
      K:=FEditCmd.Item.SQLTokensList.IndexOf(CH);
      ListBox1.AddItem(Format('%d. %s : %s (%d)', [K, SQLTokenStr[CH.Token], CH.SQLCommand, CH.Tag]), Ch);
    end;


  end
  else
  begin
    Edit3.Text:='';
    Edit4.Text:='';
    cgTokenType.Checked[0]:=false;
    cgTokenType.Checked[1]:=false;
    cgTokenType.Checked[2]:=false;
    RadioGroup2.ItemIndex:=0;
    ComboBox1.ItemIndex:=0;
  end;

  Label5.Enabled:=Assigned(P);
  Label6.Enabled:=Assigned(P);
  Edit3.Enabled:=Assigned(P);
  cgTokenType.Enabled:=Assigned(P);
  RadioGroup2.Enabled:=Assigned(P);
  ComboBox1.Enabled:=Assigned(P);
  Label2.Enabled:=Assigned(P);
  ListBox1.Enabled:=Assigned(P);
  Label7.Enabled:=Assigned(P);
  Edit4.Enabled:=Assigned(P);
end;

procedure TForm1.ListBox2Click(Sender: TObject);
begin
  if (ListBox2.ItemIndex > -1) and (ListBox2.ItemIndex < ListBox2.Items.Count) then
    DoLoad(TSQLTokenRecord(ListBox2.Items.Objects[ListBox2.ItemIndex]))
  else
    DoLoad(nil);
end;

procedure TForm1.PageControl1Change(Sender: TObject);
var
  S:TSynEdit;
begin
  case PageControl1.ActivePageIndex of
    0:S:=SynEdit1;
    1:S:=SynEdit3;
    2:S:=SynEdit4;
  else
    exit;
  end;
  UpdateStatus(S);
end;

procedure TForm1.SynEdit1Enter(Sender: TObject);
begin
  UpdateStatus(Sender as TSynEdit);
end;

procedure TForm1.SynEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateStatus(Sender as TSynEdit);
end;

procedure TForm1.SynEdit1StatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  UpdateStatus(Sender as TSynEdit);
end;

procedure TForm1.tAddExecute(Sender: TObject);
begin
  Edit3Change(nil);
end;

procedure TForm1.tDelExecute(Sender: TObject);
begin
  Edit3Change(nil);
end;

procedure TForm1.TreeView1Click(Sender: TObject);
var
  P: TSQLTokenRecord;
  i, K: Integer;
begin
  if not Assigned(TreeView1.Selected) then exit;

  if Pointer(FEditCMD) = TreeView1.Selected.Data then exit;


  ListBox1.Items.Clear;
  ListBox2.Clear;
  FEditCMD:=TSQLStatmentRecord(TreeView1.Selected.Data);

  if Assigned(FEditCMD) then
  begin
    Edit1.Text:=FEditCMD.Signature;
    for i:=0 to FEditCMD.Item.SQLTokensList.Count-1 do
    begin
      P:=FEditCMD.Item.SQLTokensList[i];
      K:=ListBox2.Items.Add( Format('%d. %s : %s', [i, SQLTokenStr[P.Token], P.SQLCommand]));
      ListBox2.Items.Objects[K]:=P;
    end;
  end
  else
    DoLoad(nil);
end;

procedure TForm1.UpdateStatus(FSynEdit: TSynEdit);
begin
  StatusBar1.Panels[0].Text:=Format('%-5d:%-3d', [FSynEdit.CaretY, FSynEdit.CaretX]);
end;

procedure TForm1.LoadEditorStates;
var
  Ini: TIniFile;
begin
  Ini:=AppIniFile;
  SynEdit1.Text:=DecodeStringBase64(Ini.ReadString('Editors', 'FirebirdSQL', ''));
  SynEdit3.Text:=DecodeStringBase64(Ini.ReadString('Editors', 'PostgreSQL', ''));
  SynEdit4.Text:=DecodeStringBase64(Ini.ReadString('Editors', 'SQLite3', ''));
  SynEdit5.Text:=DecodeStringBase64(Ini.ReadString('Editors', 'MySQL', ''));
  Ini.Free;
end;

procedure TForm1.SaveEditorStates;
var
  Ini: TIniFile;
begin
  Ini:=AppIniFile;
  Ini.WriteString('Editors', 'FirebirdSQL', EncodeStringBase64(SynEdit1.Text));
  Ini.WriteString('Editors', 'PostgreSQL', EncodeStringBase64(SynEdit3.Text));
  Ini.WriteString('Editors', 'SQLite3', EncodeStringBase64(SynEdit4.Text));
  Ini.WriteString('Editors', 'MySQL', EncodeStringBase64(SynEdit5.Text));
  Ini.Free;
end;

end.

