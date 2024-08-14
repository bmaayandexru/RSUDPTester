object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'RSUDP Tester'
  ClientHeight = 297
  ClientWidth = 631
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    631
    297)
  PixelsPerInch = 96
  TextHeight = 13
  object gbComPort: TGroupBox
    Left = 3
    Top = 4
    Width = 213
    Height = 92
    Caption = 'Com Port - not defined'
    TabOrder = 0
    object lbCBR: TLabel
      Left = 115
      Top = 46
      Width = 83
      Height = 13
      Caption = 'Custom Baudrate'
    end
    object btnSetupComPort: TButton
      Left = 12
      Top = 20
      Width = 66
      Height = 25
      Caption = #1053#1072#1089#1090#1088#1086#1080#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnSetupComPortClick
    end
    object cbxOpenComPort: TCheckBox
      Left = 84
      Top = 24
      Width = 66
      Height = 17
      Caption = #1054#1090#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = cbxOpenComPortClick
    end
    object edComPort: TEdit
      Left = 156
      Top = 22
      Width = 42
      Height = 21
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
    end
    object sedCBR: TSpinEdit
      Left = 115
      Top = 63
      Width = 83
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 115200
    end
    object cbxOnRSXch: TCheckBox
      Left = 14
      Top = 66
      Width = 73
      Height = 17
      Caption = #1042#1082#1083#1102#1095#1080#1090#1100
      TabOrder = 4
    end
  end
  object GroupBox1: TGroupBox
    Left = 3
    Top = 144
    Width = 627
    Height = 150
    Anchors = [akLeft, akTop, akRight]
    Caption = #1055#1077#1088#1077#1076#1072#1095#1072
    TabOrder = 1
    DesignSize = (
      627
      150)
    object btnTransmit: TButton
      Left = 14
      Top = 31
      Width = 97
      Height = 25
      Caption = #1055#1077#1088#1077#1076#1072#1090#1100
      TabOrder = 0
      OnClick = btnTransmitClick
    end
    object cbxSendBuffer: TComboBox
      Left = 144
      Top = 20
      Width = 425
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 16
      Sorted = True
      TabOrder = 1
    end
    object btnStrToBuffer: TButton
      Left = 143
      Top = 45
      Width = 97
      Height = 25
      Caption = #1057#1090#1088#1086#1082#1091' '#1074' '#1073#1091#1092#1077#1088
      TabOrder = 2
      OnClick = btnStrToBufferClick
    end
    object btnAddToListBuffer: TButton
      Left = 568
      Top = 18
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '+'
      TabOrder = 3
      OnClick = btnAddToListBufferClick
    end
    object btnRemoveFromListBuffer: TButton
      Left = 592
      Top = 18
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '-'
      TabOrder = 4
      OnClick = btnRemoveFromListBufferClick
    end
    object cbxTraffic: TCheckBox
      Left = 24
      Top = 116
      Width = 65
      Height = 17
      Caption = #1058#1088#1072#1092#1080#1082
      TabOrder = 5
      OnClick = cbxTrafficClick
    end
    object cbxPackOnly: TCheckBox
      Left = 112
      Top = 116
      Width = 97
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1087#1072#1082#1077#1090#1099
      TabOrder = 6
    end
    object btnFill: TButton
      Left = 16
      Top = 80
      Width = 95
      Height = 25
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100
      TabOrder = 7
      OnClick = btnFillClick
    end
    object edSample: TEdit
      Left = 399
      Top = 82
      Width = 218
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
    object sedFillCount: TSpinEdit
      Left = 128
      Top = 81
      Width = 56
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 9
      Value = 100
    end
    object cbxFillRandom: TCheckBox
      Left = 190
      Top = 84
      Width = 57
      Height = 17
      Caption = 'Random'
      TabOrder = 10
      OnClick = cbxFillRandomClick
    end
    object cbxFillCounter: TCheckBox
      Left = 253
      Top = 84
      Width = 57
      Height = 17
      Caption = 'Counter'
      TabOrder = 11
      OnClick = cbxFillCounterClick
    end
    object cbxLoop: TCheckBox
      Left = 232
      Top = 116
      Width = 57
      Height = 17
      Caption = #1055#1077#1090#1083#1103
      TabOrder = 12
    end
    object cbxAnswEdit: TCheckBox
      Left = 316
      Top = 116
      Width = 101
      Height = 17
      Caption = #1054#1090#1074#1077#1095#1072#1090#1100' '#1080#1079' edit'
      TabOrder = 13
    end
    object btnCS: TButton
      Left = 440
      Top = 112
      Width = 36
      Height = 25
      Caption = 'CS'
      TabOrder = 14
      OnClick = btnCSClick
    end
    object btnAddToListStr: TButton
      Left = 568
      Top = 45
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '+'
      TabOrder = 15
      OnClick = btnAddToListStrClick
    end
    object btnRemoveFromListStr: TButton
      Left = 592
      Top = 45
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '-'
      TabOrder = 16
      OnClick = btnRemoveFromListStrClick
    end
    object cbxSendStr: TComboBox
      Left = 240
      Top = 47
      Width = 329
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 16
      Sorted = True
      TabOrder = 17
      OnKeyPress = cbxSendStrKeyPress
    end
    object cbxFillPattern: TCheckBox
      Left = 316
      Top = 84
      Width = 77
      Height = 17
      Caption = 'Hex Pattern'
      TabOrder = 18
      OnClick = cbxFillPatternClick
    end
    object rbSendBuffer: TRadioButton
      Left = 117
      Top = 22
      Width = 20
      Height = 17
      Checked = True
      TabOrder = 19
      TabStop = True
    end
    object rbSendStr: TRadioButton
      Left = 117
      Top = 49
      Width = 20
      Height = 17
      TabOrder = 20
    end
  end
  object GroupBox2: TGroupBox
    Left = 3
    Top = 95
    Width = 241
    Height = 43
    Caption = #1055#1077#1088#1077#1076#1072#1095#1072' '#1087#1086' '#1090#1072#1084#1077#1088#1091
    TabOrder = 2
    object Label1: TLabel
      Left = 108
      Top = 18
      Width = 60
      Height = 13
      Caption = #1055#1077#1088#1080#1086#1076' ('#1084#1089')'
    end
    object cbxOnSendTimer: TCheckBox
      Left = 8
      Top = 16
      Width = 73
      Height = 17
      Caption = #1042#1082#1083#1102#1095#1080#1090#1100
      TabOrder = 0
      OnClick = cbxOnSendTimerClick
    end
    object sedTimerInt: TSpinEdit
      Left = 174
      Top = 13
      Width = 57
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 1000
      OnChange = sedTimerIntChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 250
    Top = 8
    Width = 265
    Height = 117
    Caption = 'UDP'
    TabOrder = 3
    object Label2: TLabel
      Left = 9
      Top = 19
      Width = 83
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1087#1077#1088#1077#1076#1072#1095#1080
    end
    object edRecvPort: TLabeledEdit
      Left = 98
      Top = 65
      Width = 48
      Height = 21
      EditLabel.Width = 64
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1088#1090' '#1087#1088#1080#1077#1084#1072
      LabelPosition = lpLeft
      TabOrder = 0
      Text = '52600'
    end
    object edSendPort: TLabeledEdit
      Left = 98
      Top = 40
      Width = 48
      Height = 21
      EditLabel.Width = 77
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1088#1090' '#1087#1077#1088#1077#1076#1072#1095#1080
      LabelPosition = lpLeft
      TabOrder = 1
      Text = '52601'
    end
    object IPAddress: TJvIPAddress
      Left = 98
      Top = 15
      Width = 150
      Height = 21
      ParentColor = False
      TabOrder = 2
    end
    object btnChRecvPort: TButton
      Left = 152
      Top = 63
      Width = 70
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 3
      OnClick = btnChRecvPortClick
    end
    object cbxOnUDPXCh: TCheckBox
      Left = 17
      Top = 92
      Width = 73
      Height = 17
      Caption = #1042#1082#1083#1102#1095#1080#1090#1100
      TabOrder = 4
    end
  end
  object ComPort: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    OnRxChar = ComPortRxChar
    Left = 296
    Top = 136
  end
  object JvFormStorage1: TJvFormStorage
    Active = False
    AppStorage = JvAppIniFileStorage1
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'ComPort.Port'
      'ComPort.BaudRate'
      'ComPort.DataBits'
      'ComPort.Parity'
      'ComPort.StopBits'
      'ComPort.FlowControl'
      'cbxOpenComPort.Checked'
      'sedCBR.Value'
      'cbxTraffic.Checked'
      'cbxSendBuffer.Items'
      'cbxSendBuffer.ItemIndex'
      'cbxOnSendTimer.Checked'
      'sedTimerInt.Value'
      'edSample.Text'
      'cbxFillCounter.Checked'
      'cbxFillRandom.Checked'
      'IPAddress.Text'
      'edRecvPort.Text'
      'edSendPort.Text'
      'cbxOnRSXch.Checked'
      'cbxOnUDPXCh.Checked'
      'cbxLoop.Checked'
      'cbxAnswEdit.Checked'
      'cbxFillPattern.Checked'
      'cbxSendStr.Items'
      'rbSendStr.Checked'
      'rbSendBuffer.Checked'
      'cbxSendStr.ItemIndex')
    StoredValues = <>
    Left = 560
  end
  object JvAppIniFileStorage1: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    FileName = 'FilenameRequired.ini'
    DefaultSection = 'General'
    SubStorages = <>
    Left = 520
    Top = 65535
  end
  object tmrSend: TTimer
    Enabled = False
    OnTimer = tmrSendTimer
    Left = 359
    Top = 135
  end
  object IdUDPServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 52600
    OnUDPRead = IdUDPServerUDPRead
    Left = 512
    Top = 72
  end
  object IdUDPClient: TIdUDPClient
    Active = True
    Port = 52601
    Left = 568
    Top = 72
  end
end
