/*********************     SCOPE (Solucao Completa de Pagamento Eletronico)     **************

 Arquivo      : ScopeApi.h

 Projeto      : SCoPE - Solucao Completa de Pagamento Eletronico

 Plataforma   : Genérica

 Descrição    : Arquivo padrão. As funções, estruturas e constantes	aqui definidas
                estão especificadas no documento "Scope Interface Aplicação.doc".

 -------------------------------------- HISTÓRICO --------------------------------------------
 Data     Autor        Alteração
 -------- ------------ -----------------------------------------------------------------------

*********************************************************************************************/



/********************************************************************************************

		DEFINE

*********************************************************************************************/
#ifndef		_SCOPEAPI
#define		_SCOPEAPI	1


/*--------------------------------------------------------------------------------------------
		Define padrao do Scope
--------------------------------------------------------------------------------------------*/
#if !defined(_SCOPEDOS) && !defined(__linux__)

	/* WINDOWS 32 -----------------------------------------------*/
	#define		dllScopeAPI		LONG  WINAPI
#else

	/* DOS, LINUX, UNIX e WINDOWS 16 ----------------------------*/
	typedef		unsigned char		BYTE;
	typedef		unsigned short		WORD;
	typedef		short				SHORT;

	#ifdef _SCOPEW16
		#define		dllScopeAPI		LONG _far _pascal __export
		#define		LONG			long
		#define		CALLBACK		_far _pascal

	#else
		#define 	CALLBACK
		#define		dllScopeAPI		LONG
		#ifdef _SCOPELP64
			typedef		int			LONG;
		#else
			typedef		long		LONG;
		#endif
	#endif
#endif



/*--------------------------------------------------------------------------------------------
		Define de tamanhos em geral
--------------------------------------------------------------------------------------------*/
#define TAM_PADRAO_VALOR					12
#define TAM_MAX_CMC7						40
#define TAM_COD_GRUPO						2
#define TAM_COD_ESTABELECIMENTO				15
#define TAM_NSU_HOST						12
#define TAM_NOME_OP							21
#define TAM_VALOR_OP						12
#define TAM_MSG_PROM_OP						41
#define TAM_CRM								9
#define NUM_VLRS_RC							10
#define TAM_COD_SAT							3
#define COD_SAT_OUTROS						999

#define	MAX_PROD_PARAM						10
#define	MAX_BUFFER_ATRIB					(MAX_PROD_PARAM * sizeof(stATRIB_SERVICO_V02) + 1)

/*--------------------------------------------------------------------------------------------
		Define os parametros para a funcao ScopeObtemHandle
--------------------------------------------------------------------------------------------*/
#define HDL_TRANSACAO_ANTERIOR		0	/* Solicita um handle para a transacao anterior ja concluida			*/
#define HDL_TRANSACAO_EM_ARQUIVO	8	/* Solicita um handle para uma possivel transacao interrompida			*/
#define HDL_TRANSACAO_EM_ANDAMENTO	9	/* Solicita um handle para uma transacao que ainda esta em andamento	*/


/*--------------------------------------------------------------------------------------------
		Define os parametros para a funcao ScopeMenuDinamico
--------------------------------------------------------------------------------------------*/
#define MNU_TAB_TIPO_DINAMICO			1	/* Tipo de tabela para o menu dinamico da rede CIELO */
#define MNU_TAB_TIPO_GENERICO			2	/* Tipo de tabela para o menu generico para a transacao POS*/
#define MNU_TAB_TIPO_SAVS         3	/* Tipo de tabela para o menu de itens da Plataforma de Servicos */

#define MNU_GENERICO_TIPO_REDE			1	// Tipo de menu generico - menu de redes
#define MNU_GENERICO_TIPO_BANDEIRA		2	// Tipo de menu generico - menu de bandeiras
#define MNU_GENERICO_TIPO_SERVICO		3	// Tipo de menu generico - menu de servicos


/*--------------------------------------------------------------------------------------------
		Constantes da mascara 1 da funcao ScopeObtemCampoExt2
--------------------------------------------------------------------------------------------*/
#define Numero_Conta_PAN					0x00000001		 /*	Personal Account Number (Card number)								*/
#define Valor_transacao						0x00000002		 /*	Amount																*/
#define NSU_transacao						0x00000004		 /*	Transaction Id assigned by Scope									*/
#define Hora_local_transacao				0x00000008		 /*	Transaction time													*/
#define Data_local_transacao				0x00000010		 /*	Transaction date													*/
#define Data_vencimento_cartao				0x00000020		 /*	Card due date														*/
#define Data_referencia						0x00000040		 /*	Account date														*/
#define Numero_cheque						0x00000080		 /*	Check number														*/
#define Codigo_autorizacao					0x00000100		 /*	Authorization code													*/
#define Codigo_resposta						0x00000200		 /*	Action code															*/
#define Identificacao_terminal				0x00000400		 /*	POS Id																*/
#define Codigo_Origem_Mensagem				0x00000800		 /*	Store Id assigned by the acquirer at agreement time					*/
#define Plano_Pagamento						0x00001000		 /*	Number of parcels													*/
#define Valor_Taxa_Servico					0x00002000		 /*	Tip value															*/
#define NSU_Host							0x00004000		 /*	Transaction Id assigned by Acquirer									*/
#define Cod_Banco							0x00008000		 /*	Bank code															*/
#define Cod_Agencia							0x00010000		 /*	Branch code															*/
#define Data_Vencimento						0x00020000		 /*	Due date (99ddmmyyyy [...])											*/
#define Cod_Bandeira       					0x00040000		 /*	Acquirer Code														*/
#define Cod_Servico							0x00080000		 /*	Service Code														*/
#define Texto_BIT_62						0x00100000		 /*	BIT 62																*/
#define Controle_Dac						0x00200000		 /*	Control DAC															*/
#define Cod_Rede							0x00400000		 /*	Net Code															*/
#define Nome_Bandeira						0x00800000		 /* Acquirer Name														*/
#define Nome_Rede							0x01000000		 /*	Net Name															*/
#define Cartao_Trilha02						0x02000000		 /*	Card - Track 02														*/
#define Numero_Promissorias					0x04000000		 /*	Number of promissory note											*/
#define Cod_Estab_Impresso					0x08000000		 /*	Establishment code printed on ticket								*/
#define Numero_CMC7							0x10000000		 /*	CMC7 Number															*/
#define CGC_Convenio						0x20000000		 /*	CGC Number															*/
#define Msg_Autentic_Cheque					0x40000000		 /*	Check Autentic Message												*/
#define Saldo_Disponivel					0x80000000		 /* Available Cache*/

/*--------------------------------------------------------------------------------------------
		Constantes da mascara 2 da funcao ScopeObtemCampoExt2
--------------------------------------------------------------------------------------------*/
#define NSU_transacao_Original				0x00000001		 /* Cancel Transaction Id assigned by Scope*/
#define Cliente_Com_Seguro					0x00000002		 /*	Ensured Client */
#define Dados_Parcelado_Cetelem				0x00000004		 /*	Informations about parcels Cetelem */
#define Data_Movimento						0x00000008		 /* Interchange: Data Movimento */
#define Nome_Convenio						0x00000010		 /* Interchange: Nome da Empresa de Convênio */
#define Lista_TEF_Permitidas				0x00000020		 /* Interchange: Lista das formas de pagamento em TEF permitidas (grupo e rede) */
#define Linha_Autenticacao					0x00000040		 /* Interchange - Fininvest: Linha de autenticação */
#define Dados_Consulta_Fatura				0x00000080		 /* Interchange - Fininvest: Dados da Consulta Fatura */
#define Forma_Financiamento					0x00000100		 /*	type of Financing */
#define Codigo_Resposta_AVS					0x00000200		 /*	Return Code for AVS */
#define Pontos_AdquiridosOuResgatados		0x00000400		 /*	Evangélico: Pontos adquiridos ou resgatados */
#define Fator_Compra						0x00000800		 /*	Evangélico: Fator de compra */
#define NSU_Host_Transacao_Original			0x00001000		 /* NSU Host da transação original (cancelamento) */
#define Identificacao_Cliente_PBM			0x00002000		 /* Identificação do Cliente junto a Autorizadora */
#define Cod_Operadora						0x00004000		 /* Codigo da Operadora de Celular */
#define Cod_Local_Telefone					0x00008000		 /* DDD */
#define Num_Telefone						0x00010000		 /* Telefone */
#define Dados_ValeGas						0x00020000		 /* ULTRAGAZ: Dados do ValeGás */
#define Codigo_IF							0x00040000		 /* Codigo IF (Instituicao Financeira) */
#define Numero_Item							0x00080000		 /* Fininvest, Cetelem */
#define	Num_Contrato						Numero_Item		 /* IBI: Numero do contrato (CPCHEQUE/INSS) */
#define Valor_Taxa_Embarque					0x00100000		 /* taxa de embarque*/
#define Digitos_TR2SON						0x00200000		 /* uso exclusiva sonae */
#define Taxa_Cliente_Lojista				0x00400000		 /* Informação bit 124 - CDC Orbitall */
#define Cod_Servico_Original				0x00800000		 /* Transacao de cancelamento: Codigo de Servico da transacao original */
#define Cod_Barras							0x01000000		 /* Codigo de Barras */
#define Permite_Desfazimento				0x02000000		 /* Permite cancelamento */
#define Logo_PAN							0x04000000		 /* Retorna o LOGO do cartao: bytes 7 e 8 do PAN */
#define Cod_Empresa							0x08000000		 /* Código da Empresa - HSBC */
#define Cod_Autenticacao					0x10000000		 /* Código de autenticação - ISOGCB */
#define Dados_Pagto_ISOGCB					0x20000000		 /* Dados do pagamento ISOGCB */
#define UsoRes_63						    0x40000000		 /*	BIT 63 - Projeto Vale Gás GetNet */
#define Numero_PDV							0x80000000       /* Numero do PDV - HSBC */

/*--------------------------------------------------------------------------------------------
		Constantes da mascara 3 da funcao ScopeObtemCampoExt2
--------------------------------------------------------------------------------------------*/
#define Dados_Resgate_Nao_Monetario			0x00000001		 /* Informações sobre a quantidade e os e-cupons disponíveis ao cliente */
#define DescResgateMonetario				0x00000002		 /* Desconto do resgate monetário */
#define Dados_Pagto_BRADESCO				0x00000004		 /* Bradesco - Informações sobre o Bit 48*/
#define Modo_Entrada					    0x00000008		 /* Modo de entrada da transacao (Entry Mode) */
#define Valor_Saque							0x00000010       /* Valor do Saque */
#define Resposta_Consulta_Infocards			0x00000020       /* Resposta da consulta Infocards (bit 62 da 0110) */
#define Dados_Resposta_Consulta_EPAY	    0x00000040       /* Resposta da consulta (bit 62 da 0110)  */
#define Sistema_Captura                     0x00000080       /* Caractere representando o sistema em que a transacao foi efetuada. 'P'-POS, 'I'-Internet, 'M'-Manual, 'T'-TEF ou 'O' Outros. */
#define Max_Mercadorias_TicketCar			0x00000100		 /* Maximo de mercadorias permitidas para a transacao TicketCar */
#define Codigo_SAT							0x00000200       /* Codigo SAT */
#define Versao_Carga_Tabelas_Host			0x00000400		 /* Versao corrente de Carga de Tabelas Host*/

/*--------------------------------------------------------------------------------------------
		Funcao ScopeConfigura() - Configura a Interface Coleta do Scope
--------------------------------------------------------------------------------------------*/
/*  ID   */
#define CFG_CANCELAR_OPERACAO_PINPAD		0x00000001		 /* Permite cancelar a interacao (leitura do cartao, senha e ...) no pinpad		(default: desabilitado)		*/
#define CFG_OBTER_SERVICOS					0x00000002		 /* Permite retornar o estado TC_OBTEM_SERVICOS durante o fluxo	de TEF			(default: desabilitado)		*/
#define CFG_NAO_ABRIR_DIGITADO_COM_PP		0x00000004		 /* Permite não abrir o digitado na leitura do cartão com o PP Compartilhado  	(default: desabilitado)	    */
#define CFG_DEVOLVER_SENHA_CRIPTOGRAFADA	0x00000008		 /* Permite devolver a senha criptografada com a master key da Itautec          (default: desabilitado, ou seja, devolve senha aberta)			*/
#define CFG_IMPRESSORA_CARBONADA			0x00000010		 /* Permite configurar a impressora como carbonada para não imprimir 2a via... 	(default: desabilitado, ou seja, no cupom exibirá 1a e 2a via)	*/
#define CFG_ARMAZENA_EM_QUEDA				0x00000020		 /* Armazena dados da coleta para recuperar em queda de energia.				(default: desabilitado)		*/
#define CFG_MASCARAR_DADOS					0x00000040		 /* Configura se mascaramento de dados pelo ObtemCampo está habilitado.			(default: habilitado)		*/
#define CFG_ATUALIZA_TRANSACAO_EM_QUEDA		0x00000080       /* Permite confirmar/desfazer a transação em caso de queda de energia.         (default: desabilitado, ou seja, sempre desfazer)     */
#define CFG_PERMITIR_SAQUE					0x00000100       /* Habilita coleta de saque em operações de Débito à Vista da rede Cielo  */ 
#define	CFG_COLETA_RECARGA_PP				0X00000200		 /* Permite desabilitar a coleta do ddd e telefone no pinpad em recarga de celular (default: conforme configuração do SCOPECNF)*/	

/*  OPCAO   */
#define	OP_DESABILITA						0x00000000
#define	OP_HABILITA							0x00000001
#define	OP_SOMENTE_PCI						0x00000002

/*--------------------------------------------------------------------------------------------
		Funcao ScopeObtemTipoViaReimpressao() - Retorna qual via do comprovante deverá ser impressa
--------------------------------------------------------------------------------------------*/
#define	REIMPRIME_TODAS_VIAS					0
#define REIMPRIME_VIA_LOJA						1
#define REIMPRIME_VIA_CLIENTE					2

/*--------------------------------------------------------------------------------------------
		Define os estados para a interface coleta
--------------------------------------------------------------------------------------------*/
#define	TC_PRIMEIRO_TIPO_COLETA				0xFC00
#define	TC_CARTAO							TC_PRIMEIRO_TIPO_COLETA
#define	TC_VALIDADE_CARTAO					0xFC01
#define	TC_IMPRIME_CUPOM					0xFC02
#define	TC_CPF_CGC							0xFC03
#define	TC_BANCO							0xFC04
#define	TC_AGENCIA							0xFC05
#define	TC_NUMERO_CHEQUE					0xFC06
#define	TC_BOM_PARA							0xFC07
#define	TC_IMPRIME_CHEQUE					0xFC08
#define	TC_DECIDE_AVISTA					0xFC09
#define	TC_DECIDE_P_ADM_EST					0xFC0A
#define	TC_DECIDE_P_DATADO					0xFC0B
#define	TC_DECIDE_P_AVISTA					0xFC0C
#define	TC_DECIDE_D_E_PARC					0xFC0D
#define	TC_QTDE_PARCELAS					0xFC0E
#define	TC_DECIDE_P_FINANC					0xFC0F
#define	TC_DIA_MES							0xFC10
#define	TC_SENHA							0xFC11
#define	TC_CONTROLE							0xFC12
#define	TC_FORMA_PAGAMENTO					0xFC13
#define	TC_PRIMEIRO_VENCIMENTO				0xFC14
#define	TC_VALOR_ENTRADA					0xFC15
#define	TC_FORMA_ENTRADA					0xFC16
#define	TC_CONTA_CORRENTE					0xFC17
#define	TC_ULTIMOS_DIGITOS					0xFC18
#define	TC_REIMPRESSAO_COMPROVANTE			0xFC19
#define	TC_DECISAO_C_PARC					0xFC1A
#define	TC_IMPRIME_CONSULTA					0xFC1B
#define	TC_DECISAO_CONT						0xFC1C
#define	TC_DECIDE_ULTIMO					0xFC1D
#define	TC_NUMERO_CHEQUE_CDC				0xFC1E
#define	TC_QTD_DIAS							0xFC1F
#define	TC_NUM_PRE_AUTORIZACAO				0xFC20
#define	TC_DIA_MES_FECHADO					0xFC21
#define	TC_IMPRIME_NOTA_PROMISSORIA			0xFC22
#define	TC_CEP								0xFC23
#define	TC_NUMERO_ENDERECO					0xFC24
#define	TC_COMPLEMENTO						0xFC25
#define	TC_PLANO_PAGAMENTO					0xFC26
#define	TC_CICLOS_A_PULAR					0xFC27
#define	TC_NRO_ITEM							0xFC28
#define TC_CVV_CVC_2						0xFC29
#define TC_AUSENCIA_CVV_CVC_2				0xFC2A
#define TC_DECIDE_GARANTIA					0xFC2B
#define TC_DECIDE_RISCO						0xFC2C
#define TC_COLETA_VALOR_SAQUE				0xFC2D
#define TC_COLETA_VALOR_RECARGA				0xFC2E
#define TC_COLETA_COD_LOC_TELEFONE			0xFC2F
#define TC_COLETA_NUM_TELEFONE				0xFC30
#define TC_COLETA_DIG_VERIFICADOR			0xFC31
#define TC_COLETA_DDMMAA					0xFC32
#define TC_COLETA_VALOR_TX_SERVICO			0xFC33
#define TC_COLETA_VALOR						0xFC34
#define TC_DECIDE_SAQUE						0xFC35
#define TC_DECIDE_SAQUE_SIMULADO			0xFC36
#define TC_DECIDE_SALDO_EXTRATO				0xFC37
#define TC_DECIDE_RESUMIDO_SEGVIA			0xFC38
#define TC_DECIDE_CONSULTA_RESGATE			0xFC39
#define TC_COLETA_NSU_HOST					0xFC3A
#define TC_COLETA_SERVICO					0xFC3B
#define TC_COLETA_COD_REDE					0xFC3C

