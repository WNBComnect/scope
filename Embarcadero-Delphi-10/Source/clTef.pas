unit clTef;

interface

uses
  shareMem, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, Buttons;

//------------------------------------------------------------------------------
// DECLARACAO DAS ESTRUTURAS
//------------------------------------------------------------------------------
type
  TEnumPP_INTERFACE = (
        PP_NAO_UTILIZA,
        PP_INTERFACE_LIB_VISA,
        PP_INTERFACE_LIB_COMPARTILHADA);


  //** Enumerador dos tipos das operadoras de celular */
  TEnumCelOperModelo = (
        REC_CEL_OPERADORAS_MODELO_1 = 1,
        REC_CEL_OPERADORAS_MODELO_2);


  { Enumerador dos tipos de estruturas retornadas
        para os valores de recarga }
  TEnumCelOperVals = (
        REC_CEL_VALORES_MODELO_1 = 1,
        REC_CEL_VALORES_MODELO_2,
        REC_CEL_VALORES_MODELO_3);


  //** dados utlizados na coleta de parametros */
  PParam_Coleta = ^TParam_Coleta;

  TParam_Coleta = packed record
    Bandeira,
    FormatoDado,
    HabTeclas:            Word;
    MsgOp1,
    MsgOp2,
    MsgCl1,
    MsgCl2:               array [1..64] of AnsiChar;
    WrkKey:               array [1..17] of AnsiChar;
    PosMasterKey:         Word;
    PAN:                  array [1..20] of AnsiChar;
    UsaCriptoPinpad,
    IdModoPagto,
    AceitaCartaoDigitado: Byte;
    Reservado:            array [1..105] of AnsiChar;
  end;


  //** Estrutura devolvida pela funcao ScopeGetLastMsg() */
  PColeta_Msg = ^TColeta_Msg;

  TColeta_Msg = packed record
    Op1,
    Op2,
    Cl1,
    Cl2:                  array [1..64] of AnsiChar;
  end;


  //** Estrutura devolvida pela funcao ScopeGetCheque() */
  PParam_Cheq = ^TParam_Cheq;

  TParam_Cheq = packed record
    Banco:      array [1..4] of AnsiChar;
    Agencia:    array [1..5] of AnsiChar;
    NumCheque,
    Valor:      array [1..13] of AnsiChar;
    BomPara:    array [1..9] of AnsiChar;
    CodAut:     array [1..11] of AnsiChar;
    Municipio:  array [1..41] of AnsiChar;
    Ordem:      SmallInt;
  end;


  //** Lista de Operadoras de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_Oper = ^TRec_Cel_Oper;

  TRec_Cel_Oper = packed record
    NumOperCel:   SmallInt;
    OperCel:      array [1..2000] of AnsiChar;
  end;


  //** Lista de Operadoras de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_ID_Oper = ^TRec_Cel_ID_Oper;

  TRec_Cel_ID_Oper = packed record
    CodOperCel:   AnsiChar;
    NomeOperCel:  array [1..21] of AnsiChar;
  end;


  //** Formato do valor para Recarga de Celular */
  PRec_Cel_Valor = ^TRec_Cel_Valor;

  TRec_Cel_Valor = packed record
    Valor,
    Bonus,
    Custo:      array [1..12] of AnsiChar;
  end;

  TRec_Cel_Faixa_Valores = packed record
    ValorMin,
    ValorMax:      array [1..12] of AnsiChar;
  end;


  //** Lista de Valores de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_Valores = ^TRec_Cel_Valores;

  TRec_Cel_Valores = packed record
    TipoValor:      AnsiChar;               { Tipo dos valores
                                          'V' - variavel(val min e val maximo)
                                          'F' - Fixo (apenas um valor fixo)
                                          'T' - Todos (tabela de valores) }
    ValorMinimo,
    ValorMaximo:    array [1..12] of AnsiChar;
    Totvalor:       AnsiChar;
    TabValores:     array [1..10] of TRec_Cel_Valor;
    MsgPromocional: array [1..41] of AnsiChar;
    TotFaixaValores: AnsiChar;
    TabFaixaValores:array [1..10] of TRec_Cel_Faixa_Valores;
  end;



