unit Distribuidor;

interface

uses
  Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CadastroBase, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, CurrencyEdit, Vcl.Mask, Vcl.ImgList;

type
  TuFrmDistribuidor = class(TuFrmBase)
    lblCnpj: TLabel;
    lblRazaoSocial: TLabel;
    edtCnpj: TMaskEdit;
    edtRazaoSocial: TEdit;
    chkAtivo: TCheckBox;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtCnpjKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFecharClick(Sender: TObject);
    procedure edtRazaoSocialKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    NovoRegistro : Boolean;
    procedure Controle(AEditando: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  uFrmDistribuidor: TuFrmDistribuidor;

implementation

{$R *.dfm}

uses Funcoes, Persistencia, ModuloCadastro;

procedure TuFrmDistribuidor.btnCancelarClick(Sender: TObject);
begin
  if (not edtCnpj.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      Controle(False);
    end;
  end;
end;

procedure TuFrmDistribuidor.btnExcluirClick(Sender: TObject);
begin
  if not edtCnpj.Enabled then begin
    if Questionar('Deseja realmente excluir o registro?') then begin
      if (UsoDistribuidor(edtCnpj.Text)) then begin
        Exclamar('N�o � poss�vel excluir distribuidor, foi utilizado em negocia��o!');
        Exit;
      end;

      try
        Excluir('DISTRIBUIDOR',
                ['DISTRIBUIDOR_ID'],
                 [edtCnpj.Text]);
        Informar('Excluido com sucesso!');
        Controle(False);
      except
        raise;
      end;
    end;
  end;
end;

procedure TuFrmDistribuidor.btnFecharClick(Sender: TObject);
begin
  if (not edtCnpj.Enabled) then begin
    if Questionar('Deseja realmente cancelar a edi��o!') then begin
      inherited;
    end;
  end else begin
    inherited;
  end;
end;

procedure TuFrmDistribuidor.btnGravarClick(Sender: TObject);
begin
  inherited;
  if (edtRazaoSocial.Text = EmptyStr) then begin
    Exclamar('A raz�o social deve ser informada!');
    Abort;
  end;

  if NovoRegistro then begin
    Incluir('DISTRIBUIDOR',
            ['DISTRIBUIDOR_ID',
             'RAZAO_SOCIAL',
             'ATIVO'],
            [edtCnpj.Text,
             edtRazaoSocial.Text,
             IffStr(chkAtivo.Checked, 'S', 'N')]);
  end else begin
    Alterar('DISTRIBUIDOR',
            ['DISTRIBUIDOR_ID'],
            [edtCnpj.Text],
            ['RAZAO_SOCIAL',
             'ATIVO'],
            [edtRazaoSocial.Text,
             IffStr(chkAtivo.Checked, 'S', 'N')]);
  end;
  Informar('Gravado com sucesso!');
  Controle(False);
end;

procedure TuFrmDistribuidor.btnPesquisarClick(Sender: TObject);
var
  key : Word;
  shift : TShiftState;
begin
  inherited;
  key := VK_RETURN;
  shift := [];
  if (dtmCadastro.psqDistribuidor.Executar = mrYes) then begin
    edtCnpj.Text := dtmCadastro.qryDistribuidorDISTRIBUIDOR_ID.AsString;
    edtCnpjKeyDown(edtCnpj, key, shift);
  end;
end;

procedure TuFrmDistribuidor.Controle(AEditando: Boolean);
begin
  btnGravar.Enabled := AEditando;
  btnCancelar.Enabled := AEditando;
  edtCnpj.Enabled := not AEditando;
  btnPesquisar.Enabled := not AEditando;
  edtRazaoSocial.Enabled := AEditando;
  chkAtivo.Enabled := AEditando;

  if AEditando then begin
    btnExcluir.Enabled := not NovoRegistro;
    edtRazaoSocial.SetFocus;
  end else begin
    btnExcluir.Enabled := False;
    edtCnpj.Clear;
    chkAtivo.Checked := True;
    edtRazaoSocial.Clear;
    edtCnpj.SetFocus;
  end;
end;

procedure TuFrmDistribuidor.edtCnpjKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if (Numeros(edtCnpj.Text).Length  <= 0) then begin
      btnPesquisar.Click;
    end;

    if not isCNPJ(Numeros(edtCnpj.Text)) then begin
      Exclamar('CNPJ inv�lido!');
      edtCnpj.SetFocus;
      edtCnpj.SelectAll;
      Abort;
    end;

    if (dtmCadastro.psqDistribuidor.Pesquisar(0, edtCnpj.Text) = mrYes) then begin
      edtRazaoSocial.Text := dtmCadastro.qryDistribuidorRAZAO_SOCIAL.AsString;
      chkAtivo.Checked := (dtmCadastro.qryDistribuidorATIVO.AsString = 'S');
      NovoRegistro := False;
    end else begin
      NovoRegistro := True;
    end;
    Controle(True);
  end;
end;

procedure TuFrmDistribuidor.edtRazaoSocialKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (key = vk_return) then begin
    perform(40,0,0);
  end;
end;

procedure TuFrmDistribuidor.FormShow(Sender: TObject);
begin
  inherited;
  Controle(False);
end;

end.