#define TC_DECIDE_RESGATE_AVULSO			0xFC40
#define TC_COLETA_DDMMAAAA					0xFC41
#define TC_COLETA_AUT_MEDICAMENTO			0xFC42
#define TC_COLETA_REG_MEDICAMENTO			0xFC43
#define TC_DISP_LISTA_MEDICAMENTO			0xFC44
#define TC_EXIBE_MSG						0xFC45
#define	TC_IMPRIME_CUPOM_PARCIAL			0xFC46
#define	TC_COLETA_QTD_PARC_ACEITA1			0xFC47
#define	TC_COLETA_COD_BARRAS				0xFC48
#define	TC_COLETA_COD_CONSULTA_PBM			0xFC49
#define	TC_COLETA_CRM_MEDICO				0xFC4A
#define	TC_COLETA_COD_UF_CRM_MEDICO			0xFC4B
#define	TC_COLETA_SEGURO					0xFC4C
#define	TC_DECIDE_CARTAO					0xFC4D
#define TC_COLETA_DADOS_TOKORO				0xFC4E
#define TC_DECIDE_PAG_APOS_VENC				0xFC4F
#define TC_COLETA_DECIDE_COL_SENHA			0xFC50
#define	TC_IMPRIME_CUPOM_PROMOCIONAL		0xFC51
#define	TC_COLETA_UTILIZA_SALDO				0xFC52
#define TC_COLETA_CODIGO_MATERIAL			0xFC53
#define TC_COLETA_PLANO						0xFC54
#define TC_DECIDE_PAGTO_CHEQUE				0xFC55
#define TC_DECIDE_CONFIRMA_TRN				0xFC56
#define TC_DECIDE_PAGTO_ROTATIVO			0xFC57
#define TC_COLETA_CMC7						0xFC58
#define TC_DECIDE_DIN_TEF					0xFC59
#define TC_COLETA_TEF_EXT_COD_GRUPO			0xFC5A
#define TC_COLETA_TEF_EXT_COD_REDE			0xFC5B
#define TC_COLETA_TEF_EXT_COD_ESTAB			0xFC5C
#define TC_COLETA_TEF_EXT_NSU_HOST			0xFC5D
#define TC_COLETA_TEF_EXT_DDMMAAAA			0xFC5E
#define TC_DECIDE_CONSULTA					0xFC5F
#define TC_CONTA_PERMITIDA_CONTINUA			0xFC60
#define TC_COLETA_COD_BANDEIRA				0xFC61
#define TC_DECIDE_CONTA_FATURA				0xFC62
#define TC_COLETA_VALOR_TOTAL				0xFC63
#define TC_COLETA_RG						0xFC64
#define TC_DECIDE_RETENTATIVA				0xFC65
#define	TC_CPF								0xFC66
#define TC_COLETA_ENDERECO					0xFC67
#define TC_COLETA_ANDAR						0xFC68
#define TC_COLETA_CONJUNTO					0xFC69
#define TC_COLETA_BLOCO						0xFC6A
#define TC_COLETA_BAIRRO					0xFC6B
#define TC_COLETA_AUT_OU_CARTAO				0xFC6C
#define TC_COLETA_DATA_EMISSAO_CARTAO		0xFC6D
#define TC_COLETA_PLANO_INFOCARDS			0xFC6E
#define TC_COLETA_NUM_CUPOM_FISCAL			0xFC6F
#define	TC_COLETA_OPERADORA					0xFC70
#define	TC_COLETA_DADOS_SAB					0xFC71
#define	TC_COLETA_NUM_TELEFONE_COM_DV		0xFC72
#define	TC_COLETA_DADOS_TRN_FORCADA_SAB		0xFC73
#define	TC_DECIDE_SERVICO_TECNICO			0xFC74
#define	TC_COLETA_NUMERO_OS					0xFC75
#define	TC_COLETA_ID_TECNICO				0xFC76
#define	TC_COLETA_COD_OCORRENCIA			0xFC77
#define	TC_COLETA_EPS_CREDENCIADA			0xFC78
#define	TC_DECIDE_VALOR_ENTRADA				0xFC79
#define	TC_DECIDE_COLETA_VALOR_1aPARCELA	0xFC7A
#define	TC_COLETA_VALOR_1aPARCELA			0xFC7B
#define	TC_COLETA_DADOS_ADICIONAIS			0xFC7C
#define	TC_COLETA_CANCELA_TRANSACAO			0xFC7D
#define	TC_GO_ON_CHIP						0xFC7E
#define	TC_RETIRA_CARTAO					0xFC7F
#define	TC_COLETA_VALOR_TAXA_EMBARQUE		0xFC80
#define TC_EXIBE_MSG_SALDO					0xFC81
#define TC_EXIBE_MSG_RETORNA_FLUXO			0xFC82
#define TC_EXIBE_MSG_AGUARDA_OPERADOR		0xFC83
#define TC_OBTEM_SERVICOS					0xFC84
#define TC_CARTAO_DIGITADO					0xFC85
#define TC_COLETA_COD_PRODUTO				0xFC86
#define TC_EXIBE_MENU						0xFC87
#define	TC_DECIDE_INSS						0xFC88
#define	TC_COLETA_CONTRATO					0xFC89
#define TC_COLETA_DATA_CLIENTE_DESDE		0xFC8A
#define TC_DISP_VALOR						0xFC8B
#define TC_COLETA_DATA_TRN_ORIG				0xFC8C
#define TC_COLETA_NSU_TRN_ORIG				0xFC8D
#define TC_EXIBE_DADOS_CANC					0xFC8E
#define TC_DECIDE_VIAS_REIMPRESSAO			0xFC8F
#define TC_COLETA_DDD_PP					0xFC90
#define TC_COLETA_NUM_TEL_PP				0xFC91
#define	TC_COLETA_NUM_TELEFONE_COM_DV_PP	0xFC92
#define	TC_COLETA_REDIGITACAO_RECARGA_PP	0xFC93
#define	TC_TRANSACAO_APROVADA_PARCIAL		0xFC94
#define	TC_COLETA_VALOR_PARCELAS			0xFC95
#define	TC_PRIMEIRA_PARCELA_30_60			0xFC96
#define	TC_DECIDE_CDC_PARCELE_MAIS			0xFC97
#define	TC_DECIDE_VENDAS_PAGAMENTOS			0xFC98
#define	TC_DECIDE_AVISTA_CJUROS				0xFC99
#define TC_COLETA_TEF_EXT_NUMERO_CARTAO		0xFC9A
#define	TC_TIPO_SERVICO_COMBUSTIVEL			0xFC9B
#define	TC_MATRICULA						0xFC9C
#define	TC_QUANTIDADE_COMBUSTIVEL			0xFC9D
#define	TC_HODOMETRO						0xFC9E
#define	TC_PLACA_VEICULO					0xFC9F
#define	TC_COLETA_CEL_COD_ATIVACAO			0xFCA0
#define TC_EXIBE_MENU_RESGATE_PREMIO		0xFCA1
#define TC_CONFIRMA_OPCAO_RESGATE_PREMIO	0xFCA2
#define TC_CLIENTE_CONFIRMA_RESGATE			0xFCA3
#define TC_NRO_RESGATE_PREMIO				0xFCA4
#define	TC_COLETA_NRO_VOUCHER				0xFCA5
#define	TC_DECIDE_DARF_GPS					0xFCA6
#define TC_DECIDE_TIPO_DARF                 0xFCA7
#define TC_COLETA_CODIGO_RECEITA            0xFCA8
#define TC_COLETA_NUMERO_REFERENCIA			0xFCA9
#define TC_COLETA_VALOR_JUROS				0xFCAA
#define TC_CPF_PORTADOR						0xFCAB
#define TC_CNPJ								0XFCAC
#define TC_COLETA_PERCENTUAL				0XFCAD
#define TC_COLETA_MMAAAA					0XFCAE
#define TC_COLETA_NUMERO_IDENTIFICADOR		0xFCAF
#define TC_COLETA_VALOR_INSS				0xFCB0
#define TC_COLETA_RECEITA_BRUTA				0xFCB1
#define TC_CONTA_PERMIT_CONT_BRAD_TIT		0xFCB2
#define TC_COLETA_VALOR_ACRESCIMO       	0xFCB3
#define TC_COLETA_VALOR_DEDUCAO       	    0xFCB4
#define TC_COLETA_REDIGITA_DDD_PP           0xFCB5
#define TC_COLETA_CARTAO_DIGITADO_PP		0xFCB6
#define TC_COLETA_DIG_FINAIS_CARTAO_PP		0xFCB7
#define TC_COLETA_TIPO_CONSULTA             0xFCB8
#define TC_CONFIRMA_CARTAO_DIGITADO_PP		0xFCB9
#define TC_VALIDA_SAQUE_AUTOMACAO           0xFCBA
#define TC_SAQUE_PP_EM_ANDAMENTO            0xFCBB
#define TC_COLETA_DDD_NUMTEL_PP				0xFCBC
#define TC_REDIGITA_DDD_NUMTEL_PP			0xFCBD
#define TC_COLETA_DADOS_ECF                 0xFCBE
#define TC_COLETA_COD_EAN					0xFCBF
#define TC_COLETA_HORA_TRN_ORIG				0xFCC0
#define TC_DECIDE_PGTO_CARNE				0xFCC1
#define TC_COLETA_MODALIDADE				0xFCC2
#define TC_COLETA_CODIGO_CODUTOR			0xFCC3
#define TC_COLETA_COD_COMBUSTIVEL			0xFCC4
#define TC_COLETA_VOUCHER_FROTA				0xFCC5
#define TC_COLETA_DADOS_CARTAO_PRESENTE     0xFCC6
#define TC_PRIMEIROS_DIGITOS				0xFCC7
#define TC_COLETA_CAMPO_AUT					0xFCC8
#define TC_COLETA_CAMPO_DOC					0xFCC9
#define TC_COLETA_LISTA_PRECOS				0xFCCA
#define TC_COLETA_LISTA_MERCADORIAS			0xFCCB
#define TC_HORIMETRO						0xFCCC
#define TC_COLETA_CARTAO_MAGNETICO			0xFCCD

#define TC_COLETA_LISTA_PLANOS				0xFCCE
#define TC_DECIDE_EMPRESTIMO_SAQUE			0xFCCF
#define TC_COLETA_NUM_DOCUMENTO				0xFCD0
#define TC_COLETA_PROJETO					0xFCD1
//#define TC_SENHA_NOVA						0xFCD2
//#define TC_SENHA_NOVA_CONF				0xFCD3
#define TC_COLETA_SEGMENTO_SAV				0xFCD4
#define TC_COLETA_FORNECEDOR_SAV			0xFCD5
#define TC_COLETA_PRODUTO_SAV				0xFCD6
#define TC_COLETA_QUANTIDADE				0xFCD7
#define TC_COLETA_CLIENTE_PREFERENCIAL		0xFCD8

/* --> Proximo Tipo Coleta AQUI (ACIMA) */

#define TC_COLETA_CARTAO_EM_ANDAMENTO		0xFCFC
#define TC_COLETA_EM_ANDAMENTO				0xFCFD
#define	TC_INFO_RET_FLUXO					0xFCFE
#define	TC_INFO_AGU_CONF_OP					0xFCFF
#define	TC_MAX_TIPO_COLETA					TC_INFO_AGU_CONF_OP


/*--------------------------------------------------------------------------------------------
		Define os cupons disponiveis para aplicacao
--------------------------------------------------------------------------------------------*/
#define CUPOM_TEF							0x0001
#define CUPOM_PROMOCIONAL					0x0002
#define CUPOM_NOTA_PROMISSORIA				0x0004



/*--------------------------------------------------------------------------------------------
		Código de identificacao da PBM
--------------------------------------------------------------------------------------------*/
#define ID_PBM_EPHARMA						1
#define ID_PBM_VIDALINK 					2
#define ID_PBM_PREVSAUDE					3
#define ID_PBM_FUNCIONALCARD				4
#define ID_PBM_GOODCARD						5
#define ID_PBM_NOVARTIS						6
#define ID_PBM_FLEXMED						7
#define ID_PBM_DATASUS						8
#define ID_PBM_FARMASEG						9
#define ID_PBM_PHARMASYSTEM					10
#define ID_PBM_PADRAO						11

/*--------------------------------------------------------------------------------------------
		Identificacao do formato de registro PBM fornecido ao Scope
--------------------------------------------------------------------------------------------*/
#define PBM_HEADER_LAYOUT_02	  			"FMT02#"
#define PBM_HEADER_LAYOUT_PHARMASYSTEM		"FMT03#"

/*--------------------------------------------------------------------------------------------
		Identificacao do formato de registro Lista Mercadorias fornecido ao Scope
--------------------------------------------------------------------------------------------*/
#define MERC_HEADER_LAYOUT	  				"LM01"

/*--------------------------------------------------------------------------------------------
		Identificacao do formato de registro Lista Precos fornecido ao Scope
--------------------------------------------------------------------------------------------*/
#define PREC_HEADER_LAYOUT_01	  			"LP01"

/*--------------------------------------------------------------------------------------------
		 Codigos/erros devolvidos pelo Scope
--------------------------------------------------------------------------------------------*/
#define	RCS_SUCESSO									0x0000

#define	RCS_COD_AUTORIZADORA_NAO_NUMERICO			0x0100
#define	RCS_ALC_RESTRICAO_CLIENTE					0x0101
#define	RCS_ALC_JACONSULTOU_BANCOAG_IGUAIS			0x0102
#define	RCS_ALC_JACONSULTOU_BANCOAG_DIFERENTES		0x0103
#define	RCS_COD_GAR_NAO_AUTORIZADA					0x0104
#define RCS_COMPRE_SAQUE_APROVADO_PARCIAL			0x0105
#define RCS_VOUCHER_APROVADO_PARCIAL				0x0106
#define RCS_APROVADO_COM_PREMIO						0x0107

#define	RCS_AUTO_ERRO_CRD_RLV_INVALIDO				0xF900
#define	RCS_AUTO_ERRO_CRD_TRK_INVALIDA				0xF901
#define	RCS_AUTO_ERRO_CRD_INVALIDO					0xF902
#define	RCS_AUTO_ERRO_CRD_VALIDADE					0xF903
#define	RCS_AUTO_ERRO_PARM_INVALIDO					0xF904

#define	RCS_ERRO_PARM_1								0xFA01
#define	RCS_ERRO_PARM_2								0xFA02
#define	RCS_ERRO_PARM_3								0xFA03
#define	RCS_ERRO_PARM_4								0xFA04
#define	RCS_ERRO_PARM_5								0xFA05

#define	RCS_THREAD_API_NOT_INIT						0xFB01
#define	RCS_ERRO_CRIA_SERV							0xFB02
#define	RCS_ERRO_CRITICA_MSG						0xFB03
#define	RCS_ERRO_MONTA_MSG							0xFB04
#define	RCS_ERRO_ARQ_TEF							0xFB05
#define	RCS_ERRO_CONTEXTO_TEF						0xFB06
#define	RCS_ERRO_TOTAL_TEF							0xFB07
#define	RCS_ERRO_ARQ_CICLO_TEF						0xFB08
#define RCS_ERRO_NUM_MAX_TEF_SESSAO					0xFB09
#define RCS_ERRO_MONTANDO_CONFIRMACAO				0xFB0A
#define RCS_ERRO_MONTANDO_DESFAZIMENTO				0xFB0B
#define RCS_ERRO_CRIPTOGRAFIA						0xFB0C

