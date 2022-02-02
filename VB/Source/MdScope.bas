Attribute VB_Name = "MdScope"
'Modulo concentrador das declaracoes principais do
'programa demo.

'WinAPI
Declare Function GetPrivateProfileString Lib "kernel32" _
                    Alias "GetPrivateProfileStringA" _
                    (ByVal lpApplicationName As String, _
                    ByVal lpKeyName As Any, _
                    ByVal lpDefault As String, _
                    ByVal lpReturnedString As String, _
                    ByVal nSize As Long, _
                    ByVal lpFileName As String) As Long

Declare Function WritePrivateProfileString Lib "kernel32" _
                    Alias "WritePrivateProfileStringA" _
                    (ByVal lpApplicationName As String, _
                    ByVal lpKeyName As Any, ByVal lpString As Any, _
                    ByVal lpFileName As String) As Long

'SCoPE API
Declare Function ScopeAbreSessaoTEF Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeFechaSessaoTEF Lib "SCOPEAPI.DLL" _
                    (ByVal acao As Byte, _
                    ByRef DesfezTEFAposQuedaEnergia As Byte) As Long

Declare Function ScopeOpen Lib "SCOPEAPI.DLL" _
                    (ByVal Modo As String, ByVal Empresa As String, _
                    ByVal Filial As String, ByVal POS As String) As Long

Declare Function ScopeStatus Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeClose Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeAbort Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeCompraCartaoDebito Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String) As Long

Declare Function ScopeCompraCDC Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String) As Long

Declare Function ScopeCompraCartaoCredito Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String, _
                    ByVal TxServico As String) As Long

Declare Function ScopeGetParam Lib "SCOPEAPI.DLL" _
                    (ByVal Status As Long, _
                    ByRef Coleta As stColeta) As Long

Declare Function ScopeResumeParam Lib "SCOPEAPI.DLL" _
                    (ByVal Status As Long, ByVal Dados As String, _
                    ByVal DadosParam As Integer, _
                    ByVal acao As Long) As Long

Declare Function ScopePreAutorizacaoCredito Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String, _
                    ByVal TxServico As String) As Long

Declare Function ScopeConsultaCDC Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String, _
                     ByVal TxServico As String) As Long

Declare Function ScopeConsultaCredito Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String, _
                    ByVal TxServico As String) As Long

Declare Function ScopeCancelamento Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String, _
                    ByVal TxServico As String) As Long

Declare Function ScopeConsultaCheque Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String) As Long

Declare Function ScopeGarantiaDescontoCheque Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String) As Long

Declare Function ScopeResumoVendas Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeResumoOperacoes Lib "SCOPEAPI.DLL" _
                    (ByVal Servico As Integer, _
                    ByVal CodBandeira As Integer) As Long

Declare Function ScopeGetCheque Lib "SCOPEAPI.DLL" _
                    (ByRef ParamCheque As stParamCheque) As Long

Declare Function ScopeSuspend Lib "SCOPEAPI.DLL" _
                    (ByVal Estado As Integer) As Long

Declare Function ScopeReimpressaoComprovante Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeReimpressaoComprovantePagamento Lib "SCOPEAPI.DLL" _
                    (ByVal CodBandeira As Integer) As Long

Declare Function ScopeObtemHandle Lib "SCOPEAPI.DLL" _
                    (ByVal Desloc As Long) As Long

Declare Function ScopeObtemCampoExt Lib "SCOPEAPI.DLL" _
                    (ByVal Handle As Long, ByVal Masc As Long, _
                    ByVal Masc2 As Long, ByVal FieldSeparator As Byte, _
                    ByVal Buffer As String) As Long

Declare Function ScopeObtemCampo Lib "SCOPEAPI.DLL" _
                    (ByVal Handle As Long, ByVal Masc As Long, _
                    ByVal FieldSeparator As Byte, _
                    ByRef Buffer As String) As Long

Declare Function ScopeSetAplColeta Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeConfigura Lib "SCOPEAPI.DLL" _
                    (ByVal Id As Long, ByVal Param As Long) As Long
 
Declare Function ScopeConsultaAVS Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeSaque Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String) As Long

Declare Function ScopeRecargaCelular Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeTransacaoFinanceira Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String, _
                    ByVal Servico As Integer) As Long

Declare Function ScopeInvestimento Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String, _
                    ByVal Servico As Integer) As Long

