/*	\file

	SCOPE (Solucao Completa de Pagamento Eletronico)

	Projeto		:	SCoPE - Solucao Completa de Pagamento Eletronico

	Plataforma	:	Windows/Unix/Linux/DOS

	Descricao	:	Programa teste do ScopeArquivo padrao. As funcoes,
					estruturas e constantes aqui definidas estao
					especificadas no documento "Scope Interface
					Aplicacao.doc".
 */


/* INCLUDES */

#ifndef		_SCOPEDOS
	#include	<windows.h>
#endif

#ifdef		_SCOPELNX
	#include	<sys/ioctl.h>
	#include	<termios.h>
	#include	<unistd.h>
#else
	#include	<conio.h>
#endif

#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	"scopeapi.h"
#include	"bandeira.h"
#include	"rede.h"

/* DEFINES */

#ifdef		_SCOPEDOS
	#define		BOOL				int

	#define		TRUE				1
	#define		FALSE				0
#endif

#define		_VALORES_FLUXO_FIXO		FALSE

/* Tipos */
typedef		char * 	P_CHAR;
typedef		int * 	P_INT;
typedef		WORD * 	P_WORD;

/** Tipos de consulta de cheque. */
enum _tipoConsCheq
{
	TCC_BASICA,					/*!< Consulta basica. */
	TCC_BANCO_COM_CONTINGENCIA,	/*!< Consulta bancaria com contigencia. */
	TCC_COMPLETA,				/*!< Consulta completa. */
	TCC_BANCO_SEM_CONTINGENCIA	/*!< Consulta bancaria sem contigencia. */
};


/** Para facilitar no gerenciamento dos menus. */
enum _opcMenu
{
	MNU_SAIR,
	MNU_CREDITO,				/*!< Relativa a funcao ScopeCompraCartaoCredito. */
	MNU_DEBITO,					/*!< Relativa a funcao ScopeCompraCartaoDebito. */
	MNU_CCHEQUE,				/*!< Relativa a funcao ScopeConsultaCheque. */
	MNU_CCDC,					/*!< Relativa a funcao ScopeConsultaCDC. */
	MNU_CONSULTCHEQUE,			/*!< Relativa a funcao ScopeConsultaCredito. */
	MNU_CANCELAMENTO,			/*!< Relativa a funcao ScopeCancelamento. */
	MNU_RESUMOVENDAS,			/*!< Relativa a funcao ScopeResumoVendas. */
	MNU_REIMPCOMPR,				/*!< Relativa a funcao ScopeReimpressaoComprovante. */
	MNU_RECARGCEL,				/*!< Relativa a funcao ScopeRecargaCelular. */
	MNU_CONSULTMEDIC,			/*!< Relativa a funcao ScopeConsultaMedicamento. */
	MNU_COMPMEDIC,				/*!< Relativa a funcao ScopeCompraMedicamento. */
	MNU_CONSULTAVS,				/*!< Relativa a funcao ScopeGarantiaDescontoCheque. */
	MNU_TRANSFINANC,			/*!< Relativa a funcao ScopeTransacaoFinanceira. */
	MNU_INVESTIM,				/*!< Relativa a funcao ScopeInvestimento. */
	MNU_CONSULTSALDCLIEN,		/*!< Relativa a funcao ScopeConsultaSaldoDebito. */
	MNU_CONSULTTRANSAC,			/*!< Relativa a funcao ScopeConsultaTransacao. */
	MNU_PAGTO,					/*!< Relativa a funcao ScopePagamento. */
	MNU_COMPVALEGAS,			/*!< Relativa a funcao ScopeServicosGenericos. */
	MNU_MENU,					/*!< Relativa a funcao ScopeMenu. */
	MNU_CONSULTSALDCRED,		/*!< Relativa a funcao ScopeConsultaSaldoCredito. */
	MNU_CONSULTVALEGAS,			/*!< Relativa a funcao ScopeServicosGenericos. */
	MNU_PREAUTCRED,				/*!< Relativa a funcao ScopePreAutorizacaoCredito. */
	MNU_CONSULTGARANTDESCCHEQ,	/*!< Relativa a funcao ScopeGarantiaDescontoCheque. */
	MNU_CARTAODINHEIROCARGA,	/*!< Relativa a funcao ScopeCartaDinheiro. */
	MNU_CARTAODINHEIROCOMPRA,	/*!< Relativa a funcao ScopeCartaDinheiro. */
	MNU_CONSULTACARTAODINHEIRO,	/*!< Relativa a funcao ScopeConsultaCartaoDinheiro. */
	MNU_TROCOSURPRESA,			/*!< Relativa a funcao ScopeServicosGenericos. */
		// Novas funcionalidades
	MNU_ATUALIZA_PRECO,			/*!< Relativa a funcao ScopeAtualizaPrecosMercadorias> */
	MNU_SIMULACAOCREDIARIO,		/*!< Relativa a funcao ScopeSimulacaoCrediario. */
	MNU_CAPTURAPREAUTORIZAO,	/*!< Relativa a funcao ScopeCapturaPreAutorizacao. */
	MNU_ELEGCARTAO,             /*!< Relativa a função ScopeElegibilidadeCartao  */
	MNU_CANC_PREAUTPBM,			/*!< Relativa a função ScopeCancelaPreAutMedicamento */
	MNU_EMPRESTIMO_SAQUE,		/*!< Relativa a funcao ScopeEmprestimo. */
	MNU_TRANSACAOPOS,			/*!< Relativa a funcao ScopeTransacaoPOS. */
	MNU_SAQUECONTRATO,			/*!< Relativa a funcao ScopeSaqueContrato */
	
	/* Opcoes PINPad */
	MNU_PPOPEN,					/*!< Relativa a funcao ScopePPOpen. */
	MNU_PPCLOSE,				/*!< Relativa a funcao ScopePPClose. */
	MNU_PPABORT,				/*!< Relativa a funcao ScopePPAbort. */
	MNU_PPGETINFO,				/*!< Relativa a funcao ScopePPGetInfo. */
	MNU_PPDISP,					/*!< Relativa a funcao ScopePPDisplay. */
	MNU_PPDISPEX,				/*!< Relativa a funcao ScopePPDisplayEx. */
	MNU_PPGETKEY,				/*!< Relativa a funcao ScopePPGetKey. */
	MNU_PPPIN,					/*!< Relativa a funcao ScopePPGetPIN. */
	MNU_PPPINEX,				/*!< Relativa a funcao ScopePPGetPINEx. */
	MNU_PPGETCARD				/*!< Relativa a funcao ScopePPGetCard. */
};

// estrutura de parametros de configuracao da TEF externa para funcoes de 
//	pagamento de contas
typedef struct {
	char	CodigoRede[3+1];
	char	CodigoNSU[8+1];
	char	CodigoNSUHost[15+1];
	char	PAN[23+1];
} TIPO_TEF_EXTERNA;

// estrutura de parametros de configuracao dos dados da aplicacao para a 
//	funcao ScopeForneceCampo
typedef struct {
	char	TipoTerminal;	// pode ser 'A' de ATM ou 'P' de PDV
	char	Usuario[20+1];	// codigo do operador
} TIPO_DADOS_APLIC;

// estrutura de parametros de configuracao do ambiente do PDV
typedef struct {
	char				Empresa[10];
	char				Filial[10];
	char				PDV[10];
	BYTE				PPCompartConfigurado;
	BYTE				PPUsoExclusivoScope;
	BYTE				PPPortaSerial;
	BOOL				ExibirCabecalho;
	BOOL				ExibirModoEntrada;
	BOOL				ContabilizaTotalTEF;
	BOOL				UsaSaldoVoucher;
	BOOL				CancelaOperacaoPP;
	BOOL				ObtemServicos;
	BOOL				ImpressoraCarbonada;
	BOOL				SenhaCriptografada;
	BOOL				ArmazenaDadosTransacao;
	BOOL				AbrirDigitacaoPP;
	int					MascaraDados;
	BOOL				PlataformaPromociaolCielo;
	int					CodigoBandeira;
	BYTE				CodigoRedePBM;
	int					VersaoPBM;
	int					VersaoListaPBM;
	BOOL				TratamentoDaQueda;
	BOOL				ExibeMenuDinamico;
	BOOL				AtualizaTransEmQueda;
	TIPO_TEF_EXTERNA	TEFExterna;
	BOOL				DeveEnviarListaSKU;	// Define se deve enviar lista de SKU para a rede Givex
	TIPO_DADOS_APLIC	DadosAplicacao;
	BOOL				LimpaTela;
	char				TipoTerminal;
} TIPO_CONFIGURACAO_PDV;

#define		_MULTI_TEF				TRUE	/*!< MultiTEF habilitado. */

#define		_ECF					FALSE	/*!< Nao Utiliza ECF. */

#define		_OBTEM_SERVICOS 		FALSE	/*!< Habilita o estado TC_OBTEM_SERVICOS. */

#define		_PERMITE_CANC_OPER_PP 	TRUE	/*!< Permite que o operador cancele a
												 operacao no pinpad.	*/

#define		_APL_ACESSA_PP			TRUE	/*!< Indica que a aplicacao tambem acessa o
												 PINPad. */

#define		_SIMULA_PDV				FALSE	/*!< Nao simula um pdv com teclado operador
												 (usado em certificacao). */

#define		_TECLADO				0x0004
#define		_CARTAO_MAGNETICO		0x0020

#define		_DESFAZ_TEF				0		/*!< Cancela a transacao realizada
												 anteriormente. */
#define		_CONFIRMA_TEF			1		/*!< Confirma a transacao. */

/*!< Primeira funcao de TEF valida. */
#define		_OPCAO_INI_TEF			MNU_CREDITO
/*!< Primeira funcao de acesso ao PP valida. */
#define		_OPCAO_INI_PP			MNU_PPOPEN
/*!< 'Ultima funcao de acesso ao PP. */
#define		_OPCAO_FIN_PP			MNU_PPGETCARD
/*!< 'Ultima funcao de TEF valida. */
#define		_OPCAO_FIN_TEF			MNU_TROCOSURPRESA

#define		_TAM_MAX_LINHAS			20
#define		_TAM_MAX_COLUNAS		40
#define		_TAM_MAX_CENTER			128


#ifdef _SCOPEDOS
	Sleep (int time)	{ return(0); }
#elif defined (_SCOPELNX)
	Sleep (int time)	{ usleep (time * 1000) };
#endif


BYTE	bRedePBM;
TIPO_CONFIGURACAO_PDV	ConfiguracaoPDV;
// Arquivos .txt lidos para teste
#define FILE_ATUALIZAPRECOTICKET "PrecosMercTicket.txt"
#define FILE_MERCADORIASTICKET "MercadoriasTicket.txt"

BOOL demo_SolicitaEntradaInteira(const char* Mensagem, int* InteiroEntrada);
BOOL demo_ObtemListaPrecos(char *_BufferSaida, unsigned int *_TamBuf);

/* IMPLEMENTACOES */

/**
	Fara' a leitura de uma string do teclado.

	@param	pIn	Buffer aonde a string sera' armazenada.
	@param	iSz	O tamanho de pIn.
 */

void demo_gets (P_CHAR pIn, int iSz)
{
	int	iCont,
		iChr	= 0;

	memset (pIn, 0, iSz);

	for (iCont = 0; iChr != '\n'; iCont++)
	{
		iChr = fgetc (stdin);

		if ( (iChr != '\n') && (iCont < iSz) )
			pIn [iCont] = iChr;
	}

	return;
}


/**
	A funcao fara' a leitura de um tecla (acao do
	usuario).
 */

