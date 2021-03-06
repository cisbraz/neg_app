unit ModuloBanco;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Forms, FireDAC.Phys.FB;

type
  TdtmBanco = class(TDataModule)
    cConexao: TFDConnection;
    qryExecSql: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmBanco: TdtmBanco;

implementation

uses Funcoes, Persistencia;

{$R *.dfm}

procedure TdtmBanco.DataModuleCreate(Sender: TObject);
var
  arq : TextFile;
  path,
  linha : string;
  posicao : Integer;
  oParams: TStrings;
begin
  oParams := TStringList.Create;
  try
    cConexao.Close;
    path := ExtractFilePath(Application.ExeName)+'pgConexao.ini';
    AssignFile(arq, path);
    cConexao.Connected := false;
    cConexao.Params.Clear;
    if FileExists(path) then begin
      Reset(arq);
      Readln(arq, linha);
      posicao := Pos('Database=',linha);
      if (posicao > 0) then begin
        cConexao.Params.Add('Database='+Copy(linha, 10, length(linha)));
      end else begin
        Exclamar('N�o foi poss�vel conectar com o banco de dados!');
        Exit;
      end;

      Readln(arq, linha);
      posicao := Pos('UserName=',linha);
      if (posicao > 0) then begin
        cConexao.Params.Add('User_Name='+Copy(linha, 10, length(linha)));
      end else begin
        Exclamar('N�o foi poss�vel conectar com o banco de dados!');
        Exit;
      end;

      Readln(arq, linha);
      posicao := Pos('Password=',linha);
      if (posicao > 0) then begin
        cConexao.Params.Add('Password='+Copy(linha, 10, length(linha)));
      end else begin
        Exclamar('N�o foi poss�vel conectar com o banco de dados!');
        Exit;
      end;
    end else begin
      Rewrite(arq);
      Writeln(arq, 'Database=C:\neg_app\data\BRAZ.FDB');
      Writeln(arq, 'UserName=sysdba');
      Writeln(arq, 'Password=masterkey');
      CloseFile(arq);
      cConexao.Params.Add('Database=C:\neg_app\data\BRAZ.FDB');
      cConexao.Params.Add('User_Name=sysdba');
      cConexao.Params.Add('Password=masterkey');
    end;
    cConexao.Params.Add('Port=0');
    cConexao.Params.Add('DriverID=FB');
    cConexao.Connected := True;
    _Banco := cConexao;
  except
    Exclamar('N�o foi poss�vel conectar com o banco de dados!');
  end;
end;

end.