Declare Function ScopePagamentoConta Lib "SCOPEAPI.DLL" _
                    (ByVal Servico As Integer) As Long

Declare Function ScopeConsultaSaldoDebito Lib "SCOPEAPI.DLL" _
                    (ByVal Valor As String) As Long

Declare Function ScopeCartaoDinheiro Lib "SCOPEAPI.DLL" _
                    (ByVal Servico As Integer, _
                    ByVal Valor As String) As Long

Declare Function ScopeServicosGenericos Lib "SCOPEAPI.DLL" _
                    (ByVal Servico As Integer, _
                    ByVal Bandeira As Integer, _
                    ByVal Valor As String) As Long

Declare Function ScopeGetCupomEx Lib "SCOPEAPI.DLL" _
                    (ByVal CabecLen As Integer, _
                    ByVal Cabec As String, _
                    ByVal CupomClienteLen As Integer, _
                    ByVal CupomCliente As String, _
                    ByVal CupomLojaLen As Integer, _
                    ByVal CupomLoja As String, _
                    ByVal CupomReduzidoLen As Integer, _
                    ByVal CupomReduzido As String, _
                    ByRef QtdLinhasRedizido As Byte) As Long

Declare Function ScopeResume Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopeGetLastMsg Lib "SCOPEAPI.DLL" _
                    (ByRef LastMsgColeta As stLastMsgColeta) As Long

Declare Function ScopeRecuperaOperadorasRecCel Lib "SCOPEAPI.DLL" _
                    (ByVal bTipoTabela As Byte, _
                    ByRef sBuffer As stREC_CEL_OPERADORAS, _
                    ByVal iTamBuffer As Integer) As Long

Declare Function ScopeRecuperaValoresRecCel Lib "SCOPEAPI.DLL" _
                    (ByVal bTipoTabela As Byte, _
                    ByRef sBuffer As stREC_CEL_VALORES, _
                    ByVal iTamBuffer As Integer) As Long

'Funcoes de PIN-Pad compartilhado
Declare Function ScopePPOpen Lib "SCOPEAPI.DLL" _
                    (ByVal Porta As Integer) As Long

Declare Function ScopePPClose Lib "SCOPEAPI.DLL" _
                    (ByVal Mensagem As String) As Long

Declare Function ScopePPDisplay Lib "SCOPEAPI.DLL" _
                    (ByVal Mensagem As String) As Long

Declare Function ScopePPDisplayEx Lib "SCOPEAPI.DLL" _
                    (ByVal Mensagem As String) As Long

Declare Function ScopePPGetInfo Lib "SCOPEAPI.DLL" _
                    (ByVal Id As Integer, _
                    ByVal Comprimento As Integer, _
                    ByVal Dados As String) As Long

Declare Function ScopePPStartGetKey Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopePPGetKey Lib "SCOPEAPI.DLL" () As Long

Declare Function ScopePPStartGetCard Lib "SCOPEAPI.DLL" _
                    (ByVal TipoApl As Integer, _
                    ByVal ValorInicial As String) As Long

Declare Function ScopePPGetCard Lib "SCOPEAPI.DLL" _
                    (ByVal Id As Integer, _
                    ByVal MsgNotify As String, _
                    ByVal Comprimento As Integer, _
                    ByVal Dados As String) As Long

Declare Function ScopePPStartGetPIN Lib "SCOPEAPI.DLL" _
                    (ByVal Mensagem As String) As Long

Declare Function ScopePPGetPIN Lib "SCOPEAPI.DLL" _
                    (ByVal Senha As String) As Long

Declare Function ScopePPMsgErro Lib "SCOPEAPI.DLL" _
                    (ByVal Rc As Integer, ByVal MsgErro As String) As Long

Declare Function ScopeConsultaPP Lib "SCOPEAPI.DLL" _
                    (ByRef Configurado As Byte, _
                    ByRef UsoExclusivoScope As Byte, _
                    ByRef Porta As Byte) As Long
                    
