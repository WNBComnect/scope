using System;
using System.IO;
using System.Text;
using System.Threading;
using System.Runtime.InteropServices;
using itautec.scope;

namespace demoColeta
{
    class Program
    {
        /** <summary>Para facilitar no gerenciamento dos menus</summary> */
        enum _opcMenu
        {
            MNU_SAIR,
            MNU_CREDITO,                /*!< Relativa a funcao ScopeCompraCartaoCredito. */
            MNU_DEBITO,                 /*!< Relativa a funcao ScopeCompraCartaoDebito. */
            MNU_RESUMOVENDAS,           /*!< Relativa a funcao ScopeResumoVendas. */
            MNU_REIMPCOMPR,             /*!< Relativa a funcao ScopeReimpressaoComprovante. */
            MNU_RECARGCEL,              /*!< Relativa a funcao ScopeRecargaCelular. */
            MNU_TRANSFINANC,            /*!< Relativa a funcao ScopeTransacaoFinanceira. */
            MNU_CONSULTSALDCLIEN,       /*!< Relativa a funcao ScopeConsultaSaldoDebito. */
            MNU_PREAUTCRED,             /*!< Relativa a funcao ScopePreAutorizacaoCredito. */
            MNU_CONSULTTRANSAC,         /*!< Relativa a funcao ScopeConsultaTransacao. */
            MNU_LST
        };

        /** <summary>Variavel controladora das inicializacoes do programa.</summary> */
        static
        int iInic           = 0;

        /** <summary>Opcoes do menu.</summary> */
        const
        int _OPCAO_INI_TEF  = (int) Program._opcMenu.MNU_SAIR,
            _OPCAO_FIN_TEF  = (int) Program._opcMenu.MNU_LST - 1,
            CNT_PPAD        = 1;

        /** <summary>Prints a text in the console.</summary>
         * <param name = 'strBuff'>Text to print.</param> */
        static
        void    fn_PrintStr (string strBuff)
        {
            Console.Write ( strBuff.ToString () );

            return;
        }


        /** <summary>Receives from the standard input the available
         * keys (a)synchronously.</summary>
         * 
         * <param name = 'strBuffIn'>[out] Buffer to store the entered keys.</param>
         * <param name = 'bMode'>(0): Waits for a CR/LF for return.
         *  (1): Returns the available buffer immediately.
         *  (2): Returns the last buffer only if a CR/LF was received.</param>
         * 
         * <returns>false: No buffer available.</returns>
         * <returns>true: A buffer was returned.</returns>
         */
        static
        bool    fn_GetInput (StringBuilder strBuffIn, byte bMode)
        {
            bool            bRet    = false;
            string          strRet  = null;
            int             iLido   = 0;

            if (bMode == 0)
            {
                if (strBuffIn != null)
                    strBuffIn.Remove (0, strBuffIn.Length);

                strRet = Console.ReadLine ();

                bRet = true;
            }

            else if ( (bMode == 1) || (bMode == 2) )
            {
                iLido = ConsoleFunctions.getchar (false);
                if (iLido != -1)
                {
                    strRet = Convert.ToString ( Convert.ToChar (iLido) );

                    if (iLido >= '0')
                    {
                        if (bMode != 2)
                            bRet = true;
                    }
                    else
                    {
                        switch (iLido)
                        {
                            case 8/*ConsoleKey.Backspace*/:
                                if (strBuffIn.Length > 0)
                                    strBuffIn.Remove (strBuffIn.Length - 1, 1);

                                break;

                            case 13/*ConsoleKey.Enter*/:
                                strRet = null;

                                if (bMode == 2)
                                    bRet = true;

                                break;

                            default:
                                break;
                        }
                    }
                }
            }

            if ( ( bRet || (bMode == 2) ) &&
                   ( (strRet != null) && (strBuffIn != null) ) )
                strBuffIn.Append (strRet);

            return (bRet);
        }


        /** <summary>Demo main function.</summary>
         * <param name = 'args'>Arguments passed by command line.</param> */
        static
        void    Main (string [] args)
        {
            int     Opcao       = 0,
                    NroTrnOk    = 0;

            bool    Loop        = true;

            // Abre conexao com o servidor Scope
            Opcao = AbreConexaoServidor ();

            if (Opcao != ScopeAPI.RCS_SUCESSO)
            {
                fn_PrintStr ( String.Format
                        ("\nErro na comunic c/ o server: 0x{0:X04}\n", Opcao) );

                fn_GetInput (null, 0);

                return;
            }

            // Faz uso do recurso PINPad compartilhado
            AbrePINPad ();

            // Configura o fluxo de coleta dos dados
            ConfiguraColeta ();

            /* Trata a transacao TEF anterior, se houve queda
                de energia */
            VerificaSessaoAnteriorTEF ();

            while (Loop)
            {
                // Abre uma sessao TEF
                if (AbreSessaoTEF (ref NroTrnOk) == false)
                    return;

                do
                {
                    // Seleciona funcao
                    Opcao = SelecionaFuncao ();

                    if (Opcao == (int) Program._opcMenu.MNU_SAIR)
                    {
                        Loop = false;

                        break;
                    }

                    // Executa a funcao
                    ExecutaFuncao (Opcao, ref NroTrnOk);

                    // Continua na sessao TEF?
                } while ( ContinuaSessaoTEF (Opcao) );

                // Fecha a sessao TEF
                FechaSessaoTEF (NroTrnOk);
            }

            // Desconecta ao pinpad
            FechaPINPad();

            // Encerra conexao com o servidor
            FechaConexaoServidor ();

            return;
        }


        /** <summary>Procedimentos para a inicializacao da comunicacao com
         *  o servidor SCoPE.</summary>
         * <returns>!ScopeAPI.RCS_SUCESSO:   Problema na comunicacao com o servidor.</returns>
         * <returns>ScopeAPI.RCS_SUCESSO:   Sucesso na conexao.</returns> */
        static
        int     AbreConexaoServidor ()
        {
            int             iRet    = ScopeAPI.RCS_SUCESSO;

            StringBuilder   strEmpr = new StringBuilder (),
                            strFil  = new StringBuilder (),
                            strPDV  = new StringBuilder ();

            /* Parametros de inicializacao.
                Entrada via digitacao. */
            fn_PrintStr ("\n\nEmpresa [NNNN] ? "); fn_GetInput (strEmpr, 0);
            fn_PrintStr ("\nFilial  [NNNN] ? "); fn_GetInput (strFil, 0);
            fn_PrintStr ("\nPDV     [NNN]  ? "); fn_GetInput (strPDV, 0);

            // Realizar a conexao fisica com o servidor
            fn_PrintStr ("\n\nExecutando o ScopeOpen ...");

            iRet = ScopeAPI.ScopeOpen
                        (new StringBuilder ("2"), strEmpr, strFil, strPDV);

            return (iRet);
        }


