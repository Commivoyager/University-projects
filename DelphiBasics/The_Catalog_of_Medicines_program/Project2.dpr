program Project2;

uses
  Forms,
  uCatalog,
  uChange in 'uChange.pas' {fAdding},
  uAboutProgram in 'uAboutProgram.pas' {frmAboutProgram};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCatalog, frmCatalog);
  Application.CreateForm(TfAdding, fAdding);
  Application.CreateForm(TfrmAboutProgram, frmAboutProgram);
  Application.Run;
end.
