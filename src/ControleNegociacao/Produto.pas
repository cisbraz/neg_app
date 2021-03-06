unit Produto;

interface

uses
  Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CadastroBase, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, CurrencyEdit;

type
  TuFrmProduto = class(TuFrmBase)
    lblCodigo: TLabel;
    lblNomeProduto: TLabel;
    lblPreco: TLabel;
    edtCodigo: TCurrencyEdit;
    edtNomeProduto: TEdit;
    edtPreco: TCurrencyEdit;
    chkAtivo: TCheckBox;
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure chkAtivoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure Controle(AEditando: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  uFrmProduto: TuFrmProduto;

implementation

{$R *.dfm}

uses Funcoes, Persistencia, ModuloCadastro;

procedure TuFrmProduto.btnCancelarClick(Sender: TObject);
begin
  if (not edtCodigo.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      Controle(False);
    end;
  end;
end;

procedure TuFrmProduto.btnExcluirClick(Sender: TObject);
begin
  inherited;
  if (edtCodigo.Value > 0) then begin
    if Questionar('Deseja realmente excluir o registro?') then begin
      if (UsoProduto(edtCodigo.Value)) then begin
        Exclamar('N�o � poss�vel excluir produto, foi utilizado em negocia��o!');
        Exit;
      end;

      try
        Excluir('PRODUTO',
               ['PRODUTO_ID'],
               [edtCodigo.Value]);
        Informar('Excluido com sucesso!');
        Controle(False);
      except
        raise;
      end;
    end;
  end;
end;

procedure TuFrmProduto.btnFecharClick(Sender: TObject);
begin
  if (not edtCodigo.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      inherited;
    end;
  end else begin
    inherited;
  end;
end;

procedure TuFrmProduto.btnGravarClick(Sender: TObject);
begin
  inherited;
  if (edtNomeProduto.Text = EmptyStr) then begin
    Exclamar('O nome do produto deve ser informado!');
    edtNomeProduto.SetFocus;
    Abort;
  end;

  if (edtPreco.Value <= 0) then begin
    Exclamar('O pre�o dever� ser informado!');
    edtPreco.SetFocus;
    Abort;
  end;

  if (edtCodigo.Value = 0) then begin
    Incluir('PRODUTO',
            ['NOME_PRODUTO',
             'PRECO_UNITARIO',
             'ATIVO'],
            [edtNomeProduto.Text,
             edtPreco.Value,
             IffStr(chkAtivo.Checked, 'S', 'N')]);
  end else begin
    Alterar('PRODUTO',
            ['PRODUTO_ID'],
             [edtCodigo.Value],
            ['NOME_PRODUTO',
             'PRECO_UNITARIO',
             'ATIVO'],
            [edtNomeProduto.Text,
             edtPreco.Value,
             IffStr(chkAtivo.Checked, 'S', 'N')]);
  end;
  Informar('Gravado com sucesso!');
  Controle(False);
end;

procedure TuFrmProduto.btnPesquisarClick(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
begin
  inherited;
  key := VK_RETURN;
  shift := [];
  if (dtmCadastro.psqProduto.Executar = mrYes) then begin
    edtCodigo.Value := dtmCadastro.qryProdutoPRODUTO_ID.AsFloat;
    edtCodigoKeyDown(edtCodigo,key,shift);
  end;
end;

procedure TuFrmProduto.chkAtivoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_return) then begin
    perform(40,0,0);
  end;
end;

procedure TuFrmProduto.Controle(AEditando: Boolean);
begin
  btnGravar.Enabled := AEditando;
  btnCancelar.Enabled := AEditando;
  edtCodigo.Enabled := not AEditando;
  btnPesquisar.Enabled := not AEditando;
  edtNomeProduto.Enabled := AEditando;
  edtPreco.Enabled := AEditando;
  chkAtivo.Enabled := AEditando;

  if AEditando then begin
    btnExcluir.Enabled := (edtCodigo.Value > 0);
    edtNomeProduto.SetFocus;
  end else begin
    btnExcluir.Enabled := False;
    chkAtivo.Checked := True;
    edtCodigo.Clear;
    edtNomeProduto.Clear;
    edtCodigo.SetFocus;
    edtPreco.Clear;
  end;
end;

procedure TuFrmProduto.edtCodigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (key = VK_RETURN) then begin
    if (edtCodigo.Value = 0) then begin
      Controle(True);
      edtNomeProduto.SetFocus;
    end else begin
      if (dtmCadastro.psqProduto.Pesquisar(0, edtCodigo.Value) = mrYes) then begin
        edtNomeProduto.Text := dtmCadastro.qryProdutoNOME_PRODUTO.AsString;
        edtPreco.Value := dtmCadastro.qryProdutoPRECO_UNITARIO.AsFloat;
        chkAtivo.Checked := (dtmCadastro.qryProdutoATIVO.AsString = 'S');
        Controle(True);
      end else begin
        Exclamar('Produto n�o existe!');
        edtCodigo.SelectAll;
        Abort;
      end;
    end;
  end;
end;

procedure TuFrmProduto.FormShow(Sender: TObject);
begin
  inherited;
  Controle(False);
end;

end.
