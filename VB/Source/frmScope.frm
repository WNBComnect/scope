VERSION 5.00
Object = "{354FEAED-4ACE-11D1-9497-444553540000}#6.0#0"; "Mksiac.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.1#0"; "Mscomctl.ocx"
Begin VB.Form frmScope 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Scope Hotkey (Interface Coleta)"
   ClientHeight    =   10410
   ClientLeft      =   120
   ClientTop       =   300
   ClientWidth     =   9345
   ClipControls    =   0   'False
   Icon            =   "frmScope.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   10410
   ScaleWidth      =   9345
   Begin VB.TextBox txtCupom 
      BeginProperty Font 
         Name            =   "Palatino Linotype"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5520
      TabIndex        =   43
      Top             =   7800
      Width           =   2895
   End
   Begin VB.ComboBox cboConvenio 
      Enabled         =   0   'False
      Height          =   315
      ItemData        =   "frmScope.frx":030A
      Left            =   1680
      List            =   "frmScope.frx":030C
      Style           =   2  'Dropdown List
      TabIndex        =   39
      Top             =   7800
      Width           =   2775
   End
   Begin VB.ComboBox cboPBM 
      Enabled         =   0   'False
      Height          =   315
      ItemData        =   "frmScope.frx":030E
      Left            =   1680
      List            =   "frmScope.frx":0310
      Style           =   2  'Dropdown List
      TabIndex        =   37
      Top             =   8280
      Width           =   2775
   End
   Begin VB.CommandButton cmdConectaDesconecta 
      Caption         =   "DESCONECTA DO SCOPE"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   6120
      TabIndex        =   26
      Top             =   600
      Width           =   3135
   End
   Begin VB.Frame fraPinpad 
      Caption         =   "Acesso a PIN-Pad"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   9.75
         Charset         =   0
         Weight          =   900
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1815
      Left            =   120
      TabIndex        =   18
      Top             =   5640
      Width           =   9135
      Begin VB.CommandButton cmdKey 
         Caption         =   "Capturar Tecla"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   3240
         TabIndex        =   25
         Top             =   1320
         Width           =   2055
      End
      Begin VB.CommandButton cmdPIN 
         Caption         =   "Obter Senha"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   3240
         TabIndex        =   24
         Top             =   840
         Width           =   2055
      End
      Begin VB.CommandButton cmdGetCard 
         Caption         =   "Obtem Cartão"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   6120
         TabIndex        =   23
         Top             =   840
         Width           =   2055
      End
      Begin VB.CommandButton cmdDisplayMsg 
         Caption         =   "Exibe Mensagem"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   6120
         TabIndex        =   22
         Top             =   360
         Width           =   2055
      End
      Begin VB.CommandButton cmdInfo 
         Caption         =   "Informações"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   120
         TabIndex        =   21
         Top             =   840
         Width           =   2055
      End
      Begin VB.CommandButton cmdClose 
         Caption         =   "Fechar PIN-Pad"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   3240
         TabIndex        =   20
         Top             =   360
         Width           =   2055
      End
      Begin VB.CommandButton cmdOpen 
         Caption         =   "Abrir PIN-Pad"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   120
         TabIndex        =   19
         Top             =   360
         Width           =   2055
      End
   End
   Begin MSComctlLib.StatusBar sspStatus 
      Height          =   405
      Left            =   -120
      TabIndex        =   12
      Top             =   9960
      Width           =   7305
      _ExtentX        =   12885
      _ExtentY        =   714
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   11465
            MinWidth        =   11465
         EndProperty
      EndProperty
   End
   Begin VB.Timer trmUnload 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   4800
      Top             =   9000
   End
   Begin mkSiac.maskSiac mskScope 
      Height          =   420
      Index           =   0
      Left            =   1680
      TabIndex        =   0
      Top             =   8760
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   741
      Text            =   "0,00"
      Mask            =   "#.###.###.##0,00"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Palatino Linotype"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Frame fraScope 
      Caption         =   "Tipos de Serviços"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4215
      Left            =   0
      TabIndex        =   11
      Top             =   1200
      Width           =   9255
      Begin VB.OptionButton optscope 
         Caption         =   "Cancela Pré-Autorização Medicamento"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Index           =   23
         Left            =   6960
         TabIndex        =   46
         Top             =   2520
         Width           =   1935
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Pré-Autorização Medicamento"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Index           =   22
         Left            =   6960
         TabIndex        =   45
         Top             =   1920
         Width           =   2055
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Elegibilidade Cartao"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   21
         Left            =   6960
         TabIndex        =   44
         Top             =   1440
         Width           =   2175
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Compra Medicamentos"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   20
         Left            =   6960
         TabIndex        =   41
         Top             =   840
         Width           =   2175
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Consulta Medicamentos"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Index           =   19
         Left            =   6960
         TabIndex        =   36
         Top             =   360
         Width           =   2175
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Atualização de Preços"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   18
         Left            =   3600
         TabIndex        =   35
         Top             =   3000
         Width           =   2055
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Resumo Pagamentos"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   17
         Left            =   120
         TabIndex        =   34
         Top             =   3840
         Width           =   2175
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Consulta AVS"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   16
         Left            =   120
         TabIndex        =   33
         Top             =   3360
         Width           =   2295
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Menu(Outros)"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   15
         Left            =   3600
         TabIndex        =   32
         Top             =   3720
         Width           =   2295
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Consulta Saldo Débito"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   14
         Left            =   3600
         TabIndex        =   31
         Top             =   2520
         Width           =   2295
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Consulta Saldo Crédito"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   13
         Left            =   120
         TabIndex        =   30
         Top             =   3000
         Width           =   2535
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Transação POS"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   12
         Left            =   3600
         TabIndex        =   29
         Top             =   2040
         Width           =   1815
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Atualiza Chip"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   11
         Left            =   120
         TabIndex        =   28
         Top             =   2760
         Width           =   1695
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Recarga de cellular"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   10
         Left            =   120
         TabIndex        =   27
         Top             =   2160
         Width           =   3015
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Pré-Autorização Crédito"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   9
         Left            =   120
         TabIndex        =   17
         Top             =   1080
         Width           =   2655
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Resumo de Vendas"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   8
         Left            =   3600
         TabIndex        =   16
         Top             =   1080
         Width           =   2655
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Consulta CDC"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   7
         Left            =   120
         TabIndex        =   15
         Top             =   1800
         Width           =   2655
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Reimpressão do Comprovante"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   6
         Left            =   3600
         TabIndex        =   14
         Top             =   720
         Width           =   3255
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Garantia e Desconto de Cheque"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   5
         Left            =   3600
         TabIndex        =   8
         Top             =   1440
         Width           =   3255
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Compra c/ cartão de crédito"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   3
         Top             =   360
         Value           =   -1  'True
         Width           =   3015
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Compra c/ cartão de débito"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   4
         Top             =   720
         Width           =   3015
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Cancelamento de Transação"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   2
         Left            =   3600
         TabIndex        =   5
         Top             =   360
         Width           =   2895
      End
      Begin VB.OptionButton optscope 
         Caption         =   "Consulta a Cheque"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   3
         Left            =   3600
         TabIndex        =   6
         Top             =   1800
         Width           =   3015
      End
      Begin VB.OptionButton optscope 
         Caption         =   "CDC"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   4
         Left            =   120
         TabIndex        =   7
         Top             =   1440
         Width           =   2775
      End
   End
   Begin VB.CommandButton cmdScope 
      Caption         =   "&OK"
      Default         =   -1  'True
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   465
      Left            =   7440
      TabIndex        =   2
      Top             =   9000
      Width           =   1695
   End
   Begin mkSiac.maskSiac mskScope 
      Height          =   420
      Index           =   1
      Left            =   1680
      TabIndex        =   1
      Top             =   9240
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   741
      Text            =   "0,00"
      Mask            =   "#.###.##0,00"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Palatino Linotype"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label Label1 
      Caption         =   "Cupom:"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4800
      TabIndex        =   42
      Top             =   8040
      Width           =   735
   End
   Begin VB.Label lblScope 
      AutoSize        =   -1  'True
      Caption         =   "Tipo Convênio:"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   3
      Left            =   360
      TabIndex        =   40
      Top             =   7920
      Width           =   1305
   End
   Begin VB.Label lblScope 
      AutoSize        =   -1  'True
      Caption         =   "PBM:"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   2
      Left            =   1200
      TabIndex        =   38
      Top             =   8400
      Width           =   435
   End
   Begin VB.Image Image2 
      Height          =   345
      Left            =   7560
      Picture         =   "frmScope.frx":0312
      Top             =   120
      Width           =   1680
   End
   Begin VB.Image Image1 
      Height          =   570
      Left            =   0
      Picture         =   "frmScope.frx":139B
      Top             =   0
      Width           =   2040
   End
   Begin VB.Label LbTitulo 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "[Interface Coleta]"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2520
      TabIndex        =   13
      Top             =   120
      Width           =   2415
   End
   Begin VB.Label lblScope 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "Taxa de Seviço:"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   1
      Left            =   120
      TabIndex        =   10
      Top             =   9240
      Width           =   1515
   End
   Begin VB.Label lblScope 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "Valor:"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   0
      Left            =   840
      TabIndex        =   9
      Top             =   8880
      Width           =   765
   End
