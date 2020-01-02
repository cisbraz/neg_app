inherited uFrmParametro: TuFrmParametro
  Caption = 'Par'#226'metros'
  ClientHeight = 120
  ClientWidth = 621
  ExplicitWidth = 627
  ExplicitHeight = 149
  PixelsPerInch = 96
  TextHeight = 13
  object lblNomeProduto: TLabel [0]
    Left = 3
    Top = 74
    Width = 111
    Height = 13
    Caption = 'Url acesso negocia'#231#245'es'
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
        Visible = False
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
        Width = 181
        ExplicitLeft = 404
        ExplicitWidth = 181
      end
      inherited ToolButton8: TToolButton
        Left = 585
        ExplicitLeft = 585
      end
      inherited btnFechar: TToolButton
        Left = 586
        ExplicitLeft = 586
      end
    end
  end
  object edtUrlAcessoNegociacao: TEdit
    Left = 2
    Top = 91
    Width = 610
    Height = 21
    MaxLength = 100
    TabOrder = 0
  end
end
