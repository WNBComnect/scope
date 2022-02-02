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
    MsgCl2:               array [1..64] of Char;
    WrkKey:               array [1..17] of Char;
    PosMasterKey:         Word;
    PAN:                  array [1..20] of Char;
    UsaCriptoPinpad,
    IdModoPagto,
    AceitaCartaoDigitado: Byte;
    Reservado:            array [1..105] of Char;
  end;


  //** Estrutura devolvida pela funcao ScopeGetLastMsg() */
  PColeta_Msg = ^TColeta_Msg;

  TColeta_Msg = packed record
    Op1,
    Op2,
    Cl1,
    Cl2:                  array [1..64] of Char;
  end;


  //** Estrutura devolvida pela funcao ScopeGetCheque() */
  PParam_Cheq = ^TParam_Cheq;

  TParam_Cheq = packed record
    Banco:      array [1..4] of Char;
    Agencia:    array [1..5] of Char;
    NumCheque,
    Valor:      array [1..13] of Char;
    BomPara:    array [1..9] of Char;
    CodAut:     array [1..11] of Char;
    Municipio:  array [1..41] of Char;
    Ordem:      SmallInt;
  end;


  //** Lista de Operadoras de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_Oper = ^TRec_Cel_Oper;

  TRec_Cel_Oper = packed record
    NumOperCel:   SmallInt;
    OperCel:      array [1..2000] of Char;
  end;


  //** Lista de Operadoras de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_ID_Oper = ^TRec_Cel_ID_Oper;

  TRec_Cel_ID_Oper = packed record
    CodOperCel:   Char;
    NomeOperCel:  array [1..21] of Char;
  end;


  //** Formato do valor para Recarga de Celular */
  PRec_Cel_Valor = ^TRec_Cel_Valor;

  TRec_Cel_Valor = packed record
    Valor,
    Bonus,
    Custo:      array [1..12] of Char;
  end;

  TRec_Cel_Faixa_Valores = packed record
    ValorMin,
    ValorMax:      array [1..12] of Char;
  end;


  //** Lista de Valores de Recarga de Celular retornadas pelo Servidor */
  PRec_Cel_Valores = ^TRec_Cel_Valores;

  TRec_Cel_Valores = packed record
    TipoValor:      Char;               { Tipo dos valores
                                          'V' - variavel(val min e val maximo)
                                          'F' - Fixo (apenas um valor fixo)
                                          'T' - Todos (tabela de valores) }
    ValorMinimo,
    ValorMaximo:    array [1..12] of Char;
    Totvalor:       Char;
    TabValores:     array [1..10] of TRec_Cel_Valor;
    MsgPromocional: array [1..41] of Char;
    TotFaixaValores:Char;
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

  SCO_CARTAO:                       LongInt = $FC00;
  SCO_IMPRIME_CUPOM:                LongInt = $FC02;
  SCO_IMPRIME_CHEQUE:               LongInt = $FC08;
  SCO_SENHA:                        LongInt = $FC11;
  SCO_IMPRIME_CONSULTA:             LongInt = $FC1B;
  SCO_COLETA_VALOR_RECARGA:         LongInt = $FC2E;
  SCO_IMPRIME_CUPOM_PARCIAL:        LongInt = $FC46;
  SCO_COLETA_AUT_OU_CARTAO:         LongInt = $FC6C;
  SCO_COLETA_OPERADORA:             LongInt = $FC70;
  SCO_CARTAO_DIGITADO:              LongInt = $FC85;

  SCO_COLETA_CARTAO_EM_ANDAMENTO:   LongInt = $FCFC;
  SCO_COLETA_EM_ANDAMENTO:          LongInt = $FCFD;
  SCO_MOSTRA_INFO_RET_SCOPE:        LongInt = $FCFE; // mostra informações e retorna para scope
  SCO_MOSTRA_INFO_AGUARDA_CONF:     LongInt = $FCFF; // mostra informações e aguarda operador
  SCO_ULTIMO_COLETA_DADOS:          LongInt = $FCFF;

  SCO_TRN_EM_ANDAMENTO:             LongInt = $FE00;  // transação em andamento
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
    o SCoPE - possiveis vals da var iSinc }
  INI_COMUNIC:                      LongInt = $0001;
  INI_SESSAO:                       LongInt = $0002;
  INI_APLCOLET:                     LongInt = $0004;

  ACAO_PROX:                        LongInt = $0008;
  ACAO_ANTER:                       LongInt = $0010;
  ACAO_CANCELAR:                    LongInt = $0020;

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

  // Funcoes originais do SCoPE
  function ScopeOpen (Modo, Empresa, Filial, Pdv: PChar): LongInt; stdcall;
                                                external scope name 'ScopeOpen';
  function ScopeClose: LongInt; stdcall; external scope name 'ScopeClose';
  function ScopeCompraCartaoCredito (Valor, TxServico: PChar): LongInt; stdcall;
                                external scope name 'ScopeCompraCartaoCredito';
  function ScopeAbreSessaoTEF: LongInt; stdcall; external scope
                                                      name 'ScopeAbreSessaoTEF';
  function ScopeSetAplColeta: LongInt; stdcall; external scope
                                                      name 'ScopeSetAplColeta';
  function ScopeStatus: LongInt; stdcall; external scope
                                                      name 'ScopeStatus';
  function ScopeGetParam (_TipoParam: LongInt;
                            _lpParam: PParam_Coleta): LongInt; stdcall;
                                          external scope name 'ScopeGetParam';
  function ScopeResumeParam (_CodTipoColeta: LongInt; _Dados: PChar;
                                  _DadosParam: Word; _Acao: LongInt): LongInt;
                              stdcall; external scope name 'ScopeResumeParam';
  function ScopeGetLastMsg (_ptParamColetaMsg: PColeta_Msg): LongInt;
                                stdcall; external scope name 'ScopeGetLastMsg';
  function ScopeGetCheque (_ptParamCheque: PParam_Cheq): LongInt;
                                stdcall; external scope name 'ScopeGetCheque';
  function ScopeGetCupomEx (_CabecLen: Word; _Cabec: PChar;
                              _CupomClienteLen: Word; _CupomCliente: PChar;
                                      _CupomLojaLen: Word; _CupomLoja: PChar;
              _CupomReduzLen: Word; _CupomReduz: PChar; _NroLinhasReduz: PByte):
                       LongInt; stdcall; external scope name 'ScopeGetCupomEx';
  function ScopeFechaSessaoTEF (_Acao: Byte; _DesfezTEFAposQuedaEnergia: PByte):
                                                LongInt; stdcall; external scope
                                                    name 'ScopeFechaSessaoTEF';
  function ScopeConsultaCDC (_Valor, _TxServico: PChar): LongInt;
                              stdcall; external scope name 'ScopeConsultaCDC';
  function ScopeCompraCartaoDebito (Valor: PChar): LongInt; stdcall;
                                external scope name 'ScopeCompraCartaoDebito';
  function ScopeConsultaCheque (Valor: PChar): LongInt; stdcall;
                                external scope name 'ScopeConsultaCheque';
  function ScopeCancelamento (_Valor, _TxServico: PChar): LongInt;
                              stdcall; external scope name 'ScopeCancelamento';
  function ScopeReimpressaoComprovante: LongInt; stdcall;
                            external scope name 'ScopeReimpressaoComprovante';
  function ScopeResumoVendas: LongInt; stdcall; external scope
                                                      name 'ScopeResumoVendas';
  function ScopeObtemCampoExt (_Handle, _Masc, _Masc2: LongInt;
                     _FieldSeparator: Byte; _Buffer: PChar): LongInt; stdcall;
                                      external scope name 'ScopeObtemCampoExt';
  function ScopeObtemHandle (_Desloc: LongInt): LongInt;
                              stdcall; external scope name 'ScopeObtemHandle';
  function ScopePagamento (_Servico, _CodBandeira: Word): LongInt;
                              stdcall; external scope name 'ScopePagamento';
  function ScopeRecargaCelular: LongInt; stdcall; external scope
                                                    name 'ScopeRecargaCelular';
  function ScopePreAutorizacaoCredito (_Valor, _TxServico: PChar): LongInt;
                      stdcall; external scope name 'ScopePreAutorizacaoCredito';
  function ScopeRecuperaOperadorasRecCel (_TipoTabela: Byte; _Buffer: PChar;
                                          _TamBuffer: Word): LongInt; stdcall;
                            external scope name 'ScopeRecuperaOperadorasRecCel';
  function ScopeRecuperaValoresRecCel (_TipoTabela: Byte; _Buffer: PChar;
                                          _TamBuffer: Word): LongInt; stdcall;
                            external scope name 'ScopeRecuperaValoresRecCel';
  function ScopeConfigura (_Id, _Param: LongInt): LongInt;
                            stdcall; external scope name 'ScopeConfigura';

  function ScopeValidaInterfacePP (IntPP: Byte): LongInt; stdcall;
                          external scope name 'ScopeValidaInterfacePP';
  function ScopeConsultaPP (Configurado, UsoExclusivoScope, Porta: PByte):
                    LongInt; stdcall; external scope name 'ScopeConsultaPP';
  function ScopePPOpen (Porta: Word): LongInt; stdcall;
                                      external scope name 'ScopePPOpen';
  function ScopePPClose (IdleMsg: PChar): LongInt; stdcall;
                                      external scope name 'ScopePPClose';

  // Funcoes internas auxiliares
  function AbreSCoPE: LongInt;
  function AbreSessaoTEF: LongInt;
  function IniciaTransacaoTEF (iOpcMnu: Integer): LongInt;
  function FinalizaTransacaoTEF (iOpcMnu: Integer): LongInt;
  procedure FechaSessaoTEF (bAcao: Byte; bForcar: Byte = 0);
  function AbrePINPad: LongInt;
  procedure FechaPINPad;
  procedure FechaSCoPE;

