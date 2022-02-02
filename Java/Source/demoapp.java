/**
    Classe de demonstracao Scope Coleta para Java

    javac -classpath .;..\jar\scopejava.jar demoapp.java
    java -Djava.library.path=C:\SCOPE\225 -cp .;..\jar\scopejava.jar demoapp
 */

import java.io.*;
import java.text.*;
import com.itautec.scope.*;

/** classe principal do arquivo */

public class demoapp
{
    /** Opcoes do menu */
    static final
    int             MNU_SAIR            = 0,
                    MNU_CREDIT          = 1,
                    MNU_DEBITO          = 2,
                    MNU_CONSCHEQ        = 3,
                    MNU_CDC             = 4,
                    MNU_CANCELA         = 5,
                    MNU_RESVENDAS       = 6,
                    MNU_REIMPCOMP       = 7,
                    MNU_CONSCDC         = 8,
                    MNU_PREAUTCRED      = 9,
                    MNU_VERSAO          = 10,
                    MNU_PAGTOCART       = 11,
                    MNU_PAGTOSCOPE      = 12,
                    MNU_PAGTOFATURA     = 13,
                    MNU_RECARGCEL       = 14,
                    // PINPad
                    MNU_PPOPEN          = 15,
                    MNU_PPCLOSE         = 16,
                    MNU_PPABORT         = 17,
                    MNU_PPGETINFO       = 18,
                    MNU_PPDISP          = 19,
                    MNU_PPDISPEX        = 20,
                    MNU_PPGETKEY        = 21,
                    MNU_PPGETPIN        = 22,
                    MNU_PPGETCARD       = 23,
                    MNU_PPCONFIG        = 24;


    String          Modo,
                    Empresa,
                    Filial,
                    Pdv;

    DecimalFormat   decfmt;

    Scope           clScope;

    StParamColeta   stColeta;

    StCupomEx       stCupom;

    stSessaoTef     stSessao;

    stDados         stDados;

    StRecCel        recCel;

    StConsultaPP    cPP;

   /**
      Construtor da classe.
    */

    demoapp ()
    {
        clScope = new Scope ();
        stColeta = new StParamColeta ();
        stCupom = new StCupomEx ();
        stSessao = new stSessaoTef ();
        stDados = new stDados ();
        cPP = new StConsultaPP ();
        recCel = new StRecCel (clScope);
    }


   /**
      An alias to the System.out.println method.

      @param    txtOut  The string to be printed.
    */

   public static
   void printf_ (String txtOut)
   {
        System.out.println (txtOut);

        return;
   }


   /**
      Reads a string from the console. The string is
      terminated by a newline.

      @param    iLen    The maximum string length.

      @return           The input string (without
                        the newline).
    */

   public static
   String readLine (int iLen)
   {
        int     ch;

        String  r       = "";

        boolean done    = false;

        while (done == false)
        {
            try
            {
                ch = System.in.read ();

                if (ch < 0 || (char) ch == '\n')
                    done = true;
                // weird--it used to do \r\n translation
                else if ( (char) ch != '\r')
                    r = r + (char) ch;
            }

            catch (java.io.IOException e)
            {
                done = true;
            }

            if (done == true)
                break;
        }

        if ( iLen == 0 || (r.length () < iLen) )
            iLen = r.length ();

        return ( r.substring (0, iLen) );
   }


    /**
        Executa o processo da aplicacao de PDV.

        @param   args    os codigos da empresa,
                         filial e PDV digitada.
                         ao executar o programa.
     */

