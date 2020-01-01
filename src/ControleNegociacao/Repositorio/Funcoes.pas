unit Funcoes;

interface

uses
  Vcl.Dialogs, Windows, Classes, Vcl.Forms, Vcl.Controls, Vcl.ComCtrls, Vcl.ToolWin,
  System.SysUtils, System.Variants, Vcl.Graphics, Vcl.StdCtrls, Vcl.Mask;

//Formulario
procedure ShowChild(const AInstance : string);
function IsChildFormExist(AInstanceClass: TFormClass): Boolean;

//Mensagens
procedure Exclamar(AMensagem : string);
procedure Informar(AMensagem : string);
function Questionar(AMensagem : string):Boolean;

//Uitilitarios
procedure TransformarCPFCNPJ(ACNPJ: string;
                             var edtCnpj: TMaskEdit;
                             var lblCnpj: TLabel;
                             var chkTipoPessoa: TCheckBox);
function isCNPJ(ACNPJ: string): boolean;
function isCPF(ACPF: string): boolean;
function Numeros(AStr : String): String;
function IffInt(ACondicao: Boolean; AValorSim, AValorNao: Integer):Integer;
function IffDouble(ACondicao: Boolean; AValorSim, AValorNao: Double):Double;
function IffStr(ACondicao: Boolean; AValorSim, AValorNao: string):string;

//Manipula��o de arquivos
procedure WriteArquivo(ALog: string; ANomeArquivo: string = 'LogCommitsNegociacao.txt');

implementation

procedure WriteArquivo(ALog : string; ANomeArquivo: string);
var
  arq: TextFile;
  dirEXE : string;
begin
  try
    dirEXE := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
    AssignFile(arq, dirEXE + ANomeArquivo);
    if (not FileExists(dirEXE + ANomeArquivo)) then begin
      Rewrite(arq);
    end else begin
      Append(arq);
    end;

    Writeln(arq, ALog);
    CloseFile(arq);
  except end;
end;

procedure Exclamar(AMensagem : string);
begin
  Application.MessageBox(PWideChar(AMensagem), 'Aten��o', MB_ICONEXCLAMATION + MB_OK);
end;

procedure Informar(AMensagem : string);
begin
  Application.MessageBox(PWideChar(AMensagem), 'Informa��o', MB_ICONINFORMATION + MB_OK);
end;

function Questionar(AMensagem : string):Boolean;
begin
  if (Application.MessageBox(PWideChar(AMensagem), 'Aten��o', mb_Iconquestion + mb_yesno) = 6) then begin
    Result := True;
  end else begin
    Result := False;
  end;
end;

procedure ShowChild(const AInstance : string);
var
  Instance: TForm;
  FrmClass : TFormClass;
begin
  FrmClass := TFormClass(FindClass('T'+AInstance));
  if not IsChildFormExist(FrmClass) then begin
    Instance:= TForm(FrmClass.NewInstance);
    try
      Instance.Create(Application.MainForm);
    except
      raise;
    end;
  end;
end;

function IsChildFormExist(AInstanceClass: TFormClass): Boolean;
var
  I : Integer;
begin
  with (Application.MainForm) do begin
    for I := 0 to MDIChildCount - 1 do begin
      if (MDIChildren[i] is AInstanceClass) then begin
        Result:= True;
        MDIChildren[i].Show;
        Exit;
      end;
    end;
  end;
  Result := False;
end;

procedure TransformarCPFCNPJ(ACNPJ: string;
                             var edtCnpj: TMaskEdit;
                             var lblCnpj: TLabel;
                             var chkTipoPessoa: TCheckBox);
begin
  if (ACNPJ <> EmptyStr) then begin
    if (Length(ACNPJ) = 14) then begin
      edtCnpj.EditMask := '999\.999\.999\-99;1;_';
      lblCnpj.Caption := 'CPF';
      chkTipoPessoa.Checked := True;
    end else begin
      edtCnpj.EditMask := '99\.999\.999\/9999\-99;1;_';
      lblCnpj.Caption := 'CNPJ';
      chkTipoPessoa.Checked := False;
    end;
    edtCnpj.Text := ACNPJ;
  end else begin
    edtCnpj.Clear;
    if chkTipoPessoa.Checked then begin
      edtCnpj.EditMask := '999\.999\.999\-99;1;_';
      lblCnpj.Caption := 'CPF';
    end else begin
      edtCnpj.EditMask := '99\.999\.999\/9999\-99;1;_';
      lblCnpj.Caption := 'CNPJ';
    end;

    if edtCnpj.CanFocus then begin
      edtCnpj.SetFocus;
      edtCnpj.SelectAll;
    end;
  end;
