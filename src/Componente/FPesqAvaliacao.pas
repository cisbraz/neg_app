unit FPesqAvaliacao;

interface

uses
	Classes,Windows, Messages, SysUtils, Graphics, Controls, Forms, Dialogs,
	StdCtrls, FireDAC.Comp.Client, Data.DB, Generics.Collections, DBGrids;

type
   TPesqAvaliacao = class(TComponent)
   private
    FDataSet: TDataSet;
    FNomeFormulario : string;
    FIndices : TStrings;
    FIndicePadrao : Integer;
    FSQL : TStrings;
    FColunas : TDBgridColumns;
    FGrid : TDBGrid;
    FQtdeMinima : Integer;
    procedure CriarColunas;
    procedure CriarPesquisa;
    function DataType(AField: TField): string;

   protected

   public
 	 	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetDataSet(ADataSet: TDataSet);
    procedure SetIndices(AIndice: TStrings);
    procedure SetSQL(ASQL: TStrings);
    procedure SetColunas(AColunas : TDBGridColumns);
    function Executar:TModalResult;Overload;
    function Pesquisar(AIndice: Integer; AValue: Variant):TModalResult;Overload;

   published
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property NomeFormulatio: string read FNomeFormulario write FNomeFormulario;
    property Indices: TStrings read FIndices write SetIndices;
    property IndicePadrao: Integer read FIndicePadrao write FIndicePadrao default 0;
    property SQL: TStrings read FSQL write SetSQL;
    property Colunas: TDBGridColumns read FColunas write SetColunas;
    property QtdeMinima: Integer read FQtdeMinima write FQtdeMinima;
    function Executar(AParam, AValue: array of Variant):TModalResult;Overload;
    function Pesquisar(AIndices : Integer;
                       AValues : Variant;
                       AParam,
                       AValue: array of Variant):TModalResult;Overload;

   end;

procedure Register;

implementation

uses PesqAvaliacao;

constructor TPesqAvaliacao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNomeFormulario := EmptyStr;
  FQtdeMinima := 1;
  FIndicePadrao := 0;
  FIndices := TStringList.Create;
  FSQL := TStringList.Create;
  FDataSet := TDataSet.Create(nil);
  FGrid := TDBGrid.Create(nil);
  FColunas := TDBGridColumns.Create(FGrid, TColumn);
end;

destructor TPesqAvaliacao.Destroy;
begin
  FreeAndNil(FIndices);
  FreeAndNil(FSQL);
	inherited Destroy;
end;

procedure TPesqAvaliacao.CriarColunas;
var i: Integer;
begin
  if (FColunas <> nil) and (FColunas.Count > 0) then begin
    for I := 0 to FColunas.Count -1 do begin
      uFrmPesqAvaliacao.grdPesquisa.Columns.Add;
      uFrmPesqAvaliacao.grdPesquisa.Columns[I].FieldName := FColunas.Items[I].FieldName;
      uFrmPesqAvaliacao.grdPesquisa.Columns[I].Title.Caption := FColunas.Items[I].Title.Caption;
      uFrmPesqAvaliacao.grdPesquisa.Columns[I].Width := FColunas.Items[I].Width;

      {
      uFrmPesquisa.tbvPesquisa.CreateColumn;
      uFrmPesquisa.tbvPesquisa.Columns[I].DataBinding.FieldName := FColunas.Items[I].FieldName;
      uFrmPesquisa.tbvPesquisa.Columns[I].Caption := FColunas.Items[I].Title.Caption;
      uFrmPesquisa.tbvPesquisa.Columns[I].Width := FColunas.Items[I].Width;
      uFrmPesquisa.tbvPesquisa.Columns[I].HeaderAlignmentHorz := FColunas.Items[I].Title.Alignment;
      uFrmPesquisa.tbvPesquisa.Columns[I].Options.AutoWidthSizable := False;
      uFrmPesquisa.tbvPesquisa.Columns[I].Options.Editing := False;
      uFrmPesquisa.tbvPesquisa.Columns[I].Options.HorzSizing := False;
      uFrmPesquisa.tbvPesquisa.Columns[I].Options.Moving := False;
      }
    end;
    uFrmPesqAvaliacao.dtsPesquisa.DataSet := uFrmPesqAvaliacao.qryPesquisa;
    uFrmPesqAvaliacao.grdPesquisa.DataSource := uFrmPesqAvaliacao.dtsPesquisa;
  end;
end;

function TPesqAvaliacao.DataType(AField: TField):string;
begin
  case AField.DataType of
    ftString: Result:= 'String';
    ftSmallint: Result:= 'Smallint';
    ftInteger: Result:= 'Integer';
    ftWord: Result:= 'Word';
    ftBoolean: Result:= 'Boolean';
    ftFloat: Result:= 'Float';
    ftCurrency: Result:= 'Currency';
    ftDateTime: Result:= 'DateTime';
    ftBlob : Result:= 'BLOB';
    ftWideString : Result:= 'WideString';
    ftLargeint: Result:= 'LargeInt';
    ftVariant: Result:= 'Variant';
    ftFMTBcd : Result:= 'Currency';
    ftBcd : Result:= 'Currency';
    ftObject : Result:= 'Object';
    ftSingle : Result:= 'Single';
    ftWideMemo: Result:= 'String';
    else Result:= 'String';
  end;
end;