#define	RCS_PRIMEIRO_COLETA_DADOS					0xFC00
#define	RCS_COLETAR_CARTAO							0xFC00

#define RCS_MOSTRA_INFO_AGUARDA_CONF				0xFCFF
#define	RCS_ULTIMO_COLETA_DADOS						0xFCFF

#define	RCS_TRN_EM_ANDAMENTO						0xFE00
#define	RCS_API_NAO_INICIALIZADA					0xFE01
#define	RCS_API_JA_INICIALIZADA						0xFE02
#define	RCS_EXISTE_TRN_SUSPENSA						0xFE03
#define	RCS_NAO_EXISTE_TRN_SUSPENSA					0xFE04
#define	RCS_API_NAO_FEZ_TRN							0xFE05
#define	RCS_POS_JA_LOGADO							0xFE06
#define	RCS_PROTOCOLO_NAO_SUPORTADO					0xFE07
#define	RCS_POS_NAO_CADASTRADO						0xFE08
#define	RCS_SRV_NOT_CFG								0xFE09
#define	RCS_NAO_HA_PDVS_DISPONIVEIS					0xFE0A
#define	RCS_PROTOCOLO_INCOMPATIVEL					0xFE0B
#define	RCS_NAO_PODE_DESFAZER_TRN_ENCERRADA			0xFE0C
#define	RCS_NAO_HA_CAMPOS_SALVOS					0xFE0D

#define	RCS_SERVER_OFF								0xFF00
#define	RCS_ACQUIRER_OFF							0xFF01
#define	RCS_CANCELADA_PELO_OPERADOR					0xFF02
#define	RCS_BIN_SERV_INV							0xFF03
#define	RCS_TRN_JA_CANCELADA						0xFF04
#define	RCS_TRN_NOT_FOUND_BD						0xFF05
#define	RCS_TRN_NAO_REVERSIVEL						0xFF06
#define	RCS_PARMS_INCOMPATIVEIS						0xFF07
#define	RCS_ERRO_BD									0xFF08
#define	RCS_TIMEOUT_BD								0xFF09
#define	RCS_BD_OFFLINE								0xFF0A
#define	RCS_ABORTADA_PELO_APLICATIVO				0xFF0B
#define	RCS_TRN_NAO_IMPLEMENTADA					0xFF0C
#define	RCS_HANDLE_INVALIDO							0xFF0D
#define	RCS_TX_SERV_INVALIDA						0xFF0E
#define	RCS_TX_SERV_EXCEDE_LIM						0xFF0F
#define RCS_DADO_INVALIDO							0xFF10
#define RCS_NAO_EXITE_CUPOM_VALIDO					0xFF11
#define	RCS_AREA_RESERVADA_INSUFICIENTE				0xFF12
#define	RCS_ERRO_LIMITE								0xFF13
#define	RCS_TRN_DESFEITA							0xFF14
#define	RCS_DIGITACAO_NAO_PERMITIDA					0xFF15
#define	RCS_MEMORIA_INSUFICIENTE					0xFF16
#define	RCS_SERVICE_CODE_INVALIDO					0xFF17
#define	RCS_DATA_INVALIDA							0xFF18
#define	RCS_CARTAO_VENCIDO							0xFF19
#define	RCS_CARTAO_INVALIDO							0xFF1A
#define	RCS_DESFAZIMENTO_NAO_DISPONIVEL				0xFF1B
#define	RCS_ERRO_IMPRESSAO_CUPOM					0xFF1C
#define RCS_SESSAO_MTEF_EM_ANDAMENTO				0xFF1D
#define RCS_TRANSACAO_JA_EFETUADA					0xFF1E
#define RCS_INSERIR_CARTAO_CHIP						0xFF1F
#define RCS_CONTROLE_OBRIGATORIO					0xFF20
#define RCS_PRE_AUTORIZACAO_OBRIGATORIA				0xFF21
#define RCS_SERVICO_NAO_CONFIGURADO					0xFF22
#define RCS_SERVICO_NAO_DEFINIDO					0xFF23
#define	RCS_NUM_PARCELAS_INVALIDAS					0xFF24
#define RCS_VALOR_INVALIDO							0xFF25
#define	RCS_BIN_SERV_INV_VISANET					0xFF26
#define	RCS_ESTADO_NAO_DEFINIDO						0xFF27
#define	RCS_OPERACAO_NAO_PERMITIDA					0xFF28
#define	RCS_CNPG_CPF_INVALIDO						0xFF29
#define	RCS_ERRO_DAC_BLK1							0xFF2A
#define	RCS_ERRO_DAC_BLK2							0xFF2B
#define	RCS_ERRO_DAC_BLK3							0xFF2C
#define	RCS_ERRO_DAC_BLK4							0xFF2D
#define	RCS_AID_INVALIDO							0xFF2E
#define	RCS_DISPONIVEL2								0xFF2F
#define	RCS_AUT_RETORNOU_DADOS_INVALIDOS			0xFF30
#define	RCS_CONTA_NAO_PERMITIDA						0xFF31
#define	RCS_CONTA_VENCIDA							0xFF32
#define	RCS_NAO_EXISTE_RESUMO						0xFF33
#define	RCS_CODBAR_INVALIDO							0xFF34
#define	RCS_ERRO_DAC								0xFF35
#define	RCS_ERRO_FINALIZACAO_TRN_ANTERIOR			0xFF36
#define	RCS_SERVICO_INVERTIDO						0xFF37
#define	RCS_CARTAO_NAO_PERMITIDO					0xFF38
#define	RCS_SCPC_CPF_ONLY							0xFF39
#define	RCS_ERRO_INTERNO_EXECUCAO_COLETA			0xFF3A
#define	RCS_LISTA_NAO_DISPONIVEL					0xFF3B
#define	RCS_ERRO_LEITURA_CARTAO						0xFF3C
#define	RCS_CONTROLE_INVALIDO						0xFF3D
#define	RCS_ERRO_AO_ENVIAR_MSG_SERVIDOR				0xFF3E
#define	RCS_INTERFACE_SAB_NAO_INICIALIZADA			0xFF3F
#define	RCS_ERRO_DADOS_AINDA_NAO_DISPONIVEIS		0xFF40
#define	RCS_ERRO_DADOS_INDISPONIVEIS				0xFF41
#define	RCS_SERVIDOR_SAB_OFF						0xFF42
#define	RCS_ERRO_CONEXAO_SCOPE_E_SAB				0xFF43
#define	RCS_ERRO_NSU_RECEBIDO						0xFF44
#define	RCS_ERRO_LOGON_PDV							0xFF45
#define	RCS_ERRO_PROCESSAMENTO_CHIP					0xFF46
#define	RCS_OPERADORA_INVALIDA						0xFF47
#define	RCS_DADOS_RECARGA_NAO_ENCONTRADOS			0xFF48
#define	RCS_CANCELADA_PELO_CLIENTE					0xFF49
#define	RCS_APROVADA_OFFLINE						0xFF50
#define	RCS_VERSAO_BD_INCOMPATIVEL					0xFF51
#define	RCS_FORA_PRAZO								0xFF52
#define RCS_MENSAGEM_INVALIDA						0xFF53
#define RCS_PINPAD_AINDA_NAO_FOI_ABERTO				0xFF54
#define RCS_PINPAD_JA_FOI_ABERTO					0xFF55
#define RCS_ESTADO_INVALIDO							0xFF56
#define RCS_PP_COMPARTILHADO_NAO_CONFIGURADO		0xFF57
#define RCS_PP_COMPARTILHADO_NAO_TRABALHA_VISA2000	0xFF58
#define RCS_USO_EXCLUSIVO_INTERFACE_COLETA			0xFF59
#define	RCS_AREA_ATRIBUTOS_SERV_INSUFICIENTE		0xFF5A
#define RCS_SCOPE_CONFIGURADO_PP_COMPARTILHADO		0xFF5B
#define RCS_SCOPE_NAO_CONFIGURADO_PP_COMPARTILHADO	0xFF5C
#define RCS_ERRO_ABERTURA_PERIFERICO				0xFF5D
#define RCS_ERRO_DESMONTA_ISO						0xFF5E
#define RCS_BANDEIRA_NAO_CONFIGURADA				0xFF5F
#define RCS_FUNCAO_NAO_DISPONIVEL					0xFF60
#define RCS_VALOR_MIN_PARC_INVALIDO					0xFF61
#define RCS_VALOR_NAO_DISPONIVEL					0xFF62
#define	RCS_NUMTEL_INVALIDO							0xFF63
#define	RCS_DDD_INVALIDO							0xFF64
#define	RCS_ERRO_REDE_MODELO_2						0xFF65
#define	RCS_ERRO_REDE_MODELO_3						0xFF66
#define RCS_PROMPTS_NAO_ENCONTRADOS					0xFF67
#define RCS_USE_REIMPRESSAO_OFFLINE					0xFF68
#define RCS_CONTRATO_SUSPENSO						0xFF69
#define RCS_PERMITE_SOMENTE_DIGITADO				0xFF6A
#define RCS_NOT_FOUND								0xFF6B
#define RCS_CODEAN128_INVALIDO						0xFF6C
#define	RCS_MOBILE_NAO_PERMITIDA					0xFF6D
#define	RCS_ACQUIRER_TIMEOUT						0xFF6E
#define RCS_ERRO_ARQ_CONTEXTO						0xFF6F
#define RCS_PLACA_INVALIDA							0xFF70
#define RCS_CONSULTA_BRADESCO_NAO_HABILITADA		0xFF71
#define RCS_CODIGO_BANDEIRA_MAIOR_255				0xFF72
#define RCS_REDE_INICIANDO							0xFF73
#define RCS_PINPAD_NAO_SUPORTADO_PERFIL				0xFF74
#define RCS_ERRO_ESTATISTICA_REDECARD				0xFF75
#define RCS_PINPAD_TABELAS_VAZIAS					0xFF76

#define	RCS_ERRO_GENERICO							0xFFFF


/*--------------------------------------------------------------------------------------------
		 Define as teclas que podem ser habilitadas
--------------------------------------------------------------------------------------------*/
#define	T_CANCELA			0x01
#define	T_PROXIMO			0x02
#define	T_RETORNA			0x04



/*--------------------------------------------------------------------------------------------
		 Codigos devolvidos pelas funcoes de acesso ao PIN-Pad Compartilhado
--------------------------------------------------------------------------------------------*/
#define PC_OK				0	// Operação efetuada com sucesso - parâmetros de retorno
								// (OUTPUT) contém dados válidos.
#define PC_PROCESSING		1	// Em processamento. Deve-se chamar a função novamente ou
								// PC_Abort para finalizar.
#define PC_NOTIFY			2	// Em processamento. Deve-se apresentar no "checkout" uma
								// mensagem retornada pela função e chamá-la novamente ou
								// PC_Abort para finalizar.
#define PC_F1				4	// Pressionada tecla de função #1.
#define PC_F2				5	// Pressionada tecla de função #2.
#define PC_F3				6	// Pressionada tecla de função #3.
#define PC_F4				7	// Pressionada tecla de função #4.
#define PC_BACKSP			8	// Pressionada tecla de apagar (backspace)

// Status de 10 a 29 : Erros básicos da biblioteca
#define PC_INVCALL			10	// Chamada inválida à função. Operações prévias são necessárias.
#define PC_INVPARM			11	// Parâmetro inválido passado à função.
#define PC_TIMEOUT			12	// Esgotado o tempo máximo estipulado para a operação.
#define PC_CANCEL			13	// Operação cancelada pelo operador.

#define PC_ALREADYOPEN		14 	// Pinpad já aberto.
#define PC_NOTOPEN			15 	// Pinpad não foi aberto.
#define PC_EXECERR			16 	// Erro interno de execução - problema de implementação da
								// biblioteca (software).
#define PC_INVMODEL			17 	// Função não suportada pelo modelo de pinpad.
#define PC_NOFUNC			18 	// Função não disponível na Biblioteca do pinpad.
#define PC_ERRMANDAT 		19	// Ausência de dado mandatório para o processamento.
#define PC_TABEXP			20 	// Tabelas expiradas (pelo "time-stamp").
#define PC_TABERR			21 	// Erro ao tentar gravar tabelas (falta de espaço, por exemplo)
#define PC_NOAPPLIC			22 	// Aplicação da rede adquirente não existe no pinpad.

	// 23 a 29 Reservado para uso futuro
	// Status de 30 a 39 : Erros de comunicação/protocolo com o pinpad
#define PC_PORTERR			30 	// Erro de comunicação: porta serial do pinpad provavelmente
								// ocupada.
#define PC_COMMERR			31 	// Erro de comunicação: pinpad provavelmente desconectado ou
								// problemas com a interface serial.
#define PC_UNKNOWNSTAT		32 	// Status informado pelo pinpad não é conhecido.
#define PC_RSPERR			33 	// Mensagem recebida do pinpad possui formato inválido.
#define PC_COMMTOUT			34 	// Tempo esgotado ao esperar pela resposta do pinpad (no caso de
								// comandos não blocantes).

	// 35 a 39 Reservado para uso futuro
	// Status de 40 a 49 : Erros básicos reportados pelo pinpad
#define PC_INTERR			40 	// Erro interno do pinpad.
#define PC_MCDATAERR		41 	// Erro de leitura do cartão magnético.
#define PC_ERRPIN			42 	// Erro na captura do PIN - Master Key pode não estar presente.
#define PC_NOCARD			43 	// Não há cartão inteligente presente no acoplador.
#define PC_PINBUSY			44 	// Pinpad não pode processar a captura de PIN temporariamente
								// devido a questões de segurança (como quando é atingido o limite
								// de capturas dentro de um intervalo de tempo).
	// 45 a 49 Reservado para uso futuro.
	// Status de 50 a 59 : Erros de processamento de cartão com chip (SAM)
#define PC_SAMERR			50 	// Erro genérico no módulo SAM.
#define PC_NOSAM			51 	// SAM ausente, "mudo", ou com erro de comunicação.
#define PC_SAMINV			52 	// SAM inválido, desconhecido ou com problemas.
	// 53 a 59 Reservado para uso futuro.
	// Status de 60 a 99 : Erros de processamento de cartão com chip (usuário)
#define PC_DUMBCARD			60 	// Cartão não responde ("mudo") ou chip não presente.
#define PC_ERRCARD			61 	// Erro de comunicação do pinpad com o cartão inteligente.
#define PC_CARDINV			62 	// Cartão do tipo inválido ou desconhecido, não pode ser tratado (não
								// é EMV nem TIBC v1).
#define PC_CARDBLOCKED		63 	// Cartão bloqueado por número excessivo de senhas incorretas
								// (somente para Easy-Entry TIBC v1).
#define PC_CARDNAUTH		64 	// Cartão TIBC v1 não autenticado pelo módulo SAM (somente para
								// Easy-Entry TIBC v1).
#define PC_CARDEXPIRED		65 	// Cartão TIBC v1 expirado (somente para Easy-Entry TIBC v1).
#define PC_CARDERRSTRUCT	66 	// Cartão com erro de estrutura - arquivos estão faltando.
#define PC_CARDINVALIDAT	67 	// Cartão foi invalidado.
								// Se o cartão for TIBC v1, quando seleção de arquivo ou ATR
								// retornar status ‘6284’.
								// Se o cartão for EMV, quando seleção de aplicação retornar status
								// ‘6A81’.
#define PC_CARDPROBLEMS		68	// Cartão com problemas. Esse status é válido para muitas
								// ocorrências no processamento de cartões TIBC v1 e EMV onde o
								// cartão não se comporta conforme o esperado e a transação deve
								// ser finalizada.
#define PC_CARDINVDATA		69 	// O cartão, seja TIBC v1 ou EMV, comporta-se corretamente porém
								// possui dados inválidos ou inconsistentes.
#define PC_CARDAPPNAV		70 	// Cartão sem nenhuma aplicação disponível para as condições
								// pedidas (ou cartão é reconhecido como TIBC v1 ou EMV mas não
								// possui nenhuma aplicação compatível com a requerida).
#define PC_CARDAPPNAUT		71 	// Somente para cartão EMV. A aplicação selecionada não pode ser
								// utilizada neste terminal pois o Get Processing Options retornou
								// status ‘6985’.
#define PC_NOBALANCE		72 	// Somente para aplicação de moedeiro. O saldo do moedeiro é
								// insuficiente para a operação.
#define PC_LIMITEXC			73 	// Somente para aplicação de moedeiro. O limite máximo para a
								// operação foi excedido.
#define PC_CARDNOTEFFECT	74	// Cartão ainda não efetivo.
#define PC_VCINVCURR		75	// Moeda ínválida.
#define PC_ERRFALBACK		76	// Erro de alto nível no cartão EMV que é passível de Fallback.
 // 77 a 99 Reservado para uso futuro.


 // 200 a 299 Reservado para uso do Scope