        /** <summary>Procedimento para finalizacao da comunicao com
         * o servidor SCoPE.</summary> */
        static
        void    FechaConexaoServidor ()
        {
            int iRet;

            // Solicitao o fechamento do canal com o servidor SCoPE
            iRet = ScopeAPI.ScopeClose ();

            if (iRet != 0)
            {
                fn_PrintStr ( String.Format ("\nScopeClose, RC = {0:X04}\n", iRet) );

                fn_GetInput (null, 0);
            }
        }


        /** <summary>Procedimento para configuracao da forma de
         * entrada dos dados.</summary> */
        static
        void    ConfiguraColeta ()
        {
            ScopeAPI.ScopeSetAplColeta ();

            ScopeAPI.ScopeConfigura
                  (ScopeAPI.CFG_CANCELAR_OPERACAO_PINPAD, ScopeAPI.OP_HABILITA);

            return;
        }


        /** <summary>Ira' forcar um desfazimento de operacao,
         *  garantindo a recuperacao no caso de queda de energia.</summary> */
        static
        void    VerificaSessaoAnteriorTEF ()
        {
            int     iRet;

            byte    bDesfezTEF  = 0;

            // Trata a queda de energia da transacao anterior, se houver
            iRet = ScopeAPI.ScopeFechaSessaoTEF
                        ( (byte) ScopeAPI.tAcaoSessaoTEF.DESFAZ_TEF, ref bDesfezTEF );

            if ( (iRet == ScopeAPI.RCS_SUCESSO) && (bDesfezTEF != 0) )
            {
                fn_PrintStr ("\n" + centerText (" ---> ATENCAO! <---", 40) );
                fn_PrintStr ("\n" + centerText ("A TRANSACAO TEF ANTERIOR FOI DESFEITA.", 40) );
                fn_PrintStr ("\n" + centerText ("RETER O CUPOM TEF.", 40) + "\n\n\n");

                fn_GetInput (null, 0);
            }
        }


        /** <summary>Procedimento para inicializacao de uma transacao.</summary>
         * <returns>false: Falha na inicializacao.</returns>
         * <returns>true: Sucesso.</returns> */
        static
        bool    AbreSessaoTEF (ref int _NroTrnOk)
        {
            int iRet;

            // Chamada 'a funcao da API
            iRet = ScopeAPI.ScopeAbreSessaoTEF ();

            // Abre uma sessao multi-TEF
            if (iRet != ScopeAPI.RCS_SUCESSO)
            {
                fn_PrintStr ( String.Format
                        ("\nErro ScopeAbreSessaoTEF(), iRet = 0x{0:X04} (0)\n", iRet) );

                fn_GetInput (null, 0);

                return (false);
            }

            // Inicializa o nro. de transacoes TEFs aprovadas
            _NroTrnOk = 0;

            return (true);
        }


        /** <summary>Exibira' algumas das funcoes disponiveis na
         *  API do SCoPE.</summary>
         * <returns>A opcao selecionada - valores do enumerador
         * _opcMenu.</returns> */
        static
        int     SelecionaFuncao ()
        {
            int             iOp = 0;

            StringBuilder   Op  = new StringBuilder ();

            // Exibe menu
            do
            {
                fn_PrintStr ("\n\n\n");
                fn_PrintStr ("--------------------------------------------------------------\n");
                fn_PrintStr ("SELECIONE UMA FUNCAO\n");
                fn_PrintStr ("--------------------------------------------------------------\n");
                fn_PrintStr ( String.Format ("\n{0:D02}: Sair\n", (int) Program._opcMenu.MNU_SAIR) );
                fn_PrintStr ( String.Format ("\n{0:D02}: Credito                  {1:D02}: Transacao Financeira",
                                                                (int) Program._opcMenu.MNU_CREDITO, (int) Program._opcMenu.MNU_TRANSFINANC) );
                fn_PrintStr ( String.Format ("\n{0:D02}: Debito                   {1:D02}: Consulta Saldo do Cliente", (int) Program._opcMenu.MNU_DEBITO,
                                                                (int) Program._opcMenu.MNU_CONSULTSALDCLIEN) );
                fn_PrintStr ( String.Format ("\n{0:D02}: Resumo Vendas            {1:D02}: Pre-autorizacao Credito", (int) Program._opcMenu.MNU_RESUMOVENDAS,
                                                                (int) Program._opcMenu.MNU_PREAUTCRED) );
                fn_PrintStr ( String.Format ("\n{0:D02}: Reimpressao Comprovante  {1:D02}: Consulta dados da Transacao", (int) Program._opcMenu.MNU_REIMPCOMPR,
                                                                (int) Program._opcMenu.MNU_CONSULTTRANSAC) );
                fn_PrintStr ( String.Format ("\n{0:D02}: Recarga de Celular", (int) Program._opcMenu.MNU_RECARGCEL) );

                fn_PrintStr ("\n\n");

                // Coleta opcao
                fn_PrintStr ("Opcao ? "); fn_GetInput (Op, 0); fn_PrintStr ("\n");

                try
                {
                    iOp = Convert.ToInt32 ( Op.ToString () );
                }
                catch (Exception)
                {
                    iOp = _OPCAO_FIN_TEF + 1;

                    continue;
                }
            } while ( (iOp > 0) && ( (iOp > _OPCAO_FIN_TEF) ||
                                        (iOp < _OPCAO_INI_TEF) ) );

            return (iOp);
        }