procedure TPesqAvaliacao.CriarPesquisa;
var I : Integer;
begin
  if (FIndices <> nil) then begin
    for I := 0 to FIndices.Count -1 do begin
      uFrmPesqAvaliacao.cbxPesquisa.Items.Add(Copy(FIndices[I], 1, Pos(';', FIndices[I]) - 1));
    end;

    if (FIndicePadrao <= (uFrmPesqAvaliacao.cbxPesquisa.Items.Count - 1)) then begin
      uFrmPesqAvaliacao.cbxPesquisa.ItemIndex := FIndicePadrao;
    end else begin
      uFrmPesqAvaliacao.cbxPesquisa.ItemIndex := 0;
    end;
  end;
end;

function TPesqAvaliacao.Executar:TModalResult;
begin
  Application.CreateForm(TuFrmPesqAvaliacao, uFrmPesqAvaliacao);
  TFDQuery(FDataSet).Close;
  uFrmPesqAvaliacao.Caption := NomeFormulatio;
  uFrmPesqAvaliacao.QtdeMinima := FQtdeMinima;
  uFrmPesqAvaliacao.qryPesquisa := TFDQuery(FDataSet);
  uFrmPesqAvaliacao.SQLIndice := FSQL;
  uFrmPesqAvaliacao.IndicePesquisa := FIndices;
  uFrmPesqAvaliacao.IndiceUnico := -1;
  uFrmPesqAvaliacao.Values := 0;
  uFrmPesqAvaliacao.SetParametros([],[]);
  CriarColunas;
  CriarPesquisa;

  case uFrmPesqAvaliacao.ShowModal of
    mrOk: Result := mrYes;
    else  Result := mrNo;
  end;
end;

function TPesqAvaliacao.Executar(AParam, AValue: array of Variant):TModalResult;
begin
  Application.CreateForm(TuFrmPesqAvaliacao, uFrmPesqAvaliacao);
  TFDQuery(FDataSet).Close;
  uFrmPesqAvaliacao.Caption := NomeFormulatio;
  uFrmPesqAvaliacao.QtdeMinima := FQtdeMinima;
  uFrmPesqAvaliacao.qryPesquisa := TFDQuery(FDataSet);
  uFrmPesqAvaliacao.SQLIndice := FSQL;
  uFrmPesqAvaliacao.IndicePesquisa := FIndices;
  uFrmPesqAvaliacao.IndiceUnico := -1;
  uFrmPesqAvaliacao.Values := 0;
  uFrmPesqAvaliacao.SetParametros(AParam, AValue);
  CriarColunas;
  CriarPesquisa;

  case uFrmPesqAvaliacao.ShowModal of
    mrOk: Result := mrYes;
    else  Result := mrNo;
  end;
end;

function TPesqAvaliacao.Pesquisar(AIndices: Integer; AValues: Variant; AParam,
  AValue: array of Variant): TModalResult;
begin
  Application.CreateForm(TuFrmPesqAvaliacao, uFrmPesqAvaliacao);
  TFDQuery(FDataSet).Close;
  uFrmPesqAvaliacao.qryPesquisa := TFDQuery(FDataSet);
  uFrmPesqAvaliacao.SQLIndice := FSQL;
  uFrmPesqAvaliacao.QtdeMinima := FQtdeMinima;
  uFrmPesqAvaliacao.IndicePesquisa := FIndices;
  uFrmPesqAvaliacao.IndiceUnico := AIndices;
  uFrmPesqAvaliacao.Values := AValues;
  CriarColunas;
  CriarPesquisa;
  uFrmPesqAvaliacao.SqlPesquisa(AParam,AValue);
  uFrmPesqAvaliacao.SqlPesquisaComp('');
  if uFrmPesqAvaliacao.qryPesquisa.IsEmpty then begin
    Result := mrNo;
  end else begin
    Result := mrYes;
  end;
end;

function TPesqAvaliacao.Pesquisar(AIndice: Integer; AValue: Variant): TModalResult;
begin
  Application.CreateForm(TuFrmPesqAvaliacao, uFrmPesqAvaliacao);
  TFDQuery(FDataSet).Close;
  uFrmPesqAvaliacao.qryPesquisa := TFDQuery(FDataSet);
  uFrmPesqAvaliacao.SQLIndice := FSQL;
  uFrmPesqAvaliacao.QtdeMinima := FQtdeMinima;
  uFrmPesqAvaliacao.IndicePesquisa := FIndices;
  uFrmPesqAvaliacao.IndiceUnico := AIndice;
  uFrmPesqAvaliacao.Values := AValue;
  CriarColunas;
  CriarPesquisa;
  uFrmPesqAvaliacao.SqlPesquisa([],[]);
  uFrmPesqAvaliacao.SqlPesquisaComp('');

  if uFrmPesqAvaliacao.qryPesquisa.IsEmpty then begin
    Result := mrNo;
  end else begin
    Result := mrYes;
  end;
end;

procedure TPesqAvaliacao.SetColunas(AColunas: TDBGridColumns);
begin
  try FColunas.Assign(AColunas); except end;
end;

procedure TPesqAvaliacao.SetDataSet(ADataSet: TDataSet);
begin
  if (ADataSet <> nil) then begin
    FDataSet := TDataSet(ADataSet);
  end;
end;

procedure TPesqAvaliacao.SetIndices(AIndice: TStrings);
begin
  if (AIndice <> nil) then begin
    FIndices.Clear;
    FIndices.AddStrings(AIndice);
  end;
end;

procedure TPesqAvaliacao.SetSQL(ASQL: TStrings);
begin
  if (ASQL <> nil) then begin
    FSQL.Clear;
    FSQL.AddStrings(ASQL);
  end;
end;

procedure Register;
begin
	RegisterComponents('PesqAvaliacao', [TPesqAvaliacao]);
end;

end.
