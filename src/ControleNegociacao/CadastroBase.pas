unit CadastroBase;

interface

uses
  Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ImgList;

type
  TuFrmBase = class(TForm)
    cbrMenu: TCoolBar;
    tbrMenu: TToolBar;
    btnExcluir: TToolButton;
    btnGravar: TToolButton;
    btnCancelar: TToolButton;
    tbtSeparador: TToolButton;
    btnPesquisar: TToolButton;
    ToolButton1: TToolButton;
    ToolButton8: TToolButton;
    btnFechar: TToolButton;
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    _Editando : Boolean;
    _NovoRegistro : Boolean;
  end;

var
  uFrmBase: TuFrmBase;

implementation

{$R *.dfm}

uses Menu, Funcoes;

procedure TuFrmBase.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TuFrmBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
end;

procedure TuFrmBase.FormShow(Sender: TObject);
var
  R : TRect;
begin
  Windows.GetClientRect(Application.MainForm.ClientHandle, R);
  Self.Position := poDefault;
  Self.BorderIcons := [biSystemMenu];
  Self.Top := 0;
  Self.Left := (R.Right - Self.Width) div 2;
end;

end.