Declare Function ScopeAtualizaParametrosChip Lib "SCOPEAPI.DLL" (ByVal Futuro1 As String, ByVal Futuro2 As String) As Long
Declare Function ScopeTransacaoPOS Lib "SCOPEAPI.DLL" (ByVal Valor As String, ByVal Rede As Integer, ByVal Bandeira As Integer, ByVal Servico As Integer) As Long
Declare Function ScopeConsultaSaldoCredito Lib "SCOPEAPI.DLL" () As Long
Declare Function ScopeMenu Lib "SCOPEAPI.DLL" (ByVal UsoFuturo As Integer) As Long
Declare Function ScopeAtualizaPrecosMercadorias Lib "SCOPEAPI.DLL" (ByVal Bandeira As Long, ByVal UsoFuturo1 As String) As Long

'funções PBM
Declare Function ScopeConsultaMedicamento Lib "SCOPEAPI.DLL" (ByVal bTipoConvenio As Byte, ByVal bCodRede As Byte) As Long
Declare Function ScopeObtemMedicamentosComCRM Lib "SCOPEAPI.DLL" (ByRef bQtdRegistros As Byte, ByRef bTipoConvenio As Byte, ByRef sListaMedicamentos As stREGISTRO_MEDICAMENTO_CRM, iTamLista As Integer) As Long
Declare Function ScopeObtemMedicamentos Lib "SCOPEAPI.DLL" (ByRef bQtdRegistros As Byte, ByRef sListaMedicamentos As stREGISTRO_MEDICAMENTO, iTamLista As Integer) As Long
Declare Function ScopeCompraMedicamento Lib "SCOPEAPI.DLL" (ByVal Servico As Byte, ByVal CodBandeira As Byte, ByVal CupomFiscal As String) As Long
Declare Function ScopeAtualizaValor Lib "SCOPEAPI.DLL" (ByVal sValor As String) As Long
Declare Function ScopePreAutorizacaoMedicamento Lib "SCOPEAPI.DLL" (ByVal bTipoConvenio As Byte, ByVal bCodRede As Byte) As Long
Declare Function ScopeRecuperaBufTabela Lib "SCOPEAPI.DLL" (ByVal bTipoTabela As Byte, ByRef bQtdRegistros As Byte, ByRef sBuffer As RegistroProjeto, iTamBuffer As Integer) As Long
Declare Function ScopeElegibilidadeCartao Lib "SCOPEAPI.DLL" (ByVal bTipoConvenio As Byte, ByVal bCodRede As Byte) As Long
Declare Function ScopeCancelaPreAutMedicamento Lib "SCOPEAPI.DLL" (ByVal bTipoConvenio As Byte, ByVal bCodRede As Byte) As Long


Public sCupom As String
Global glControle               As Long, _
        gsDadosPedido           As String * 255, _
        gsSecao, _
        gsKeyCompany, _
        gsKeyFilial, _
        gsKeyPos, _
        gsCompany, _
        gsFilial, _
        gsPos                   As String, _
        gbConfigCompartilhado, _
        gbExclusivoScope, _
        gbPorta, _
        gbAcao, _
        gbDesfezTransacao       As Byte, _
        gbConectado             As Byte, _
        giNumTef                As Integer
'Arquivos lidos
Global Const FILE_ATUALIZAPRECOTICKET As String = "PrecosMercTicket.txt"
Global Const FILE_MERCADORIASTICKET As String = "MercadoriasTicket.txt"

Global Const gcFieldSeparator               As Byte = 61, _
                APPNAME = "SCoPEIni", _
                APPSEC = "Geral", _
                KEY_COMPANY = "Empresa", _
                KEY_FILIAL = "Filial", _
                KEY_POS = "Pos", _
                TEMPO_ESPERA = 500, _
                SCO_TECLADO                 As Integer = &H4&, _
                SCO_CARTAO_MAGNETICO        As Integer = &H20&, _
                RCS_CANCELADA_PELO_OPERADOR As Long = &HFF02&

'Define os parametros para a funcao ScopeObtemHandle
Global Const HDL_TRANSACAO_ANTERIOR     As Long = 0
Global Const HDL_TRANSACAO_EM_ARQUIVO   As Long = 8
Global Const HDL_TRANSACAO_EM_ANDAMENTO As Long = 9

Global Const S_RESUMO_PAGAMENTOS = 93
Global Const B_REDECARD = 22
'Identificacao das redes
Global Const R_GWCEL As Long = 90

'Define os campos para as funcoes ScopeObtemCampo()
'e para ScopeObtemCampoExt()
Global Const Cod_Rede                   As Long = &H400000