        /** <summary>Direciona o fluxo do programa para a funcao selecionada.</summary>
         * <param name = '_Opcao'>A funcao 'a ser executada.
         *                   Valores: de _OPCAO_INI_TEF 'a _OPCAO_FIN_TEF.</param>
         * <param name = '_NroTrnOk'>Registro da quantidade de transacoes
         *                  realizadas com sucesso.</param> */
        static
        void    ExecutaFuncao (int _Opcao, ref int _NroTrnOk)
        {
            //  Realiza consulta dados de uma transacao TEF
            if (_Opcao == (int) Program._opcMenu.MNU_CONSULTTRANSAC)
            {
                /* Para esta transacao nao e' necessario
                    executar o fluxo de coleta */
                ConsultaTransacao ();

                return;
            }

            // Executa uma transacao TEF
            if (IniciaTransacaoTEF (_Opcao) == ScopeAPI.RCS_SUCESSO &&
                    FinalizaTransacaoTEF () == ScopeAPI.RCS_SUCESSO)
                _NroTrnOk += 1;

            return;
        }


        /** <summary>Procedimento para consulta de uma transacao.</summary> */
        static
        void    ConsultaTransacao ()
        {
            int                         iRet;

            ScopeAPI.cl_dadosTr         DadosTr     = new ScopeAPI.cl_dadosTr ();

            StringBuilder               Controle    = new StringBuilder ();

            fn_PrintStr ("\n\nControle ? "); fn_GetInput (Controle, 0);

            iRet = DadosTr.ScopeConsultaTransacao (Controle);

            if (iRet == ScopeAPI.RCS_SUCESSO)
            {
                fn_PrintStr ("\n Bandeira                                    = [" + DadosTr.stDados.CodBandeira + "]");
                fn_PrintStr ("\n Rede                                        = [" + DadosTr.stDados.CodRede + "]");
                fn_PrintStr ("\n Codigo Estabelecimento                      = [" + DadosTr.stDados.CodEstab + "]");
                fn_PrintStr ("\n Empresa                                     = [" + DadosTr.stDados.Empresa + "]");
                fn_PrintStr ("\n Filial                                      = [" + DadosTr.stDados.Filial + "]");
                fn_PrintStr ("\n POS                                         = [" + DadosTr.stDados.POS + "]");
                fn_PrintStr ("\n Data e Hora do Estabelecimento [mmddhhmmss] = [" + DadosTr.stDados.DtHrEstab + "]");
                fn_PrintStr ("\n Data Administrativa [mmdd]                  = [" + DadosTr.stDados.DtAdministr + "]");
                fn_PrintStr ("\n Data e Hora GMT [mmddhhmmss]                = [" + DadosTr.stDados.DtHrGmt + "]");
                fn_PrintStr ("\n Valor                                       = [" + DadosTr.stDados.Valor + "]");
                fn_PrintStr ("\n Texto do Servico                            = [" + DadosTr.stDados.TxServico + "]");
                fn_PrintStr ("\n Valor do Saque                              = [" + DadosTr.stDados.ValorSaque + "]");
                fn_PrintStr ("\n Cartao                                      = [" + DadosTr.stDados.Cartao + "]");
                fn_PrintStr ("\n Data do Vencimento do Cartao                = [" + DadosTr.stDados.DtVencCartao + "]");
                fn_PrintStr ("\n Banco                                       = [" + DadosTr.stDados.Banco + "]");
                fn_PrintStr ("\n Agencia                                     = [" + DadosTr.stDados.Agencia + "]");
                fn_PrintStr ("\n Numero Cheque                               = [" + DadosTr.stDados.NumCheque + "]");
                fn_PrintStr ("\n Codigo Autorizacao                          = [" + DadosTr.stDados.CodAut + "]");
                fn_PrintStr ("\n Codigo Resposta                             = [" + DadosTr.stDados.CodResp + "]");
                fn_PrintStr ("\n NSU do Host                                 = [" + DadosTr.stDados.NSUHost + "]");
                fn_PrintStr ("\n Numero de Parcelas                          = [" + DadosTr.stDados.NumParcelas + "]");
                fn_PrintStr ("\n Codigo Gr do Servico                        = [" + DadosTr.stDados.CodGrServico + "]");
                fn_PrintStr ("\n Codigo do Servico                           = [" + DadosTr.stDados.CodServico + "]");
                fn_PrintStr ("\n NSU                                         = [" + DadosTr.stDados.NSU + "]");
                fn_PrintStr ("\n Mensagem de Status                          = [" + DadosTr.stDados.StatusMsg + "]");
                fn_PrintStr ("\n Mensagem da Situacao                        = [" + DadosTr.stDados.SitMsg + "]");
                fn_PrintStr ("\n Digitado                                    = [" + DadosTr.stDados.Digitado + "]");
            }
            else
                fn_PrintStr ( String.Format ("\nScopeConsultaTransacao retornou iRet = [0x{0:X04}]", iRet) );

            fn_PrintStr ("\n\nPressione alguma tecla para continuar...");

            fn_GetInput (null, 0);

            return;
        }


        /**<summary>Procedimento para recuperacao da transacao em andamento.</summary> */
        static
        void    ExibeDadosTransacao ()
        {
            int h;

            StringBuilder   aux = new StringBuilder (128);

            /* receber o identificador da transacao */
            h = ScopeAPI.ScopeObtemHandle (0);

            if (h <= 0xFFFF)
            {
                fn_PrintStr ( String.Format
                                ("\n\nErro ScopeObtemHandle, RC = 0x{0:X04}\n") );
                return;
            }

            /* receber e exibir as infos  */
            ScopeAPI.ScopeObtemCampoExt (h, ScopeAPI.NSU_transacao,
                                            0x00, '\0', aux);
            fn_PrintStr ( String.Format ("\nNSU      = [{0}]", aux) );

            aux.Remove (0, aux.Length);
            ScopeAPI.ScopeObtemCampoExt (h, ScopeAPI.Cod_Bandeira +
                ScopeAPI.Nome_Bandeira, 0x00, ':', aux);
            fn_PrintStr ( String.Format ("\nBandeira = [{0}]", aux) );

            aux.Remove (0, aux.Length);
            ScopeAPI.ScopeObtemCampoExt (h, ScopeAPI.Numero_Conta_PAN,
                                                0x00, '\0', aux);
            fn_PrintStr ( String.Format ("\nCartao   = [{0}]", aux) );

            aux.Remove (0, aux.Length);
            ScopeAPI.ScopeObtemCampoExt (h, ScopeAPI.Cod_Rede +
                                    ScopeAPI.Nome_Rede, 0x00, ':', aux);
            fn_PrintStr ( String.Format ("\nRede     = [{0}]\n", aux) );

            return;
        }


