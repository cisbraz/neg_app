unit Persistencia;

interface
  uses
    FireDAC.Comp.Client, System.SysUtils, Vcl.Dialogs;

//Grava��o no bd
procedure Incluir(pTabela : string;
                  pParamCampo : array of string;
                  pParamValue : array of Variant);
procedure Alterar(pTabela : string;
                  pParamCampoChave : array of string;
                  pParamValueChave : array of Variant;
                  pParamCampo : array of string;
                  pParamValue : array of Variant);
procedure Excluir(pTabela : string;
                  pParamCampo : array of string;
                  pParamValue : array of Variant);

//Fun��es diversas
function NextVal(ANomeSequence : string): Double;
function DataAtual:TDateTime;
function DataHoraAtualStr:String;
function ValidarNegociacao(AProdutor : string;
                           ADistribuidor : string;
                           AMensagem : Boolean):Boolean;
function UsoProduto(AProduto : Double):Boolean;
function UsoProdutor(AProdutor : string):Boolean;
function UsoDistribuidor(ADistribuidor : string):Boolean;

var
  _Banco : TFDConnection;

implementation

uses Funcoes;

function UsoDistribuidor(ADistribuidor : string):Boolean;
var
  qryDistribuidor : TFDQuery;
begin
  try
    qryDistribuidor := TFDQuery.Create(nil);
    qryDistribuidor.Connection := _Banco;
    qryDistribuidor.Close;
    qryDistribuidor.SQL.Add('SELECT COUNT(*) AS QTDE FROM CAPA_NEGOCIACAO CP ');
    qryDistribuidor.SQL.Add(' WHERE CP.DISTRIBUIDOR_ID = :DISTRIBUIDOR_ID ');
    qryDistribuidor.ParamByName('DISTRIBUIDOR_ID').AsString := ADistribuidor;
    qryDistribuidor.Open;

    if not qryDistribuidor.IsEmpty then begin
      Result := qryDistribuidor.FieldByName('QTDE').AsFloat > 0;
    end;
  finally
    FreeAndNil(qryDistribuidor);
  end;
end;

function UsoProdutor(AProdutor : string):Boolean;
var
  qryProdutor : TFDQuery;
begin
  try
    qryProdutor := TFDQuery.Create(nil);
    qryProdutor.Connection := _Banco;
    qryProdutor.Close;
    qryProdutor.SQL.Add('SELECT COUNT(*) AS QTDE FROM CAPA_NEGOCIACAO CP ');
    qryProdutor.SQL.Add(' WHERE CP.PRODUTOR_ID = :PRODUTOR_ID ');
    qryProdutor.ParamByName('PRODUTOR_ID').AsString := AProdutor;
    qryProdutor.Open;

    if not qryProdutor.IsEmpty then begin
      Result := qryProdutor.FieldByName('QTDE').AsFloat > 0;
    end;
  finally
    FreeAndNil(qryProdutor);
  end;
end;

function UsoProduto(AProduto : Double):Boolean;
var
  qryProduto : TFDQuery;
begin
  try
    qryProduto := TFDQuery.Create(nil);
    qryProduto.Connection := _Banco;
    qryProduto.Close;
    qryProduto.SQL.Add('SELECT COUNT(*) AS QTDE FROM ITENS_NEGOCIACAO IT ');
    qryProduto.SQL.Add(' WHERE IT.PRODUTO_ID = :PRODUTO_ID ');
    qryProduto.ParamByName('PRODUTO_ID').AsFloat := AProduto;
    qryProduto.Open;

    if not qryProduto.IsEmpty then begin
      Result := qryProduto.FieldByName('QTDE').AsFloat > 0;
    end;
  finally
    FreeAndNil(qryProduto);
  end;
end;

function ValidarNegociacao(AProdutor : string;
                           ADistribuidor : string;
                           AMensagem : Boolean):Boolean;
var
  qryValidacao : TFDQuery;
  Ativo : Boolean;
  ValorLimite,
  ValorNegociacao : Double;
  Mensagem : string;