Global Const BUF_TAB_PRJ_PHARMASYSTEM As Integer = 1
'Retornos da interface PINPad
Global Const PC_OK              As Long = 0     'Operacao efetuada com sucesso
Global Const PC_PROCESSING      As Long = 1     'Em processamento. Deve-se chamar
                                                'a função novamente ou PC_Abort
                                                'para finalizar
Global Const PC_NOTIFY          As Long = 2     'Em processamento. Deve-se
                                                'apresentar no "checkout" uma
                                                'mensagem retornada pela função e
                                                'chamá-la novamente ou PC_Abort
                                                'para finalizar.

'ScopeStatus
'global const ST_COMPLETED      =0x00xx  'Transaction completed (xx means the return code from the acquirer)
Global Const ST_PROGRESS As Long = &HFE00&       'Transaction in progress
Global Const ST_NOTINIT  As Long = &HFE01&        'Scope API not initialized
Global Const ST_SUPENDED  As Long = &HFE03&       'Scope API in suspended state
Global Const ST_SERVEROFF  As Long = &HFF00&      'Scope Server off-line
Global Const ST_ACQOFF  As Long = &HFF01&        'Acquirer off-line
Global Const ST_CANCELOP  As Long = &HFF02&      'Transaction cancelled by operator
Global Const ST_TRANSNOTCONF  As Long = &HFF03&  'Transaction not configured in the Scope BD
Global Const ST_CANCELED  As Long = &HFF04&      'Source transaction already cancelled
Global Const ST_NOTFOUND  As Long = &HFF05&      'Source transaction not found in the Scope BD
Global Const ST_NOTREVER  As Long = &HFF06&      'Source transaction not reversible
Global Const ST_ARGNOTOK  As Long = &HFF07&      'Arguments differs from that of the source transaction

'Acao a ser tomada na coleta
Global Const ACAO_PROXIMO     As Long = 0
Global Const ACAO_ANTERIOR    As Long = 1
Global Const ACAO_CANCELAR    As Long = 2

'ScopeStatus - Coleta de dados
Global Const CT_ESTADO_INICIAL              As Long = &HFC00&       'Status inicial da coleta
Global Const CT_COLETA_CARTAO               As Long = &HFC00&       'Numero do cartao
Global Const CT_COLETA_VALIDADE_CARTAO      As Long = &HFC01&       'Validade do cartao
Global Const CT_IMPRIME_CUPOM               As Long = &HFC02&       'Imprime cupom
Global Const CT_IMPRIME_CHEQUE              As Long = &HFC08&       'Imprime cheque
Global Const CT_COLETA_SENHA                As Long = &HFC11&       'Senha
Global Const CT_COLETA_VALOR_RECARGA        As Long = &HFC2E&       'Recarg Cell: Valores
Global Const CT_IMPRIME_CONSULTA            As Long = &HFC1B&       'Imprime consulta
Global Const CT_COLETA_OPERADORA            As Long = &HFC70&       'Recarg Cell: Operadora
Global Const CT_CARTAO_DIGITADO             As Long = &HFC85&
Global Const CT_COLETA_CARTAO_EM_ANDAMENTO  As Long = &HFCFC&
Global Const CT_COLETA_EM_ANDAMENTO         As Long = &HFCFD&
Global Const CT_INFO_RETORNA_FLUXO          As Long = &HFCFE&       'Retorna ao fluxo
Global Const CT_INFO_AGUARDA_OPERADOR       As Long = &HFCFF&       'Aguarda entrada do operador
Global Const CT_ESTADO_FINAL                As Long = &HFCFF&       'Status final da coleta
Global Const CT_OBTER_LISTA_MEDICAMENTOS    As Long = &HFC44&       'Status para obter a lista de medicamentos
Global Const CT_COLETA_REG_MEDICAMENTO      As Long = &HFC43&
Global Const CT_COLETA_PROJETO              As Long = &HFCD1&       'Status para coleta o projeto da phamaSystem
Global Const CT_COLETA_TIPO_CONSULTA        As Long = &HFCB8&       ' coleta o tipo da consulta