        /** <summary>Funcao responsavel pela execucao da funcao selecionada
         *  na funcao SelecionaFuncao ().</summary>
         * <param name = 'iOp'>O numero da funcao (valida entre os numeros
         *      _OPCAO_INI_TEF e _OPCAO_FIN_TEF).</param>
         * <returns>Valores de retorno das funcoes do SCoPE.</returns> */
        static
        int     IniciaTransacaoTEF (int iOp)
        {
            StringBuilder   Valor           = new StringBuilder (),//15
                            Work            = new StringBuilder ();//64

            int             iRet            = 0;

            // chama a funcao escolhida
            switch (iOp)
            {
                // credito
                case (int) Program._opcMenu.MNU_CREDITO:
                    fn_PrintStr ("\n\nValor ? "); fn_GetInput (Valor, 0);

                    iRet = ScopeAPI.ScopeCompraCartaoCredito
                                    ( Valor, new StringBuilder ("") );

                    break;

                // procedimento de consulta de saldo do cartao de debito
                case (int) Program._opcMenu.MNU_CONSULTSALDCLIEN:
                    fn_PrintStr ("\n\nValor ? "); fn_GetInput (Valor, 0);

                    iRet = ScopeAPI.ScopeConsultaSaldoDebito (Valor);

                    break;

                // pre-autorizacao de credito
                case (int) Program._opcMenu.MNU_PREAUTCRED:
                    fn_PrintStr ("\n\nValor da transacao? ");

                    fn_GetInput (Valor, 0);

                    iRet = ScopeAPI.ScopePreAutorizacaoCredito
                                        ( Valor, new StringBuilder ("") );

                    break;

                // debito
                case (int) Program._opcMenu.MNU_DEBITO:
                    fn_PrintStr ("\n\nValor ? "); fn_GetInput (Valor, 0);

                    iRet = ScopeAPI.ScopeCompraCartaoDebito (Valor);

                    break;

                // resumo de vendas
                case (int) Program._opcMenu.MNU_RESUMOVENDAS:
                    iRet = ScopeAPI.ScopeResumoVendas ();

                    break;

                // reimpressao de comprovante
                case (int) Program._opcMenu.MNU_REIMPCOMPR:
                    iRet = ScopeAPI.ScopeReimpressaoComprovante ();

                    break;

                // recarga celular
                case (int) Program._opcMenu.MNU_RECARGCEL:
                    iRet = ScopeAPI.ScopeRecargaCelular ();

                    break;

                // transacao financeira
                case (int) Program._opcMenu.MNU_TRANSFINANC:
                    fn_PrintStr
                       ("\n\nServico: 70=Saldo, 71=ExtratoResumido, 72=Extrato, 73=SimulacaoSaque, 74=Saque");
                    fn_PrintStr ("\n\nServico ? "); fn_GetInput (Valor, 0);

                    try
                    {
                        iRet = (int) Convert.ToInt16 (Valor);
                    }
                    catch (Exception)
                    {
                        iRet = 70;
                    }

                    iRet = ScopeAPI.ScopeTransacaoFinanceira
                                        (new StringBuilder ("000"), (short) iRet);

                    break;

                default:
                    fn_PrintStr ("\n\n\nOpcao Invalida !\n"); fn_GetInput (Valor, 0);

                    break;
            }

            if (iRet != ScopeAPI.RCS_SUCESSO)
                fn_PrintStr ( String.Format
                            ("Erro na IniciaTransacaoTEF. iRet: {0:X}\n", iRet) );

            return (iRet);
        }


