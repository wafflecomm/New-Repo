program KeyGen;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  uKeyGen in 'uKeyGen.pas',
  uKeyCheck in 'uKeyCheck.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Key Generate for Product of Waffle Comm.';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