var
  iSinc:    Integer;  //!< Indicara' se o SCoPE foi inicializado

  sBufEntr: string;   //!< O texto digitado pelo usr

implementation

uses fPrincipal, fAux;

{
  Rotina para inicializacao da comunicacao com o SCoPE.
  As informacoes necessarias para a inicializacao esta'
  implementada estaticam/te.

  @return SCO_SUCESSO     Sucesso.
  @return <> SCO_SUCESSO  O erro ocorrido.
}

function AbreSCoPE: LongInt;
var
  iRet            : LongInt;
  sModo,
  sEmpresa,
  sFilial,
  sPDV            : string;

begin
  iRet := SCO_SUCESSO;

  sModo := '2';
  sEmpresa := '0001';
  sFilial := '0001';
  sPDV := '001';

  if (iSinc and INI_COMUNIC) = 0 then
  begin
    atualizMsg ('Abrindo comunicacao...');

    iRet := ScopeOpen ( PChar(sModo), PChar (sEmpresa),
                                PChar (sFilial), PChar (sPDV) );

    if (iRet <> SCO_SUCESSO) then
      atualizMsg ('Erro na comunicacao com o SCoPE...')
    else
    begin
      iSinc := iSinc or INI_COMUNIC;

      atualizMsg ('Comunicando.');

    end;

    FechaSessaoTEF (SCO_DESFAZ_TEF, 1);

  end;

  Result := iRet;