#define PC_RESERVADO     			200 // Transacao negada na funcao PP_GoOnChip()
#define PC_TRN_NEGADA_CHIP			201 // Transacao negada na funcao PP_GoOnChip()
#define PC_MEM_NAO_ALOCADA			202 // Memoria nao alocada para a estrutura do pinpad compartilhado
#define PC_ERRO_ALOCANDO_MEMORIA	203 // Erro alocando memoria
#define PC_MEMORIA_INSUFICIENTE		204 // Memoria insuficiente para receber os dados
#define PC_JA_ABERTO_VIA_SCOPE		205 // Pinpad ja aberto via Scope
#define PC_MKEY_NAO_DEFINIDA		206 // Nao foi possivel definir a Master Key a ser utilizada
#define PC_ESTADO_NAO_DEFINIDO		207 // Nao foi possivel definir o Estado de coleta no PIN-Pad
#define PC_ERRO_PRM_GET_PIN			208 // Erro no parametro da funcao GetPIN
#define PC_PINPAD_NAO_CONFIGURADO	209 // Pinpad nao configurado
#define PC_DISPLAY_NAO_PERMITIDO	210 // Display nao permitido neste momento ou situacao
#define PC_NAO_ABERTO_APP			211 // Pinpad nao foi aberto pela aplicacao
#define PC_TIMEOUT_USER				212 // Timeout do cliente/usuario
#define PC_DATA_NOT_FOUND			213 // Dado no chip nao encontrado

#define PC_COMANDA_VAZIA			214 //Comanda não possui ítens 
#define PC_COMANDA_INVALIDA			215 //A Leitura da comanda apresentou erros 
#define PC_PINPAD_TABELAS_VAZIAS	216 //As tabelas do pinpad estão vazias

 // 213 a 299 Reservado para uso futuro.

#define PC_MAX_ERRO					300 // Indica o fim da tabela de erros



/*--------------------------------------------------------------------------------------------
		Tipo de aplicacao do PIN-Pad Compartilhado
--------------------------------------------------------------------------------------------*/
#define PC_APL_CREDITO				1	// Aplicacao de Credito
#define PC_APL_DEBITO				2	// Aplicacao de Debito
#define PC_APL_QUALQUER				99	// Qualquer aplicacao



/********************************************************************************************

		TYPEDEF

*********************************************************************************************/
/* Comanda em SmartCard */
typedef struct {
	char atendimento[3];
	char operador[6];
	char mesa[3];
	char serial[10];
	char pos[4];
	char seq[3];
	char data[8];
	char hora[4];
	char codigo[14];
	char qtd[8];
	char status;
} statend_item, *lpatend_item;

typedef struct {
	char comanda[8];
	char loja[4];
	char qtd_itens[3];
	statend_item atend_items;
} stcomanda_cafe, *lpcomanda_cafe;

typedef enum {
	comanda_reservado,
	comanda_cafe
} etipocomandas;
/*--------------------------------------------------------------------------------------------
		Define os estados para a funcao ScopeSuspend()
--------------------------------------------------------------------------------------------*/
typedef enum {
/* 000 */	EC_COLETA_CARTAO,
/* 001 */	EC_COLETA_VALIDADE_CARTAO,
/* 002 */	EC_MONTA_ENVIA_TEF,
/* 003 */	EC_EXIBE_NAO_AUTORIZADO,
/* 004 */	EC_IMPRIME_CUPOM,
/* 005 */	EC_RECUPERA_SERVICOS,
/* 006 */	EC_COLETA_CGC_CPF,
/* 007 */	EC_ENCERRA_TRANSACAO_CANCELADA,
/* 008 */	EC_ENCERRA_TRANSACAO_OK,
/* 009 */	EC_COLETA_BANCO,
/* 010 */	EC_COLETA_AGENCIA,
/* 011 */	EC_COLETA_NUM_CHEQUE,
/* 012 */	EC_COLETA_BOM_PARA,
/* 013 */	EC_IMPRIME_CHEQUE,
/* 014 */	EC_DECIDE_A_VISTA,
/* 015 */	EC_DECIDE_FIN_ADM,
/* 016 */	EC_DECIDE_PRE_DATADO,
/* 017 */	EC_DECIDE_PARCELA_A_VISTA,
/* 018 */	EC_COLETA_DIAS_ENTRE_PARCELAS,
/* 019 */	EC_COLETA_QTD_PARCELAS,
/* 020 */	EC_DECIDE_PLANO_FINANCIAMENTO,
/* 021 */	EC_COLETA_DIAS_DDMM,
/* 022 */	EC_DECIDE_COLETA_SENHA,						/* Decid. coleta ou nao senha */
/* 023 */	EC_COLETA_SENHA,
/* 024 */	EC_LOAD_BANDEIRA,
/* 025 */	EC_DESFAZIMENTO,
/* 026 */	EC_RECUPERA_MENSAGEM,
/* 027 */	EC_COLETA_CONTROLE,
/* 028 */	EC_CRITICA_CANCELAMENTO,
/* 029 */	EC_CRITICA_CARTAO,
/* 030 */	EC_MONTA_ENVIA_PRE_AUTORIZACAO,
/* 031 */	EC_DECIDE_FORMA_PAGTO,
/* 032 */	EC_MODALIDADE,
/* 033 */	EC_PRIM_VCTO,
/* 034 */	EC_VALOR_ENTRADA,
/* 035 */	EC_FORMA_ENTRADA,
/* 036 */	EC_INICIA_COLETA_NUM_CHEQUES,
/* 037 */	EC_COLETA_CONTA_CORRENTE,
/* 038 */	EC_ENCERRA_TRANSACAO_ABORTADA,
/* 039 */	EC_DECIDE_ULTIMOS_DIGITOS,
/* 040 */	EC_COLETA_ULTIMOS_DIGITOS,					/* Coleta ultimos 4 digitos */
/* 041 */	EC_VERIFICACAO_LOCAL_CARTAO_SERVICOS,		/* Verf. Visanet x Nao Dig. x Electron*/
/* 042 */	EC_DECIDE_ULTIMO,
/* 043 */	EC_RECUPERA_COMPROVANTE,
/* 044 */	EC_DECIDE_CONSULTA_PARCELAS,
/* 045 */	EC_CONSULTA_PARCELAS,
/* 046 */	EC_IMPRIME_CONSULTA,
/* 047 */	EC_DECIDE_CONTINUA,
/* 048 */	EC_EXIBE_MENSAGEM_ERRO,
/* 049 */	EC_EXIBE_AUTORIZADO,
/* 050 */	EC_DECIDE_A_VISTA_SENHA,
/* 051 */	EC_DECIDE_FIN_ADM_QTD_PARCELAS,
/* 052 */	EC_DECIDE_PRE_DATADO_OU_PARCELADO,
/* 053 */	EC_DECIDE_COM_OU_SEM_PARCELA_A_VISTA,
/* 054 */	EC_COLETA_CARTAO_RESUMO_VENDAS,
/* 055 */	EC_DECIDE_CONTINUA_OU_FIM,
/* 056 */	EC_EXIBE_CONTINUA,
/* 057 */	EC_EXIBE_FIM,
/* 058 */	EC_COLETA_NUM_CHEQUE_CDC,
/* 059 */	EC_DECIDE_IMPRIME_CHEQUE,
/* 060 */	EC_COLETA_QTD_DIAS,
/* 061 */	EC_COLETA_QTD_DIAS_PRIMEIRA_PARCELA,
/* 062 */	EC_COLETA_DATA_PRIMEIRA_PARCELA,
/* 063 */	EC_ATRIBUTOS_PRE_DATADO,
/* 064 */	EC_ATRIBUTOS_D_PARC_C_PARC_AVISTA,
/* 065 */	EC_ATRIBUTOS_DIAS_ENTRE_PARCELAS,
/* 066 */	EC_ATRIBUTOS_QTD_PARCELAS,
/* 067 */	EC_DECIDE_PRE_AUTORIZACAO,
/* 068 */	EC_COLETA_PRE_AUTORIZACAO,
/* 069 */	EC_COLETA_DIA_MES_FECHADO,
/* 070 */	EC_ATRIBUTOS_D_PARC_S_PARC_AVISTA,
/* 071 */	EC_DECIDE_CARTAO_CHEQUE,
/* 072 */	EC_CRITICA_CHEQUE,
/* 073 */	EC_IMPRIME_NOTA_PROMISSORIA,
/* 074 */	EC_COLETA_DATA_PRE_AUTORIZACAO,
/* 075 */	EC_COLETA_CEP,
/* 076 */	EC_COLETA_NUMERO_ENDERECO,
/* 077 */	EC_COLETA_COMPLEMENTO,
/* 078 */	EC_DECIDE_CONSULTA_CASH,
/* 079 */	EC_CONSULTA_CASH,
/* 080 */	EC_DECIDE_COLETA_FININVEST,
/* 081 */	EC_COLETA_PLANO_PAGAMENTO,
/* 082 */	EC_COLETA_CICLOS_A_PULAR,
/* 083 */	EC_COLETA_NRO_ITEM,
/* 084 */	EC_DECIDE_CVV_CVC_2,
/* 085 */	EC_COLETA_CVV_CVC_2,
/* 086 */	EC_OBTEM_AUTORIZACAO_SUPERVISOR,
/* 087 */	EC_AUSENCIA_CVV_CVC_2,
/* 088 */	EC_ATR_GARANTIA_PREDATADO,
/* 089 */	EC_DECIDE_GARANTIA_PREDATADO,
/* 090 */	EC_DECIDE_RISCO_PREDATADO,
/* 091 */	EC_ATRIBUTO_CVV2_ULTIMOS_DIGITOS,
/* 092 */	EC_DECIDE_COLETA_VALOR_SAQUE,
/* 093 */	EC_COLETA_VALOR_SAQUE,
/* 094 */	EC_CONSULTA_VALORES,
/* 095 */	EC_COLETA_VALOR_RECARGA,
/* 096 */	EC_CRITICA_VALOR_RECARGA,
/* 097 */	EC_COLETA_COD_LOC_TELEFONE,
/* 098 */	EC_COLETA_NUM_TELEFONE,
/* 099 */	EC_SUGESTAO_VALOR_RECARGA,
/* 100 */	EC_CRITICA_TRANSACAO,
/* 101 */	EC_COLETA_DIG_VERIFICADOR,
/* 102 */	EC_DECIDE_COLETA_TAXA_SERVICO,
/* 103 */	EC_COLETA_VALOR_TAXA_SERVICO,
/* 104 */	EC_COLETA_DDMMAA,
/* 105 */	EC_DECIDE_COLETA_DDMMAA,
/* 106 */	EC_DECISAO_PREV_SERVICO,
/* 107 */	EC_DECISAO_PREV_SERVICO_CONSULTA,
/* 108 */	EC_DECISAO_PREV_SERVICO_EXTRATO,
/* 109 */	EC_DECIDE_SAQUE,
/* 110 */	EC_DECIDE_SAQUE_SIMULADO,
/* 111 */	EC_DECIDE_SALDO_EXTRATO,
/* 112 */	EC_DECIDE_EXTRATO_RESUMIDO_SEGVIA,
/* 113 */	EC_DECIDE_COLETA_VALOR,
/* 114 */	EC_COLETA_VALOR,
/* 115 */	EC_DECIDE_RESUMIDO_SEGVIA,
/* 116 */	EC_DECIDE_COLETA_QTD_PARCELAS,
/* 117 */	EC_VALIDA_DADOS,
/* 118 */	EC_EXIBE_MSG_CRITICA,
/* 119 */	EC_DECIDE_CONSULTA_RESGATE,
/* 120 */	EC_DECISAO_PREV_SERVICO_RESGATE,
/* 121 */	EC_DECIDE_RESGATE_AVULSO,
/* 122 */	EC_DESFAZIMENTO_RISCO_PREDATADO,
/* 123 */	EC_DECIDE_COLETA_DDMMAAAA,
/* 124 */	EC_COLETA_DDMMAAAA,
/* 125 */	EC_VERIFICA_MSG_ADVERTENCIA,
/* 126 */	EC_EXIBE_MSG,
/* 127 */	EC_COLETA_COD_AUT_MEDICAMENTO,
/* 128 */	EC_COLETA_REGISTRO_MEDICAMENTO,
/* 129 */	EC_FORNECE_LISTA_MEDICAMENTO,
/* 130 */	EC_IMPRIME_CUPOM_PARCIAL,
/* 131 */	EC_COLETA_QTD_PARCELAS_ACEITA1,
/* 132 */	EC_COLETA_COD_BARRAS,
/* 133 */	EC_DECIDE_COLETA_VENCIMENTO,
/* 134 */	EC_COLETA_VENCIMENTO,
/* 135 */	EC_COLETA_COD_CONSULTA_PBM,
/* 136 */	EC_COLETA_MEDICAMENTOS_SEM_RECEITA,
/* 137 */	EC_COLETA_CRM_MEDICO,
/* 138 */	EC_COLETA_CODIGO_UF_CRM_MEDICO,
/* 139 */	EC_DECIDE_COLETA_SEGURO,
/* 140 */	EC_COLETA_SEGURO,
/* 141 */	EC_DECIDE_COLETA_CARTAO,
/* 142 */	EC_DECIDE_CARTAO,
/* 143 */	EC_COLETA_DADOS_TOKORO,
/* 144 */	EC_DECISAO_PREV_FIN_ADM,
/* 145 */	EC_DECIDE_PAG_APOS_VENC,
/* 146 */	EC_COLETA_DECIDE_COL_SENHA,
/* 147 */	EC_IMPRIME_CUPOM_PROMOCIONAL,
/* 148 */	EC_COLETA_UTILIZA_SALDO,
/* 149 */	EC_COLETA_CODIGO_MATERIAL,
/* 150 */	EC_COLETA_PLANO,
/* 151 */	EC_DECIDE_PAGTO_CHEQUE,
/* 152 */	EC_DECIDE_CONFIRMA_TRANSACAO,
/* 153 */	EC_CLIENTE_NAO_CONFIRMOU_TRANSACAO,
/* 154 */	EC_DECIDE_PAGTO_ROTATIVO,
/* 155 */	EC_COLETA_CONF_VALOR_PINPAD,
/* 156 */	EC_EXIBE_GAR_NAO_AUTORIZADA,
/* 157 */	EC_COLETA_CMC7,
/* 158 */	EC_DECIDE_DIN_TEF,
/* 159 */	EC_COLETA_TEF_EXT_COD_GRUPO,
/* 160 */	EC_COLETA_TEF_EXT_COD_REDE,
/* 161 */	EC_COLETA_TEF_EXT_COD_ESTAB,
/* 162 */	EC_COLETA_TEF_EXT_NSU_HOST,
/* 163 */	EC_COLETA_TEF_EXT_DDMMAAAA,
/* 164 */	EC_COLETA_TEF_EXT_CRITICA,
/* 165 */	EC_DECIDE_CONSULTA,
/* 166 */	EC_CONSULTA,
/* 167 */	EC_CONTA_PERMITIDA_CONTINUA,
/* 168 */	EC_COLETA_COD_BANDEIRA,
/* 169 */	EC_DECIDE_CONTA_FATURA,
/* 170 */	EC_CRITICA_COD_BARRAS,
/* 171 */	EC_COLETA_CONFIRMACAO_VALOR,
/* 172 */	EC_DECIDE_IMPRIME_TOTAL_OU_PARCIAL,
/* 173 */	EC_COLETA_VALOR_TOTAL,
/* 174 */	EC_DECIDE_VENDAS_PAGAMENTOS,
/* 175 */	EC_COLETA_RG,
/* 176 */	EC_DECIDE_RETENTATIVA,
/* 177 */	EC_COLETA_CPF,
/* 178 */	EC_COLETA_ENDERECO,
/* 179 */	EC_COLETA_ANDAR,
/* 180 */	EC_COLETA_CONJUNTO,
/* 181 */	EC_COLETA_BLOCO,
/* 182 */	EC_COLETA_BAIRRO,
/* 183 */	EC_COLETA_AUTORIZACAO_OU_CARTAO,
/* 184 */	EC_COLETA_DATA_EMISSAO_CARTAO,
/* 185 */	EC_COLETA_PLANO_INFOCARDS,
/* 186 */	EC_COLETA_NUM_CUPOM_FISCAL,
/* 187 */	EC_COLETA_OPERADORA,
/* 188 */	EC_COLETA_DADOS_SAB,
/* 189 */	EC_COLETA_NUM_TELEFONE_COM_DV,
/* 190 */	EC_COLETA_DADOS_TRN_FORCADA_SAB,
/* 191 */	EC_DECIDE_SERVICO_TECNICO,
/* 192 */	EC_RESERVADO,
/* 193 */	EC_RESERVADO2,
/* 194 */	EC_COLETA_NUMERO_OS,
/* 195 */	EC_COLETA_ID_TECNICO,
/* 196 */	EC_COLETA_COD_OCORRENCIA,
/* 197 */	EC_COLETA_EPS_CREDENCIADA,
/* 198 */	EC_GO_ON_CHIP,
/* 199 */	EC_FINISH_CHIP,
/* 200 */	EC_RECUPERA_TABELAS_PINPAD,
/* 201 */	EC_COLETA_CONFIRMACAO_POSITIVA,
/* 202 */	EC_DECIDE_VALOR_ENTRADA,
/* 203 */	EC_DECIDE_COLETA_VALOR_1aPARCELA,
/* 204 */	EC_COLETA_VALOR_1aPARCELA,
/* 205 */	EC_SALVA_SERVICO_ESCOLHIDO,
/* 206 */	EC_DECIDE_CONSULTA_PARCELAS_OU_ENVIA_TEF,
/* 207 */	EC_DECIDE_CHIP_OU_SENHA,
/* 208 */	EC_DECIDE_COLETA_DADOS_ADICIONAIS,
/* 209 */	EC_COLETA_DADOS_ADICIONAIS,
/* 210 */	EC_DECIDE_FLUXO,
/* 211 */	EC_CONSULTA_OPERADORAS,
/* 212 */	EC_DECIDE_CONF_VALOR_PINPAD,
/* 213 */	EC_TRANSACAO_CANCELADA_CLIENTE,
/* 214 */	EC_DECIDE_CANCELA_TRANSACAO,
/* 215 */	EC_COLETA_CANCELA_TRANSACAO,
/* 216 */	EC_COLETA_EM_ANDAMENTO,
/* 217 */	EC_RETIRA_CARTAO,
/* 218 */	EC_TRANSACAO_APROVADA,
/* 219 */	EC_DECIDE_COLETA_TAXA_EMBARQUE,
/* 220 */	EC_COLETA_VALOR_TAXA_EMBARQUE,
/* 221 */	EC_COLETA_CARTAO_EM_ANDAMENTO,
/* 222 */	EC_EXIBE_MSG_SALDO,
/* 223 */	EC_PINPAD_EXIBE_MSG_E_RETORNA,
/* 224 */	EC_PINPAD_EXIBE_ERRO_E_AGUARDA,
/* 225 */	EC_COLETA_CARTAO_DIGITADO,
/* 226 */	EC_OBTEM_SERVICOS,
/* 227 */	EC_EXIBE_SALDO_PINPAD,
/* 228 */	EC_ENCERRA_TRANSACAO_ERRO,
/* 229 */	EC_COLETA_COD_PRODUTO,
/* 230 */	EC_EXIBE_MSG_RECEBIDA_PINPAD_E_RETORNA,
/* 231 */	EC_EXIBE_ERRO_RECEBIDO_PINPAD_E_AGUARDA,
/* 232 */	EC_EXIBE_MENU,
/* 233 */	EC_ENCERRA_MENU,
/* 234 */	EC_ENCERRA_TRANSACAO,
/* 235 */	EC_DECIDE_INSS,
/* 236 */	EC_COLETA_CONTRATO,
/* 237 */	EC_CRITICA_CPF,
/* 238 */	EC_COLETA_DATA_CLIENTE_DESDE,
/* 239 */	EC_RECUPERA_COMPROVANTE_SERVER,
/* 240 */	EC_FORNECE_VALOR,
/* 241 */	EC_RECUPERA_MENU_CANCELAMENTO,
/* 242 */	EC_COLETA_DADOS_TRN_ORIGINAL,
/* 243 */	EC_RETORNO_DADOS_TRN_ORIGINAL,
/* 244 */	EC_COLETA_NUM_AUT_ORIG,
/* 245 */	EC_COLETA_DATA_ORIG,
/* 246 */	EC_COLETA_NSU_ORIG,
/* 247 */	EC_EXIBE_DADOS_CANC,
/* 248 */	EC_DECIDE_VIAS_REIMPRESSAO,
/* 249 */	EC_EXIBE_MSG_ROTATIVA,
/* 250 */	EC_COLETA_DDD_PP,
/* 251 */	EC_COLETA_NUMTEL_PP,
/* 252 */	EC_COLETA_NUM_TELEFONE_COM_DV_PP,
/* 253 */	EC_COLETA_REDIGITA_RECARGA_PP,
/* 254 */   EC_TRANSACAO_APROVADA_PARCIAL,
/* 255 */	EC_COLETA_VALOR_PARCELAS,
/* 256 */	EC_COLETA_PRIMEIRA_PARCELA_30_60,
/* 257 */	EC_DECIDE_CDC_PARCELE_MAIS,
/* 258 */   EC_DECIDE_A_VISTA_COM_JUROS,
/* 259 */   EC_ENCERRA_TRANSACAO_CANCELADA_FALLBACK_INVALIDO,
/* 260 */	EC_COLETA_UTILIZA_SALDO_VOUCHER,
/* 261 */   EC_CRITICA_VALOR_TROCO_SURPRESA,
/* 262 */	EC_CONSULTA_VALE_GAS,
/* 263 */	EC_DECIDE_CEL_COD_ATIVACAO,
/* 264 */	EC_COLETA_CEL_COD_ATIVACAO,
/* 265 */	EC_COLETA_TEF_EXT_NUMERO_CARTAO,
/* 266 */   EC_COLETA_VERIFICA_PREMIACAO,
/* 267 */   EC_EXIBE_MENSAGEM_XLS_SERVER,
/* 268 */   EC_VERIFICA_OCORRENCIAS_ECUPOM,
/* 269 */   EC_CONFIRMA_OPCAO_RESGATE_PREMIO,
/* 270 */   EC_EXIBE_MENU_OCORRENCIAS_ECUPOM,
/* 271 */   EC_RESGATA_PREMIO,
/* 272 */   EC_VERIFICA_EXIBE_TEXTO_DISPLAY,
/* 273 */   EC_COLETA_NRO_RESGATE_PREMIO,
/* 274 */   EC_EXIBE_OPCAO_RESGATE_PREMIO,
/* 275 */   EC_CLIENTE_CONFIRMA_RESGATE,
/* 276 */	EC_EXIBE_VALOR_DESCONTO,
/* 277 */	EC_COLETA_HORA_ORIG,
/* 278 */	EC_TIPO_SERVICO_COMBUSTIVEL,
/* 279 */	EC_MATRICULA,
/* 280 */	EC_QUANTIDADE_COMBUSTIVEL,
/* 281 */	EC_HODOMETRO,
/* 282 */	EC_PLACA_VEICULO,
/* 283 */	EC_COLETA_VALOR_DEDUCAO,
/* 284 */	EC_COLETA_VALOR_ACRESCIMO,
/* 285 */   EC_CRITICA_LIMITE_VALOR,
/* 286 */	EC_MOSTRA_VALOR,
/* 287 */	EC_MOSTRA_VENCIMENTO,
/* 288 */	EC_COLETA_VALOR_BRADESCO,
/* 289 */	EC_DECIDE_DARF_GPS,
/* 290 */	EC_DECIDE_TIPO_DARF,
/* 291 */	EC_COLETA_CODIGO_RECEITA,
/* 292 */	EC_COLETA_NUMERO_REFERENCIA,
/* 293 */	EC_COLETA_VALOR_JUROS,
/* 294 */	EC_COLETA_CPF_PORTADOR,
/* 295 */	EC_EXIBE_MENSAGEM_ERRO_BRADESCO_VALOR,
/* 296 */	EC_COLETA_CNPJ,
/* 297 */	EC_COLETA_PERCENTUAL,
/* 298 */	EC_COLETA_MMAAAA,
/* 299 */	EC_COLETA_NUMERO_IDENTIFICADOR,
/* 300 */	EC_COLETA_VALOR_INSS,
/* 301 */	EC_COLETA_RECEITA_BRUTA,
/* 302 */	EC_CONTA_PERMIT_CONT_BRAD_TIT,
/* 303 */	EC_COLETA_NRO_VOUCHER,
/* 304 */	EC_COLETA_REDIGITA_DDD_PP,
/* 305 */	EC_COLETA_CARTAO_DIGITADO_PP,
/* 306 */	EC_COLETA_DIGITOS_FINAIS_CARTAO_PP,
/* 307 */	EC_CONFIRMA_CARTAO_DIGITADO_PP,
/* 308 */	EC_CONFIRMA_SAQUE_PP,
/* 309 */   EC_SAQUE_PP_EM_ANDAMENTO,
/* 310 */   EC_COLETA_TIPO_CONSULTA,
/* 311 */   EC_COLETA_VALOR_SAQUE_PP,
/* 312 */	EC_VALIDA_SAQUE_SCOPE,
/* 313 */   EC_VALIDA_SAQUE_AUTOMACAO,
/* 314 */   EC_COLETA_DDD_NUMTEL_PP,
/* 315 */   EC_REDIGITA_DDD_NUMTEL_PP,
/* 316 */   EC_COLETA_DADOS_ECF,
/* 317 */   EC_CRITICA_CARTAO_BENEFICIO,
/* 318 */   EC_DECIDE_ENVIA_OFFLINE,
/* 319 */   EC_MONTA_OFFLINE,
/* 320 */   EC_APAGA_OFFLINE,
/* 321 */   EC_COLETA_VALOR_TAC,
/* 322 */   EC_DECIDE_DADOS_VENDA_AVS,
/* 323 */   EC_DECIDE_COLETA_TELEFONE,
/* 324 */	EC_DECIDE_COLETA_NUMERO_ENDERECO,
/* 325 */	EC_DECIDE_COLETA_RG,
/* 326 */   EC_DECIDE_COLETA_NUM_CELULAR,
/* 327 */   EC_COLETA_NUM_CELULAR,
/* 328 */	EC_DECIDE_COLETA_CEP,
/* 329 */	EC_DECIDE_COLETA_CPF_CNPJ,
/* 330 */	EC_DECIDE_COLETA_NUM_TELEFONE,
/* 331 */	EC_COLETA_COD_LOC_CELULAR,
/* 332 */	EC_COLETA_CONFIRMA_POSITIVA_ABERTA,
/* 333 */	EC_COLETA_VALOR_JUROS_MENSAL,
/* 334 */	EC_COLETA_VALOR_JUROS_ANUAL,
/* 335 */	EC_COLETA_PORCENT_MULTA,
/* 336 */	EC_COLETA_PORCENT_JUROS_MORA,
/* 337 */	EC_COLETA_VENC_DDMMAA,
/* 338 */   EC_COLETA_CODIGO_EAN,
/* 339 */	EC_DECIDE_PGTO_CARNE,
/* 340 */	EC_COLETA_DADOS_CARTAO_PRESENTE,
/* 341 */	EC_COLETA_CONFIRMACAO_DADOS,
/* 342 */	EC_PRIMEIROS_DIGITOS,
/* 343 */	EC_COLETA_CAMPO_AUT,
/* 344 */	EC_COLETA_CAMPO_DOC,
/* 345 */	EC_COLETA_COD_REDE,
/* 346 */	EC_COLETA_SERVICO,
/* 347 */	EC_COLETA_NSU_HOST,
/* 348 */	EC_COLETA_REDE_MENU,
/* 349 */	EC_COLETA_BANDEIRA_MENU,
/* 350 */   EC_COLETA_MODALIDADE,
/* 351 */   EC_COLETA_CODIGO_CODUTOR,
/* 352 */   EC_COLETA_COD_COMBUSTIVEL,
/* 353 */   EC_COLETA_VOUCHER_FROTA,
/* 354 */	EC_COLETA_LISTA_PLANOS,
/* 355 */	EC_DECIDE_EMPRESTIMO_SAQUE,
/* 356 */	EC_COLETA_NUM_DOCUMENTO,
/* 357 */	EC_COLETA_PROJETO,
/* 358 */	EC_COLETA_LISTA_PRECOS,
/* 359 */	EC_COLETA_LISTA_MERCADORIAS,
/* 360 */	EC_DECIDE_CONTROLE_MERCADORIAS,
/* 361 */	EC_DECIDE_CONTROLE_VEICULOS,
/* 362 */	EC_DECIDE_COLETA_MOTORISTA,
/* 363 */	EC_DECIDE_COLETA_HODOMETRO,
/* 364 */	EC_DECIDE_COLETA_HORIMETRO,
/* 365 */	EC_HORIMETRO,
/* 366 */	EC_DECIDE_COLETA_PLACA,
/* 367 */	EC_COLETA_CARTAO_MAGNETICO,
/* 368 */   EC_COLETA_SENHA_NOVA,
/* 369 */   EC_COLETA_SENHA_NOVA_CONF,
/* 370 */   EC_TROCA_SENHA_CHIP,
/* 371 */   EC_CHG_PARM_CHIP,
/* 372 */	EC_COLETA_SEGMENTO_SAV,
/* 373 */	EC_COLETA_FORNECEDOR_SAV,
/* 374 */	EC_COLETA_PRODUTO_EAN_SAV,
/* 375 */	EC_COLETA_QUANTIDADE,
/* 376 */	EC_RECUPERA_DADOS,	// Estado utilizado para recuperar informações do BD (Server), os tipo de dados são definidos em ePreTefDado
/* 377 */	EC_COLETA_CLIENTE_PREFERENCIAL,
/* 378 */ EC_EXIBE_MENSAGEM,

	/* --> Proximo Estado AQUI */

			EC_INICIO_COLETA,
			EC_MAX_ESTADO
} eEstadosColeta;