begin
  try
    qryValidacao := TFDQuery.Create(nil);
    qryValidacao.Connection := _Banco;

    //Carregando produtor produtor
    qryValidacao.Close;
    qryValidacao.SQL.Add('SELECT PD.ATIVO FROM PRODUTOR PD WHERE PD.PRODUTOR_ID = :PRODUTOR_ID   ');
    qryValidacao.ParamByName('PRODUTOR_ID').AsString := AProdutor;
    qryValidacao.Open;

    if not qryValidacao.IsEmpty then begin
      Ativo := (qryValidacao.FieldByName('ATIVO').AsString = 'S');
    end else begin
      Ativo := False;
    end;

    //Carregando limite
    qryValidacao.Close;
    qryValidacao.SQL.Clear;
    qryValidacao.SQL.Add('SELECT IL.VALOR_LIMITE  ');
    qryValidacao.SQL.Add('  FROM ITENS_LIMITE_CLIENTE IL, ');
    qryValidacao.SQL.Add('       PRODUTOR PD,             ');
    qryValidacao.SQL.Add('       DISTRIBUIDOR DI          ');
    qryValidacao.SQL.Add(' WHERE IL.PRODUTOR_ID = PD.PRODUTOR_ID         ');
    qryValidacao.SQL.Add('   AND IL.DISTRIBUIDOR_ID = DI.DISTRIBUIDOR_ID ');
    qryValidacao.SQL.Add('   AND IL.DISTRIBUIDOR_ID = :DISTRIBUIDOR_ID   ');
    qryValidacao.SQL.Add('   AND IL.PRODUTOR_ID = :PRODUTOR_ID           ');
    qryValidacao.ParamByName('PRODUTOR_ID').AsString := AProdutor;
    qryValidacao.ParamByName('DISTRIBUIDOR_ID').AsString := ADistribuidor;
    qryValidacao.Open;

    if not qryValidacao.IsEmpty then begin
      ValorLimite := qryValidacao.FieldByName('VALOR_LIMITE').AsFloat;
    end else begin
      ValorLimite := 0;
    end;

    //Carregando negocia�oes
    qryValidacao.Close;
    qryValidacao.SQL.Clear;
    qryValidacao.SQL.Add('SELECT COALESCE(SUM(TN.QUANTIDADE * TN.PRECO_UNITARIO),0) AS TOTAL ');
    qryValidacao.SQL.Add('  FROM CAPA_NEGOCIACAO CN,                     ');
    qryValidacao.SQL.Add('       ITENS_NEGOCIACAO TN                     ');
    qryValidacao.SQL.Add(' WHERE CN.NEGOCIACAO_ID = TN.NEGOCIACAO_ID     ');
    qryValidacao.SQL.Add('   AND CN.STATUS IN (''P'',''A'')              ');
    qryValidacao.SQL.Add('   AND CN.DT_CONCLUSAO IS NULL                 ');
    qryValidacao.SQL.Add('   AND CN.DISTRIBUIDOR_ID = :DISTRIBUIDOR_ID   ');
    qryValidacao.SQL.Add('   AND CN.PRODUTOR_ID = :PRODUTOR_ID           ');
    qryValidacao.ParamByName('PRODUTOR_ID').AsString := AProdutor;
    qryValidacao.ParamByName('DISTRIBUIDOR_ID').AsString := ADistribuidor;
    qryValidacao.Open;

    if not qryValidacao.IsEmpty then begin
      ValorNegociacao := qryValidacao.FieldByName('TOTAL').AsFloat;
    end else begin
      ValorNegociacao := 0;
    end;

    Mensagem := EmptyStr;
    if not Ativo then begin
      Mensagem := 'Produtor n�o est� ativo.';
    end;

    if (ValorNegociacao > ValorLimite) then begin
      if (Mensagem.Length > 0) then begin
        Mensagem := Mensagem + '#13';
      end;
      Mensagem := Mensagem + 'Limite de cr�dito dispon�vel n�o � suficiente. ' + #13;
      Mensagem := Mensagem + 'Limite: '+ FormatCurr('#,##0.00', ValorLimite) + '. Valor utilizado: ' + FormatCurr('#,##0.00', ValorNegociacao) + '.';
    end;

    if (Mensagem.Length > 0) then begin
      Result := False;
      if (AMensagem) then begin
        Exclamar(Mensagem);
        Abort;
      end;
    end else begin
      Result := True;
    end;
  finally
    FreeAndNil(qryValidacao);
  end;
