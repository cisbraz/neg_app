inherited uFrmProduto: TuFrmProduto
  Caption = 'Cadastro de produtos'
  ClientHeight = 159
  ClientWidth = 621
  ExplicitWidth = 627
  ExplicitHeight = 187
  PixelsPerInch = 96
  TextHeight = 13
  object lblCodigo: TLabel [0]
    Left = 8
    Top = 72
    Width = 33
    Height = 13
    Caption = 'C'#243'digo'
  end
  object lblNomeProduto: TLabel [1]
    Left = 8
    Top = 114
    Width = 68
    Height = 13
    Caption = 'Nome produto'
  end
  object lblPreco: TLabel [2]
    Left = 521
    Top = 114
    Width = 27
    Height = 13
    Caption = 'Pre'#231'o'
  end
  inherited cbrMenu: TCoolBar
    Width = 621
    Bands = <
      item
        Control = tbrMenu
        ImageIndex = -1
        MinHeight = 132
        Width = 618
      end>
    ExplicitWidth = 621
    inherited tbrMenu: TToolBar
      Width = 618
      ExplicitWidth = 618
      inherited btnExcluir: TToolButton
        OnClick = btnExcluirClick
      end
      inherited btnGravar: TToolButton
        OnClick = btnGravarClick
      end
      inherited btnCancelar: TToolButton
        OnClick = btnCancelarClick
      end
      inherited tbtSeparador: TToolButton
        Width = 192
        ExplicitWidth = 192
      end
      inherited btnPesquisar: TToolButton
        Left = 351
        OnClick = btnPesquisarClick
        ExplicitLeft = 351
      end
      inherited ToolButton1: TToolButton
        Left = 404
        ExplicitLeft = 404
      end
      inherited ToolButton8: TToolButton
        Left = 559
        ExplicitLeft = 559
      end
      inherited btnFechar: TToolButton
        Left = 560
        ExplicitLeft = 560
      end
    end
  end
  object edtCodigo: TCurrencyEdit
    Left = 8
    Top = 89
    Width = 94
    Height = 21
    Alignment = taRightJustify
    Decimals = -1
    NumeroNegativo = False
    MaxLength = 8
    NumberFormat = Standard
    OnKeyDown = edtCodigoKeyDown
    TabOrder = 0
  end
  object edtNomeProduto: TEdit
    Left = 8
    Top = 130
    Width = 507
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 100
    TabOrder = 2
    OnKeyDown = chkAtivoKeyDown
  end
  object edtPreco: TCurrencyEdit
    Left = 521
    Top = 130
    Width = 94
    Height = 21
    Alignment = taRightJustify
    Decimals = 2
    NumeroNegativo = False
    MaxLength = 6
    NumberFormat = Standard
    OnKeyDown = chkAtivoKeyDown
    TabOrder = 3
  end
  object chkAtivo: TCheckBox
    Left = 116
    Top = 91
    Width = 45
    Height = 17
    Caption = 'Ativo'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnKeyDown = chkAtivoKeyDown
  end
end
