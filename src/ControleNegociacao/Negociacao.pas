unit Negociacao;

interface

uses
  Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CadastroBase, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, Data.DB, Vcl.Grids, Vcl.DBGrids,
  CurrencyEdit, Datasnap.DBClient, HTTPApp, IdHTTP, IdMultipartFormData,
  Vcl.ExtCtrls;

type
  TuFrmNegociacao = class(TForm)
    lblCnpjDistribuidor: TLabel;
    edtCnpjDistribuidor: TMaskEdit;
    btnDistribuidor: TSpeedButton;
    edtRSDistribuidor: TEdit;
    lblRSDistribuidor: TLabel;
    edtRSProdutor: TEdit;
    lblRSProdutor: TLabel;
    btnProdutor: TSpeedButton;
    chkPFProdutor: TCheckBox;
    edtCnpjProdutor: TMaskEdit;
    lblCnpjProdutor: TLabel;
    lblStatus: TLabel;
    grdDistribuidor: TDBGrid;
    lblProduto: TLabel;
    edtProduto: TCurrencyEdit;
    lblNomeProduto: TLabel;
    edtNomeProduto: TEdit;
    lblPreco: TLabel;
    edtPreco: TCurrencyEdit;
    edtQtde: TCurrencyEdit;
    lblQuantidade: TLabel;
    btnAdItem: TSpeedButton;
    btnExItem: TSpeedButton;
    lblValorTotal: TLabel;
    GroupBox1: TGroupBox;
    lblDtCadastro: TLabel;
    lblDtAprovacao: TLabel;
    lblDtConclusao: TLabel;
    lblDtCancelamento: TLabel;
    lblCadastro: TLabel;
    lblAprovacao: TLabel;
    lblConclusao: TLabel;
    lblCancelamento: TLabel;
    edtCodigo: TCurrencyEdit;
    lblCodigo: TLabel;
    cbrMenu: TCoolBar;
    tbrMenu: TToolBar;
    btnAprovar: TToolButton;
    btnGravar: TToolButton;
    btnCancelarNegociacao: TToolButton;
    tbtSeparador: TToolButton;
    btnPesquisar: TToolButton;
    ToolButton1: TToolButton;
    ToolButton8: TToolButton;
    btnFechar: TToolButton;
    btnCancelar: TToolButton;
    cdsItensNegociacao: TClientDataSet;
    dtsItensNegociacao: TDataSource;
    cdsItensNegociacaoPRODUTO_ID: TFloatField;
    cdsItensNegociacaoNOME_PRODUTO: TStringField;
    cdsItensNegociacaoQUANTIDADE: TFloatField;
    cdsItensNegociacaoPRECO: TFloatField;
    cdsItensNegociacaoTOTAL_ITEM: TFloatField;
    cdsItensNegociacaoITEM_NEGOCIACAO: TFloatField;
    cdsItensNegociacaoOPERACAO: TStringField;
    btnProduto: TSpeedButton;
    btnConcluir: TToolButton;
    pnlAtualizar: TPanel;
    tmrAtualizar: TTimer;
    tmrMinuto: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExItemClick(Sender: TObject);
    procedure btnAdItemClick(Sender: TObject);
    procedure edtProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnProdutoClick(Sender: TObject);
    procedure edtCnpjProdutorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkPFProdutorClick(Sender: TObject);
    procedure btnProdutorClick(Sender: TObject);
    procedure edtCnpjDistribuidorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnDistribuidorClick(Sender: TObject);
    procedure chkSolicitarAprovacaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtQtdeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAprovarClick(Sender: TObject);
    procedure btnConcluirClick(Sender: TObject);
    procedure btnCancelarNegociacaoClick(Sender: TObject);
    procedure tmrMinutoTimer(Sender: TObject);
    procedure tmrAtualizarTimer(Sender: TObject);
  private
    MinutosAtualizar : Integer;
    procedure Controle(AEditando: Boolean; AConcluido: Boolean = False);
    function Validar: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure EditarNegociacao(ACodigo : Double);

var
  uFrmNegociacao: TuFrmNegociacao;

implementation

{$R *.dfm}

uses Menu, Funcoes, ModuloCadastro, Persistencia, cParametro;

procedure EditarNegociacao(ACodigo : Double);
var
  key : Word;
  shift : TShiftState;