End
Attribute VB_Name = "frmScope"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Formulario principal

Option Explicit

'Valores relativos aos checkboxes no formulario principal
Enum mnuOpc
    MNU_CREDITO         '00 Compra c/ cartao de credito
    MNU_DEBITO          '01 Compra c/ cartao de debito
    MNU_CANCEL          '02 Cancelamento de transacao
    MNU_CONSCHEQ        '03 Consulta de cheque
    MNU_COMPCDC         '04 Compra CDC
    MNU_GARANTCHEQ      '05 Garantia e desconto de cheque
    MNU_REIMPCOMPON     '06 Reimpressao de comprovante (Online)
    MNU_CONSCDC         '07 Consulta CDC
    MNU_RESUMOPER       '08 Resumo de vendas
    MNU_PREAUTCRED      '09 Pre-autorizacao de credito
    MNU_RECARGCELL      '10 Recarga de cellular
    MNU_ATUALIZA_CHIP   '11 Atualiza chip
    MNU_TRANSACAO_POS   '12 transacao POS
    MNU_CONSULTA_SALDO_CREDITO '13 Saldo Crédito
    MNU_CONSULTA_SALDO_DEBITO '14 Saldo Crédito
    MNU_MENU                   '15 MENU
    MNU_CONSULTA_AVS            '16 consulta AVS
    MNU_RESUMO_PAGAMENTO        '17 resumo pagamento
    MNU_ATUALIZACAO_DE_PRECO    '18 ATUALIZACAO DE PRECO
    MNU_CONSULTA_MEDICAMENTOS   '19 Consulta Medicamentos
    MNU_COMPRA_MEDICAMENTOS     '20 Compra Medicamentos
    MNU_ElEGIBILIDADE_CARTAO    '21 Elegibilidade Cartão
    MNU_PRE_AUTORIZACAO_MEDICAMENTO '22 Pré-Autorização Medicamento
    MNU_CANCELA_PRE_AUTORIZACAO_MEDICAMENTO '23 Pré-Autorização Medicamento
