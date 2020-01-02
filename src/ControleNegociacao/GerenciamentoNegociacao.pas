unit GerenciamentoNegociacao;

interface

uses
  Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Stan.StorageBin, ppDB,
  ppDBPipe, ppComm, ppRelatv, ppProd, ppClass, ppReport, ppBands, ppCache,
  ppDesignLayer, ppParameter, ppCtrls, ppPrnabl, ppVar;

type
  TuFrmGerenciamentoNegociacao = class(TForm)
    gbxStatus: TGroupBox;
    chkPendente: TCheckBox;
    chkAprovada: TCheckBox;
    chkCancelada: TCheckBox;
    chkConcluida: TCheckBox;
    lblCnpjProdutor: TLabel;
    chkPFProdutor: TCheckBox;
    edtCnpjProdutor: TMaskEdit;
    btnProdutor: TSpeedButton;
    edtRSProdutor: TEdit;
    lblRSProdutor: TLabel;
    lblCnpjDistribuidor: TLabel;
    edtCnpjDistribuidor: TMaskEdit;
    btnDistribuidor: TSpeedButton;
    edtRSDistribuidor: TEdit;
    lblRSDistribuidor: TLabel;
    gbxPeriodo: TGroupBox;
    dtIni: TDateTimePicker;
    dtFim: TDateTimePicker;
    cbxData: TComboBox;
    Label1: TLabel;
    btnOk: TButton;
    btn1Semana: TButton;
    btn1Mes: TButton;
    btn6Mes: TButton;
    btn1Ano: TButton;
    grdNegociacao: TDBGrid;
    cdsNegociacao: TFDMemTable;
    dtsNegociacao: TDataSource;
    qryNegociacao: TFDQuery;
    btnRelatorio: TButton;
    qryNegociacaoNEGOCIACAO_ID: TIntegerField;
    qryNegociacaoNOME_PRODUTOR: TStringField;
    qryNegociacaoNOME_DISTRIBUIDOR: TStringField;
    qryNegociacaoDT_CADASTRO: TDateField;
    qryNegociacaoDT_APROVACAO: TDateField;
    qryNegociacaoDT_CANCELAMENTO: TDateField;
    qryNegociacaoDT_CONCLUSAO: TDateField;
    qryNegociacaoTOTAL_NEGOCIACAO: TBCDField;
    qryNegociacaoEDITAR: TStringField;
    qryNegociacaoSTATUS_N: TStringField;
    cdsNegociacaoNEGOCIACAO_ID: TIntegerField;
    cdsNegociacaoNOME_PRODUTOR: TStringField;
    cdsNegociacaoNOME_DISTRIBUIDOR: TStringField;
    cdsNegociacaoDT_CADASTRO: TDateField;
    cdsNegociacaoDT_APROVACAO: TDateField;
    cdsNegociacaoDT_CANCELAMENTO: TDateField;
    cdsNegociacaoDT_CONCLUSAO: TDateField;
    cdsNegociacaoTOTAL_NEGOCIACAO: TBCDField;
    cdsNegociacaoEDITAR: TStringField;
    cdsNegociacaoSTATUS_N: TStringField;
    pprNegociacao: TppReport;
    ppiNegociacao: TppDBPipeline;
    ppParameterList1: TppParameterList;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppLabel1: TppLabel;
    ppDBText1: TppDBText;
    ppLabel2: TppLabel;
    ppDBText2: TppDBText;
    ppLabel3: TppLabel;
    ppDBText3: TppDBText;
    ppLine1: TppLine;
    ppLabel4: TppLabel;
    ppDBText4: TppDBText;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppLabel8: TppLabel;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppSystemVariable1: TppSystemVariable;
    ppPageSummaryBand1: TppPageSummaryBand;
    ppDBCalc1: TppDBCalc;
    ppLabel11: TppLabel;
    ppLine2: TppLine;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure grdNegociacaoCellClick(Column: TColumn);
    procedure chkPendenteClick(Sender: TObject);
    procedure btn1MesClick(Sender: TObject);
    procedure btn1SemanaClick(Sender: TObject);
    procedure btn6MesClick(Sender: TObject);
    procedure btn1AnoClick(Sender: TObject);
    procedure btnProdutorClick(Sender: TObject);
    procedure edtCnpjProdutorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnDistribuidorClick(Sender: TObject);
    procedure edtCnpjDistribuidorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnRelatorioClick(Sender: TObject);
  private
    procedure ProcessaNegociacao;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  uFrmGerenciamentoNegociacao: TuFrmGerenciamentoNegociacao;

implementation

{$R *.dfm}

uses ModuloBanco, ModuloCadastro, Menu, Funcoes, Negociacao, Persistencia;

procedure TuFrmGerenciamentoNegociacao.btn1AnoClick(Sender: TObject);
begin
  dtIni.Date := StrToDateTimeDef(FormatDateTime('dd/mm/yyyy', Date - 365), Date);
  dtFim.Date := Date;
  ProcessaNegociacao;