char demo_ReadKey (void)
{
#ifdef __linux__
	char	Key [6];

	demo_gets ( Key, sizeof (Key) );

	return (Key [0]);
#else
	return ( (char) getche () );
#endif
}


/**
	Funcao auxiliadora para recebimento de uma tecla
	(via teclado).
 */

char demo_ReadKeyUP (void)
{
	return ( toupper ( demo_ReadKey () ) );
}


/**
	Procedimentos para a inicializacao da comunicacao com
	o servidor SCoPE.

	@param	argc	Contador de argumentos (parametro padrao C).
	@param	argv	Ponteiro para os parametros passados na
					linha-de-comando (parametro padrao C).

	@return	FALSE	Problema na comunicacao com o servidor.
	@return	TRUE	Sucesso na conexao.
 */

BOOL demo_AbreConexaoServidor (int _argc, P_CHAR _argv [])
{
	LONG	RC;

	char	Empresa [10],
			Filial [10],
			Pdv [10];

	/*	Parametros de inicializacao.
		Entrada via digitacao. */
	if (_argc < 4)
	{
		printf ("\n\nEmpresa [NNNN] ? "); demo_gets ( Empresa, sizeof (Empresa) );
		printf ("\nFilial  [NNNN] ? "); demo_gets ( Filial, sizeof (Filial) );
		printf ("\nPDV     [NNN]  ? "); demo_gets ( Pdv, sizeof (Pdv) );
	}
	/* Entrada via linha-de-comando */
	else
	{
		strncpy (Empresa, _argv [1], 4);
		strncpy (Filial, _argv [2], 4);
		strncpy (Pdv, _argv [3], 3);
	}

	/* Para garantirmos o terminador da string */
	Empresa [4] = Filial [4] = Pdv [3] = 0;

	/* Realizar a conexao fisica com o servidor */
	printf ("\n\nScopeOpen \"%s\" \"%s\" \"%s\"...\n",
										Empresa, Filial, Pdv);

	RC = ScopeOpen ("2", Empresa, Filial, Pdv);

	if (RC != RCS_SUCESSO)
	{
		printf ("Erro ScopeOpen(), RC = %x (%ld)\n", RC, RC);

		demo_ReadKey ();
		return (FALSE);
	}

	return (TRUE);
}


/**
	Procedimento para finalizacao da comunicao com
	o servidor SCoPE.
 */

void demo_FechaConexaoServidor (void)
{
	LONG	RC;

	/* Solicitao o fechamento do canal com o servidor SCoPE */
	RC = ScopeClose ();

	if (RC != 0)
	{
		printf ("\nScopeClose, RC = %x (%ld)\n", RC, RC);
		demo_ReadKey ();
	}
}

/**
	Procedimento para inicializacao de uma transacao.

	@return	FALSE	Falha na inicializacao.
	@return	TRUE	Sucesso.
 */

BOOL demo_AbreSessaoTEF (P_INT _NroTrnOk)
{
	LONG	RC;

	/* Chamada 'a funcao da API */
	RC = ScopeAbreSessaoTEF ();

	/* Abre uma sessao multi-TEF */
	if (RC != RCS_SUCESSO)
	{
		printf ("\nErro ScopeAbreSessaoTEF(), RC = %x (%ld)\n", RC, RC);
		demo_ReadKey ();
		return (FALSE);
	}

	/* Inicializa o nro. de transacoes TEFs aprovadas */
	*_NroTrnOk = 0;

	return (TRUE);
}


/**
	Realiza o procedimento para termino de uma sessao TEF.
	Basicamente essa funcao desfara' todos os passos
	realizados na funcao demo_AbreSessaoTEF().

	@param	_NroTrnOk	Contador de transacoes realizadas
						com sucesso (diretamente
						relacionada 'a funcao
						demo_ExecutaFuncao () ).
 */

void demo_FechaSessaoTEF (int _NroTrnOk)
{
	LONG	RC;

	BYTE	Acao,
			Filler;

	if (_NroTrnOk == 0)
		/* Nao houve tefs aprovadas entao apenas fecha a sessao */
		RC = ScopeFechaSessaoTEF (_DESFAZ_TEF, &Filler);
	else
	{
		if (_SIMULA_PDV)
			Acao = CONFIRMA_TEF;
		else
		{
			/* Define operacao (confirma ou desfaz) ? */
			printf ("\n\n[C] = Confirmar TEF(s)\n[D] = Desfaz TEF(s)\n\nOpcao ? ");

			/* Coleta acao */
			Acao = (demo_ReadKeyUP () == 'D') ?
									DESFAZ_TEF : CONFIRMA_TEF ;
		}

		/* Envia a confirmacao ou desfazimento */
		RC = ScopeFechaSessaoTEF (Acao, &Filler);

		if (RC == RCS_SUCESSO)
			printf ( "\n\nTEF(s) %s com sucesso!",
					(Acao == DESFAZ_TEF ? "desfeita(s)" : "confirmada(s)") );
		else
			printf ("\n\nErro ao %s a(s) TEF(s)! Resultado da operacao (RC: %ld)",
					(Acao == DESFAZ_TEF ? "desfazer" : "confirmar"), RC);
	}
}


/**
	Procedimento para configuracao da forma de
	entrada dos dados.
 */

void demo_ConfiguraColeta (void)
{
	/* Informa que esta aplicacao deseja coletar
		os dados */
	ScopeSetAplColeta ();

	/* Configura a interface Scope */
	if (_PERMITE_CANC_OPER_PP)
		ScopeConfigura (CFG_CANCELAR_OPERACAO_PINPAD, OP_HABILITA);

	if (_OBTEM_SERVICOS)
		ScopeConfigura (CFG_OBTER_SERVICOS, OP_HABILITA);

	ScopeConfigura (CFG_IMPRESSORA_CARBONADA, OP_HABILITA);

	ScopeConfigura (CFG_DEVOLVER_SENHA_CRIPTOGRAFADA, OP_HABILITA);

	return;
}


/**
	Ira' forcar um desfazimento de operacao,
	garantindo a recuperacao no caso de queda de energia.
 */

void demo_VerificaSessaoAnteriorTEF (void)
{
	LONG	RC;

	BYTE	DesfezTEF	= FALSE;

	/* Trata a queda de energia da transacao anterior, se houver */
	RC = ScopeFechaSessaoTEF (DESFAZ_TEF, &DesfezTEF);

	if ( (RC == RCS_SUCESSO) && (DesfezTEF) )
	{
		/*        ....+....1....+....2....+....3....+....4 */
		printf ("\n-----           ATENCAO!            -----\n");
		printf ("\n A TRANSACAO TEF ANTERIOR FOI DESFEITA.  \n");
		printf ("\n          RETER O CUPOM TEF.             \n\n\n");

		demo_ReadKey ();
	}
}


/**
	Realiza o procedimento para uso do PINPad.

	@return	FALSE	Falha na abertura do recurso.
	@return	TRUE	Sucesso.
 */

BOOL demo_AbrePINPad (void)
{
	BYTE	config,
			exclusivo,
			porta;

	LONG	RC;

	ScopeValidaInterfacePP (PP_INTERFACE_LIB_COMPARTILHADA);

	/* Consulta como esta' configurado o PIN-Pad
		compartilhado no ScopeCNF */
	RC = ScopeConsultaPP (&config, &exclusivo, &porta);

	if (RC != PC_OK)
	{
		printf ("erro ScopeConsultaPP: %ld\n", RC);

		demo_ReadKey ();

		return (FALSE);
	}

	if ( config && (! exclusivo) )
	{
		/* Abre conexao com PINPad */
		printf ("\nConectando ao PINPad...");

		RC = ScopePPOpen (porta);

		if (RC != PC_OK)
		{
			printf ("falhou!\nErro ao abrir o PIN-Pad: %ld\n", RC);

			demo_ReadKey ();

			return (FALSE);
		}
	}

	return (TRUE);
}


/**
	Procedimento para finalizacao da comunicacao
	com o PINPad.
 */

void demo_FechaPINPad (void)
{
	ScopePPClose ("SCOPE");
}


/**
	Exibira' algumas das funcoes disponiveis na
	API do SCoPE.

	return	A opcao selecionada.
 */

int demo_SelecionaFuncao (void)
{
	int		iOp;

	char	Op [7]		= {0},
			cValid [2]	= {0};

	/* Exibe menu */
	do
	{
		printf ("\n\n\n");
		printf ("--------------------------------------------------------------\n");
		printf ("SELECIONE UMA FUNCAO\n");
		printf ("--------------------------------------------------------------\n");
		printf ("\n%.2d: Sair\n", MNU_SAIR);
		printf ("\n%.2d: Credito                  %.2d: Transacao Financeira",
														MNU_CREDITO, MNU_TRANSFINANC);
		printf ("\n%.2d: Debito                   %.2d: Investimento",
														MNU_DEBITO, MNU_INVESTIM);
		printf ("\n%.2d: Consulta Cheque          %.2d: Consulta Saldo do Cliente",
														MNU_CCHEQUE, MNU_CONSULTSALDCLIEN);
		printf ("\n%.2d: Consulta CDC             %.2d: Consulta dados da Transacao",
														MNU_CCDC, MNU_CONSULTTRANSAC);
		printf ("\n%.2d: Consulta Credito         %.2d: Pagamento",
														MNU_CONSULTCHEQUE, MNU_PAGTO);
		printf ("\n%.2d: Cancelamento             %.2d: Compra Vale Gas",
														MNU_CANCELAMENTO, MNU_COMPVALEGAS);
		printf ("\n%.2d: Resumo Vendas            %.2d: Menu (outros)",
														MNU_RESUMOVENDAS, MNU_MENU);
		printf ("\n%.2d: Reimpressao Comprovante  %.2d: Consulta Saldo Credito",
														MNU_REIMPCOMPR, MNU_CONSULTSALDCRED);
		printf ("\n%.2d: Recarga de Celular       %.2d: Consulta Vale Gas",
														MNU_RECARGCEL, MNU_CONSULTVALEGAS);
		printf ("\n%.2d: Consulta Medicamentos    %.2d: Pre-autorizacao Credito",
														MNU_CONSULTMEDIC, MNU_PREAUTCRED);
		printf ("\n%.2d: Compra Medicamentos      %.2d: Consulta Garantia Desc Cheque",
														MNU_COMPMEDIC, MNU_CONSULTGARANTDESCCHEQ);
		printf ("\n%.2d: Consulta AVS             %.2d: Cartao Presente Carga",
														MNU_CONSULTAVS, MNU_CARTAODINHEIROCARGA);
		printf ("\n%.2d: Cartao Presente Compra   %.2d: Consulta Cartao Dinheiro",
														MNU_CARTAODINHEIROCOMPRA, MNU_CONSULTACARTAODINHEIRO);
		printf ("\n%.2d: Troco Surpresa           %.2d: Atualiza Precos Mercadorias", MNU_TROCOSURPRESA, MNU_ATUALIZA_PRECO);
	    printf ("\n%.2d: Simulacao Crediario      %.2d: Captura pre-autorizacao",MNU_SIMULACAOCREDIARIO,MNU_CAPTURAPREAUTORIZAO);
	    printf ("\n%.2d: Elegibilidade Cartao Med %.2d: Cancela Pre-aut. Medicamento",MNU_ELEGCARTAO,MNU_CANC_PREAUTPBM);
		printf ("\n%.2d: Emprestimo / Saque       %.2d: Transacao POS",MNU_EMPRESTIMO_SAQUE,MNU_TRANSACAOPOS);
		printf ("\n%.2d: Saque contrato",MNU_SAQUECONTRATO);
	
		if (_APL_ACESSA_PP)
		{
			printf ("\n");
			printf ("\n%.2d: ScopePPOpen              %.2d: ScopePPGetKey",
																MNU_PPOPEN, MNU_PPGETKEY);
			printf ("\n%.2d: ScopePPClose             %.2d: ScopePPGetPIN",
																MNU_PPCLOSE, MNU_PPPIN);
			printf ("\n%.2d: ScopePPAbort             %.2d: ScopePPGetPINEx",
																MNU_PPABORT, MNU_PPPINEX);
			printf ("\n%.2d: ScopePPGetInfo           %.2d: ScopePPGetCard",
																MNU_PPGETINFO, MNU_PPGETCARD);
			printf ("\n%.2d: ScopePPDisplay", MNU_PPDISP);
			printf ("\n%.2d: ScopePPDisplayEx", MNU_PPDISPEX);
		}

		printf ("\n\n");

		/* Coleta opcao */
		printf ("Opcao ? "); demo_gets ( Op, sizeof (Op) ); printf ("\n");

		iOp = atoi (Op);

		cValid [0] = ( (! _APL_ACESSA_PP) && (iOp >= MNU_PPOPEN) );

		cValid [1] = ( iOp && ( (iOp > _OPCAO_FIN_TEF) ||
								(iOp < _OPCAO_INI_TEF) ) );
	} while ( cValid [0] && cValid [1] );

	return (iOp);
}