End Enum


'Procedimento para a finalizacao da comunicacao
'com o PPad.
Private Function inicComunic() As Boolean
    Dim lRet        As Long, _
        sTitle      As String, _
        sMsg        As String, _
        bAcao       As Byte, _
        bDesfeito   As Byte

      '  lRet = ScopeOpen("2", gsCompany, gsFilial, gsPos)
        lRet = ScopeOpen("2", "0001", "0001", "001")
        If lRet <> OP_SUCCESS Then
            Select Case lRet
                Case OP_INVMODO:
                    sMsg = "SCOPEOPEN: modo inválido!"
                Case OP_INVCOMPANY:
                    sMsg = "SCOPEOPEN: empresa inválida!"
                Case OP_INVFILIAL:
                    sMsg = "SCOPEOPEN: filial inválida!"
                Case OP_INVPOS:
                    sMsg = "SCOPEOPEN: Pos inválido!"
                Case Else:
                    sMsg = "SCOPEOPEN: Erro [" & CStr(lRet) & "]"
            End Select

            MsgBox sMsg, vbCritical, Me.Caption
            
            inicComunic = False
            Exit Function
        End If

        gbConectado = True

        ' Indica que a aplicacao coletara os dados
        sspStatus.Panels(1).Text = "Definindo API coleta..."
        
        ScopeSetAplColeta

        'Configuracoes do SCoPE
        lRet = ScopeConfigura(CFG_CANCELAR_OPERACAO_PINPAD, 1)

        'Consulta parametros de configuracao do PIN-Pad
        sspStatus.Panels(1).Text = _
                        "Consultando PIN-Pad compartilhado..."
        lRet = ScopeConsultaPP(gbConfigCompartilhado, _
                                    gbExclusivoScope, gbPorta)
        If lRet <> OP_SUCCESS Then
            sMsg = "ScopeConsultaPP: Erro [" & CStr(lRet) & "]"
            MsgBox sMsg, vbCritical, Me.Caption
        End If

        'Inicializa a quantidade de transacoes da sessao de TEF
        giNumTef = 0

        'Abre o PIN-Pad se configurado no ScopeCNF que nao e'
        'exclusivo do Scope
        If gbExclusivoScope = 0 Then
            sspStatus.Panels(1).Text = "Abrindo PIN-Pad..."

            lRet = ScopePPOpen(gbPorta)

            If lRet <> OP_SUCCESS Then
                sspStatus.Panels(1).Text = _
                                "Abrindo PIN-Pad...Falhou!"
                sMsg = "ScopePPOpen: Erro [" & CStr(lRet) & "]"
                MsgBox sMsg, vbCritical, Me.Caption
                
                inicComunic = False
                Exit Function
            End If
        End If

        'Verifica se houve queda de energia
        sspStatus.Panels(1).Text = _
                        "Verificando se houve queda de energia..."

        lRet = ScopeFechaSessaoTEF(0, bDesfeito)

        If lRet <> OP_SUCCESS Then
            sMsg = "ScopeFechaSessaoTEF: Erro [" & CStr(lRet) & "]"
            sspStatus.Panels(1).Text = sMsg
            MsgBox sMsg, vbCritical, Me.Caption
        
            inicComunic = False
            Exit Function
        Else
            If bDesfeito = 1 Then
                MsgBox "Tratou Queda de Energia: Realizou" & _
                        "o desfazimento da(s) TEF(s) apos queda" & _
                                        " de energia. Reter o cupom!"
                sspStatus.Panels(1).Text = _
                    "Realizou o desfazimento da(s) TEF(s) anteriores."
            Else
                sspStatus.Panels(1).Text = _
                            "Não houve transações incompletas."
            End If
    End If

    inicComunic = True
