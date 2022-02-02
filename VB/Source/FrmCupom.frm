VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form FrmCupom 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Cupom"
   ClientHeight    =   6480
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5175
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6480
   ScaleWidth      =   5175
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
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
      Left            =   1920
      TabIndex        =   1
      Top             =   6000
      Width           =   1095
   End
   Begin VB.Frame FrameCupom 
      Height          =   5655
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4935
      Begin RichTextLib.RichTextBox RtbCupom 
         Height          =   5295
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   4695
         _ExtentX        =   8281
         _ExtentY        =   9340
         _Version        =   393217
         BackColor       =   -2147483633
         BorderStyle     =   0
         Enabled         =   -1  'True
         ScrollBars      =   2
         Appearance      =   0
         TextRTF         =   $"FrmCupom.frx":0000
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
      End
   End
End
Attribute VB_Name = "FrmCupom"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Formulario demonstrando a aparencia do cupom impresso.

Option Explicit

'Procedimento para continuidade do fluxo de impressao.
Private Sub BtnOk_Click()
    Me.Hide
    FrmColeta.ResumeColeta (ACAO_PROXIMO)
End Sub
