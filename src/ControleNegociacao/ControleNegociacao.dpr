program ControleNegociacao;

uses
  Vcl.Forms,
  Menu in 'Menu.pas' {uFrmMenu},
  CadastroBase in 'CadastroBase.pas' {uFrmBase},
  ModuloBanco in 'ModuloBanco.pas' {dtmBanco: TDataModule},
  Produto in 'Produto.pas' {uFrmProduto},
  ModuloCadastro in 'ModuloCadastro.pas' {dtmCadastro: TDataModule},
  Persistencia in 'Persistencia\Persistencia.pas',
  Funcoes in 'Repositorio\Funcoes.pas',
  Produtor in 'Produtor.pas' {uFrmProdutor},
  Distribuidor in 'Distribuidor.pas' {uFrmDistribuidor},
  Negociacao in 'Negociacao.pas' {uFrmNegociacao},
  GerenciamentoNegociacao in 'GerenciamentoNegociacao.pas' {uFrmGerenciamentoNegociacao},
  Parametro in 'Parametro.pas' {uFrmParametro},
  cParametro in 'Persistencia\cParametro.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdtmBanco, dtmBanco);
  Application.CreateForm(TdtmCadastro, dtmCadastro);
  Application.CreateForm(TuFrmMenu, uFrmMenu);
  Application.Run;
end.
