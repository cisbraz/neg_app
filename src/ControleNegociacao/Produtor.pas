unit Produtor;

interface

uses
  Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CadastroBase, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, CurrencyEdit, Vcl.Mask, Vcl.Buttons, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ImgList;

type
  TuFrmProdutor = class(TuFrmBase)
    lblCnpj: TLabel;
    lblRazaoSocial: TLabel;
    edtCnpj: TMaskEdit;
    chkTipoPessoa: TCheckBox;
    edtRazaoSocial: TEdit;
    chkAtivo: TCheckBox;
    gbxLimiteCredito: TGroupBox;
    btnDistribuidor: TSpeedButton;
    edtRSDistribuidor: TEdit;
    lblCnpjDistribuidor: TLabel;
    edtCnpjDistribuidor: TMaskEdit;
    lblRSDistribuidor: TLabel;
    grdDistribuidor: TDBGrid;
    cdsDistribuidor: TClientDataSet;
    dtsDistribuidor: TDataSource;
    cdsDistribuidorDISTRIBUIDOR_ID: TStringField;
    cdsDistribuidorRAZAO_SOCIAL: TStringField;
    cdsDistribuidorLIMITE_CREDITO: TFloatField;
    edtLimiteCredito: TCurrencyEdit;
    lblLimiteCredito: TLabel;
    imgOperacao: TImageList;
    btnAdDistribuidor: TSpeedButton;
    btnExDistribuidor: TSpeedButton;
    cdsDistribuidorLIMITE_ID: TFloatField;
    cdsDistribuidorOPERACAO: TStringField;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure chkTipoPessoaClick(Sender: TObject);
    procedure edtCnpjKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFecharClick(Sender: TObject);
    procedure btnDistribuidorClick(Sender: TObject);
    procedure edtCnpjDistribuidorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAdDistribuidorClick(Sender: TObject);
    procedure edtLimiteCreditoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnExDistribuidorClick(Sender: TObject);
    procedure edtRazaoSocialKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdDistribuidorDblClick(Sender: TObject);
  private
    NovoRegistro : Boolean;
    procedure Controle(AEditando: Boolean);
    procedure GetLimite;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  uFrmProdutor: TuFrmProdutor;

implementation

{$R *.dfm}

uses Funcoes, Persistencia, ModuloCadastro;

procedure TuFrmProdutor.btnAdDistribuidorClick(Sender: TObject);
begin
  if not isCNPJ(Numeros(edtCnpjDistribuidor.Text)) then begin
    Exclamar('CNPJ inv�lido!');
    edtCnpjDistribuidor.SetFocus;
    edtCnpjDistribuidor.SelectAll;
    Abort;
  end;

  if (dtmCadastro.psqDistribuidor.Pesquisar(0, edtCnpjDistribuidor.Text) <> mrYes) then begin
    Exclamar('Distribuidor n�o encontrado!');
    edtCnpjDistribuidor.SetFocus;
    edtCnpjDistribuidor.SelectAll;
    Abort;
  end;

  if (edtLimiteCredito.Value <= 0) then begin
    Exclamar('Por favor informe o valor do limite de cr�dito!');
    edtLimiteCredito.SetFocus;
    edtLimiteCredito.SelectAll;
    Abort;
  end;

  if (cdsDistribuidor.Locate('DISTRIBUIDOR_ID', edtCnpjDistribuidor.Text, [])) then begin
    cdsDistribuidor.Edit;
    if (cdsDistribuidorLIMITE_ID.AsFloat > 0) then begin
      cdsDistribuidorOPERACAO.AsString := 'A';
    end else begin
      cdsDistribuidorOPERACAO.AsString := 'I';
    end;
  end else begin
    cdsDistribuidor.Append;
    cdsDistribuidorOPERACAO.AsString := 'I';
  end;
  cdsDistribuidorDISTRIBUIDOR_ID.AsString := edtCnpjDistribuidor.Text;
  cdsDistribuidorRAZAO_SOCIAL.AsString := edtRSDistribuidor.Text;
  cdsDistribuidorLIMITE_CREDITO.AsString := edtLimiteCredito.Text;
  cdsDistribuidor.Post;

  edtCnpjDistribuidor.Clear;
  edtRSDistribuidor.Clear;
  edtLimiteCredito.Clear;
  edtCnpjDistribuidor.SetFocus;
