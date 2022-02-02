unit fPrincipal;

interface

uses
  shareMem, Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, Buttons;


type
  TfrmPrincipal = class (TForm)
    rgpOpcoes:  TRadioGroup;
    StatusBar1: TStatusBar;
    btnOk:      TBitBtn;
    btnCancela: TBitBtn;
    lbValor: TLabel;
    eTaxa: TEdit;
    lbTaxa: TLabel;
    eValor: TEdit;
    procedure btnCancelaClick (Sender: TObject);
    procedure btnOkClick (Sender: TObject);
    procedure FormClose (Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
    //** Opcoes disponiveis no menu */
    TEnumMnuOpcs: (
        MNU_CREDITO,
        MNU_DEBITO,
        MNU_PAGTO,
        MNU_CONSCDC,
        MNU_CHEQ,
        MNU_CANC,
        MNU_REIMPCOMP,
        MNU_RESVEND,
        MNU_RECCEL,
        MNU_PREAUTCRED );
  end;

var
  frmPrincipal: TfrmPrincipal;

  procedure atualizMsg (sMsg: string);

implementation

uses clTef;


{$R *.DFM}

procedure TfrmPrincipal.btnCancelaClick (Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btnOkClick (Sender: TObject);
var
  iRet:   LongInt;

begin
  // Se o SCoPE nao foi inicializado iremos faze-lo agora
  if (AbreSCoPE <> SCO_SUCESSO) then
    Exit;

  // Antes de mais nada, temos q ter uma sessao TEF iniciada
  if (AbreSessaoTEF <> SCO_SUCESSO) then
    Exit;

  { Testando com coleta pela aplicacao
    Caso se queira testar o HLAPI, comente este bloco abaixo }
  if (iSinc and INI_APLCOLET) = 0 then
  begin
    atualizMsg ('Configurando tipo de coleta ...');

    ScopeSetAplColeta;

    // Aproveitar e configurar o SCoPE.
    iRet := ScopeConfigura (CFG_CANCELAR_OPERACAO_PINPAD, 1);

    // Verificar se a aplicacao precisa abrir o PINPad
    AbrePINPad;

    iSinc := iSinc or INI_APLCOLET;
  end;

  // Inicializar os bits controladores
  iSinc := iSinc and not (ACAO_PROX + ACAO_ANTER + ACAO_CANCELAR +
              BIT6_ON + BIT7_ON + BIT8_ON + BIT9_ON);

  iRet := IniciaTransacaoTEF (rgpOpcoes.ItemIndex);

  if iRet = SCO_SUCESSO then
    iRet := FinalizaTransacaoTEF (rgpOpcoes.ItemIndex);

  if (iRet <> SCO_SUCESSO) then
    atualizMsg ( 'Pronto. Retorno do SCoPE: ' + IntToStr (iRet) );

end;

procedure TfrmPrincipal.FormClose (Sender: TObject;
  var Action: TCloseAction);
begin
  FechaSCoPE;
end;

procedure atualizMsg (sMsg: string);
begin
  frmPrincipal.StatusBar1.Panels [0].Text := sMsg;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  iSinc := 0;
end;

end.

