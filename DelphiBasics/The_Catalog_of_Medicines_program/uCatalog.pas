unit uCatalog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmCatalog = class(TForm)
    pnlActions: TPanel;
    scrBList: TScrollBox;
    btnAdd: TButton;
    btnExit: TButton;
    pnlDrugInfo: TPanel;
    memDrugInfo: TMemo;
    Splitter1: TSplitter;
    lblMainCategory: TLabel;
    lblMainCategotyTitle: TLabel;
    lblMainCost: TLabel;
    lblMainCostTitle: TLabel;
    pnlMainTitle: TPanel;
    lblMainTitle: TLabel;
    btnDelete: TButton;
    btnRestore: TButton;
    btnEdit: TButton;
    edtSearch: TEdit;
    btnSearch: TButton;
    btnAll: TButton;
    phlChoice: TPanel;
    rbtnTitleUp: TRadioButton;
    rbtnTitleDown: TRadioButton;
    rbtnCategoryDown: TRadioButton;
    rbtnCostUp: TRadioButton;
    rbtnCostDown: TRadioButton;
    lblTitleSort: TLabel;
    lblCategoruSort: TLabel;
    lblCostSort: TLabel;
    lblSortChoice: TLabel;
    rbtnCategoryUp: TRadioButton;
    btnSortList: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure PanelTitleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure rbtnClick(Sender: TObject);
    procedure btnSortListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCatalog: TfrmCatalog;

implementation

uses uChange, uAboutProgram;

{$R *.dfm}

Type
  TString = String[50];
  TInfoOfDrug = record
    Title: String[50];
    Info: String[250];
    Category: String[50];
    Cost: Real;
  End;
  PDrug =^ TDrug;
  TDrug = record
    Pnl: TPanel;
    InfDrg: TInfoOfDrug;
    Next: PDrug;
  End;
  PStack =^ TDeleted;
  TDeleted = record
    Element: TInfoOfDrug;
    Prev: TString;
    Next: PStack;
  End;

Var
  HeaderCurrList, ListEl, LastCurrList: PDrug;
  CurrPanel: TPanel;
  HeadStack: PStack;
  NumOfSort:Integer;

Procedure MakeList(Var procHeader, procLast: PDrug);
  Begin
    New(procHeader);
    procHeader^.Next := nil;
    procHeader^.InfDrg.Title := '';
    procLast := procHeader;
  End;

Procedure FindDrug(Var Str: TString; Var DrugPoint: PDrug);
  Begin
    While (DrugPoint^.Next.InfDrg.Title <> Str) do
      DrugPoint := DrugPoint.Next;
  End;

Procedure TfrmCatalog.PanelTitleClick(Sender: TObject);
  Var
    LabelOfPanel: TLabel;
    StrName: TString;
  Begin
    LabelOfPanel := TLabel(Sender);
    CurrPanel := TPanel(LabelOfPanel.Parent);
    StrName := TString(LabelOfPanel.Caption);
    ListEl := HeaderCurrList;
    FindDrug(StrName, ListEl);
    ListEl := ListEl^.Next;
    frmCatalog.memDrugInfo.Text := ListEl.InfDrg.Info;
    frmCatalog.lblMainCategory.Caption := ListEl.InfDrg.Category;
    frmCatalog.lblMainCost.Caption := FloatToStr(ListEl.InfDrg.Cost);
    frmCatalog.lblMainTitle.Caption := StrName;
    frmCatalog.btnDelete.Enabled := True;
    frmCatalog.btnEdit.Enabled := True;
  End;

Function ListPanel(Var panelOwner: TScrollBox; Var ListPanelInfo: TInfoOfDrug): TPanel;
  Var
    PanelTitle: TLabel;
  Begin
    Result := TPanel.Create(panelOwner);
    With Result do
    Begin
      Parent := panelOwner;
      Align := alTop;
      Caption := '';
      Visible := True;
      Height := 30;
    End;
    PanelTitle := TLabel.Create(Result);
    With PanelTitle do
    Begin
      Parent := Result;
      Align := alClient;
      Alignment := taLeftJustify;
      Layout := tlCenter;
      Caption := ListPanelInfo.Title;
      Font.Size := 10;
      OnClick := frmCatalog.PanelTitleClick;
    End;
  End;