End Function


'Procedimento para a finalizacao da comunicacao
'com o PPad.
Private Sub cmdClose_Click()
    Dim lRet        As Long, _
        PPMsgErro   As String * 50

    lRet = ScopePPClose("  Itautec S.A.       Scope")

    If lRet = PC_OK Then
        MsgBox "PIN-Pad fechado.", vbInformation, Me.Caption

        sspStatus.Panels(1).Text = "Pronto"
    Else
        'Receber a mensagem de erro do SCoPE
        ScopePPMsgErro lRet, PPMsgErro

        MsgBox "Erro ao fechar PIN-Pad. " & PPMsgErro & _
                    "RC = " & lRet, vbExclamation, Me.Caption
    End If
End Sub

'Procedimento para o uso das funcoes de exibicao de
'mensagens no visor do PPad.
Private Sub cmdDisplayMsg_Click()
    Dim lRet        As Long, _
        Mensagem    As String, _
        PPMsgErro   As String * 50
    
    Mensagem = InputBox("Digite a mensagem a ser enviada ao PIN-Pad.", _
                                                "Mensagem para o PIN-Pad")

    If Len(Mensagem) < 10 Then
        lRet = ScopePPDisplayEx("00" & Len(Mensagem) & Mensagem)
    ElseIf Len(Mensagem) < 100 Then
        lRet = ScopePPDisplayEx("0" & Len(Mensagem) & Mensagem)
    Else
        lRet = ScopePPDisplayEx(Len(Mensagem) & Mensagem)
    End If

    If lRet = PC_OK Then
        MsgBox "Mensagem enviada.", vbInformation, Me.Caption

        sspStatus.Panels(1).Text = "Pronto"
    Else
        ScopePPMsgErro lRet, PPMsgErro

        MsgBox "Erro ao enviar mensagem ao PIN-Pad. " & _
                PPMsgErro & "RC = " & lRet, vbExclamation, Me.Caption
    End If
End Sub