'ScopeOpen
Global Const OP_SUCCESS  As Long = &H0&          'Successful
Global Const OP_INVMODO  As Long = &HFA01&       '_Modo Invalid
Global Const OP_INVCOMPANY  As Long = &HFA02&    '_Empresa Invalid
Global Const OP_INVFILIAL  As Long = &HFA03&     '_Filial Invalid
Global Const OP_INVPOS  As Long = &HFA04&        '_PoS Invalid
Global Const OP_ALREADYINIT  As Long = &HFE01&   'Scope API already initialized
Global Const OP_SERVEROFF  As Long = &HFF00&     'Scope Server off-line

'ScopeClose
Global Const CL_SUCCESS  As Long = &H0&          'Successful
Global Const CL_APINOTINIT  As Long = &HFE01&    'Scope API not initialized
Global Const CL_APISUSPEND  As Long = &HFE03&    'Scope API in suspended state
Global Const CL_SERVEROFF  As Long = &HFF00&     'Scope Server off-line

'ScopeCompraCartaoDebito / ScopeCompraCartaoCredito / ScopeCancelamento /ScopeConsultaCheque
Global Const TR_TRANSSTART  As Long = &H0&       'Transaction started
Global Const TR_INVVALUE  As Long = &HFA01&      ' 1   _Valor invalid
Global Const TR_INVSERVICE  As Long = &HFA02&    ' 2   _TxServico invalid
Global Const TR_PROGRESS  As Long = &HFE00&      'Exists a transaction in progress
Global Const TR_APINOTINIT  As Long = &HFE01&    'Scope API not initialized
Global Const TR_APINSUSPEND  As Long = &HFE03&   'Scope API in suspended state
Global Const TR_SERVEROFF  As Long = &HFF00&     'Scope Server off-line

Global Const CT_COLETA_DADOS_LISTA_PRECOS     As Long = &HFCCA& 'Coleta Lista de Preços
Global Const CT_COLETA_LISTA_MERCADORIAS      As Long = &HFCCB& 'Coleta Lista de Mercadorias

'ScopeConfigura
Global Const CFG_CANCELAR_OPERACAO_PINPAD As Long = 1

'Modelos operadoras
Public Enum eREC_CEL_OPERADORAS_MODELO
    REC_CEL_OPERADORAS_MODELO_1 = 1
    REC_CEL_OPERADORAS_MODELO_2
End Enum

'Tipo de estrutura 'a ser retornada com informacoes dos valores
'de recarga
Public Enum eREC_CEL_VALORES_MODELO
    REC_CEL_VALORES_MODELO_1 = 1
    REC_CEL_VALORES_MODELO_2
    REC_CEL_VALORES_MODELO_3
End Enum

'Informacoes especificas de cada operadora
Type stREC_CEL_ID_OPERADORA
    CodOperCel  As Byte          'Codigo da operadora
    NomeOperCel As String * 21   'Nome da operadora
End Type

'Lista de Operadoras de Recarga de Celular retornadas pelo Servidor
Type stREC_CEL_OPERADORAS
    NumOperCel      As Integer                  'Numero de Operadoras de Celular retornadas nesta transacao
    Operadoras(91)  As stREC_CEL_ID_OPERADORA   'Tabela de operadoras
End Type

'Formato do valor para Recarga de Celular
Type stREC_CEL_VALOR
    Valor       As String * 12      'Codigo da operadora
    Bonus       As String * 12      'Bonus da recarga para este valor
    Custo       As String * 12      'Custo da recarga para este valor
End Type

'Abrangencia de valores disponiveis
Type stREC_CEL_FAIXA_VALORES
    ValorMin    As String * 12
    ValorMax    As String * 12
End Type

'Lista de Valores de Recarga de Celular retornadas pelo Servidor
Type stREC_CEL_VALORES
    TipoValor       As Byte             'Tipo dos valores
                                        ''V' - variavel(val min e val maximo)
                                        ''F' - Fixo (apenas um valor fixo)
                                        ''T' - Todos (tabela de valores)
    ValorMinimo         As String * 12      'Valor Minimo
    ValorMaximo         As String * 12      'Valor Maximo
    Totvalor            As Byte             'Total de valores da tabela
    TabValores(9)       As stREC_CEL_VALOR  'Tabela de valores com 2 casas decimais
    MsgPromocional      As String * 41      'Custo da recarga para este valor
    TotFaixaValores     As Byte
    TabFaixaValores(9)  As stREC_CEL_FAIXA_VALORES
End Type