/**
	Procedimento para consulta de uma transacao.
 */

void demo_ConsultaTransacao (void)
{
	LONG				RC;

	stDadosTransacao	DadosTr			= {0};

	char				Controle [11+1]	= {0};

	printf ("\n\nControle ? ");
	demo_gets ( Controle, sizeof (Controle) );

	RC = ScopeConsultaTransacao (Controle, 0,
			sizeof (stDadosTransacao), (P_CHAR) &DadosTr);

	if (RC == RCS_SUCESSO)
	{
		printf ("\nScopeConsultaTransacao retornou RC = RCS_SUCESSO\n");

		printf ("\n Bandeira                                    = [%s]", DadosTr.CodBandeira);
		printf ("\n Rede                                        = [%s]", DadosTr.CodRede);
		printf ("\n Codigo Estabelecimento                      = [%s]", DadosTr.CodEstab);
		printf ("\n Empresa                                     = [%s]", DadosTr.Empresa);
		printf ("\n Filial                                      = [%s]", DadosTr.Filial);
		printf ("\n POS                                         = [%s]", DadosTr.POS);
		printf ("\n Data e Hora do Estabelecimento [mmddhhmmss] = [%s]", DadosTr.DtHrEstab);
		printf ("\n Data Administrativa [mmdd]                  = [%s]", DadosTr.DtAdministr);
		printf ("\n Data e Hora GMT [mmddhhmmss]                = [%s]", DadosTr.DtHrGmt);
		printf ("\n Valor                                       = [%s]", DadosTr.Valor);
		printf ("\n Texto do Servico                            = [%s]", DadosTr.TxServico);
		printf ("\n Valor do Saque                              = [%s]", DadosTr.ValorSaque);
		printf ("\n Cartao                                      = [%s]", DadosTr.Cartao);
		printf ("\n Data do Vencimento do Cartao                = [%s]", DadosTr.DtVencCartao);
		printf ("\n Banco                                       = [%s]", DadosTr.Banco);
		printf ("\n Agencia                                     = [%s]", DadosTr.Agencia);
		printf ("\n Numero Cheque                               = [%s]", DadosTr.NumCheque);
		printf ("\n Codigo Autorizacao                          = [%s]", DadosTr.CodAut);
		printf ("\n Codigo Resposta                             = [%s]", DadosTr.CodResp);
		printf ("\n NSU do Host                                 = [%s]", DadosTr.NSUHost);
		printf ("\n Numero de Parcelas                          = [%s]", DadosTr.NumParcelas);
		printf ("\n Codigo Gr do Servico                        = [%s]", DadosTr.CodGrServico);
		printf ("\n Codigo do Servico                           = [%s]", DadosTr.CodServico);
		printf ("\n NSU                                         = [%s]", DadosTr.NSU);
		printf ("\n Mensagem de Status                          = [%c]", DadosTr.StatusMsg);
		printf ("\n Mensagem da Situacao                        = [%c]", DadosTr.SitMsg);
		printf ("\n Digitado                                    = [%d]", DadosTr.Digitado);
	}
	else
		printf ("\nScopeConsultaTransacao retornou RC = [%ld]", RC);

	printf ("\n\nPressione alguma tecla para continuar...");

	demo_ReadKey ();

	return;
}


/**
	Procedimento para uso do PINPad.

	@param	_Opcao	Opcao seleta na funcao demo_SelecionaFuncao relativa
					'as funcoes para uso do PINPad (valores de
					_OPCAO_INI_PP 'a _OPCAO_FIN_PP).
 */

void demo_TrataPINPad (int _Opcao)
{
	#define	AUXTAM			255

	char	aux [255]		= {0},
			notify [255],
			work [64];

	int		tipo_dado		= 0;

	LONG	RC				= 0;

	BYTE	iPorta			= 0;

	/* chama a funcao escolhida */
	switch (_Opcao)
	{
		/* Inicia comunicacao com o PINPad */
		case MNU_PPOPEN:
			printf ("Porta Serial ? "); demo_gets ( aux, sizeof (aux) ); printf ("\n");

			iPorta = (BYTE) atoi (aux);

			RC = ScopePPOpen (iPorta);

			break;

		/* Finaliza a comunicacao com o PINPad */
		case MNU_PPCLOSE:
			RC = ScopePPClose ("     Scope        Itautec S.A.");

			break;

		/* Cancela a 'ultima operacao realizada no PINPad */
		case MNU_PPABORT:
			RC = ScopePPAbort ();

			break;

		/* Retorna informacoes do PINPad */
		case MNU_PPGETINFO:
			printf ("Tipo de dados (entre 0 e 3)? ");
			demo_gets ( aux, sizeof (aux) ); printf ("\n");

			tipo_dado = atoi (aux);

			RC = ScopePPGetInfo ( (WORD) tipo_dado,
										(WORD) sizeof (aux), aux );

			printf ("\nScopePPGetInfo retornou = [%s]\n", aux);

			if (RC == RCS_SUCESSO)
			{
				if (tipo_dado == 0)
				{
					printf ("Nome do fabricante do PIN-Pad..: [%20.20s]\n", &aux[ 0]);
					printf ("Modelo / versao do hardware....: [%20.20s]\n", &aux[20]);
					printf ("Versao do firmware.............: [%20.20s]\n", &aux[40]);
					printf ("Versao da especificacao........: [%4.4s]  \n", &aux[60]);
					printf ("Versao da aplicacao basica.....: [%16.16s]\n", &aux[64]);
					printf ("Numero de serie do PIN-Pad.....: [%20.20s]\n", &aux[80]);
				}
				else
				{
					printf ("Nome da rede adquirente (RA).........: [%20.20s]\n", &aux [ 0]);
					printf ("Versao da aplicacao da RA............: [%13.13s]\n", &aux [20]);
					printf ("Informacoes proprietarias da RA......: [%7.7s]  \n", &aux [33]);
					printf ("Tamanho em bytes dos proximos dados..: [%2.2s]  \n", &aux [40]);
					printf ("Dados binarios do modulo SAM.........: [%s]\n", &aux [42]);
				}
			}

			break;

		/* Exibe uma msg no display do PINPad */
		case MNU_PPDISP:
		case MNU_PPDISPEX:
			printf ("Digite o texto 'a ser exibido " \
					"(digite '\\n' p/ quebra-de-linha):\n\n");

			printf ("0        1         2         3         4         5         6\n" \
					"123456789012345678901234567890123456789012345678901234567890\n");

			demo_gets ( aux, sizeof (aux) ); printf ("\n");

			RC = strlen (aux);

			aux [RC - 1] = 0;

			/* Substituir os possiveis '\n' por 0x0D */
			for (tipo_dado = 0; aux [tipo_dado] &&
						(tipo_dado + 1 < AUXTAM); tipo_dado++)
			{
				if (aux [tipo_dado] == '\\' &&
						aux [tipo_dado + 1] == 'n')
				{
					aux [tipo_dado++] = 0x0D;

					memmove (aux + tipo_dado,
						aux + tipo_dado + 1, RC - tipo_dado);
				}
			}

			aux [tipo_dado] = 0;

			if (_Opcao == MNU_PPDISP)
				RC = ScopePPDisplay (aux);
			else
			{
				/*	P/ essa funcao e' necessario especificar
					a qtde de caracteres 'a serem exibidos */
				RC = strlen (aux);

				if (RC + 3 < AUXTAM)
					memmove (aux + 3, aux, RC);

				sprintf (work, "%.3d", RC);

				memcpy (aux, work, 3);

				RC = ScopePPDisplayEx (aux);
			}

			break;


		/* Inicia a captura de teclas no PINPad */
		case MNU_PPGETKEY:
			RC = ScopePPStartGetKey ();

			if (RC != PC_OK)
			{
				printf ("Erro na ScopePPStartGetKey: %d", RC);

				break;
			}

			printf ("\nPressione uma Tecla no PINPad\n");

			do
			{
				RC = ScopePPGetKey ();
			}
			while (RC == PC_PROCESSING);

			break;

		/* Inicia a captura de teclas no PINPad em modo senha */
		case MNU_PPPIN:
			RC = ScopePPStartGetPIN ("DIGITE A SENHA");

			if (RC != PC_OK)
			{
				printf ("Erro na ScopePPStartGetPIN: %d", RC);

				break;
			}

			printf ("\nDigite a Senha\n");

			do
			{
				RC = ScopePPGetPIN (aux);
			}
			while (RC == PC_PROCESSING);

			printf ("\nScopePPGetPIN retornou = [%s]\n", aux);

			break;

		/*	Inicia a captura de teclas no PINPad em modo senha (com
			opcoes estendidas) */
		case MNU_PPPINEX:
			RC = ScopePPStartGetPINEx ("DIGITE A SENHA",
											0, 0, NULL, NULL);

			if (RC != PC_OK)
			{
				printf ("Erro na ScopePPStartGetPINEx: %d", RC);

				break;
			}

			printf ("\nDigite a Senha\n", RC);

			do
			{
				RC = ScopePPGetPINEx (aux);
			}
			while (RC == PC_PROCESSING);

			printf ("\nScopePPGetPINEx retornou = [%s]\n", aux);

			break;

		/* Inicio do procedimento para leitura do cartao */
		case MNU_PPGETCARD:
			RC = ScopePPStartGetCard (0, "000");

			if (RC != PC_OK)
				break;

			printf ("\nInsira ou Passe o Cartao\n", RC);

			do
			{
				RC = ScopePPGetCard (0, notify, sizeof(aux), aux);

				if (RC == PC_NOTIFY)
					printf ("\n%s\n", notify);
			}
			while (RC == PC_NOTIFY || RC == PC_PROCESSING);

			if (RC == PC_OK)
				printf ("\nScopePPGetCard retornou = [%s]\n", aux);

			break;

		default:
			printf ("\n\n\n(PPad)Opcao Invalida !\n"); demo_gets ( work, sizeof (work) );

			return;
	}

	if (RC == PC_OK)
		printf ("\nRC = %d [OK]\n", RC);
	else
	{
		ScopePPMsgErro (RC, aux);
		printf ("\nRC = %d [%s]\n", RC, aux);
	}

	printf ("\n[ Pressione uma tecla para continuar... ]\n", RC);

	demo_ReadKey ();

	return;
}