'Procedimento para leitura do cartao via funcao
'de gerencicamento do PINPad.
Private Sub cmdGetCard_Click()
    Dim CartaoLen       As Integer, _
        lRet            As Long, _
        PPMsgErro       As String * 50, _
        Cartao          As String * 500, _
        MsgNotificacao  As String * 500

    CartaoLen = 500

    'Inicio do procedimento para leitura do cartao,
    'como '99' (aplicacao credito/debito)
    lRet = ScopePPStartGetCard(99, "0")

    If lRet = PC_OK Then
        sspStatus.Panels(1).Text = "Lendo o cartão..."

        'Repeticao ate' obtencao completa dos dados do
        'cartao
        Do
            lRet = ScopePPGetCard(0, MsgNotificacao, _
                                            CartaoLen, Cartao)

            If lRet = PC_NOTIFY Then
                MsgBox MsgNotificacao, vbInformation, Me.Caption
            End If
        Loop While (lRet = PC_PROCESSING Or lRet = PC_NOTIFY)

        If lRet = 0 Then
            MsgBox "Cartão [" & Left(Cartao, Abs(InStr(Cartao, _
                    Chr(0))) - 1) & "]", vbInformation, Me.Caption
        Else
            ScopePPMsgErro lRet, PPMsgErro

            MsgBox "Erro ao ler o cartão. " & PPMsgErro & _
                        "RC = " & lRet, vbExclamation, Me.Caption
        End If
        sspStatus.Panels(1).Text = "Pronto"
    'Provavel problema na comunicacao com o PPad
    Else
        ScopePPMsgErro lRet, PPMsgErro

        MsgBox "Erro ao ler o cartão. " & PPMsgErro & _
                    "RC = " & lRet, vbExclamation, Me.Caption
    End If
End Sub

'Procedimento para verificacao do status do PPad
Private Sub cmdInfo_Click()
    Dim lRet        As Long, _
        Opcao       As Integer, _
        InfoLen     As Integer, _
        OpcaoStr    As String, _
        Info        As String * 500, _
        PPMsgErro   As String * 50

    InfoLen = 500

    OpcaoStr = InputBox("Qual a informação? (0-PIN-Pad; 1-AMEX;" & _
                            "2-Redecard; 3-Visanet)", "Tipo de dado")

    Opcao = CInt(OpcaoStr)

    'Leitura do status do PPad
    lRet = ScopePPGetInfo(Opcao, InfoLen, Info)

    If lRet = PC_OK Then
        MsgBox "[" & Left(Info, Abs(InStr(Info, Chr(0))) - 1) & "]", _
                                            vbInformation, Me.Caption
        sspStatus.Panels(1).Text = "Pronto"
    Else
        ScopePPMsgErro lRet, PPMsgErro

        MsgBox "Erro ao obter informações do PIN-Pad. " & PPMsgErro & _
                            "RC = " & lRet, vbExclamation, Me.Caption
    End If
End Sub

'Procedimento para o recebimento de teclas sem
'criptografia.
Private Sub cmdKey_Click()
    Dim lRet        As Long, _
        PPMsgErro   As String * 50

    'Inicia o processo
    lRet = ScopePPStartGetKey()

    If lRet = PC_OK Then
        sspStatus.Panels(1).Text = "Lendo tecla do PIN-Pad..."

        'Aguarda o processamento das teclas pelo
        'PPad
        Do
            lRet = ScopePPGetKey()
        Loop While (lRet = PC_PROCESSING)

        If lRet = PC_OK Then
            MsgBox "Tecla " & lRet, vbInformation, Me.Caption
        Else
            ScopePPMsgErro lRet, PPMsgErro

            MsgBox "Erro ao ler tecla. " & PPMsgErro & "RC = " & _
                                    lRet, vbExclamation, Me.Caption
        End If

        sspStatus.Panels(1).Text = "Pronto"
    Else
        ScopePPMsgErro lRet, PPMsgErro

        MsgBox "Erro ao ler tecla. " & PPMsgErro & "RC = " & _
                                lRet, vbExclamation, Me.Caption
    End If
End Sub

'Procedimento para abertura de comunicacao com o
'PPad.
Private Sub cmdOpen_Click()
    Dim lRet        As Long, _
        PPMsgErro   As String * 50

    'Abrir o PPad na serial 1
    lRet = ScopePPOpen(gbPorta)

    If lRet = PC_OK Then
        MsgBox "PIN-Pad aberto.", vbInformation, Me.Caption

        sspStatus.Panels(1).Text = "Pronto"
    Else
        ScopePPMsgErro lRet, PPMsgErro

        MsgBox "Erro ao abrir PIN-Pad. " & PPMsgErro & _
                    "RC = " & lRet, vbExclamation, Me.Caption
    End If