end;


{
  Procedimento para inicializacao da comunicacao com o PPad.

  @return SCO_SUCESSO     Sucesso.
  @return <> SCO_SUCESSO  O erro ocorrido.
}

function AbrePINPad: LongInt;
var
  iRet:       LongInt;

  bConfig,
  bExclusivo,
  bPorta:     Byte;

begin
  iRet := SCO_SUCESSO;

  ScopeValidaInterfacePP ( Byte (PP_INTERFACE_LIB_COMPARTILHADA) );

  { Consulta como esta' configurado o PIN-Pad
    compartilhado no ScopeCNF }
  iRet := ScopeConsultaPP (@bConfig, @bExclusivo, @bPorta);

  if iRet <> PC_OK then
  begin
    Result := 1;
    Exit;
  end;

  if ( (bConfig = 1) and (bExclusivo = 0) ) then
  begin
  { Abre conexao com PINPad }
    iRet := ScopePPOpen (bPorta);

    if iRet <> PC_OK then
    begin
      Result := 1;
      Exit;
    end;
  end;

  Result := SCO_SUCESSO;
end;


{
  Procedimento para inicializacao da comunicacao com o PPad.

  @return SCO_SUCESSO     Sucesso.
  @return <> SCO_SUCESSO  O erro ocorrido.
}

