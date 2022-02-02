object frmPrincipal: TfrmPrincipal
  Left = 253
  Top = 212
  BorderStyle = bsDialog
  Caption = 'Consulta de TEF'
  ClientHeight = 299
  ClientWidth = 678
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbValor: TLabel
    Left = 8
    Top = 189
    Width = 24
    Height = 13
    Caption = 'Valor'
  end
  object lbTaxa: TLabel
    Left = 169
    Top = 189
    Width = 24
    Height = 13
    Caption = 'Taxa'
  end
  object rgpOpcoes: TRadioGroup
    Left = 5
    Top = 0
    Width = 324
    Height = 183
    Caption = 'OP'#199#213'ES'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Cart'#227'o Cr'#233'dito'
      'Cart'#227'o D'#233'bito'
      'Pagamento'
      'Consulta CDC'
      'Cheque'
      'Cancelamento de Transa'#231#227'o'
      'Reimpress'#227'o Comprovante'
      'Resumo de Vendas'
      'Recarga de Celular'
      'Pre-Autoriza'#231#227'o de Cr'#233'dito')
    TabOrder = 2
    OnClick = rgpOpcoesClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 280
    Width = 678
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object btnOk: TBitBtn
    Left = 135
    Top = 235
    Width = 82
    Height = 25
    Caption = '&OK'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancela: TBitBtn
    Left = 228
    Top = 235
    Width = 82
    Height = 25
    Caption = '&Cancelar'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 4
    OnClick = btnCancelaClick
  end
  object eTaxa: TEdit
    Left = 169
    Top = 208
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 1
    Text = '0'
  end
  object eValor: TEdit
    Left = 8
    Top = 208
    Width = 121
    Height = 21
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 0
    Text = '1000'
  end
  object GroupBox1: TGroupBox
    Left = 335
    Top = 0
    Width = 338
    Height = 274
    Caption = 'IMPRESSORA'
    TabOrder = 6
    object Button1: TButton
      Left = 260
      Top = 235
      Width = 75
      Height = 25
      Caption = 'Limpar'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Impressora: TMemo
      Left = 3
      Top = 16
      Width = 332
      Height = 213
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      Lines.Strings = (
        'Impressora')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object ProgressBar: TProgressBar
    Left = 526
    Top = 280
    Width = 152
    Height = 17
    TabOrder = 7
  end
end
