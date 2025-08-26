program Lab1;

uses
  Forms,
  uMain in 'uMain.pas' {frmGame},
  uMzGeneration in 'uMzGeneration.pas',
  uModel in 'uModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGame, frmGame);
  Application.Run;
end.
