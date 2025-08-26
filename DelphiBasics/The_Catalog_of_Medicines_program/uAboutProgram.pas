unit uAboutProgram;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmAboutProgram = class(TForm)
    memAboutProgram: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAboutProgram: TfrmAboutProgram;

implementation

uses
  uCatalog;

{$R *.dfm}

procedure TfrmAboutProgram.FormShow(Sender: TObject);
begin

  // Load the content of the file 'AboutProgram.txt' into the memo control
  memAboutProgram.Lines.LoadFromFile('AboutProgram.txt');
end;

end.