end;

procedure TuFrmProdutor.btnCancelarClick(Sender: TObject);
begin
  if (not edtCnpj.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      Controle(False);
    end;
  end;
end;

procedure TuFrmProdutor.btnDistribuidorClick(Sender: TObject);
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

procedure TuFrmProdutor.btnExcluirClick(Sender: TObject);
begin
  if not edtCnpj.Enabled then begin
    if Questionar('Deseja realmente excluir o registro?') then begin
      if (UsoProdutor(edtCnpj.Text)) then begin
        Exclamar('N�o � poss�vel excluir produtor, foi utilizado em negocia��o!');
        Exit;
      end;

      try
        Excluir('PRODUTOR',
                ['PRODUTOR_ID'],
                 [edtCnpj.Text]);
        Excluir('ITENS_LIMITE_CLIENTE', ['PRODUTOR_ID'], [edtCnpj.Text]);
        Informar('Excluido com sucesso!');
        Controle(False);
      except
        raise;
      end;
    end;
  end;
end;

procedure TuFrmProdutor.btnExDistribuidorClick(Sender: TObject);
begin
  if (cdsDistribuidor.RecordCount > 0) then begin
    cdsDistribuidor.Edit;
    cdsDistribuidorOPERACAO.AsString := 'E';
    cdsDistribuidor.Post;
  end;
end;

procedure TuFrmProdutor.btnFecharClick(Sender: TObject);
begin
  if (not edtCnpj.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      inherited;
    end;
  end else begin
    inherited;
  end;
end;

procedure TuFrmProdutor.btnGravarClick(Sender: TObject);
begin
  inherited;
  if (edtRazaoSocial.Text = EmptyStr) then begin
    Exclamar('A raz�o social deve ser informada!');
    Abort;
  end;

  if NovoRegistro then begin
    Incluir('PRODUTOR',
            ['PRODUTOR_ID',
             'RAZAO_SOCIAL',
             'ATIVO'],
            [edtCnpj.Text,
             edtRazaoSocial.Text,
             IffStr(chkAtivo.Checked, 'S', 'N')]);

    cdsDistribuidor.First;
    while not cdsDistribuidor.Eof do begin
      Incluir('ITENS_LIMITE_CLIENTE',
              ['PRODUTOR_ID',
               'DISTRIBUIDOR_ID',
               'VALOR_LIMITE'],
              [edtCnpj.Text,
               cdsDistribuidorDISTRIBUIDOR_ID.AsString,
               cdsDistribuidorLIMITE_CREDITO.AsFloat]);
      cdsDistribuidor.Next;
    end;
  end else begin
    Alterar('PRODUTOR',
            ['PRODUTOR_ID'],
            [edtCnpj.Text],
            ['RAZAO_SOCIAL',
             'ATIVO'],
            [edtRazaoSocial.Text,
             IffStr(chkAtivo.Checked, 'S', 'N')]);

    cdsDistribuidor.Filtered := False;
    cdsDistribuidor.First;
    while not cdsDistribuidor.Eof do begin
      if (cdsDistribuidorOPERACAO.AsString = 'I') then begin
        Incluir('ITENS_LIMITE_CLIENTE',
                ['PRODUTOR_ID',
                 'DISTRIBUIDOR_ID',
                 'VALOR_LIMITE'],
                [edtCnpj.Text,
                 cdsDistribuidorDISTRIBUIDOR_ID.AsString,
                 cdsDistribuidorLIMITE_CREDITO.AsFloat]);
      end
      else if (cdsDistribuidorOPERACAO.AsString = 'A') then begin
        Alterar('ITENS_LIMITE_CLIENTE',
                ['LIMITE_ID'],
                [cdsDistribuidorLIMITE_ID.AsFloat],
                ['PRODUTOR_ID',
                 'DISTRIBUIDOR_ID',
                 'VALOR_LIMITE'],
                [edtCnpj.Text,
                 cdsDistribuidorDISTRIBUIDOR_ID.AsString,
                 cdsDistribuidorLIMITE_CREDITO.AsFloat]);
      end
      else if (cdsDistribuidorOPERACAO.AsString = 'E') then begin
        Excluir('ITENS_LIMITE_CLIENTE', ['LIMITE_ID'], [cdsDistribuidorLIMITE_ID.AsFloat]);
      end;

      cdsDistribuidor.Next;
    end;
    cdsDistribuidor.Filtered := True;
  end;
  Informar('Gravado com sucesso!');
  Controle(False);
end;

procedure TuFrmProdutor.btnPesquisarClick(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
begin
  inherited;
  key := VK_RETURN;
  shift := [];
  if (dtmCadastro.psqProdutor.Executar = mrYes) then begin
    TransformarCPFCNPJ(dtmCadastro.qryProdutorPRODUTOR_ID.AsString, edtCnpj, lblCnpj, chkTipoPessoa);
    edtCnpjKeyDown(edtCnpj, key, shift);
  end;
end;

procedure TuFrmProdutor.chkTipoPessoaClick(Sender: TObject);
begin
  TransformarCPFCNPJ(EmptyStr, edtCnpj, lblCnpj, chkTipoPessoa);
end;

procedure TuFrmProdutor.Controle(AEditando: Boolean);
begin
  btnGravar.Enabled := AEditando;
  btnCancelar.Enabled := AEditando;
  edtCnpj.Enabled := not AEditando;
  chkTipoPessoa.Enabled := not AEditando;
  btnPesquisar.Enabled := not AEditando;
  edtRazaoSocial.Enabled := AEditando;
  chkAtivo.Enabled := AEditando;
  gbxLimiteCredito.Enabled := AEditando;

  if AEditando then begin
    btnExcluir.Enabled := not NovoRegistro;
    edtRazaoSocial.SetFocus;
  end else begin
    btnExcluir.Enabled := False;
    chkTipoPessoa.Checked := False;
    TransformarCPFCNPJ(EmptyStr, edtCnpj, lblCnpj, chkTipoPessoa);
    chkAtivo.Checked := True;
    edtRazaoSocial.Clear;
    edtCnpjDistribuidor.Clear;
    edtRSDistribuidor.Clear;
    edtLimiteCredito.Clear;
    cdsDistribuidor.EmptyDataSet;
    edtCnpj.SetFocus;
  end;
end;

procedure TuFrmProdutor.grdDistribuidorDblClick(Sender: TObject);
begin
  if (cdsDistribuidor.RecordCount > 0) then begin
    edtCnpjDistribuidor.Text := cdsDistribuidorDISTRIBUIDOR_ID.AsString;
    edtRSDistribuidor.Text := cdsDistribuidorRAZAO_SOCIAL.AsString;
    edtLimiteCredito.Value := cdsDistribuidorLIMITE_CREDITO.AsFloat;
    edtLimiteCredito.SetFocus;
    edtLimiteCredito.SelectAll;
  end;
end;

procedure TuFrmProdutor.edtCnpjDistribuidorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (Numeros(edtCnpjDistribuidor.Text).Length  <= 0) then begin
      btnDistribuidor.Click;
    end;

    if not isCNPJ(Numeros(edtCnpjDistribuidor.Text)) then begin
      Exclamar('CNPJ inv�lido!');
      edtCnpjDistribuidor.SetFocus;
      edtCnpjDistribuidor.SelectAll;
      Abort;
    end;

    if (dtmCadastro.psqDistribuidor.Pesquisar(0, edtCnpjDistribuidor.Text) = mrYes) then begin
      edtRSDistribuidor.Text := dtmCadastro.qryDistribuidorRAZAO_SOCIAL.AsString;
      edtLimiteCredito.SetFocus;
      edtLimiteCredito.SelectAll;
    end;
  end;
end;

procedure TuFrmProdutor.edtCnpjKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (Numeros(edtCnpj.Text).Length  <= 0) then begin
      btnPesquisar.Click;
    end;

    if chkTipoPessoa.Checked then begin
      if not isCPF(Numeros(edtCnpj.Text)) then begin
        Exclamar('CPF inv�lido!');
        edtCnpj.SetFocus;
        edtCnpj.SelectAll;
        Abort;
      end;
    end else begin
      if not isCNPJ(Numeros(edtCnpj.Text)) then begin
        Exclamar('CNPJ inv�lido!');
        edtCnpj.SetFocus;
        edtCnpj.SelectAll;
        Abort;
      end;
    end;

    if (dtmCadastro.psqProdutor.Pesquisar(0, edtCnpj.Text) = mrYes) then begin
      edtRazaoSocial.Text := dtmCadastro.qryProdutorRAZAO_SOCIAL.AsString;
      chkAtivo.Checked := (dtmCadastro.qryProdutorATIVO.AsString = 'S');
      GetLimite;
      NovoRegistro := False;
    end else begin
      NovoRegistro := True;
    end;
    Controle(True);
  end;
end;

procedure TuFrmProdutor.GetLimite;
var
  qryLimite: TFDQuery;
begin
  try
    qryLimite := TFDQuery.Create(nil);
    qryLimite.Connection := _Banco;
    qryLimite.Close;
    qryLimite.SQL.Add('SELECT IC.DISTRIBUIDOR_ID, ');
    qryLimite.SQL.Add('       IC.PRODUTOR_ID,     ');
    qryLimite.SQL.Add('       DI.RAZAO_SOCIAL,    ');
    qryLimite.SQL.Add('       IC.VALOR_LIMITE,    ');
    qryLimite.SQL.Add('       IC.LIMITE_ID        ');
    qryLimite.SQL.Add('  FROM ITENS_LIMITE_CLIENTE IC, ');
    qryLimite.SQL.Add('       DISTRIBUIDOR DI          ');
    qryLimite.SQL.Add(' WHERE IC.DISTRIBUIDOR_ID = DI.DISTRIBUIDOR_ID ');
    qryLimite.SQL.Add('   AND IC.PRODUTOR_ID = :PRODUTOR_ID ');
    qryLimite.SQL.Add(' ORDER BY IC.LIMITE_ID ');
    qryLimite.ParamByName('PRODUTOR_ID').AsString := edtCnpj.Text;
    qryLimite.Open;

    if (not qryLimite.IsEmpty) then begin
      cdsDistribuidor.EmptyDataSet;
      qryLimite.First;
      while not qryLimite.Eof do begin
        cdsDistribuidor.Append;
        cdsDistribuidorDISTRIBUIDOR_ID.AsString := qryLimite.FieldByName('DISTRIBUIDOR_ID').AsString;
        cdsDistribuidorRAZAO_SOCIAL.AsString := qryLimite.FieldByName('RAZAO_SOCIAL').AsString;
        cdsDistribuidorLIMITE_CREDITO.AsFloat := qryLimite.FieldByName('VALOR_LIMITE').AsFloat;
        cdsDistribuidorLIMITE_ID.AsFloat := qryLimite.FieldByName('LIMITE_ID').AsFloat;
        cdsDistribuidor.Post;
        qryLimite.Next;
      end;
    end;
  finally
    FreeAndNil(qryLimite);
  end;
end;

procedure TuFrmProdutor.edtLimiteCreditoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_return) then begin
    btnAdDistribuidor.Click;
  end;
end;

procedure TuFrmProdutor.edtRazaoSocialKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_return) then begin
    perform(40,0,0);
  end;
end;

procedure TuFrmProdutor.FormShow(Sender: TObject);
begin
  inherited;
  Controle(False);
end;

end.
