using System;
using System.Text;
using System.Runtime.InteropServices;


namespace itautec.scope
{
    /** <summary>Objeto c/ as definicoes necessarias p/ o
     * uso c/ o SCoPE client</summary>*/
    unsafe public
    class ScopeAPI
    {
        #region DEFINICOES

        // Define os parametros para a funcao ScopeObtemHandle
        public const
        int HDL_TRANSACAO_ANTERIOR              = 0,
            /* Solicita um handle para uma possivel transacao interrompida */
            HDL_TRANSACAO_EM_ARQUIVO            = 8,
            /* Solicita um handle para uma transacao que ainda esta em andamento */
            HDL_TRANSACAO_EM_ANDAMENTO          = 9;

        // Identificacao das redes
        public const
        int R_GWCEL                             = 90;

        // Codigos devolvidos pelas funcoes de acesso
        // ao PIN-Pad Compartilhados
        public const
        int PC_OK                               = 0,
            PC_PROCESSING                       = 1,
            PC_PORTERR                          = 30,   /* Erro de comunicacao: porta serial
                                                           do pinpad provavelmente ocupada. */
            PC_COMMERR                          = 31;   /* Erro de comunicação: pinpad
                                                           provavelmente desconectado ou
                                                           problemas com a interface serial. */

        // Funcao ScopeConfigura() - Configura a Interface Coleta do Scope
        public const
        int CFG_CANCELAR_OPERACAO_PINPAD        = 0x00000001,   // Permite cancelar a interacao (leitura do cartao, senha e ...) no pinpad (default: desabilitado)
            CFG_OBTER_SERVICOS                  = 0x00000002,   // Permite retornar o estado TC_OBTEM_SERVICOS durante o fluxo	de TEF (default: desabilitado)
            CFG_NAO_ABRIR_DIGITADO_COM_PP       = 0x00000004,   // Permite não abrir o digitado na leitura do cartão com o PP Compartilhado (default: desabilitado)
            CFG_DEVOLVER_SENHA_CRIPTOGRAFADA    = 0x00000008,   // Permite devolver a senha criptografada com a master key da Itautec (default: desabilitado, ou seja, devolve senha aberta)
            CFG_IMPRESSORA_CARBONADA            = 0x00000010,   // Permite configurar a impressora como carbonada para não imprimir 2a via...(default: desabilitado, ou seja, no cupom exibirá 1a e 2a via)
            CFG_ARMAZENA_EM_QUEDA               = 0x00000020,   // Armazena dados da coleta para recuperar em queda de energia. (default: desabilitado)
        // OPCAO
            OP_DESABILITA                       = 0x00000000,
            OP_HABILITA                         = 0x00000001;

        // Valores de retorno do SCoPE API
        public const
        int RCS_SUCESSO                     = 0x0000,
            RCS_PRIMEIRO_COLETA_DADOS       = 0xFC00,
            RCS_COLETAR_CARTAO              = 0xFC00,
            RCS_MOSTRA_INFO_AGUARDA_CONF    = 0xFCFF,
            RCS_ULTIMO_COLETA_DADOS         = 0xFCFF,
            RCS_TRN_EM_ANDAMENTO            = 0xFE00,
            RCS_API_NAO_INICIALIZADA        = 0xFE01,
            RCS_API_JA_INICIALIZADA         = 0xFE02,
            RCS_EXISTE_TRN_SUSPENSA         = 0xFE03,
            RCS_DADO_INVALIDO               = 0xFF10;

        // Define os estados para a interface coleta
        public const
        int TC_PRIMEIRO_TIPO_COLETA         = 0xFC00,
            TC_CARTAO                       = TC_PRIMEIRO_TIPO_COLETA,
            TC_IMPRIME_CUPOM                = 0xFC02,
            TC_IMPRIME_CONSULTA             = 0xFC1B,
            TC_COLETA_VALOR_RECARGA         = 0xFC2E,
            TC_IMPRIME_CUPOM_PARCIAL        = 0xFC46,
            TC_COLETA_AUT_OU_CARTAO         = 0xFC6C,
            TC_COLETA_OPERADORA             = 0xFC70,
            TC_OBTEM_SERVICOS               = 0xFC84,
            TC_CARTAO_DIGITADO              = 0xFC85,
            TC_COLETA_CARTAO_EM_ANDAMENTO   = 0xFCFC,
            TC_COLETA_EM_ANDAMENTO          = 0xFCFD,
            TC_INFO_RET_FLUXO               = 0xFCFE,
            TC_INFO_AGU_CONF_OP             = 0xFCFF,
            TC_MAX_TIPO_COLETA              = TC_INFO_AGU_CONF_OP;