end;

procedure TuFrmGerenciamentoNegociacao.btn1MesClick(Sender: TObject);
begin
  dtIni.Date := StrToDateTimeDef(FormatDateTime('dd/mm/yyyy', Date - 30), Date);
  dtFim.Date := Date;
  ProcessaNegociacao;
end;

procedure TuFrmGerenciamentoNegociacao.btn1SemanaClick(Sender: TObject);
begin
  dtIni.Date := StrToDateTimeDef(FormatDateTime('dd/mm/yyyy', Date - 7), Date);
  dtFim.Date := Date;
  ProcessaNegociacao;
end;

procedure TuFrmGerenciamentoNegociacao.btn6MesClick(Sender: TObject);
begin
  dtIni.Date := StrToDateTimeDef(FormatDateTime('dd/mm/yyyy', Date - 180), Date);
  dtFim.Date := Date;
  ProcessaNegociacao;
end;

procedure TuFrmGerenciamentoNegociacao.btnDistribuidorClick(Sender: TObject);
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

procedure TuFrmGerenciamentoNegociacao.btnOkClick(Sender: TObject);
begin
  ProcessaNegociacao;
end;

procedure TuFrmGerenciamentoNegociacao.btnProdutorClick(Sender: TObject);
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

procedure TuFrmGerenciamentoNegociacao.btnRelatorioClick(Sender: TObject);
begin
  if not cdsNegociacao.IsEmpty then begin
    pprNegociacao.Print;
  end;
end;

procedure TuFrmGerenciamentoNegociacao.ProcessaNegociacao;
var
  Status : string;
begin
  cdsNegociacao.Close;
  qryNegociacao.Close;
  qryNegociacao.SQL.Clear;
  qryNegociacao.SQL.Add('SELECT CN.NEGOCIACAO_ID,                     ');
  qryNegociacao.SQL.Add('       PD.RAZAO_SOCIAL AS NOME_PRODUTOR,     ');
  qryNegociacao.SQL.Add('       DI.RAZAO_SOCIAL AS NOME_DISTRIBUIDOR, ');
  qryNegociacao.SQL.Add('       CN.DT_CADASTRO,                       ');
  qryNegociacao.SQL.Add('       CN.DT_APROVACAO,                      ');
  qryNegociacao.SQL.Add('       CN.DT_CANCELAMENTO,                   ');
  qryNegociacao.SQL.Add('       CN.DT_CONCLUSAO,                      ');
  qryNegociacao.SQL.Add('       (SELECT COALESCE(SUM(IT.QUANTIDADE * IT.PRECO_UNITARIO),0)        ');
  qryNegociacao.SQL.Add('          FROM ITENS_NEGOCIACAO IT                                       ');
  qryNegociacao.SQL.Add('         WHERE IT.NEGOCIACAO_ID = CN.NEGOCIACAO_ID) AS TOTAL_NEGOCIACAO, ');
  qryNegociacao.SQL.Add('       ''Ok'' AS EDITAR,                        ');
  qryNegociacao.SQL.Add('       CASE WHEN (CN.STATUS = ''C'') THEN ''Cancelada'' ');
  qryNegociacao.SQL.Add('            WHEN (CN.STATUS = ''A'') THEN ''Aprovada''  ');
  qryNegociacao.SQL.Add('            WHEN (CN.STATUS = ''U'') THEN ''Concluído'' ');
  qryNegociacao.SQL.Add('            ELSE ''Pendente''                           ');
  qryNegociacao.SQL.Add('       END STATUS_N                                     ');
  qryNegociacao.SQL.Add('  FROM CAPA_NEGOCIACAO CN,                      ');
  qryNegociacao.SQL.Add('       PRODUTOR PD,                             ');
  qryNegociacao.SQL.Add('       DISTRIBUIDOR DI                          ');
  qryNegociacao.SQL.Add(' WHERE CN.PRODUTOR_ID = PD.PRODUTOR_ID          ');
  qryNegociacao.SQL.Add('   AND CN.DISTRIBUIDOR_ID = DI.DISTRIBUIDOR_ID  ');

  Status := EmptyStr;
  if chkPendente.Checked then begin
    Status := '''P''';
  end;

  if chkAprovada.Checked then begin
    if (Status.Length > 0) then Status := Status + ',';
    Status := Status + '''A''';
  end;

  if chkCancelada.Checked then begin
    if (Status.Length > 0) then Status := Status + ',';
    Status := Status + '''C''';
  end;

  if chkConcluida.Checked then begin
    if (Status.Length > 0) then Status := Status + ',';
    Status := Status + '''U''';
  end;

  if (Status.Length > 0) then begin
    qryNegociacao.SQL.Add('   AND CN.STATUS IN ('+ Status + ')' );
  end;

  case cbxData.ItemIndex of
    0: qryNegociacao.SQL.Add(' AND CN.DT_CADASTRO BETWEEN :DT_INI AND :DT_FIM ');
    1: qryNegociacao.SQL.Add(' AND CN.DT_APROVACAO BETWEEN :DT_INI AND :DT_FIM ');
    2: qryNegociacao.SQL.Add(' AND CN.DT_CANCELAMENTO BETWEEN :DT_INI AND :DT_FIM ');
    3: qryNegociacao.SQL.Add(' AND CN.DT_CONCLUSAO BETWEEN :DT_INI AND :DT_FIM ');
    else qryNegociacao.SQL.Add(' AND CN.DT_CADASTRO BETWEEN :DT_INI AND :DT_FIM ');
  end;

  if (Numeros(edtCnpjProdutor.Text).Length > 0) then begin
    qryNegociacao.SQL.Add('   AND CN.PRODUTOR_ID = :PRODUTOR_ID           ');
  end;

  if (Numeros(edtCnpjDistribuidor.Text).Length > 0) then begin
    qryNegociacao.SQL.Add('   AND CN.DISTRIBUIDOR_ID = :DISTRIBUIDOR_ID   ');
  end;


  if (Numeros(edtCnpjProdutor.Text).Length > 0) then begin
    qryNegociacao.ParamByName('PRODUTOR_ID').AsString := edtCnpjProdutor.Text;
  end;

  if (Numeros(edtCnpjDistribuidor.Text).Length > 0) then begin
    qryNegociacao.ParamByName('DISTRIBUIDOR_ID').AsString := edtCnpjDistribuidor.Text;
  end;

  qryNegociacao.ParamByName('DT_INI').AsDate := dtIni.Date;
  qryNegociacao.ParamByName('DT_FIM').AsDate := dtFim.Date;
  qryNegociacao.Open;

  qryNegociacao.FetchAll;
  cdsNegociacao.Data := qryNegociacao.Data;
  cdsNegociacao.Open;