    public
    void executar (String [] args)
    {
        char            cAcao;

        byte            ttab        = StRecCel.REC_CEL_OPERADORAS_MODELO_2;

        int             wCaptura    = Scope.SCO_TECLADO,
                        RC          = 0,
                        option      = 0;

        boolean         bProximo    = false,
                        bRetorna    = false,
                        bCancela    = false;

        String          szWork,
                        szTmp,
                        aux         = "";

        StringBuffer    sbAux       = new StringBuffer (5);

        Buffer          auxb,
                        notifyb;

        Modo    = "2";


        // Se faltou algum parametro, vamos captura-lo agora
        if (args.length < 3)
        {
            if (args.length == 0)
            {
                printf_ ("Digite o codigo da empresa [NNNN]: ");
                Empresa = readLine (4);
            }

            if (args.length < 2)
            {
                printf_ ("Digite o codigo da filial: [NNNN]");
                Filial  = readLine (4);
            }

            if (args.length < 3)
            {
                printf_ ("Digite o codigo da PDV: [NNN]");
                Pdv     = readLine (3);
            }
        }

        /* Atribuir o que foi passado na linha de comando
           'as variaveis */
        if (Empresa == null)
            Empresa = args [0];

        if (Filial == null)
            Filial = args [1];

        if (Pdv == null)
            Pdv = args [2];

        // Validar a digitacao
        for (cAcao = 0; cAcao < 3; cAcao++)
        {
            RC = sbAux.length ();

            if (RC > 0)
                sbAux.delete (0, RC);

            RC = 4;

            if (cAcao == 0)         // Empresa
                szTmp = Empresa;
            else if (cAcao == 1)    // Filial
                szTmp = Filial;
            else                    // Pdv
            {
                szTmp = Pdv;
                RC = 3;
            }

            if ( (szTmp == null) ||
                    (szTmp.length () == 0) )
                szTmp = "0001";

            /* Se encontrarmos caracteres que nao sejam
               digitos */
            if ( szTmp.matches ("\\D") )
                /* Iremos descartar o que foi digitado
                   e usaremos o valor padrao */
                szTmp = (RC != 2) ? "0001" : "001";
            /* Se o tamanho for diferente do esperado
               (ele e' menor do que o esperado) */
            else if (szTmp.length () != RC)
            {
                /* Iremos preencher as posicoes faltantes
                   com o caracter '0' */
                for (option = RC - szTmp.length ();
                     option != 0; option--)
                    sbAux.append ('0');

                /* E incluir o que foi digitado */
                sbAux.append (szTmp);

                // Convertamos o StringBuffer para String
                szTmp = sbAux.toString ();
            }

            if (cAcao == 0)
                Empresa = szTmp;
            else if (cAcao == 1)
                Filial = szTmp;
            else
                Pdv = szTmp;
        }

        printf_ ("Modo = " + Modo);
        printf_ ("Empresa = " + Empresa);
        printf_ ("Filial = " + Filial);
        printf_ ("Pdv = " + Pdv + "\n");

        // Instanciando as classes
        auxb = new Buffer ();
        notifyb = new Buffer ();

        try
        {
            // faz a conexao com o servidor
            RC = clScope.open (Modo, Empresa, Filial, Pdv);

            // erro ao abrir conexao
            if (RC != Scope.RCS_SUCESSO)
            {
                printf_ ("ScopeOpen, RC = " +
                        Integer.toHexString (RC) +
                        ", (" + RC + ")");

                printf_ ("\n\n\nFim !\n");

                return;
            }

            // informa que esta aplicacao deseja coletar os dados
            clScope.setAplColeta();

            // Configura o fluxo de coleta dos dados
            clScope.configura
                (Scope.CFG_CANCELAR_OPERACAO_PINPAD, Scope.OP_HABILITA);

            // Faz uso do recurso PINPad compartilhado
            AbrePINPad ();

            /* Tratamento de queda de energia. Verifica se a ultima
               transacao esta pendente e caso sim, envia o
               desfazimento */
            stSessao.desfaz ();

            RC = clScope.fechaSessaoTEF (stSessao);

            if ( (RC == clScope.RCS_SUCESSO) &&
                stSessao.desfezTefAposQuedaEnergia () )
                printf_ ("\nA ULTIMA TRANSACAO TEF FOI DESFEITA." +
                        " RETER CUPOM TEF.");

            // pergunta qual a opcao ao usuario
            while (true)
            {
                printf_ (MNU_CREDIT + ": Compra com Cartao de Credito\t|  " +
                        MNU_CONSCDC + ": Consulta CDC");
                printf_ (MNU_DEBITO + ": Compra c/ Cartao de Debito\t|  " +
                        MNU_PREAUTCRED + ": Pre-Autorizacao Credito");
                printf_ (MNU_CONSCHEQ + ": Consulta de Cheque\t\t| " +
                        MNU_VERSAO + ": Versao do Scope");
                printf_ (MNU_CDC + ": CDC\t\t\t\t| " +
                        MNU_PAGTOCART + ": Pagamento de Conta c/ Cartao");
                printf_ (MNU_CANCELA + ": Cancelamento\t\t\t| " +
                        MNU_PAGTOSCOPE + ": Pagamento de Conta SCoPE/ Cartao");
                printf_ (MNU_RESVENDAS + ": Resumo de Vendas\t\t| " +
                        MNU_PAGTOFATURA + ": Pagamento de Fatura");
                printf_ (MNU_REIMPCOMP + ": Reimpressao de Comprovante\t| " +
                        MNU_RECARGCEL + ": Recarga de Celular\n");
                printf_ (MNU_PPOPEN + ": ScopePPOpen\t\t\t| " +
                        MNU_PPDISPEX + ": ScopePPDisplayEx");
                printf_ (MNU_PPCLOSE + ": ScopePPClose\t\t| " +
                        MNU_PPGETKEY + ": ScopePPGetKey");
                printf_ (MNU_PPABORT + ": ScopePPAbort\t\t| " +
                        MNU_PPGETPIN + ": ScopePPGetPIN");
                printf_ (MNU_PPGETINFO + ": ScopePPGetInfo\t\t| " +
                        MNU_PPGETCARD + ": ScopePPGetCard");
                printf_ (MNU_PPDISP + ": ScopePPDisplay\t\t| " +
                        MNU_PPCONFIG + ": Configuracao PIN-Pad");
                printf_ (MNU_SAIR + ": S A I R\n");

                printf_ ("Opcao ? ");

                aux = readLine (2);

                option = iVal (aux);

                if (option == MNU_SAIR)
                    break;

                /* Abre a stSessao multitef. Exemplo
                   contendo apenas 1 transacao */
                RC = clScope.abreSessaoTEF ();

                if (RC != Scope.RCS_SUCESSO)
                {
                    printf_ ("\ns.abreSessaoTEF, RC = " +
                                Integer.toHexString (RC) +
                                ", (" + RC + ")");

                    break;
                }

                // chama a funcao escolhida
                aux = "";

                switch (option)
                {
                    // credito
                    case MNU_CREDIT:
                        printf_ ("\nValor ? "); aux = readLine (0);

                        clScope.compraCartaoCredito (aux, "");

                        break;

                    // debito
                    case MNU_DEBITO:
                        printf_ ("\nValor ? "); aux = readLine (0);

                        clScope.compraCartaoDebito (aux);

                        break;

                    // consulta cheque
                    case MNU_CONSCHEQ:
                        printf_ ("\nValor ? "); aux = readLine (0);

                        clScope.consultaCheque (aux);

                        break;

                    // compra CDC
                    case MNU_CDC:
                        printf_ ("\nValor ? "); aux = readLine (0);

                        clScope.compraCDC (aux);

                        break;

                    // cancelamento
                    case MNU_CANCELA:
                        printf_ ("\nValor ? "); aux = readLine(6);

                        clScope.cancelamento (aux, "");

                        break;

                    // resumo de vendas
                    case MNU_RESVENDAS:
                        clScope.resumoVendas ();

                        break;

                    // reimpressao de comprovante
                    case MNU_REIMPCOMP:
                        clScope.reimpressaoComprovante ();

                        break;

                    // consulta CDC
                    case MNU_CONSCDC:
                        printf_ ("\nValor ? "); aux = readLine (0);

                        clScope.consultaCDC (aux, "");

                        break;

                    // Pre-Autorizacao de Credito
                    case MNU_PREAUTCRED:
                        printf_ ("\nValor ? "); aux = readLine (0);

                        clScope.preAutorizacaoCredito (aux, "");

                        break;

                    // versao do scope
                    case MNU_VERSAO:
                        clScope.versao (auxb);

                        printf_ ("Versao do Scope = " + auxb.buffer);

                        continue;

                    // Pagamento de conta c/ cartao
                    case MNU_PAGTOCART:
                        clScope.pagamento (85, 0);

                        break;

                    // Pagamento de conta Scope/cartao
                    case MNU_PAGTOSCOPE:
                        clScope.pagamento (87, 0);

                        break;

                    // Pagamento de fatura
                    case MNU_PAGTOFATURA:
                        clScope.pagamento (91, 0);

                        break;

                    // Recarga de Celular
                    case MNU_RECARGCEL:
                        clScope.recargaCelular ();

                        break;

                    // inicio comunicacao com o o PPad
                    case MNU_PPOPEN:
                        printf_ ("\nSerial ? "); aux = readLine (2);

                        RC = clScope.ppOpen ( (byte) iVal (aux) );

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // finaliza a comunicacao c/ o PPad
                    case MNU_PPCLOSE:
                        RC = clScope.ppClose
                                ("    ITAUTEC          SCOPE      ");

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // cancela a operacao pendente/em execucao do PPad
                    case MNU_PPABORT:
                        RC = clScope.ppAbort ();

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // informacoes armazenadas no PPad
                    case MNU_PPGETINFO:
                        RC = clScope.ppGetInfo (0, auxb);

                        if (RC == Scope.PC_OK)
                            printf_ ("INFO = [" + auxb.buffer + "]");

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // exibicao de texto no display do PPad
                    case MNU_PPDISP:
                        RC = clScope.ppDisplay ("Teste display");

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // exibicao de texto estendida
                    case MNU_PPDISPEX:
                        RC = clScope.ppDisplayEx ("Teste displayEx");

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // uso do PPad p/ obtencao de teclas
                    case MNU_PPGETKEY:
                        RC = clScope.ppStartGetKey ();

                        if (RC != Scope.PC_OK)
                        {
                            exibeRetornoPP (clScope, RC);

                            continue;
                        }

                        printf_ ("PRESSIONE UMA TECLA NO PINPAD");

                        do
                        {
                            RC = clScope.ppGetKey ();
                        }
                        // Processando ...
                        while (RC == Scope.PC_PROCESSING);

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // recebimento de senha (PIN) pelo PPad
                    case MNU_PPGETPIN:
                        RC = clScope.ppStartGetPIN ("DIGITE A SENHA");

                        if (RC != Scope.PC_OK)
                        {
                            exibeRetornoPP (clScope, RC);

                            continue;
                        }

                        printf_ ("DIGITE A SENHA");

                        do
                        {
                            RC = clScope.ppGetPIN (auxb);
                        }
                        while (RC == Scope.PC_PROCESSING);
                        // Processando...

                        if (RC == Scope.PC_OK)
                            printf_ ("PIN = [" + auxb.buffer + "]");

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // leitura de cartao magnetico via PPad
                    case MNU_PPGETCARD:
                        RC = clScope.ppStartGetCard (0, "000");

                        if (RC != Scope.PC_OK)
                        {
                            exibeRetornoPP (clScope, RC);

                            continue;
                        }

                        printf_ ("INSIRA OU PASSE O CARTAO");

                        do
                        {
                            RC = clScope.ppGetCard (0, notifyb, auxb);

                            if (RC == Scope.PC_NOTIFY)
                                // Pinpad notificou operador
                                printf_ ("MSG. PIN-PAD = [" +
                                                notifyb.buffer + "]");
                        }
                        // Notificou ou esta processando...
                        while (RC == Scope.PC_PROCESSING || RC == Scope.PC_NOTIFY);

                        if (RC == Scope.PC_OK)
                            printf_ ("CARD = [" + auxb.buffer + "]");

                        exibeRetornoPP (clScope, RC);

                        continue;

                    // Consulta configuracao do PIN-Pad
                    case MNU_PPCONFIG:
                        exibeConsultaPP ();

                        continue;

                    default:
                        printf_ ("Opcao Invalida !");

                        continue;
                }

                // enquanto a transacao estiver em andamento, aguarda
                while (true)
                {
                    while ( (RC = clScope.status () ) ==
                                        Scope.RCS_TRN_EM_ANDAMENTO )
                        Thread.sleep (500);

                    printf_ ("\nScopeStatus, RC = " +
                                Integer.toHexString (RC) +
                                                ", (" + RC + ")");

                    szWork = "";

                    szTmp = "";

                    cAcao = Scope.PROXIMO_ESTADO;

                    /* se estiver entre FC00 e FCFF,
                       deve tomar alguma atitude */
                    if ( (RC >= Scope.TC_PRIMEIRO_TIPO_COLETA) &&
                                (RC <= Scope.RCS_ULTIMO_COLETA_DADOS) )
                    {
                        clScope.getParam (RC, stColeta);

                        exibeMsgs (stColeta.MsgCl1, stColeta.MsgCl2,
                                    stColeta.MsgOp1, stColeta.MsgOp2);

                        switch (RC)
                        {
                            // Imprime Cheque
                            case Scope.TC_IMPRIME_CHEQUE:
                                StParamCheque   spc = new StParamCheque ();

                                clScope.getCheque (spc);

                                printf_ ("\n\nCheque\n");

                                printf_ ("Banco = " + spc.Banco);
                                printf_ ("Agencia =  " + spc.Agencia);
                                printf_ ("Numero do cheque =  " + spc.NumCheque);
                                printf_ ("Valor =  " + spc.Valor);
                                printf_ ("Bom Para =  " + spc.BomPara);
                                printf_ ("Codigo da autorizadora =  " + spc.CodAut);
                                printf_ ("Municipio =  " + spc.Municipio);

                                break;

                            case Scope.TC_IMPRIME_CUPOM: // Imprime Cupom
                            case Scope.TC_IMPRIME_CONSULTA: // Imprime Consulta
                                clScope.getCupomEx (stCupom);

                                printf_ ("CABECALHO ----------------------------- \n" +
                                                                            stCupom.cabec);
                                printf_ ("CUPOM CLIENTE ------------------------- \n" +
                                                                            stCupom.cpCliente);
                                printf_ ("CUPOM LOJA ---------------------------- \n" +
                                                                            stCupom.cpLoja);

                                if (stCupom.nroLnReduzido > 0)
                                    printf_ ("CUPOM REDUZIDO ------------------------ \n" +
                                                                            stCupom.cpReduzido);

                                break;

                            // Recupera e exibe as operadoras da Recarga Celular
                            case Scope.TC_COLETA_OPERADORA:
                                ttab = StRecCel.REC_CEL_OPERADORAS_MODELO_2;

                                printf_ ("\n\nRecupera/exibe operadoras da Recarga Celular\n");

                                StRecCel.stREC_CEL_OPERADORAS operCel =
                                            recCel.recuperaOperadorasRecCel (ttab);

                                if (operCel.OperCel == null)
                                {
                                    printf_ ("\nErro da funcao recuperaOperadorasRecCel: " +
                                        Integer.toHexString (operCel.NumOperCel) + "\n");

                                    break;
                                }

                                // listagem das operadoras
                                for (option = 0; option < operCel.NumOperCel; option++)
                                    printf_ ("Codigo da operadora: " + operCel.OperCel [option].CodOperCel +
                                            "\tNome da operadora: " + operCel.OperCel [option].NomeOperCel);

                                printf_ ("\nOperadora = ? "); szWork = readLine (5);

                                break;

                            // Recupera e exibe os valores da Recarga Celular
                            case Scope.TC_COLETA_VALOR_RECARGA:
                                ttab = StRecCel.REC_CEL_VALORES_MODELO_2;

                                printf_ ("\nRecupera/exibe valores da Recarga Celular\n");

                                option = clScope.obtemHandle (Scope.HDL_TRANSACAO_EM_ANDAMENTO);

                                if (option > 0xFFFF)
                                {
                                    clScope.obtemCampoEx (option, Scope.Cod_Rede, 0, 0, auxb);

                                    if (Integer.parseInt (auxb.buffer) == Scope.R_GWCEL)
                                        ttab = StRecCel.REC_CEL_VALORES_MODELO_3;
                                }

                                StRecCel.stREC_CEL_VALORES valCel =
                                            recCel.recuperaValoresRecCel (ttab);

                                if (valCel.TabValores == null)
                                {
                                    printf_ ("\nErro da funcao recuperaValoresRecCel: " +
                                        Integer.toHexString (valCel.Totvalor) + "\n");

                                    break;
                                }

                                // listagem dos valores
                                printf_ ("\nLISTA DE VALORES:\n");

                                Modo = ( (valCel.TipoValor == 'V') ? "variavel" :
                                                                (valCel.TipoValor == 'F') ? "fixo" :
                                                                "fixo ou variavel" );

                                printf_ ("Tipo do valor: " + Modo);

                                printf_ ("Valor minimo de recarga: [" + valCel.ValorMinimo + "]");
                                printf_ ("Valor maximo de recarga: [" + valCel.ValorMaximo + "]");
                                printf_ ("Valor total: [" + valCel.Totvalor + "]");

                                for (option = 0; option < valCel.Totvalor; option++)
                                    printf_ ("     Valor = [" + valCel.TabValores [option].Valor  + "]" +
                                             "   Bonus = [" + valCel.TabValores [option].Bonus  + "]" +
                                             "   Custo = [" + valCel.TabValores [option].Custo + "]");

                                printf_ ("Mensagem promocional: [" +
                                                    valCel.MsgPromocional + "]\n");

                                if (ttab == StRecCel.REC_CEL_VALORES_MODELO_3)
                                {
                                    printf_ ("Quantidade de faixa de valores: [" +
                                                            valCel.TotFaixaValores + "]\n");

                                    for (option = 0; option < valCel.TotFaixaValores; option++)
                                        printf_ ("     Valor Minimo = [" + valCel.TabFaixaValores [option].ValorMin  + "]" +
                                                 "   Valor Maximo= [" + valCel.TabFaixaValores [option].ValorMax + "]");
                                }

                                printf_ ("Valor = ? "); szWork = readLine (6);

                                break;

                            case Scope.TC_COLETA_NUM_TELEFONE:
                                /* Esse tratamento e' exclusivo p/ a
                                captura do numero do telefone usando
                                o PPad. */

                                option = Scope.PC_CANCEL;

                                /* Premissas:
                                1) Ele precisa estar configurado;
                                2) E nao pode estar como
                                   'Uso Exclusivo do Scope' */
                                if ( (cPP.configurado != 0) &&
                                    (cPP.usoExclusivoScope == 0) )
                                {
                                    bProximo = false;

                                    do
                                    {
                                        option = GetPIN_PINPad
                                                    ("Digite o telefone:", notifyb);

                                        if (option != Scope.PC_OK)
                                            break;

                                        do
                                        {
                                            szWork = notifyb.buffer.toString ();

                                            clScope.ppDisplay
                                                ("Confirme a digitacao: " + szWork);

                                            option = GetKey_PINPad ();
                                        } while ( (option != Scope.PC_OK) &&
                                                (option != Scope.PC_CANCEL) );

                                        if (option == Scope.PC_OK)
                                        {
                                            cAcao = 'P';
                                            bProximo = true;
                                        }
                                    } while (! bProximo);
                                }

                            default: // deve coletar algo...
                                // apenas mostra informacao e deve retornar ao scope
                                if ( (RC == Scope.TC_INFO_RET_FLUXO) ||
                                    (RC == Scope.TC_COLETA_CARTAO_EM_ANDAMENTO) ||
                                    (RC == Scope.TC_COLETA_EM_ANDAMENTO) )
                                    break;

                                if ( ( (RC == Scope.TC_COLETA_NUM_TELEFONE) &&
                                    (option != Scope.PC_OK) ) ||
                                    (RC != Scope.TC_COLETA_NUM_TELEFONE) )
                                {
                                    // Na coleta de senha, trata criptografia
                                    if (RC == Scope.TC_SENHA)
                                    {
                                        // Verificar se obtem senha com criptografia ou nao
                                        if ( (stColeta.PosMasterKey >= 0) &&
                                                        (stColeta.PosMasterKey <= 9) )
                                            printf_ ("Obtem senha com criptografia! MasterK: <" +
                                                            stColeta.PosMasterKey + ">  Wkey: <" +
                                                                            stColeta.WrkKey + ">");
                                        else
                                            printf_ ("Obtem senha sem criptografia!");
                                    }
                                    else if (RC == Scope.TC_CARTAO)
                                        wCaptura = ( (szWork.indexOf ('=') != -1) ||
                                                            (szWork.indexOf ('D') != -1) ) ?
                                                    Scope.SCO_CARTAO_MAGNETICO : Scope.SCO_TECLADO;

                                    // mostra informacao e aguarda confirmacao do usuario
                                    if (RC != Scope.RCS_MOSTRA_INFO_AGUARDA_CONF)
                                    {
                                        printf_ ("\nColeta = ? ");
                                        szWork = readLine (0);
                                    }
                                    else
                                        szWork = "";

                                    // habilita as teclas correspondentes
                                    bCancela = ( (stColeta.HabTeclas & 0x01) != 0 );
                                    bProximo = ( (stColeta.HabTeclas & 0x02) != 0 );
                                    bRetorna = ( (stColeta.HabTeclas & 0x04) != 0 );

                                    printf_ ( (bRetorna ? "[(R)etorna]" : "") +
                                                (bProximo ? "[(P)roximo]" : "") +
                                                (bCancela ? "[(C)ancela]" : "") );

                                    szTmp = readLine (1).toUpperCase ();

                                    if (szTmp.length () > 0)
                                        cAcao = szTmp.charAt (0);
                                    else
                                        cAcao = 'P';

                                    // verifica qual botao o usuario pressionou
                                    switch (cAcao)
                                    {
                                        default:
                                        case 'P':
                                            cAcao = Scope.PROXIMO_ESTADO;

                                            break;

                                        case 'R':
                                            cAcao = Scope.ESTADO_ANTERIOR;

                                            break;

                                        case 'C':
                                            cAcao = Scope.CANCELAR;

                                            break;
                                    }
                                }

                                break;
                        }

                        // Retorna ao scope, informa o dado coletado
                        stDados.Work = szWork;

                        RC = clScope.resumeParam (RC, stDados, wCaptura, cAcao);

                        if (RC != Scope.RCS_SUCESSO)
                        {
                            StColetaMsg     smsg = new StColetaMsg ();

                            printf_ ("ScopeResumeParam, RC = " +
                                        Integer.toHexString (RC) + ", (" + RC + ")");

                            clScope.getLastMsg (smsg);

                            exibeMsgs (smsg.Cl1, smsg.Cl2,
                                            smsg.Op1, smsg.Op2);

                            // verifica se dado invalido
                            if (RC != Scope.RCS_DADO_INVALIDO)
                                break;      // finaliza a coleta
                        }

                        continue;
                    }
                    else
                    {
                        // fim
                        if (RC == Scope.RCS_SUCESSO)
                        {
                            printf_ ("\n\nConfirma a transacao (S/N) ?");

                            szWork = readLine (1);

                            if ( szWork.equalsIgnoreCase ("S") )
                                stSessao.confirma ();
                            else
                                stSessao.desfaz ();

                            RC = clScope.fechaSessaoTEF (stSessao);

                            if (RC != 0)
                                printf_ ("\ns.fechaSessaoTEF, RC = " +
                                            Integer.toHexString (RC) +
                                                    ", (" + RC + ")");

                            printf_ ("\n\nFinalizado com Sucesso !\n");
                        }
                        else
                            printf_ ("\n\nErro ScopeStatus, RC = " +
                                            Integer.toHexString (RC) +
                                            ", (" + RC + ")");

                        break;
                    }
                }

                // nova operacao?
                printf_ ("\n\n\nNovamente (S/N) ? "); szWork = readLine (1);

                if ( ! szWork.equalsIgnoreCase ("S") )
                    break;
            }
        }

        catch (Exception e)
        {
            e.printStackTrace ();
        }

        try
        {
            // encerra conexao com o servidor
            clScope.close();
        }
        catch (Exception e)
        {
            e.printStackTrace ();
        }

        return;
    }


