VERSION 5.00
Begin VB.Form FrmColeta 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Coleta de dados"
   ClientHeight    =   6150
   ClientLeft      =   5490
   ClientTop       =   3210
   ClientWidth     =   8370
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6150
   ScaleWidth      =   8370
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer TColeta 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   3480
      Top             =   120
   End
   Begin VB.CommandButton BtnCancela 
      Caption         =   "Cancela"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3120
      TabIndex        =   4
      Top             =   5520
      Width           =   1095
   End
   Begin VB.CommandButton BtnRetorna 
      Caption         =   "Retorna"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1680
      TabIndex        =   3
      Top             =   5520
      Width           =   1095
   End
   Begin VB.CommandButton BtnOk 
      Caption         =   "OK"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   5520
      Width           =   1095
   End
   Begin VB.Frame FrameEntrDados 
      Caption         =   "Entrada de dados"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   895
      Left            =   120
      TabIndex        =   6
      Top             =   4320
      Width           =   7815
      Begin VB.TextBox TbEntrDados 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Left            =   240
         TabIndex        =   1
         Text            =   "Text1"
         Top             =   360
         Width           =   7335
      End
   End
   Begin VB.Frame FrameMsgCli 
      Caption         =   "Mensagens do Cliente"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1335
      Left            =   120
      TabIndex        =   5
      Top             =   2880
      Width           =   7815
      Begin VB.Label LbMsgCli1 
         Alignment       =   2  'Center
         AutoSize        =   -1  'True
         Caption         =   "Mensagem do cliente 01"
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   480
         Left            =   2400
         TabIndex        =   7
         Top             =   360
         Width           =   2535
         WordWrap        =   -1  'True
      End
   End
   Begin VB.Frame FrameMsgOper 
      Caption         =   "Mensagens do Operador"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2535
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7815
      Begin VB.ListBox LbMsgOper1 
         BackColor       =   &H80000004&
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1740
         Left            =   120
         TabIndex        =   8
         Top             =   360
         Width           =   7455
      End
   End
End
Attribute VB_Name = "FrmColeta"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Formulario para a coleta dos dados - exemplo da interface coleta

Option Explicit

Dim Status As Long

'Procedimento para cancelamento da transacao
Private Sub BtnCancela_Click()
    ResumeColeta (ACAO_CANCELAR)
End Sub

Private Sub DispOperad(sIn As String)
    Dim PosInic         As Integer, _
        PosAtual        As Integer, _
        iTmp            As Integer

    FrmColeta.LbMsgOper1.Clear

    PosAtual = 1

    Do
        PosInic = InStr(PosAtual, sIn, vbCrLf)

        If PosInic = 0 Then Exit Do

        gsPos = Trim(Mid(sIn, PosAtual, _
                            PosInic - PosAtual))

        If Len(gsPos) < 40 Then
            iTmp = Abs(20 - (Len(gsPos) / 2))
    
            gsPos = Space(iTmp) & gsPos
        End If
    
        FrmColeta.LbMsgOper1.AddItem (gsPos)
    
        PosAtual = PosInic + 2
    Loop While PosInic <> 0
End Sub

'Procedimento para o avanco do estado da
'transacao.
Private Sub BtnOk_Click()
    ResumeColeta (ACAO_PROXIMO)
End Sub

'Procedimento para o retorno do estado
'da transacao.
Private Sub BtnRetorna_Click()
    ResumeColeta (ACAO_ANTERIOR)
End Sub

'Procedimento para inicializacao da aplicacao.
'Funcao padrao MS-VB.
Private Sub Form_Activate()
    ' Trata text box
    Call InicializaMsgTela
'    If TbEntrDados.Visible Then
'        TbEntrDados.SetFocus
'    End If

    ' Trata a maquina de estado
    TColeta_Timer
End Sub

'Procedimento para inicializacao da apresentacao
'dos dados.
Private Sub Form_Load()
    InicializaTela
End Sub


