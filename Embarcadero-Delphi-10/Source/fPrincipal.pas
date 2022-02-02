unit fPrincipal;

interface

uses
  shareMem, Windows, Messages, SysUtils, Classes, Graphics, Controls, StrUtils,
  Forms, Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, Buttons, Vcl.ToolWin;


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
    GroupBox1: TGroupBox;
    Button1: TButton;
    Impressora: TMemo;
    ProgressBar: TProgressBar;
    procedure btnCancelaClick (Sender: TObject);
    procedure btnOkClick (Sender: TObject);
    procedure FormClose (Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rgpOpcoesClick(Sender: TObject);
    procedure setEmProcessamento(Desabilita: Boolean);

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
  Empresa: string;
  Filial: string;
  PDV: string;

  procedure atualizMsg (sMsg: string);
  procedure showMensagemErro(sMsg: string; erro: LongInt);
  procedure encerraTransacao(erro: LongInt);
  procedure Imprime(sEntr: string);
  procedure LimpaImpressora();
implementation

uses clTef;


{$R *.DFM}

//------------------------------------------------------------------------------
//  Fecha a aplicacao
//------------------------------------------------------------------------------
procedure TfrmPrincipal.btnCancelaClick (Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//  Iniciar a transacao
//------------------------------------------------------------------------------
procedure TfrmPrincipal.btnOkClick (Sender: TObject);
var
  iRet:   LongInt;

begin
  if IsConectado() = False then
  begin
    // Se o SCOPE nao foi inicializado iremos faze-lo agora
    if (AbreSCOPE(Empresa, Filial, PDV) <> SCO_SUCESSO) then
      Exit;
  end;

  // Antes de mais nada, temos q ter uma sessao TEF iniciada
  if (AbreSessaoTEF <> SCO_SUCESSO) then
    Exit;

  { Testando com coleta pela aplicacao
    Caso se queira testar o HLAPI, comente este bloco abaixo }
  if (iSinc and INI_APLCOLET) = 0 then
  begin
    atualizMsg ('Configurando tipo de coleta ...');

    ScopeSetAplColeta;

    // Aproveitar e configurar o SCOPE.
    ScopeConfigura(CFG_CANCELAR_OPERACAO_PINPAD, 1);

    // Verificar se a aplicacao precisa abrir o PINPad
    AbrePINPad;

    iSinc := iSinc or INI_APLCOLET;
  end;

  // Inicializar os bits controladores
  iSinc := iSinc and not (ACAO_PROX + ACAO_ANTER + ACAO_CANCELAR +
              BIT6_ON + BIT7_ON + BIT8_ON + BIT9_ON);

  setEmProcessamento(True);
  iRet := IniciaTransacaoTEF (rgpOpcoes.ItemIndex);

  if iRet = SCO_SUCESSO then
  begin
    iRet := FinalizaTransacaoTEF (rgpOpcoes.ItemIndex);
  end;
  setEmProcessamento(False);

  if (iRet <> SCO_SUCESSO) then
    showMensagemErro('Transação encerrada.', iRet);

end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  Impressora.Text := '';
end;

//------------------------------------------------------------------------------
//  Encerra a aplicacao
//------------------------------------------------------------------------------
procedure TfrmPrincipal.FormClose (Sender: TObject;
  var Action: TCloseAction);
begin
  FechaSCOPE;
end;

//------------------------------------------------------------------------------
//  Exibe uma mensagem
//------------------------------------------------------------------------------
procedure atualizMsg (sMsg: string);
begin
  LimpaImpressora;
end;

//------------------------------------------------------------------------------
//  Exibe uma mensagem de erro com código
//------------------------------------------------------------------------------
procedure showMensagemErro(sMsg: string; erro: LongInt);
begin
  frmPrincipal.StatusBar1.Panels [0].Text := sMsg + ' -> Erro= ' + IntToStr(erro);
end;

//------------------------------------------------------------------------------
//  Indica que a transação foi encerrada
//------------------------------------------------------------------------------
procedure encerraTransacao(erro: LongInt);
begin
  if (erro = SCO_SUCESSO) then
    atualizMsg('Transacao completa')
  else
    showMensagemErro('Transacao completa com erro', erro);
end;

//------------------------------------------------------------------------------
//  Esvazia a impressora
//------------------------------------------------------------------------------
procedure LimpaImpressora();
begin
  frmPrincipal.StatusBar1.Panels [0].Text := '';
end;

//------------------------------------------------------------------------------
//  Exibe uma mensagem
//------------------------------------------------------------------------------
procedure Imprime(sEntr: string);
var
  sStr:   string;
  iPos,
  iTam,
  iIni:   LongInt;
begin
  iPos := 1;
  iIni := 1;
  iTam := 1;

  //Cada CR encontrado na string passada sera' 1 linha no memo de exibicao
  while (iPos - 1) < Length(sEntr) do
  begin
    if sEntr[iPos] = #10 then
    begin
      sStr := MidStr(sEntr, iIni, iTam - 1);
      frmPrincipal.Impressora.Lines.Add(sStr);

      iIni := iPos + 1;
      iTam := 0;
      sStr := '';
    end;

    iPos := iPos + 1;

    // Pular os caracteres nulos
    if iPos >= Length (sEntr) then
      break
    else
      iTam := iTam + 1;
  end;
  frmPrincipal.Impressora.Lines.Add('');
  frmPrincipal.Impressora.Lines.Add('----------------------------------------');
  frmPrincipal.Impressora.Lines.Add('');

end;

//------------------------------------------------------------------------------
//  Procedimento que executa ao iniciar a aplicacao
//------------------------------------------------------------------------------
procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  Versao : array [1..13] of AnsiChar;
begin
  Impressora.Text := '';
  if ParamCount <> 3 then
  begin
    Empresa := '0001';
    Filial := '0001';
    PDV := '001';
  end
  else
  begin
    Empresa := ParamStr(1);
    Filial := ParamStr(2);
    PDV := ParamStr(3);
  end;
  ObtemVersaoScope(@Versao);
  frmPrincipal.Caption := 'HotKey Delphi - modo COLETA (' + Empresa + '/' +
          Filial + '/' + PDV + ') - ' + string(Versao);
  AbreSCOPE(Empresa, Filial, PDV);
  iSinc := 0;
end;

//------------------------------------------------------------------------------
//  Atualiza GUI
//------------------------------------------------------------------------------
procedure TfrmPrincipal.rgpOpcoesClick(Sender: TObject);
var
  EnableValor : Boolean;
  EnableTaxa : Boolean;

begin
  EnableValor := True;
  EnableTaxa := False;
  case rgpOpcoes.ItemIndex of
    Integer (MNU_CREDITO):
    begin

    end;

    Integer (MNU_DEBITO):
    begin

    end;

    Integer (MNU_PAGTO):
    begin

    end;

    Integer (MNU_CONSCDC):
    begin

    end;

    Integer (MNU_CHEQ):
    begin

    end;

    Integer (MNU_CANC):
    begin

    end;

    Integer (MNU_REIMPCOMP):
    begin
      EnableValor := False;
    end;

    Integer (MNU_RECCEL):
    begin
      EnableValor := False;
    end;

    Integer (MNU_RESVEND):
    begin
      EnableValor := False;
    end;

    Integer (MNU_PREAUTCRED):
    begin

    end;
  end;
  eValor.Enabled := EnableValor;
  eTaxa.Enabled := EnableTaxa;

end;

procedure TfrmPrincipal.setEmProcessamento(Desabilita: Boolean);
begin
  rgpOpcoes.Enabled := Not Desabilita;
  btnOk.Enabled := Not Desabilita;
  btnCancela.Enabled := Not Desabilita;
end;

end.