/**
	Funcao responsavel pela execucao da funcao selecionada
	na funcao demo_SelecionaFuncao ().

	@param	iOp	O numero da funcao (valida entre os numeros
				_OPCAO_INI_TEF e _OPCAO_FIN_TEF)

	@return	Valores de retorno das funcoes do SCoPE.
 */

LONG demo_IniciaTransacaoTEF (int iOp)
{
	char	Valor [15]		= {0},
			Rede [10],
			CupomFiscal [7]	= {0},
			Servico [3]		= {0};

	LONG	RC				= 0;
	WORD codRede;
	WORD codBandeira;
	WORD codServico;
	int iServico;
	/* chama a funcao escolhida */
	switch (iOp)
	{
		/* credito */
		case MNU_CREDITO:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeCompraCartaoCredito (Valor, "");
			break;

		/* debito */
		case MNU_DEBITO:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeCompraCartaoDebito (Valor);
			break;

		/* consulta cheque */
		case MNU_CCHEQUE:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeConsultaCheque (Valor);
			break;

		/* consulta CDC */
		case MNU_CCDC:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeConsultaCDC (Valor, "");
			break;

		/* consulta credito */
		case MNU_CONSULTCHEQUE:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeConsultaCredito (Valor, "");
			break;

		/* cancelamento */
		case MNU_CANCELAMENTO:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeCancelamento (Valor, "");

			break;

		/* resumo de vendas */
		case MNU_RESUMOVENDAS:
			RC = ScopeResumoVendas ();

			break;

		/* reimpressao de comprovante */
		case MNU_REIMPCOMPR:
			RC = ScopeReimpressaoComprovante ();

			break;

		/* recarga celular */
		case MNU_RECARGCEL:
			RC = ScopeRecargaCelular ();

			break;

		/* consulta ao sistema farmaco (medicamentos) */
		case MNU_CONSULTMEDIC:
			printf ("\n\nRede (01)e-Pharma (02)Vidalink (03)PrevSaude (04)FuncionalCard (05)GoodCard");
			printf ("\n     (06)Novartis (07)FlexMed  (08)Datasus   (09)FarmaSeg      (10)PharmaLink\nOpcao? ");

			demo_gets ( Rede, sizeof (Rede) );

			bRedePBM = (BYTE) atoi (Rede);

			RC = ScopeConsultaMedicamento (0, bRedePBM);

			break;

		/* compra de medicamentos */
		case MNU_COMPMEDIC:
			printf ("\n\nRede (01)e-Pharma (02)Vidalink (03)PrevSaude (04)FuncionalCard (05)GoodCard");
			printf ("\n     (06)Novartis (07)FlexMed  (08)Datasus   (09)FarmaSeg      (10)PharmaLink\nOpcao? ");

			demo_gets ( Rede, sizeof (Rede) );

			bRedePBM = (BYTE) atoi (Rede);

			printf ("\n\nNumero do cupom ? "); demo_gets ( CupomFiscal, sizeof (CupomFiscal) );

			RC = ScopeCompraMedicamento
							(0, bRedePBM, CupomFiscal);

			break;

		/* transacao financeira */
		case MNU_TRANSFINANC:
			printf ("\n\nServico: 70=Saldo, 71=ExtratoResumido, 72=Extrato, 73=SimulacaoSaque, 74=Saque");
			printf ("\n\nServico ? "); demo_gets ( Servico, sizeof (Servico) );

			RC = ScopeTransacaoFinanceira
								( "000", (WORD) atoi (Servico) );

			break;

		/* investimento */
		case MNU_INVESTIM:
			printf ("\n\nServico: 75=Saldo, 76=Extrato, 77=ResgateAvulso, 78=Resgate");
			printf ("\n\nServico: 105=Deposito CDB, 106=Resgate CDB");
			printf ("\n\nServico ? "); demo_gets ( Servico, sizeof (Servico) );

			RC = ScopeInvestimento ( "000", (WORD) atoi (Servico) );

			break;

		/* procedimento de consulta de saldo do cartao de debito */
		case MNU_CONSULTSALDCLIEN:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeConsultaSaldoDebito (Valor);

			break;

		/* pagamento de conta.
			primeiro parametro pode ser:
				- S_PAGAMENTO_CONTA_COM_CARTAO (85)
				- S_PAGAMENTO_CONTA_SEM_CARTAO (87)
				- S_PAGAMENTO_FATURA (91)
			segundo parametro: enumerador eBandeira */
		case MNU_PAGTO:
			RC = ScopePagamento (87, 92);

			break;

		/* compra Vale Gas.
			primeiro parametro:
				- S_COMPRA_VALE_GAS (25)

			segundo argumento: bandeira 'a ser utilizada
				(enumerador eBandeira).

			terceiro argumento: o valor 'a ser utilizado. */
		case MNU_COMPVALEGAS:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeServicosGenericos (25, B_VALEGAS, Valor);

			break;

		/* menu (outros servicos) */
		case MNU_CONSULTAVS:
			RC = ScopeConsultaAVS ();

			break;

		/* menu (outros servicos) */
		case MNU_MENU:
			RC = ScopeMenu (0);

			break;

		/*	procedimento de consulta de saldo do cartao
			de credito */
		case MNU_CONSULTSALDCRED:
			RC = ScopeConsultaSaldoCredito ();

			break;

		/* Troco Surpresa
			primeiro parametro pode ser:
				- S_TROCO_SURPRESA (118)

			segundo parametro: bandeira 'a ser utilizada
				- B_GETNET (166).

			terceiro argumento: o valor 'a ser utilizado. */
		case MNU_TROCOSURPRESA:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeServicosGenericos (118, 166, Valor);

			break;

		/* consulta Vale Gas
			primeiro parametro pode ser:
				- S_CONSULTA_VALE_GAS (103)

			segundo parametro: bandeira 'a ser utilizada
				(enumerador eBandeira).

			terceiro argumento: o valor 'a ser utilizado. */
		case MNU_CONSULTVALEGAS:
			printf ("\n\nValor ? "); demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeServicosGenericos (103, B_VALEGAS, Valor);

			break;

		/* pre-autorizacao de credito */
		case MNU_PREAUTCRED:
			printf("\n\nValor da transacao? ");

			demo_gets ( Valor, sizeof (Valor) );

			RC = ScopePreAutorizacaoCredito (Valor, "");

			break;

		/* garantia de cheque */
		case MNU_CONSULTGARANTDESCCHEQ:
			printf ("\n\nValor ? ");

			demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeGarantiaDescontoCheque (Valor);

			break;

		/* Cartao presente */
		case MNU_CARTAODINHEIROCARGA:
			RC = 110;
		case MNU_CARTAODINHEIROCOMPRA:
			if (RC == 0)
				RC = 98;

			printf ("\n\nValor ? ");

			demo_gets ( Valor, sizeof (Valor) );

			RC = ScopeCartaoDinheiro ( (WORD) RC, Valor );

			break;

		case MNU_CONSULTACARTAODINHEIRO:
			RC = ScopeConsultaCartaoDinheiro ();
			break;

		case MNU_ATUALIZA_PRECO:
			RC = ScopeAtualizaPrecosMercadorias(228, "");
			break;
		case MNU_SIMULACAOCREDIARIO:
			printf ("\n\nValor ? ");
			demo_gets ( Valor, sizeof (Valor) );
			RC = ScopeSimulacaoCrediario(1, Valor, "");
			break;

		case MNU_CAPTURAPREAUTORIZAO:
			printf ("\n\nValor ? ");
			demo_gets ( Valor, sizeof (Valor) );
			RC = ScopeCapturaPreAutorizacaoCredito(Valor, "");
			break;
		
		/* - Elegibilidade do Cartao */
		case MNU_ELEGCARTAO:
			RC = ScopeElegibilidadeCartao (0,10);
			break;
		case MNU_CANC_PREAUTPBM:
		//	RC = ScopeCancelaPreAutMedicamento (0, (BYTE)ConfiguracaoPDV.CodigoRedePBM);
			RC = ScopeCancelaPreAutMedicamento (0, 10);
			break;

			// emprestimo ou saque da Leader
		case MNU_EMPRESTIMO_SAQUE:
			printf ("\n\nValor ? ");
			demo_gets ( Valor, sizeof (Valor) );
			printf ("\nTipo de servico (0-Fluxo/1-Emprestimo/2-Saque)\n");
			printf("Opcao: ");
			scanf("%d",&iServico);
			
			if (iServico == 1)
			{
				// Emprestimo
				iServico = 130;
			}
			else if (iServico == 2)
			{
				// Saque
				iServico = 74;
			}
			else
			{
				// invalido
				iServico = 0;
			}

			RC = ScopeEmprestimo(Valor, (WORD)iServico, (WORD)119);
			break;

			/* Transacao POS */
		case MNU_TRANSACAOPOS:;
			if (_VALORES_FLUXO_FIXO)
			{
				strcpy(Valor, "37655");
				codRede = R_CIELO;
				codBandeira = B_BNDES;
				codServico = 6; // débito a vista
			}
			else
			{
				printf ("\n\nValor ? ");
				demo_gets ( Valor, sizeof (Valor) );
				demo_SolicitaEntradaInteira("Codigo Rede", (int *) &codRede);
				demo_SolicitaEntradaInteira("Codigo da Bandeira ", (int *) &codBandeira);
		    	demo_SolicitaEntradaInteira("Codigo do Servico", (int *) &codServico);
			}

			RC = ScopeTransacaoPOS(Valor, codRede, codBandeira, codServico);
			break;

			case MNU_SAQUECONTRATO:
				RC = ScopeSaqueContrato();
			break;

		default:
			printf ("\n\n\n(IT)Opcao Invalida !\n"); demo_ReadKeyUP ();

			break;
	}

	if (RC != RCS_SUCESSO)
		printf ("Erro na demo_IniciaTransacaoTEF. RC: 0x%X (%ld)", RC, RC);

	return (RC);
}


/**
	Recupera do sistema a atual mensagem de erro do SCoPE.

	@param[out]	_MsgErro	O buffer 'a ser preenchido com
							a mensagem.
 */

void demo_ObtemMsgOp2Erro (P_CHAR _MsgErro)
{
	LONG			RC;

	stCOLETA_MSG	LastMsg;

	RC = ScopeGetLastMsg (&LastMsg);

	if (RC == RCS_SUCESSO)
		strcpy (_MsgErro, LastMsg.Op2);
	else
		printf ("erro demo_ObtemMsgOp2Erro: %ld\n", RC);
}


/**
	Procedimento para centralizacao de texto.

	@param[out]	_Campo	Buffer 'a ser centralizado usando como
						base o tamanho passado em _Len.
	@param		_Len	O tamanho maximo 'a ser utilizado como
						largura.
 */

void demo_CenterTx (P_CHAR _Campo, int _Len)
{
	char	Aux [_TAM_MAX_CENTER];
	int		Pos						= (int) ( (_Len -
										strlen (_Campo) ) / 2 );

	if (_Len > _TAM_MAX_CENTER)
	{
		_Campo [0] = 0;
		return;
	}

	memset (Aux, ' ', Pos);
	strcpy ( &Aux [Pos], _Campo);
	strcpy (_Campo, Aux);
}


/**
	Procedimento para descongestionar a exibicao
	dos dados no monitor.
 */

void demo_LimpaTela (void)
{
#ifdef __linux__
	system ("clear");
#else
	system ("cls");
#endif
}


/**
	Funcao para exibicao e formatacao das mensagens
	recebidas do SCoPE.

	@param	_MsgCl1	Primeira linha da mensagem 'a ser
					exibida ao cliente.
	@param	_MsgCl2	Segunda linha da mensagem 'a ser
					exibida ao cliente.
	@param	_MsgOp1	Primeira linha da mensagem 'a ser
					exibida ao operador.
	@param	_MsgOp2	Segunda linha da mensagem 'a ser
					exibida ao operador.
 */

