inherited uFrmDistribuidor: TuFrmDistribuidor
  Caption = 'Cadastro de distribuidor'
  ClientHeight = 115
  ClientWidth = 630
  ExplicitWidth = 636
  ExplicitHeight = 143
  PixelsPerInch = 96
  TextHeight = 13
  object lblCnpj: TLabel [0]
    Left = 8
    Top = 72
    Width = 25
    Height = 13
    Caption = 'CNPJ'
  end
  object lblRazaoSocial: TLabel [1]
    Left = 135
    Top = 72
    Width = 59
    Height = 13
    Caption = 'Raz'#227'o social'
  end
  inherited cbrMenu: TCoolBar
    Width = 630
    Bands = <
      item
        Control = tbrMenu
        ImageIndex = -1
        MinHeight = 132
        Width = 627
      end>
    ExplicitWidth = 630
    inherited tbrMenu: TToolBar
      Width = 627
      ExplicitWidth = 627
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
        Width = 163
        ExplicitLeft = 404
        ExplicitWidth = 163
      end
      inherited ToolButton8: TToolButton
        Left = 567
        ExplicitLeft = 567
      end
      inherited btnFechar: TToolButton
        Left = 568
        ExplicitLeft = 568
      end
    end
  end
  object edtCnpj: TMaskEdit
    Left = 8
    Top = 89
    Width = 118
    Height = 21
    EditMask = '99\.999\.999\/9999\-99;1;_'
    MaxLength = 18
    TabOrder = 0
    Text = '  .   .   /    -  '
    OnKeyDown = edtCnpjKeyDown
  end
  object edtRazaoSocial: TEdit
    Left = 134
    Top = 89
    Width = 435
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 100
    TabOrder = 1
    OnKeyDown = edtRazaoSocialKeyDown
  end
  object chkAtivo: TCheckBox
    Left = 577
    Top = 91
    Width = 45
    Height = 17
    Caption = 'Ativo'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnKeyDown = edtRazaoSocialKeyDown
  end
end