'Procedimento/evento utilizado para gerenciamento
'do estado da coleta.
Private Sub TColeta_Timer()
    On Error Resume Next
    
    Dim ListaMedicamentosCRM As stREGISTRO_MEDICAMENTO_CRM
    Dim iLen As Integer
    Dim listaProjeto As RegistroProjeto
   
     
    Dim ListaMedicamento    As stREGISTRO_MEDICAMENTO
    Dim Rc                  As Long, _
        lTmp                As Long, _
        CabecLen            As Integer, _
        CupomClienteLen     As Integer, _
        CupomLojaLen        As Integer, _
        CupomReduzidoLen    As Integer, _
        sTmp                As String, _
        Cabec               As String * 512, _
        CupomCliente        As String * 2048, _
        CupomLoja           As String * 2048, _
        CupomReduzido       As String * 2048, _
        qtdLinhasReduz      As Byte, _
        BArray()            As Byte, _
        bMsg                As Byte, _
        ParamCheque         As stParamCheque, _
        Coleta              As stColeta, _
        ListaOper           As stREC_CEL_OPERADORAS, _
        ListaValores        As stREC_CEL_VALORES, _
        TipoVal             As eREC_CEL_VALORES_MODELO

        ' variaveis pbm
        Dim bQtdRegistros As Byte, _
        bTipoConvenio As Byte
       
       Dim iIndice  As Integer

    ' Inicializacoes
    TColeta.Enabled = False
    TColeta.Interval = 0      ' Valor default

    Do While (True)
        'Realizar a acao de acordo com o estado do SCoPE
        Status = ScopeStatus
        
        ' Transacao ainda em processamento
        If Status = ST_PROGRESS Then
            TColeta.Enabled = True
            TColeta.Interval = TEMPO_ESPERA

            Exit Do
        End If

        ' Se estiver fora da faixa, o processo esta encerrado
        If (Status < CT_ESTADO_INICIAL) Or _
            (Status > CT_ESTADO_FINAL) Then
            If Status = OP_SUCCESS Then
                frmScope.sspStatus.Panels(1).Text = _
                                " Transação encerrada com sucesso."
            Else
                frmScope.sspStatus.Panels(1).Text = _
                        " Transação encerrada com RC = " & Status & "."
            End If

            FrmColeta.Hide

            Exit Do
        End If

        ' Trata os estados da coleta
        Select Case Status
            Case CT_IMPRIME_CUPOM   ' Imprime cupom
                CabecLen = Len(Cabec)
                CupomClienteLen = Len(CupomCliente)
                CupomLojaLen = Len(CupomLoja)
                CupomReduzidoLen = Len(CupomReduzido)
                Cabec = ""
                CupomCliente = ""
                CupomLoja = ""
                CupomReduzido = ""
                qtdLinhasReduz = 0

                Rc = ScopeGetCupomEx(CabecLen, Cabec, CupomClienteLen, _
                                CupomCliente, CupomLojaLen, CupomLoja, _
                                CupomReduzidoLen, CupomReduzido, qtdLinhasReduz)

                Cabec = Trim(Cabec)
                CupomCliente = Trim(CupomCliente)
                CupomLoja = Trim(CupomLoja)
                CupomReduzido = Trim(CupomReduzido)

                If (CupomCliente <> "") Then
                    FrmCupom.Caption = "Cupom do cliente"
                    FrmCupom.RtbCupom.Text = CStr2VBStr(Cabec) & vbCrLf & _
                                                CStr2VBStr(CupomCliente)

                    FrmCupom.Show vbModal, Me
                End If

                If (CupomLoja <> "") Then
                    FrmCupom.Caption = "Cupom da loja"
                    FrmCupom.RtbCupom.Text = CStr2VBStr(Cabec) & vbCrLf & _
                                                CStr2VBStr(CupomLoja)

                    FrmCupom.Show vbModal, Me
                End If

                If (qtdLinhasReduz <> 0) Then
                    FrmCupom.Caption = "Cupom reduzido"
                    FrmCupom.RtbCupom.Text = CStr2VBStr(Cabec) & vbCrLf & _
                                                CStr2VBStr(CupomReduzido)

                    FrmCupom.Show vbModal, Me
                End If

            Case CT_COLETA_OPERADORA    ' Recupera a lista de operadoras da
                                        ' Recarga de Celular
                Rc = ScopeRecuperaOperadorasRecCel(REC_CEL_OPERADORAS_MODELO_2, _
                                                ListaOper, Len(ListaOper))

                If Rc = OP_SUCCESS Then
                    sTmp = "Selecione a operadora (" _
                            & ListaOper.NumOperCel & "):" & vbCrLf

                    For CupomLojaLen = 0 To ListaOper.NumOperCel - 1
                        Cabec = ListaOper.Operadoras(CupomLojaLen).NomeOperCel

                        sTmp = sTmp & "(" & _
                                ListaOper.Operadoras(CupomLojaLen).CodOperCel & ") "
                        sTmp = sTmp & CStr2VBStr(Cabec) & vbCrLf
                    Next

                    bMsg = 1
                End If

            Case CT_COLETA_VALOR_RECARGA    ' Recupera a lista de valores da
                                            ' Recarga de Celular
                TipoVal = REC_CEL_VALORES_MODELO_2

                lTmp = ScopeObtemHandle(HDL_TRANSACAO_EM_ANDAMENTO)

                If lTmp > &HFFFF& Then
                    Call ScopeObtemCampoExt(lTmp, Cod_Rede, 0, CByte(0), Cabec)

                    If CLng(Cabec) = R_GWCEL Then
                        TipoVal = REC_CEL_VALORES_MODELO_3
                    End If
                End If

                Rc = ScopeRecuperaValoresRecCel(TipoVal, ListaValores, _
                                                            Len(ListaValores))

                If Rc = OP_SUCCESS Then
                    sTmp = "Selecione o val da recarga: " & vbCrLf

                    For CupomLojaLen = 0 To ListaValores.Totvalor - 1
                        CabecLen = 1
                        qtdLinhasReduz = 0

                        Do While CabecLen <= _
                                Len(ListaValores.TabValores(CupomLojaLen).Valor)
                            Cabec = Mid(ListaValores.TabValores(CupomLojaLen).Valor, _
                                                            CabecLen, 1)

                            If Mid(Cabec, 1, 1) <> "0" Or qtdLinhasReduz <> 0 Then
                                sTmp = sTmp & Mid(Cabec, 1, 1)
                                qtdLinhasReduz = 1
                            End If

                            CabecLen = CabecLen + 1
                        Loop

                        sTmp = Trim(sTmp) & vbCrLf
                    Next

                    If (ListaValores.TotFaixaValores > 0) Then
                        sTmp = sTmp & vbCrLf & "FAIXA DE VALORES" & vbCrLf

                        For CupomLojaLen = 0 To ListaValores.TotFaixaValores - 1
                            sTmp = sTmp & "(" & CupomLojaLen & ") ValorMinimo=" & _
                                ListaValores.TabFaixaValores(CupomLojaLen).ValorMin & _
                                " ValorMinimo= " & _
                                    ListaValores.TabFaixaValores(CupomLojaLen).ValorMax & _
                                        vbCrLf
                        Next
                    End If

                    bMsg = 1
                End If

            Case CT_IMPRIME_CHEQUE  ' Imprime cheque
                Rc = ScopeGetCheque(ParamCheque)
                BArray = ParamCheque.Banco
                FrmCupom.RtbCupom.Text = "Banco.........: " & _
                                                CStr2VBStr(ParamCheque.Banco) & _
                                                vbCrLf & _
                                         "Agencia.......: " & _
                                                CStr2VBStr(ParamCheque.Agencia) & _
                                                vbCrLf & _
                                         "Num. Cheque...: " & _
                                                CStr2VBStr(ParamCheque.NumCheque) & _
                                                vbCrLf & _
                                         "Bom Para......: " & _
                                                CStr2VBStr(ParamCheque.BomPara) & _
                                                vbCrLf & _
                                         "Cod. Autoriz..: " & _
                                                CStr2VBStr(ParamCheque.CodAut) & _
                                                vbCrLf & _
                                         "Municipio.....: " & _
                                                CStr2VBStr(ParamCheque.Municipio) & _
                                                vbCrLf & _
                                         "Valor.........: " & CStr2VBStr(ParamCheque.Valor)

                FrmCupom.Show vbModal, Me
            Case CT_OBTER_LISTA_MEDICAMENTOS ' obtem a lista de medicamentos
            
                Rc = ScopeObtemMedicamentosComCRM(bQtdRegistros, bTipoConvenio, ListaMedicamentosCRM, Len(ListaMedicamentosCRM))
                    'ScopeObtemMedicamentosEx
                    'ScopeObtemMedicamentos
                If Rc = 0 Then
                    sTmp = ""
                    For iIndice = 0 To bQtdRegistros - 1
                         sTmp = sTmp & "CRM: " & ListaMedicamentosCRM.RegistroM(iIndice).CRM & vbCrLf
                         sTmp = sTmp & "Codigo EAN: " & ListaMedicamentosCRM.RegistroM(iIndice).CodigoEAN & vbCrLf
                         sTmp = sTmp & "Quantidade de produtos: " & ListaMedicamentosCRM.RegistroM(iIndice).QtdProdutos & vbCrLf
                         sTmp = sTmp & "Preco PMC: " & ListaMedicamentosCRM.RegistroM(iIndice).PrecoPMC & vbCrLf
                         sTmp = sTmp & "Preco Venda: " & ListaMedicamentosCRM.RegistroM(iIndice).PrecoVenda & vbCrLf
                         sTmp = sTmp & "Preco Fabrica: " & ListaMedicamentosCRM.RegistroM(iIndice).PrecoFabrica & vbCrLf
                         sTmp = sTmp & "Preco Aquisicao: " & ListaMedicamentosCRM.RegistroM(iIndice).PrecoAquisicao & vbCrLf
                         sTmp = sTmp & "Preco Repasse: " & ListaMedicamentosCRM.RegistroM(iIndice).PrecoRepasse & vbCrLf
                         sTmp = sTmp & "Motivo Rejeicao: " & ListaMedicamentosCRM.RegistroM(iIndice).MotivoRejeicao & vbCrLf
                         sTmp = sTmp & vbCrLf
                    Next iIndice
                    
                    bQtdRegistros = 0
                    
                    ' Utiliza o formulário de cupom para mostrar a lista de medicamentos
                    FrmCupom.RtbCupom.Text = sTmp
                    FrmCupom.Caption = "Lista de Medicamentos"
                    FrmCupom.Show vbModal, Me
                    Exit Do
                End If
                
            Case CT_COLETA_REG_MEDICAMENTO
          
            ' Atualiza o valor
             ScopeAtualizaValor ("40000")
             ResumeColeta (ACAO_PROXIMO)
            Case Else           ' deve coletar algo...
                ' Informar o num do cartao
                If Status = CT_CARTAO_DIGITADO And _
                        TbEntrDados.Text <> "" Then
                    ResumeColeta (ACAO_PROXIMO)

                    Exit Sub
                End If

                bMsg = 1
                        
        End Select

        If bMsg <> 0 Then
            Rc = ScopeGetParam(Status, Coleta)

            ' Habilita as teclas
            BtnCancela.Enabled = IIf(Coleta.HabTeclas And _
                                                &H1&, True, False)
            BtnOk.Enabled = IIf(Coleta.HabTeclas And _
                                                &H2&, True, False)
            BtnRetorna.Enabled = IIf(Coleta.HabTeclas And _
                                                &H4&, True, False)

            If sTmp = "" Then
                sTmp = Trim(CStr2VBStr(Coleta.MsgOp1)) & vbCrLf & _
                        Trim(CStr2VBStr(Coleta.MsgOp2)) & vbCrLf
            End If

            DispOperad (sTmp)

            FrmColeta.LbMsgCli1 = Trim(CStr2VBStr(Coleta.MsgCl1)) & vbCrLf & _
                                    Trim(CStr2VBStr(Coleta.MsgCl2))

            ' Habilita a entrada de dados via teclado
             FrameEntrDados.Visible = IIf((BtnOk.Enabled = True) And _
                        (Status <> CT_INFO_AGUARDA_OPERADOR), True, False)

            If TbEntrDados.Visible Then
                TbEntrDados.SetFocus
            End If

            ' Apenas mostra informacao e deve retornar ao scope
            bMsg = 0

            If Status = CT_INFO_RETORNA_FLUXO Or _
                    Status = CT_COLETA_EM_ANDAMENTO Then
                TbEntrDados.Text = ""
                ResumeColeta (ACAO_PROXIMO)
           ElseIf Status = CT_COLETA_PROJETO Then
           
            ' Recupera a lista de projetos
             Rc = ScopeRecuperaBufTabela(0, bQtdRegistros, listaProjeto, Len(listaProjeto))
             If Rc = 0 Then
                DispOperad (sTmp)
                bQtdRegistros = bQtdRegistros / 16
                FrmColeta.LbMsgOper1.AddItem (sTmp & vbCrLf)
                For iIndice = 0 To bQtdRegistros - 1
                    sTmp = sTmp & "Cod: " & listaProjeto.RegistroProjeto(iIndice).CodProjeto & vbCrLf
                    sTmp = sTmp & "Descricao: " & listaProjeto.RegistroProjeto(iIndice).CodProjeto & vbCrLf
                    sTmp = sTmp & "Operadora de produtos: " & listaProjeto.RegistroProjeto(iIndice).OperadoraProjeto & vbCrLf
                    sTmp = sTmp & vbCrLf
                    DispOperad (sTmp)
                Next iIndice
             End If
            Else
                If Status = CT_COLETA_CARTAO_EM_ANDAMENTO Then
                    Rc = ScopeResumeParam(Status, _
                                            "", SCO_TECLADO, ACAO_PROXIMO)

                    bMsg = 1
                Else
                    TbEntrDados.Text = ""
                End If
            End If

            If bMsg = 1 Then
                TColeta.Enabled = True
                TColeta.Interval = TEMPO_ESPERA

                Exit Do
            End If

            ' Na coleta de senha, define se obtem senha com ou sem criptografia
            If Status = CT_COLETA_SENHA Then
                If (Coleta.PosMasterKey >= 0) And _
                        (Coleta.PosMasterKey <= 9) Then
                    ' Obtem senha com criptografia
                    Exit Do
                Else
                    ' Obtem senha sem criptografia
                    Exit Do
                End If
            End If
        End If

        Exit Do
    Loop
