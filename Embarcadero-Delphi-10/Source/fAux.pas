unit fAux;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Mask, StrUtils;

type
  TfrmAux = class(TForm)
    btnBack: TSpeedButton;
    btnForw: TSpeedButton;
    btnCancel: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    lbOperador: TLabel;
    lbClient: TLabel;
    lbTextoEntr: TLabel;
    memoOper: TMemo;
    memoClient: TMemo;
    memoMsg: TMemo;
    cbTextoEntr: TMaskEdit;
    procedure btnBackClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnForwClick(Sender: TObject);
    procedure cbTextoEntrKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    sTxt:   string;
    wMode:  Word;
  public
    { Public declarations }
  end;

var
  frmAux: TfrmAux;

  function execFormAux (sMsgOp1, sMsgOp2, sMsgCli1, sMsgCli2, sEntr: string;
                        iBotExib: LongInt): string;
  function frmAuxParallelCtl (bAction: Byte; pRet: PByte): string;

implementation

uses
  clTef;

{$R *.dfm}


procedure TfrmAux.btnBackClick(Sender: TObject);
begin
  // Indicar a selecao do usuario
  iSinc := iSinc or ACAO_ANTER;

  Close;
end;

procedure TfrmAux.btnCancelClick(Sender: TObject);
begin
  // Indicar a selecao do usuario
  iSinc := iSinc or ACAO_CANCELAR;

  Close;
end;

procedure TfrmAux.btnForwClick(Sender: TObject);
begin
  // Indicar a selecao do usuario
  iSinc := iSinc or ACAO_PROX;

  Close;
end;


{
  A funcao ira' exibir o dialogo de acordo com os parametros passados.

  @param  sMsgOp1   Primeira linha da mensagem 'a ser exibida para o operador.
  @param  sMsgOp2   Segunda linha da mensagem 'a ser exibida para o operador.
  @param  sMsgCli1  Primeira linha da mensagem 'a ser exibida para o cliente.
  @param  sMsgCli2  Segunda linha da mensagem 'a ser exibida para o cliente.
  @param  sEntr     O texto 'a ser exibido no label da edit box. Caso seu
                    valor seja '', a edit box sera' desabilitada.
                    Caso a operacao (iBotExib and BIT7_ON) seja verdadeira,
                    o texto existente nessa variavel sera' posto na memo de
                    exibicao.
  @param  iBotExib  Os botoes 'a serem exibidos (os valores podem ser somados):
                    - 1: Cancelar
                    - 2: Proximo
                    - 4: Retornar
                    - BIT7_ON: Colocar o texto da sEntr no memo de exibicao.
                    - BIT8_ON: O texto da edit box ficara' no modo senha.
                    - BIT9_ON: Iniciar a janela de coleta em modo paralelo.
                               Apos essa chamada, p/ verificacao do status
                               da mesma, utilize a funcao frmAuxParallelCtl.

  @return Qdo sEntr <> '', o valor digitado pelo usr.
}

function execFormAux (sMsgOp1, sMsgOp2, sMsgCli1, sMsgCli2, sEntr: string;
                      iBotExib: LongInt): string;
var
  sStr:   string;
  iPos,
  iTam,
  iIni:   LongInt;