end;

function DataHoraAtualStr:String;
var
  qryData : TFDQuery;
begin
  try
    qryData := TFDQuery.Create(nil);
    qryData.Connection := _Banco;
    qryData.Close;
    qryData.SQL.Clear;
    qryData.SQL.Add('SELECT CURRENT_TIMESTAMP AS DT FROM rdb$database');
    qryData.Open;

    if not qryData.IsEmpty then begin
      Result := qryData.FieldByName('DT').AsString;
    end;
  finally
    FreeAndNil(qryData);
  end;
end;

function DataAtual:TDateTime;
var
  qryData : TFDQuery;
begin
  try
    qryData := TFDQuery.Create(nil);
    qryData.Connection := _Banco;
    qryData.Close;
    qryData.SQL.Clear;
    qryData.SQL.Add('SELECT (DATE ''Now'') AS DT FROM rdb$database');
    qryData.Open;

    if not qryData.IsEmpty then begin
      Result := qryData.FieldByName('DT').AsDateTime;
    end;
  finally
    FreeAndNil(qryData);
  end;
end;

function NextVal(ANomeSequence: string): Double;
var
  qrySequence : TFDQuery;
begin
  try
    Result := 0;
    qrySequence := TFDQuery.Create(nil);
    qrySequence.Connection := _Banco;
    qrySequence.SQL.Add('SELECT GEN_ID('+ ANomeSequence +', 1) AS SEQ FROM rdb$database');
    qrySequence.Open;

    if not qrySequence.IsEmpty then begin
      Result := qrySequence.FieldByName('SEQ').AsFloat;
    end;
  finally
    FreeAndNil(qrySequence);
  end;
end;

procedure Incluir(pTabela : string;
                  pParamCampo : array of string;
                  pParamValue : array of Variant);
var
  qryIncluir : TFDQuery;
  I: Integer;
  params, values : string;
  datahora : string;
begin
  try
    datahora := DataHoraAtualStr;
    qryIncluir := TFDQuery.Create(nil);
    qryIncluir.Connection := _Banco;
    qryIncluir.Close;
    qryIncluir.SQL.Clear;

    qryIncluir.SQL.Add('INSERT INTO ' + pTabela + '(');

    for I := Low(pParamCampo) to High(pParamCampo) do begin
      if (pParamCampo[i] <> EmptyStr) then begin
        if (i = Low(pParamCampo)) then begin
           qryIncluir.SQL.Add(pParamCampo[i]);
        end else begin
           qryIncluir.SQL.Add(','+pParamCampo[i]);
        end;
      end;

      if (params.Length > 0) then begin
        params := params + ',:'+ pParamCampo[i];
      end else begin
        params := ':' + pParamCampo[i];
      end;
    end;

    qryIncluir.SQL.Add(')VALUES(');

    for I := Low(pParamCampo) to High(pParamCampo) do begin
      if (pParamCampo[i] <> EmptyStr) then begin
        if (i = Low(pParamCampo)) then begin
           qryIncluir.SQL.Add(':'+pParamCampo[i]);
        end else begin
           qryIncluir.SQL.Add(',:'+pParamCampo[i]);
        end;
      end;
    end;

    qryIncluir.SQL.Add(')');

    //Adiciona os valores
    for I := Low(pParamValue) to High(pParamValue) do begin
      if (String(pParamValue[i]) <> EmptyStr) then begin
        case TVarData(pParamValue[i]).vType of
          varInteger: qryIncluir.ParamByName(pParamCampo[i]).AsInteger := Integer(pParamValue[i]);
          varDouble: qryIncluir.ParamByName(pParamCampo[i]).AsFloat := Double(pParamValue[i]);
          varCurrency: qryIncluir.ParamByName(pParamCampo[i]).AsCurrency := Currency(pParamValue[i]);
          varDate: qryIncluir.ParamByName(pParamCampo[i]).AsDateTime := TDateTime(pParamValue[i]);
          varString: qryIncluir.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
          varUString: qryIncluir.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
          else qryIncluir.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
        end;
      end else begin
        qryIncluir.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
      end;

      if (values.Length > 0) then begin
        values := values + ','+ String(pParamValue[i]);
      end else begin
        values := String(pParamValue[i]);
      end;
    end;
    qryIncluir.ExecSQL;

    if (params.Length > 0) then begin
      WriteArquivo(datahora + '-> Inserir, tabela: '+ pTabela +', params: '+ params);
    end;

    if (values.Length > 0) then begin
      WriteArquivo(datahora + '-> Inserir, tabela: '+ pTabela +', values: '+ values);
    end;
    WriteArquivo('<------------------>');
  except
    on E : Exception do begin
       Exclamar('Ocorreu erro ao gravar na tabela '+pTabela+' :'+e.Message);
       Abort;
    end;
  end;