procedure UpdatePanels(Var panelsParent: TScrollBox; Head: PDrug);
Begin
  While panelsParent.ControlCount <> 0 do
  Begin
    panelsParent.Controls[0].Free
  End;
  While Head^.Next <> nil do
  Begin
    Head^.Next^.Pnl := ListPanel(panelsParent, Head^.Next.InfDrg);
    Head := Head^.Next;
  End;
End;

Procedure NewDrug(Var procLast: PDrug; Var procOwner: TScrollBox);
  Var
    procP: PDrug;
    InfoF: File of TInfoOfDrug;

  Begin
    New(procLast^.Next);
    procLast := procLast^.Next;
    procLast^.Next := nil;
    AssignFile(InfoF,'CatalogInfo.txt');
    Reset(InfoF);
    Seek(InfoF, FileSize(InfoF)-1);
    Read(InfoF,procLast.InfDrg);
    CloseFile(InfoF);
    procLast^.Pnl := ListPanel(procOwner, procLast.InfDrg);
  End;

Procedure UpdateList(Var Head, Last: PDrug);
  Var
    N: Integer;
    InfoF: File of TInfoOfDrug;

  Begin
    Last := Head;
    AssignFile(InfoF,'CatalogInfo.txt');
    Reset(InfoF);
    N := 0;
    While N < FileSize(InfoF) do
    Begin
      Seek(InfoF, N);
      New(Last^.Next);
      Last := Last^.Next;
      Last^.Next := nil;
      Read(InfoF,Last.InfDrg);
      Last^.Pnl := ListPanel(frmCatalog.scrBList, Last.InfDrg);
      inc(N);
    End;
  End;

procedure ClearPanels(Var panelsParent: TScrollBox);
  Begin
    While panelsParent.ControlCount <> 0 do
      panelsParent.Controls[0].Free
  End;

procedure TfrmCatalog.btnAddClick(Sender: TObject);
  begin
    ClearPanels(frmCatalog.scrBList);
    UpdateList(HeaderCurrList, LastCurrList);
    fAdding.btnAddInCatalog.Enabled := True;
    fAdding.ShowModal;
    If fAdding.btnAddInCatalog.Tag = 1 then
    Begin
      NewDrug(LastCurrList, scrBList);
      fAdding.btnAddInCatalog.Tag := 0;
    End;
    fAdding.btnAddInCatalog.Enabled := False;
  end;


procedure TfrmCatalog.btnExitClick(Sender: TObject);
  begin
    frmAboutProgram.Show;
  end;

Procedure MakeStack(Var Header: PStack);
  Begin
    New(Header);
    Header^.Next := nil;
    Header^.Prev := '';
  End;

procedure TfrmCatalog.FormShow(Sender: TObject);
  begin
    MakeList(HeaderCurrList, LastCurrList);
    MakeStack(HeadStack);
    UpdateList(HeaderCurrList, LastCurrList);
  end;

procedure Push(Var Head: PStack; Var StrPrev: TString; Var DelDrug:TInfoOfDrug);
  Var
    NewDeleted: PStack;
  Begin
    New(NewDeleted);
    NewDeleted^.Next := Head;
    Head := NewDeleted;
    Head^.Element := DelDrug;
    Head^.Prev := StrPrev;
    frmCatalog.btnRestore.Enabled := True;
  End;

procedure Pop(Var Head: PStack; Var StrPrev: TString; Var RestoredDrug:TInfoOfDrug);
  Var
    ToDelete: PStack;
  Begin
    StrPrev := Head^.Prev;
    RestoredDrug := Head^.Element;
    ToDelete := Head;
    Head := Head^.Next;
    Dispose(ToDelete);
  End;

procedure FindPos(Var Str: TString; Var DrugPoint: PDrug);
  Begin
    While (DrugPoint.InfDrg.Title <> Str) do
      DrugPoint := DrugPoint.Next;
  End;

procedure Restore(Var StrPrev: TString; Var DrugInfo:TInfoOfDrug; Var OldHeader: PDrug);
  Var
    RestoredDrug: PDrug;
    PrevP, NextP: PDrug;
  Begin
    PrevP := OldHeader;
    FindPos(StrPrev,PrevP);
    NextP := PrevP^.Next;
    New(PrevP^.Next);
    PrevP^.Next^.InfDrg:= DrugInfo;
    PrevP^.Next^.Next := NextP;
    PrevP^.Next^.Pnl := ListPanel(frmCatalog.scrBList, PrevP^.Next.InfDrg);
  End;