begin
  iPos := 1;
  iIni := 1;
  iTam := 1;

  { Incondicionalm/te reinicializar os vals
    usados pelo formulario qdo em modo paralelo }
  frmAux.sTxt := '';
  frmAux.wMode := 0;

  if (iBotExib and BIT7_ON) <> 0 then
  begin
    frmAux.PageControl1.ActivePageIndex := 1;

    frmAux.memoMsg.Lines.Clear;

    { Cada CR encontrado na string passada sera' 1 linha
      no memo de exibicao }
    while (iPos - 1) < Length (sEntr) do
    begin
      if sEntr [iPos] = #10 then
      begin
        sStr := MidStr (sEntr, iIni, iTam - 1);
        frmAux.memoMsg.Lines.Add (sStr);

        iIni := iPos + 1;
        iTam := 0;
        sStr := '';
      end;

      iPos := iPos + 1;

      // Pular os caracteres nulos
      if iPos >= Length (sEntr) then
        break
      else
        iTam := iTam + 1;
    end;

    frmAux.lbTextoEntr.Caption := 'Coleta:';
    frmAux.cbTextoEntr.Enabled := True;
  end
  else
  begin
    frmAux.PageControl1.ActivePageIndex := 0;

    // Tratar o inputbox
    if (Length (sEntr) > 0) then
    begin
      frmAux.lbTextoEntr.Caption := sEntr;
      frmAux.cbTextoEntr.Enabled := True;

      // Modo senha?
      if (iBotExib and BIT8_ON) <> 0 then
        frmAux.cbTextoEntr.PasswordChar := '*'
      else
        frmAux.cbTextoEntr.PasswordChar := #0;
    end
    else
    begin
      frmAux.lbTextoEntr.Caption := 'Desabilitado';
      frmAux.cbTextoEntr.Enabled := False;
    end;
  end;

  frmAux.memoOper.Lines.Clear;
  frmAux.memoClient.Lines.Clear;
  frmAux.cbTextoEntr.Clear;

  frmAux.memoOper.Lines.Add (sMsgOp1);
  frmAux.memoOper.Lines.Add (sMsgOp2);

  frmAux.memoClient.Lines.Add (sMsgCli1);
  frmAux.memoClient.Lines.Add (sMsgCli2);

  // Mudar o estado dos botoes
  if (iBotExib and 1) <> 0 then
    frmAux.btnCancel.Visible := True
  else
    frmAux.btnCancel.Visible := False;

  if ( (iBotExib and (1 + 2 + 4) = 0) or
        ( (iBotExib and 2) <> 0) ) then
    frmAux.btnForw.Visible := True
  else
    frmAux.btnForw.Visible := False;

  if (iBotExib and 4) <> 0 then
    frmAux.btnBack.Visible := True
  else
    frmAux.btnBack.Visible := False;

  if (iBotExib and BIT9_ON) <> 0 then
    frmAuxParallelCtl (1, nil)
  else
  begin
    // Forcar o fecham/to da janela em modo paralelo
    frmAuxParallelCtl (0, nil);

    frmAux.ShowModal;
  end;

  Result := frmAux.sTxt;
end;


{
  Tratar as teclas ESC e ENTER.
}

procedure TfrmAux.cbTextoEntrKeyDown(Sender: TObject; var Key: Word;
                                                      Shift: TShiftState);
begin
  if Key = $0D then           // Enter
    btnForwClick (Sender)
  else if Key = $1B then      // Esc
    btnCancelClick (Sender);
end;

procedure TfrmAux.FormShow(Sender: TObject);
begin
  btnCancel.Glyph.TransparentColor := clNone;

  cbTextoEntr.Text := '';
end;


{
  Funcao auxiliar p/ exibicao da janela de coleta em modo assincrono (paralela).

  @param      bAction A acao 'a ser realizada na janela. Os vals possiveis:
                      - 0: fechar a janela (cancelar a operacao).
                      - 1: exibir a janela (iniciar uma operacao paralela).
                      - 2: status da janela.
  @param[out] pRet    Ponteiro p/ armazenam/to da execucao da funcao.
                      Os vals podem ser:
                      - 0: sucesso.
                      - 1: erro/a janela nao esta' em exibicao.
                      - 2: janela em exibicao.

  @return     O valor digitado pelo usuario.
}

function frmAuxParallelCtl (bAction: Byte; pRet: PByte): string;
var
  bRet: Byte;

begin
  bRet := 0;

  if (frmAux.Visible) then
  begin
    // Fechar a janela
    if (bAction = 0) then
    begin
      if (fsModal in frmAux.FFormState) then
        frmAux.Close
      else
        frmAux.Hide;
    end
    // Foi pedido p/ exibir a janela, qdo ela ja' esta' em exibicao
{    else if bAction = 1 then
      bRet := 1  // Erro}
    else
    // Status da janela
        bRet := 2; // Erro
  end
  else
  begin
    // Foi pedido p/ fechar a janela qdo ela ja' esta' fechada
    if ( (bAction = 0) or
        ( (bAction = 2) and ( Length (frmAux.sTxt) = 0 ) ) ) then
      bRet := 1 // Erro
    // Exibir a janela
    else if bAction = 1 then
    begin
      frmAux.wMode := 1;

      frmAux.Show;
    end;
  end;

  if (pRet <> nil) then
    CopyMemory ( pRet, @bRet, SizeOf (Byte) );

  Result := frmAux.sTxt;
end;

procedure TfrmAux.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Qdo em modo paralelo, qdo a janela for fechada, vamos armazenar
    o texto digitado na edit box
  if wMode = 1 then }
    sTxt := string (cbTextoEntr.Text);
end;

end.