        /** <summary>Funcao complementar aos procedimentos realizados
         *  pela IniciaTransacaoTEF ().</summary> */
        static
        int     FinalizaTransacaoTEF ()
        {
            int                     iRet,
                                    acao        = 0;

            ushort                  wCaptura;

            StringBuilder           Work        = new StringBuilder (320);

            ScopeAPI.stPARAM_COLETA PColeta     = new ScopeAPI.stPARAM_COLETA ();

            // Processo da TEF
            while (true)
            {
                /* Enquanto a transacao estiver em
                    andamento, aguarda */
                while ( ( iRet = ScopeAPI.ScopeStatus () ) ==
                                ScopeAPI.RCS_TRN_EM_ANDAMENTO )
                    Thread.Sleep (200);

                /* Configurado que o operador podera cancelar
                   a operacao no pinpad via teclado */
                if (iRet == ScopeAPI.TC_COLETA_CARTAO_EM_ANDAMENTO)
                {
                    if ( fn_GetInput (Work, 2) )
                    {
                        acao = (int) ScopeAPI.eACAO_APL.CANCELAR;

                        if ( (Work.Length < 14) ||
                            ( ( Work.ToString ().ToUpper () ).IndexOf ('C') != -1 ) )
                            Work.Remove (0, Work.Length);

                        Thread.Sleep (500);
                    }
                    else
                        acao = (int) ScopeAPI.eACAO_APL.PROXIMO_ESTADO;

                    ScopeAPI.ScopeResumeParam (iRet,
                                new StringBuilder (""), 0,
                                        (ScopeAPI.eACAO_APL) acao );

                    continue;
                }
                else if (iRet != ScopeAPI.TC_CARTAO_DIGITADO)
                    Work.Remove (0, Work.Length);

                /* Se estiver fora da faixa FC00 a FCFF,
                                        finaliza o processo */
                if ( (iRet < ScopeAPI.TC_PRIMEIRO_TIPO_COLETA) ||
                                (iRet > ScopeAPI.TC_MAX_TIPO_COLETA) )
                {
                    if (iRet == ScopeAPI.RCS_SUCESSO)
                    {
                        ExibeDadosTransacao ();
                        fn_PrintStr ("\n\nTEF finalizado com Sucesso !\n");
                    }
                    else
                    {
                        Work.Remove (0, Work.Length);

                        ObtemMsgOp2Erro (Work);

                        fn_PrintStr ( String.Format
                                ("\n\nErro ScopeStatus, iRet = 0x{0:X04} [{1}]\n",
                                            iRet, Work) );
                    }

                    break;
                }

                // Exibe status
                fn_PrintStr ( String.Format
                        ("\n\nScopeStatus, iRet = 0x{0:X04} ({0})\n", iRet) );

                // Inicializa variveis do fluxo
                acao = (int) ScopeAPI.eACAO_APL.PROXIMO_ESTADO;

                wCaptura = ScopeAPI._TECLADO;

                /* Obtem dados do Scope e exibe as mensagens
                    do cliente e operador */
                ScopeAPI.ScopeGetParam (iRet, ref PColeta);

                ExibeMsg (PColeta.ParamColeta);

                // Trata os estados
                switch (iRet)
                {
                    // imprime Cupom Parcial
                    case ScopeAPI.TC_IMPRIME_CUPOM_PARCIAL:
                    /* imprime Cupom + Nota Promissoria +
                        Cupom Promocional */
                    case ScopeAPI.TC_IMPRIME_CUPOM:
                    // imprime Consulta
                    case ScopeAPI.TC_IMPRIME_CONSULTA:
                        ExibeCupom ();

                        break;

                    // SCoPE aguardando o cartao que foi digitado
                    case ScopeAPI.TC_CARTAO_DIGITADO:
                        /* O texto digitado ja' esta' na var Work ... mas caso
                           nao esteja ... */
                        if ( (iRet == ScopeAPI.TC_CARTAO_DIGITADO) &&
                                                        (Work.Length < 13) )
                            goto default;

                            break;

                    /* apenas mostra informacao e deve
                        retornar ao scope */
                    case ScopeAPI.TC_INFO_RET_FLUXO:
                    // transacao em andamento
                    case ScopeAPI.TC_COLETA_EM_ANDAMENTO:
                        break;

                    /* recupera a lista de operadoras da
                       Recarga de Celular */
                    case ScopeAPI.TC_COLETA_OPERADORA:
                        acao = ExibeListaOperadoras ();

                        if (acao != ScopeAPI.RCS_SUCESSO)
                        {
                            fn_PrintStr ("\nerro ExibeListaOperadoras (): " + acao);

                            break;
                        }

                        fn_PrintStr ("\nCodigo da operadora ? ");
                        fn_GetInput (Work, 0); fn_PrintStr ("\n");

                        acao = ColetaAcao (PColeta);

                        break;

                    /* recupera a lista de valores da
                        Recarga de Celular */
                    case ScopeAPI.TC_COLETA_VALOR_RECARGA:
                        acao = ExibeListaValores ();

                        if (acao != ScopeAPI.RCS_SUCESSO)
                        {
                            fn_PrintStr ("\nErro ExibeListaValores (): " + acao);

                            break;
                        }

                        fn_PrintStr ("\nValor de recarga ? ");
                        fn_GetInput (Work, 0); fn_PrintStr ("\n");

                        acao = ColetaAcao (PColeta);

                        break;

                    /* mostra informacao e aguarda
                        confirmacao do usuario */
                    case ScopeAPI.TC_INFO_AGU_CONF_OP:
                        acao = ColetaAcao (PColeta);

                        break;

                    // deve coletar algo...
                    default:
                        fn_PrintStr ("\nColeta ? ");

                        fn_GetInput (Work, 0);

                        fn_PrintStr ("\n");

                        acao = ColetaAcao (PColeta);

                        break;
                }

                // retorna ao scope
                iRet = ScopeAPI.ScopeResumeParam (iRet,
                        Work, (short) wCaptura, (ScopeAPI.eACAO_APL) acao);

                if (iRet != ScopeAPI.RCS_SUCESSO)
                {
                    fn_PrintStr ( String.Format
                            ("\n\nScopeResumeParam, iRet = {0:X04} ({0})\n", iRet) );

                    ExibeMsgErro ();

                    // Se apenas dados invalido, retorna a coleta
                    if (iRet != ScopeAPI.RCS_DADO_INVALIDO)
                        break;
                }
            }

            return (iRet);
        }


        /** <summary>Recupera do sistema a atual mensagem de erro do SCoPE.</summary>
         *  <param name = '_MsgErro'>O buffer 'a ser preenchido com a mensagem.</param> */
        static
        void    ObtemMsgOp2Erro (StringBuilder _MsgErro)
        {
            int                     iRet;

            ScopeAPI.stCOLETA_MSG   LastMsg = new ScopeAPI.stCOLETA_MSG ();

            iRet = ScopeAPI.ScopeGetLastMsg (ref LastMsg);

            if (iRet == ScopeAPI.RCS_SUCESSO)
                _MsgErro.Append (LastMsg.Op2);
            else
                fn_PrintStr ( String.Format ("erro ObtemMsgOp2Erro: {0:X04}\n", iRet) );

            return;
        }


        /** <summary>Funcao responsavel pela exibicao das mensagens
         *  retornadas do SCoPE 'a serem exibidas pela aplicacao.</summary>
         * <param name = '_pColeta'>Estrutura comum para coleta dos dados.</param> */
        static
        void    ExibeMsg (ScopeAPI.stCOLETA_MSG _pColeta)
        {
            fn_PrintStr ("\nX########### TELA DO CLIENTE ############X");
            fn_PrintStr ("\nX" + centerText (_pColeta.Cl1, 40) + "X");
            fn_PrintStr ("\nX" + centerText (_pColeta.Cl2, 40) + "X");
            fn_PrintStr ("\nX########################################X\n");

            fn_PrintStr ("\n+--------- TECLADO DO OPERADOR-----------+");
            fn_PrintStr ("\n|" + centerText (_pColeta.Op1, 40) + "|");
            fn_PrintStr ("\n|" + centerText (_pColeta.Op2, 40) + "|");
            fn_PrintStr ("\n+----------------------------------------+\n");

            return;
        }


