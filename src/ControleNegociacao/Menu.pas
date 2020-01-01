unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, System.ImageList,
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
    Button4: TButton;
    Button5: TButton;
    procedure btnProdutoClick(Sender: TObject);
    procedure btnProdutorClick(Sender: TObject);
    procedure btnDistribuidorClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  GerenciamentoNegociacao;

procedure TuFrmMenu.btnDistribuidorClick(Sender: TObject);
begin
  ShowChild('uFrmDistribuidor');
end;

procedure TuFrmMenu.btnProdutoClick(Sender: TObject);
begin
  ShowChild('uFrmProduto');
end;

procedure TuFrmMenu.btnProdutorClick(Sender: TObject);
begin
  ShowChild('uFrmProdutor');
end;

procedure TuFrmMenu.Button4Click(Sender: TObject);
begin
  ShowChild('uFrmNegociacao');
end;

procedure TuFrmMenu.Button5Click(Sender: TObject);
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
                   TuFrmGerenciamentoNegociacao]);

finalization
  UnRegisterClasses([TuFrmProdutor,
                     TuFrmProduto,
                     TuFrmDistribuidor,
                     TuFrmNegociacao,
                     TuFrmGerenciamentoNegociacao]);

end.