{------------------------------------------------------------------------------
  DECLARACAO DE CONSTANTES GLOBAIS
------------------------------------------------------------------------------}
const
  SCO_SUCESSO:                      LongInt = $0000;

  { Codigos devolvidos pelas funcoes de acesso
    ao PIN-Pad Compartilhado }
  PC_OK:                            LongInt = 0;

  // Identificacao das redes
  R_GWCEL:                          LongInt = 90;

  {- entrada dos dados -}
  SCO_NONE:                         LongInt = $0000;
  SCO_TECLADO:                      LongInt = $0004;
  SCO_PIN_PAD:                      LongInt = $0008;
  SCO_CMC_7:                        LongInt = $0010;
  SCO_CARTAO_MAGNETICO:             LongInt = $0020;
  SCO_SCANNER:                      LongInt = $0040;

  {- parametros do ScopeOpen -}
  SCO_ERRO_PARM_1:                  LongInt = $FA01;  // Modo
  SCO_ERRO_PARM_2:                  LongInt = $FA02;  // Empresa
  SCO_ERRO_PARM_3:                  LongInt = $FA03;  // Filial
  SCO_ERRO_PARM_4:                  LongInt = $FA04;  // PDV

  {- ainda não sei para que servem estes ??? -}
  SCO_AUTO_ERRO_CRD_RLV_INVALIDO:   LongInt = $F900;
  SCO_AUTO_ERRO_CRD_TRK_INVALIDA:   LongInt = $F901;
  SCO_AUTO_ERRO_CRD_INVALIDO:       LongInt = $F902;
  SCO_AUTO_ERRO_CRD_VALIDADE:       LongInt = $F903;
  SCO_AUTO_ERRO_PARM_INVALIDO:      LongInt = $F904;

  {- erros relacionados ao windows -}
  SCO_THREAD_API_NOT_INIT:          LongInt = $FB01;
  SCO_ERRO_CRIA_SERV:               LongInt = $FB02;
  SCO_ERRO_CRITICA_MSG:             LongInt = $FB03;
  SCO_ERRO_MONTA_MSG:               LongInt = $FB04;

  {-coleta de dados -}
  SCO_PRIMEIRO_COLETA_DADOS:        LongInt = $FC00;
  SCO_COLETAR_CARTAO:               LongInt = $FC00;

  SCO_CARTAO = $FC00;
  SCO_IMPRIME_CUPOM = $FC02;
  SCO_IMPRIME_CHEQUE = $FC08;
  SCO_SENHA = $FC11;
  SCO_IMPRIME_CONSULTA  = $FC1B;
  SCO_COLETA_VALOR_RECARGA  = $FC2E;
  SCO_IMPRIME_CUPOM_PARCIAL = $FC46;
  SCO_COLETA_AUT_OU_CARTAO = $FC6C;
  SCO_COLETA_OPERADORA = $FC70;
  SCO_CARTAO_DIGITADO = $FC85;

  SCO_COLETA_CARTAO_EM_ANDAMENTO = $FCFC;
  SCO_COLETA_EM_ANDAMENTO = $FCFD;
  SCO_MOSTRA_INFO_RET_SCOPE = $FCFE; // mostra informações e retorna para scope
  SCO_MOSTRA_INFO_AGUARDA_CONF = $FCFF; // mostra informações e aguarda operador
  SCO_ULTIMO_COLETA_DADOS = $FCFF;

  SCO_TRN_EM_ANDAMENTO = $FE00;  // transação em andamento
  SCO_API_NAO_INICIALIZADA:         LongInt = $FE01;
  SCO_API_JA_INICIALIZADA:          LongInt = $FE02;
  SCO_EXISTE_TRN_SUSPENSA:          LongInt = $FE03;  // existe transação suspensa
  SCO_NAO_EXISTE_TRN_SUSPENSA:      LongInt = $FE04;  // não existe transação suspensa
  SCO_API_NAO_FEZ_TRN:              LongInt = $FE05;  //
  SCO_POS_JA_LOGADO:                LongInt = $FE06;  // Logon duplicado
  SCO_POS_NAO_CADASTRADO:           LongInt = $FE08;  // Codigo POS não cadastrado no BD
  SCO_SRV_NOT_CFG:                  LongInt = $FE09;  // serviço nao configurado

  SCO_SERVER_OFF:                   LongInt = $FF00;
  SCO_INSTITUICAO_OFF:              LongInt = $FF01;
  SCO_CANCELADA_PELO_OPERADOR:      LongInt = $FF02;
  SCO_BIN_SERV_INV:                 LongInt = $FF03; // BIN não configurado
  SCO_TRN_JA_CANCELADA:             LongInt = $FF04;
  SCO_TRN_NOT_FOUND_BD:             LongInt = $FF05;
  SCO_TRN_NAO_REVERSIVEL:           LongInt = $FF06; // transação não pode ser cancelada
  SCO_PARMS_INCOMPATIVEIS:          LongInt = $FF07; // Dados não conferem com a transação original
  SCO_ERRO_BD:                      LongInt = $FF08;
  SCO_TIMEOUT_BD:                   LongInt = $FF09;
  SCO_BD_OFFLINE:                   LongInt = $FF0A;
  SCO_ABORTADA_PELO_APLICATIVO:     LongInt = $FF0B;
  SCO_TRN_NAO_IMPLEMENTADA:         LongInt = $FF0C;
  SCO_HANDLE_INVALIDO:              LongInt = $FF0D;
  SCO_TX_SERV_INVALIDA:             LongInt = $FF0E;
  SCO_TX_SERV_EXCEDE_LIM:           LongInt = $FF0F;
  SCO_DADO_INVALIDO:                LongInt = $FF10;
  SCO_NAO_EXITE_CUPOM_VALIDO:       LongInt = $FF11;
  SCO_AREA_RESERVADA_INSUFICIENTE:  LongInt = $FF12;
  SCO_ERRO_GENERICO:                LongInt = $FFFF;

  {- Define os campos para as funcoes ScopeObtemCampo() e para ScopeObtemCampoExt() -}
  Cod_Rede:                         LongInt = $400000;

  {- Define os parametros para a funcao ScopeObtemHandle -}
  HDL_TRANSACAO_ANTERIOR:           LongInt = $0000;
  HDL_TRANSACAO_EM_ARQUIVO:         LongInt = $0008;
  HDL_TRANSACAO_EM_ANDAMENTO:       LongInt = $0009;

  {- codigos das bandeiras -}
  SCO_SCOPE:                        LongInt = $0000;
  SCO_VISA:                         LongInt = $0001;
  SCO_MASTERCARD:                   LongInt = $0002;
  SCO_AMEX:                         LongInt = $0003;
  SCO_FININCARD:                    LongInt = $0004;
  SCO_DINERS:                       LongInt = $0005;
  SCO_SOLO:                         LongInt = $0006;
  SCO_CHEQUE_ELETRONICO:            LongInt = $0007;
  SCO_REDESHOP:                     LongInt = $0008;
  SCO_ITAU:                         LongInt = $0009;
  SCO_BRADESCO:                     LongInt = $000A;
  SCO_TRISHOP_ITAU:                 LongInt = $000B;
  SCO_SERASA:                       LongInt = $000C;
  SCO_TELECHEQUE:                   LongInt = $000D;
  SCO_CREDICARD:                    LongInt = $000E;
  SCO_RVA:                          LongInt = $000F;
  SCO_TICKET:                       LongInt = $0010;
  SCO_HIPERCARD:                    LongInt = $0011;
  SCO_CNS:                          LongInt = $0012;
  SCO_CSS:                          LongInt = $0013;
  SCO_BANRISUL:                     LongInt = $0014;
  SCO_ELECTRON:                     LongInt = $0015;
  SCO_REDECARD:                     LongInt = $0016;
  SCO_JBC:                          LongInt = $0017;
  SCO_QUALITY_CARD:                 LongInt = $0018;
  SCO_UNNISA:                       LongInt = $0019;
  SCO_FININVEST:                    LongInt = $001A;

  { Bits para indicacao do estado da comunicacao c/
    o SCOPE - possiveis vals da var iSinc }
  INI_COMUNIC:                      LongInt = $0001;
  INI_SESSAO:                       LongInt = $0002;
  INI_APLCOLET:                     LongInt = $0004;

  ACAO_PROX:                        LongInt = $0008;
  ACAO_ANTER:                       LongInt = $0010;
  ACAO_CANCELAR:                    LongInt = $0020;

  COLETA_PROXIMO_ESTADO:            LongInt = 0;
	COLETA_ANTERIOR_ESTADO:           LongInt = 1;
	COLETA_CANCELAR:                  LongInt = 2;

  BIT6_ON:                          LongInt = $0040;
  BIT7_ON:                          LongInt = $0080;
  BIT8_ON:                          LongInt = $0100;
  BIT9_ON:                          LongInt = $0200;

  SCO_DESFAZ_TEF:                   Byte    = 0;
  SCO_CONFIRMA_TEF:                 Byte    = 1;

  // Funcao ScopeConfigura() - Configura a Interface Coleta do Scope
  CFG_CANCELAR_OPERACAO_PINPAD:     LongInt = 1;