procedure UpdateFile(DrugList: PDrug);
  Var
    ListFile: File of TInfoOfDrug;
  Begin
    AssignFile(ListFile,'CatalogInfo.txt');
    Rewrite(ListFile);
    While DrugList^.Next <> nil do
    Begin
      Write(ListFile,DrugList^.Next^.InfDrg);
      Seek(ListFile,FileSize(ListFile));
      DrugList := DrugList^.Next;
    End;
    Close(ListFile);
  End;

Procedure Delete(Var DeleteP: PDrug);
  Var
    toDelete: PDrug;
  Begin
    toDelete := DeleteP^.Next;
    If toDelete^.Next = nil then
      LastCurrList := DeleteP;
    DeleteP^.Next := DeleteP^.Next^.Next;
    Dispose(toDelete);
    CurrPanel.Destroy;
  End;

procedure TfrmCatalog.btnDeleteClick(Sender: TObject);
  Var
    StrName: TString;
    CurrP: PDrug;
  begin
    CurrP := HeaderCurrList;
    StrName := TString(frmCatalog.lblMainTitle.Caption);
    frmCatalog.btnDelete.Enabled := False;
    frmCatalog.memDrugInfo.Clear;
    frmCatalog.lblMainCategory.Caption := '';
    frmCatalog.lblMainCost.Caption := '';
    frmCatalog.lblMainTitle.Caption := '';
    FindDrug(StrName,CurrP);
    Push(HeadStack,CurrP^.InfDrg.Title,CurrP^.Next^.InfDrg);
    Delete(CurrP);
    UpdateFile(HeaderCurrList);
    btnEdit.Enabled := false;
  end;

procedure TfrmCatalog.btnRestoreClick(Sender: TObject);
  Var
    PreviousString: TString;
    ResDrug:TInfoOfDrug;
    InfoF: File of TInfoOfDrug;
    N: Longint;
    Temp: PDrug;
   begin
    Pop(HeadStack, PreviousString, ResDrug);
    Restore(PreviousString, ResDrug, HeaderCurrList);
    UpdateFile(HeaderCurrList);
    LastCurrList := HeaderCurrList^.Next;
    While LastCurrList^.Next <> nil do
      LastCurrList := LastCurrList^.Next;
    If HeadStack.Next = nil then
    Begin
      frmCatalog.btnRestore.Enabled := False;
      LastCurrList := HeaderCurrList^.Next;
    End;
    ClearPanels(frmCatalog.scrBList);
    UpdateList(HeaderCurrList, LastCurrList);
  end;

Procedure EditeDrug(Var Header: PDrug);
  Var
    StrName: TString;
    CurrP: PDrug;
    FileInfo: File of TInfoOfDrug;
  begin
    fAdding.btnEditInCatalog.Enabled := True;
    CurrP := Header;
    StrName := TString(frmCatalog.lblMainTitle.Caption);
    FindDrug(StrName,CurrP);
    fAdding.edtTitle.Text := CurrP^.Next^.InfDrg.Title;
    fAdding.memDescription.Text := CurrP^.Next^.InfDrg.Info;
    fAdding.edtCategory.Text := CurrP^.Next^.InfDrg.Category;
    fAdding.edtCost.Text := FloatToStr(CurrP^.Next^.InfDrg.Cost);
    fAdding.ShowModal;
    AssignFile(FileInfo,'CatalogInfo.txt');
    Reset(FileInfo);
    Seek(FileInfo, FileSize(FileInfo)-1);
    Read(FileInfo,CurrP^.Next^.InfDrg);
    CloseFile(FileInfo);
    UpdateFile(Header);
    fAdding.btnEditInCatalog.Enabled := False;
    UpdatePanels(frmCatalog.scrBList,HeaderCurrList);
  end;


procedure TfrmCatalog.btnEditClick(Sender: TObject);
  begin
    EditeDrug(HeaderCurrList);
    frmCatalog.btnEdit.Enabled := False;
  end;