    /**
        Converte uma string em int.

        @param  v   String contendo o numero 'a ser convertido.

        @return     O numero em tipo inteiro (int).
     */

    public
    int iVal (String v)
    {
        int r;

        if (v == null)
            return 0;

        if (decfmt == null)
            decfmt = new DecimalFormat ();

        try
        {
            r = decfmt.parse (v).intValue ();
        }
        catch (ParseException e)
        {
            r = 0;
        }

        return (r);
    }


    /**
        Copia uma string para um array de caracteres.

        @param  destino     Array que recebera a String.
        @param  Origem      String a ser convertida para array.
        @param  tamOrigem   Tamanho da string.
     */

    public
    void CopyStringToArray (char [] destino, String Origem,
                        int tamOrigem) throws java.io.IOException
    {
        int     i;
        char    tmpOrigem []    = Origem.toCharArray ();

        // Copia o buffer
        for (i = 0; i < tamOrigem; i++)
            destino [i] = tmpOrigem [i];

        destino [i] = '#';  // insere o caracter NULO

        return;
    }


    /**
        Procedimento auxiliar para exibicao do retorno
        das funcoes de acesso ao PPad.

        @param  clScope Objeto Scope instanciado.
        @param  rc      O retorno da funcao de acesso ao PPad.

        @throw  java.io.IOException
     */

