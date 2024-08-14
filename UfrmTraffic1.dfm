object frmTraffic1: TfrmTraffic1
  Left = 0
  Top = 0
  Caption = #1058#1088#1072#1092#1080#1082
  ClientHeight = 328
  ClientWidth = 1032
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 501
    Top = 0
    Height = 328
    ExplicitLeft = 352
    ExplicitTop = 288
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 501
    Height = 328
    Align = alLeft
    TabOrder = 0
    object memSend: TMemo
      Left = 1
      Top = 30
      Width = 499
      Height = 278
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -5
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = memSendDblClick
    end
    object sbSend: TStatusBar
      Left = 1
      Top = 308
      Width = 499
      Height = 19
      Panels = <
        item
          Width = 200
        end
        item
          Width = 50
        end>
      OnDblClick = sbSendDblClick
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 499
      Height = 29
      Align = alTop
      TabOrder = 2
      OnDblClick = Panel2DblClick
      DesignSize = (
        499
        29)
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 50
        Height = 13
        Caption = #1055#1077#1088#1077#1076#1072#1095#1072
      end
      object cbxSBEShow: TCheckBox
        Left = 88
        Top = 6
        Width = 41
        Height = 17
        Caption = #1085'/'#1093
        TabOrder = 0
      end
      object sedSB: TSpinEdit
        Left = 127
        Top = 3
        Width = 41
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object sedSE: TSpinEdit
        Left = 174
        Top = 3
        Width = 41
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object cbxSSize: TCheckBox
        Left = 231
        Top = 6
        Width = 56
        Height = 17
        Caption = #1088#1072#1079#1084#1077#1088
        TabOrder = 3
      end
      object cbxSChars: TCheckBox
        Left = 429
        Top = 6
        Width = 65
        Height = 17
        Anchors = [akTop, akRight]
        Caption = #1089#1080#1084#1074#1086#1083#1099
        TabOrder = 4
      end
    end
  end
  object Panel3: TPanel
    Left = 504
    Top = 0
    Width = 528
    Height = 328
    Align = alClient
    TabOrder = 1
    object memRecv: TMemo
      Left = 1
      Top = 30
      Width = 526
      Height = 278
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -5
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = memRecvDblClick
    end
    object sbRecv: TStatusBar
      Left = 1
      Top = 308
      Width = 526
      Height = 19
      Panels = <
        item
          Width = 200
        end
        item
          Width = 50
        end>
      OnDblClick = sbRecvDblClick
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 526
      Height = 29
      Align = alTop
      TabOrder = 2
      DesignSize = (
        526
        29)
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 31
        Height = 13
        Caption = #1055#1088#1080#1077#1084
      end
      object cbxRChars: TCheckBox
        Left = 456
        Top = 6
        Width = 65
        Height = 17
        Anchors = [akTop, akRight]
        Caption = #1089#1080#1084#1074#1086#1083#1099
        TabOrder = 0
      end
      object cbxRBEShow: TCheckBox
        Left = 64
        Top = 6
        Width = 73
        Height = 17
        Caption = #1085'/'#1093
        TabOrder = 1
      end
      object sedRB: TSpinEdit
        Left = 103
        Top = 1
        Width = 41
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object sedRE: TSpinEdit
        Left = 150
        Top = 1
        Width = 41
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 0
      end
      object cbxRSize: TCheckBox
        Left = 209
        Top = 6
        Width = 56
        Height = 17
        Caption = #1088#1072#1079#1084#1077#1088
        TabOrder = 4
      end
    end
  end
  object JvFormStorage1: TJvFormStorage
    Active = False
    AppStorage = frmMain.JvAppIniFileStorage1
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'Panel1.Width'
      'cbxRChars.Checked'
      'cbxRBEShow.Checked'
      'cbxSBEShow.Checked'
      'sedRB.Value'
      'sedRE.Value'
      'sedSB.Value'
      'sedSE.Value'
      'cbxRSize.Checked'
      'cbxSChars.Checked'
      'cbxSSize.Checked')
    StoredValues = <>
  end
end