End Sub

'Procedimento para captura da senha via PPad.
Private Sub cmdPIN_Click()
    Dim lRet        As Long, _
        Senha       As String * 32, _
        PPMsgErro   As String * 50

    lRet = ScopePPStartGetPIN("Digite a senha")

    If lRet = PC_OK Then
        sspStatus.Panels(1).Text = "Obtendo senha do PIN-Pad..."

        'Aguardar o processamento do PPad
        Do
            lRet = ScopePPGetPIN(Senha)
        Loop While (lRet = PC_PROCESSING)

        If lRet = PC_OK Then
            MsgBox "Senha [" & Left(Senha, Abs(InStr(Senha, _
                    Chr(0))) - 1) & " ]", vbInformation, Me.Caption
        Else
            ScopePPMsgErro lRet, PPMsgErro

            MsgBox "Erro ao obter senha. RC = " & lRet, _
                                        vbExclamation, Me.Caption
        End If

        sspStatus.Panels(1).Text = "Pronto"
    Else
        ScopePPMsgErro lRet, PPMsgErro

        MsgBox "Erro ao obter senha. RC = " & lRet, _
                                vbExclamation, Me.Caption
    End If
End Sub

'Procedimento para a realizacao da comunicacao com
'o o servidor do SCoPE.
Private Sub cmdConectaDesconecta_Click()
    Dim lRet As Long, _
        sMsg As String

    If gbConectado = True Then
        sspStatus.Panels(1).Text = "Desconectando do Scope..."

        'Primeiro desconecta
        ScopeClose

        cmdConectaDesconecta.Caption = "CONECTA AO SCOPE"
        sspStatus.Panels(1).Text = "Desconectado do Scope!"
        gbConectado = False

        'Fecha a comunicacao com o PPad
        ScopePPClose "  Itautec S.A.       Scope"
    ElseIf gbConectado = False Then
        If inicComunic() = True Then
            cmdConectaDesconecta.Caption = "DESCONECTA DO SCOPE"
        End If
    End If
End Sub