end;

procedure TuFrmGerenciamentoNegociacao.chkPendenteClick(Sender: TObject);
begin
  ProcessaNegociacao;
end;

procedure TuFrmGerenciamentoNegociacao.edtCnpjDistribuidorKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (Numeros(edtCnpjDistribuidor.Text).Length  <= 0) then begin
      btnDistribuidor.Click;
    end;

    if not isCNPJ(Numeros(edtCnpjDistribuidor.Text)) then begin
      Exclamar('CNPJ distribuidor inválido!');
      edtCnpjDistribuidor.Clear;
      edtCnpjDistribuidor.SetFocus;
      edtCnpjDistribuidor.SelectAll;
      Exit;
    end;

    if (dtmCadastro.psqDistribuidor.Pesquisar(0, edtCnpjDistribuidor.Text) = mrYes) then begin
      edtRSDistribuidor.Text := dtmCadastro.qryDistribuidorRAZAO_SOCIAL.AsString;
    end;
  end;
end;

procedure TuFrmGerenciamentoNegociacao.edtCnpjProdutorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (Numeros(edtCnpjProdutor.Text).Length  <= 0) then begin
      btnProdutor.Click;
    end;

    if chkPFProdutor.Checked then begin
      if not isCPF(Numeros(edtCnpjProdutor.Text)) then begin
        Exclamar('CPF produtor inválido!');
        edtCnpjProdutor.Clear;
        edtCnpjProdutor.SetFocus;
        edtCnpjProdutor.SelectAll;
        Exit;
      end;
    end else begin
      if not isCNPJ(Numeros(edtCnpjProdutor.Text)) then begin
        Exclamar('CNPJ produtor inválido!');
        edtCnpjProdutor.Clear;
        edtCnpjProdutor.SetFocus;
        edtCnpjProdutor.SelectAll;
        Abort;
      end;
    end;

    if (dtmCadastro.psqProdutor.Pesquisar(0, edtCnpjProdutor.Text) = mrYes) then begin
      edtRSProdutor.Text := dtmCadastro.qryProdutorRAZAO_SOCIAL.AsString;
    end;
  end;
end;

procedure TuFrmGerenciamentoNegociacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Release;
end;

procedure TuFrmGerenciamentoNegociacao.FormShow(Sender: TObject);
var
  R : TRect;
begin
  Windows.GetClientRect(Application.MainForm.ClientHandle, R);
  Self.Position := poDefault;
  Self.BorderIcons := [biSystemMenu];
  Self.Top := 0;
  Self.Left := (R.Right - Self.Width) div 2;
  dtIni.Date := DataAtual;
  dtFim.Date := dtIni.Date;
  btnOk.Click;
end;

procedure TuFrmGerenciamentoNegociacao.grdNegociacaoCellClick(Column: TColumn);
begin
  if (Column.Index = 9) then begin
    EditarNegociacao(cdsNegociacaoNEGOCIACAO_ID.AsFloat);
  end;
end;

end.
