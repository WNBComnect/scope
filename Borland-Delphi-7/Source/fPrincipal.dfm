object frmPrincipal: TfrmPrincipal
  Left = 253
  Top = 212
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Consulta de TEF'
  ClientHeight = 232
  ClientWidth = 337
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
    Top = 128
    Width = 24
    Height = 13
    Caption = 'Valor'
  end
  object lbTaxa: TLabel
    Left = 169
    Top = 128
    Width = 24
    Height = 13
    Caption = 'Taxa'
  end
  object rgpOpcoes: TRadioGroup
    Left = 5
    Top = 0
    Width = 324
    Height = 121
    Caption = ' Op'#231#245'es '
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
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 213
    Width = 337
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object btnOk: TBitBtn
    Left = 36
    Top = 180
    Width = 82
    Height = 25
    Caption = '&OK'
    TabOrder = 3
    OnClick = btnOkClick
    Kind = bkOK
  end
  object btnCancela: TBitBtn
    Left = 220
    Top = 180
    Width = 82
    Height = 25
    Caption = '&Cancelar'
    TabOrder = 4
    OnClick = btnCancelaClick
    Kind = bkCancel
  end
  object eTaxa: TEdit
    Left = 169
    Top = 144
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object eValor: TEdit
    Left = 8
    Top = 144
    Width = 121
    Height = 21
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 0
    Text = '1000'
  end
end