    public
    void exibeRetornoPP (Scope clScope, int rc)
                            throws java.io.IOException
    {
        Buffer msgErro = new Buffer ();

        // Para as funcoes de PIN-Pad, nao segue o fluxo
        if (rc == Scope.PC_OK)
            printf_ ("RC = " + rc + "  [SUCESSO]");
        else
        {
            clScope.ppMsgErro (rc, msgErro);

            printf_ ("RC = " + rc + "  [" + msgErro.buffer + "]");
        }

        printf_ ("\nPressione uma tecla para continuar...");

        readLine (1);

        return;
    }


    /**
        Procedimento auxiliar para exibicao das informacoes
        disponibilizadas pela funcao consultaPP ().

        @param  cPP Estrutura StConsultaPP ja' preenchida.
        @param  rc  O retorno da funcao consultaPP ().

        @retun  Uma instancia da classe StConsultaPP com
                os membros preenchidos.

        @throw  java.io.IOException
     */

    public
    StConsultaPP exibeConsultaPP () throws java.io.IOException
    {
        int             rc      = clScope.consultaPP (cPP);

        if (rc == Scope.PC_OK)
            printf_ ("\nRC = [SUCESSO]." +
            "\nConfigurado = [" + ( (cPP.configurado != 0) ?
                                        "S" : "N" ) + "]" +
            "\nPorta = [" + cPP.porta + "]" +
            "\nUso exclusivo do SCoPE? = [" +
                ( (cPP.usoExclusivoScope != 0) ? "S" : "N" ) + "]");
        else
            printf_ ("\nERRO. RC = " + rc);

        pressioneTecla ();

        return (cPP);
    }