'Procedimento para execucao das funcoes/transacoes do
'SCoPE
Private Sub cmdScope_Click()
    Dim sValor      As String, _
        sTaxa       As String, _
        lRet        As Long, _
        dValor      As Double, _
        HaMaisTEF   As Integer, _
        Confimar    As Integer
    
    sspStatus.Panels(1).Text = " Efetuando transação..."
    
    dValor = CDbl(mskScope(0).Text) * 100
    sValor = CStr(dValor)
        
    dValor = CDbl(mskScope(1).Text) * 100
    sTaxa = CStr(dValor)

    If giNumTef = 0 Then
        lRet = ScopeAbreSessaoTEF()
    End If

    If optscope(MNU_CREDITO).Value Then
        lRet = ScopeCompraCartaoCredito(sValor, sTaxa)
    ElseIf optscope(MNU_DEBITO).Value Then
        lRet = ScopeCompraCartaoDebito(sValor)
    ElseIf optscope(MNU_CANCEL).Value Then
        lRet = ScopeCancelamento(sValor, sTaxa)
    ElseIf optscope(MNU_CONSCHEQ).Value Then
        lRet = ScopeConsultaCheque(sValor)
    ElseIf optscope(MNU_COMPCDC).Value Then
        lRet = ScopeCompraCDC(sValor)
    ElseIf optscope(MNU_GARANTCHEQ).Value Then
        lRet = ScopeGarantiaDescontoCheque(sValor)
    ElseIf optscope(MNU_REIMPCOMPON).Value Then
        lRet = ScopeReimpressaoComprovante()
    ElseIf optscope(MNU_CONSCDC).Value Then
        lRet = ScopeConsultaCDC(sValor, sTaxa)
    ElseIf optscope(MNU_RESUMOPER).Value Then
        lRet = ScopeResumoVendas()
    ElseIf optscope(MNU_PREAUTCRED).Value Then
        lRet = ScopePreAutorizacaoCredito(sValor, sTaxa)
    ElseIf optscope(MNU_RECARGCELL).Value Then
        lRet = ScopeRecargaCelular()
    ElseIf optscope(MNU_ATUALIZA_CHIP).Value Then
        lRet = ScopeAtualizaParametrosChip("", "")
    ElseIf optscope(MNU_TRANSACAO_POS).Value Then
       'Atencao só  é passado string vazia quando o valor é zerado
        lRet = ScopeTransacaoPOS(sValor, 0, 0, 0)
    ElseIf optscope(MNU_CONSULTA_SALDO_CREDITO).Value Then
       lRet = ScopeConsultaSaldoCredito()
    ElseIf optscope(MNU_CONSULTA_SALDO_DEBITO).Value Then
      lRet = ScopeConsultaSaldoDebito(sValor)
    ElseIf optscope(MNU_MENU).Value Then
      lRet = ScopeMenu(0)
    ElseIf optscope(MNU_CONSULTA_AVS).Value Then
      lRet = ScopeConsultaAVS()
    ElseIf optscope(MNU_RESUMO_PAGAMENTO).Value Then
      lRet = ScopeResumoOperacoes(S_RESUMO_PAGAMENTOS, B_REDECARD)
    ElseIf optscope(MNU_ATUALIZACAO_DE_PRECO).Value Then
      'Bandeira = 228
      lRet = ScopeAtualizaPrecosMercadorias(228, "") 'Atualizacao de Precos de Mercadorias Ticket
    ElseIf optscope(MNU_CONSULTA_MEDICAMENTOS).Value Then
        lRet = ScopeConsultaMedicamento(cboConvenio.ListIndex, cboPBM.ListIndex + 1)
    ElseIf optscope(MNU_COMPRA_MEDICAMENTOS).Value Then
        If txtCupom.Text = "" Then
            MsgBox "Favor informar o Cupom Fiscal", vbInformation
            txtCupom.SetFocus
            Exit Sub
        Else
            lRet = ScopeCompraMedicamento(cboConvenio.ListIndex, cboPBM.ListIndex + 1, txtCupom.Text)
         End If
    ElseIf optscope(MNU_ElEGIBILIDADE_CARTAO).Value Then
        If (cboPBM.ListIndex + 1 <> 10) Then
            MsgBox "Opção válida apenas para a rede PharmaSystem"
        Else
             lRet = ScopeElegibilidadeCartao(cboConvenio.ListIndex, cboPBM.ListIndex + 1)
        End If
    ElseIf optscope(MNU_PRE_AUTORIZACAO_MEDICAMENTO) Then
        If (cboPBM.ListIndex + 1 <> 10) Then
            MsgBox "Opção válida apenas para a rede PharmaSystem"
            Exit Sub
        Else
             lRet = ScopePreAutorizacaoMedicamento(cboConvenio.ListIndex, cboPBM.ListIndex + 1)
        End If

    ElseIf optscope(MNU_CANCELA_PRE_AUTORIZACAO_MEDICAMENTO) Then
        
        If (cboPBM.ListIndex + 1 <> 10) Then
            MsgBox "Opção válida apenas para a rede PharmaSystem"
            Exit Sub
        Else
             lRet = ScopeCancelaPreAutMedicamento(cboConvenio.ListIndex, cboPBM.ListIndex + 1)
        End If
    End If

    If lRet = TR_SERVEROFF Then
        MsgBox "A transação foi cancelada! Servidor " & _
                "encontra-se off-line! (RC=" & lRet & ")", _
                                    vbExclamation, Me.Caption
        sspStatus.Panels(1).Text = " Pronto"
    Else
        'Executa a transacao
        FrmColeta.Show vbModal, Me

        'Verificando o estado do SCoPE
        lRet = ScopeStatus

        'Decide se encerra ou realiza mais TEFs na mesma sessao
        HaMaisTEF = vbNo
        HaMaisTEF = MsgBox("Há outra TEF para esta mesma sessão?", _
                                            vbYesNo, "Encerra TEF?")

        If HaMaisTEF = vbNo Then
            'Cancelado nao pelo operador
            If lRet <> RCS_CANCELADA_PELO_OPERADOR Or _
                    giNumTef > 0 Then

                Confimar = MsgBox("Confirmar a(s) transação(ões)?", _
                                    vbYesNo, "Confirma ou desfaz?")
                If Confimar = vbYes Then
                    gbAcao = 1
                    sspStatus.Panels(1).Text = _
                                    "Confirmando transação(ões)"
                Else
                    gbAcao = 0
                    sspStatus.Panels(1).Text = _
                                    "Desfazendo transação(ões)"
                End If

                lRet = ScopeFechaSessaoTEF(gbAcao, gbDesfezTransacao)

                If lRet <> OP_SUCCESS Then
                    sspStatus.Panels(1).Text = _
                        "Erro ao encerrar sessão. Retorno = " & lRet
                End If

                giNumTef = 0
            End If
        Else
            ' Cancelado pelo operador
            If lRet <> RCS_CANCELADA_PELO_OPERADOR Then
                giNumTef = giNumTef + 1
            End If
        End If
    End If