begin
  key := vk_return;
  shift := [];
  uFrmNegociacao := TuFrmNegociacao.Create(nil);
  uFrmNegociacao.Show;
  uFrmNegociacao.edtCodigo.Value := ACodigo;
  uFrmNegociacao.edtCodigoKeyDown(uFrmNegociacao.edtCodigo, key, shift);
end;

procedure TuFrmNegociacao.btnExItemClick(Sender: TObject);
begin
  if (cdsItensNegociacao.RecordCount > 0) then begin
    cdsItensNegociacao.Edit;
    cdsItensNegociacaoOPERACAO.AsString := 'E';
    cdsItensNegociacao.Post;
  end;
end;

procedure TuFrmNegociacao.btnFecharClick(Sender: TObject);
begin
  if (not edtCodigo.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      Close;
    end;
  end else begin
    Close;
  end;
end;

function TuFrmNegociacao.Validar: Boolean;
begin
  if chkPFProdutor.Checked then begin
    if not isCPF(Numeros(edtCnpjProdutor.Text)) then begin
      Exclamar('CPF produtor inv�lido!');
      edtCnpjProdutor.SetFocus;
      edtCnpjProdutor.SelectAll;
      Exit(False);
    end;
  end else begin
    if not isCNPJ(Numeros(edtCnpjProdutor.Text)) then begin
      Exclamar('CNPJ produtor inv�lido!');
      edtCnpjProdutor.SetFocus;
      edtCnpjProdutor.SelectAll;
      Exit(False);
    end;
  end;

  if (dtmCadastro.psqProdutor.Pesquisar(0, edtCnpjProdutor.Text) <> mrYes) then begin
    Exclamar('Produtor n�o encontrado!');
    edtCnpjProdutor.SetFocus;
    edtCnpjProdutor.SelectAll;
    Exit(False);
  end;

  if not isCNPJ(Numeros(edtCnpjDistribuidor.Text)) then begin
    Exclamar('CNPJ distribuidor inv�lido!');
    edtCnpjDistribuidor.SetFocus;
    edtCnpjDistribuidor.SelectAll;
    Exit(False);
  end;

  if (dtmCadastro.psqDistribuidor.Pesquisar(0, edtCnpjDistribuidor.Text) <> mrYes) then begin
    Exclamar('Distribuidor n�o encontrado!');
    edtCnpjDistribuidor.SetFocus;
    edtCnpjDistribuidor.SelectAll;
    Exit(False);
  end;

  if (cdsItensNegociacao.IsEmpty) then begin
    Exclamar('Negocia��o dever� conter pelo menos um item!');
    edtProduto.SetFocus;
    edtProduto.SelectAll;
    Exit(False);
  end;
  Result := True;
end;

procedure TuFrmNegociacao.btnGravarClick(Sender: TObject);
var
  NegociacaoId : Double;
begin
  if not Validar then Exit;
  if (edtCodigo.Value = 0) then begin
    NegociacaoId := NextVal('SEQ_NEGOCIACAO');
    if (NegociacaoId > 0) then begin
      Incluir('CAPA_NEGOCIACAO',
              ['NEGOCIACAO_ID',
               'STATUS',
               'PRODUTOR_ID',
               'DISTRIBUIDOR_ID',
               'DT_CADASTRO'],
              [NegociacaoId,
               'P',
               edtCnpjProdutor.Text,
               edtCnpjDistribuidor.Text,
               DataAtual]);

      cdsItensNegociacao.First;
      while not cdsItensNegociacao.Eof do begin
        Incluir('ITENS_NEGOCIACAO',
                ['PRODUTO_ID',
                 'NOME_PRODUTO',
                 'QUANTIDADE',
                 'PRECO_UNITARIO',
                 'NEGOCIACAO_ID'],
                [cdsItensNegociacaoPRODUTO_ID.AsFloat,
                 cdsItensNegociacaoNOME_PRODUTO.AsString,
                 cdsItensNegociacaoQUANTIDADE.AsFloat,
                 cdsItensNegociacaoPRECO.AsFloat,
                 NegociacaoId]);
        cdsItensNegociacao.Next;
      end;
    end else begin
      Exclamar('N�o foi poss�vel gravar a negocia��o, verificar sequencial!');
      Exit;
    end;
  end else begin
    Alterar('CAPA_NEGOCIACAO',
            ['NEGOCIACAO_ID'],
            [edtCodigo.Value],
            ['STATUS',
             'PRODUTOR_ID',
             'DISTRIBUIDOR_ID',
             'DT_CADASTRO'],
            ['P',
             edtCnpjProdutor.Text,
             edtCnpjDistribuidor.Text,
             StrToDateDef(lblCadastro.Caption,0)]);

    cdsItensNegociacao.Filtered := False;
    cdsItensNegociacao.First;
    while not cdsItensNegociacao.Eof do begin
      if (cdsItensNegociacaoOPERACAO.AsString = 'I') then begin
        Incluir('ITENS_NEGOCIACAO',
                ['PRODUTO_ID',
                 'NOME_PRODUTO',
                 'QUANTIDADE',
                 'PRECO_UNITARIO',
                 'NEGOCIACAO_ID'],
                [cdsItensNegociacaoPRODUTO_ID.AsFloat,
                 cdsItensNegociacaoNOME_PRODUTO.AsString,
                 cdsItensNegociacaoQUANTIDADE.AsFloat,
                 cdsItensNegociacaoPRECO.AsFloat,
                 edtCodigo.Value]);
      end
      else if (cdsItensNegociacaoOPERACAO.AsString = 'A') then begin
        Alterar('ITENS_NEGOCIACAO',
                ['ITENS_NEGOCIACAO_ID',
                 'NEGOCIACAO_ID'],
                [cdsItensNegociacaoITEM_NEGOCIACAO.AsFloat,
                 edtCodigo.Value],
                ['PRODUTO_ID',
                 'NOME_PRODUTO',
                 'QUANTIDADE',
                 'PRECO_UNITARIO'],
                [cdsItensNegociacaoPRODUTO_ID.AsFloat,
                 cdsItensNegociacaoNOME_PRODUTO.AsString,
                 cdsItensNegociacaoQUANTIDADE.AsFloat,
                 cdsItensNegociacaoPRECO.AsFloat]);
      end
      else if (cdsItensNegociacaoOPERACAO.AsString = 'E') then begin
        Excluir('ITENS_NEGOCIACAO',
                ['ITENS_NEGOCIACAO_ID',
                 'NEGOCIACAO_ID'],
                [cdsItensNegociacaoITEM_NEGOCIACAO.AsFloat,
                 edtCodigo.Value]);
      end;
      cdsItensNegociacao.Next;
    end;
    cdsItensNegociacao.Filtered := True;
  end;
  Informar('Gravado com sucesso!');
  Controle(False);
end;

procedure TuFrmNegociacao.btnPesquisarClick(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
begin
  inherited;
  key := VK_RETURN;
  shift := [];
  if (dtmCadastro.psqNegociacao.Executar = mrYes) then begin
    edtCodigo.Value := dtmCadastro.qryNegociacaoNEGOCIACAO_ID.AsFloat;
    edtCodigoKeyDown(edtCodigo, key, shift);
  end;
end;

procedure TuFrmNegociacao.btnProdutoClick(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
begin
  inherited;
  key := VK_RETURN;
  shift := [];
  if (dtmCadastro.psqProduto.Executar = mrYes) then begin
    edtProduto.Value := dtmCadastro.qryProdutoPRODUTO_ID.AsFloat;
    edtProdutoKeyDown(edtProduto, key, shift);
  end;
end;

procedure TuFrmNegociacao.btnProdutorClick(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
begin
  inherited;
  key := VK_RETURN;
  shift := [];
  if (dtmCadastro.psqProdutor.Executar = mrYes) then begin
    TransformarCPFCNPJ(dtmCadastro.qryProdutorPRODUTOR_ID.AsString,
                       edtCnpjProdutor,
                       lblCnpjProdutor,
                       chkPFProdutor);
    edtCnpjProdutorKeyDown(edtCnpjProdutor, key, shift);
  end;
end;

procedure TuFrmNegociacao.chkPFProdutorClick(Sender: TObject);
begin
  TransformarCPFCNPJ(EmptyStr, edtCnpjProdutor, lblCnpjProdutor, chkPFProdutor);
end;

procedure TuFrmNegociacao.chkSolicitarAprovacaoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (key = vk_return) then begin
    Perform(40,0,0);
  end;
end;

procedure TuFrmNegociacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
end;

procedure TuFrmNegociacao.FormShow(Sender: TObject);
var
  R : TRect;
begin
  Windows.GetClientRect(Application.MainForm.ClientHandle, R);
  Self.Position := poDefault;
  Self.BorderIcons := [biSystemMenu];
  Self.Top := 0;
  Self.Left := (R.Right - Self.Width) div 2;
  Controle(False);
end;

procedure TuFrmNegociacao.tmrAtualizarTimer(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
  codigo : Double;
begin
  key := VK_RETURN;
  shift := [];
  pnlAtualizar.Visible := False;
  MinutosAtualizar := 6;
  tmrMinuto.Enabled := False;
  tmrAtualizar.Enabled := False;
  codigo := edtCodigo.Value;
  Controle(False);
  edtCodigo.Value := codigo;
  edtCodigoKeyDown(edtCodigo, key, shift);
end;

procedure TuFrmNegociacao.tmrMinutoTimer(Sender: TObject);
begin
  MinutosAtualizar := MinutosAtualizar - 1;
  pnlAtualizar.Visible := True;
  pnlAtualizar.Caption := 'Verificando aprova��o... ' + IntToStr(MinutosAtualizar);
  pnlAtualizar.Repaint;
end;

procedure TuFrmNegociacao.btnAdItemClick(Sender: TObject);
begin
  if (edtProduto.Value > 0) then begin
    if (dtmCadastro.psqProduto.Pesquisar(0, edtProduto.Value) <> mrYes) then begin
      Exclamar('Produto n�o encontrado!');
      edtProduto.SetFocus;
      edtProduto.SelectAll;
      Exit;
    end;
  end else begin
    Exclamar('Por favor informe o produto!');
    edtProduto.SetFocus;
    edtProduto.SelectAll;
    Exit;
  end;

  if (edtQtde.Value <= 0) then begin
    Exclamar('Por favor informe a quantidade!');
    edtQtde.SetFocus;
    edtQtde.SelectAll;
    Exit;
  end;

  if (cdsItensNegociacao.Locate('PRODUTO_ID', edtProduto.Value, [])) then begin
    cdsItensNegociacao.Edit;
    if (cdsItensNegociacaoITEM_NEGOCIACAO.AsFloat > 0) then begin
      cdsItensNegociacaoOPERACAO.AsString := 'A';
    end else begin
      cdsItensNegociacaoOPERACAO.AsString := 'I';
    end;
  end else begin
    cdsItensNegociacao.Append;
    cdsItensNegociacaoOPERACAO.AsString := 'I';
  end;

  cdsItensNegociacaoPRODUTO_ID.AsFloat := edtProduto.Value;
  cdsItensNegociacaoNOME_PRODUTO.AsString := edtNomeProduto.Text;
  cdsItensNegociacaoQUANTIDADE.AsFloat := edtQtde.Value;
  cdsItensNegociacaoPRECO.AsFloat := edtPreco.Value;
  cdsItensNegociacaoTOTAL_ITEM.AsFloat := (edtQtde.Value * edtPreco.Value);
  cdsItensNegociacao.Post;

  edtProduto.Clear;
  edtNomeProduto.Clear;
  edtQtde.Clear;
  edtPreco.Clear;
  edtProduto.SetFocus;
  edtProduto.SelectAll;
  lblValorTotal.Caption := 'Total:  ' + FormatCurr('#,##0.00', cdsItensNegociacao.Aggregates[0].Value);
end;

procedure TuFrmNegociacao.btnAprovarClick(Sender: TObject);
var
  params: TIdMultipartFormDataStream;
  ss: TStringStream;
  IdHTTP : TIdHTTP;
  url : string;
begin
  params := TIdMultiPartFormDataStream.Create;
  ss := TStringStream.Create('');
  if (Questionar('Ao aprovar n�o poder� mais alterar a negocia��o! Deseja continuar?')) then begin
    url := RetornaParametro('URL_ACESSO_NEGOCIACAO');
    try
      IdHTTP := TIdHTTP.Create();
      IdHTTP.Request.CustomHeaders.Clear;
      IdHTTP.Request.Clear;
      IdHTTP.Request.ContentType := 'application/json';
      IdHTTP.Request.CharSet := 'utf-8';
    finally
      IdHTTP.Post(url + '/api/negociacao/Liberanegociacoes?negociacaoId='+edtCodigo.Text, params, ss);
    end;
    Informar('Solicita��o enviada com sucesso!');
    MinutosAtualizar := 6;
    tmrAtualizar.Enabled := True;
    tmrMinuto.Enabled := True;

    {Valida��o manual no delphi, caso desejar utilizar � somente trocar o comentario.
    ValidarNegociacao(edtCnpjProdutor.Text, edtCnpjDistribuidor.Text, True);
    Alterar('CAPA_NEGOCIACAO',
            ['NEGOCIACAO_ID'],
            [edtCodigo.Value],
            ['STATUS',
             'DT_APROVACAO'],
            ['A',
             DataAtual]);
    Informar('Aprovado com sucesso!');
    Controle(False);}
  end;
end;

procedure TuFrmNegociacao.btnCancelarClick(Sender: TObject);
begin
  if (not edtCodigo.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      Controle(False);
    end;
  end;
end;

procedure TuFrmNegociacao.btnCancelarNegociacaoClick(Sender: TObject);
begin
  if (Questionar('Deseja realmente cancelar a negocia��o?')) then begin
    Alterar('CAPA_NEGOCIACAO',
            ['NEGOCIACAO_ID'],
            [edtCodigo.Value],
            ['DT_CANCELAMENTO',
             'DT_CONCLUSAO',
             'STATUS'],
            [DataAtual,
             DataAtual,
             'C']);
    Informar('Cancelado com sucesso!');
    Controle(False);
  end;
end;

procedure TuFrmNegociacao.btnConcluirClick(Sender: TObject);
begin
  if (Questionar('Deseja realmente concluir a negocia��o?')) then begin
    Alterar('CAPA_NEGOCIACAO',
            ['NEGOCIACAO_ID'],
            [edtCodigo.Value],
            ['DT_CONCLUSAO',
             'STATUS'],
            [DataAtual,
             'U']);
    Informar('Conclu�do com sucesso!');
    Controle(False);
  end;
end;

procedure TuFrmNegociacao.btnDistribuidorClick(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
begin
  inherited;
  key := VK_RETURN;
  shift := [];
  if (dtmCadastro.psqDistribuidor.Executar = mrYes) then begin
    edtCnpjDistribuidor.Text := dtmCadastro.qryDistribuidorDISTRIBUIDOR_ID.AsString;
    edtCnpjDistribuidorKeyDown(edtCnpjDistribuidor, key, shift);
  end;
end;

procedure TuFrmNegociacao.Controle(AEditando : Boolean; AConcluido: Boolean);
begin
  btnCancelar.Enabled := AEditando;
  edtCodigo.Enabled := not AEditando and (not AConcluido);
  btnPesquisar.Enabled := not AEditando and (not AConcluido);
  edtCnpjProdutor.Enabled := AEditando and (not AConcluido);
  chkPFProdutor.Enabled := AEditando and (not AConcluido);
  btnProdutor.Enabled := AEditando and (not AConcluido);
  edtCnpjDistribuidor.Enabled := AEditando and (not AConcluido);
  btnDistribuidor.Enabled := AEditando and (not AConcluido);
  edtProduto.Enabled := AEditando and (not AConcluido);
  btnProduto.Enabled := AEditando and (not AConcluido);
  edtQtde.Enabled := AEditando and (not AConcluido);
  grdDistribuidor.Enabled := AEditando and (not AConcluido);
  btnAdItem.Enabled := AEditando and (not AConcluido);
  btnExItem.Enabled := AEditando and (not AConcluido);

  if AEditando then begin
    if (not AConcluido) then begin
      edtCnpjProdutor.SetFocus;
    end;
  end else begin
    btnCancelarNegociacao.Enabled := False;
    btnAprovar.Enabled := False;
    btnConcluir.Enabled := False;
    btnGravar.Enabled := False;
    edtCodigo.Clear;
    chkPFProdutor.Checked := False;
    TransformarCPFCNPJ(EmptyStr, edtCnpjProdutor, lblCnpjProdutor, chkPFProdutor);
    edtRSProdutor.Clear;
    edtCnpjDistribuidor.Clear;
    edtRSDistribuidor.Clear;
    edtProduto.Clear;
    edtNomeProduto.Clear;
    edtQtde.Clear;
    edtPreco.Clear;
    cdsItensNegociacao.EmptyDataSet;
    lblStatus.Caption := EmptyStr;
    lblValorTotal.Caption := 'Total:  0,00';
    lblCadastro.Caption := 'N�o definido';
    lblAprovacao.Caption := 'N�o definido';
    lblConclusao.Caption := 'N�o definido';
    lblCancelamento.Caption := 'N�o definido';
    edtCodigo.SetFocus;
  end;
end;

procedure TuFrmNegociacao.edtCnpjDistribuidorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (Numeros(edtCnpjDistribuidor.Text).Length  <= 0) then begin
      btnDistribuidor.Click;
    end;

    if not isCNPJ(Numeros(edtCnpjDistribuidor.Text)) then begin
      Exclamar('CNPJ distribuidor inv�lido!');
      edtCnpjDistribuidor.SetFocus;
      edtCnpjDistribuidor.SelectAll;
      Exit;
    end;

    if (dtmCadastro.psqDistribuidor.Pesquisar(0, edtCnpjDistribuidor.Text) = mrYes) then begin
      edtRSDistribuidor.Text := dtmCadastro.qryDistribuidorRAZAO_SOCIAL.AsString;
      edtProduto.SetFocus;
    end;
  end;
end;

procedure TuFrmNegociacao.edtCnpjProdutorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (Numeros(edtCnpjProdutor.Text).Length  <= 0) then begin
      btnProdutor.Click;
    end;

    if chkPFProdutor.Checked then begin
      if not isCPF(Numeros(edtCnpjProdutor.Text)) then begin
        Exclamar('CPF produtor inv�lido!');
        edtCnpjProdutor.SetFocus;
        edtCnpjProdutor.SelectAll;
        Exit;
      end;
    end else begin
      if not isCNPJ(Numeros(edtCnpjProdutor.Text)) then begin
        Exclamar('CNPJ produtor inv�lido!');
        edtCnpjProdutor.SetFocus;
        edtCnpjProdutor.SelectAll;
        Abort;
      end;
    end;

    if (dtmCadastro.psqProdutor.Pesquisar(0, edtCnpjProdutor.Text) = mrYes) then begin
      edtRSProdutor.Text := dtmCadastro.qryProdutorRAZAO_SOCIAL.AsString;
      edtCnpjDistribuidor.SetFocus;
    end;
  end;
end;

procedure TuFrmNegociacao.edtCodigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_return) then begin
    if (edtCodigo.Value = 0) then begin
      lblCadastro.Caption := DateToStr(DataAtual);
      Controle(True);
      btnGravar.Enabled := True;
    end else begin
      if (dtmCadastro.psqNegociacao.Pesquisar(0, edtCodigo.Value) = mrYes) then begin
        Controle(True, (dtmCadastro.qryNegociacaoSTATUS.AsString = 'U') or (dtmCadastro.qryNegociacaoSTATUS.AsString = 'C'));

        TransformarCPFCNPJ(dtmCadastro.qryNegociacaoPRODUTOR_ID.AsString, edtCnpjProdutor, lblCnpjProdutor, chkPFProdutor);
        if (dtmCadastro.psqProdutor.Pesquisar(0, edtCnpjProdutor.Text) = mrYes) then begin
          edtRSProdutor.Text := dtmCadastro.qryProdutorRAZAO_SOCIAL.AsString;
        end;

        edtCnpjDistribuidor.Text := dtmCadastro.qryNegociacaoDISTRIBUIDOR_ID.AsString;
        if (dtmCadastro.psqDistribuidor.Pesquisar(0, edtCnpjDistribuidor.Text) = mrYes) then begin
          edtRSDistribuidor.Text := dtmCadastro.qryDistribuidorRAZAO_SOCIAL.AsString;
        end;

        lblStatus.Caption := dtmCadastro.qryNegociacaoSTATUS_N.AsString;
        lblCadastro.Caption := dtmCadastro.qryNegociacaoDT_CADASTRO.AsString;

        if (dtmCadastro.qryNegociacaoDT_APROVACAO.IsNull) then begin
          lblAprovacao.Caption := 'N�o definida';
        end else begin
          lblAprovacao.Caption := dtmCadastro.qryNegociacaoDT_APROVACAO.AsString;
        end;

        if (dtmCadastro.qryNegociacaoDT_CONCLUSAO.IsNull) then begin
          lblConclusao.Caption := 'N�o definida';
        end else begin
          lblConclusao.Caption := dtmCadastro.qryNegociacaoDT_CONCLUSAO.AsString;
        end;

        if (dtmCadastro.qryNegociacaoDT_CANCELAMENTO.IsNull) then begin
          lblCancelamento.Caption := 'N�o definida';
        end else begin
          lblCancelamento.Caption := dtmCadastro.qryNegociacaoDT_CANCELAMENTO.AsString;
        end;

        btnAprovar.Enabled := (dtmCadastro.qryNegociacaoSTATUS.AsString = 'P');
        btnCancelarNegociacao.Enabled := (dtmCadastro.qryNegociacaoSTATUS.AsString = 'A') or (dtmCadastro.qryNegociacaoSTATUS.AsString = 'P');
        btnConcluir.Enabled := (dtmCadastro.qryNegociacaoSTATUS.AsString = 'A');
        btnGravar.Enabled := (dtmCadastro.qryNegociacaoSTATUS.AsString = 'P');

        if (dtmCadastro.psqItensNegociacao.Pesquisar(0, edtCodigo.Value) = mrYes) then begin
          cdsItensNegociacao.EmptyDataSet;
          dtmCadastro.qryItensNegociacao.First;
          while not dtmCadastro.qryItensNegociacao.Eof do begin
            cdsItensNegociacao.Append;
            cdsItensNegociacaoPRODUTO_ID.AsFloat := dtmCadastro.qryItensNegociacaoPRODUTO_ID.AsFloat;
            cdsItensNegociacaoNOME_PRODUTO.AsString := dtmCadastro.qryItensNegociacaoNOME_PRODUTO.AsString;
            cdsItensNegociacaoQUANTIDADE.AsFloat := dtmCadastro.qryItensNegociacaoQUANTIDADE.AsFloat;
            cdsItensNegociacaoPRECO.AsFloat := dtmCadastro.qryItensNegociacaoPRECO_UNITARIO.AsFloat;
            cdsItensNegociacaoTOTAL_ITEM.AsFloat := (dtmCadastro.qryItensNegociacaoQUANTIDADE.AsFloat *
                                                     dtmCadastro.qryItensNegociacaoPRECO_UNITARIO.AsFloat);
            cdsItensNegociacaoITEM_NEGOCIACAO.AsFloat := dtmCadastro.qryItensNegociacaoITENS_NEGOCIACAO_ID.AsFloat;
            cdsItensNegociacao.Post;
            dtmCadastro.qryItensNegociacao.Next;
          end;
        end;

        if (dtmCadastro.qryNegociacaoSTATUS.AsString <> 'U') and
           (dtmCadastro.qryNegociacaoSTATUS.AsString <> 'C') then begin
          edtProduto.SetFocus;
        end;
        lblValorTotal.Caption := 'Total:  ' + FormatCurr('#,##0.00', cdsItensNegociacao.Aggregates[0].Value);
      end;
    end;
  end;
end;

procedure TuFrmNegociacao.edtProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (edtProduto.Value = 0) then begin
      btnProduto.Click;
    end else begin
      if (dtmCadastro.psqProduto.Pesquisar(0, edtProduto.Value) = mrYes) then begin
        if (dtmCadastro.qryProdutoATIVO.AsString <> 'S') then begin
          Exclamar('Produto est� inativo!');
          edtProduto.Clear;
          Abort;
        end;

        edtNomeProduto.Text := dtmCadastro.qryProdutoNOME_PRODUTO.AsString;
        edtPreco.Value := dtmCadastro.qryProdutoPRECO_UNITARIO.AsFloat;
        edtQtde.SetFocus;
      end else begin
        Exclamar('Produto n�o existe!');
        edtProduto.SelectAll;
        Abort;
      end;
    end;
  end;
end;

procedure TuFrmNegociacao.edtQtdeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_return) then begin
    btnAdItem.Click;
  end;
end;

end.