    /**
        Procedimento-pausa para exibicao de informacoes
        na tela.

        @throw  java.io.IOException
     */

    public
    void pressioneTecla () throws java.io.IOException
    {
        printf_ ("\nPressione uma tecla para continuar...\n");

        readLine (1);

        return;
    }


    /**
        Procedimento inicial do aplicativo Java.

        @param  args    Os parametros passados na
                        linha de comando.
     */

    public static
    void main (String [] args)
    {
        demoapp d = new demoapp ();

        d.executar (args);

        return;
    }


    /**
        Procedimento para exibicao das mensagens
        recuperadas do SCoPE para o cliente e operador.

        @param  sMsgCli1    Primeira linha 'a ser exibida
                            no painel/display do cliente.
        @param  sMsgCli2    Segunda linha 'a ser exibida
                            no painel/display do cliente.
        @param  sMsgOp1     Primeira linha 'a ser exibida
                            no painel/display do operador.
        @param  sMsgOp2     Segunda linha 'a ser exibida
                            no painel/display do operador.
     */

    public static
    void exibeMsgs (String sMsgCli1, String sMsgCli2,
                                    String sMsgOp1, String sMsgOp2)
    {
        printf_ ("\nX########### TELA DO CLIENTE ############X");
        printf_ ("X" + centerText (sMsgCli1, 40) + "X");
        printf_ ("X" + centerText (sMsgCli2, 40) + "X");
        printf_ ("X########################################X\n");

        printf_ ("\n+--------- TECLADO DO OPERADOR-----------+");
        printf_ ("|" + centerText (sMsgOp1, 40) + "|");
        printf_ ("|" + centerText (sMsgOp2, 40) + "|");
        printf_ ("+----------------------------------------+\n");

        return;
    }