procedure FechaPINPad;
begin
  ScopePPClose ('SCOPE');
end;


{
  Procedimento para inicializacao de uma transacao.

  @return SCO_SUCESSO     Sucesso.
  @return <> SCO_SUCESSO  O erro ocorrido.
}

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
      atualizMsg ('Falha na inicializacao da sessao...')
    else
    begin
      iSinc := iSinc or INI_SESSAO;

      atualizMsg ('Sessao iniciada...');
    end;
  end;

  Result := iRet;
end;


{
  Funcao responsavel pela execucao da funcao selecionada.

  @return SCO_SUCESSO     Sucesso.
  @return <> SCO_SUCESSO  O erro ocorrido.
}

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
      atualizMsg ('... Compra ''a credito');

      iRet := ScopeCompraCartaoCredito ( PChar (sValor), PChar (sTaxa) );
    end;

    Integer (MNU_DEBITO):
    begin
      atualizMsg ('... Compra ''a debito');

      iRet := ScopeCompraCartaoDebito ( PChar (sValor) );
    end;

    Integer (MNU_PAGTO):
    begin
      atualizMsg ('... Pagamento');

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
      atualizMsg ('... Consulta CDC');

      iRet := ScopeConsultaCDC ( PChar (sValor), PChar (sTaxa) );
    end;

    Integer (MNU_CHEQ):
    begin
      atualizMsg ('... Consulta cheque');

      iRet := ScopeConsultaCheque ( PChar (sValor) );
    end;

    Integer (MNU_CANC):
    begin
      atualizMsg ('... Cancelamento de transacao');

      iRet := ScopeCancelamento ( PChar (sValor), PChar (sTaxa) );
    end;

    Integer (MNU_REIMPCOMP):
    begin
      atualizMsg ('... Reimpressao de comprovante');

      iRet := ScopeReimpressaoComprovante;
    end;

    Integer (MNU_RECCEL):
    begin
      atualizMsg ('... Recarga de celular');

      iRet := ScopeRecargaCelular;
    end;

    Integer (MNU_RESVEND):
    begin
      atualizMsg ('... Resumo de vendas');

      iRet := ScopeResumoVendas;
    end;

    Integer (MNU_PREAUTCRED):
    begin
      atualizMsg ('... Pre-autorizacao de credito');

      iRet := ScopePreAutorizacaoCredito ( PChar (sValor), PChar (sTaxa) );
    end;
  end;

  Result := iRet;
end;



{
  Funcao complementar aos procedimentos realizados pela IniciaTransacaoTEF ().

  @return SCO_SUCESSO     Sucesso.
  @return <> SCO_SUCESSO  O erro ocorrido.
}

function FinalizaTransacaoTEF (iOpcMnu: Integer): LongInt;
var
  iRet,
  iAux:       LongInt;

  eTipoVal:   TEnumCelOperVals;

  PColeta:    TParam_Coleta;
  PColetaMsg: TColeta_Msg;

  PCheque:    TParam_Cheq;

  PRecOper:   TRec_Cel_Oper;
  PRecIDOper: TRec_Cel_ID_Oper;
  PLstVals:   TRec_Cel_Valores;

  bAux:       Byte;

  Cabec:      array [1..1024] of Char;
  CpCliente,
  CpLoja,
  CpReduzido: array [1..2048] of Char;

label
  fEnd;