End Sub

'Procedimento para inicializacao e tratamento de
'estados especificos do SCoPE.
Private Sub Form_Load()
    Dim lRet        As Long, _
        sTitle      As String, _
        sMsg        As String, _
        bAcao       As Byte, _
        bDesfeito   As Byte

    If App.PrevInstance Then
        'Ativa instancia anterior
        sTitle = Me.Caption
        Me.Caption = "teste"
        AppActivate sTitle
        Unload Me
        Exit Sub
    End If

    'debug
    'ChDir ("C:\SCOPE\32")
    
    Me.Top = 0
    Me.Left = 0

    gsSecao = "HotKey (Interface Coleta)"
    gsKeyCompany = "Empresa"
    gsKeyFilial = "Filial"
    gsKeyPos = "Pos"

    Show

    mskScope(0).Text = ""
    mskScope(1).Text = ""
    
    ' carrega a lista de PBM
    cboPBM.Enabled = True
    cboPBM.AddItem "01 - e-Pharma", 0
    cboPBM.AddItem "02 - Vidalink", 1
    cboPBM.AddItem "03 - PrevSaude", 2
    cboPBM.AddItem "04 - FuncionalCard", 3
    cboPBM.AddItem "05 - GoodCard", 4
    cboPBM.AddItem "06 - Novartis", 5
    cboPBM.AddItem "07 - FlexMed", 6
    cboPBM.AddItem "08 - Datasus", 7
    cboPBM.AddItem "09 - Farmaseg", 8
    cboPBM.AddItem "10 - PharmaSystem", 9
    cboPBM.AddItem "11 - PBMPadrao", 10
    cboPBM.ListIndex = 0
    
     ' tipo Convênio PBM
    cboConvenio.Enabled = True
    cboConvenio.AddItem "0 - PBM", 0
    cboConvenio.AddItem "01 - Empresa", 1
    cboConvenio.ListIndex = 0

    If ProcessCommandLine Then
        inicComunic
    End If
End Sub

'Procedimento para finalizacao da aplicacao - funcao padrao
'do MS-VB
'@param Cancel
'@param UnloadMode
Private Sub Form_QueryUnload(Cancel As Integer, _
                                    UnloadMode As Integer)
    If UnloadMode = vbFormControlMenu Then
        sspStatus.Panels(1).Text = _
                        " Finalizando a aplicação..."

        Me.Enabled = False
        cmdScope.Enabled = False
        trmUnload.Enabled = True

        Cancel = 1
    End If
End Sub

'Procedimento para atualizacao de componentes
'visuais - evento Click
Private Sub optScope_Click(Index As Integer)
    Dim bEnabled As Boolean

    'Servico de Credito ou Cancelamento de Transacao
    If Index = MNU_CREDITO Or Index = MNU_CANCEL Or _
        Index = MNU_CONSCDC Or Index = MNU_RESUMOPER Then
        bEnabled = optscope(Index).Value
    Else
        bEnabled = False
    End If

    lblScope(1).Enabled = bEnabled
    mskScope(1).Enabled = bEnabled

    If Index = MNU_PREAUTCRED Or _
            Index = MNU_REIMPCOMPON Then
        lblScope(0).Enabled = False
        mskScope(0).Enabled = False
    Else
        lblScope(0).Enabled = True
        mskScope(0).Enabled = True
    End If
End Sub

'Procedimento para finalizacao do processo de
'comunicacao/transacao com o servidor SCoPE.
Private Sub trmUnload_Timer()
    Dim lRet As Long

    If ScopeStatus <> ST_PROGRESS Then
        If gbConectado = False Then
            gbConectado = 3
        End If

        cmdConectaDesconecta_Click

        trmUnload.Enabled = False

        Unload Me
        Unload FrmCupom
        Unload FrmColeta
    End If
    
End Sub