end;

function isCNPJ(ACNPJ: string): boolean;
var   dig13, dig14: string;
    sm, i, r, peso: integer;
begin
  if ((ACNPJ = '00000000000000') or (ACNPJ = '11111111111111') or
      (ACNPJ = '22222222222222') or (ACNPJ = '33333333333333') or
      (ACNPJ = '44444444444444') or (ACNPJ = '55555555555555') or
      (ACNPJ = '66666666666666') or (ACNPJ = '77777777777777') or
      (ACNPJ = '88888888888888') or (ACNPJ = '99999999999999') or
      (length(ACNPJ) <> 14)) then begin
         isCNPJ := false;
         Exit(False);
  end;

  try
    sm := 0;
    peso := 2;
    for i := 12 downto 1 do begin
      sm := sm + (StrToInt(ACNPJ[i]) * peso);
      peso := peso + 1;
      if (peso = 10) then begin
        peso := 2;
      end;
    end;

    r := sm mod 11;
    if ((r = 0) or (r = 1)) then begin
      dig13 := '0'
    end else begin
      str((11-r):1, dig13);
    end;

    sm := 0;
    peso := 2;
    for i := 13 downto 1 do begin
      sm := sm + (StrToInt(ACNPJ[i]) * peso);
      peso := peso + 1;
      if (peso = 10) then begin
        peso := 2;
      end;
    end;
    r := sm mod 11;
    if ((r = 0) or (r = 1)) then begin
      dig14 := '0'
    end else begin
      str((11-r):1, dig14);
    end;

    if ((dig13 = ACNPJ[13]) and (dig14 = ACNPJ[14])) then begin
      isCNPJ := true
    end else begin
      isCNPJ := false;
    end;
  except
    isCNPJ := false
  end;
end;

function isCPF(ACPF: string): boolean;
var
  n1,n2,n3,n4,n5,n6,n7,n8,n9:integer;
  d1,d2:integer;
  digitado, calculado:string;
begin
  if (ACPF = EmptyStr) then Exit(False);

  n1:= StrToInt(ACPF[1]);
  n2:= StrToInt(ACPF[2]);
  n3:= StrToInt(ACPF[3]);
  n4:= StrToInt(ACPF[4]);
  n5:= StrToInt(ACPF[5]);
  n6:= StrToInt(ACPF[6]);
  n7:= StrToInt(ACPF[7]);
  n8:= StrToInt(ACPF[8]);
  n9:= StrToInt(ACPF[9]);
  d1:= n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10;
  d1:= 11-(d1 mod 11);
  if (d1 >= 10) then d1:=0;
  d2:= d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11;
  d2:= 11-(d2 mod 11);
  if (d2 >= 10) then d2 := 0;
  calculado := inttostr(d1)+inttostr(d2);
  digitado := ACPF[10]+ACPF[11];
  if (calculado = digitado) then begin
    Result := True;
  end else begin
    Result := False;
  end;
end;

function Numeros(AStr : String): String;
var
  I : Byte;
begin
  Result := EmptyStr;
  for I := 1 To Length(AStr) do begin
    if AStr[I] In ['0'..'9'] then begin
      Result := Result + AStr [I];
    end;
  end;
end;

function IffInt(ACondicao: Boolean; AValorSim, AValorNao: Integer):Integer;
begin
  if ACondicao then begin
    Result := AValorSim;
  end else begin
    Result := AValorNao;
  end;
end;

function IffDouble(ACondicao: Boolean; AValorSim, AValorNao: Double):Double;
begin
  if ACondicao then begin
    Result := AValorSim;
  end else begin
    Result := AValorNao;
  end;
end;

function IffStr(ACondicao: Boolean; AValorSim, AValorNao: string):string;
begin
  if ACondicao then begin
    Result := AValorSim;
  end else begin
    Result := AValorNao;
  end;
end;

end.