begin
  { Se estiver sendo usado o HLAPI nao precisaremos fazer o procedimento
    abaixo }
  if (iSinc and INI_APLCOLET) = 0 then
    Exit;

  repeat
    iAux := 0;
    bAux := 0;
    sBufEntr := '';
    ZeroMemory ( @PColeta, SizeOf (TParam_Coleta) );

    { Enquanto a transacao estiver em
      andamento, aguarda }
    repeat
      iRet := ScopeStatus;

      Sleep (200);

      if (iAux = 0) then
        atualizMsg ('... transacao em andamento |')
      else if (iAux = 1) then
        atualizMsg ('... transacao em andamento /')
      else if (iAux = 2) then
        atualizMsg ('... transacao em andamento -')
      else
      begin
        atualizMsg ('... transacao em andamento \');
        iAux := -1;
      end;

      iAux := iAux + 1;

      if (iRet = SCO_TRN_EM_ANDAMENTO) then
      begin
        if (iSinc and ACAO_CANCELAR) <> 0 then
        begin
          atualizMsg ('Transacao cancelada');

          ScopeResumeParam (iRet, '', 0, 2);

          goto fEnd;
        end;
      end
      { Tratar a coleta de cartao manualm/te, em paralelo
        c/ o PINPad }
      else if (iRet = SCO_COLETA_CARTAO_EM_ANDAMENTO) then
      begin
        PColeta.HabTeclas := BIT9_ON;

        // Vejamos se o usuario digitou o cartao manualm/te
        sBufEntr := frmAuxParallelCtl (2, @bAux);

        if ( (bAux = 2) or (bAux = 0) ) then
        begin
          // Nao precisamos criar a janela novam/te
          bAux := 1;

          if Length (sBufEntr) <> 0 then
          begin
            // Vamos informar o SCoPE q o cartao foi digitado
            ScopeResumeParam (iRet, '', 0, 2);

            Sleep (500);
          end;
        end
        else
          bAux := 0;

        if (Length (sBufEntr) = 0) then
          sBufEntr := 'Digite o numero do cartao:';
      end;

      Application.ProcessMessages;
    until (iRet <> SCO_TRN_EM_ANDAMENTO);

    if ( (iRet < SCO_PRIMEIRO_COLETA_DADOS) or
          (iRet > SCO_ULTIMO_COLETA_DADOS) ) then
    begin
      if (iRet = SCO_SUCESSO) then
        atualizMsg ('Transacao completa')
      else
        atualizMsg ('Transacao completa com erro: ' + IntToStr (iRet) );

      break;
    end;

    // Guardar os bits q ligamos nos passos anteriores
    iAux := PColeta.HabTeclas;

    { Obtem dados do Scope e exibe as mensagens
      do cliente e operador }
    ScopeGetParam (iRet, @PColeta);

    // Restaurar os bits armazenados anteriorm/te
    PColeta.HabTeclas := PColeta.HabTeclas or iAux;

    // Tratam/to dos estados
    if ( (iRet = SCO_CARTAO) or
            (iRet = SCO_COLETA_AUT_OU_CARTAO) ) then
      sBufEntr := 'Digite o numero do cartao:'
    // imprime Cheque
    else if (iRet = SCO_IMPRIME_CHEQUE) then
    begin
      { P/ indicarmos p/ a funcao execFormAux exibir esse texto
        no memo de exibicao }
      PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;

      iAux := ScopeGetCheque (@PCheque);

      if (iAux = SCO_SUCESSO) then
      begin
        sBufEntr := 'Banco = ' + TrimRight ( string (PCheque.Banco) ) + #10 +
              'Agencia = ' + TrimRight ( string (PCheque.Agencia) ) + #10 +
              'Numero do cheque = ' + TrimRight ( string (PCheque.NumCheque) ) + #10 +
              'Valor = ' + TrimRight ( string (PCheque.Valor) ) + #10 +
              'Bom para = ' + TrimRight ( string (PCheque.BomPara) ) + #10 +
              'Codigo da autorizadora = ' + TrimRight ( string (PCheque.CodAut) ) + #10 +
              'Municipio = ' + TrimRight ( string (PCheque.Municipio) ) + #10;
      end
      else
        sBufEntr := 'Erro ScopeGetCheque: ' + IntToStr (iAux) + #10;
    end
    { recupera a lista de valores da
      Recarga de Celular }
    else if (iRet = SCO_COLETA_VALOR_RECARGA) then
    begin
      eTipoVal := REC_CEL_VALORES_MODELO_2;

      iAux := ScopeObtemHandle (HDL_TRANSACAO_EM_ANDAMENTO);

      if (iAux > $FFFF) then
      begin
        ScopeObtemCampoExt ( iAux, Cod_Rede, $00, 0, PCHAR (@Cabec) );

        if ( StrToInt
            ( TrimRight ( string (Cabec) ) ) = R_GWCEL) then
          eTipoVal := REC_CEL_VALORES_MODELO_3;
      end;

      iAux := ScopeRecuperaValoresRecCel
           ( Byte (eTipoVal), @PLstVals, SizeOf (TRec_Cel_Valores) );

      if (iAux = SCO_SUCESSO) then
      begin
        PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;

        sBufEntr := 'Informacoes dos valores disponiveis:' + #10 + #10 +
                    'Tipo de valor ';

        if PLstVals.TipoValor = 'V' then
          sBufEntr := sBufEntr + 'variavel'
        else if PLstVals.TipoValor = 'F' then
          sBufEntr := sBufEntr + 'fixo'
        else
          sBufEntr := sBufEntr + 'fixo ou variavel';

        sBufEntr := sBufEntr + #10 + 'Valor minimo de recarga: ' +
                              TrimRight ( string (PLstVals.ValorMinimo) );

        sBufEntr := sBufEntr + #10 + 'Valor maximo de recarga: ' +
                              TrimRight ( string (PLstVals.ValorMaximo) );

        sBufEntr := sBufEntr + #10 + 'Quantidade total: ' +
                                    IntToStr ( Integer (PLstVals.Totvalor) );

        for iAux := 1 to Integer (PLstVals.Totvalor) do
        begin
          sBufEntr := sBufEntr + #10 +
                      '  Valor: ' + TrimRight ( string (PLstVals.TabValores [iAux].Valor) ) +
                      ' Bonus: ' + TrimRight ( string (PLstVals.TabValores [iAux].Bonus) ) +
                      ' Custo: ' + TrimRight ( string (PLstVals.TabValores [iAux].Custo) );
        end;

        sBufEntr := sBufEntr + #10 + #10 + 'Mensagem promocional: ' +
                          TrimRight ( string (PLstVals.MsgPromocional) ) + #10;

        if ( (eTipoVal = REC_CEL_VALORES_MODELO_3) and
                  (Integer (PLstVals.TotFaixaValores) > 0) ) then
        begin
          for iAux := 1 to Integer (PLstVals.TotFaixaValores) do
          begin
            sBufEntr := sBufEntr + #10 +
                        '  Valor Minimo = : ' + TrimRight ( string (PLstVals.TabFaixaValores [iAux].ValorMin) ) +
                        ' Valor Maximo: ' + TrimRight ( string (PLstVals.TabFaixaValores [iAux].ValorMax) );
          end;
        end;
      end;
    end
    { recupera a lista de operadoras da
      Recarga de Celular }
    else if (iRet = SCO_COLETA_OPERADORA) then
    begin
      // recuperar as operadoras
      iAux := ScopeRecuperaOperadorasRecCel
           ( Byte (REC_CEL_OPERADORAS_MODELO_2), @PRecOper,
                                                SizeOf (TRec_Cel_Oper) );

      if (iAux = SCO_SUCESSO) then
      begin
        PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;

        sBufEntr := 'Existem ' + IntToStr (PRecOper.NumOperCel) +
                                              ' operadoras.' + #10 + #10;

        { Exibe as operadoras: a listagem esta' dividida de acordo
          com o record TRec_Cel_ID_Oper. Entao a logica p/ a recuperacao
          das infos deve ser ... }
        for iAux := 0 to PRecOper.NumOperCel - 1 do
        begin
          CopyMemory (@PRecIDOper,
            @PRecOper.OperCel [ iAux * SizeOf (TRec_Cel_ID_Oper) + 1 ],
                                              SizeOf (TRec_Cel_ID_Oper) );

          sBufEntr := sBufEntr + #10 + 'Codigo da operadora = [' +
          IntToStr ( Integer (PRecIDOper.CodOperCel) ) + '] -> Nome = [' +
                          TrimRight ( string (PRecIDOper.NomeOperCel) )+ ']';
        end;

        sBufEntr := sBufEntr + #10;
      end;
    end
    { imprime Cupom + Nota Promissoria +
      Cupom Promocional }
    else if ( (iRet = SCO_IMPRIME_CUPOM) or
            // imprime Cupom Parcial
              (iRet = SCO_IMPRIME_CUPOM_PARCIAL) or
            // imprime Consulta
              (iRet = SCO_IMPRIME_CONSULTA) ) then
    begin
      { P/ indicarmos p/ a funcao execFormAux exibir esse texto
        no memo de exibicao }
      PColeta.HabTeclas := PColeta.HabTeclas or BIT7_ON;

      iAux := ScopeGetCupomEx (SizeOf (Cabec), @Cabec,
                  SizeOf (CpCliente), @CpCliente,
                  SizeOf (CpLoja), @CpLoja,
                  SizeOf (CpReduzido), @CpReduzido, @bAux);

      if (iAux = SCO_SUCESSO) then
      begin
        sBufEntr := '>>CABECALHO<<' + #10 + TrimRight ( string (Cabec) ) + #10 + #10 +
                    '>>CUPOM DO CLIENTE<<' + #10 + TrimRight ( string (CpCliente) ) + #10 + #10 +
                    '>>CUPOM DA LOJA<<' + #10 + TrimRight ( string (CpLoja) ) + #10 + #10;

        if (bAux > 0) then
          sBufEntr := sBufEntr +
                    '>>CUPOM REDUZIDO<<' + #10 + TrimRight ( string (CpReduzido) ) + #10;

        bAux := 0;
      end
      else
        sBufEntr := 'Erro ScopeGetCupomEx: ' + IntToStr (iAux) + #10;
    end
    // captura da senha do usuario
    else if (iRet = SCO_SENHA) then
    begin
      // Indicando p/ ativar o modo senha
      PColeta.HabTeclas := PColeta.HabTeclas or BIT8_ON;

      sBufEntr := 'Digite a senha:'
    end
    // SCoPE aguardando o cartao que foi digitado
    else if (iRet = SCO_CARTAO_DIGITADO) then
    begin
      // Vamos ver c o usr ja' digitou o texto
      sBufEntr := frmAuxParallelCtl (2, @bAux);

      if bAux = 0 then
      begin
        if Length (sBufEntr) <> 0 then
        begin
          // O texto ja' esta' em sBufEntr
          iAux := 0;  // Proximo estado
          bAux := 1;  // Nao podemos executar a funcao execFormAux
        end
        else
          // O usr teclou 'Cancelar' no PPad
          sBufEntr := 'Coleta:';
      end;
    end
    // mostra informacao e aguarda confirmacao do usuario
    else if (iRet = SCO_MOSTRA_INFO_RET_SCOPE) then
    begin
        if Length (sBufEntr) = 0 then
          sBufEntr := 'Coleta:';

        PColeta.HabTeclas := BIT9_ON;

        iAux := 0; // Garantir o envio da acao PROXIMO ao SCoPE
    end
    else if (iRet = SCO_COLETA_EM_ANDAMENTO) then
      bAux := 1
    // Todos os outros estados nao tratados
    else
      if Length (sBufEntr) = 0 then
        sBufEntr := 'Coleta:';

    // Exibe as msgs retornadas pelo SCoPE
    if (bAux <> 1) then
    begin
      iSinc := iSinc and not (ACAO_PROX + ACAO_ANTER + ACAO_CANCELAR);

      sBufEntr := execFormAux ( TrimRight ( string (PColeta.MsgOp1) ),
                                TrimRight ( string (PColeta.MsgOp2) ),
                                TrimRight ( string (PColeta.MsgCl1) ),
                                TrimRight ( string (PColeta.MsgCl2) ),
                                sBufEntr,
                                PColeta.HabTeclas);

      // Em qual botao o usr clicou?
      // Proximo
      if (iSinc and ACAO_PROX) <> 0 then
        iAux := 0
      // Anterior
      else if (iSinc and ACAO_ANTER) <> 0 then
        iAux := 1
      // Cancelar
      else if (iSinc and ACAO_CANCELAR) <> 0 then
        iAux := 2;
    end;

    if ( iSinc and (ACAO_PROX + ACAO_ANTER + ACAO_CANCELAR) = 0 ) then
      sBufEntr := '';

    iRet := ScopeResumeParam (iRet, PChar (sBufEntr), SCO_TECLADO, iAux);

    if (iRet <> SCO_SUCESSO) then
    begin
      iAux := ScopeGetLastMsg (@PColetaMsg);

      if (iAux <> SCO_SUCESSO) then
      begin
        Application.MessageBox (PChar (
                      Format ('ERRO NO ScopeGetLastMsg() = %x', [iRet] ) ),
                                                                 'TEF', MB_OK);
      end;

      { Se o erro for de dado invalido, vamos
        permitir o usuario tentar novamente }
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
  until ( (iRet < SCO_PRIMEIRO_COLETA_DADOS) and
                      (iRet > SCO_ULTIMO_COLETA_DADOS) );

fEnd:
  sBufEntr := execFormAux ('Confirmar essa transacao? (1/0)',
                                      '', '', '', 'Opcao', 2);

  if ( (Length (sBufEntr) = 0) or
        (StrToInt (sBufEntr) <> 0) ) then
    bAux := SCO_CONFIRMA_TEF
  else
    bAux := SCO_DESFAZ_TEF;

  FechaSessaoTEF (bAux);

  Result := iRet;
end;


{
  Realiza o procedimento para termino de uma sessao TEF.
  Basicamente essa funcao desfara' todos os passos
  realizados na funcao AbreSessaoTEF().

  @param  bAcao   A acao 'a ser realizada:
                  - SCO_CONFIRMA_TEF: confirma a transacao.
                  - SCO_DESFAZ_TEF: desfaz a transacao.
  @param  bForcar P/ forcar o fecham/to da sessao.
}

procedure FechaSessaoTEF (bAcao: Byte; bForcar: Byte = 0);
var
  bAux:   Byte;
  iRet:   LongInt;
  sMsg:   String;

begin
  if ( ( (iSinc and INI_SESSAO) <> 0 ) or
                                (bForcar = 1) ) then
  begin
    iRet := ScopeFechaSessaoTEF (bAcao, @bAux);

    if (iRet = SCO_SUCESSO) then
    begin
      sMsg := 'Sessao finalizada.';

      if (bAux = 1) then
        sMsg := sMsg + 'Transacao anterior desfeita.';

      iSinc := iSinc and not INI_SESSAO;
    end
    else
      sMsg := 'Erro no fecham/to da sessao: + ' + IntToStr (iRet);

    atualizMsg (sMsg);
  end;
end;


{
  Procedimento para finalizacao da comunicao com
  o servidor SCoPE.
}

procedure FechaSCoPE;
var
  iRet:   LongInt;

begin
  iRet := SCO_SUCESSO;

  if (iSinc and INI_COMUNIC) <> 0 then
  begin
    iRet := ScopeClose;

    if iRet <> SCO_SUCESSO then
    begin
      atualizMsg ('Comunicacao fechada.');

      iSinc := iSinc and not INI_COMUNIC;
    end
    else
      atualizMsg ( 'Erro no fecham/to da comunicacao: + ' + IntToStr (iRet) );
  end;

  FechaPINPad;
end;

end.