        /** <summary>Procedimento para centralizacao de texto numa string.</summary>
         * <param name = 'sTxt'>O texto 'a ser centralizado.</param>
         * <param name = 'iMax'>O tamanho da tela em caracteres.</param>
         * <returns>Uma string com o texto passado centralizado.</returns> */
        static
        String  centerText (String sTxt, int iMax)
        {
            StringBuilder   sAux    = new StringBuilder (iMax);

            // Preencher com brancos
            sAux.Append (' ', ( (iMax - sTxt.Length) / 2) );

            if ((sTxt != null) && (sTxt.Length > 0))
                sAux.Append (sTxt);

            sAux.Append (' ', iMax - sAux.Length);

            return ( sAux.ToString () );
        }


        /** <summary>Procedimento para exibicao das informacoes que compoem
         *  um cupom 'a ser impresso.</summary> */
        static
        void    ExibeCupom ()
        {
            int             iRet;

            byte            NroLnhReduzido  = 0;

            StringBuilder   Cabec           = new StringBuilder (1024),
                            CpCliente       = new StringBuilder (2048),
                            CpLoja          = new StringBuilder (2048),
                            CpReduzido      = new StringBuilder (2048);

            iRet = ScopeAPI.ScopeGetCupomEx ( (ushort) Cabec.Capacity, Cabec,
                                     (ushort) CpCliente.Capacity, CpCliente,
                                     (ushort) CpLoja.Capacity, CpLoja,
                                     (ushort) CpReduzido.Capacity, CpReduzido,
                                                    ref NroLnhReduzido );

            if (iRet != ScopeAPI.RCS_SUCESSO)
            {
                fn_PrintStr ( String.Format
                        ("\nScopeGetCupomEx retornou RC = [{0:X04}]", iRet) );

                return;
            }

            ExibeCupomMonitor ( "CABECALHO", Cabec.ToString () );

            ExibeCupomMonitor ( "CUPOM DO CLIENTE", CpCliente.ToString () );
            ExibeCupomMonitor ( "CUPOM DA LOJA", CpLoja.ToString () );

            if (NroLnhReduzido > 0)
                ExibeCupomMonitor ( "CUPOM REDUZIDO", CpReduzido.ToString () );

            fn_PrintStr ("\n\n\n\n");

            return;
        }


        /** <summary>Procedimento para exibicao/impressao do cupom fiscal.</summary>
         * <param name = '_Titulo'>O titulo 'a ser exibido.</param>
         * <param name = '_Cupom'>O corpo do cupom. Observe que este
         *              ponteiro sera' movido por uso
         *              interno da funcao, porem o conteudo
         *              do mesmo nao sera' alterado.</param> */
        static
        void    ExibeCupomMonitor (string _Titulo, string _Cupom)
        {
            int             NroLn   = 0,
                            Tam     = 0,
                            iPos    = 0,
                            iLstPos = 0;

            StringBuilder   Linha   = new StringBuilder (40/*Console.LargestWindowWidth*/ + 1);

            // Monta a identificacao do cupom
            Linha.Append (_Titulo);

            centerText (Linha.ToString (), 30/*Console.LargestWindowWidth*/);

            //      ....+....1....+....2....+....3....+....4
            fn_PrintStr ("*****************************************\n");
            fn_PrintStr ( Linha.ToString () );
            fn_PrintStr ("\n*****************************************\n");

            /* Exibe o cupom no monitor respeitando
                as limitacoes de exibicao */
            while (iPos < _Cupom.Length)
            {
                iPos = _Cupom.IndexOf ('\n', iLstPos);

                if (iPos == -1)
                    break;

                /*  Iremos saber a quantidade de colunas que
                    estao sendo utilizadas */
                Tam = (iPos - iLstPos) + 1;

                if (Tam > 40/*Console.LargestWindowWidth*/)
                    break;

                Linha.Remove (0, Linha.Length);
                Linha.Append ( _Cupom.Substring (iLstPos, Tam) );
                fn_PrintStr ( Linha.ToString () );

                if (++NroLn == 25)
                {
                    NroLn = 0;

                    fn_PrintStr ("\n[Pressione uma tecla para continuar...]");

                    fn_GetInput (null, 0);
                }

                /*  Avancando, procurando pelo
                    proximo '\n' */
                iLstPos = ++iPos;
            }

            fn_GetInput (null, 0);
        }


        /** <summary>Funcao utilizada para selecao da acao desejada
         * do usuario. Complementa a funcao FinalizaTransacaoTEF ().</summary>
         * <param name = '_pColeta'>Estrutura comum para coleta dos dados.</param>
         * <returns>ScopeAPI.eACAO_APL.PROXIMO_ESTADO: Prosseguir no
         *       proximo estagio do processo.</returns>
         * <returns>ScopeAPI.eACAO_APL.ESTADO_ANTERIOR: Retornar ao
         *     estagio anterior do processo.</returns>
         * <returns>ScopeAPI.eACAO_APL.CANCELAR: Cancelar o processo.</returns> */
        static
        int     ColetaAcao (ScopeAPI.stPARAM_COLETA _PColeta)
        {
            bool                bProximo    = false,
                                bRetorna    = false,
                                bCancela    = false;

            int                 iAcao;

            StringBuilder       strTecl     = new StringBuilder ();

            /* verifica qual teclas estao disponiveis para
                o usuario */
            bCancela = ( (_PColeta.HabTeclas & 0x01) != 0 );
            bProximo = ( (_PColeta.HabTeclas & 0x02) != 0 );
            bRetorna = ( (_PColeta.HabTeclas & 0x04) != 0 );

            fn_PrintStr ( String.Format ("{0} {1} {2}\n", bRetorna ? "[(R)etorna]" : "",
                                    bProximo ? "[(P)roximo]" : "",
                                    bCancela ? "[(C)ancela]" : "") );

            // verifica qual botao o usuario pressionou
            try
            {
                iAcao = ConsoleFunctions.getchar (true);
            }
            catch (Exception)
            {
                iAcao = 'P';
            }

            switch (iAcao)
            {
                case 'R':
                case 'r':
                    iAcao = (int) ScopeAPI.eACAO_APL.ESTADO_ANTERIOR;

                    break;

                case 'C':
                case 'c':
                    iAcao = (int) ScopeAPI.eACAO_APL.CANCELAR;

                    break;

                case 'P':
                case 'p':
                default:
                    iAcao = (int) ScopeAPI.eACAO_APL.PROXIMO_ESTADO;

                    break;
            }

            return (iAcao);
        }