'Estrutura com as informacoes do cheque
Type stParamCheque
    Banco       As String * 4
    Agencia     As String * 5
    NumCheque   As String * 13
    Valor       As String * 13
    BomPara     As String * 9
    CodAut      As String * 11
    Municipio   As String * 41
    Ordem       As Integer
End Type

'Estrutura das ultimas mensagens da coleta
Type stLastMsgColeta
    MsgOp1          As String * 64
    MsgOp2          As String * 64
    MsgCl1          As String * 64
    MsgCl2          As String * 64
End Type

' Estrutura de coleta
Type stColeta
    Bandeira        As Integer
    FormatoDado     As Integer
    HabTeclas       As Integer
    MsgOp1          As String * 64
    MsgOp2          As String * 64
    MsgCl1          As String * 64
    MsgCl2          As String * 64
    WrkKey          As String * 17
    ' devido ao alinhamento do VB foi necessario quebrar o campo em dois
    PosMasterKey    As Byte
    Filler          As Byte
    Reservadoas     As String * 128
End Type


'--------------------------------------------------------------------------------------------
Type stREGISTRO_MEDICAMENTO
    CodigoEAN As String * 13           ' Codigo ean do medicamento
    QtdProdutos As String * 2           ' Quantidade autorizada do produto
    PrecoPMC As String * 7              ' Preço maximo ao consumidor
    PrecoVenda As String * 7             ' Preço de venda
    PrecoFabrica As String * 7          ' Preço de fabrica
    PrecoAquisicao As String * 7         ' Preço de aquisicao
    PrecoRepasse As String * 7          ' Preço de repasse
    ReservadoFuturo As String * 1       ' Reservado futuro
    MotivoRejeicao As String * 2        ' Motivo da rejeicao
    CRM As String * 9 ' Numero do CRM
End Type


'--------------------------------------------------------------------------------------------
'       Registro devolvido pelo Scope na Consulta PBM com CRM
'--------------------------------------------------------------------------------------------
Type stREGISTRO_MEDICAMENTO_CRM
    RegistroM(38)  As stREGISTRO_MEDICAMENTO  ' Dados do medicamento
End Type

'--------------------------------------------------------------------------------------------
'       Estrutura para a PhamaSystem
'-------------------------------------------------------------------------------------------
Type stPrjPharmaSystem
    CodProjeto As String * 6
    DescrProjeto As String * 30
    OperadoraProjeto As String * 20
End Type

Type RegistroProjeto
   RegistroProjeto(14) As stPrjPharmaSystem
End Type

'Funcao para carregamento das configuracoes internas
'da aplicacao demo - utilizacao das funcoes utilitarias
'do MS-VB.
'@return    True    Informacoes lidas com sucesso.
'@return    False   Informacoes nao lidas.
Public Function LeIni() As Boolean
    Dim sRet As String, _
        sMsg As String, _
        sValue As String * 5, _
        lRet As Long

    On Error GoTo Fim

    LeIni = False

    'Empresa
    gsCompany = Trim(GetSetting(APPNAME, APPSEC, KEY_COMPANY, ""))

    'Filial
    gsFilial = Trim(GetSetting(APPNAME, APPSEC, KEY_FILIAL, ""))

    'Pos
    gsPos = Trim(GetSetting(APPNAME, APPSEC, KEY_POS, ""))

    If gsCompany = "" Or gsFilial = "" Or gsPos = "" Then
        frmParam.Show 1
    Else
        LeIni = True
    End If

Fim:

End Function

'-----------------------------------------------------------
' FUNCTION: ProcessCommandLine
'
' Processes the command-line arguments
'
' OUT: Fills in the passed-in byref parameters as appropriate
'-----------------------------------------------------------
'
Function ProcessCommandLine() As Boolean
    Dim fErr        As Boolean, _
        intAnchor   As Integer, _
        strCommand  As String

    Const strTemp$ = ""

    ProcessCommandLine = False

    strCommand = CStr(Command())

    strCommand = Trim$(strCommand)
    
    gsCompany = strExtractFilenameArg(strCommand, fErr)

    If fErr Then GoTo BadCommandLine

    gsFilial = strExtractFilenameArg(strCommand, fErr)

    If fErr Then GoTo BadCommandLine

    gsPos = strExtractFilenameArg(strCommand, fErr)

    If fErr Then GoTo BadCommandLine

    ' Last check:  There should be nothing else on the command line
    strCommand = Trim$(strCommand)

    If strCommand <> "" Then
        GoTo BadCommandLine
    End If

    ProcessCommandLine = True

    Exit Function
    