void demo_ExibeMsgTela (P_CHAR _MsgCl1, P_CHAR _MsgCl2,
						P_CHAR _MsgOp1, P_CHAR _MsgOp2)
{
	char	MsgAuxCl1 [40 + 1],
			MsgAuxCl2 [40 + 1],
			MsgAuxOp1 [40 + 1],
			MsgAuxOp2 [40 + 1];

	printf ("\n\n");

	strcpy (MsgAuxCl1, _MsgCl1);
	strcpy (MsgAuxCl2, _MsgCl2);
	strcpy (MsgAuxOp1, _MsgOp1);
	strcpy (MsgAuxOp2, _MsgOp2);

	demo_CenterTx (MsgAuxCl1, 40);
	demo_CenterTx (MsgAuxCl2, 40);
	demo_CenterTx (MsgAuxOp1, 40);
	demo_CenterTx (MsgAuxOp2, 40);

	demo_LimpaTela ();

	/*       ....+....1....+....2....+....3....+....4    */
	printf ("X########### TELA DO CLIENTE ############X\n");
	printf ("X%-40.40sX\n", MsgAuxCl1);
	printf ("X%-40.40sX\n", MsgAuxCl2);
	printf ("X########################################X\n");

	printf ("\n\n\n\n");

	printf ("+--------- TECLADO DO OPERADOR-----------+\n");
	printf ("|%-40.40s|\n", MsgAuxOp1);
	printf ("|%-40.40s|\n", MsgAuxOp2);
	printf ("+----------------------------------------+\n");
}


/**
	Funcao responsavel pela exibicao das mensagens
	retornadas do SCoPE 'a serem exibidas pela aplicacao.

	@param	_pColeta	Estrutura comum para coleta dos
						dados.
 */

void demo_ExibeMsgFluxo (ptPARAM_COLETA _pColeta)
{
	demo_ExibeMsgTela (_pColeta->MsgCl1, _pColeta->MsgCl2,
						_pColeta->MsgOp1, _pColeta->MsgOp2);
}


/**
	Procedimento para a coleta do cartao pela aplicacao.

	@param[out]	_Cartao		O conteudo do cartao ('a ser
							preenchido).
	@param[out]	wCaptura	A forma em que o cartao foi lido.
							Valores de retorno possiveis:
							- _CARTAO_MAGNETICO
							- _TECLADO
 */

void demo_ColetaCartao (P_CHAR _Cartao, P_WORD wCaptura)
{
	printf ("\nCartao ? "); demo_gets (_Cartao, 100); printf ("\n");

	*wCaptura = ( (strchr (_Cartao, '=') != NULL) ||
					(strchr (_Cartao, 'D') != NULL) ) ?
								_CARTAO_MAGNETICO : _TECLADO;

	return;
}


/**
	Funcao utilizada para selecao da acao desejada
	do usuario. Complementa da funcao demo_FinalizaTransacaoTEF ().

	@param	_pColeta		Estrutura comum para coleta dos
							dados.

	@return	PROXIMO_ESTADO	Prosseguir no proximo estagio do
							processo.
	@return	ESTADO_ANTERIOR	Retornar ao estagio anterior do
							processo.
	@return	CANCELAR		Cancelar o processo.
 */

char demo_ColetaAcao (ptPARAM_COLETA _PColeta)
{
	BOOL	bProximo = FALSE,
			bRetorna = FALSE,
			bCancela = FALSE;

	int		iKey;

	/*	verifica qual teclas estao disponiveis para
		o usuario */
	bCancela = ( (_PColeta->HabTeclas & 0x01) != 0 );
	bProximo = ( (_PColeta->HabTeclas & 0x02) != 0 );
	bRetorna = ( (_PColeta->HabTeclas & 0x04) != 0 );

	printf ("%s %s %s\n", bRetorna ? "[(R)etorna]" : "",
							bProximo ? "[(P)roximo]" : "",
							bCancela ? "[(C)ancela]" : "");

	iKey = demo_ReadKeyUP ();

	/* verifica qual botao o usuario pressionou */
	switch (iKey)
	{
		case 'R':
			iKey = ESTADO_ANTERIOR;

			break;

		case 'C':
			iKey = CANCELAR;

			break;

		case 'P':
		default:
			iKey = PROXIMO_ESTADO;

			break;
	}

	return ( (char) iKey );
}


/**
	Procedimento para exibicao das informacoes
	disponiveis do cheque.
 */

void demo_ExibeCheque (void)
{
	LONG	RC					= RCS_SUCESSO;

	stPARAM_CHEQUE	ParamCheque	= {0};

	printf ("\n\nCheque\n");

	RC = ScopeGetCheque (&ParamCheque);

	if (RC == RCS_SUCESSO)
		printf ("Banco = %s\n" \
				"Agencia = %s\n" \
				"Numero do cheque = %s\n" \
				"Valor = %s\n" \
				"Bom para = %s\n" \
				"Codigo da autorizadora = %s\n" \
				"Municipio = %s\n",
								ParamCheque.Banco,
								ParamCheque.Agencia,
								ParamCheque.NumCheque,
								ParamCheque.Valor,
								ParamCheque.BomPara,
								ParamCheque.CodAut,
								ParamCheque.Municipio);
	else
		printf ("erro ScopeGetCheque: %ld\n", RC);

	demo_ReadKey ();
}


/**
	Procedimento para exibicao/impressao do cupom fiscal.

	@param		_Titulo	O titulo 'a ser exibido.
	@param[out]	_Cupom	O corpo do cupom. Observe que este
						ponteiro sera' movido por uso
						interno da funcao, porem o conteudo
						do mesmo nao sera' alterado.
 */

void demo_ExibeCupomMonitor (P_CHAR _Titulo, P_CHAR _Cupom)
{
	int		NroLn = 0,
			Tam = 0;

	char	*p,
			Linha [_TAM_MAX_COLUNAS + 1];

	/* Monta a identificacao do cupom */
	strcpy (Linha, _Titulo);

	demo_CenterTx (Linha, _TAM_MAX_COLUNAS); printf ("\n\n\n\n");

	/*      ....+....1....+....2....+....3....+....4 */
	printf ("*****************************************\n");
	printf ("%s\n", Linha);
	printf ("*****************************************\n");

	/* Exibe o cupom no monitor respeitando
		as limitacoes de exibicao */
	while (*_Cupom)
	{
		p = strchr (_Cupom, '\n');

		if (p == NULL)
			break;

		/*	Iremos saber a quantidade de colunas que
			estao sendo utilizadas */
		Tam = (p - _Cupom);

		if (Tam > _TAM_MAX_COLUNAS)
			break;

		memset ( Linha, 0, sizeof (Linha) );
		memcpy (Linha, _Cupom, Tam);
		printf ("\n%s", Linha);

		if (++NroLn == _TAM_MAX_LINHAS)
		{
			NroLn = 0;

			printf ("\n[Pressione uma tecla para continuar...]");

			demo_ReadKey ();
		}

		/*	Avancando o ponteiro, procurando pelo
			proximo '\n' */
		_Cupom = p + 1;
	}

	demo_ReadKey ();
}


/**
	Procedimento para exibicao das informacoes que compoem
	um cupom 'a ser impresso.
 */

void demo_ExibeCupom (void)
{
	LONG	RC;

	BYTE	NroLnhReduzido		= 0;

	char	Cabec [1024]		= {0},
			CpCliente [2048]	= {0},
			CpLoja [2048]		= {0},
			CpReduzido [2048]	= {0};

	RC = ScopeGetCupomEx (sizeof (Cabec), Cabec,
							sizeof (CpCliente), CpCliente,
							sizeof (CpLoja), CpLoja,
							sizeof (CpReduzido), CpReduzido,
											&NroLnhReduzido);

	if (RC != RCS_SUCESSO)
	{
		printf ("\nScopeGetCupomEx retornou RC = [%ld]", RC);

		return;
	}

	if (_ECF)
		demo_ExibeCupomMonitor ("CABECALHO", Cabec);

	demo_ExibeCupomMonitor ("CUPOM DO CLIENTE", CpCliente);
	demo_ExibeCupomMonitor ("CUPOM DA LOJA", CpLoja);

	if (NroLnhReduzido > 0)
		demo_ExibeCupomMonitor ("CUPOM REDUZIDO", CpReduzido);

	printf ("\n\n\n\n");

	return;
}


/**
	Procedimento para exibicao dos medicamentos
	cadastrados.

	@param	A rede selecionada, p/ q seja usa a estrutura
			correta.
 */

void demo_ExibeListaMedicamentos (BYTE bRede)
{
	LONG		RC,
				lConvenio;

	BYTE		QtdVias			= 0,
				pBuff [2024];
	
	stREGISTRO_MEDICAMENTO_CRM
				lstMedsCRM [38]	= {0};

	ptREGISTRO_MEDICAMENTO
				lstMeds [38]	= {NULL};

	if ( (bRede == ID_PBM_NOVARTIS) ||
		(bRede == ID_PBM_FLEXMED) )
	{
		RC = ScopeObtemMedicamentos ( &QtdVias,
							(P_CHAR) &pBuff, sizeof (pBuff) );

		if (RC == RCS_SUCESSO)
			for (RC = 0; RC < QtdVias; RC++)
				lstMeds [RC] = (ptREGISTRO_MEDICAMENTO) ( pBuff +
							( RC * sizeof (stREGISTRO_MEDICAMENTO) ) );
	}
	else
	{
		RC = ScopeObtemMedicamentosComCRM ( &QtdVias, &bRede,
							(P_CHAR) &lstMedsCRM, sizeof (lstMedsCRM) );

		if (RC == RCS_SUCESSO)
			for (lConvenio = 0; lConvenio < QtdVias; lConvenio++)
				lstMeds [lConvenio] = &lstMedsCRM [lConvenio].RegistroM;
	}

	if (RC == RCS_SUCESSO)
	{
		printf ("\n\nLista de Medicamentos\n" \
			"Quantidade de Registros = %d\n", QtdVias);

		for ( ; QtdVias > 0; QtdVias--)
		{
			if ( (bRede != ID_PBM_NOVARTIS) && (bRede != ID_PBM_FLEXMED) )
				printf ("CRM: %.9d", lstMedsCRM [QtdVias - 1].CRM);

			printf ("\n\nProduto: %.2d" \
					"\nEAN: %.13s" \
					"\nQuantidade de Produtos: %.2s" \
					"\nPreco PMC: %.7s" \
					"\nPreco Venda: %.7s" \
					"\nPreco Fabrica: %.7s" \
					"\nPreco Aquisicao: %.7s" \
					"\nPreco Repasse: %.7s" \
					"\nMotivo Rejeicao: %.2s\n",
						QtdVias,
						lstMeds [QtdVias - 1]->CodigoEAN,
						lstMeds [QtdVias - 1]->QtdProdutos,
						lstMeds [QtdVias - 1]->PrecoPMC,
						lstMeds [QtdVias - 1]->PrecoVenda,
						lstMeds [QtdVias - 1]->PrecoFabrica,
						lstMeds [QtdVias - 1]->PrecoAquisicao,
						lstMeds [QtdVias - 1]->PrecoRepasse,
						lstMeds [QtdVias - 1]->MotivoRejeicao);
		}
	}
	else
		printf ("erro ScopeObtemMedicamentos: %ld\n", RC);

	demo_ReadKey ();

	return;
}


/**
	Procedimento para exibicao dos servicos
	disponiveis da Vale-Gas.
 */

