unit cParametro;

interface

uses FireDAC.Comp.Client, System.SysUtils, Vcl.Dialogs;

procedure GravarParametro(ANomeCampo, AValor: string);
function RetornaParametro(ANomeCampo: string):string;

implementation

uses Funcoes, Persistencia, ModuloBanco;

procedure GravarParametro(ANomeCampo, AValor: string);
var
  qryParametro : TFDQuery;
begin
  try
    qryParametro := TFDQuery.Create(nil);
    qryParametro.Connection := dtmBanco.cConexao;
    qryParametro.SQL.Add('SELECT VALOR FROM PARAMETRO WHERE NOME_CAMPO =:NOME');
    qryParametro.ParamByName('NOME').AsString := ANomeCampo;
    qryParametro.Open;

    if not qryParametro.IsEmpty then begin
      Alterar('PARAMETRO',
             ['NOME_CAMPO'],
             [ANomeCampo],
             ['VALOR'],
             [AValor]);
    end else begin
      Incluir('PARAMETRO',
             ['NOME_CAMPO',
              'VALOR'],
             [ANomeCampo,
              AValor]);
    end;
  finally
    qryParametro.Free;
  end;
end;

function RetornaParametro(ANomeCampo: string):string;
var
  qryParametro : TFDQuery;
begin
  try
    qryParametro := TFDQuery.Create(nil);
    qryParametro.Connection := dtmBanco.cConexao;
    qryParametro.SQL.Add('SELECT VALOR FROM PARAMETRO WHERE NOME_CAMPO =:NOME');
    qryParametro.ParamByName('NOME').AsString := ANomeCampo;
    qryParametro.Open;

    if not qryParametro.IsEmpty then begin
      Result := qryParametro.FieldByName('VALOR').AsString;
    end else begin
      Result := EmptyStr;
    end;
  finally
    qryParametro.Free;
  end;
end;

end.
