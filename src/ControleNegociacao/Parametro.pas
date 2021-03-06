unit Parametro;

interface

uses
  Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CadastroBase, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, CurrencyEdit;

type
  TuFrmParametro = class(TuFrmBase)
    lblNomeProduto: TLabel;
    edtUrlAcessoNegociacao: TEdit;
    procedure btnGravarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Controle;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  uFrmParametro: TuFrmParametro;

implementation

{$R *.dfm}

uses Funcoes, Persistencia, ModuloCadastro, cParametro;

procedure TuFrmParametro.btnCancelarClick(Sender: TObject);
begin
  if Questionar('Deseja realmente cancelar a edi��o!') then begin
     Controle;
  end;
end;

procedure TuFrmParametro.btnFecharClick(Sender: TObject);
begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      inherited;
    end;
end;

procedure TuFrmParametro.btnGravarClick(Sender: TObject);
begin
  GravarParametro('URL_ACESSO_NEGOCIACAO', edtUrlAcessoNegociacao.Text);
  Informar('Gravado com sucesso!');
  Controle;
end;

procedure TuFrmParametro.btnPesquisarClick(Sender: TObject);
begin
  edtUrlAcessoNegociacao.Text := RetornaParametro('URL_ACESSO_NEGOCIACAO');
end;

procedure TuFrmParametro.Controle;
begin
  edtUrlAcessoNegociacao.Clear;
  btnPesquisar.Click;
end;

procedure TuFrmParametro.FormShow(Sender: TObject);
begin
  inherited;
  Controle;
end;

end.