procedure Search(Head: PDrug);
  Var
    i, j: Integer;
    searchStr, cmpare: TString;
    Similar: Boolean;
  Begin
    ClearPanels(frmCatalog.scrBList);
    UpdateList(HeaderCurrList, LastCurrList);
    searchStr := TString(frmCatalog.edtSearch.Text);
    While Head^.next <> nil do
    Begin
      Head^.Next.Pnl.Visible := True;
      cmpare := TString(Head^.next.InfDrg.Title);
      Similar := False;

      If length(searchStr) <= length(cmpare) then
      Begin
        j := 0;
        While (Length(cmpare)-j >=  Length(searchStr)) and (not Similar) do
        Begin
          i := 1;
          Similar := True;
          While (i <= length(searchStr)) and Similar do
          Begin
            If searchStr[i] <> cmpare[i+j] then
              Similar := False;
            inc(i);
          End;
          inc(j);
        End;
      End
      Else
        Similar := False;
      If not Similar then
        Head^.next.Pnl.Visible := False;
      Head := Head^.Next;
    End;
  End;

procedure TfrmCatalog.btnSearchClick(Sender: TObject);
  begin
    Search(HeaderCurrList);
  end;

Procedure All(Head: PDrug);
  Begin
    UpdatePanels(frmCatalog.scrBList, HeaderCurrList);
  End;

procedure TfrmCatalog.btnAllClick(Sender: TObject);
  begin
    All(HeaderCurrList);
  end;

Procedure TfrmCatalog.rbtnClick(Sender: TObject);
  Begin
    btnSortList.Enabled := True;
    NumOfSort := TRadioButton(Sender).Tag;
  End;

Procedure UpdateC(Var Head, Last: PDrug);
  Var
    N: Integer;
    InfoF: File of TInfoOfDrug;
  Begin
    Last := Head;
    AssignFile(InfoF,'CatalogInfo.txt');
    Reset(InfoF);
    N := 0;
    While N < FileSize(InfoF) do
    Begin
      Seek(InfoF, N);
      New(Last^.Next);
      Last := Last^.Next;
      Last^.Next := nil;
      Read(InfoF,Last.InfDrg);
      inc(N);
    End;
  End;

procedure SortByTitleUp(Var Header: PDrug);
  Var
    ToDelete, Curr: PDrug;
    ShowInfo: TInfoOfDrug;
  Begin
    ClearPanels(frmCatalog.scrBList);
    While Header^.Next <> nil do
    Begin
      Curr := Header;
      ShowInfo := Curr^.Next.InfDrg;
      ToDelete := Curr;
      While Curr^.Next^.Next <> nil do
      Begin
        If Curr^.Next.InfDrg.Title < Curr^.Next^.Next.InfDrg.Title then
        Begin
          ShowInfo := Curr^.Next^.Next.InfDrg;
          ToDelete := Curr^.Next;
        End;
        Curr := Curr^.Next;
      End;
      Curr := ToDelete;
      ToDelete := ToDelete^.Next;
      Curr^.Next := Curr^.Next^.Next;
      Dispose(ToDelete);
      ListPanel(frmCatalog.scrBList, ShowInfo);
    End;
    UpdateC(HeaderCurrList, LastCurrList);
  End;

procedure SortByTitleDown(Var Header: PDrug);
  Var
    ToDelete, Curr: PDrug;
    ShowInfo: TInfoOfDrug;
  Begin
    ClearPanels(frmCatalog.scrBList);
    While Header^.Next <> nil do
    Begin
      Curr := Header;
      ShowInfo := Curr^.Next.InfDrg;
      ToDelete := Curr;
      While Curr^.Next^.Next <> nil do
      Begin
        If Curr^.Next.InfDrg.Title > Curr^.Next^.Next.InfDrg.Title then
        Begin
          ShowInfo := Curr^.Next^.Next.InfDrg;
          ToDelete := Curr^.Next;
        End;
        Curr := Curr^.Next;
      End;
      Curr := ToDelete;
      ToDelete := ToDelete^.Next;
      Curr^.Next := Curr^.Next^.Next;
      Dispose(ToDelete);
      ListPanel(frmCatalog.scrBList, ShowInfo);
    End;
    UpdateC(HeaderCurrList, LastCurrList);
  End;