    /**
        Procedimento para centralizacao de texto numa string.

        @param  sTxt    O texto 'a ser centralizado.
        @param  iMax    O tamanho da tela em caracteres.

        @return         Uma string com o texto passado
                        centralizado.
     */

    public static
    String centerText (String sTxt, int iMax)
    {
        StringBuffer    sAux    = new StringBuffer (iMax);

        byte            bCont;

        // Preencher com brancos
        for (bCont = 0; bCont < iMax; bCont++)
            sAux.append (' ');

        if ( (sTxt != null) && (sTxt.length () > 0) )
        {
            bCont = (byte) ( ( iMax - sTxt.length () ) / 2 );

            sAux.replace (bCont, sTxt.length () + bCont, sTxt);
        }

        return ( sAux.toString () );
    }


    /**
        Realiza o procedimento para uso do PINPad.

        @return false   Falha na abertura do recurso.
        @return true    Sucesso.
    */

    public
    boolean AbrePINPad () throws java.io.IOException
    {
        long            RC;

        clScope.validaInterfacePP (Scope.PP_INTERFACE_LIB_COMPARTILHADA);

        /* Consulta como esta' configurado o PIN-Pad
            compartilhado no ScopeCNF */
        cPP = exibeConsultaPP ();

        if ( (cPP.configurado != 0) &&
                    (cPP.usoExclusivoScope == 0) )
        {
            /* Abre conexao com PINPad	*/
            printf_ ("\nConectando ao PINPad...");

            RC = clScope.ppOpen (cPP.porta);

            if (RC != Scope.PC_OK)
            {
                printf_ ("falhou!\nErro ao abrir o PIN-Pad: " +
                        Long.toHexString (RC) +
                        ", (" + RC + ")");

                pressioneTecla ();

                return (false);
            }
        }

        return (true);
    }