end;

procedure Alterar(pTabela : string;
                  pParamCampoChave : array of string;
                  pParamValueChave : array of Variant;
                  pParamCampo : array of string;
                  pParamValue : array of Variant);
var
  qryAlterar : TFDQuery;
  I: Integer;
  params, values : string;
  datahora : string;
begin
  try
    datahora := DataHoraAtualStr;
    qryAlterar := TFDQuery.Create(nil);
    qryAlterar.Connection := _Banco;
    qryAlterar.Close;
    qryAlterar.SQL.Clear;

    qryAlterar.SQL.Add('UPDATE ' + pTabela + ' SET ');

    params := EmptyStr;
    for I := Low(pParamCampo) to High(pParamCampo) do begin
      if (pParamCampo[i] <> EmptyStr) then begin
        if (i = Low(pParamCampo)) then begin
           qryAlterar.SQL.Add(pParamCampo[i] + ' = :'+pParamCampo[i]);
        end else begin
           qryAlterar.SQL.Add(',' +pParamCampo[i] + ' = :'+pParamCampo[i]);
        end;

        if (params.Length > 0) then begin
          params := params + ',:'+ pParamCampo[i];
        end else begin
          params := ':' + pParamCampo[i];
        end;
      end;
    end;

    values := EmptyStr;
    for I := Low(pParamValue) to High(pParamValue) do begin
      if (String(pParamValue[i]) <> EmptyStr) then begin
        case TVarData(pParamValue[i]).vType of
          varInteger: qryAlterar.ParamByName(pParamCampo[i]).AsInteger := Integer(pParamValue[i]);
          varDouble: qryAlterar.ParamByName(pParamCampo[i]).AsFloat := Double(pParamValue[i]);
          varCurrency: qryAlterar.ParamByName(pParamCampo[i]).AsCurrency := Currency(pParamValue[i]);
          varDate: qryAlterar.ParamByName(pParamCampo[i]).AsDateTime := TDateTime(pParamValue[i]);
          varString: qryAlterar.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
          varUString: qryAlterar.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
          else qryAlterar.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
        end;
      end else begin
        qryAlterar.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
      end;

      if (values.Length > 0) then begin
        values := values + ','+ String(pParamValue[i]);
      end else begin
        values := String(pParamValue[i]);
      end;
    end;

    qryAlterar.SQL.Add(' WHERE 1=1 ');

    for I := Low(pParamCampoChave) to High(pParamCampoChave) do begin
      if (pParamCampoChave[i] <> EmptyStr) then begin
        qryAlterar.SQL.Add('AND ' +pParamCampoChave[i] + ' = :'+pParamCampoChave[i]);
      end;
    end;

    for I := Low(pParamValueChave) to High(pParamValueChave) do begin
      if (String(pParamValueChave[i]) <> EmptyStr) then begin
        case TVarData(pParamValueChave[i]).vType of
          varInteger: qryAlterar.ParamByName(pParamCampoChave[i]).AsInteger := Integer(pParamValueChave[i]);
          varDouble: qryAlterar.ParamByName(pParamCampoChave[i]).AsFloat := Double(pParamValueChave[i]);
          varCurrency: qryAlterar.ParamByName(pParamCampoChave[i]).AsCurrency := Currency(pParamValueChave[i]);
          varDate: qryAlterar.ParamByName(pParamCampoChave[i]).AsDateTime := TDateTime(pParamValueChave[i]);
          varString: qryAlterar.ParamByName(pParamCampoChave[i]).AsString := String(pParamValueChave[i]);
          varUString: qryAlterar.ParamByName(pParamCampoChave[i]).AsString := String(pParamValueChave[i]);
          else qryAlterar.ParamByName(pParamCampoChave[i]).AsString := String(pParamValueChave[i]);
        end;
      end else begin
        qryAlterar.ParamByName(pParamCampoChave[i]).AsString := String(pParamValueChave[i]);
      end;
    end;

    qryAlterar.ExecSQL;

    if (params.Length > 0) then begin
      WriteArquivo(datahora + '-> Alterar, tabela: '+ pTabela +', params: '+ params);
    end;

    if (values.Length > 0) then begin
      WriteArquivo(datahora + '-> Alterar, tabela: '+ pTabela +', values: '+ values);
    end;
    WriteArquivo('<------------------>');
  except
    on E : Exception do begin
       Exclamar('Ocorreu erro ao alterar a tabela '+pTabela+' :'+e.Message);
       Abort;
    end;
  end;