procedure SortByCategoryUp(Var Header: PDrug);
  Var
    ToDelete, Curr: PDrug;
    ShowInfo: TInfoOfDrug;
  Begin
    ClearPanels(frmCatalog.scrBList);
    While Header^.Next <> nil do
    Begin
      Curr := Header;
      ShowInfo := Curr^.Next.InfDrg;
      ToDelete := Curr;
      While Curr^.Next^.Next <> nil do
      Begin
        If Curr^.Next.InfDrg.Category < Curr^.Next^.Next.InfDrg.Category then
        Begin
          ShowInfo := Curr^.Next^.Next.InfDrg;
          ToDelete := Curr^.Next;
        End;
        Curr := Curr^.Next;
      End;
      Curr := ToDelete;
      ToDelete := ToDelete^.Next;
      Curr^.Next := Curr^.Next^.Next;
      Dispose(ToDelete);
      ListPanel(frmCatalog.scrBList, ShowInfo);
    End;
    UpdateC(HeaderCurrList, LastCurrList);
  End;

procedure SortByCategoryDown(Var Header: PDrug);
  Var
    ToDelete, Curr: PDrug;
    ShowInfo: TInfoOfDrug;
  Begin
    ClearPanels(frmCatalog.scrBList);
    While Header^.Next <> nil do
    Begin
      Curr := Header;
      ShowInfo := Curr^.Next.InfDrg;
      ToDelete := Curr;
      While Curr^.Next^.Next <> nil do
      Begin
        If Curr^.Next.InfDrg.Category > Curr^.Next^.Next.InfDrg.Category then
        Begin
          ShowInfo := Curr^.Next^.Next.InfDrg;
          ToDelete := Curr^.Next;
        End;
        Curr := Curr^.Next;
      End;
      Curr := ToDelete;
      ToDelete := ToDelete^.Next;
      Curr^.Next := Curr^.Next^.Next;
      Dispose(ToDelete);
      ListPanel(frmCatalog.scrBList, ShowInfo);
    End;
    UpdateC(HeaderCurrList, LastCurrList);
  End;

procedure SortByCostUp(Var Header: PDrug);
  Var
    ToDelete, Curr: PDrug;
    ShowInfo: TInfoOfDrug;
  Begin
    ClearPanels(frmCatalog.scrBList);
    While Header^.Next <> nil do
    Begin
      Curr := Header;
      ShowInfo := Curr^.Next.InfDrg;
      ToDelete := Curr;
      While Curr^.Next^.Next <> nil do
      Begin
        If Curr^.Next.InfDrg.Cost < Curr^.Next^.Next.InfDrg.Cost then
        Begin
          ShowInfo := Curr^.Next^.Next.InfDrg;
          ToDelete := Curr^.Next;
        End;
        Curr := Curr^.Next;
      End;
      Curr := ToDelete;
      ToDelete := ToDelete^.Next;
      Curr^.Next := Curr^.Next^.Next;
      Dispose(ToDelete);
      ListPanel(frmCatalog.scrBList, ShowInfo);
    End;
    UpdateC(HeaderCurrList, LastCurrList);
  End;

procedure SortByCostDown(Var Header: PDrug);
  Var
    ToDelete, Curr: PDrug;
   ShowInfo: TInfoOfDrug;
  Begin
    ClearPanels(frmCatalog.scrBList);
    While Header^.Next <> nil do
    Begin
      Curr := Header;
      ShowInfo := Curr^.Next.InfDrg;
      ToDelete := Curr;
      While Curr^.Next^.Next <> nil do
      Begin
        If Curr^.Next.InfDrg.Cost > Curr^.Next^.Next.InfDrg.Cost then
        Begin
          ShowInfo := Curr^.Next^.Next.InfDrg;
          ToDelete := Curr^.Next;
        End;
        Curr := Curr^.Next;
      End;
      Curr := ToDelete;
      ToDelete := ToDelete^.Next;
      Curr^.Next := Curr^.Next^.Next;
      Dispose(ToDelete);
      ListPanel(frmCatalog.scrBList, ShowInfo);
    End;
    UpdateC(HeaderCurrList, LastCurrList);
  End;

procedure TfrmCatalog.btnSortListClick(Sender: TObject);
  begin
    Case NumOfSort of
      1:
        SortByTitleUp(HeaderCurrList);
      2:
        SortByTitleDown(HeaderCurrList);
      3:
        SortByCategoryUp(HeaderCurrList);
      4:
        SortByCategoryDown(HeaderCurrList);
      5:
        SortByCostUp(HeaderCurrList);
      6:
        SortByCostDown(HeaderCurrList);
    End;
  end;
end.