/*--------------------------------------------------------------------------------------------
		Valores possiveis para o parametro <Acao> da funcao ScopeResumeParam()
--------------------------------------------------------------------------------------------*/
typedef enum
{
	PROXIMO_ESTADO,
	ESTADO_ANTERIOR,
	CANCELAR,
	APL_ERRO
} eACAO_APL;



/*--------------------------------------------------------------------------------------------
		Valores possiveis para o parametro <TypeField> da funcao ScopeForneceCampo()
--------------------------------------------------------------------------------------------*/
typedef enum {
/*01*/	SCOPE_DADO_MIN,
/*01*/	SCOPE_DADO_EMPRESA,
/*02*/	SCOPE_DADO_PLANO_LOJA,
/*03*/	SCOPE_DADO_ATRIBUTOS_APLIC,
/*04*/	SCOPE_DADO_TRILHA_01,
/*05*/	SCOPE_DADO_REG_FORMA_PAGTO,
/*06*/	SCOPE_DADO_AUT_SUPERVISOR,
/*07*/	SCOPE_DADO_IMPRIME_CHEQUE,
/*08*/	SCOPE_DADO_SEPARADOR_LINHA,
/*09*/	SCOPE_DADOS_APLIC,
/*10*/	SCOPE_DADOS_PAGAMENTO,
/*11*/	SCOPE_DADOS_APLIC_CBD,
/*12*/	SCOPE_DADO_DATA_MOVIMENTO,
/*13*/	SCOPE_DADO_NSU_CUPOM_FISCAL,
/*14*/	SCOPE_DADOS_AUTOMACAO,
/*15*/	SCOPE_DADOS_COD_AUT_MEDICAMENTOS,
/*16*/	SCOPE_DADOS_LISTA_MEDICAMENTOS,
/*17*/	SCOPE_AUTOMACAO_PERMITE_SALDO_VOUCHER,
/*18*/	SCOPE_COD_TABELA_PARCELE_MAIS,
/*19*/	SCOPE_DADOS_PAGAMENTO_EX,
/*20*/	SCOPE_AUTOMACAO_PARTICIPA_PPONLINE,
/*21*/	SCOPE_PERMITIR_SAQUE,
/*22*/	SCOPE_RESULTADO_VALIDACAO,
/*23*/	SCOPE_DADOS_ECF_BENEFICIO,
/*24*/	SCOPE_NOME_PRODUTO,
/*25*/	SCOPE_DADOS_CARTAO_PRESENTE,
/*26*/	SCOPE_DADOS_LISTA_PRECOS,
/*27*/	SCOPE_DADOS_LISTA_MERCADORIAS,
/*28*/	SCOPE_DADOS_LEADER = 28,

	SCOPE_DADO_MAX,
} tDadoForneceCampo;



/*--------------------------------------------------------------------------------------------
		Valores possiveis para o parametro <Acao> da funcao ScopeFechaSessaoTEF()
--------------------------------------------------------------------------------------------*/
typedef enum
{
	DESFAZ_TEF      = 0,
	CONFIRMA_TEF    = 1
} tAcaoSessaoTEF;