        // Valores 'a serem usados na ScopeResumeParam
        public const
        int _TECLADO                        = 0x0004,
            _CARTAO_MAGNETICO               = 0x0020;

        // Valores 'a serem usados na ScopeFechaSessaoTEF
        public const
        byte    _DESFAZ_TEF     = 0,        /*!< Cancela a transacao realizada
                                                             anteriormente. */
                _CONFIRMA_TEF   = 1;        //!< Confirma a transacao.

        // Definicao dos campos para as funcoes ScopeObtemCampo() e para ScopeObtemCampoExt()
        public const
        int     Numero_Conta_PAN    = 0x00000001,   //!< Personal Account Number (Card number).
                Valor_transacao     = 0x00000002,   //!< Amount.
                NSU_transacao       = 0x00000004,   //!< Transaction Id assigned by Scope.
                Cod_Bandeira        = 0x00040000,   //!< Acquirer Code.
                Cod_Rede            = 0x00400000,   //!< Net Code.
                Nome_Bandeira       = 0x00800000,   //!< Acquirer Name.
                Nome_Rede           = 0x01000000;   //!< Net Name.

        // Valores possiveis para o parametro <Acao> da funcao ScopeResumeParam()
        public
        enum eACAO_APL
        {
            PROXIMO_ESTADO,
            ESTADO_ANTERIOR,
            CANCELAR,
            APL_ERRO
        };

        // Valores possiveis para o parametro <Acao> da funcao ScopeFechaSessaoTEF()
        public
        enum tAcaoSessaoTEF: byte
        {
            DESFAZ_TEF,
            CONFIRMA_TEF
        };

        // Valores possiveis para o parametro <tipoTabela> da
        // funcao ScopeRecuperaOperadorasRecCel()
        public
        enum eREC_CEL_OPERADORAS_MODELO: byte
        {
            REC_CEL_OPERADORAS_MODELO_1 = 1,
            REC_CEL_OPERADORAS_MODELO_2
        };

        // Valores possiveis para o parametro <tipoTabela> da
        // funcao ScopeRecuperaValoresRecCel()
        public
        enum eREC_CEL_VALORES_MODELO: byte
        {
            REC_CEL_VALORES_MODELO_1 = 1,
            REC_CEL_VALORES_MODELO_2,
            REC_CEL_VALORES_MODELO_3
        };

        // Tamanho da constante pBuffInt
        private const
        int     SZBUFFINT       = 2200;

        /**
         * <summary>'Area temporaria usada p/ conversao dos dados
         * umanaged->managed.</summary>
         */
        private static
        IntPtr  pBuffInt        = Marshal.AllocHGlobal (SZBUFFINT);

        #endregion

        #region ESTRUTURAS