    /**
        Realiza o procedimento para o recebimento
        de dados digitados no PINPad.

        @param msgDisplay   Mensagem que sera exibida no
                            PIN-Pad. Esta mensagem deve
                            ter no maximo 32 caracteres
                            sendo duas linhas de 16 caracteres.
        @param [out] bSaida Teclas digitadas no PINPad.

        @return             Ver codigos relacionados na
                            tabela CODIGOS DE RETORNO.
    */

    public
    int GetPIN_PINPad (String msgDisplay, Buffer bSaida)
                                throws java.io.IOException
    {
        int RC = clScope.ppStartGetPIN (msgDisplay);

        if (RC != Scope.PC_OK)
            return (RC);

        do
        {
            RC = clScope.ppGetPIN (bSaida);
        }
        while (RC == Scope.PC_PROCESSING);

        return (RC);
    }


    /**
        Realiza o procedimento para o recebimento
        de uma tecla de funcao do PINPad.

        @return             Ver codigos relacionados na
                            tabela CODIGOS DE RETORNO.
    */

    public
    int GetKey_PINPad () throws java.io.IOException
    {
        int RC = clScope.ppStartGetKey ();

        if (RC != Scope.PC_OK)
            return (RC);

        do
        {
            RC = clScope.ppGetKey ();
        }
        while (RC == Scope.PC_PROCESSING);

        return (RC);
    }
}