void demo_ExibeValorConsultaValeGas (void)
{
	LONG	RC;

	char	Valor [20]	= {0};

	RC = ScopeObtemConsultaValeGas (Valor);

	if (RC == RCS_SUCESSO)
		printf ("\nValor da Consulta = %s\n", Valor);
	else
		printf ("erro ScopeObtemConsultaValeGas: %ld\n", RC);

	return;
}


/**
	Procedimento para atualizacao do valor de uma
	transacao.
 */

void demo_AtualizaValor (void)
{
	LONG	RC;

	char	ValorMedicamentos [15]	= {0};

	printf ("\nValor Total dos Medicamentos = ? ");
	demo_gets ( ValorMedicamentos, sizeof (ValorMedicamentos) ); printf ("\n");

	if (strlen (ValorMedicamentos) > 0)
	{
		RC = ScopeAtualizaValor (ValorMedicamentos);

		if (RC != RCS_SUCESSO)
			printf ("erro ScopeAtualizaValor: %ld\n", RC);
	}

	return;
}


/**
	Procedimento para exibicao da mensagem de erro
	do SCoPE.
 */

void demo_ExibeMsgErro (void)
{
	LONG			RC;

	stCOLETA_MSG	LastMsg;

	RC = ScopeGetLastMsg (&LastMsg);

	if (RC == RCS_SUCESSO)
		demo_ExibeMsgTela (LastMsg.Cl1,
				LastMsg.Cl2, LastMsg.Op1, LastMsg.Op2);
	else
		printf ("erro ScopeGetLastMsg: %ld\n", RC);
}


/**
	Procedimento para recuperacao da transacao em
	andamento.
 */

void demo_ExibeDadosTransacao (void)
{
	LONG	h;

	char	aux [128]	= {0};

	/* receber o identificador da transacao */
	h = ScopeObtemHandle (0);

	if (h <= 0xFFFF)
	{
		printf ("\n\nErro ScopeObtemHandle, RC = %x (%d)\n", h, h);
		return;
	}

	/* receber e exibir as infos  */
	ScopeObtemCampoExt (h,
			NSU_transacao, 0x00, '\0', aux);
	printf ("\nNSU      = [%s]", aux);

	memset ( aux, 0, sizeof (aux) );
	ScopeObtemCampoExt (h, Numero_Conta_PAN,
								0x00, '\0', aux);
	printf ("\nCartao   = [%s]", aux);

	memset ( aux, 0, sizeof (aux) );
	ScopeObtemCampoExt (h,
			Cod_Rede + Nome_Rede, 0x00, ':', aux);
	printf ("\nRede     = [%s]", aux);

	memset ( aux, 0, sizeof (aux) );
	ScopeObtemCampoExt (h, Cod_Bandeira +
				Nome_Bandeira, 0x00, ':', aux);
	printf ("\nBandeira = [%s]\n", aux);

	memset ( aux, 0, sizeof (aux) );
	ScopeObtemCampoExt (h, Controle_Dac,
								0x00, '\0', aux);
	printf ("\nControle_Dac = [%s]", aux);

	memset ( aux, 0, sizeof (aux) );
	ScopeObtemCampoExt (h, Cartao_Trilha02,
								0x00, '\0', aux);
	printf ("\nCartao_Trilha = [%s]", aux);

	memset(aux, '\0', sizeof(aux));
	ScopeObtemCampoExt (h, Saldo_Disponivel,
								0x00, ':', aux);
	printf("\nSaldo_Disponivel = [%s]", aux);
}


/**
	Procedimento para recuperacao dos servicos disponiveis.
 */

void demo_ObtemServicosTEF (void)
{
	int					i;

	LONG				RC;

	stPARAM_SERVICOS	Serv	= {0};

	Serv.TamCampoAtributos =
				sizeof (stATRIB_SERVICO) * MAX_PROD_PARAM;

	RC = ScopeObtemServicosEx (0, &Serv);

	if (RC == RCS_SUCESSO)
	{
		printf ("\nScopeObtemServicosEx retornou RC = RCS_SUCESSO\n\n");

		printf ("Informacoes do servico:\n\n");
		printf ("\t* Aceita digitacao das informacoes? %c\n",
											(Serv.AceitaDigitacao) ? 'S' : 'N');
		printf ("\t* Solicita os 4 ultimos digitos do cartao? %c\n",
											(Serv.PedeUlt4Digitos) ? 'S' : 'N');
		printf ("\t* Solicita a taxa do servico? %c\n",
											(Serv.AceitaTxServico) ? 'S' : 'N');
		printf ("\t* Porcentagem maxima da taxa: %d\n", Serv.MaxTaxPercent);
		printf ("\t* Solicita senha pessoal? %c\n",
												(Serv.ObtemSenha) ? 'S' : 'N');
		printf ("\t* Master Key: %d\n", Serv.PosMasterKey);
		printf ("\t* Working Key: %.16s\n", Serv.WorkingKey);
		printf ("\t* Numero de servicos disponiveis: %d\n", Serv.NumServicos);
		printf ("\t* Tamanho do campo atributos, em bytes: %d\n",
												Serv.TamCampoAtributos);

		if (Serv.NumServicos > 0)
		{
			printf ("\nListagem dos servicos disponiveis e seus atributos:\n");
			for (i = 0; i < Serv.NumServicos; i++)
			{
				printf ("\nId Servico = [%d]\n", i);

				printf ("\tRede: ");

				switch (Serv.Atributos[i].Rede)
				{
					case R_ITAU:
						printf ("Itau, ");
						break;

					case R_VISANET:
						printf ("VISANet, ");
						break;

					case R_REDECARD:
						printf ("RedeCard, ");
						break;

					case R_BANKTEC:
						printf ("Banktec, ");
						break;

					case R_VISANET_41:
						printf ("VISANet 4.1, ");
						break;

					default:
						printf ("%d, ", Serv.Atributos[i].Rede);
						break;
				}

				printf ("Bandeira: %d, Codigo do servico: %d\n" \
						"\tA rede esta'%sativada, Pre-autorizacao? %c," \
						" Emissao de nota promissoria: %c",
									Serv.Atributos[i].Bandeira,
									Serv.Atributos[i].CodServico,
									(Serv.Atributos[i].RedeInativa) ? " des" : " ",
									(Serv.Atributos[i].PreAutorizacao) ? 'S' : 'N',
									(Serv.Atributos[i].EmitePromissoria) ? 'S' : 'N');

				printf ("\tMoeda: %d, Cheque: tipo de consulta: %s," \
						" Qtd minima de parcelas: %d\n" \
						"\tQtd maxima de parcelas: %d," \
						" Qtd maxima de pre-datados: %d\n" \
						"\tDia para o pre-datado: %d," \
						" Qtd de parcelas: %d, Dia da parcela: %d\n" \
						"\tDia da primeira parcela: %.2d,",
												Serv.Atributos[i].MoedaServicoCredito,
												(Serv.Atributos[i].TipoConsultaCheque == TCC_BASICA) ?
												"basica" :
												(Serv.Atributos[i].TipoConsultaCheque == TCC_BANCO_COM_CONTINGENCIA) ?
												"banco com contigencia" :
												(Serv.Atributos[i].TipoConsultaCheque == TCC_COMPLETA) ?
												"completa" : "banco sem contigencia",
												Serv.Atributos[i].LimInfParcelas,
												Serv.Atributos[i].LimSupParcelas,
												Serv.Atributos[i].LimPreDatado,
												Serv.Atributos[i].DiaPredatado,
												Serv.Atributos[i].QtdParcela,
												Serv.Atributos[i].DiaParcela,
												Serv.Atributos[i].DiaPrimParcela);

				printf (" Menor valor permitido: %.12s\n\tMaior valor permitido: %.12s\n",
												Serv.Atributos[i].LimInfValor,
												Serv.Atributos[i].LimSupValor);
			}
		}
	}
	else
		printf ("\nScopeObtemServicosEx retornou RC = [%ld]\n", RC);

	printf ("\n");

	return;
}


/**
	Recupera a lista de operadores cadastradas no
	SCoPE.
 */

void demo_ExibeListaOperadoras (void)
{
	int						i;
	stREC_CEL_OPERADORAS	ListaOper	= {0};
	stREC_CEL_ID_OPERADORA	Oper;

	/* Recupera as operadoras */
	if (ScopeRecuperaOperadorasRecCel
			(REC_CEL_OPERADORAS_MODELO_2,
				(P_CHAR) &ListaOper,
					sizeof (ListaOper) ) != RCS_SUCESSO)
		return;

	printf ("\n\n LISTA DE OPERADORAS:\n\n");
	printf ("\nNumero de operadoras de celular = [%d]",
									ListaOper.NumOperCel);

	/* Exibe as operadoras */
	for (i = 0; i < (int) ListaOper.NumOperCel; i++)
	{
		memset (&Oper, 0, sizeof (stREC_CEL_ID_OPERADORA) );
		memcpy (&Oper,
			&ListaOper.OperCel [ i * sizeof (stREC_CEL_ID_OPERADORA) ],
									sizeof (stREC_CEL_ID_OPERADORA) );
		printf ("\nCodigo da operadora = [%d]\tNome = [%.21s]",
								Oper.CodOperCel, Oper.NomeOperCel);
	}

	printf ("\n\n");

	return;
}


/**
	Procedimento para recuperacao dos valores disponiveis
	para a recarga de celular.
 */

void demo_ExibeListaValores (void)
{
	int							i,
								iTipoVal		= REC_CEL_VALORES_MODELO_2;

#ifdef _SCOPE225
	/* PR062197 - Projeto Recarga de celular - fase II - início */
	stREC_CEL_VALORES_MODELO_3	ListaValores	= {0};
	char						aux [6]			= {0};

	/* PR062197 - Recarga de Celular - fase II */
	i = ScopeObtemHandle (HDL_TRANSACAO_EM_ANDAMENTO);

	if (i > 0xFFFF)
	{
		ScopeObtemCampoExt (i, Cod_Rede, 0x00, '\0', aux);

		if (atoi (aux) == R_GWCEL)
			iTipoVal = REC_CEL_VALORES_MODELO_3;
	}
	/* PR062197 - Projeto Recarga de celular - fase II - fim */
#else
	stREC_CEL_VALORES			ListaValores	= {0};
#endif

	/* Recupera os valores */
	if (ScopeRecuperaValoresRecCel ( (BYTE) iTipoVal,(P_CHAR) &ListaValores, sizeof (ListaValores) ) != RCS_SUCESSO)
		return;

	/* Exibe os valores */
	printf ("\n\n LISTA DE VALORES:\n\n");
	printf ("\nTipo do valor: %s", (ListaValores.TipoValor == 'V') ? "variavel" :
									(ListaValores.TipoValor == 'F') ? "fixo" :
									"fixo ou variavel");
	printf ("\nValor minimo de recarga: [%.12s]", ListaValores.ValorMinimo);
	printf ("\nValor maximo de recarga: [%.12s]", ListaValores.ValorMaximo);
	printf ("\nValor total: [%d]", ListaValores.Totvalor);

	for (i = 0; i < (int) ListaValores.Totvalor; i++)
		printf ("\n     Valor = [%.12s]   Bonus = [%.12s]   Custo = [%.12s]",
											ListaValores.TabValores [i].Valor,
											ListaValores.TabValores [i].Bonus,
											ListaValores.TabValores [i].Custo);

#ifdef _SCOPE225
	if (ListaValores.TotFaixaValores > 0)
	{
		printf ("\n\n FAIXA DE VALORES:\n\n");

		printf ("\nQuantidade de Faixas de Valores          = [%d]\n",
											ListaValores.TotFaixaValores);

		for (i = 0; i < (int) ListaValores.TotFaixaValores; i++)
			printf ("\n     ValorMinimo = [%.12s]   ValorMaximo = [%.12s]",
								ListaValores.TabFaixaValores [i].ValorMin,
								ListaValores.TabFaixaValores [i].ValorMax);
	}
#endif

	printf ("\nMensagem promocional: [%.41s]\n\n",
										ListaValores.MsgPromocional);

	return;
}