        /** <summary>Procedimento para exibicao da mensagem de erro
         *  do SCoPE.</summary> */
        static
        void    ExibeMsgErro ()
        {
            int                     iRet;

            ScopeAPI.stCOLETA_MSG   LastMsg = new ScopeAPI.stCOLETA_MSG ();

            iRet = ScopeAPI.ScopeGetLastMsg (ref LastMsg);

            if (iRet == ScopeAPI.RCS_SUCESSO)
                ExibeMsg (LastMsg);
            else
                fn_PrintStr ( String.Format ("erro ScopeGetLastMsg: {0:X04}\n", iRet) );
        }


        /** <summary>Funcao utilizada para a definicao do fluxo do programa.</summary>
         * <param name = '_Opcao'>Seletor do fluxo do programa. Caso o seu valor
         *              esteja entre _OPCAO_INI_TEF e _OPCAO_FIN_TEF,
         *              sera' exibida a pergunta para continuacao da
         *              sessao TEF. Caso contrario, incondicionalmente
         *              sera' retornado FALSE, indicando o termino da
         *              sessao.</param>
         * <returns>true: O usuario confirmou a continuacao da sessao.</returns>
         * <returns>false: O usuario solicitou o termino da sessao.</returns> */
        static
        bool    ContinuaSessaoTEF (int _Opcao)
        {
            StringBuilder   Work    = new StringBuilder ();

            // Continua na Sessao TEF?
            if ( (_Opcao >= _OPCAO_INI_TEF) &&
                            (_Opcao <= _OPCAO_FIN_TEF) )
            {
                fn_PrintStr ("\n\n\nContinua na Sessao TEF (S/N) ? ");

                int iAux = ConsoleFunctions.getchar (true);

                if (iAux != -1)
                    if (/*Console.ReadKey ().KeyChar*/iAux.ToString ().ToLower ().CompareTo ("s") == 0)
                        return (true);
            }

            return (false);
        }


        /** <summary>Realiza o procedimento para termino de uma sessao TEF.
         *  Basicamente essa funcao desfara' todos os passos
         *  realizados na funcao AbreSessaoTEF().</summary>
         * <param name = '_NroTrnOk'>Contador de transacoes realizadas
         *              com sucesso (diretamente
         *              relacionada 'a funcao
         *              ExecutaFuncao () ).</param> */
        static
        void    FechaSessaoTEF (int _NroTrnOk)
        {
            int     iRet;

            byte    Acao    = ScopeAPI._CONFIRMA_TEF,
                    Filler  = 0;

            if (_NroTrnOk == 0)
                // Nao houve tefs aprovadas entao apenas fecha a sessao
                iRet = ScopeAPI.ScopeFechaSessaoTEF (ScopeAPI._DESFAZ_TEF, ref Filler);
            else
            {
                // Define operacao (confirma ou desfaz) ?
                fn_PrintStr
                        ("\n\n[C] = Confirmar TEF(s)\n[D] = Desfaz TEF(s)\n\nOpcao ? ");

                // Coleta acao
                iRet = ConsoleFunctions.getchar (true);//VS2k3
                if (iRet != -1)
                    Acao = (/*Console.ReadKey ().KeyChar*/iRet.ToString ().ToLower ().CompareTo ("d") == 0) ?
                                        ScopeAPI._DESFAZ_TEF : ScopeAPI._CONFIRMA_TEF;

                // Envia a confirmacao ou desfazimento
                iRet = ScopeAPI.ScopeFechaSessaoTEF (Acao, ref Filler);

                if (iRet == ScopeAPI.RCS_SUCESSO)
                    fn_PrintStr ( String.Format ("\n\nTEF(s) {0} com sucesso!",
                        (Acao == ScopeAPI._DESFAZ_TEF ? "desfeita(s)" : "confirmada(s)") ) );
                else
                    fn_PrintStr ( String.Format
                        ("\n\nErro ao {0} a(s) TEF(s)! Resultado da operacao (iRet: 0x{1:X04})",
                            (Acao == ScopeAPI._DESFAZ_TEF ? "desfazer" : "confirmar"), iRet) );
            }
        }


        /** <summary>Recupera a lista de operadores cadastradas no SCoPE.</summary>
         * <returns>Possiveis valores de erro da funcao
         *  ScopeAPI.ScopeRecuperaOperadorasRecCel ().</returns> */
        static
        int     ExibeListaOperadoras ()
        {
            int                     iRet;
            ScopeAPI.cl_operacCel   OperacaoCel =
                                        new ScopeAPI.cl_operacCel ();

            iRet = OperacaoCel.ScopeRecuperaOperadorasRecCel
                (ScopeAPI.eREC_CEL_OPERADORAS_MODELO.REC_CEL_OPERADORAS_MODELO_2);

            if (iRet != ScopeAPI.RCS_SUCESSO)
                return (iRet);

            fn_PrintStr ("\n\n LISTA DE OPERADORAS:\n\n");
            fn_PrintStr ("\nNumero de operadoras de celular = " +
                                                    OperacaoCel.ListaOper.NumOperCel);

            // Exibe as operadoras
            foreach (ScopeAPI.cl_operacCel.stREC_CEL_ID_OPERADORA
                                Oper in OperacaoCel.ListaOper.OperCel)
                fn_PrintStr ( String.Format
                    ("\nCodigo da operadora = {0}\tNome = {1}",
                                    //OperacaoCel.ListaOper.OperCel [iRet].CodOperCel,
                                    Oper.CodOperCel,
                                    //OperacaoCel.ListaOper.OperCel [iRet].NomeOperCel) );
                                    Oper.NomeOperCel) );

            fn_PrintStr ("\n\n");

            return (ScopeAPI.RCS_SUCESSO);
        }