        /** <summary>Estrutura devolvida pela funcao ScopeGetLastMsg()</summary> */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public
        struct stCOLETA_MSG
        {
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 64)]
            public
            String              Op1,
                                Op2,
                                Cl1,
                                Cl2;
        }


        /** <summary>Dados de uma transacao armazenado no Servidor. Essa classe
         * foi criada p/ facilitar o preenchim/to da estrutura retornada pelo
         * SCoPE.</summary> */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public
        class cl_dadosTr
        {
            [DllImport("ScopeAPI.dll", EntryPoint = "ScopeConsultaTransacao", CharSet = CharSet.Ansi)]
            private static extern int ScopeConsultaTransacaoInt(StringBuilder _Controle, byte _TipoSaida, ushort TamSaida, IntPtr _DadosTransacao);

            /** <summary>Definicao da estrutura.</summary> */
            public
            struct stDadosTransacao
            {
                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 5)]
                public
                String              Empresa,
                                    Filial;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 4)]
                public
                String              POS,
                                    CodBandeira,
                                    CodRede;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 16)]
                public
                String              CodEstab;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 7)]
                public
                String              NSU;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 11)]
                public
                String              DtHrEstab;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 5)]
                public
                String              DtAdministr;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 11)]
                public
                String              DtHrGmt;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 13)]
                public
                String              Valor,
                                    TxServico,
                                    ValorSaque;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 38)]
                public
                String              Cartao;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 5)]
                public
                String              DtVencCartao;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 3)]
                public
                String              NumParcelas;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 4)]
                public
                String              Banco;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 5)]
                public
                String              Agencia;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 13)]
                public
                String              NumCheque;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 11)]
                public
                String              CodAut;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 3)]
                public
                String              CodResp;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 13)]
                public
                String              NSUHost;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 3)]
                public
                String              CodGrServico;

                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 4)]
                public
                String              CodServico;

                public
                sbyte               StatusMsg,          /* P: Pendente
                                                        R: Confirmada real-time
                                                        M: Confirmada manualmente
                                                        A: Confirmada manualmente (pendentes de primeira perna) */

                                    SitMsg,             /* O: Ok
                                                        1: Em Andamento
                                                        2: Pendente
                                                        k: Cancelamento Pendente
                                                        N: Não Efetuado
                                                        D: Desfeito
                                                        C: Cancelado */

                                    Digitado;           /* 0: Leitura magnetica
                                                        1: Digitado */
            }


            /** <summary>A estrutura 'a ser retornada.</summary> */
            public
            stDadosTransacao    stDados = new stDadosTransacao ();

            /** <summary>Funcao auxiliadora ao acesso 'as infos de
             * transacoes.</summary>
             * <param name='Controle'>O identificador (numero) da transacao
             * 'a ser verificada. Apos a execucao (c/ sucesso) dessa funcao,
             * a estrutura stDados contera' as infos retornadas do servidor.</param>
             * <returns>Possiveis valores da funcao ScopeConsultaTransacao ().</returns>
             */
            public
            int ScopeConsultaTransacao (StringBuilder Controle)
            {
                int iRet;

                iRet = ScopeConsultaTransacaoInt (Controle, 0,
                    (ushort) SZBUFFINT, pBuffInt);

                if (iRet == RCS_SUCESSO)
                    stDados = (stDadosTransacao)
                        Marshal.PtrToStructure ( pBuffInt, typeof (stDadosTransacao) );

                return (iRet);
            }
        }


        /** <summary>Classe auxiliadora p/ acesso 'as infos relativas
         * ao servico recarga de cell.</summary> */
        public
        class cl_operacCel
        {
            [DllImport("ScopeAPI.dll", EntryPoint = "ScopeRecuperaOperadorasRecCel", CharSet = CharSet.Ansi)]
            private static extern int ScopeRecuperaOperadorasRecCelInt(eREC_CEL_OPERADORAS_MODELO tipoTabela, IntPtr stOperadoras, short tamBuffer);

            [DllImport("ScopeAPI.dll", EntryPoint = "ScopeRecuperaValoresRecCel", CharSet = CharSet.Ansi)]
            private static extern int ScopeRecuperaValoresRecCelInt(eREC_CEL_VALORES_MODELO tipoTabela, IntPtr stVals, short tamBuffer);

            /** <summary>Informacoes relativas ao valor disponivel na rede.</summary> */
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
            public
            struct stREC_CEL_VALOR
            {
                public
                String              Valor,
                                    Bonus,
                                    Custo;
            }

            /** <summary>Para a versao 2.25 do Scope, essa classe sera'
             * utilizada quando na chamada da funcao StRecCel
             * recuperaValoresRecCel () for utilizado o tipo de
             * tabela 3 </summary> */
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
            public
            class stREC_CEL_FAIXA_VALORES
            {
                public
                String  ValorMin,   // Valor Fixo da recarga, com 2 casas decimais
                        ValorMax;   // Bonus da recarga para este valor
            }

            /** <summary>Lista de Valores de Recarga de Cellular
             * retornadas pelo Servidor.</summary> */
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
            public
            struct stREC_CEL_VALORES
            {
                public
                sbyte               TipoValor;

                public
                String              ValorMinimo,
                                    ValorMaximo;

                public
                sbyte               Totvalor;

                public
                stREC_CEL_VALOR []  TabValores;

                public
                String              MsgPromocional;

                public
                sbyte               TotFaixaValores;

                public
                stREC_CEL_FAIXA_VALORES []
                                    TabFaixaValores;
            }

            /** <summary>Formato da Operadora para Recarga de Celular.</summary> */
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
            public
            struct stREC_CEL_ID_OPERADORA
            {
                public
                byte                CodOperCel;

                public
                String              NomeOperCel;
            }


            /** <summary>Lista de Operadoras de Recarga de
             * Celular retornadas pelo Servidor </summary> */
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
            public
            struct stREC_CEL_OPERADORAS
            {
                public
                short                       NumOperCel;

                public
                stREC_CEL_ID_OPERADORA []   OperCel;
            }


            /** <summary>Estrutura p/ recebim/to das operadoras, apos
             * chamada a ScopeRecuperaOperadorasRecCel ().</summary> */
            public
            stREC_CEL_OPERADORAS    ListaOper   = new stREC_CEL_OPERADORAS ();

            /** <summary>Estrutura p/ recebim/to dos valores disponiveis,
             * apos chamada a ScopeRecuperaOperadorasRecCel ().</summary> */
            public
            stREC_CEL_VALORES       ListaVal    = new stREC_CEL_VALORES ();

            /** <summary>Funcao p/ obtencao das operadoras de telefonia cellular
             * disponiveis na base de dados.</summary>
             * <param name = 'tipoTabela'>O tipo de tabela desejado.</param>
             * <returns>Todos os retornos da ScopeRecuperaOperadorasRecCel ().</returns>*/
            public
            int ScopeRecuperaOperadorasRecCel (eREC_CEL_OPERADORAS_MODELO tipoTabela)
            {
                int iRet,
                    iCont;

                iRet = ScopeRecuperaOperadorasRecCelInt (tipoTabela,
                                                 pBuffInt, (short) SZBUFFINT );

                if (iRet != RCS_SUCESSO)
                    return (iRet);

                ListaOper.NumOperCel = Marshal.ReadInt16 (pBuffInt);

                ListaOper.OperCel = new stREC_CEL_ID_OPERADORA [ListaOper.NumOperCel];

                iRet = 2;

                for (iCont = 0; iCont < ListaOper.NumOperCel; iCont++)
                {
                    ListaOper.OperCel [iCont].CodOperCel = (byte)
                                Marshal.ReadByte (pBuffInt, iRet++);

                    ListaOper.OperCel [iCont].NomeOperCel = Marshal.PtrToStringAnsi
                        ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 21 ).Replace ('0', ' ').Trim ();

                    iRet += 21;
                }

                return (RCS_SUCESSO);
            }


            /** <summary>Funcao p/ obtencao dos valores de recarga.</summary>
             * <param name = 'tipoTabela'>O tipo de tabela desejado.</param>
             * <returns>Todos os retornos da ScopeRecuperaValoresRecCel ().</returns> */
            public
            int ScopeRecuperaValoresRecCel (eREC_CEL_VALORES_MODELO tipoTabela)
            {
                /* No MS-VS 2008 (C#) e' possivel o preenchim/to da estrutura
                   sem a mecanica abaixo. */
                int iRet,
                    iCont;

                iRet = ScopeRecuperaValoresRecCelInt
                        (tipoTabela, pBuffInt, (short) SZBUFFINT);

                if (iRet != RCS_SUCESSO)
                    return (iRet);

                ListaVal.TipoValor = (sbyte) Marshal.ReadByte (pBuffInt);

                iRet = 1;

                ListaVal.ValorMinimo = Marshal.PtrToStringAnsi
                                ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 12 );

                iRet += 12;

                ListaVal.ValorMaximo = Marshal.PtrToStringAnsi
                    ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 12 );

                iRet += 12;

                ListaVal.Totvalor = (sbyte) Marshal.ReadByte
                                ( (IntPtr) (pBuffInt.ToInt32 () + iRet++) );

                ListaVal.TabValores = new stREC_CEL_VALOR [ListaVal.Totvalor];

                for (iCont = 0; iCont < ListaVal.Totvalor; iCont++)
                {
                    ListaVal.TabValores [iCont].Valor = Marshal.PtrToStringAnsi
                        ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 12 ).Trim ();

                    iRet += 12;

                    ListaVal.TabValores [iCont].Bonus = Marshal.PtrToStringAnsi
                        ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 12 ).Trim ();

                    iRet += 12;

                    ListaVal.TabValores [iCont].Custo = Marshal.PtrToStringAnsi
                        ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 12 ).Trim ();

                    iRet += 12;
                }

                ListaVal.MsgPromocional = Marshal.PtrToStringAnsi
                    ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 41 );

                iRet += 41;

                if (tipoTabela == eREC_CEL_VALORES_MODELO.REC_CEL_VALORES_MODELO_3)
                {
                    ListaVal.TotFaixaValores = (sbyte) Marshal.ReadByte
                        ( (IntPtr) (pBuffInt.ToInt32 () + iRet++) );

                    if (ListaVal.TotFaixaValores > 0)
                    {
                        ListaVal.TabFaixaValores =
                                new stREC_CEL_FAIXA_VALORES [ListaVal.TotFaixaValores];

                        for (iCont = 0; iCont < ListaVal.TotFaixaValores; iCont++)
                        {
                            ListaVal.TabFaixaValores [iCont].ValorMin = Marshal.PtrToStringAnsi
                                ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 12 ).Trim ();

                            iRet += 12;

                            ListaVal.TabFaixaValores [iCont].ValorMax = Marshal.PtrToStringAnsi
                                ( (IntPtr) (pBuffInt.ToInt32 () + iRet), 12 ).Trim ();

                            iRet += 12;
                        }
                    }
                }

                return (RCS_SUCESSO);
            }
        }


        /** <summary>Estrutura p/ recebim/to dos parametros da coleta.</summary> */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public
        struct stPARAM_COLETA
        {
            public
            ushort              Bandeira,
                                FormatoDado,
                                HabTeclas;

            public
            stCOLETA_MSG        ParamColeta;

            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 17)]
            public
            String              WrkKey; //17

            public
            ushort              PosMasterKey;

            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 20)]
            public
            String              PAN;    // 20

            public
            byte                UsaCriotpPinpad,
                                IdModoPagto,
                                AceitaCartaoDigitado;

            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 105)]
            public
            String              Reservado;  //105
        }


        /** <summary>Uso das informacoes contidas no PPad.</summary> */
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        public
        class cl_infosPP
        {
            [DllImport("ScopeAPI.dll", EntryPoint = "ScopePPGetInfo", CharSet = CharSet.Ansi)]
            private static extern int ScopePPGetInfoInt(ushort Id, ushort DadosLen, IntPtr Dados);

            /** <summary>Estrutura p/ recebim/to das infos genericas via
             * ScopePPGetInfo (). </summary> */
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
            public
            class stPPInfo_Gen
            {
                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
                public
                Char []             strPPFabr,
                                    strPPModel,
                                    strPPFw;

                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
                public
                Char []             strPPEspecVer;

                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 16)]
                public
                Char []             strPPAplVer;

                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
                public
                Char []             strPPNumSer;
            }


            /** <summary>Estrutura p/ recebim/to das infos das redes via
             * ScopePPGetInfo (). </summary> */
            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
            public
            class stPPInfo_Red
            {
                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
                public
                Char []             strRedeNome;

                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 13)]
                public
                Char []             strRedeVerApl;

                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 7)]
                public
                Char []             strRedeInfos;

                public
                ushort              usSAMTam;

                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 215)]
                public
                Byte []             bSAMInfos;
            }


            /** <summary>Estrutura de retorno c/ as infos genericas.</summary> */
            public
            stPPInfo_Gen    ppGenInfos      = new stPPInfo_Gen ();

            /** <summary>Estrutura de retorno c/ as infos da rede.</summary> */
            public
            stPPInfo_Red    ppRedeInfos     = new stPPInfo_Red ();

            /** <summary>Funcao auxiliadora ao acesso 'as infos contidas
             * no PPad.</summary>
             * <param name='Id'>A info 'a ser retornada (consulte o manual
             * do desenvolvedor). As estruturas ppGenInfos e ppRedeInfos
             * serao preenchidas de acordo c/ esse parametro.</param>
             * <returns>Possiveis valores da funcao ScopePPGetInfo ().</returns> */
            public
            int ScopePPGetInfo (ushort Id)
            {
                int iRet;

                iRet = ScopePPGetInfoInt (Id, (ushort) SZBUFFINT, pBuffInt);

                if (iRet != RCS_SUCESSO)
                    return (iRet);

                if (Id == 0)
                    Marshal.PtrToStructure (pBuffInt, ppGenInfos);
                else
                    Marshal.PtrToStructure (pBuffInt, ppRedeInfos);

                return (iRet);
            }
        }

        #endregion

        #region FUNCOES

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeOpen", CharSet = CharSet.Ansi)]
        public static extern int ScopeOpen(StringBuilder modo, StringBuilder empresa, StringBuilder filial, StringBuilder pdv);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeClose", CharSet = CharSet.Ansi)]
        public static extern int ScopeClose();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeAbreSessaoTEF", CharSet = CharSet.Ansi)]
        public static extern int ScopeAbreSessaoTEF();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeSetAplColeta", CharSet = CharSet.Ansi)]
        public static extern int ScopeSetAplColeta();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeFechaSessaoTEF", CharSet = CharSet.Ansi)]
        public static extern int ScopeFechaSessaoTEF(byte acao, ref byte desfezTEFAposQuedaEnergia);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeConsultaSaldoDebito", CharSet = CharSet.Ansi)]
        public static extern int ScopeConsultaSaldoDebito(StringBuilder _Valor);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeGetCupomEx", CharSet = CharSet.Ansi)]
        public static extern int ScopeGetCupomEx (ushort _CabecLen, StringBuilder _Cabec, ushort _CupomClienteLen, StringBuilder _CupomCliente, ushort _CupomLojaLen, StringBuilder _CupomLoja, ushort _CupomReduzLen, StringBuilder _CupomReduz, ref byte _NroLinhasReduz);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeStatus", CharSet = CharSet.Ansi)]
        public static extern int ScopeStatus();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeCompraCartaoCredito", CharSet = CharSet.Ansi)]
        public static extern int ScopeCompraCartaoCredito(StringBuilder valor, StringBuilder taxaServico);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeCompraCartaoDebito", CharSet = CharSet.Ansi)]
        public static extern int ScopeCompraCartaoDebito(StringBuilder valor);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeResumoVendas", CharSet = CharSet.Ansi)]
        public static extern int ScopeResumoVendas();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeReimpressaoComprovante", CharSet = CharSet.Ansi)]
        public static extern int ScopeReimpressaoComprovante();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeReimpressaoComprovantePagamento", CharSet = CharSet.Ansi)]
        public static extern int ScopeReimpressaoComprovantePagamento(short codBandeira);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopePreAutorizacaoCredito", CharSet = CharSet.Ansi)]
        public static extern int ScopePreAutorizacaoCredito(StringBuilder valor, StringBuilder taxaServico);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeResume", CharSet = CharSet.Ansi)]
        public static extern int ScopeResume();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeGetParam", CharSet = CharSet.Ansi)]
        public static extern int ScopeGetParam(int tipoParam, ref stPARAM_COLETA _lpParam);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeResumeParam", CharSet = CharSet.Ansi)]
        public static extern int ScopeResumeParam(int codTipoColeta, StringBuilder dados, short dadosParam, eACAO_APL _Acao);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeGetLastMsg", CharSet = CharSet.Ansi)]
        public static extern int ScopeGetLastMsg(ref stCOLETA_MSG _ptParamColetaMsg);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeMTEFAbreSessao", CharSet = CharSet.Ansi)]
        public static extern int ScopeMTEFAbreSessao();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeMTEFFechaSessao", CharSet = CharSet.Ansi)]
        public static extern int ScopeMTEFFechaSessao(byte confirmar, ref byte desfazimentoForcado);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeObtemDadosTotalTEF", CharSet = CharSet.Ansi)]
        public static extern int ScopeObtemDadosTotalTEF(byte nivel, StringBuilder buffer, short tamBuffer);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeTransacaoFinanceira", CharSet = CharSet.Ansi)]
        public static extern int ScopeTransacaoFinanceira(StringBuilder valor, short servico);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeRecargaCelular", CharSet = CharSet.Ansi)]
        public static extern int ScopeRecargaCelular();

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeConfigura", CharSet = CharSet.Ansi)]
        public static extern int ScopeConfigura(int id, int param);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeObtemValoresRecarga", CharSet = CharSet.Ansi)]
        public static extern int ScopeObtemValoresRecarga(StringBuilder buffer, short tamBuffer);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeConsultaPP", CharSet = CharSet.Ansi)]
        public static extern int ScopeConsultaPP(ref byte Configurado, ref byte UsoExclusivoScope, ref byte Porta);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeObtemHandle", CharSet = CharSet.Ansi)]
        public static extern int ScopeObtemHandle (int _Desloc);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopeObtemCampoExt", CharSet = CharSet.Ansi)]
        public static extern int ScopeObtemCampoExt (int _Handle, int _Masc, int _Masc2, char _FieldSeparator, StringBuilder _Buffer);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopePPOpen", CharSet = CharSet.Ansi)]
        public static extern int ScopePPOpen(ushort Porta);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopePPClose", CharSet = CharSet.Ansi)]
        public static extern int ScopePPClose(String IdleMsg);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopePPDisplay", CharSet = CharSet.Ansi)]
        public static extern int ScopePPDisplay(String Msg);

        [DllImport("ScopeAPI.dll", EntryPoint = "ScopePPDisplayEx", CharSet = CharSet.Ansi)]
        public static extern int ScopePPDisplayEx(String Msg);

        #endregion
    }
}