/**
	Funcao especifica 'a plataforma Linux, responsavel por
	informar a quantidade de teclas disponiveis no buffer
	do sistema.

	@return	A quantidade de teclas em buffer.
 */

#ifdef _SCOPELNX
	int demo_kbhit (void)
	{
		int	cnt = 0;

		ioctl (0, FIONREAD, &cnt);

		return (cnt);
	}
#elif !defined(_SCOPEDOS)
	#define	demo_kbhit	_kbhit
#endif


/**
	Captura da senha do usuario.

	@param		_pColeta	Estrutura comum para coleta dos
							dados.
	@param[out]	_Senha		A senha informada pelo
							usuario/cliente.
 */

void demo_ColetaSenha (ptPARAM_COLETA _pColeta, P_CHAR _Senha)
{
	printf ("\nMaster Key = [%d] Working Key = [%.255s]\n",
					_pColeta->PosMasterKey, _pColeta->WrkKey);

	printf ("\nSenha ? "); demo_gets (_Senha, 320);
	printf ("\n");

	return;
}


/**
	Funcao complementar aos procedimentos realizados
	pela demo_IniciaTransacaoTEF ().
 */

LONG demo_FinalizaTransacaoTEF (void)
{
	LONG			RC;
	LONG		scopeHandle;
	WORD			wCaptura;
	char aux [5000]	= {0};
	char			acao,
					Work [120]	= {0};

	stPARAM_COLETA	PColeta;

	/* Processo da TEF */
	while (TRUE)
	{
		/* Enquanto a transacao estiver em
			andamento, aguarda */
		while ( ( RC = ScopeStatus () ) ==
						RCS_TRN_EM_ANDAMENTO )
			Sleep (200);

		/*	Configurado que o operador podera cancelar
						a operacao no pinpad via teclado */
		if (_PERMITE_CANC_OPER_PP)
		{
			if (RC == TC_COLETA_CARTAO_EM_ANDAMENTO)
			{
				acao = ( demo_kbhit () &&
						(demo_ReadKeyUP () == 'C') ) ?
							CANCELAR : PROXIMO_ESTADO;

				ScopeResumeParam ( (WORD) RC, "", 0, acao );

				continue;
			}
		}

		/* Se estiver fora da faixa FC00 a FCFF,
								finaliza o processo */
		if ( (RC < TC_PRIMEIRO_TIPO_COLETA) ||
						(RC > TC_MAX_TIPO_COLETA) )
		{
			if (RC == RCS_SUCESSO)
			{
				demo_ExibeDadosTransacao ();
				printf ("\n\nTEF finalizado com Sucesso !\n");
			}
			else
			{
				demo_ObtemMsgOp2Erro (Work);

				printf ("\n\nErro ScopeStatus, RC = 0x%x (%d) [%s]\n",
												RC, RC, Work);
			}

			break;
		}

		/* Exibe status */
		if (! _SIMULA_PDV)
			printf ("\n\nScopeStatus, RC = %x (%d)\n", RC, RC);

		/* Inicializa variveis do fluxo */
		acao = PROXIMO_ESTADO;

		wCaptura = _TECLADO;

		memset ( Work,		0, sizeof (Work) );

		memset ( &PColeta,	0, sizeof (PColeta) );

		/* Obtem dados do Scope e exibe as mensagens
			do cliente e operador */
		ScopeGetParam ( (WORD) RC, &PColeta );

		demo_ExibeMsgFluxo (&PColeta);

		/* Trata os estados */
		switch (RC)
		{
			/* cartao */
			case TC_CARTAO:
			case TC_COLETA_AUT_OU_CARTAO:
				demo_ColetaCartao (Work, &wCaptura);

				acao = demo_ColetaAcao (&PColeta);

				break;

			/* imprime Cheque */
			case TC_IMPRIME_CHEQUE:
				demo_ExibeCheque ();

				break;

			/* imprime Cupom Parcial */
			case TC_IMPRIME_CUPOM_PARCIAL:
			/* imprime Cupom + Nota Promissoria +
				Cupom Promocional */
			case TC_IMPRIME_CUPOM:
			/* imprime Consulta */
			case TC_IMPRIME_CONSULTA:
				demo_ExibeCupom ();

				break;

			/* recupera lista de Medicamentos */
			case TC_DISP_LISTA_MEDICAMENTO:
				demo_ExibeListaMedicamentos (bRedePBM);

				break;

			/* recupera valor do Vale Gas */
			case TC_DISP_VALOR:
				demo_ExibeValorConsultaValeGas ();

				break;

			/* se coletou lista de medicamentos, deve
				tambem atualizar o valor. */
			case TC_COLETA_REG_MEDICAMENTO:
					strcpy (Work, "01XXXXXXXXXXXXX");

					demo_AtualizaValor ();

					break;
	
			/*	apenas mostra informacao e deve
				retornar ao scope */
			case TC_INFO_RET_FLUXO:
			/* transacao em andamento */
			case TC_COLETA_EM_ANDAMENTO:
				break;

			/* recupera os servicos configurados */
			case TC_OBTEM_SERVICOS:
				demo_ObtemServicosTEF ();

				acao = demo_ColetaAcao (&PColeta);

				break;

			/* recupera a lista de operadoras da
				Recarga de Celular */
			case TC_COLETA_OPERADORA:
				demo_ExibeListaOperadoras ();

				printf ("\nCodigo da operadora ? ");
				demo_gets ( Work, sizeof (Work) ); printf ("\n");

				acao = demo_ColetaAcao (&PColeta);

				break;

			/* recupera a lista de valores da
				Recarga de Celular */
			case TC_COLETA_VALOR_RECARGA:
				demo_ExibeListaValores ();

				printf ("\nValor de recarga ? ");
				demo_gets ( Work, sizeof (Work) ); printf ("\n");

				acao = demo_ColetaAcao (&PColeta);

				break;

			/* captura da senha do usuario */
			case TC_SENHA:
				demo_ColetaSenha (&PColeta, Work);

				acao = demo_ColetaAcao (&PColeta);

				break;

			/*	mostra informacao e aguarda
				confirmacao do usuario */
			case TC_INFO_AGU_CONF_OP:
				acao = demo_ColetaAcao (&PColeta);

				break;
				// coleta dados do ECF e do cupom fiscal para a 
			// transacao de debito voucher com o TICKET CAR
			case TC_COLETA_DADOS_ECF:
				//Obtem o ECF
				ScopeForneceCampo(SCOPE_DADOS_ECF_BENEFICIO, Work);
				break;

			// coleta Lista de Mercadorias para a 
			// transacao de debito voucher com o TICKET CAR
			case TC_COLETA_LISTA_MERCADORIAS:
				scopeHandle = ScopeObtemHandle(9);
				if (scopeHandle > 0xFFFF) 
				{
					ScopeObtemCampoExt2(scopeHandle,  0x00,0x00 ,Max_Mercadorias_TicketCar, 0x00 , aux);
					printf("\nMaximo Mercadorias: [%s] \n" ,aux);
				}

//				Obtem a lista de mercadorias <<TODO- Descomentar aqui>>
			//	demo_ObtemListaMercadorias(Work, sizeof(Work));
				ScopeForneceCampo(SCOPE_DADOS_LISTA_MERCADORIAS,Work);
				break;

			// coleta Lista para Atualização de Precos (TICKET CAR)
			case TC_COLETA_LISTA_PRECOS:
				{
					int TamBuf= sizeof(Work);
					demo_ObtemListaPrecos(Work, &TamBuf);
					ScopeForneceCampo(SCOPE_DADOS_LISTA_PRECOS,Work);
					break;
				}

			/* deve coletar algo... */
			default:
				printf ("\nColeta ? ");

				demo_gets ( Work, sizeof (Work) );

				printf ("\n");

				acao = demo_ColetaAcao (&PColeta);

				break;
		}

		/* retorna ao scope */
		RC = ScopeResumeParam ( (WORD) RC,
				Work, wCaptura, (eACAO_APL) acao );

		if (RC != RCS_SUCESSO)
		{
			if (! _SIMULA_PDV)
				printf ("\n\nScopeResumeParam, RC = %x (%d)\n", RC, RC);

			demo_ExibeMsgErro ();

			/* Se apenas dados invalido, retorna a coleta */
			if (RC == RCS_DADO_INVALIDO)
				continue;

			break;
		}
		else
			continue;
	}

	return (RC);
}


/**
	Direciona o fluxo do programa para a funcao selecionada.

	@param		_Opcao		A funcao 'a ser executada. Valores:
							de _OPCAO_INI_TEF 'a _OPCAO_FIN_TEF.
	@param[out]	_NroTrnOk	Registro da quantidade de transacoes
							realizadas com sucesso.
 */

void demo_ExecutaFuncao (int _Opcao, P_INT _NroTrnOk)
{
	/*  Realiza consulta dados de uma transacao TEF */
	if (_Opcao == MNU_CONSULTTRANSAC)
	{
		/* Para esta transacao nao e' necessario
			executar o fluxo de coleta */
		demo_ConsultaTransacao ();

		return;
	}

	/* Executa funcoes do PINPad */
	if ( (_Opcao >= _OPCAO_INI_PP) &&
						(_Opcao <= _OPCAO_FIN_PP) )
	{
		demo_TrataPINPad (_Opcao);

		return;
	}

	/* Executa uma transacao TEF */
	if (demo_IniciaTransacaoTEF (_Opcao) == RCS_SUCESSO &&
			demo_FinalizaTransacaoTEF () == RCS_SUCESSO)
		*_NroTrnOk += 1;

	return;
}


/**
	Funcao utilizada para a definicao do fluxo do programa.

	@param	_Opcao	Seletor do fluxo do programa. Caso o seu valor
					esteja entre _OPCAO_INI_TEF e _OPCAO_FIN_TEF,
					sera' exibida a pergunta para continuacao da
					sessao TEF. Caso contrario, incondicionalmente
					sera' retornado FALSE, indicando o termino da
					sessao.

	@return	TRUE	O usuario confirmou a continuacao da sessao.
	@return	FALSE	O usuario solicitou o termino da sessao.
 */

BOOL demo_ContinuaSessaoTEF (int _Opcao)
{
	char	Work [16];

	/* Continua na Sessao TEF? */
	if ( (_Opcao >= _OPCAO_INI_TEF) &&
					(_Opcao <= _OPCAO_FIN_TEF) )
	{
		printf ("\n\n\nContinua na Sessao TEF (S/N) ? ");
		demo_gets ( Work, sizeof (Work) );

		if (toupper (Work [0]) == 'S')
			return (TRUE);
	}

	return (FALSE);
}


/**
	Entry point do programa-teste.

	@param	argc	Contador de argumentos (parametro padrao C).
	@param	argv	Ponteiro para os parametros passados na
					linha-de-comando (parametro padrao C).

	@return	0		Retorno com sucesso.
	@return	-1		Retorno com erro.
 */