end;

procedure Excluir(pTabela : string;
                  pParamCampo : array of string;
                  pParamValue : array of Variant);
var
  qryExcluir : TFDQuery;
  I: Integer;
  params, values : string;
  datahora : string;
begin
  try
    datahora := DataHoraAtualStr;
    qryExcluir := TFDQuery.Create(nil);
    qryExcluir.Connection := _Banco;
    qryExcluir.Close;
    qryExcluir.SQL.Clear;

    qryExcluir.SQL.Add('DELETE FROM ' + pTabela + ' WHERE 1=1 ');

    //Adiciona os parametros
    for I := Low(pParamCampo) to High(pParamCampo) do begin
      if (pParamCampo[i] <> EmptyStr) then begin
        qryExcluir.SQL.Add('AND ' +pParamCampo[i] + ' = :'+pParamCampo[i]);
      end;

      if (params.Length > 0) then begin
        params := params + ',:'+ pParamCampo[i];
      end else begin
        params := ':' + pParamCampo[i];
      end;
    end;

    //Adiciona os valores
    for I := Low(pParamValue) to High(pParamValue) do begin
      if (String(pParamValue[i]) <> EmptyStr) then begin
        case TVarData(pParamValue[i]).vType of
          varInteger: qryExcluir.ParamByName(pParamCampo[i]).AsInteger := Integer(pParamValue[i]);
          varDouble: qryExcluir.ParamByName(pParamCampo[i]).AsFloat := Double(pParamValue[i]);
          varCurrency: qryExcluir.ParamByName(pParamCampo[i]).AsCurrency := Currency(pParamValue[i]);
          varDate: qryExcluir.ParamByName(pParamCampo[i]).AsDateTime := TDateTime(pParamValue[i]);
          varString: qryExcluir.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
          varUString: qryExcluir.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
          else qryExcluir.ParamByName(pParamCampo[i]).AsString := String(pParamValue[i]);
        end;
      end;

      if (values.Length > 0) then begin
        values := values + ',:'+ String(pParamValue[i]);
      end else begin
        values := ':' + String(pParamValue[i]);
      end;
    end;

    qryExcluir.ExecSQL;

    if (params.Length > 0) then begin
      WriteArquivo(datahora + '-> Excluir, tabela: '+ pTabela +', params: '+ params);
    end;

    if (values.Length > 0) then begin
      WriteArquivo(datahora + '-> Excluir, tabela: '+ pTabela +', values: '+ values);
    end;
    WriteArquivo('<------------------>');
  except
    on E : Exception do begin
       Exclamar('Ocorreu erro ao excluir na tabela '+pTabela+' :'+e.Message);
       Abort;
    end;
  end;
end;

end.
