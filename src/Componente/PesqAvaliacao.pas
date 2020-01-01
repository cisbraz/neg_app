unit PesqAvaliacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Data.DB, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,Generics.Collections, Vcl.Grids, Vcl.DBGrids;

type
  TuFrmPesqAvaliacao = class(TForm)
    ImageList1: TImageList;
    qryPesquisa: TFDQuery;
    dtsPesquisa: TDataSource;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    btnSelecionar: TToolButton;
    separacao: TToolButton;
    btnPesquisar: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton2: TToolButton;
    btnRetornar: TToolButton;
    cbxPesquisa: TComboBox;
    edtPesquisa: TEdit;
    Label1: TLabel;
    grdPesquisa: TDBGrid;
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnRetornarClick(Sender: TObject);
    procedure edtPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbvPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure btnPesquisarClick(Sender: TObject);
    procedure grdPesquisaEnter(Sender: TObject);
    procedure grdPesquisaDblClick(Sender: TObject);
    procedure grdPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FSQLIndice : TStrings;
    FIndicePesquisa : TStrings;
    FIndiceUnico : Integer;
    FValues : Variant;
    FQtdeMinima : Integer;
    AParamLocal: array of Variant;
    AValueLocal: array of Variant;
    function RetornaIndice: string;
  public
    procedure SqlPesquisa(AParam, AValue: array of Variant);
    procedure SqlPesquisaComp(AValue : string);
    procedure SetParametros(AParam, AValue: array of Variant);
  published
    property SQLIndice: TStrings read FSQLIndice write FSQLIndice;
    property IndicePesquisa : TStrings read FIndicePesquisa write FIndicePesquisa;
    property IndiceUnico: Integer read FIndiceUnico write FIndiceUnico;
    property Values: Variant read FValues write FValues;
    property QtdeMinima: Integer read FQtdeMinima write FQtdeMinima;

  end;

var
  uFrmPesqAvaliacao: TuFrmPesqAvaliacao;

implementation

{$R *.dfm}

procedure TuFrmPesqAvaliacao.btnPesquisarClick(Sender: TObject);
var
  Sql : TStrings;
  I : Integer;
  Iterar : Boolean;
  Indice : string;
begin
  if (Length(edtPesquisa.Text) < FQtdeMinima) then begin
    Application.MessageBox(PWideChar('Informe no mínimo um caracter!'), 'Atenção', MB_ICONEXCLAMATION + MB_OK);
    edtPesquisa.SelectAll;
    Abort;
  end else begin
    SqlPesquisa(AParamLocal, AValueLocal);

    if (Length(edtPesquisa.Text) = 0) then begin
      SqlPesquisaComp('%%');
    end else begin
      SqlPesquisaComp(edtPesquisa.Text);
    end;
  end;
end;

procedure TuFrmPesqAvaliacao.btnRetornarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TuFrmPesqAvaliacao.btnSelecionarClick(Sender: TObject);
begin
  if not qryPesquisa.IsEmpty then begin
    ModalResult := MrOk;
  end else begin
    ModalResult := mrCancel;
  end;
end;

procedure TuFrmPesqAvaliacao.grdPesquisaDblClick(Sender: TObject);
begin
  if not qryPesquisa.IsEmpty then begin
    ModalResult := MrOk;
  end else begin
    ModalResult := mrCancel;
  end;
end;

procedure TuFrmPesqAvaliacao.SetParametros(AParam, AValue: array of Variant);
var i : Integer;
begin
  for i := Low(AParam) to High(AParam) do begin
    SetLength(AParamLocal, i + 1);
    SetLength(AValueLocal, i + 1);
    AParamLocal[I] := AParam[I];
    AValueLocal[I] := AValue[I];
  end;
end;

procedure TuFrmPesqAvaliacao.SqlPesquisa(AParam, AValue: array of Variant);
var
  Sql : TStrings;
  I, cont :Integer;
  Iterar : Boolean;
  Indice : string;
