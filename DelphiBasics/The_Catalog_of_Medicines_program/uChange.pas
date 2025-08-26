unit uChange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfAdding = class(TForm)
    lblTitle: TLabel;
    edtTitle: TEdit;
    lblDescription: TLabel;
    memDescription: TMemo;
    lblCost: TLabel;
    edtCost: TEdit;
    btnAddInCatalog: TButton;
    lblCategory: TLabel;
    edtCategory: TEdit;
    btnClear: TButton;
    btnEditInCatalog: TButton;
    procedure btnAddInCatalogClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnEditInCatalogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAdding: TfAdding;

implementation

uses
  uCatalog;

{$R *.dfm}

// Type declaration section
type
  NewDrugInfo = record
    Title: String[50];
    Info: String[250];
    Category: String[50];
    Cost: Real;
  end;

procedure TfAdding.btnAddInCatalogClick(Sender: TObject);
var
  NewDrug: NewDrugInfo;
  InfoFile: File of NewDrugInfo;
begin
  AssignFile(InfoFile, 'CatalogInfo.txt');
  Reset(InfoFile);
  Seek(InfoFile, FileSize(InfoFile));
  btnAddInCatalog.Tag := 0;
  
  // Check if all fields are filled
  if (edtTitle.Text = '') or (memDescription.Text = '') or (edtCategory.Text = '') or (edtCost.Text = '') then
    ShowMessage('All fields must be filled!')
  else
  begin

    // Fill NewDrug record with input values
    NewDrug.Title := edtTitle.Text;
    NewDrug.Info := memDescription.Text;
    NewDrug.Category := edtCategory.Text;
    NewDrug.Cost := StrToFloat(edtCost.Text);

    // Write NewDrug record to InfoFile
    Write(InfoFile, NewDrug);
    btnAddInCatalog.Tag := 1;
    
    // Clear input fields
    edtTitle.Clear;
    memDescription.Clear;
    edtCategory.Clear;
    edtCost.Clear;

    // Close the form
    fAdding.Close;
  end;
  CloseFile(InfoFile);
end;

procedure TfAdding.btnClearClick(Sender: TObject);
begin

  // Clear all input fields
  edtTitle.Clear;
  memDescription.Clear;
  edtCategory.Clear;
  edtCost.Clear;
end;

procedure TfAdding.btnEditInCatalogClick(Sender: TObject);
var
  NewDrug: NewDrugInfo;
  InfoFile: File of NewDrugInfo;
begin
  AssignFile(InfoFile, 'CatalogInfo.txt');
  Reset(InfoFile);
  Seek(InfoFile, FileSize(InfoFile));
  btnAddInCatalog.Tag := 0;
  
  // Check if title and description fields are filled
  if (edtTitle.Text = '') or (memDescription.Text = '') then
    ShowMessage('Title and description cannot be empty!')
  else
  begin

    // Fill NewDrug record with input values
    NewDrug.Title := edtTitle.Text;
    NewDrug.Info := memDescription.Text;
    NewDrug.Category := edtCategory.Text;
    NewDrug.Cost := StrToFloat(edtCost.Text);
    
    // Write NewDrug record to InfoFile
    Write(InfoFile, NewDrug);
    btnAddInCatalog.Tag := 1;
    
    // Clear input fields
    edtTitle.Clear;
    memDescription.Clear;
    edtCategory.Clear;
    edtCost.Clear;
    
    // Close the form
    fAdding.Close;
  end;
  CloseFile(InfoFile);
end;

end.