        /** <summary>Procedimento para recuperacao dos valores disponiveis
         *  para a recarga de celular.</summary>
         * <returns>Possiveis valores de erro da funcao
         *  ScopeAPI.ScopeRecuperaValoresRecCel ().</returns> */
        static
        int     ExibeListaValores ()
        {
            int                     iRet =
                        ScopeAPI.ScopeObtemHandle (ScopeAPI.HDL_TRANSACAO_EM_ANDAMENTO);
            StringBuilder           aux = new StringBuilder (6);
            ScopeAPI.eREC_CEL_VALORES_MODELO
                                    tipoVal =
                        ScopeAPI.eREC_CEL_VALORES_MODELO.REC_CEL_VALORES_MODELO_2;
            ScopeAPI.cl_operacCel   OperacaoCel = new ScopeAPI.cl_operacCel ();

            ScopeAPI.ScopeObtemCampoExt (iRet, ScopeAPI.Cod_Rede,
                                                    0x00, '\0', aux);

            if (Convert.ToInt32 ( aux.ToString() ) == ScopeAPI.R_GWCEL)
                tipoVal = ScopeAPI.eREC_CEL_VALORES_MODELO.REC_CEL_VALORES_MODELO_3;

            // Recupera os valores
            iRet = OperacaoCel.ScopeRecuperaValoresRecCel (tipoVal);

            if (iRet != ScopeAPI.RCS_SUCESSO)
                return (iRet);

            // Exibe os valores
            fn_PrintStr ("\n\n LISTA DE VALORES:\n\n");
            fn_PrintStr ( "\nTipo do valor: " + (
                (OperacaoCel.ListaVal.TipoValor == 'V') ? "variavel" :
                (OperacaoCel.ListaVal.TipoValor == 'F') ? "fixo" : "fixo ou variavel") );
            fn_PrintStr ("\nValor minimo de recarga: " +
                                OperacaoCel.ListaVal.ValorMinimo);
            fn_PrintStr ("\nValor maximo de recarga: " +
                                OperacaoCel.ListaVal.ValorMaximo);
            fn_PrintStr ("\nValor total: " + OperacaoCel.ListaVal.Totvalor);

            foreach (ScopeAPI.cl_operacCel.stREC_CEL_VALOR
                         Val in OperacaoCel.ListaVal.TabValores)
                fn_PrintStr ("\n     Valor = " +
                    //OperacaoCel.ListaVal.TabValores [iRet].Valor +
                    Val.Valor +
                    "   Bonus = " +
                    //OperacaoCel.ListaVal.TabValores [iRet].Bonus +
                    Val.Valor +
                    "   Custo = " +
                    //OperacaoCel.ListaVal.TabValores [iRet].Custo);
                    Val.Custo);

            fn_PrintStr ("\nMensagem promocional: " +
                    OperacaoCel.ListaVal.MsgPromocional + " \n\n");

            if ( (tipoVal ==
                ScopeAPI.eREC_CEL_VALORES_MODELO.REC_CEL_VALORES_MODELO_3) &&
                (OperacaoCel.ListaVal.TotFaixaValores > 0) )
            {
                fn_PrintStr ("\n\n FAIXA DE VALORES:\n\n");

                foreach (ScopeAPI.cl_operacCel.stREC_CEL_FAIXA_VALORES
                            Val in OperacaoCel.ListaVal.TabFaixaValores)
                    fn_PrintStr ("\n     ValorMin = " + Val.ValorMin +
                                "     ValorMax = " + Val.ValorMax);
            }

            return (ScopeAPI.RCS_SUCESSO);
        }


        /** <summary>Realiza o procedimento para uso do PINPad.</summary>
         * <returns>false: Falha na abertura do recurso.</returns>
         * <returns>true: Sucesso.</returns> */
        static
        bool    AbrePINPad ()
        {
            byte                    bConfig     = 0,
                                    bExclusivo  = 0,
                                    bPorta      = 0;

            int                     iRet;

            String                  strCompl;

            ScopeAPI.cl_infosPP     infosPP     = new itautec.scope.ScopeAPI.cl_infosPP ();

            /* Consulta como esta' configurado o PIN-Pad
                compartilhado no ScopeCNF */
            iRet = ScopeAPI.ScopeConsultaPP
                        (ref bConfig, ref bExclusivo, ref bPorta);

            if (iRet != ScopeAPI.PC_OK)
            {
                fn_PrintStr ("\nErro na ScopeConsultaPP: " + iRet + "\n");

                fn_GetInput (null, 0);

                return (false);
            }

            // O PPad deve estar configurado e nao pode ser exclusivo do SCoPE
            if ( (bConfig != 1) || (bExclusivo != 0) )
                return (true);

            // Abre conexao com PINPad
            fn_PrintStr ("\nConectando ao PINPad...\n");

            iRet = ScopeAPI.ScopePPOpen (bPorta);

            if (iRet != ScopeAPI.PC_OK)
            {
                fn_PrintStr ("\nErro ao abrir o PIN-Pad: " + iRet + "\n");

                fn_GetInput (null, 0);

                return (false);
            }

            // Conseguimos inicializar o PPad
            iInic |= CNT_PPAD;

            // Solicitar todas as opcoes disponiveis da funcao ScopePPGetInfo ()
            for (bExclusivo = 0; bExclusivo < 4; bExclusivo++)
            {
                iRet = infosPP.ScopePPGetInfo ( (ushort) bExclusivo );

                if (iRet != ScopeAPI.RCS_SUCESSO)
                    break;

                if (bExclusivo == 0)
                    fn_PrintStr
                        ("PinPAD: " + new String (infosPP.ppGenInfos.strPPFabr).Trim () +
                            " " + new String (infosPP.ppGenInfos.strPPModel).Trim () + "\n\n");
                else
                {
                    fn_PrintStr ("Rede suportada: " +
                        new String (infosPP.ppRedeInfos.strRedeNome).Trim () );

                    strCompl = new String (infosPP.ppRedeInfos.strRedeInfos).Trim ();

                    if (strCompl.Length > 0)
                        fn_PrintStr ("\n\t" + strCompl + "\n");
                    else
                        fn_PrintStr ("\n");
                }
            }

            //1234567890123456
            ScopeAPI.ScopePPDisplayEx ("042   Aplicacao\x0D  demonstracao\x0D  da SCoPE API");

            return (true);
        }


        /** <summary>Procedimento para finalizacao da comunicacao
         *  com o PINPad.</summary> */
        static
        void    FechaPINPad ()
        {
            if ( (iInic & CNT_PPAD) != 0 )
                ScopeAPI.ScopePPClose ("Bye");

            return;
        }
    }
}
