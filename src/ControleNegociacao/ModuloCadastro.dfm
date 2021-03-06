object dtmCadastro: TdtmCadastro
  OldCreateOrder = False
  Height = 183
  Width = 426
  object qryProduto: TFDQuery
    Connection = dtmBanco.cConexao
    SQL.Strings = (
      'select * from produto')
    Left = 16
    Top = 16
    object qryProdutoPRODUTO_ID: TIntegerField
      FieldName = 'PRODUTO_ID'
      Origin = 'PRODUTO_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryProdutoNOME_PRODUTO: TStringField
      FieldName = 'NOME_PRODUTO'
      Origin = 'NOME_PRODUTO'
      Size = 100
    end
    object qryProdutoPRECO_UNITARIO: TCurrencyField
      FieldName = 'PRECO_UNITARIO'
      Origin = 'PRECO_UNITARIO'
    end
    object qryProdutoATIVO: TStringField
      FieldName = 'ATIVO'
      Origin = 'ATIVO'
      FixedChar = True
      Size = 1
    end
  end
  object psqProduto: TPesqAvaliacao
    DataSet = qryProduto
    NomeFormulatio = 'Consulta de produtos'
    Indices.Strings = (
      'C'#243'digo;1'
      'Nome produto;2')
    IndicePadrao = 2
    SQL.Strings = (
      'BEGIN SELECT'
      '  SELECT *'
      '    FROM PRODUTO'
      '   WHERE 1=1'
      'END'
      ''
      'BEGIN 00'
      '  AND PRODUTO_ID = :PARAM'
      'END'
      ''
      'BEGIN 01'
      '  AND CAST(PRODUTO_ID AS VARCHAR(8))  LIKE :PARAM'
      'END'
      ''
      'BEGIN 02'
      '  AND UPPER(NOME_PRODUTO) LIKE '#39'%'#39' || UPPER(:PARAM) ||'#39'%'#39
      'END'
      '')
    Colunas = <
      item
        Expanded = False
        FieldName = 'PRODUTO_ID'
        Title.Caption = 'C'#243'digo'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME_PRODUTO'
        Title.Caption = 'Nome produto'
        Width = 400
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECO_UNITARIO'
        Title.Caption = 'Pre'#231'o'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ATIVO'
        Title.Caption = 'Ativo'
        Width = 50
        Visible = True
      end>
    QtdeMinima = 0
    Left = 72
    Top = 16
  end
  object qryProdutor: TFDQuery
    Connection = dtmBanco.cConexao
    SQL.Strings = (
      'select * from produtor')
    Left = 16
    Top = 64
    object qryProdutorPRODUTOR_ID: TStringField
      FieldName = 'PRODUTOR_ID'
      Origin = 'PRODUTOR_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 18
    end
    object qryProdutorRAZAO_SOCIAL: TStringField
      FieldName = 'RAZAO_SOCIAL'
      Origin = 'RAZAO_SOCIAL'
      Size = 100
    end
    object qryProdutorATIVO: TStringField
      FieldName = 'ATIVO'
      Origin = 'ATIVO'
      FixedChar = True
      Size = 1
    end
  end
  object psqProdutor: TPesqAvaliacao
    DataSet = qryProdutor
    NomeFormulatio = 'Consulta de produtor'
    Indices.Strings = (
      'CPF/CNPJ;1'
      'Raz'#227'o social;2')
    IndicePadrao = 2
    SQL.Strings = (
      'BEGIN SELECT'
      '  SELECT *'
      '    FROM PRODUTOR'
      '   WHERE 1=1'
      'END'
      ''
      'BEGIN 00'
      '  AND PRODUTOR_ID = :PARAM'
      'END'
      ''
      'BEGIN 01'
      '  AND PRODUTOR_ID LIKE :PARAM'
      'END'
      ''
      'BEGIN 02'
      '  AND UPPER(RAZAO_SOCIAL) LIKE '#39'%'#39' || UPPER(:PARAM) ||'#39'%'#39
      'END'
      '')
    Colunas = <
      item
        Expanded = False
        FieldName = 'PRODUTOR_ID'
        Title.Caption = 'CPF/CNPJ'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RAZAO_SOCIAL'
        Title.Caption = 'Raz'#227'o social'
        Width = 450
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ATIVO'
        Title.Caption = 'Ativo'
        Width = 50
        Visible = True
      end>
    QtdeMinima = 0
    Left = 72
    Top = 64
  end
  object psqDistribuidor: TPesqAvaliacao
    DataSet = qryDistribuidor
    NomeFormulatio = 'Consulta de distribuidor'
    Indices.Strings = (
      'CPF/CNPJ;1'
      'Raz'#227'o social;2')
    IndicePadrao = 2
    SQL.Strings = (
      'BEGIN SELECT'
      '  SELECT *'
      '    FROM DISTRIBUIDOR'
      '   WHERE 1=1'
      'END'
      ''
      'BEGIN 00'
      '  AND DISTRIBUIDOR_ID = :PARAM'
      'END'
      ''
      'BEGIN 01'
      '  AND DISTRIBUIDOR_ID LIKE :PARAM'
      'END'
      ''
      'BEGIN 02'
      '  AND UPPER(RAZAO_SOCIAL) LIKE '#39'%'#39' || UPPER(:PARAM) ||'#39'%'#39
      'END'
      '')
    Colunas = <
      item
        Expanded = False
        FieldName = 'DISTRIBUIDOR_ID'
        Title.Caption = 'CPF/CNPJ'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RAZAO_SOCIAL'
        Title.Caption = 'Raz'#227'o social'
        Width = 450
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ATIVO'
        Title.Caption = 'Ativo'
        Width = 50
        Visible = True
      end>
    QtdeMinima = 0
    Left = 72
    Top = 120
  end
  object qryDistribuidor: TFDQuery
    Connection = dtmBanco.cConexao
    SQL.Strings = (
      'select * from distribuidor')
    Left = 16
    Top = 120
    object qryDistribuidorDISTRIBUIDOR_ID: TStringField
      FieldName = 'DISTRIBUIDOR_ID'
      Origin = 'DISTRIBUIDOR_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 18
    end
    object qryDistribuidorRAZAO_SOCIAL: TStringField
      FieldName = 'RAZAO_SOCIAL'
      Origin = 'RAZAO_SOCIAL'
      Size = 100
    end
    object qryDistribuidorATIVO: TStringField
      FieldName = 'ATIVO'
      Origin = 'ATIVO'
      FixedChar = True
      Size = 1
    end
  end
  object qryNegociacao: TFDQuery
    Connection = dtmBanco.cConexao
    SQL.Strings = (
      'SELECT CN.*,'
      '       DI.RAZAO_SOCIAL AS RAZAO_DISTRIBUIDOR,'
      '       PO.RAZAO_SOCIAL AS RAZAO_PRODUTOR,'
      '       CASE'
      '          WHEN (CN.STATUS = '#39'C'#39') THEN '#39'Cancelada'#39
      '          WHEN (CN.STATUS = '#39'A'#39') THEN '#39'Aprovada'#39
      '          WHEN (CN.STATUS = '#39'U'#39') THEN '#39'Conclu'#237'do'#39
      '          ELSE '#39'Pendente'#39
      '       END STATUS_N'
      '  FROM CAPA_NEGOCIACAO CN,'
      '       DISTRIBUIDOR    DI,'
      '       PRODUTOR        PO'
      ' WHERE CN.DISTRIBUIDOR_ID = DI.DISTRIBUIDOR_ID'
      '   AND CN.PRODUTOR_ID = PO.PRODUTOR_ID')
    Left = 144
    Top = 16
    object qryNegociacaoNEGOCIACAO_ID: TIntegerField
      FieldName = 'NEGOCIACAO_ID'
      Origin = 'NEGOCIACAO_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryNegociacaoSTATUS: TStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      FixedChar = True
      Size = 1
    end
    object qryNegociacaoDT_CADASTRO: TDateField
      FieldName = 'DT_CADASTRO'
      Origin = 'DT_CADASTRO'
    end
    object qryNegociacaoDT_APROVACAO: TDateField
      FieldName = 'DT_APROVACAO'
      Origin = 'DT_APROVACAO'
    end
    object qryNegociacaoDT_CONCLUSAO: TDateField
      FieldName = 'DT_CONCLUSAO'
      Origin = 'DT_CONCLUSAO'
    end
    object qryNegociacaoDT_CANCELAMENTO: TDateField
      FieldName = 'DT_CANCELAMENTO'
      Origin = 'DT_CANCELAMENTO'
    end
    object qryNegociacaoPRODUTOR_ID: TStringField
      FieldName = 'PRODUTOR_ID'
      Origin = 'PRODUTOR_ID'
      Size = 18
    end
    object qryNegociacaoDISTRIBUIDOR_ID: TStringField
      FieldName = 'DISTRIBUIDOR_ID'
      Origin = 'DISTRIBUIDOR_ID'
      Size = 18
    end
    object qryNegociacaoRAZAO_DISTRIBUIDOR: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'RAZAO_DISTRIBUIDOR'
      Origin = 'RAZAO_SOCIAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qryNegociacaoRAZAO_PRODUTOR: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'RAZAO_PRODUTOR'
      Origin = 'RAZAO_SOCIAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qryNegociacaoSTATUS_N: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'STATUS_N'
      Origin = 'STATUS_N'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 12
    end
  end
  object psqNegociacao: TPesqAvaliacao
    DataSet = qryNegociacao
    NomeFormulatio = 'Consulta de negocia'#231#245'es'
    Indices.Strings = (
      'C'#243'digo;3'
      'Raz'#227'o distribuidor;1'
      'Raz'#227'o produtor;2')
    IndicePadrao = 2
    SQL.Strings = (
      'BEGIN SELECT'
      '  SELECT CN.*,'
      '         DI.RAZAO_SOCIAL AS RAZAO_DISTRIBUIDOR,'
      '         PO.RAZAO_SOCIAL AS RAZAO_PRODUTOR,'
      '         CASE'
      '            WHEN (CN.STATUS = '#39'C'#39') THEN '#39'Cancelada'#39
      '            WHEN (CN.STATUS = '#39'A'#39') THEN '#39'Aprovada'#39
      '            WHEN (CN.STATUS = '#39'U'#39') THEN '#39'Conclu'#237'do'#39
      '            ELSE '#39'Pendente'#39
      '         END STATUS_N'
      '    FROM CAPA_NEGOCIACAO CN,'
      '         DISTRIBUIDOR    DI,'
      '         PRODUTOR        PO'
      '   WHERE CN.DISTRIBUIDOR_ID = DI.DISTRIBUIDOR_ID'
      '     AND CN.PRODUTOR_ID = PO.PRODUTOR_ID'
      'END'
      ''
      'BEGIN 00'
      '  AND NEGOCIACAO_ID = :PARAM'
      'END'
      ''
      'BEGIN 01'
      '  AND UPPER(DI.RAZAO_SOCIAL) LIKE '#39'%'#39' || UPPER(:PARAM) ||'#39'%'#39
      'END'
      ''
      'BEGIN 02'
      '  AND UPPER(PO.RAZAO_SOCIAL) LIKE '#39'%'#39' || UPPER(:PARAM) ||'#39'%'#39
      'END'
      ''
      'BEGIN 03'
      '  AND CAST(NEGOCIACAO_ID AS VARCHAR(8)) LIKE :PARAM'
      'END')
    Colunas = <
      item
        Expanded = False
        FieldName = 'NEGOCIACAO_ID'
        Title.Caption = 'C'#243'digo'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RAZAO_PRODUTOR'
        Title.Caption = 'Produtor'
        Width = 235
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RAZAO_DISTRIBUIDOR'
        Title.Caption = 'Distribuidor'
        Width = 235
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATUS_N'
        Title.Caption = 'Status'
        Width = 70
        Visible = True
      end>
    QtdeMinima = 0
    Left = 200
    Top = 16
  end
  object qryItensNegociacao: TFDQuery
    Connection = dtmBanco.cConexao
    SQL.Strings = (
      'select * from itens_negociacao')
    Left = 143
    Top = 72
    object qryItensNegociacaoITENS_NEGOCIACAO_ID: TIntegerField
      FieldName = 'ITENS_NEGOCIACAO_ID'
      Origin = 'ITENS_NEGOCIACAO_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryItensNegociacaoPRODUTO_ID: TIntegerField
      FieldName = 'PRODUTO_ID'
      Origin = 'PRODUTO_ID'
    end
    object qryItensNegociacaoNOME_PRODUTO: TStringField
      FieldName = 'NOME_PRODUTO'
      Origin = 'NOME_PRODUTO'
      Size = 100
    end
    object qryItensNegociacaoPRECO_UNITARIO: TCurrencyField
      FieldName = 'PRECO_UNITARIO'
      Origin = 'PRECO_UNITARIO'
    end
    object qryItensNegociacaoQUANTIDADE: TIntegerField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
    end
    object qryItensNegociacaoNEGOCIACAO_ID: TIntegerField
      FieldName = 'NEGOCIACAO_ID'
      Origin = 'NEGOCIACAO_ID'
    end
  end
  object psqItensNegociacao: TPesqAvaliacao
    DataSet = qryItensNegociacao
    Indices.Strings = (
      'C'#243'digo;0'
      '')
    IndicePadrao = 2
    SQL.Strings = (
      'BEGIN SELECT'
      '  SELECT *'
      '    FROM ITENS_NEGOCIACAO'
      '   WHERE 1=1'
      'END'
      ''
      'BEGIN 00'
      '  AND NEGOCIACAO_ID = :PARAM'
      'END'
      '')
    Colunas = <>
    QtdeMinima = 0
    Left = 199
    Top = 72
  end
end