begin
  Sql := TStringList.Create;
  Iterar := False;
  Indice := RetornaIndice;
  for I := 0 to FSQLIndice.Count -1 do begin
    if Iterar then begin
      if not (Trim(FSQLIndice[i]) = 'END') then begin
        Sql.Add(FSQLIndice[i]);
      end else begin
        Iterar := False;
      end;
    end else begin
      if (Trim(FSQLIndice[i]) = 'BEGIN SELECT') or
         (Trim(FSQLIndice[i]) = 'BEGIN '+Indice) then begin
        Iterar := True;
      end;
    end;
  end;

  qryPesquisa.Close;
  qryPesquisa.SQL.Clear;
  qryPesquisa.SQL.Add(Sql.Text);

  for i := Low(AParam) to High(AParam) do begin
    if (AParam[i] <> EmptyStr) then begin
      for cont := 0 to Sql.Count -1 do begin
        if (Pos(':'+AParam[i],Sql[cont]) > 0) then begin
          case TVarData(AParam[i]).vType of
            varInteger: qryPesquisa.ParamByName(AParam[i]).AsInteger := Integer(AValue[i]);
            varDouble: qryPesquisa.ParamByName(AParam[i]).AsFloat := Double(AValue[i]);
            varCurrency: qryPesquisa.ParamByName(AParam[i]).AsCurrency := Currency(AValue[i]);
            varDate: qryPesquisa.ParamByName(AParam[i]).AsDateTime := TDateTime(AValue[i]);
            varString: begin
              qryPesquisa.ParamByName(AParam[i]).DataType := ftString;
              qryPesquisa.ParamByName(AParam[i]).AsString := String(AValue[i]);
            end;
            varUString: begin
              qryPesquisa.ParamByName(AParam[i]).DataType := ftString;
              qryPesquisa.ParamByName(AParam[i]).AsString := String(AValue[i]);
            end
            else qryPesquisa.ParamByName(AParam[i]).AsString := String(AValue[i]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TuFrmPesqAvaliacao.SqlPesquisaComp(AValue : string);
begin
  if (Pos(':PARAM',uFrmPesqAvaliacao.qryPesquisa.SQL.Text) > 0) then begin
    if (Length(AValue) = 0) then begin
      case TVarData(Values).vType of
        varInteger: qryPesquisa.ParamByName('PARAM').AsInteger := Integer(Values);
        varDouble: qryPesquisa.ParamByName('PARAM').AsFloat := Double(Values);
        varCurrency: qryPesquisa.ParamByName('PARAM').AsCurrency := Currency(Values);
        varDate: qryPesquisa.ParamByName('PARAM').AsDateTime := TDateTime(Values);
        varString: qryPesquisa.ParamByName('PARAM').AsString := String(Values);
        varUString: qryPesquisa.ParamByName('PARAM').AsString := String(Values);
        else qryPesquisa.ParamByName('PARAM').AsString := String(Values);
      end;
    end else begin
      qryPesquisa.ParamByName('PARAM').AsString := AValue;
    end;
  end;
  qryPesquisa.Open;

  if (AValue <> EmptyStr) then begin
    if not qryPesquisa.IsEmpty then begin
      grdPesquisa.SetFocus;
    end else begin
      edtPesquisa.SelectAll;
    end;
  end;
end;

procedure TuFrmPesqAvaliacao.edtPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Sql : TStrings;
  I : Integer;
  Iterar : Boolean;
  Indice : string;
begin
  if (key = vk_return) then begin
    if (Length(edtPesquisa.Text) < FQtdeMinima) then begin
      Application.MessageBox(PWideChar('Informe no mínimo um caracter!'), 'Atenção', MB_ICONEXCLAMATION + MB_OK);
      edtPesquisa.SelectAll;
      Abort;
    end else begin
      SqlPesquisa(AParamLocal, AValueLocal);

      if (Length(edtPesquisa.Text) = 0) then begin
        SqlPesquisaComp('%%');
      end else begin
        SqlPesquisaComp(edtPesquisa.Text);
      end;
    end;
  end;
end;

procedure TuFrmPesqAvaliacao.edtPesquisaKeyPress(Sender: TObject; var Key: Char);
Const
  especiais = 'çÇ~^´`¨âÂàÀãÃéÉêÊèÈíÍîÎìÌæÆôòûùø£ØƒáÁóúñÑªº¿®½¼ÓßÔÒõÕµþÚÛÙýÝ';
Var
  Str : String;
begin
  Str := key;
  if (Pos(Str,especiais)<>0) or (Str = '''') Then
  begin
    key:= #95;
  end;
end;

function TuFrmPesqAvaliacao.RetornaIndice:string;
var
  I : Integer;
  Indice : string;
begin
  if (FIndiceUnico = -1) then begin
    for I := 0 to FIndicePesquisa.Count -1 do begin
      if (Copy(FIndicePesquisa[I], 1, Pos(';', FIndicePesquisa[I]) - 1) = cbxPesquisa.Items[cbxPesquisa.ItemIndex]) then begin
        Indice := Copy(FIndicePesquisa[I], Pos(';', FIndicePesquisa[I])+1, length(FIndicePesquisa[I]));
      end;
    end;

    if (StrToIntDef(Indice, 0) < 10) then begin
      Result := '0'+Indice;
    end else begin
      Result := Indice;
    end;
  end else begin
    if (FIndiceUnico < 10) then begin
      Result := '0'+IntToStr(FIndiceUnico);
    end else begin
      Result := IntToStr(FIndiceUnico);
    end;
  end;
end;

procedure TuFrmPesqAvaliacao.tbvPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) then begin
    if not qryPesquisa.IsEmpty then begin
      ModalResult := MrOk;
    end else begin
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TuFrmPesqAvaliacao.FormCreate(Sender: TObject);
begin
  FSQLIndice := TStringList.Create;
  FIndicePesquisa := TStringList.Create;
end;

procedure TuFrmPesqAvaliacao.FormShow(Sender: TObject);
begin
  edtPesquisa.SetFocus;
end;

procedure TuFrmPesqAvaliacao.grdPesquisaEnter(Sender: TObject);
var
  Sql : TStrings;
  I : Integer;
  Iterar : Boolean;
  Indice : string;
begin
  if (Length(edtPesquisa.Text) < FQtdeMinima) then begin
    Application.MessageBox(PWideChar('Informe no mínimo um caracter!'), 'Atenção', MB_ICONEXCLAMATION + MB_OK);
    edtPesquisa.SelectAll;
    Abort;
  end else begin
    SqlPesquisa(AParamLocal, AValueLocal);

    if (Length(edtPesquisa.Text) = 0) then begin
      SqlPesquisaComp('%%');
    end else begin
      SqlPesquisaComp(edtPesquisa.Text);
    end;
  end;
end;

procedure TuFrmPesqAvaliacao.grdPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_return) then begin
    if not qryPesquisa.IsEmpty then begin
      ModalResult := MrOk;
    end else begin
      ModalResult := mrCancel;
    end;
  end;
end;

end.