int main (int argc, P_CHAR argv [])
{
	int		Opcao		= 0,
			NroTrnOk	= 0;

	BOOL	SessaoTEF	= TRUE,
			Loop		= TRUE;

		/*	Informa ao Scope qual interface do PINPad sera
		utilizada.

		O uso desta funcao e' opcional.
		Opcoes:
			- PP_NAO_UTILIZA
			- PP_INTERFACE_LIB_VISA
			- PP_INTERFACE_LIB_COMPARTILHADA

		Esta informacao sera validada pela funcao ScopeOpen().
	ScopeValidaInterfacePP (PP_INTERFACE_LIB_COMPARTILHADA); */

	/* Abre conexao com o servidor Scope */
	if ( ! demo_AbreConexaoServidor (argc, argv) )
		return (-1);

	/* Configura o fluxo de coleta dos dados */
	demo_ConfiguraColeta ();

	/* Faz uso do recurso PINPad compartilhado */
	if (_APL_ACESSA_PP)
		demo_AbrePINPad ();

	/* Trata a transacao TEF anterior, se houve queda
		de energia */
	demo_VerificaSessaoAnteriorTEF ();

	while (Loop)
	{
		/* Abre uma sessao TEF */
		if (! demo_AbreSessaoTEF (&NroTrnOk) )
			return (-1);

		while (SessaoTEF)
		{
			/* Seleciona funcao */
			if ( ! ( Opcao = demo_SelecionaFuncao () ) )
			{
				Loop = FALSE;
				SessaoTEF = FALSE;

				continue;
			}

			/* Executa a funcao */
			demo_ExecutaFuncao (Opcao, &NroTrnOk);

			/* Continua na sessao TEF? */
			if ( _MULTI_TEF && demo_ContinuaSessaoTEF (Opcao) )
				continue;

			break;
		}

		/* Fecha a sessao TEF */
		demo_FechaSessaoTEF (NroTrnOk);
	}

	/* Encerra conexao com o servidor */
	demo_FechaConexaoServidor ();

	/* Desconecta ao pinpad */
	if (_APL_ACESSA_PP)
		demo_FechaPINPad ();

	return (0);
}

//==============================================================================
//  FUNCAO:		demo_ObtemListaMercadorias
//
//  DESCRICAO:	Funcao para obter os dados de lista de mercadorias (TicketCar).
//				Embora ela preencha um buffer fixo, foi criada esta funcao para 
//				futuramente adicionar logica de obter dados diferentes e variar 
//				os dados de teste. Podem ler do teclado ou de um arquivo.
//
//  DATA:		
//
//  AUTORES:	
//
//  ENTRADA:	_nSize
//
//  SAIDA:		_BufferSaida
//
//	RETORNO:	---
//
//==============================================================================
void demo_ObtemListaMercadorias(char* _BufferSaida, unsigned int _nSize)
{
	char szFileName[] = FILE_MERCADORIASTICKET;

	memset (_BufferSaida, 0, _nSize);

	// Obtem a lista de mercadorias do arquivo texto. Caso nao encontre o arquivo, monta uma lista de mercadorias hardcoded
//	if (!demo_GetBufferDadosFromTXT(szFileName, _BufferSaida, _nSize))
	{
		LPHeaderMercadorias		ptHeader;
		LPMercadoriaSC100		ptMercadoria100;

		ptHeader = (LPHeaderMercadorias)_BufferSaida;

		memmove(ptHeader->IDHeader,             "LM01", 4);
		ptHeader->CasasValorUnitMerc = '2'; 
		ptHeader->CasasQuantidadeMerc = '2';
		memmove(ptHeader->RamoAtiv,               "01", 2);
		memmove(ptHeader->IDReg,               "SC100", 5);
		memmove(ptHeader->QtdReg,                "002", 3);

		ptMercadoria100 = (LPMercadoriaSC100) (_BufferSaida + sizeof(stHeaderMercadorias));

		memmove (ptMercadoria100->Descricao,     "GASOLINA COMUM                          ", 40);
		memmove (ptMercadoria100->regticket.CodMercadoria, "00101",     5);	// Gasolina Comum
		memmove (ptMercadoria100->regticket.QtdMercadoria, "00002000",  8);	// 20 litros
		memmove (ptMercadoria100->regticket.ValorTrnsMerc, "000007780", 9);	// R$ 77,80
		memmove (ptMercadoria100->regticket.ValorUnitario, "000000389", 9);	// R$ 3,89

		ptMercadoria100 = (LPMercadoriaSC100) ((char *)ptMercadoria100 + sizeof(stMercadoriaSC100));

		memmove (ptMercadoria100->Descricao,     "ALCOOL   COMUM                          ", 40);
		memmove (ptMercadoria100->regticket.CodMercadoria, "00104",     5);	// Alcool Comum
		memmove (ptMercadoria100->regticket.QtdMercadoria, "00003000",  8);	// 30 litros
		memmove (ptMercadoria100->regticket.ValorTrnsMerc, "000006000", 9);	// R$ 60,00
		memmove (ptMercadoria100->regticket.ValorUnitario, "000000200", 9);	// R$ 2,00
	}
}
	

//==============================================================================
//  FUNCAO:		demo_ObtemListaPrecos
//
//  DESCRICAO:	Funcao para obter os dados de lista de precos (TicketCar).
//				Embora ela preencha um buffer fixo, foi criada esta funcao para 
//				futuramente adicionar logica de obter dados diferentes e variar 
//				os dados de teste. Podem ler do teclado ou de um arquivo.
//
//  ENTRADA:	_TamBuf - Tamanho maximo permitido para o _BufferSaida
//
//  SAIDA:		_BufferSaida - Buffer preenchido com a lista de precos
//              _TamBuf - Tamanho do _BufferSaida
//
//	RETORNO:	TRUE - Lista obtida com sucesso
//
//==============================================================================
BOOL demo_ObtemListaPrecos(char *_BufferSaida, unsigned int *_TamBuf)
{
	char szFileName[] = FILE_ATUALIZAPRECOTICKET;

	memset (_BufferSaida, 0, *_TamBuf);

	// Obtem a lista de precos do arquivo texto. Caso nao encontre o arquivo, monta uma lista de precos hardcoded
//	if (!((*_TamBuf) = demo_GetBufferDadosFromTXT(szFileName, _BufferSaida, *_TamBuf)))
	{
		char szAux[3 + 1] = {0};
		stHeaderPrecos		Header = {PREC_HEADER_LAYOUT_01, "ID504", "000"};
		stPrecoID504		Precos504[] = {
			{"20130220", "151052", "00101", "000000001160", "3"},
			{"20130220", "183620", "00102", "000000001590", "3"},
			{"20130220", "172335", "00103", "000000009730", "3"},
			{"20130220", "162225", "00104", "000000001040", "3"},
			{"20130220", "172211", "00105", "000000006350", "3"},
			{"20130220", "172335", "00106", "000000002530", "3"},
			{"20130220", "101233", "00107", "000000001910", "3"},
			{"20130220", "101519", "00108", "000000001250", "3"},
			{"20130220", "095828", "00109", "000000001170", "3"},
			{"20130220", "172337", "00110", "000000003140", "3"},
			{"20130220", "172337", "00111", "000000001570", "3"},
			{"20130220", "095828", "00112", "000000002420", "3"},
			{"20130220", "172356", "00133", "000000001160", "2"},
			{"20130220", "101948", "00134", "000000001590", "2"},
			{"20130220", "102553", "00135", "000000009730", "2"},
			{"20130220", "145901", "00136", "000000001040", "2"},
			{"20130220", "151004", "00137", "000000006350", "2"},
			{"20130220", "102313", "00138", "000000002530", "2"},
			{"20130220", "102315", "00139", "000000001910", "2"},
			{"20130220", "162137", "00140", "000000001250", "2"},
			{"20130220", "102140", "00141", "000000001170", "2"},
			{"20130220", "172234", "00142", "000000003140", "2"},
			{"20130220", "150732", "00143", "000000001570", "2"},
			{"20130220", "172337", "00144", "000000002420", "2"},
			{"20130220", "094616", "00145", "000000001600", "2"},
			{"20130220", "091246", "00146", "000000001490", "2"},
			{"20130220", "095831", "00147", "000000002640", "2"},
			{"20130220", "101948", "00148", "000000002190", "2"},
			{"20130220", "101950", "00149", "000000001230", "2"},
			{"20130220", "151004", "00150", "000000001270", "2"},
			{"20130220", "162137", "00151", "000000001040", "2"},
			{"20130220", "172242", "00152", "000000001220", "2"},
			{"20130220", "102008", "00153", "000000001090", "2"},
			{"20130220", "152212", "00154", "000000002500", "2"},
			{"20130220", "151052", "00155", "000000001180", "2"},
			{"20130220", "183337", "00156", "000000001040", "2"},
			{"20130220", "094617", "00157", "000000001100", "2"},
			{"20130220", "183337", "00158", "000000001560", "2"},
			{"20130220", "162137", "00159", "000000003020", "2"},
			{"20130220", "101950", "00160", "000000002620", "2"},
			{"20130220", "095831", "00161", "000000001040", "2"},
			{"20130220", "101220", "00162", "000000001150", "2"},
			{"20130220", "183920", "00163", "000000002500", "2"},
			{"20130220", "162212", "00164", "000000001070", "2"},
			{"20130220", "183337", "00165", "000000001060", "2"},
			{"20130220", "091246", "00166", "000000008590", "2"},
			{"20130220", "150730", "00167", "000000001600", "2"},
			{"20130220", "094617", "00168", "000000001140", "2"},
			{"20130220", "183335", "00169", "000000001270", "2"},
			{"20130220", "172356", "00170", "000000001760", "2"},
			{"20130220", "172030", "00171", "000000002160", "2"},
			{"20130220", "151052", "00172", "000000002160", "2"},
			{"20130220", "183335", "00173", "000000001300", "2"},
			{"20130220", "102538", "00174", "000000001870", "2"},
			{"20130220", "161110", "00175", "000000002490", "2"},
			{"20130220", "095828", "00176", "000000005120", "2"},
			{"20130220", "095828", "00177", "000000001230", "2"},
			{"20130220", "172337", "00178", "000000001110", "2"},
			{"20130220", "172337", "00179", "000000002650", "2"},
			{"20130220", "094617", "00180", "000000001180", "2"},
			{"20130220", "101220", "00181", "000000001850", "2"},
			{"20130220", "150732", "00182", "000000001050", "2"},
			{"20130220", "094617", "00183", "000000001040", "2"}
		};

		memset(_BufferSaida, 0x00, *_TamBuf);

		// Verifica tamanho disponivel para o _BufferSaida
		if((sizeof(stHeaderPrecos) + sizeof(Precos504)) >= *_TamBuf)
		{
			*_TamBuf = 0;
			return FALSE;
		}

		memset(szAux, 0x00, sizeof(szAux));

		// Calcula quantidade de registros
		sprintf(szAux, "%03d", sizeof(Precos504)/ sizeof(stPrecoID504));
		memmove(Header.QtdReg, szAux, 3);

		memset(szAux, 0x00, sizeof(szAux));

		memmove(_BufferSaida, &Header, sizeof(stHeaderPrecos));
		memmove(&_BufferSaida[sizeof(stHeaderPrecos)], Precos504 , sizeof(Precos504));

		*_TamBuf = sizeof(stHeaderPrecos) + sizeof(Precos504);
		_BufferSaida[*_TamBuf]= 0x00;
	}

	return TRUE;
}	

BOOL demo_SolicitaEntradaInteira(const char* Mensagem, int* InteiroEntrada)
{
	char teclado[124];

	printf("\n:%s ? ", Mensagem);
	scanf("%d",&teclado);
	*InteiroEntrada = atoi(teclado);
//	sprintf(msg, "\n:%s ? \'%d\'\n", Mensagem, *InteiroEntrada);

	return TRUE;
}
		  