{------------------------------------------------------------------------------
  DECLARACAO DE FUNCOES EXTERNAS - SCOPE
------------------------------------------------------------------------------}
  scope = 'scopeapi.dll';

  // Funcoes originais do SCOPE
  function ScopeOpen(Modo, Empresa, Filial, Pdv: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopeOpen';
  function ScopeClose: LongInt; stdcall; external scope name 'ScopeClose';
  function ScopeVersao(_Versao: PAnsiChar; _TamBufVersao: Integer): LongInt;
                stdcall; external scope name 'ScopeVersao';
  function ScopeCompraCartaoCredito (Valor, TxServico: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopeCompraCartaoCredito';
  function ScopeAbreSessaoTEF: LongInt;
                stdcall; external scope name 'ScopeAbreSessaoTEF';
  function ScopeSetAplColeta: LongInt;
                stdcall; external scope name 'ScopeSetAplColeta';
  function ScopeStatus: LongInt;
                stdcall; external scope name 'ScopeStatus';
  function ScopeGetParam (_TipoParam: LongInt;
                _lpParam: PParam_Coleta): LongInt;
                stdcall; external scope name 'ScopeGetParam';
  function ScopeResumeParam (_CodTipoColeta: LongInt; _Dados: PAnsiChar;
                _DadosParam: Word; _Acao: LongInt): LongInt;
                stdcall; external scope name 'ScopeResumeParam';
  function ScopeGetLastMsg (_ptParamColetaMsg: PColeta_Msg): LongInt;
                stdcall; external scope name 'ScopeGetLastMsg';
  function ScopeGetCheque (_ptParamCheque: PParam_Cheq): LongInt;
                stdcall; external scope name 'ScopeGetCheque';
  function ScopeGetCupomEx (_CabecLen: Word; _Cabec: PAnsiChar;
                _CupomClienteLen: Word; _CupomCliente: PAnsiChar;
                _CupomLojaLen: Word; _CupomLoja: PAnsiChar;
                _CupomReduzLen: Word; _CupomReduz: PAnsiChar;
                _NroLinhasReduz: PByte): LongInt;
                stdcall; external scope name 'ScopeGetCupomEx';
  function ScopeFechaSessaoTEF (_Acao: Byte;
                _DesfezTEFAposQuedaEnergia: PByte): LongInt;
                stdcall; external scope name 'ScopeFechaSessaoTEF';
  function ScopeConsultaCDC (_Valor, _TxServico: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopeConsultaCDC';
  function ScopeCompraCartaoDebito (Valor: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopeCompraCartaoDebito';
  function ScopeConsultaCheque (Valor: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopeConsultaCheque';
  function ScopeCancelamento (_Valor, _TxServico: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopeCancelamento';
  function ScopeReimpressaoComprovante: LongInt;
                stdcall; external scope name 'ScopeReimpressaoComprovante';
  function ScopeResumoVendas: LongInt;
                stdcall; external scope name 'ScopeResumoVendas';
  function ScopeObtemCampoExt (_Handle, _Masc, _Masc2: LongInt;
                _FieldSeparator: Byte; _Buffer: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopeObtemCampoExt';
  function ScopeObtemHandle (_Desloc: LongInt): LongInt;
                stdcall; external scope name 'ScopeObtemHandle';
  function ScopePagamento (_Servico, _CodBandeira: Word): LongInt;
                stdcall; external scope name 'ScopePagamento';
  function ScopeRecargaCelular: LongInt;
                stdcall; external scope name 'ScopeRecargaCelular';
  function ScopePreAutorizacaoCredito (_Valor, _TxServico: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopePreAutorizacaoCredito';
  function ScopeRecuperaOperadorasRecCel (_TipoTabela: Byte; _Buffer: PAnsiChar;
                _TamBuffer: Word): LongInt;
                stdcall; external scope name 'ScopeRecuperaOperadorasRecCel';
  function ScopeRecuperaValoresRecCel (_TipoTabela: Byte; _Buffer: PAnsiChar;
                _TamBuffer: Word): LongInt;
                stdcall; external scope name 'ScopeRecuperaValoresRecCel';
  function ScopeConfigura (_Id, _Param: LongInt): LongInt;
                stdcall; external scope name 'ScopeConfigura';
  function ScopeValidaInterfacePP (IntPP: Byte): LongInt;
                stdcall; external scope name 'ScopeValidaInterfacePP';
  function ScopeConsultaPP (Configurado, UsoExclusivoScope,
                Porta: PByte): LongInt;
                stdcall; external scope name 'ScopeConsultaPP';
  function ScopePPOpen (Porta: Word): LongInt;
                stdcall; external scope name 'ScopePPOpen';
  function ScopePPClose (IdleMsg: PAnsiChar): LongInt;
                stdcall; external scope name 'ScopePPClose';

  // Funcoes internas auxiliares
  function ObtemVersaoScope(_Versao: PAnsiChar): LongInt;
  function AbreSCOPE(_Empresa, _Filial, _PDV: string): LongInt;
  function AbreSessaoTEF: LongInt;
  function IniciaTransacaoTEF (iOpcMnu: Integer): LongInt;
  function FinalizaTransacaoTEF (iOpcMnu: Integer): LongInt;
  procedure FechaSessaoTEF (bAcao: Byte; bForcar: Byte = 0);
  function AbrePINPad: LongInt;
  procedure FechaPINPad;
  procedure FechaSCOPE;
  function IsConectado: Boolean;
  function ObtemDadosCupom(): string;
  function ObtemValoresRecarga(PColeta: TParam_Coleta): string;
  function ObtemOperadorasRecarga(PColeta: TParam_Coleta): string;
  function ObtemCupons(PColeta: TParam_Coleta): string;

var
  iSinc:    Integer;  //!< Indicara' se o SCOPE foi inicializado
  Conectado: Boolean;
  sBufEntr: array [1..2000] of AnsiChar;   //!< O texto digitado pelo usr

implementation

uses fPrincipal, fAux;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function ObtemVersaoScope(_Versao: PAnsiChar): LongInt;
var
  Versao : array [1..13] of AnsiChar;
  iRet : LongInt;
begin
  iRet := ScopeVersao(@Versao, 13);
  if iRet = 0 then
  begin
    StrLCopy(_Versao, @Versao, 13);
  end
  else
  begin
    showMensagemErro('Erro ao obter versão', iRet);
  end;

  Result := iRet;
end;

//------------------------------------------------------------------------------
//  Rotina para inicializacao da comunicacao com o SCOPE. As informacoes
// necessarias para a inicializacao estao implementada estaticamente.
//------------------------------------------------------------------------------
function AbreSCOPE(_Empresa, _Filial, _PDV: string): LongInt;
var
  iRet : LongInt;

begin
  iRet := SCO_SUCESSO;

  if (iSinc and INI_COMUNIC) = 0 then
  begin
    atualizMsg ('Abrindo comunicacao...');
    iRet := ScopeOpen(PAnsiChar(AnsiString('2')),
                    PAnsiChar(AnsiString(_Empresa)),
                    PAnsiChar(AnsiString(_Filial)),
                    PAnsiChar(AnsiString(_PDV)));

    if (iRet <> SCO_SUCESSO) then
      begin
        showMensagemErro('Erro na comunicacao com o SCOPESRV', iRet);
        Conectado := False;
      end
    else
      begin
        iSinc := iSinc or INI_COMUNIC;
        Conectado := True;
        atualizMsg('Conectado ao SCOPESRV');
        FechaSessaoTEF(SCO_DESFAZ_TEF, 1);
      end;
  end;

  Result := iRet;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function IsConectado: Boolean;
begin
  Result := Conectado;
end;

//------------------------------------------------------------------------------
//  Procedimento para inicializacao da comunicacao com o PPad.
//------------------------------------------------------------------------------
function AbrePINPad: LongInt;
var
  iRet:       LongInt;

  bConfig,
  bExclusivo,
  bPorta:     Byte;

begin
  iRet := SCO_SUCESSO;

  { Consulta como esta' configurado o PIN-Pad
    compartilhado no ScopeCNF }
  iRet := ScopeConsultaPP (@bConfig, @bExclusivo, @bPorta);

  if iRet <> PC_OK then
  begin
    Result := 1;
    Exit;
  end;

  if (bExclusivo = 0) then
  begin
    // Abre conexao com PINPad
    iRet := ScopePPOpen (bPorta);
    if iRet <> PC_OK then
    begin
      Result := 1;
      Exit;
    end;
  end;

  Result := SCO_SUCESSO;
end;

//------------------------------------------------------------------------------
//  Procedimento para inicializacao da comunicacao com o PPad.
//------------------------------------------------------------------------------
procedure FechaPINPad;
begin
  ScopePPClose ('SCOPE');
end;

//------------------------------------------------------------------------------
//  Procedimento para inicializacao de uma transacao.
//------------------------------------------------------------------------------
function AbreSessaoTEF: LongInt;
var
  iRet:   LongInt;

begin
  iRet := SCO_SUCESSO;

  if (iSinc and INI_SESSAO) = 0 then
  begin
    atualizMsg ('Iniciando sessao TEF...');

    iRet := ScopeAbreSessaoTEF;

    if iRet <> SCO_SUCESSO then
      showMensagemErro('Falha ao iniciar sessao de TEF', iRet)
    else
    begin
      iSinc := iSinc or INI_SESSAO;
      atualizMsg ('Sessao iniciada');
    end;
  end;

  Result := iRet;
end;

//------------------------------------------------------------------------------
//  Funcao responsavel pela execucao da funcao selecionada.
//------------------------------------------------------------------------------
function IniciaTransacaoTEF (iOpcMnu: Integer): LongInt;
var
  iRet:     LongInt;
  sValor,
  sTaxa:    string;

begin
  sValor := frmPrincipal.eValor.Text;
  sTaxa := frmPrincipal.eTaxa.Text;

  case iOpcMnu of
    Integer (MNU_CREDITO):
    begin
      atualizMsg ('Cartão de crédito');
      iRet := ScopeCompraCartaoCredito(PAnsiChar(AnsiString(sValor)), PAnsiChar(AnsiString(sTaxa)));
    end;

    Integer (MNU_DEBITO):
    begin
      atualizMsg ('Cartão de débito');
      iRet := ScopeCompraCartaoDebito ( PAnsiChar (sValor) );
    end;

    Integer (MNU_PAGTO):
    begin
      atualizMsg ('Pagamento de contas');
    { pagamento de conta.
      primeiro parametro pode ser:
        - S_PAGAMENTO_CONTA_COM_CARTAO (85)
        - S_PAGAMENTO_CONTA_SEM_CARTAO (87)
        - S_PAGAMENTO_FATURA (91)
      segundo parametro: enumerador eBandeira }
      iRet := ScopePagamento (87, 92);
    end;

    Integer (MNU_CONSCDC):
    begin
      atualizMsg ('Consulta CDC');
      iRet := ScopeConsultaCDC ( PAnsiChar (sValor), PAnsiChar (sTaxa) );
    end;

    Integer (MNU_CHEQ):
    begin
      atualizMsg('Consulta cheque');
      iRet := ScopeConsultaCheque ( PAnsiChar (sValor) );
    end;

    Integer (MNU_CANC):
    begin
      atualizMsg('Cancelamento de transação');
      iRet := ScopeCancelamento ( PAnsiChar (sValor), PAnsiChar (sTaxa) );
    end;

    Integer (MNU_REIMPCOMP):
    begin
      atualizMsg('Reimpressão de comprovante');
      iRet := ScopeReimpressaoComprovante;
    end;

    Integer (MNU_RECCEL):
    begin
      atualizMsg('Recarga de celular');
      iRet := ScopeRecargaCelular;
    end;

    Integer (MNU_RESVEND):
    begin
      atualizMsg('Resumo de vendas');
      iRet := ScopeResumoVendas;
    end;

    Integer (MNU_PREAUTCRED):
    begin
      atualizMsg('Pré-autorização de crédito');
      iRet := ScopePreAutorizacaoCredito ( PAnsiChar(sValor), PAnsiChar(sTaxa) );
    end;
  end;

  Result := iRet;
end;

//------------------------------------------------------------------------------
//  Funcao complementar aos procedimentos realizados pela IniciaTransacaoTEF ().
//  @return SCO_SUCESSO     Sucesso.
//  @return <> SCO_SUCESSO  O erro ocorrido.
//------------------------------------------------------------------------------
function FinalizaTransacaoTEF (iOpcMnu: Integer): LongInt;
var
  iRet,
  iAux:       LongInt;
  PColeta:    TParam_Coleta;
  PColetaMsg: TColeta_Msg;
  bAux:       Byte;
  sBufEntrAux: string;

label
  fEnd;

begin
  { Se estiver sendo usado o HLAPI nao precisaremos fazer o procedimento
    abaixo }
  if (iSinc and INI_APLCOLET) = 0 then
  begin
    Result := SCO_ERRO_GENERICO;
    Exit;
  end;

  repeat
    iAux := 0;
    bAux := 0;
    sBufEntrAux := '';
    FillChar(sBufEntr, length(sBufEntr) * sizeof(AnsiChar), #0);
    ZeroMemory(@PColeta, SizeOf(TParam_Coleta));

    // Enquanto a transacao estiver em andamento, aguarda
    repeat
      iRet := ScopeStatus;
      Sleep (200);
      if (iAux = 0) then
        atualizMsg ('... transacao em andamento |    -> ' + IntToStr(iRet))
      else if (iAux = 1) then
        atualizMsg ('... transacao em andamento /    -> ' + IntToStr(iRet))
      else if (iAux = 2) then
        atualizMsg ('... transacao em andamento -    -> ' + IntToStr(iRet))
      else
      begin
        atualizMsg ('... transacao em andamento \    -> ' + IntToStr(iRet));
        iAux := -1;
      end;

      iAux := iAux + 1;

      if (iRet = SCO_TRN_EM_ANDAMENTO) then
      begin
        if (iSinc and ACAO_CANCELAR) <> 0 then
        begin
          atualizMsg('Transacao cancelada');
          ScopeResumeParam(iRet, '', SCO_NONE, COLETA_CANCELAR);
          goto fEnd;
        end;
      end
      // Tratar a coleta de cartao manualmente, em paralelo c/ o PINPad
      else if (iRet = SCO_COLETA_CARTAO_EM_ANDAMENTO) then
      begin
        PColeta.HabTeclas := BIT9_ON;
        // Vejamos se o usuario digitou o cartao manualm/te
        sBufEntrAux := frmAuxParallelCtl(2, @bAux);

        if ( (bAux = 2) or (bAux = 0) ) then
        begin
          // Nao precisamos criar a janela novamente
          bAux := 1;
          if Length (sBufEntrAux) <> 0 then
          begin
            // Vamos informar o SCOPE q o cartao foi digitado
            ScopeResumeParam(iRet, '', SCO_NONE, COLETA_CANCELAR);
            Sleep (500);
          end;
        end
        else
          bAux := 0;

        if (Length (sBufEntrAux) = 0) then
          sBufEntrAux := 'Digite o numero do cartao:';
      end;

      Application.ProcessMessages;
    until (iRet <> SCO_TRN_EM_ANDAMENTO);

    if ((iRet < SCO_PRIMEIRO_COLETA_DADOS) or
        (iRet > SCO_ULTIMO_COLETA_DADOS)) then
    begin
      encerraTransacao(iRet);
      break;
    end;

    // Guardar os bits q ligamos nos passos anteriores
    iAux := PColeta.HabTeclas;

    // Obtem dados do Scope e exibe as mensagens do cliente e operador
    ScopeGetParam(iRet, @PColeta);

    // Restaurar os bits armazenados anteriorm/te
    PColeta.HabTeclas := PColeta.HabTeclas or iAux;

    // Tratamento dos estados
    case iRet of
      Integer(SCO_CARTAO), Integer(SCO_COLETA_AUT_OU_CARTAO) :
      begin
        sBufEntrAux := 'Digite o numero do cartao:';
      end;

      // imprime Cheque
      Integer(SCO_IMPRIME_CHEQUE):
      begin
        // P/ indicarmos p/ a funcao execFormAux exibir esse texto no memo
        // de exibicao
        PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;
        sBufEntrAux := ObtemDadosCupom();
        Imprime(sBufEntrAux);
      end;

      // recupera a lista de valores da Recarga de Celular
      Integer(SCO_COLETA_VALOR_RECARGA):
      begin
        sBufEntrAux := ObtemValoresRecarga(PColeta);
        PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;
        Imprime(sBufEntrAux);
      end;

      // recupera a lista de operadoras da Recarga de Celular
      Integer(SCO_COLETA_OPERADORA):
      begin
        sBufEntrAux := ObtemOperadorasRecarga(PColeta);
        PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;
        Imprime(sBufEntrAux);
      end;

      // imprime Cupom + Nota Promissoria + Cupom Promocional
      Integer(SCO_IMPRIME_CUPOM),
      Integer(SCO_IMPRIME_CUPOM_PARCIAL), // imprime Cupom Parcial
      Integer(SCO_IMPRIME_CONSULTA) : // imprime Consulta
      begin
        { P/ indicarmos p/ a funcao execFormAux exibir esse texto
        no memo de exibicao }
        PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;
        sBufEntrAux := ObtemCupons(PColeta);
        Imprime(sBufEntrAux);
      end;

      // SCOPE aguardando o cartao que foi digitado
      Integer(SCO_CARTAO_DIGITADO):
      begin
        // Vamos ver c o usr ja' digitou o texto
        sBufEntrAux := frmAuxParallelCtl (2, @bAux);
        if bAux = 0 then
        begin
          if Length (sBufEntrAux) <> 0 then
          begin
            // O texto ja' esta' em sBufEntrAux
            iAux := 0;  // Proximo estado
            bAux := 1;  // Nao podemos executar a funcao execFormAux
          end
          else
            // O usr teclou 'Cancelar' no PPad
            sBufEntrAux := 'Coleta:';
        end;
      end;

      // mostra informacao e aguarda confirmacao do usuario
      Integer(SCO_MOSTRA_INFO_RET_SCOPE):
      begin
        if Length (sBufEntrAux) = 0 then
          sBufEntrAux := 'Coleta:';
        PColeta.HabTeclas := BIT9_ON;
        iAux := 0; // Garantir o envio da acao PROXIMO ao SCOPE
      end;

      Integer(SCO_COLETA_EM_ANDAMENTO):
      begin
        bAux := 1
      end;

      // Todos os outros estados nao tratados
      else
      begin
        if Length (sBufEntrAux) = 0 then
          sBufEntrAux := 'Coleta:';
      end;
    end;

    // Exibe as msgs retornadas pelo SCOPE
    if (bAux <> 1) then
    begin
      iSinc := iSinc and not (ACAO_PROX + ACAO_ANTER + ACAO_CANCELAR);
      sBufEntrAux := execFormAux ( TrimRight ( string (PColeta.MsgOp1) ),
                                TrimRight ( string (PColeta.MsgOp2) ),
                                TrimRight ( string (PColeta.MsgCl1) ),
                                TrimRight ( string (PColeta.MsgCl2) ),
                                sBufEntrAux,
                                PColeta.HabTeclas);

      // Em qual botao o usr clicou?
      // Proximo
      if (iSinc and ACAO_PROX) <> 0 then
        iAux := COLETA_PROXIMO_ESTADO
      // Anterior
      else if (iSinc and ACAO_ANTER) <> 0 then
        iAux := COLETA_ANTERIOR_ESTADO
      // Cancelar
      else if (iSinc and ACAO_CANCELAR) <> 0 then
        iAux := COLETA_CANCELAR;
    end;

    if ( iSinc and (ACAO_PROX + ACAO_ANTER + ACAO_CANCELAR) = 0 ) then
      sBufEntrAux := '';

    iRet := ScopeResumeParam(iRet, PAnsiChar(AnsiString(sBufEntrAux)), SCO_TECLADO, iAux);

    if (iRet <> SCO_SUCESSO) then
    begin
      iAux := ScopeGetLastMsg (@PColetaMsg);
      if (iAux <> SCO_SUCESSO) then
      begin
        showMensagemErro('Erro ao obter mensagens', iRet);
        Application.MessageBox(PWideChar('ERRO NO ScopeGetLastMsg() = ' + IntToStr(iRet)), 'TEF', MB_OK);
      end;

      // Se o erro for de dado invalido, vamos permitir o usuario tentar novamente
      if (iRet <> SCO_DADO_INVALIDO) then
        break
      else
        continue;

      execFormAux ( TrimRight ( string (PColeta.MsgOp1) ),
                    TrimRight ( string (PColeta.MsgOp2) ),
                    TrimRight ( string (PColeta.MsgCl1) ),
                    TrimRight ( string (PColeta.MsgCl2) ),
                    'Coleta:',
                    2);
    end;
  until ((iRet < SCO_PRIMEIRO_COLETA_DADOS) and
          (iRet > SCO_ULTIMO_COLETA_DADOS));

fEnd:
  sBufEntrAux := execFormAux ('Confirmar essa transacao? (1/0)',
                                      '', '', '', 'Opcao', 2);

  if ((Length(sBufEntrAux) = 0) or (StrToInt (sBufEntrAux) <> 0)) then
    bAux := SCO_CONFIRMA_TEF
  else
    bAux := SCO_DESFAZ_TEF;
  FechaSessaoTEF (bAux);

  Result := iRet;
end;

//------------------------------------------------------------------------------
//  Realiza o procedimento para termino de uma sessao TEF. Basicamente essa
// funcao desfara' todos os passos realizados na funcao AbreSessaoTEF().
// @param  bAcao  A acao 'a ser realizada:
//                  - SCO_CONFIRMA_TEF: confirma a transacao.
//                  - SCO_DESFAZ_TEF: desfaz a transacao.
// @param  bForcar Para forcar o fechamento da sessao.
//------------------------------------------------------------------------------
procedure FechaSessaoTEF (bAcao: Byte; bForcar: Byte = 0);
var
  bAux:   Byte;
  iRet:   LongInt;

begin
  if (((iSinc and INI_SESSAO) <> 0 ) or (bForcar = 1)) then
  begin
    iRet := ScopeFechaSessaoTEF (bAcao, @bAux);

    if (iRet = SCO_SUCESSO) then
    begin
    if (bAux = 1) then
      atualizMsg('Transacao anterior desfeita.');
      iSinc := iSinc and not INI_SESSAO;
    end
    else
      showMensagemErro('Erro no fechamento da sessão', iRet);
  end;
end;

//------------------------------------------------------------------------------
//  Procedimento para finalizacao da comunicao com o servidor SCOPE.
//------------------------------------------------------------------------------
procedure FechaSCOPE;
var
  iRet:   LongInt;

begin
  FechaPINPad;
  if (iSinc and INI_COMUNIC) <> 0 then
  begin
    iRet := ScopeClose;

    if iRet <> SCO_SUCESSO then
    begin
      atualizMsg ('Comunicacao encerrada.');
      iSinc := iSinc and not INI_COMUNIC;
    end
    else
      showMensagemErro('Erro ao encerrar comunicação', iRet);
  end;
end;

//------------------------------------------------------------------------------
//  Procedimento para obter os dados do cheque para impressao
//------------------------------------------------------------------------------
function ObtemDadosCupom(): string;
var
  Retorno: LongInt;
  PCheque: TParam_Cheq;
  Dados: string;
begin
  Retorno := ScopeGetCheque(@PCheque);
  if (Retorno = SCO_SUCESSO) then
  begin
    Dados :=
        'Banco = ' + TrimRight(string(PCheque.Banco)) + #10 +
        'Agencia = ' + TrimRight(string(PCheque.Agencia)) + #10 +
        'Numero do cheque = ' + TrimRight(string(PCheque.NumCheque)) + #10 +
        'Valor = ' + TrimRight(string(PCheque.Valor)) + #10 +
        'Bom para = ' + TrimRight(string(PCheque.BomPara)) + #10 +
        'Codigo da autorizadora = ' + TrimRight(string(PCheque.CodAut)) + #10 +
        'Municipio = ' + TrimRight(string(PCheque.Municipio)) + #10;
  end
  else
    Dados := 'Erro ao obter dados do cheque para impressão. -> ' +
          IntToStr(Retorno) + #10;
  Result := Dados;
end;

//------------------------------------------------------------------------------
//  Obtem os valores de recarga disponiveis
//------------------------------------------------------------------------------
function ObtemValoresRecarga(PColeta: TParam_Coleta): string;
var
  iRet,
  iAux:       LongInt;
  eTipoVal:   TEnumCelOperVals;
  Cabec:      array [1..1024] of AnsiChar;
  PLstVals:   TRec_Cel_Valores;
  BufValores: string;

begin
  eTipoVal := REC_CEL_VALORES_MODELO_2;
  iAux := ScopeObtemHandle(HDL_TRANSACAO_EM_ANDAMENTO);
  if (iAux > $FFFF) then
  begin
    ScopeObtemCampoExt(iAux, Cod_Rede, $00, 0, PAnsiChar(@Cabec));
    // Verifica se a rede é GWCel
    if (StrToInt(TrimRight(string(Cabec))) = R_GWCEL) then
      eTipoVal := REC_CEL_VALORES_MODELO_3;
  end;

  iAux := ScopeRecuperaValoresRecCel(Byte(eTipoVal), @PLstVals, SizeOf(TRec_Cel_Valores));

  if (iAux = SCO_SUCESSO) then
  begin
    PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;

    BufValores := 'Informacoes dos valores disponiveis:' + #10 + #10 +
                'Tipo de valor ';

    if PLstVals.TipoValor = 'V' then
      BufValores := BufValores + 'variavel'
    else if PLstVals.TipoValor = 'F' then
      BufValores := BufValores + 'fixo'
    else
      BufValores := BufValores + 'fixo ou variavel';

    BufValores := BufValores + #10 + 'Valor minimo de recarga: ' +
                          TrimRight ( string (PLstVals.ValorMinimo) );

    BufValores := BufValores + #10 + 'Valor maximo de recarga: ' +
                          TrimRight ( string (PLstVals.ValorMaximo) );

    BufValores := BufValores + #10 + 'Quantidade total: ' +
                                IntToStr ( Integer (PLstVals.Totvalor) );

    for iAux := 1 to Integer (PLstVals.Totvalor) do
    begin
      BufValores := BufValores + #10 +
                  '  Valor: ' + TrimRight ( string (PLstVals.TabValores [iAux].Valor) ) +
                  ' Bonus: ' + TrimRight ( string (PLstVals.TabValores [iAux].Bonus) ) +
                  ' Custo: ' + TrimRight ( string (PLstVals.TabValores [iAux].Custo) );
    end;

    BufValores := BufValores + #10 + #10 + 'Mensagem promocional: ' +
                      TrimRight ( string (PLstVals.MsgPromocional) ) + #10;

    if ( (eTipoVal = REC_CEL_VALORES_MODELO_3) and
              (Integer (PLstVals.TotFaixaValores) > 0) ) then
    begin
      for iAux := 1 to Integer (PLstVals.TotFaixaValores) do
      begin
        BufValores := BufValores + #10 +
                    '  Valor Minimo = : ' + TrimRight ( string (PLstVals.TabFaixaValores [iAux].ValorMin) ) +
                    ' Valor Maximo: ' + TrimRight ( string (PLstVals.TabFaixaValores [iAux].ValorMax) );
      end;
    end;
  end;
  Result := BufValores;
end;

//------------------------------------------------------------------------------
//  Obtem as operadoras de recarga disponiveis
//------------------------------------------------------------------------------
function ObtemOperadorasRecarga(PColeta: TParam_Coleta): string;
var
  iAux: LongInt;
  BufOperadoras: string;
  PRecOper: TRec_Cel_Oper;
  PRecIDOper: TRec_Cel_ID_Oper;

begin
  // recuperar as operadoras
  iAux := ScopeRecuperaOperadorasRecCel
       (Byte(REC_CEL_OPERADORAS_MODELO_2), @PRecOper, SizeOf(TRec_Cel_Oper));

  if (iAux = SCO_SUCESSO) then
  begin
    BufOperadoras := '----- OPERADORAS DISPONIVEIS -----' + #10;
    BufOperadoras := BufOperadoras + 'QUANTIDADE: ' +
                      IntToStr(PRecOper.NumOperCel) + ' operadoras';
    { Exibe as operadoras: a listagem esta' dividida de acordo
      com o record TRec_Cel_ID_Oper. Entao a logica p/ a recuperacao
      das infos deve ser ... }
    for iAux := 0 to PRecOper.NumOperCel do
    begin
      CopyMemory(@PRecIDOper,
                  @PRecOper.OperCel[iAux * SizeOf(TRec_Cel_ID_Oper) + 1],
                  SizeOf(TRec_Cel_ID_Oper));
      BufOperadoras := BufOperadoras + #10 +
                      IntToStr(Integer(PRecIDOper.CodOperCel)) + ' : ' +
                      TrimRight(string(PRecIDOper.NomeOperCel));
    end;

    BufOperadoras := BufOperadoras + #10;
  end;
  Result := BufOperadoras;
end;

//------------------------------------------------------------------------------
//  Obtem as operadoras de recarga disponiveis
//------------------------------------------------------------------------------
function ObtemCupons(PColeta: TParam_Coleta): string;
var
  Retorno: LongInt;
  Cabec:      array [1..1024] of AnsiChar;
  CpCliente,
  CpLoja,
  CpReduzido: array [1..2048] of AnsiChar;
  NumeroLinhasReduzido: Byte;
  BufCupom: string;

begin
  ZeroMemory(@Cabec, SizeOf(Cabec));
  ZeroMemory(@CpCliente, SizeOf(CpCliente));
  ZeroMemory(@CpLoja, SizeOf(CpLoja));
  ZeroMemory(@CpReduzido, SizeOf(CpReduzido));
  Retorno := ScopeGetCupomEx(SizeOf (Cabec), @Cabec,
                    SizeOf(CpCliente), @CpCliente,
                    SizeOf(CpLoja), @CpLoja,
                    SizeOf(CpReduzido), @CpReduzido, @NumeroLinhasReduzido);

  if (Retorno = SCO_SUCESSO) then
  begin
    BufCupom := '>>............  CABECALHO ............<<' + #10 + TrimRight(string(Cabec)) + #10 + #10 +
                '>>......... CUPOM DO CLIENTE .........<<' + #10 + TrimRight(string(CpCliente)) + #10 + #10 +
                '>>......... CUPOM DA LOJA ............<<' + #10 + TrimRight(string(CpLoja)) + #10 + #10;

    if (NumeroLinhasReduzido > 0) then
      BufCupom := BufCupom +
                '>>......... CUPOM REDUZIDO ...........<<' + #10 + TrimRight(string(CpReduzido)) + #10;
    NumeroLinhasReduzido := 0;
  end
  else
  begin
    BufCupom := 'Erro ScopeGetCupomEx: ' + IntToStr (Retorno) + #10;
    showMensagemErro('Erro ao obter cupons de TEF', Retorno);
  end;
  Result := BufCupom;
end;
end.