End Sub

'Procedimento para a continuacao do processo de
'coleta de informacoes.
Public Sub ResumeColeta(acao As Long)
    Dim BytArrayDados()     As Byte, _
        DadosParam          As Integer, _
        Count               As Integer, _
        Rc                  As Long, _
        Dados               As String, _
        LastMsgColeta       As stLastMsgColeta
    Dim FileName      As String
    Dim listaProjeto As RegistroProjeto
    Dim sTmp                As String
    Dim bQtdRegistros As Byte
    Dim iIndice  As Integer
    
    Dados = ""

    ' Inicializacoes
    If (TbEntrDados.Text <> "") And _
            (acao <> ACAO_CANCELAR) Then
        Dados = TbEntrDados.Text
    End If

    ' Define a via de entrada na coleta de cartao
    If Status = CT_COLETA_CARTAO Then
        If (TbEntrDados.Text <> "") Then
            'Entrada via teclado
            DadosParam = SCO_TECLADO
        Else
            'Entrada via leitura magnetica
            DadosParam = SCO_CARTAO_MAGNETICO
        End If
    Else
        DadosParam = SCO_TECLADO
    End If

    ' O SCoPE estava esperando o cartao no PPad,
    ' e o usr digitou-o
    If (Status = CT_COLETA_CARTAO_EM_ANDAMENTO) And _
        (TbEntrDados.Text <> "") And (acao = ACAO_PROXIMO) Then
        ' Vamos informar ao SCoPE q iremos informar
        ' o num do cartao via funcao
        Dados = ""

        acao = 2 ' Cancelar
      ElseIf Status = CT_COLETA_DADOS_LISTA_PRECOS Then
         FileName = App.Path & "\" & FILE_ATUALIZAPRECOTICKET
         
         Dados = GetBufferDadosFromTXT(FileName)
            
         If Len(Dados) = 0 Then
            Dados = "LP01" & "ID504" & "218"
            Dados = Dados & "20130220" & "151052" & "00101" & "000000001160" & "3"
            Dados = Dados & "20130220" & "183620" & "00102" & "000000001590" & "3"
            Dados = Dados & "20130220" & "172335" & "00103" & "000000009730" & "3"
            Dados = Dados & "20130220" & "162225" & "00104" & "000000001040" & "3"
            Dados = Dados & "20130220" & "172211" & "00105" & "000000006350" & "3"
            Dados = Dados & "20130220" & "172335" & "00106" & "000000002530" & "3"
            Dados = Dados & "20130220" & "101233" & "00107" & "000000001910" & "3"
            Dados = Dados & "20130220" & "101519" & "00108" & "000000001250" & "3"
            Dados = Dados & "20130220" & "095828" & "00109" & "000000001170" & "3"
            Dados = Dados & "20130220" & "172337" & "00110" & "000000003140" & "3"
            Dados = Dados & "20130220" & "172337" & "00111" & "000000001570" & "3"
            Dados = Dados & "20130220" & "095828" & "00112" & "000000002420" & "3"
            Dados = Dados & "20130220" & "172356" & "00133" & "000000001160" & "2"
            Dados = Dados & "20130220" & "101948" & "00134" & "000000001590" & "2"
            Dados = Dados & "20130220" & "102553" & "00135" & "000000009730" & "2"
            Dados = Dados & "20130220" & "145901" & "00136" & "000000001040" & "2"
            Dados = Dados & "20130220" & "151004" & "00137" & "000000006350" & "2"
            Dados = Dados & "20130220" & "102313" & "00138" & "000000002530" & "2"
            Dados = Dados & "20130220" & "102315" & "00139" & "000000001910" & "2"
            Dados = Dados & "20130220" & "162137" & "00140" & "000000001250" & "2"
            Dados = Dados & "20130220" & "102140" & "00141" & "000000001170" & "2"
            Dados = Dados & "20130220" & "172234" & "00142" & "000000003140" & "2"
            Dados = Dados & "20130220" & "150732" & "00143" & "000000001570" & "2"
            Dados = Dados & "20130220" & "172337" & "00144" & "000000002420" & "2"
            Dados = Dados & "20130220" & "094616" & "00145" & "000000001600" & "2"
            Dados = Dados & "20130220" & "091246" & "00146" & "000000001490" & "2"
            Dados = Dados & "20130220" & "095831" & "00147" & "000000002640" & "2"
            Dados = Dados & "20130220" & "101948" & "00148" & "000000002190" & "2"
            Dados = Dados & "20130220" & "101950" & "00149" & "000000001230" & "2"
            Dados = Dados & "20130220" & "151004" & "00150" & "000000001270" & "2"
            Dados = Dados & "20130220" & "162137" & "00151" & "000000001040" & "2"
            Dados = Dados & "20130220" & "172242" & "00152" & "000000001220" & "2"
            Dados = Dados & "20130220" & "102008" & "00153" & "000000001090" & "2"
            Dados = Dados & "20130220" & "152212" & "00154" & "000000002500" & "2"
            Dados = Dados & "20130220" & "151052" & "00155" & "000000001180" & "2"
            Dados = Dados & "20130220" & "183337" & "00156" & "000000001040" & "2"
            Dados = Dados & "20130220" & "094617" & "00157" & "000000001100" & "2"
            Dados = Dados & "20130220" & "183337" & "00158" & "000000001560" & "2"
            Dados = Dados & "20130220" & "162137" & "00159" & "000000003020" & "2"
            Dados = Dados & "20130220" & "101950" & "00160" & "000000002620" & "2"
            Dados = Dados & "20130220" & "095831" & "00161" & "000000001040" & "2"
            Dados = Dados & "20130220" & "101220" & "00162" & "000000001150" & "2"
            Dados = Dados & "20130220" & "183920" & "00163" & "000000002500" & "2"
            Dados = Dados & "20130220" & "162212" & "00164" & "000000001070" & "2"
            Dados = Dados & "20130220" & "183337" & "00165" & "000000001060" & "2"
            Dados = Dados & "20130220" & "091246" & "00166" & "000000008590" & "2"
            Dados = Dados & "20130220" & "150730" & "00167" & "000000001600" & "2"
            Dados = Dados & "20130220" & "094617" & "00168" & "000000001140" & "2"
            Dados = Dados & "20130220" & "183335" & "00169" & "000000001270" & "2"
            Dados = Dados & "20130220" & "172356" & "00170" & "000000001760" & "2"
            Dados = Dados & "20130220" & "172030" & "00171" & "000000002160" & "2"
            Dados = Dados & "20130220" & "151052" & "00172" & "000000002160" & "2"
            Dados = Dados & "20130220" & "183335" & "00173" & "000000001300" & "2"
            Dados = Dados & "20130220" & "102538" & "00174" & "000000001870" & "2"
            Dados = Dados & "20130220" & "161110" & "00175" & "000000002490" & "2"
            Dados = Dados & "20130220" & "095828" & "00176" & "000000005120" & "2"
            Dados = Dados & "20130220" & "095828" & "00177" & "000000001230" & "2"
            Dados = Dados & "20130220" & "172337" & "00178" & "000000001110" & "2"
            Dados = Dados & "20130220" & "172337" & "00179" & "000000002650" & "2"
            Dados = Dados & "20130220" & "094617" & "00180" & "000000001180" & "2"
            Dados = Dados & "20130220" & "101220" & "00181" & "000000001850" & "2"
            Dados = Dados & "20130220" & "150732" & "00182" & "000000001050" & "2"
            Dados = Dados & "20130220" & "094617" & "00183" & "000000001040" & "2"
            
            Dados = Dados & "20130220" & "151052" & "00101" & "000000001160" & "3"
            Dados = Dados & "20130220" & "183620" & "00102" & "000000001590" & "3"
            Dados = Dados & "20130220" & "172335" & "00103" & "000000009730" & "3"
            Dados = Dados & "20130220" & "162225" & "00104" & "000000001040" & "3"
            Dados = Dados & "20130220" & "172211" & "00105" & "000000006350" & "3"
            Dados = Dados & "20130220" & "172335" & "00106" & "000000002530" & "3"
            Dados = Dados & "20130220" & "101233" & "00107" & "000000001910" & "3"
            Dados = Dados & "20130220" & "101519" & "00108" & "000000001250" & "3"
            Dados = Dados & "20130220" & "095828" & "00109" & "000000001170" & "3"
            Dados = Dados & "20130220" & "172337" & "00110" & "000000003140" & "3"
            Dados = Dados & "20130220" & "172337" & "00111" & "000000001570" & "3"
            Dados = Dados & "20130220" & "095828" & "00112" & "000000002420" & "3"
            Dados = Dados & "20130220" & "172356" & "00133" & "000000001160" & "2"
            Dados = Dados & "20130220" & "101948" & "00134" & "000000001590" & "2"
            Dados = Dados & "20130220" & "102553" & "00135" & "000000009730" & "2"
            Dados = Dados & "20130220" & "145901" & "00136" & "000000001040" & "2"
            Dados = Dados & "20130220" & "151004" & "00137" & "000000006350" & "2"
            Dados = Dados & "20130220" & "102313" & "00138" & "000000002530" & "2"
            Dados = Dados & "20130220" & "102315" & "00139" & "000000001910" & "2"
            Dados = Dados & "20130220" & "162137" & "00140" & "000000001250" & "2"
            Dados = Dados & "20130220" & "102140" & "00141" & "000000001170" & "2"
            Dados = Dados & "20130220" & "172234" & "00142" & "000000003140" & "2"
            Dados = Dados & "20130220" & "150732" & "00143" & "000000001570" & "2"
            Dados = Dados & "20130220" & "172337" & "00144" & "000000002420" & "2"
            Dados = Dados & "20130220" & "094616" & "00145" & "000000001600" & "2"
            Dados = Dados & "20130220" & "091246" & "00146" & "000000001490" & "2"
            Dados = Dados & "20130220" & "095831" & "00147" & "000000002640" & "2"
            Dados = Dados & "20130220" & "101948" & "00148" & "000000002190" & "2"
            Dados = Dados & "20130220" & "101950" & "00149" & "000000001230" & "2"
            Dados = Dados & "20130220" & "151004" & "00150" & "000000001270" & "2"
            Dados = Dados & "20130220" & "162137" & "00151" & "000000001040" & "2"
            Dados = Dados & "20130220" & "172242" & "00152" & "000000001220" & "2"
            Dados = Dados & "20130220" & "102008" & "00153" & "000000001090" & "2"
            Dados = Dados & "20130220" & "152212" & "00154" & "000000002500" & "2"
            Dados = Dados & "20130220" & "151052" & "00155" & "000000001180" & "2"
            Dados = Dados & "20130220" & "183337" & "00156" & "000000001040" & "2"
            Dados = Dados & "20130220" & "094617" & "00157" & "000000001100" & "2"
            Dados = Dados & "20130220" & "183337" & "00158" & "000000001560" & "2"
            Dados = Dados & "20130220" & "162137" & "00159" & "000000003020" & "2"
            Dados = Dados & "20130220" & "101950" & "00160" & "000000002620" & "2"
            Dados = Dados & "20130220" & "095831" & "00161" & "000000001040" & "2"
            Dados = Dados & "20130220" & "101220" & "00162" & "000000001150" & "2"
            Dados = Dados & "20130220" & "183920" & "00163" & "000000002500" & "2"
            Dados = Dados & "20130220" & "162212" & "00164" & "000000001070" & "2"
            Dados = Dados & "20130220" & "183337" & "00165" & "000000001060" & "2"
            Dados = Dados & "20130220" & "091246" & "00166" & "000000008590" & "2"
            Dados = Dados & "20130220" & "150730" & "00167" & "000000001600" & "2"
            Dados = Dados & "20130220" & "094617" & "00168" & "000000001140" & "2"
            Dados = Dados & "20130220" & "183335" & "00169" & "000000001270" & "2"
            Dados = Dados & "20130220" & "172356" & "00170" & "000000001760" & "2"
            Dados = Dados & "20130220" & "172030" & "00171" & "000000002160" & "2"
            Dados = Dados & "20130220" & "151052" & "00172" & "000000002160" & "2"
            Dados = Dados & "20130220" & "183335" & "00173" & "000000001300" & "2"
            Dados = Dados & "20130220" & "102538" & "00174" & "000000001870" & "2"
            Dados = Dados & "20130220" & "161110" & "00175" & "000000002490" & "2"
            Dados = Dados & "20130220" & "095828" & "00176" & "000000005120" & "2"
            Dados = Dados & "20130220" & "095828" & "00177" & "000000001230" & "2"
            Dados = Dados & "20130220" & "172337" & "00178" & "000000001110" & "2"
            Dados = Dados & "20130220" & "172337" & "00179" & "000000002650" & "2"
            Dados = Dados & "20130220" & "094617" & "00180" & "000000001180" & "2"
            Dados = Dados & "20130220" & "101220" & "00181" & "000000001850" & "2"
            Dados = Dados & "20130220" & "150732" & "00182" & "000000001050" & "2"
            Dados = Dados & "20130220" & "094617" & "00183" & "000000001040" & "2"
            
            Dados = Dados & "20130220" & "151052" & "00101" & "000000001160" & "3"
            Dados = Dados & "20130220" & "183620" & "00102" & "000000001590" & "3"
            Dados = Dados & "20130220" & "172335" & "00103" & "000000009730" & "3"
            Dados = Dados & "20130220" & "162225" & "00104" & "000000001040" & "3"
            Dados = Dados & "20130220" & "172211" & "00105" & "000000006350" & "3"
            Dados = Dados & "20130220" & "172335" & "00106" & "000000002530" & "3"
            Dados = Dados & "20130220" & "101233" & "00107" & "000000001910" & "3"
            Dados = Dados & "20130220" & "101519" & "00108" & "000000001250" & "3"
            Dados = Dados & "20130220" & "095828" & "00109" & "000000001170" & "3"
            Dados = Dados & "20130220" & "172337" & "00110" & "000000003140" & "3"
            Dados = Dados & "20130220" & "172337" & "00111" & "000000001570" & "3"
            Dados = Dados & "20130220" & "095828" & "00112" & "000000002420" & "3"
            Dados = Dados & "20130220" & "172356" & "00133" & "000000001160" & "2"
            Dados = Dados & "20130220" & "101948" & "00134" & "000000001590" & "2"
            Dados = Dados & "20130220" & "102553" & "00135" & "000000009730" & "2"
            Dados = Dados & "20130220" & "145901" & "00136" & "000000001040" & "2"
            Dados = Dados & "20130220" & "151004" & "00137" & "000000006350" & "2"
            Dados = Dados & "20130220" & "102313" & "00138" & "000000002530" & "2"
            Dados = Dados & "20130220" & "102315" & "00139" & "000000001910" & "2"
            Dados = Dados & "20130220" & "162137" & "00140" & "000000001250" & "2"
            Dados = Dados & "20130220" & "102140" & "00141" & "000000001170" & "2"
            Dados = Dados & "20130220" & "172234" & "00142" & "000000003140" & "2"
            Dados = Dados & "20130220" & "150732" & "00143" & "000000001570" & "2"
            Dados = Dados & "20130220" & "172337" & "00144" & "000000002420" & "2"
            Dados = Dados & "20130220" & "094616" & "00145" & "000000001600" & "2"
            Dados = Dados & "20130220" & "091246" & "00146" & "000000001490" & "2"
            Dados = Dados & "20130220" & "095831" & "00147" & "000000002640" & "2"
            Dados = Dados & "20130220" & "101948" & "00148" & "000000002190" & "2"
            Dados = Dados & "20130220" & "101950" & "00149" & "000000001230" & "2"
            Dados = Dados & "20130220" & "151004" & "00150" & "000000001270" & "2"
            Dados = Dados & "20130220" & "162137" & "00151" & "000000001040" & "2"
            Dados = Dados & "20130220" & "172242" & "00152" & "000000001220" & "2"
            Dados = Dados & "20130220" & "102008" & "00153" & "000000001090" & "2"
            Dados = Dados & "20130220" & "152212" & "00154" & "000000002500" & "2"
            Dados = Dados & "20130220" & "151052" & "00155" & "000000001180" & "2"
            Dados = Dados & "20130220" & "183337" & "00156" & "000000001040" & "2"
            Dados = Dados & "20130220" & "094617" & "00157" & "000000001100" & "2"
            Dados = Dados & "20130220" & "183337" & "00158" & "000000001560" & "2"
            Dados = Dados & "20130220" & "162137" & "00159" & "000000003020" & "2"
            Dados = Dados & "20130220" & "101950" & "00160" & "000000002620" & "2"
            Dados = Dados & "20130220" & "095831" & "00161" & "000000001040" & "2"
            Dados = Dados & "20130220" & "101220" & "00162" & "000000001150" & "2"
            Dados = Dados & "20130220" & "183920" & "00163" & "000000002500" & "2"
            Dados = Dados & "20130220" & "162212" & "00164" & "000000001070" & "2"
            Dados = Dados & "20130220" & "183337" & "00165" & "000000001060" & "2"
            Dados = Dados & "20130220" & "091246" & "00166" & "000000008590" & "2"
            Dados = Dados & "20130220" & "150730" & "00167" & "000000001600" & "2"
            Dados = Dados & "20130220" & "094617" & "00168" & "000000001140" & "2"
            Dados = Dados & "20130220" & "183335" & "00169" & "000000001270" & "2"
            Dados = Dados & "20130220" & "172356" & "00170" & "000000001760" & "2"
            Dados = Dados & "20130220" & "172030" & "00171" & "000000002160" & "2"
            Dados = Dados & "20130220" & "151052" & "00172" & "000000002160" & "2"
            Dados = Dados & "20130220" & "183335" & "00173" & "000000001300" & "2"
            Dados = Dados & "20130220" & "102538" & "00174" & "000000001870" & "2"
            Dados = Dados & "20130220" & "161110" & "00175" & "000000002490" & "2"
            Dados = Dados & "20130220" & "095828" & "00176" & "000000005120" & "2"
            Dados = Dados & "20130220" & "095828" & "00177" & "000000001230" & "2"
            Dados = Dados & "20130220" & "172337" & "00178" & "000000001110" & "2"
            Dados = Dados & "20130220" & "172337" & "00179" & "000000002650" & "2"
            Dados = Dados & "20130220" & "094617" & "00180" & "000000001180" & "2"
            Dados = Dados & "20130220" & "101220" & "00181" & "000000001850" & "2"
            Dados = Dados & "20130220" & "150732" & "00182" & "000000001050" & "2"
            Dados = Dados & "20130220" & "094617" & "00183" & "000000001040" & "2"
            
            Dados = Dados & "20130220" & "151052" & "00101" & "000000001160" & "3"
            Dados = Dados & "20130220" & "183620" & "00102" & "000000001590" & "3"
            Dados = Dados & "20130220" & "172335" & "00103" & "000000009730" & "3"
            Dados = Dados & "20130220" & "162225" & "00104" & "000000001040" & "3"
            Dados = Dados & "20130220" & "172211" & "00105" & "000000006350" & "3"
            Dados = Dados & "20130220" & "172335" & "00106" & "000000002530" & "3"
            Dados = Dados & "20130220" & "101233" & "00107" & "000000001910" & "3"
            Dados = Dados & "20130220" & "101519" & "00108" & "000000001250" & "3"
            Dados = Dados & "20130220" & "095828" & "00109" & "000000001170" & "3"
            Dados = Dados & "20130220" & "172337" & "00110" & "000000003140" & "3"
            Dados = Dados & "20130220" & "172337" & "00111" & "000000001570" & "3"
            Dados = Dados & "20130220" & "095828" & "00112" & "000000002420" & "3"
            Dados = Dados & "20130220" & "172356" & "00133" & "000000001160" & "2"
            Dados = Dados & "20130220" & "101948" & "00134" & "000000001590" & "2"
            Dados = Dados & "20130220" & "102553" & "00135" & "000000009730" & "2"
            Dados = Dados & "20130220" & "145901" & "00136" & "000000001040" & "2"
            Dados = Dados & "20130220" & "151004" & "00137" & "000000006350" & "2"
            Dados = Dados & "20130220" & "102313" & "00138" & "000000002530" & "2"
            Dados = Dados & "20130220" & "102315" & "00139" & "000000001910" & "2"
            Dados = Dados & "20130220" & "162137" & "00140" & "000000001250" & "2"
            Dados = Dados & "20130220" & "102140" & "00141" & "000000001170" & "2"
            Dados = Dados & "20130220" & "172234" & "00142" & "000000003140" & "2"
            Dados = Dados & "20130220" & "150732" & "00143" & "000000001570" & "2"
            Dados = Dados & "20130220" & "172337" & "00144" & "000000002420" & "2"
            Dados = Dados & "20130220" & "094616" & "00145" & "000000001600" & "2"
            Dados = Dados & "20130220" & "091246" & "00146" & "000000001490" & "2"
            Dados = Dados & "20130220" & "095831" & "00147" & "000000002640" & "2"
            Dados = Dados & "20130220" & "101948" & "00148" & "000000002190" & "2"
            Dados = Dados & "20130220" & "101950" & "00149" & "000000001230" & "2"
         End If
    ElseIf Status = CT_COLETA_LISTA_MERCADORIAS Then
         FileName = App.Path & "\" & FILE_MERCADORIASTICKET

         Dados = GetBufferDadosFromTXT(FileName)
            
         If Len(Dados) = 0 Then
            Dados = ""
            Dados = Dados & "LM01"
            Dados = Dados & "2"
            Dados = Dados & "2"
            Dados = Dados & "01"
            Dados = Dados & "SC100"
            Dados = Dados & "002"
         
            Dados = Dados & "GASOLINA COMUM                          "
            Dados = Dados & "00101"
            Dados = Dados & "00002000"
            Dados = Dados & "000007780"
            Dados = Dados & "000000389"
         
            Dados = Dados & "ALCOOL   COMUM                          "
            Dados = Dados & "00104"
            Dados = Dados & "00003000"
            Dados = Dados & "000006000"
            Dados = Dados & "000000200"
         End If
    ElseIf Status = CT_COLETA_REG_MEDICAMENTO Then
        Dados = "789626100107701"
    ElseIf Status = CT_COLETA_PROJETO Then
        'recupera a lista de projetos
        Rc = ScopeRecuperaBufTabela(0, bQtdRegistros, listaProjeto, Len(listaProjeto))
              
        If Rc = 0 Then
           sTmp = ""
            bQtdRegistros = bQtdRegistros / 16
            For iIndice = 0 To bQtdRegistros - 1
                sTmp = sTmp & "Cod: " & listaProjeto.RegistroProjeto(iIndice).CodProjeto & vbCrLf
                sTmp = sTmp & "Descricao: " & listaProjeto.RegistroProjeto(iIndice).CodProjeto & vbCrLf
                sTmp = sTmp & "Operadora de produtos: " & listaProjeto.RegistroProjeto(iIndice).OperadoraProjeto & vbCrLf
                sTmp = sTmp & vbCrLf
            Next iIndice
        End If
        MsgBox "" + sTmp
    ElseIf Status = CT_COLETA_TIPO_CONSULTA Then
        Dados = TbEntrDados.Text
        TbEntrDados.Text = ""
    Else
        DadosParam = SCO_TECLADO
    End If

    ' Resume os parametros
    Rc = ScopeResumeParam(Status, Dados, DadosParam, acao)
       
    If Rc <> OP_SUCCESS Then
       ' Obtem as mensagens
       Rc = ScopeGetLastMsg(LastMsgColeta)

       DispOperad (LastMsgColeta.MsgOp1 & vbCrLf & LastMsgColeta.MsgOp2 & vbCrLf)
       FrmColeta.LbMsgCli1 = LastMsgColeta.MsgCl1 & vbCrLf & LastMsgColeta.MsgCl2

       ' Trata tela
       DesabilitaBotoes

       FrameEntrDados.Visible = False
       TColeta.Interval = TEMPO_ESPERA * 6
       TColeta.Enabled = True
    Else
       TColeta_Timer
    End If
End Sub

'Procedimento para configuracao inicial dos
'objetos graficos.
Private Sub InicializaTela()
    BtnOk.Default = True
    TbEntrDados.Text = ""
    DesabilitaBotoes
    InicializaMsgTela
End Sub

'Procedimento para desativacao dos botoes
'quando necessario.
Private Sub DesabilitaBotoes()
    BtnOk.Enabled = False
    BtnRetorna.Enabled = False
    BtnCancela.Enabled = False
End Sub

'Procedimento para inicializacao das mensagens
'de apresentacao.
Private Sub InicializaMsgTela()
    FrmColeta.LbMsgOper1.Clear
    FrmColeta.LbMsgCli1 = ""
End Sub