/*--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------*/
typedef enum
{
	REC_CEL_OPERADORAS_MODELO_1		= 1,
	REC_CEL_OPERADORAS_MODELO_2

} eREC_CEL_OPERADORAS_MODELO;



/*--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------*/
typedef enum
{
	REC_CEL_VALORES_MODELO_1		= 1,
	REC_CEL_VALORES_MODELO_2,
	REC_CEL_VALORES_MODELO_3,
	REC_CEL_VALORES_MODELO_4

} eREC_CEL_VALORES_MODELO;


/*--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------*/
typedef enum
{
	REGISTRO_MEDICAMENTO			= 1,
	REGISTRO_MEDICAMENTO_CRM,
	REGISTRO_MEDICAMENTO_L3,
	REGISTRO_PHARMASYSTEM_PHMS

} eREGISTRO_MEDICAMENTO;

/*--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------*/
typedef enum
{
	PP_NAO_UTILIZA					= 0,
	PP_INTERFACE_LIB_VISA			= 1,
	PP_INTERFACE_LIB_COMPARTILHADA	= 2

} ePP_INTERFACE;

/*--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------*/
typedef enum
{
	BUF_TAB_PRJ_PHARMASYSTEM,
	BUF_TAB_FORNECEDORES_SAVS,
	BUF_TAB_PRODUTOS_SAVS,
} eREC_TIPO_BUF_TABELA;
/*Tipos de layout de listas enviadas para a aplicacao */

/********************************************************************************************

		STRUCT

*********************************************************************************************/

#ifndef __linux__
#pragma pack (1)
#endif


/*--------------------------------------------------------------------------------------------
		Estrutura devolvida pela funcao ScopeGetParam()
--------------------------------------------------------------------------------------------*/
typedef struct _stPARAM_COLETA
{
	WORD	Bandeira;
	WORD	FormatoDado;
	WORD	HabTeclas;
	char	MsgOp1[64];
	char	MsgOp2[64];
	char	MsgCl1[64];
	char	MsgCl2[64];
	char	WrkKey[16+1];
#ifdef __linux__
	char	filler;			/* filler, para alinhar em 8 bytes */
#endif
	WORD	PosMasterKey;
	char	PAN[19+1];
	BYTE	UsaCriptoPinpad;
	BYTE	IdModoPagto;
	BYTE	AceitaCartaoDigitado;
	char	Reservado[105];
} stPARAM_COLETA, *ptPARAM_COLETA;



/*--------------------------------------------------------------------------------------------
		Estrutura devolvida pela funcao ScopeGetLastMsg()
--------------------------------------------------------------------------------------------*/
typedef struct _stCOLETA_MSG
{
	char	Op1[64];
	char	Op2[64];
	char	Cl1[64];
	char	Cl2[64];
} stCOLETA_MSG, *ptCOLETA_MSG;



/*--------------------------------------------------------------------------------------------
		Estrutura devolvida pela funcao ScopeGetCheque()
--------------------------------------------------------------------------------------------*/
typedef struct _stPARAM_CHEQUE
{
	char	Banco[4];
	char	Agencia[5];
	char	NumCheque[13];
	char	Valor[13];
	char	BomPara[9];
	char	CodAut[11];
	char	Municipio[41];
	short	Ordem;
} stPARAM_CHEQUE, *ptPARAM_CHEQUE;



/*--------------------------------------------------------------------------------------------
		Estrutura fornecida a funcao ScopeResumeParam() quando o parametro <TipoCaptura> = 0x80
--------------------------------------------------------------------------------------------*/
#define VERSAO_INTERFACE_PINPAD		"VERSAO 1.00"

typedef struct _stCARTAO_DADOS
{
   char VersaoInterfPinpad[11+1];		/* contante */
   char Trilha1[80+1];
   char Trilha2[40+1];
   char NroEmbosso[19+1];
   char NomeCliente[30+1];
   char DadosExtrasTrilha1[60+1];
   char TipoCartao[5+1];
   char Flags[5+1];
   char PIX[5+1];
   char IdCredito[3+1];
} stCARTAO_DADOS, *ptCARTAO_DADOS;



/*--------------------------------------------------------------------------------------------
		Formato retornado em ObtemCampo para Dados_Consulta_Fatura
--------------------------------------------------------------------------------------------*/
typedef struct {
	char szValorPagto[TAM_PADRAO_VALOR];	/* valor pagamento */
	char szValorOrig[TAM_PADRAO_VALOR];		/* valor original */
	char szValorAcres[TAM_PADRAO_VALOR];	/* acrescimo */
	char szValorAcresOpc[TAM_PADRAO_VALOR];	/* acrescimo opcional */
	char szValorMinimo[TAM_PADRAO_VALOR];	/* valor mínimo */
	char szValorDesc[TAM_PADRAO_VALOR];		/* desconto */
	char szDataVenc[8];						/* data de vencimento AAAAMMDD */
} stConsultaFatura, *LPConsultaFatura;



/*--------------------------------------------------------------------------------------------
		Formato esperado em ForneceCampo para SCOPE_DADOS_PAGAMENTO
--------------------------------------------------------------------------------------------*/
typedef struct {
	char szValorDinheiro[TAM_PADRAO_VALOR+1];					/* valor em dinheiro */
	char szValorCheque[TAM_PADRAO_VALOR+1];						/* valor em cheque */
	char szValorTEF[TAM_PADRAO_VALOR+1];						/* valor em TEF externa */
	char szChequeCMC7[TAM_MAX_CMC7+1];							/* CMC7, alinhado a esquerda (zeros a direita) */
	char ChequeCMC7Digitado;									/* '1' p/ CMC7 digitada; '0' p/ CMC7 capturada */
	char szTEFCodGrupo[TAM_COD_GRUPO+1];						/* cod. grupo de servico da TEF externa */
	char szTEFCodRede[2+1];										/* cod. rede da TEF externa */
	char szTEFCodEstabelecimento[TAM_COD_ESTABELECIMENTO+1];	/* cod. estabelecimento da TEF externa */
	char szTEFNSUHost[TAM_NSU_HOST+1];							/* NSU Host da TEF externa */
	char szTEFDDMMAAAA[8+1];									/* data da TEF externa */
} stTypeForneceCampoDadosPagamento, *LPTypeForneceCampoDadosPagamento;

/*--------------------------------------------------------------
 Formato esperado em ForneceCampo para SCOPE_DADOS_PAGAMENTO_EX
---------------------------------------------------------------*/
typedef struct {
	char szValorDinheiro[TAM_PADRAO_VALOR+1];
	char szValorCheque[TAM_PADRAO_VALOR+1];
	char szValorTEF[TAM_PADRAO_VALOR+1];
	char szChequeCMC7[TAM_MAX_CMC7+1];
	char ChequeCMC7Digitado;
	char szTEFCodGrupo[TAM_COD_GRUPO+1];
	char szTEFCodRede[2+1];
	char szTEFCodEstabelecimento[TAM_COD_ESTABELECIMENTO+1];
	char szTEFNSUHost[TAM_NSU_HOST+1];
	char szTEFDDMMAAAA[8+1];
	char szNumeroCartao[19+1];
} stTypeForneceCampoDadosPagamentoEx, *LPTypeForneceCampoDadosPagamentoEx;

/*----------------------------------------------------------------
 Formato esperado em ForneceCampo para SCOPE_DADOS_CARTAO_PRESEMTE
-----------------------------------------------------------------*/
typedef struct{
	char		PwUsuario[4];
	char		IdOperador[15];
	char		PwOperador[4];
	char		ListaSKU[999*3 + 1];
}stTypeCartaoPresente, *LPTypeCartaoPresente;

/*--------------------------------------------------------------
 Formato esperado em ForneceCampo para SCOPE_DADOS_ECF_BENEFICIO
---------------------------------------------------------------*/
typedef struct {
	char SerieECF[40];
	char Pdv[4];
	char NumeroDocFiscal[20];
	char DataDocFiscalAAAAMMDD[8];
} stTipoDadosECF, *LPTipoDadosECF;

/*--------------------------------------------------------------------------------------------
		Registro devolvido pelo Scope na Consulta PBM
--------------------------------------------------------------------------------------------*/
typedef struct {
	char    CodigoEAN[13];				/* Codigo ean do medicamento */
	char    QtdProdutos[2];				/* Quantidade autorizada do produto */
	char	PrecoPMC[7];     			/* Preço maximo ao consumidor */
	char	PrecoVenda[7];   			/* Preço de venda */
	char	PrecoFabrica[7];   			/* Preço de fabrica */
	char	PrecoAquisicao[7];			/* Preço de aquisicao */
	char	PrecoRepasse[7];   			/* Preço de repasse */
	char	ReservadoFuturo[1];			/* Reservado futuro */
	char	MotivoRejeicao[2];			/* Motivo da rejeicao */
} stREGISTRO_MEDICAMENTO, *ptREGISTRO_MEDICAMENTO;



/*--------------------------------------------------------------------------------------------
		Registro devolvido pelo Scope na Consulta PBM com CRM
--------------------------------------------------------------------------------------------*/
typedef struct	{
	stREGISTRO_MEDICAMENTO	RegistroM;	/* Dados do medicamento */
	char					CRM[9];		/* Numero do CRM */
} stREGISTRO_MEDICAMENTO_CRM, *ptREGISTRO_MEDICAMENTO_CRM;



/*--------------------------------------------------------------------------------------------
		Registro devolvido pelo Scope na Consulta PBM com CRM e número do convênio por medicamento
--------------------------------------------------------------------------------------------*/
typedef struct	{
	char	CodigoEAN[13];
	char	QtdProdutos[2];
	char	MotivoRejeicao[2];
	char	NumeroConvenio[8];
	char	PrecoPMC[7];
	char	PrecoVenda[7];
	char	PrecoFabrica[7];
	char	PrecoAquisicao[7];
	char	PrecoRepasse[7];
	char	CRM[TAM_CRM];
} stREGISTRO_MEDICAMENTO_L3, *ptREGISTRO_MEDICAMENTO_L3;

/*--------------------------------------------------------------------------------------------
PharmaSystem - Obtém a Lista de Medicamentos do SCOPE recebida da rede
--------------------------------------------------------------------------------------------*/
typedef struct	{
	char	CodigoEAN[13];
	char	QtdAprovada[4];
	char	StatusProduto[2];
	char	ObservacaoProduto[40];
	char	PrecoBruto[7];
	char	PrecoLiquido[7];
	char	ValorReceber[7];
	char	PorcentagemDesconto[5];
} stREGISTRO_PHARMASYSTEM_RET;

/*--------------------------------------------------------------------------------------------
PharmaSystem - Contém os projetos que o PDV participa, retornados na mensagem 0810, de logon
--------------------------------------------------------------------------------------------*/
typedef struct {
	char CodProjeto [6];
	char DescrProjeto [30];
	char OperadoraProjeto [20];
} stREGISTRO_PROJETO_PHMS;

/*--------------------------------------------------------------------------------------------
		Registro informado ao Scope na Compra PBM
--------------------------------------------------------------------------------------------*/
typedef struct {
	char    CodigoEAN[13];				/* Codigo ean do medicamento */
	char    QtdProdutos[2];				/* Quantidade autorizada do produto */
} stPBM_REG_COMPRA_01, *ptPBM_REG_COMPRA_01;



/*--------------------------------------------------------------------------------------------
		 Registro informado ao Scope na Compra PBM  (Identificado como formato 02)
--------------------------------------------------------------------------------------------*/
typedef struct {
	char    CodigoEAN[13];				/* Codigo ean do medicamento */
	char    QtdProdutos[2];				/* Quantidade autorizada do produto */
	char	PrecoVenda[7];     			/* Preço de venda */
	char	PrecoBruto[7];   			/* Preço bruto do produto */
} stPBM_REG_COMPRA_02, *ptPBM_REG_COMPRA_02;

/*--------------------------------------------------------------------------------------------------------
Modelo PharmaSystem. Utilizado pela função Pre-autorização Medicamento (Efetivação de produto)
---------------------------------------------------------------------------------------------------------*/
typedef struct {
	char CodigoEAN [13];
	char QtdProdutos [4];
	char PrecoBruto [7];
	char PrecoLiquido [7];
	char CodigoInternoPDV [10];
	char DescrProduto [40];
	char Zeros [4];
} stPBM_REG_PHARMASYSTEM, *ptPBM_REG_PHARMASYSTEM;

/*--------------------------------------------------------------------------------------------
		 Registro informado ao Scope na Lista de Mercadorias TicketCar
--------------------------------------------------------------------------------------------*/
// Mercadoria ID100 (TICKET)
typedef struct {
	char	CodMercadoria[5];	/* Codigo da Mercadoria consumida */
	char	QtdMercadoria[8];	/* Quantidade Mercadoria consumida */
	char	ValorTrnsMerc[9];	/* Valor da Transação para a mercadoria consumida */
	char	ValorUnitario[9];	/* Valor unitario da mercadoria consumida */
} stMercadoriaID100, *LPMercadoriaID100;

// Mercadoria SC100 (SCOPE)
typedef struct {
	char	Descricao	[40];		// descricao da mercadoria da automacao */
    stMercadoriaID100 regticket;	// Mercadoria ID100 (TICKET)
} stMercadoriaSC100, *LPMercadoriaSC100;

// Mercadoria ID101 (TICKET)
typedef struct {
	char	CodMercadoria[5];	/* Codigo da Mercadoria consumida */
	char	QtdMercadoria[8];	/* Quantidade Mercadoria consumida */
	char	ValorTrnsMerc[9];	/* Valor da Transação para a mercadoria consumida */
	char	ValorUnitario[9];	/* Valor unitario da mercadoria consumida */
	char	ValorTrnsDesc[9];	/* Valor da Transacao para a Mercadoria com desconto */
	char	ValorDesconto[9];	/* Valor do desconto */
	char	SignValorDesc;		/* Significado do campo "Valor do desconto" 0=$ 1=% */
} stMercadoriaID101, *LPMercadoriaID101;

// Mercadoria ID101 (SCOPE)
typedef struct {
	char	Descricao	[40];		// descricao da mercadoria da automacao
	stMercadoriaID101 regticket; // Mercadoria ID101 (TICKET)
} stMercadoriaSC101, *LPMercadoriaSC101;

typedef struct {
	char				IDHeader[4];		// Identificador do Layout da List "LM01"
	char				CasasValorUnitMerc; // ID126 - Numero de Casas Decimais para Valor Unitario das mercadorias
	char				CasasQuantidadeMerc;// ID145 - Numero de casas Decimais para Quantidade das mercadorias
	char				RamoAtiv[2];		// Codigo do Ramo de Ativ. do Checkout - 01=Posto Combust.
	char				IDReg[5];			// Identificador do formato do registro ID100 ou ID101
	char				QtdReg[3];			// Quantidade de registros
} stHeaderMercadorias, *LPHeaderMercadorias;

// Mercadoria (INTERNO SCOPE)
typedef struct{
	BYTE	nIDReg;			    // Identificador do tipo de registro
	char	sCodMercadoria[5];	// Codigo da Mercadoria consumida
	char: 1;
	char	sQtdMercadoria[8];	// Quantidade Mercadoria consumida
	char: 1;
	char	sValorTrnsMerc[9];	// Valor da Transação para a mercadoria consumida
	char: 1;
	char	sValorUnitario[9];	// Valor unitario da mercadoria consumida
	char: 1;
	char	sValorTrnsDesc[9];	// Valor da Transacao para a Mercadoria com desconto
	char: 1;
	char	sValorDesconto[9];	// Valor do desconto
	char: 1;
	char	cSignValorDesc;	// Significado do campo "Valor do desconto" 0=$ 1=%
	char: 1;
} stMercadoriaSCOPE, *LPMercadoriaSCOPE;

/*--------------------------------------------------------------------------------------------
		 Registro informado ao Scope na Lista de Preco de Mercadorias TicketCar
--------------------------------------------------------------------------------------------*/
typedef struct {
	char				IDHeader[4];		// Identificador do layout da lista "LP01"
	char				IDPrecos[5];		// identificador do formato do registro "ID504"
	char				QtdReg[3];			// Quantidade de registros
} stHeaderPrecos, *LPHeaderPrecos;

typedef struct {
	char	DataAtualizacao[8];	// Data da atualização de preço (AAAAMMDD) 
	char	HrAtualizacao[6];	// Hora da atualização de preço (HHMMSS) 
	char	CodMercadoria[5];	// Codigo da mercadoria 
	char	ValorUnitario[12];	// Valor do preço unitário 
	char	CasasDecimais[1];	// Numero de casas decimais para o valor unitario da mercadoria 
} stPrecoID504, *LPPrecoID504;

