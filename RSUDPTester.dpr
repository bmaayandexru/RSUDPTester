program RSUDPTester;

uses
  Vcl.Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  UfrmTraffic1 in 'UfrmTraffic1.pas' {frmTraffic1},
  bmaTools in '..\bmaTools\bmaTools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTraffic1, frmTraffic1);
  Application.Run;
end.
