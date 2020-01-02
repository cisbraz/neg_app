unit ModuloCadastro;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FPesqAvaliacao;

type
  TdtmCadastro = class(TDataModule)
    qryProduto: TFDQuery;
    qryProdutoPRODUTO_ID: TIntegerField;
    qryProdutoNOME_PRODUTO: TStringField;
    qryProdutoPRECO_UNITARIO: TCurrencyField;
    psqProduto: TPesqAvaliacao;
    qryProdutor: TFDQuery;
    psqProdutor: TPesqAvaliacao;
    psqDistribuidor: TPesqAvaliacao;
    qryDistribuidor: TFDQuery;
    qryProdutorPRODUTOR_ID: TStringField;
    qryProdutorRAZAO_SOCIAL: TStringField;
    qryDistribuidorDISTRIBUIDOR_ID: TStringField;
    qryDistribuidorRAZAO_SOCIAL: TStringField;
    qryProdutoATIVO: TStringField;
    qryProdutorATIVO: TStringField;
    qryDistribuidorATIVO: TStringField;
    qryNegociacao: TFDQuery;
    psqNegociacao: TPesqAvaliacao;
    qryItensNegociacao: TFDQuery;
    psqItensNegociacao: TPesqAvaliacao;
    qryNegociacaoNEGOCIACAO_ID: TIntegerField;
    qryNegociacaoSTATUS: TStringField;
    qryNegociacaoDT_CADASTRO: TDateField;
    qryNegociacaoDT_APROVACAO: TDateField;
    qryNegociacaoDT_CONCLUSAO: TDateField;
    qryNegociacaoDT_CANCELAMENTO: TDateField;
    qryNegociacaoPRODUTOR_ID: TStringField;
    qryNegociacaoDISTRIBUIDOR_ID: TStringField;
    qryItensNegociacaoITENS_NEGOCIACAO_ID: TIntegerField;
    qryItensNegociacaoPRODUTO_ID: TIntegerField;
    qryItensNegociacaoNOME_PRODUTO: TStringField;
    qryItensNegociacaoPRECO_UNITARIO: TCurrencyField;
    qryItensNegociacaoQUANTIDADE: TIntegerField;
    qryItensNegociacaoNEGOCIACAO_ID: TIntegerField;
    qryNegociacaoRAZAO_DISTRIBUIDOR: TStringField;
    qryNegociacaoRAZAO_PRODUTOR: TStringField;
    qryNegociacaoSTATUS_N: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmCadastro: TdtmCadastro;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses ModuloBanco;

{$R *.dfm}

end.
