program Tef;

uses
  shareMem,
  Forms,
  fPrincipal in 'fPrincipal.pas' {frmPrincipal},
  clTef in 'clTef.pas',
  fAux in 'fAux.pas' {frmAux};


{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmAux, frmAux);
  Application.Run;
end.