BadCommandLine:
    MsgBox "Linha de comando inválida!", _
                    vbCritical, frmScope.Caption

End Function

'-----------------------------------------------------------
' FUNCTION: strExtractFilenameArg
'
' Extracts a quoted or unquoted filename from a string
'   containing command-line arguments
'
' IN: [str] - string containing a filename.  This filename
'             begins at the first character, and continues
'             to the end of the string or to the first space
'             or switch character, or, if the string begins
'             with a double quote, continues until the next
'             double quote
' OUT: Returns the filename, without quotes
'      str is set to be the remainder of the string after
'      the filename and quote (if any)
'
'-----------------------------------------------------------
'
Function strExtractFilenameArg(str As String, fErr As Boolean)
    Dim strFilename     As String, _
        iEndFilenamePos As Integer, _
        iSpacePos       As Integer, _
        iSwitch1        As Integer, _
        iSwitch2        As Integer, _
        iQuote          As Integer

    str = Trim$(str)

    If Left$(str, 1) = """" Then
        ' Filenames is surrounded by quotes
        iEndFilenamePos = InStr(2, str, """") ' Find matching quote

        If iEndFilenamePos > 0 Then
            strFilename = Mid$(str, 2, iEndFilenamePos - 2)

            str = Right$(str, Len(str) - iEndFilenamePos)
        Else
            fErr = True

            Exit Function
        End If
    Else
        ' Filename continues until next switch or space or quote
        iSpacePos = InStr(str, " ")
        iSwitch1 = InStr(str, gstrSwitchPrefix1)
        iSwitch2 = InStr(str, gstrSwitchPrefix2)
        iQuote = InStr(str, """")
        
        If iSpacePos = 0 Then iSpacePos = Len(str) + 1
        If iSwitch1 = 0 Then iSwitch1 = Len(str) + 1
        If iSwitch2 = 0 Then iSwitch2 = Len(str) + 1
        If iQuote = 0 Then iQuote = Len(str) + 1

        iEndFilenamePos = iSpacePos
        If iSwitch1 < iEndFilenamePos Then iEndFilenamePos = iSwitch1
        If iSwitch2 < iEndFilenamePos Then iEndFilenamePos = iSwitch2
        If iQuote < iEndFilenamePos Then iEndFilenamePos = iQuote

        strFilename = Left$(str, iEndFilenamePos - 1)

        If iEndFilenamePos > Len(str) Then
            str = ""
        Else
            str = Right(str, Len(str) - iEndFilenamePos + 1)
        End If
    End If

    strFilename = Trim$(strFilename)
    If strFilename = "" Then
        fErr = True

        Exit Function
    End If

    fErr = False
    strExtractFilenameArg = strFilename
    str = Trim$(str)
End Function

Public Function CStr2VBStr(strIn As String) As String
    CStr2VBStr = Mid(strIn, 1, InStr(strIn, Chr(0)) - 1)
End Function

' ===========================================================================
' DESCRIÇÃO:      Efetua leitura de qualquer arquivo .TXT
'
' ENTRADA:        Caminho do arquivo .txt a ser lido
' SAÍDA:          Código de retorno modificado, se necessário
' HISTÓRICO:      --/05/2013 Felipe M. Schaden - Versão inicial.
' ===========================================================================
Public Function GetBufferDadosFromTXT(FileName As String) As String
   Dim File             As Long
   Dim Linha            As String
   Dim Comentario       As String
   Dim LinhaLen         As Integer

   On Error GoTo CreateDeviceError
   
   File = FreeFile
   GetBufferDadosFromTXT = ""
   
   Open FileName For Input As #File 'abre o arquivo texto
   
   Do While Not EOF(File)
         Line Input #File, Linha 'lê uma linha do arquivo texto
         LinhaLen = Len(Trim(Linha))
         Comentario = Mid$(Linha, 1, 2)
         If LinhaLen > 0 And Comentario <> Chr$(47) & Chr$(47) Then
            GetBufferDadosFromTXT = GetBufferDadosFromTXT & Linha
         End If
   Loop
   
CreateDeviceError:
   Close #File
End Function