/*--------------------------------------------------------------------------------------------
		Atributos do Servico devolvidos pelas funcoes ScopeObtemServicos() e ScopeObtemServicosEx()
--------------------------------------------------------------------------------------------*/
typedef struct {
	WORD		Bandeira;
	BYTE		CodServico;
	BYTE		RedeInativa;						/* 0: Ativa,		1: Inativa */
	BYTE		Rede;
	BYTE		PreAutorizacao;
	BYTE		EmitePromissoria;
	BYTE		TipoDiaPredatado;
	BYTE		TipoQtdParcela;
	BYTE		TipoDiaParcela;
	BYTE		TipoDiaPrimParcela;
	BYTE		MoedaServicoCredito;
	BYTE		TipoConsultaCheque;
	BYTE		LimInfParcelas;
	BYTE		LimSupParcelas;
	BYTE		LimPreDatado;
	BYTE		DiaPredatado;
	BYTE		QtdParcela;
	BYTE		DiaParcela;
	BYTE		DiaPrimParcela;
	char		LimInfValor[11+1];
	char		LimSupValor[11+1];
	BYTE		SolicitaCodPlPagto;
	BYTE		TipoGarantiaPreDatado;
	BYTE		AceitaValorSaque;
	WORD		LimPrimParcela;
} stATRIB_SERVICO_V02, * ptATRIB_SERVICO_V02;



/*--------------------------------------------------------------------------------------------
		Servicos devolvidos pelas funcoes ScopeObtemServicos() e ScopeObtemServicosEx()
--------------------------------------------------------------------------------------------*/
typedef struct
{
	BYTE		AceitaDigitacao;				/* 0: Não Aceita,	1: Aceita */
	BYTE		PedeUlt4Digitos;				/* 0: Não solicita, 1: Solicita */
	BYTE		AceitaTxServico;				/* 0: Não Aceita,	1: Aceita */
#ifdef __linux__
	char		filler;							/* filler, para alinhar em 8 bytes */
#endif
	WORD		MaxTaxPercent;					/* Valor com duas casas decimais. Ex.:5,10% = "510\0"*/
	BYTE		ObtemSenha;						/* 0: Não Coleta,	1: Coleta */
	BYTE		PedeCVV2;						/* 0: Não Solicita,	1: Solicita */
	char		PosMasterKey;					/* 0..9: Posicao de Master Key valida */
	char		WorkingKey[16+1];
	BYTE		NumServicos;
#ifdef __linux__
	char		filler2;						/* filler, para alinhar em 8 bytes */
#endif
	WORD		TamCampoAtributos;
	stATRIB_SERVICO_V02	Atributos[MAX_PROD_PARAM];
} stPARAM_SERVICOS_V02, *ptPARAM_SERVICOS_V02;

/*--------------------------------------------------------------------------------------------
		Atributos do Servico devolvidos pelas funcoes ScopeObtemServicos() e ScopeObtemServicosEx()
--------------------------------------------------------------------------------------------*/
typedef struct {
	BYTE		Bandeira;
	BYTE		CodServico;
	BYTE		RedeInativa;						/* 0: Ativa,		1: Inativa */
	BYTE		Rede;
	BYTE		PreAutorizacao;
	BYTE		EmitePromissoria;
	BYTE		TipoDiaPredatado;
	BYTE		TipoQtdParcela;
	BYTE		TipoDiaParcela;
	BYTE		TipoDiaPrimParcela;
	BYTE		MoedaServicoCredito;
	BYTE		TipoConsultaCheque;
	BYTE		LimInfParcelas;
	BYTE		LimSupParcelas;
	BYTE		LimPreDatado;
	BYTE		DiaPredatado;
	BYTE		QtdParcela;
	BYTE		DiaParcela;
	BYTE		DiaPrimParcela;
	char		LimInfValor[11+1];
	char		LimSupValor[11+1];
	BYTE		SolicitaCodPlPagto;
	BYTE		TipoGarantiaPreDatado;
	BYTE		AceitaValorSaque;
	WORD		LimPrimParcela;
} stATRIB_SERVICO, * ptATRIB_SERVICO;

/*--------------------------------------------------------------------------------------------
		Servicos devolvidos pelas funcoes ScopeObtemServicos() e ScopeObtemServicosEx()
--------------------------------------------------------------------------------------------*/
typedef struct
{
	BYTE		AceitaDigitacao;				/* 0: Não Aceita,	1: Aceita */
	BYTE		PedeUlt4Digitos;				/* 0: Não solicita, 1: Solicita */
	BYTE		AceitaTxServico;				/* 0: Não Aceita,	1: Aceita */
#ifdef __linux__
	char		filler;							/* filler, para alinhar em 8 bytes */
#endif
	WORD		MaxTaxPercent;					/* Valor com duas casas decimais. Ex.:5,10% = "510\0"*/
	BYTE		ObtemSenha;						/* 0: Não Coleta,	1: Coleta */
	BYTE		PedeCVV2;						/* 0: Não Solicita,	1: Solicita */
	char		PosMasterKey;					/* 0..9: Posicao de Master Key valida */
	char		WorkingKey[16+1];
	BYTE		NumServicos;
#ifdef __linux__
	char		filler2;						/* filler, para alinhar em 8 bytes */
#endif
	WORD		TamCampoAtributos;
	stATRIB_SERVICO	Atributos[MAX_PROD_PARAM];
} stPARAM_SERVICOS, *ptPARAM_SERVICOS;


/*--------------------------------------------------------------------------------------------
		Dados de uma transacao armazenado no Servidor
--------------------------------------------------------------------------------------------*/
typedef struct {
	char		Empresa [4+1];				/* ref. TamEMPRESA     */
	char		Filial [4+1];				/* ref. TamFILIAL      */
	char		POS [3+1];					/* ref. TamPOS         */
	char		CodBandeira [3+1];			/* ref. TamCodBandeira */
	char		CodRede [3+1];				/* ref. TamCodRede     */
	char		CodEstab [15+1];			/* ref. TamBIT42       */
	char		NSU [6+1];					/* ref. TamBIT11       */
	char		DtHrEstab [10+1];			/* ref. TamBIT7        */	/* mmddhhmmss */
	char		DtAdministr [4+1];			/* ref. TamBIT13	   */	/* mmdd	*/
	char		DtHrGmt [10+1];				/* ref. TamBIT7        */	/* mmddhhmmss */
	char		Valor [12+1];				/* ref. TamBIT4        */
	char		TxServico [12+1];			/* ref. TamTAXA        */
	char		ValorSaque [12+1];			/* ref. TamBIT6        */
	char		Cartao [37+1];				/* ref. TamBIT35       */
	char 		DtVencCartao [4+1];			/* ref. TamBIT14       */	/* aamm	*/
	char		NumParcelas [2+1];			/* ref. TamBIT67       */
	char		Banco [3+1];				/* ref. TamBANCO       */
	char		Agencia [4+1];				/* ref. TamAGENCIA     */
	char		NumCheque [12+1];			/* ref. TamBIT37       */
	char		CodAut [10+1];				/* ref. TamCOD_AUT     */
	char		CodResp [2+1];				/* ref. TamBIT39       */
	char		NSUHost [12+1];				/* ref. TamBIT127      */
	char		CodGrServico [2+1];
	char		CodServico [3+1];

	char		StatusMsg;					/* P: Pendente;					*/
											/* R: Confirmada real-time		*/
											/* M: Confirmada manualmente	*/
											/* A: Confirmada manualmente (pendentes de primeira perna) */

	char		SitMsg;						/* O: Ok						*/
											/* 1: Em Andamento				*/
											/* 2: Pendente					*/
											/* k: Cancelamento Pendente		*/
											/* N: Não Efetuado				*/
											/* D: Desfeito					*/
											/* C: Cancelado					*/

	char		Digitado;					/* 0: Leitura magnetica			*/
											/* 1: Digitado					*/

} stDadosTransacao, *LPDadosTransacao;

typedef struct{

	char  ValorMinino[TAM_PADRAO_VALOR + 1];
	char  ValorMaximo[TAM_PADRAO_VALOR + 1];
	char  Saldo[TAM_PADRAO_VALOR + 1];

}stValoresConsultaSaldoEPAY;

/*--------------------------------------------------------------------------------------------
		Formato da Operadora para Recarga de Celular
--------------------------------------------------------------------------------------------*/
typedef struct
{
	unsigned char		CodOperCel;			/* Codigo da operadora					*/
	char		NomeOperCel[TAM_NOME_OP];	/* Nome da operadora terminado por '/0'	*/

} stREC_CEL_ID_OPERADORA, *ptREC_CEL_ID_OPERADORA;



/*--------------------------------------------------------------------------------------------
		Lista de Operadoras de Recarga de Celular retornadas pelo Servidor
--------------------------------------------------------------------------------------------*/
typedef struct
{
	short		NumOperCel;					/* número de Operadoras de Celular retornadas nesta transação */
	char		OperCel[2000];				/* tabela de operadoras										  */

} stREC_CEL_OPERADORAS, *ptREC_CEL_OPERADORAS;



/*--------------------------------------------------------------------------------------------
		Formato do valor para Recarga de Celular
--------------------------------------------------------------------------------------------*/
typedef struct
{
	char		Valor[TAM_VALOR_OP];		/* Valor Fixo da recarga, com 2 casas decimais	*/
	char		Bonus[TAM_VALOR_OP];		/* Bonus da recarga para este valor				*/
	char		Custo[TAM_VALOR_OP];		/* Custo da recarga para este valor				*/
} stREC_CEL_VALOR, *ptREC_CEL_VALOR;

typedef struct
{
	char		ValorMin[TAM_VALOR_OP];		/* Valor Fixo da recarga, com 2 casas decimais	*/
	char		ValorMax[TAM_VALOR_OP];		/* Bonus da recarga para este valor				*/
} stREC_CEL_FAIXA_VALORES, *ptREC_CEL_FAIXA_VALORES;

// Estrutura de Valores de Faixa da rede GWCEL 005
typedef struct 
{
	char		ValorMin[TAM_VALOR_OP];		/* Valor Fixo da recarga, com 2 casas decimais	*/
	char		ValorMax[TAM_VALOR_OP];		/* Bonus da recarga para este valor				*/
	char		Bonus[TAM_VALOR_OP];		/* Bonus da recarga para este valor				*/
	char		Custo[TAM_VALOR_OP];		/* Custo da recarga para este valor				*/

}stREC_CEL_FAIXA_VALORES_2, *ptREC_CEL_FAIXA_VALORES_2;


/*--------------------------------------------------------------------------------------------
		Estruturas para PharmaSystem
--------------------------------------------------------------------------------------------*/
#define	TAM_ID_BLOCO_PHARMASYS		9
#define MAX_PRJ_PHARMASYS			16


/* ==========================================================================================*/
// Constantes para rede SAVS
/* ==========================================================================================*/
#define TAM_COD_FORNECEDOR			4
#define TAM_COD_PRODUTO				13
#define TAM_NOME_FORNECEDOR			20
#define TAM_COD_SEGMENTO			2
#define TAM_VALOR					12
#define TAM_ID_GRUPO_COLETA			4
#define TAM_DESCRICAO				20
#define TAM_COD_DADO_COLETAR		4
#define TAM_ITEM_MENU				4
#define MAX_FORNECEDORES_SAVS		20 
#define MAX_PRODUTOS_SAVS			50 
#define MAX_DADOS_DINAMIC_SAVS		20
#define MAX_ITENS_MENU_SAVS			20 


typedef struct {
	char CodProjeto [6];
	char DescrProjeto [30];
	char OperadoraProjeto [20];
} stPrjPharmaSystem;

typedef struct {
	char IdBloco [TAM_ID_BLOCO_PHARMASYS];
	char QtdRegistros [2];
	stPrjPharmaSystem Projeto [MAX_PRJ_PHARMASYS];
} *LPParametrosPharmaSystem, stParametrosPharmaSystem;


/*--------------------------------------------------------------------------------------------
	Estrutura para Plataforma de Servicos - SAVS
--------------------------------------------------------------------------------------------*/
typedef struct 
{
	char CodFornecedor[TAM_COD_FORNECEDOR];	/* id_fornecedor */
	char Nome[TAM_NOME_FORNECEDOR];			/* nome_fornecedor */
	char CodSegMerc[TAM_COD_SEGMENTO];		/* cod_segmento */
	char Quantidade[1];						/* qtd_maxima produtos diferentes */
} LP_REGISTRO_FORNECEDORES_SAVS, stREGISTRO_FORNECEDORES_SAVS;

typedef struct 
{
	char CodProduto[TAM_COD_PRODUTO];	// cod_produto
	char Descricao[TAM_DESCRICAO];		// descricao
	char ValMin[TAM_VALOR];				// valor_sugerido
	char ValMax[TAM_VALOR];				// valor_sugerido
	char ValSugerido[TAM_VALOR];		// valor_sugerido
} LP_REGISTRO_PRODUTOS_SAVS, stREGISTRO_PRODUTOS_SAVS;

/*--------------------------------------------------------------------------------------------
		Lista de Valores de Recarga de Celular retornadas pelo Servidor
--------------------------------------------------------------------------------------------*/
typedef struct
{
	char				TipoValor;							/* Tipo dos valores								*/
															/* 'V' - variavel(val min e val maximo)			*/
															/* 'F' - Fixo (apenas um valor fixo)			*/
															/* 'T' - Todos (tabela de valores)				*/
	char				ValorMinimo[TAM_VALOR_OP];			/* Valor Minimo									*/
	char				ValorMaximo[TAM_VALOR_OP];			/* Valor Maximo									*/
	char				Totvalor;							/* Total de valores da tabela					*/
	stREC_CEL_VALOR		TabValores[NUM_VLRS_RC];			/* Tabela de valores com 2 casas decimais		*/
	char				MsgPromocional[TAM_MSG_PROM_OP];	/* MsgPromocional, a ser exibida com os valores	*/
} stREC_CEL_VALORES, *ptREC_CEL_VALORES;


typedef struct
{
	char				TipoValor;								/* Tipo dos valores								*/
																/* 'V' - variavel(val min e val maximo)			*/
																/* 'F' - Fixo (apenas um valor fixo)			*/
																/* 'T' - Todos (tabela de valores)				*/
	char					ValorMinimo[TAM_VALOR_OP];			/* Valor Minimo									*/
	char					ValorMaximo[TAM_VALOR_OP];			/* Valor Maximo									*/
	char					Totvalor;							/* Total de valores da tabela					*/
	stREC_CEL_VALOR			TabValores[NUM_VLRS_RC];			/* Tabela de valores com 2 casas decimais	*/
	char					MsgPromocional[TAM_MSG_PROM_OP];	/* MsgPromocional, a ser exibida com os valores*/
	char					TotFaixaValores;					/* Total de valores da tabela					*/
	stREC_CEL_FAIXA_VALORES TabFaixaValores[NUM_VLRS_RC];		/* Tab. de valores com 2 casas decimais */

} stREC_CEL_VALORES_MODELO_3, *ptREC_CEL_VALORES_MODELO_3;

// estrutura de valores 
typedef struct{



	char				TipoValor;								/* Tipo dos valores								*/
																/* 'V' - variavel(val min e val maximo)			*/
																/* 'F' - Fixo (apenas um valor fixo)			*
																/* 'T' - Todos (tabela de valores)				*/
	char					ValorMinimo[TAM_VALOR_OP];			/* Valor Minimo									*/
	char					ValorMaximo[TAM_VALOR_OP];			/* Valor Maximo									*/
	char					Totvalor;							/* Total de valores da tabela					*/
	stREC_CEL_VALOR			TabValores[NUM_VLRS_RC];			/* Tabela de valores com 2 casas decimais	*/
	char					MsgPromocional[TAM_MSG_PROM_OP];	/* MsgPromocional, a ser exibida com os valores*/
	char					TotFaixaValores;					/* Total de valores da tabela					*/
	stREC_CEL_FAIXA_VALORES_2 TabFaixaValores[NUM_VLRS_RC];		/* Tab. de valores com 2 casas decimais */

}stREC_CEL_VALORES_MODELO_4, *ptREC_CEL_VALORES_MODELO_4;

/*--------------------------------------------------------------------------------------------
	Estruturas de saida da funcao ScopePPGetCard()
		stScopePPGetCard		-> estrutura retornada para o Id igual a 0
		stScopePPGetCard_V02	-> estrutura retornada para o Id igual a 1
--------------------------------------------------------------------------------------------*/
typedef struct
{
   char Tipo[2];					/* "00" - Magnético											*/
									/* "01" - Moedeiro VisaCash sobre TIBC v1					*/
									/* "02" - Moedeiro VisaCash sobre TIBC v3					*/
									/* "03" - EMV												*/
									/* "04" - Easy-Entry sobre TIBC v1							*/
   char TamTrilha1[02];				/* Tamanho da trilha 1										*/
   char Trilha1[76];				/* Trilha 1	- alinhada à esquerda com espaços à direita		*/
   char TamTrilha2[02];				/* Tamanho da trilha 2										*/
   char Trilha2[37];				/* Trilha 2	- alinhada à esquerda com espaços à direita		*/
   char TamPAN[02];					/* Tamanho do PAN											*/
   char PAN[19];					/* PAN														*/
   char NomeEmbosso[26];			/* Nome do cliente, alinhada à esquerda com espaços à direita */

} stScopePPGetCard, *ptScopePPGetCard;

