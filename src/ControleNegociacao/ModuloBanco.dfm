object dtmBanco: TdtmBanco
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object cConexao: TFDConnection
    Params.Strings = (
      'Password=masterkey'
      'User_Name=sysdba'
      'Server=localhost'
      'Database=C:\neg_app\data\BRAZ.FDB'
      'DriverID=FB')
    LoginPrompt = False
    Left = 16
    Top = 8
  end
  object qryExecSql: TFDQuery
    Connection = cConexao
    Left = 72
    Top = 8
  end
end
