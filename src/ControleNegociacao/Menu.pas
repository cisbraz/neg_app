unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.ImgList, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.AppEvnts;

type
  TuFrmMenu = class(TForm)
    imgOpcao: TImageList;
    pgcMenu: TPageControl;
    tbsCadastro: TTabSheet;
    tbsNegociacao: TTabSheet;
    btnProduto: TButton;
    btnProdutor: TButton;
    btnDistribuidor: TButton;
    btnNegociacao: TButton;
    btnGerenNegociacao: TButton;
    tbsConfiguracao: TTabSheet;
    btnParametro: TButton;
    procedure btnProdutoClick(Sender: TObject);
    procedure btnProdutorClick(Sender: TObject);
    procedure btnDistribuidorClick(Sender: TObject);
    procedure btnNegociacaoClick(Sender: TObject);
    procedure btnGerenNegociacaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnParametroClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  uFrmMenu: TuFrmMenu;

implementation

{$R *.dfm}

uses Produtor, Funcoes, Persistencia, Produto, Distribuidor, Negociacao,
  GerenciamentoNegociacao, Parametro;

procedure TuFrmMenu.btnDistribuidorClick(Sender: TObject);
begin
  ShowChild('uFrmDistribuidor');
end;

procedure TuFrmMenu.btnParametroClick(Sender: TObject);
begin
  ShowChild('uFrmParametro');
end;

procedure TuFrmMenu.btnProdutoClick(Sender: TObject);
begin
  ShowChild('uFrmProduto');
end;

procedure TuFrmMenu.btnProdutorClick(Sender: TObject);
begin
  ShowChild('uFrmProdutor');
end;

procedure TuFrmMenu.btnNegociacaoClick(Sender: TObject);
begin
  ShowChild('uFrmNegociacao');
end;

procedure TuFrmMenu.btnGerenNegociacaoClick(Sender: TObject);
begin
  ShowChild('uFrmGerenciamentoNegociacao');
end;

procedure TuFrmMenu.FormShow(Sender: TObject);
begin
  pgcMenu.ActivePage := tbsCadastro;
end;

initialization
  RegisterClasses([TuFrmProdutor,
                   TuFrmProduto,
                   TuFrmDistribuidor,
                   TuFrmNegociacao,
                   TuFrmGerenciamentoNegociacao,
                   TuFrmParametro]);

finalization
  UnRegisterClasses([TuFrmProdutor,
                     TuFrmProduto,
                     TuFrmDistribuidor,
                     TuFrmNegociacao,
                     TuFrmGerenciamentoNegociacao,
                     TuFrmParametro]);

end.