typedef struct
{
   char Tipo[2];					/* "00" - Magnético											*/
									/* "01" - Moedeiro VisaCash sobre TIBC v1					*/
									/* "02" - Moedeiro VisaCash sobre TIBC v3					*/
									/* "03" - EMV												*/
									/* "04" - Easy-Entry sobre TIBC v1							*/
   char TamTrilha1[02];				/* Tamanho da trilha 1										*/
   char Trilha1[76];				/* Trilha 1	- alinhada à esquerda com espaços à direita		*/
   char TamTrilha2[02];				/* Tamanho da trilha 2										*/
   char Trilha2[37];				/* Trilha 2	- alinhada à esquerda com espaços à direita		*/
   char TamPAN[02];					/* Tamanho do PAN											*/
   char PAN[19];					/* PAN														*/
   char NomeEmbosso[26];			/* Nome do cliente, alinhada à esq. com espaços à direita	*/
   char TamTrilha3[03];				/* Tamanho da trilha 3										*/
   char Trilha3[104];				/* Trilha 3	- alinhada à esquerda com espaços à direita		*/

} stScopePPGetCard_V02, *ptScopePPGetCard_V02;

typedef struct {
	char					CodFuncao[4+1];
	char					Descricao[40+1];
	char					CodGrupoServico[2+1];
	char					CodFluxoPDV[3+1];
	char					CodRede[3+1];
	char					CodBandeira[3+1];
	char					CodFuncaoRede[4+1];
} stScopeItemMenuDinamico, *LPScopeItemMenuDinamico;

typedef struct {
	char					TipoTabela;
	char					QtdItens;
	stScopeItemMenuDinamico	sItem[15];
} stScopeMenuDinamico, *LPScopeMenuDinamico;

typedef struct {
	char					TipoMenu;
	char					strItem[15][40+1];
} TipoScopeMenuGenerico, *LPTipoScopeMenuGenerico;

typedef struct {
	char					TipoTabela;
	char					QtdItens;
	union {
		stScopeItemMenuDinamico	sItem[15];
		TipoScopeMenuGenerico   stItemGenerico;
	} itens;
} TipoScopeMenuDinamico, *LPTipoScopeMenuDinamico;

/*--------------------------------------------------------------------------------------------
	Estrutura de dados para efetuar a transacao de autorizacao overlimit da consulta generica
--------------------------------------------------------------------------------------------*/
typedef struct
{
	char Versao[2];			// fixo em 01
	char Operacao[2];		// fixo em 16
	char Subfuncao[2];		// fixo em 12
	char TamDadosGen[3];	// tamanho dos dados a seguir
	char DadosGen[256];		// dados da consulta (apos subfuncao)
} stConsultaGenerica, *LPConsultaGenerica;


#ifndef __linux__
#pragma pack()
#endif



/********************************************************************************************

		PROTOTYPES

*********************************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

dllScopeAPI ScopeOpen	(char *_Modo, char *_Empresa, char *_Filial, char *_PDV);
dllScopeAPI ScopeClose	(void);
dllScopeAPI ScopeCompraCartaoDebito (char *_Valor);
dllScopeAPI ScopeCompraCDC (char *_Valor);
dllScopeAPI ScopeCompraCartaoCredito (char *_Valor, char *_TxServico);
dllScopeAPI ScopeCompraCartaoCreditoPrivateLabel (char *_Valor, char *_TxServico);
dllScopeAPI ScopeCancelamento (char *_Valor, char *_TxServico);
dllScopeAPI ScopeConsultaCheque (char *_Valor);
dllScopeAPI ScopeConsultaCDC (char *_Valor, char *_TxServico);
dllScopeAPI ScopeSimulacaoCrediario (WORD _CodGrupoServico, char *_Valor, char *_TxServico);
dllScopeAPI ScopeGarantiaDescontoCheque (char *_Valor);
dllScopeAPI ScopeReimpressaoComprovante (void);
dllScopeAPI ScopeRecargaCelular (void);
dllScopeAPI ScopeStatus (void);
dllScopeAPI ScopeObtemHandle (LONG _Desloc);
dllScopeAPI ScopeResumoVendas (void);
dllScopeAPI ScopeObtemCampo (LONG _Handle, LONG _Masc, char _FieldSeparator, char *_Buffer);
dllScopeAPI ScopeObtemCampoExt (LONG _Handle, LONG _Masc, LONG _Masc2, char _FieldSeparator, char *_Buffer);
dllScopeAPI ScopeObtemCampoExt2 (LONG _Handle, LONG _Masc, LONG _Masc2, LONG _Masc3, char _FieldSeparator, char *_Buffer); 
dllScopeAPI ScopeForneceCampo (char _TypeField, void * _lpStructField);
dllScopeAPI ScopeSuspend (eEstadosColeta _Estado);
dllScopeAPI ScopeResume (void);
dllScopeAPI ScopeAbort (void);
dllScopeAPI ScopeSetAplColeta (void);
dllScopeAPI ScopeGetParam (LONG _TipoParam, ptPARAM_COLETA _lpParam);
dllScopeAPI ScopeResumeParam (LONG _CodTipoColeta, char *_Dados, WORD _DadosParam, eACAO_APL _Acao);
dllScopeAPI ScopeGetLastMsg (ptCOLETA_MSG _ptParamColetaMsg);
dllScopeAPI ScopeGetCupom (WORD _CabecLen, char *_Cabec, WORD _CupomLen,
						   char *_Cupom, BYTE *_QtdVias);
dllScopeAPI ScopeGetCupomEx(WORD _CabecLen, char *_Cabec, WORD _CupomClienteLen, char *_CupomCliente,
							WORD _CupomLojaLen, char *_CupomLoja, WORD _CupomReduzLen, char *_CupomReduz, BYTE *_NroLinhasReduz);
dllScopeAPI ScopeGetCupomReduzido (WORD _CabecLen, char *_Cabec, WORD _CupomLen,
						   char *_Cupom, BYTE *_NumLinhas);
dllScopeAPI ScopeObtemTipoViaReimpressao (BYTE *_ReimpressaoComprovante, BYTE *_ViaReimpressao);
dllScopeAPI ScopeGetCheque (ptPARAM_CHEQUE _ptParamCheque);
dllScopeAPI ScopeGetNotaPromissoria (WORD _CabecLen, char *_Cabec, WORD _NotaPromissoriaLen,
									 char *_NotaPromissoria, BYTE *_QtdVias);
dllScopeAPI ScopeGetCupomPromocional (WORD _CabecLen, char *_Cabec, WORD _CupomLen,
						   char *_Cupom, BYTE *_QtdVias);
dllScopeAPI ScopeObtemValoresRecarga(char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeRecuperaValoresRecCel(BYTE _TipoTabela, char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeRecuperaOperValeGas(char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeRecuperaOperadorasRecCel(BYTE _TipoTabela, char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeMenuRecuperaItens(BYTE _TipoTabela, char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeMenuSelecionaItem(char _Item); 
dllScopeAPI ScopeVersao (char *_VersaoScope, int _TamBufVersao);
dllScopeAPI ScopeConsultaAVS (void);
dllScopeAPI ScopeConsultaPeriferico (WORD _Fabricante, WORD *_EquipamentosDisponiveis);
dllScopeAPI ScopePreAutorizacaoCredito (char *_Valor, char *_TxServico);
dllScopeAPI ScopeCapturaPreAutorizacaoCredito (char *_Valor, char *_TxServico);

dllScopeAPI ScopeTransacaoFinanceira (char *_Valor, WORD _Servico);
dllScopeAPI ScopeSaqueContrato (void);
dllScopeAPI ScopeInvestimento (char *_Valor, WORD _Servico);
dllScopeAPI ScopeObtemCartaoInvestimento(char *_CPF, char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeConsultaMedicamento(BYTE _TipoConvenio, BYTE _CodRede);
dllScopeAPI ScopeObtemMedicamentos (BYTE *_QtdRegistros, char *_Medicamentos, WORD _TamMedicamentos);
dllScopeAPI ScopeObtemMedicamentosComCRM (BYTE *_QtdRegistros, BYTE *_TipoConvenio, char *_ListaMedicamentos, WORD _TamLista);
dllScopeAPI ScopeObtemMedicamentosEx (BYTE IdLayout, BYTE *_QtdRegistros, char *_ListaMedicamentos, WORD _TamLista, BYTE *_TipoConvenio);
dllScopeAPI ScopeCompraMedicamento(BYTE _TipoConvenio, BYTE _CodRede, char *_CupomFiscal);
dllScopeAPI ScopeAtualizaValor (char *_Valor);
dllScopeAPI ScopeSaque (char *_Valor);
dllScopeAPI ScopePagamento(WORD _Servico, WORD _CodBandeira);
dllScopeAPI ScopePagamentoConta(WORD _Servico);
dllScopeAPI ScopePagamentoContaExt(WORD _Servico);
dllScopeAPI ScopeResumoOperacoes(WORD _Servico, WORD _CodBandeira);
dllScopeAPI ScopeValidaPagTEFExterna(WORD _Servico, WORD _CodBandeira, char *_Cartao, WORD _CodGrupo);
dllScopeAPI ScopeProcessaCodBarras(char *_CodBarras, BYTE _Digitado, BYTE *_Convenio, char *_Vencimento, char *_ValorNominal, char *_CodBarrasConvertido);
dllScopeAPI ScopeAbreSessaoTEF (void);
dllScopeAPI ScopeFechaSessaoTEF (BYTE _Acao, BYTE *_DesfezTEFAposQuedaEnergia);
dllScopeAPI ScopeObtemCuponsDisponiveis (WORD *_CuponsDisp);
dllScopeAPI ScopeConsultaCredito (char *_Valor, char *_TxServico);
dllScopeAPI ScopeObtemServicos (BYTE _GrupoServ, char *_NumCart, ptPARAM_SERVICOS _Servicos);
dllScopeAPI ScopeIniciaTotalTEF (BYTE _Nivel);
dllScopeAPI ScopeObtemTotalTEF (BYTE _Nivel, char* _Cupom, WORD _TamCupom, char _SeparadorLinhasCupom);
dllScopeAPI ScopeObtemDadosTotalTEF (BYTE _Nivel, char* _Buffer, WORD _TamBuffer);
dllScopeAPI ScopeObtemDadosTotalTEFEx (BYTE _Versao, BYTE _Nivel, char* _Buffer, WORD _TamBuffer);
dllScopeAPI ScopeConverteDadosCartao (void *_ptPPCartao, stCARTAO_DADOS *_ptScopeCartao);
dllScopeAPI ScopeConsultaSaldoDebito (char *_Valor);
dllScopeAPI ScopeConsultaSaldoCredito (void);
dllScopeAPI ScopeConsultaTransacao (char *_Controle, BYTE _TipoSaida , WORD TamSaida, char *_DadosTransacao);
dllScopeAPI ScopeDefineCetelemSemSenha (void);
dllScopeAPI ScopeRecuperaOperadorasRecCel(BYTE _TipoTabela, char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeRecuperaValoresRecCel(BYTE _TipoTabela, char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeConfigura(LONG _Id, LONG _Param);
dllScopeAPI ScopeObtemServicosEx (WORD _IdSaida, void *Saida);
dllScopeAPI ScopeObtemServicosEx2 (WORD _IdSaida, void *_Serv, int _Versao);
dllScopeAPI ScopeConsultaPP (BYTE *Configurado, BYTE *UsoExclusivoScope, BYTE *Porta);
dllScopeAPI ScopeValidaInterfacePP (BYTE IntPP);
dllScopeAPI ScopeNaoColetarCartaoComTrnIBI (void);
#if !defined(_SCOPEAPI_LIGHT)
dllScopeAPI ScopeAtualizaParametrosChip(char *UsoFuturo1, char *UsoFuturo2);
dllScopeAPI ScopeIATACompraCartaoCredito (char *_Valor, char *_TxServico);
dllScopeAPI ScopeCartaoDinheiro(WORD _Servico, char *_Valor);
dllScopeAPI ScopeConsultaCartaoDinheiro(void);
dllScopeAPI ScopeServicosGenericos(WORD _Servico, WORD _CodBandeira, char *_Valor);
dllScopeAPI ScopeObtemConsultaValeGas (char *_Valor);
dllScopeAPI ScopeAtualizaPrecosMercadorias(WORD _CodBandeira, char *UsoFuturo1);
dllScopeAPI ScopeConsultaSaldoCreditoGenerica(WORD _Servico, WORD _CodBandeira);
dllScopeAPI ScopeCompraCartaoCreditoGenerico(char *_Valor, WORD _Bandeira);
dllScopeAPI ScopeConsultaGenerica(WORD _Servico, WORD _CodBandeira, char *_DadosGenericos);
dllScopeAPI ScopeEmprestimo(char *_Valor, WORD _Servico, WORD _CodBandeira);
#endif
dllScopeAPI ScopeMenu (WORD _UsoFuturo);
dllScopeAPI ScopeTransacaoPOS(char *Valor, WORD Rede, WORD Bandeira, WORD Servico);


#if !defined(_SCOPEDOS) && !defined(__WATCOMC__)
dllScopeAPI ScopeColetaSenha (char *_Msg, WORD iToutSec, WORD (CALLBACK *piTestCancel) (void), char *_Senha, BYTE iPinpad);
dllScopeAPI ScopeSenha (char *_Msg, SHORT _iToutSec, SHORT (CALLBACK *piTestCancel) (void), char *_Senha, BYTE _iPinpad);
#endif

dllScopeAPI ScopeObtemOperadorasRecCelOffTEF(BYTE _TipoTabela, char *_Buffer, WORD _TamBuffer);
dllScopeAPI ScopeRecuperaValoresRecCelOffTEF(BYTE _TipoTabela, char *_Buffer, WORD _TamBuffer,char* codOperadora, char* codLocalidade);

/**** Funcoes de PIN-Pad para a biblioteca compartilhada ****/
dllScopeAPI ScopePPOpen (WORD Porta);
dllScopeAPI ScopePPClose (char  *IdleMsg);
dllScopeAPI ScopePPAbort (void);
dllScopeAPI ScopePPGetInfo (WORD Id, WORD DadosLen, char *Dados);
dllScopeAPI ScopePPDisplay (char *Msg);
dllScopeAPI ScopePPDisplayEx (char *Msg);
dllScopeAPI ScopePPStartGetKey (void);
dllScopeAPI ScopePPGetKey (void);
dllScopeAPI ScopePPStartGetPIN (char *MsgDisplay);
dllScopeAPI ScopePPStartGetPINEx (char *MsgDisplay, int mode, int mkey, char *wkey, char *pan);
dllScopeAPI ScopePPGetPIN (char *PIN);
dllScopeAPI ScopePPStartGetCard (WORD TipoApl, char* ValorInicial);
dllScopeAPI ScopePPGetCard (WORD Id, char* MsgNotify, WORD DadosLen,  char* Dados);
dllScopeAPI ScopePPMsgErro (LONG RC, char *MsgErro);
dllScopeAPI ScopePPStartGetPINEx (char *MsgDisplay, int mode, int mkey, char *wkey, char *pan);
dllScopeAPI ScopePPGetPINEx (char *PIN);
dllScopeAPI ScopePPStartObtemComanda (int  TipoComanda);
dllScopeAPI ScopePPObtemComanda(int  TipoComanda, char *Comanda, int RemoveComanda);
dllScopeAPI ScopePPStartLimpaComanda (int  TipoComanda);
dllScopeAPI ScopePPLimpaComanda(int  TipoComanda);
dllScopeAPI ScopePPGravaComanda (int  TipoComanda);
dllScopeAPI ScopeElegibilidadeCartao (BYTE _TipoConvenio, BYTE _CodRede);
dllScopeAPI ScopePreAutorizacaoMedicamento (BYTE _TipoConvenio, BYTE _CodRede);
dllScopeAPI ScopeCancelaPreAutMedicamento (BYTE _TipoConvenio, BYTE _CodRede);
dllScopeAPI ScopeRecuperaBufTabela(BYTE _TipoTabela, char *_QtdRegistros, char *_Buffer, WORD _TamBuffer);


#ifdef __cplusplus
}  /* extern "C"	*/
#endif

#endif



