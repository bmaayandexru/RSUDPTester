unit UfrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CPort, Vcl.StdCtrls, Vcl.ExtCtrls,
  CPortCtl, JvAppStorage, JvAppIniStorage, JvComponentBase, JvFormPlacement,
  Vcl.Samples.Spin, IdUDPServer, IdGlobal, IdSocketHandle, IdUDPClient,
  IdBaseComponent, IdComponent, IdUDPBase, JvExControls, JvComCtrls;

type
  TfrmMain = class(TForm)
    ComPort: TComPort;
    gbComPort: TGroupBox;
    btnSetupComPort: TButton;
    cbxOpenComPort: TCheckBox;
    edComPort: TEdit;
    GroupBox1: TGroupBox;
    btnTransmit: TButton;
    cbxSendBuffer: TComboBox;
    btnStrToBuffer: TButton;
    btnAddToListBuffer: TButton;
    btnRemoveFromListBuffer: TButton;
    cbxTraffic: TCheckBox;
    cbxPackOnly: TCheckBox;
    GroupBox2: TGroupBox;
    cbxOnSendTimer: TCheckBox;
    JvFormStorage1: TJvFormStorage;
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    sedCBR: TSpinEdit;
    lbCBR: TLabel;
    sedTimerInt: TSpinEdit;
    Label1: TLabel;
    tmrSend: TTimer;
    btnFill: TButton;
    edSample: TEdit;
    sedFillCount: TSpinEdit;
    cbxFillRandom: TCheckBox;
    cbxFillCounter: TCheckBox;
    cbxOnRSXch: TCheckBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    edRecvPort: TLabeledEdit;
    edSendPort: TLabeledEdit;
    IPAddress: TJvIPAddress;
    btnChRecvPort: TButton;
    IdUDPServer: TIdUDPServer;
    IdUDPClient: TIdUDPClient;
    cbxOnUDPXCh: TCheckBox;
    cbxLoop: TCheckBox;
    cbxAnswEdit: TCheckBox;
    btnCS: TButton;
    btnAddToListStr: TButton;
    btnRemoveFromListStr: TButton;
    cbxSendStr: TComboBox;
    cbxFillPattern: TCheckBox;
    rbSendBuffer: TRadioButton;
    rbSendStr: TRadioButton;
    procedure btnSetupComPortClick(Sender: TObject);
    procedure cbxOpenComPortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTransmitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxTrafficClick(Sender: TObject);
    procedure btnAddToListBufferClick(Sender: TObject);
    procedure btnStrToBufferClick(Sender: TObject);
    procedure btnRemoveFromListBufferClick(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure cbxOnSendTimerClick(Sender: TObject);
    procedure tmrSendTimer(Sender: TObject);
    procedure sedTimerIntChange(Sender: TObject);
    procedure btnFillClick(Sender: TObject);
    procedure cbxFillRandomClick(Sender: TObject);
    procedure cbxFillCounterClick(Sender: TObject);
    procedure btnChRecvPortClick(Sender: TObject);
    procedure IdUDPServerUDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure btnCSClick(Sender: TObject);
    procedure btnAddToListStrClick(Sender: TObject);
    procedure btnRemoveFromListStrClick(Sender: TObject);
    procedure cbxFillPatternClick(Sender: TObject);
    procedure cbxSendStrKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Showed : boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
uses bmaTools, UfrmTraffic1;

procedure TfrmMain.btnAddToListBufferClick(Sender: TObject);
begin
  // если нет ткого элемента то добавляем
  if cbxSendBuffer.Items.IndexOf(cbxSendBuffer.Text) = -1 then cbxSendBuffer.Items.Add(cbxSendBuffer.Text);
end;

procedure TfrmMain.btnAddToListStrClick(Sender: TObject);
begin
  // если нет ткого элемента то добавляем
  if cbxSendStr.Items.IndexOf(cbxSendStr.Text) = -1 then cbxSendStr.Items.Add(cbxSendStr.Text);
end;

procedure TfrmMain.btnChRecvPortClick(Sender: TObject);
var
  Port: integer;
begin
  if not TryStrToInt(edRecvPort.Text,Port) then Port:=52600;
  ReCreateUDPServer(IdUDPServer,self,Port);
end;

procedure TfrmMain.btnCSClick(Sender: TObject);
var
  buf : TBA;
  count : integer;
  CS, i : word;
begin
  // взять из edit buffer
  // посчитать слово КС от 4го байта и добавить к буферу
  HexStrToBuffer(cbxSendBuffer.Text,buf,count);
  CS := 0;
  for i:=4 to count-1 do inc(CS,buf[i]);
  move(CS,buf[count],2);
  inc(count,2);
  // вернуть буфер в строку
  cbxSendBuffer.Text:=BufferToStr(buf,count);
end;

procedure TfrmMain.btnFillClick(Sender: TObject);
var
  sbuf : TBAs;
  scount,i  : integer;
  dbuf :TBA;
  tmpc : TColor;
begin
  if cbxFillRandom.Checked then begin
    // заполнение рандомом
    for i := 0 to sedFillCount.Value-1 do  dbuf[i]:=Random(256);
  end else
  if cbxFillCounter.Checked then begin
    // заполнение счетчиком
    for i := 0 to sedFillCount.Value-1 do  dbuf[i]:=i;
  end else  begin
    // заполнение образцом
    HexStrToBuffer(edSample.Text,sbuf,scount);
    if scount = 0 then begin
      tmpc:= edSample.Color;
      edSample.Color := clRed;
      Application.ProcessMessages;
      Sleep(500);
      edSample.Color := tmpc;
      exit;
    end;
    i:=0;
    while i < sedFillCount.Value do begin
      Move(sbuf,dbuf[i],scount);
      inc(i,scount);
    end;
  end;
  cbxSendBuffer.Text:=BufferToStr(dbuf,sedFillCount.Value);
end;

procedure TfrmMain.btnRemoveFromListBufferClick(Sender: TObject);
var
  i:integer;
begin
  i:=cbxSendBuffer.Items.IndexOf(cbxSendBuffer.Text);
  if i > -1 then cbxSendBuffer.Items.Delete(i);
  if i < cbxSendBuffer.Items.Count
    then cbxSendBuffer.ItemIndex := i
    else cbxSendBuffer.ItemIndex := cbxSendBuffer.Items.Count - 1;
end;

procedure TfrmMain.btnRemoveFromListStrClick(Sender: TObject);
var
  i:integer;
begin
  i:=cbxSendStr.Items.IndexOf(cbxSendStr.Text);
  if i > -1 then cbxSendStr.Items.Delete(i);
  if i < cbxSendStr.Items.Count
    then cbxSendStr.ItemIndex := i
    else cbxSendStr.ItemIndex := cbxSendStr.Items.Count - 1;
end;

procedure TfrmMain.btnSetupComPortClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
  lbCBR.Visible := (ComPort.BaudRate = brCustom);
  sedCBR.Visible := (ComPort.BaudRate = brCustom);
end;

procedure TfrmMain.btnStrToBufferClick(Sender: TObject);
var
  buf:TBA;
  count:integer;
begin
  CharStrToBuffer(cbxSendStr.Text,buf,count);
  cbxSendBuffer.Text:=BufferToStr(buf,count);
end;

procedure TfrmMain.btnTransmitClick(Sender: TObject);
var
  buf:TBA;
  count,Port:integer;
  IdBuf:TIdBytes;
begin
  if not ComPort.Connected then begin
    // предупредить пользователя
    frmTraffic1.WriteLine('COM-порт не подключен');
    // отключаем передачу
    cbxOnRSXch.Checked:=false;
    // exit;
  end;
  // получить буфер из строки
  if rbSendBuffer.Checked then begin
    HexStrToBuffer(cbxSendBuffer.Text,buf,count);
    cbxSendBuffer.Text:=BufferToStr(buf,count);
  end;
  if rbSendStr.Checked then begin
    CharStrToBuffer(cbxSendStr.Text,buf,count);
  end;
  if cbxOnRSXch.Checked then begin
    try
    ComPort.Write(buf,count);
    except
      cbxOnSendTimer.Checked:=false;
    end;
    frmTraffic1.SendBuf(buf,count);
  end;
  if cbxOnUDPXCh.Checked then begin
    BufferToIdBuf(buf, count, IdBuf);
    Port:=StrToInt(edSendPort.Text);
    IdUDPClient.SendBuffer(IPAddress.Text,Port,IdBuf);
    frmTraffic1.SendBuf(IdBuf);
  end;
end;

procedure TfrmMain.cbxOpenComPortClick(Sender: TObject);
begin
  if cbxOpenComPort.Checked then begin
  // открываем
    try
      if ComPort.BaudRate = brCustom then begin
        ComPort.CustomBaudRate := sedCBR.Value;
      end;

      ComPort.Open;
      edComPort.Text:=ComPort.Port;
      gbComPort.Caption:=ExPortParamsStr(ComPort);
      edComPort.Hint:=PortParamsStr(ComPort);
      btnSetupComPort.Enabled:=false;
      sedCBR.Enabled:=false;
    except
      MessageDlg('Порт занят, отсутсвует или ошибка в параметрах настройки!',mtError,[mbCancel],0);
      gbComPort.Caption:=ExPortParamsStr(nil);
      edComPort.Text:='';
      edComPort.TextHint:=PortParamsStr(nil);
      btnSetupComPort.Enabled:=true;
      cbxOpenComPort.Checked:=false;
      sedCBR.Enabled:=true;
      ComPort.Close;
    end;
  end else begin
  // закрываем
    ComPort.Close;
    gbComPort.Caption:=ExPortParamsStr(nil);
    edComPort.Text:='';
    edComPort.TextHint:=PortParamsStr(nil);
    btnSetupComPort.Enabled:=true;
    sedCBR.Enabled:=true;
  end;
end;

procedure TfrmMain.cbxSendStrKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    if rbSendStr.Checked then begin
       btnTransmitClick(btnTransmit);
    end;
  end;
end;

procedure TfrmMain.cbxTrafficClick(Sender: TObject);
begin
  if cbxTraffic.Checked
    then frmTraffic1.Show
    else frmTraffic1.Close;
end;

procedure TfrmMain.cbxFillCounterClick(Sender: TObject);
begin
  if cbxFillCounter.Checked then begin
    cbxFillRandom.Checked:=false;
    cbxFillPattern.Checked:=false;
  end;
end;

procedure TfrmMain.cbxFillPatternClick(Sender: TObject);
begin
  if cbxFillPattern.Checked then begin
    cbxFillRandom.Checked := false;
    cbxFillCounter.Checked := false;
  end;
end;

procedure TfrmMain.cbxFillRandomClick(Sender: TObject);
begin
  if cbxFillRandom.Checked then begin
   cbxFillCounter.Checked:=false;
   cbxFillPattern.Checked:=false;
  end;
end;

procedure TfrmMain.cbxOnSendTimerClick(Sender: TObject);
begin
  tmrSend.Interval := sedTimerInt.Value;
  tmrSend.Enabled := cbxOnSendTimer.Checked;
end;

procedure TfrmMain.ComPortRxChar(Sender: TObject; Count: Integer);
var
  buf:TBA;
begin
  ComPort.Read(buf, Count);
  frmTraffic1.RecvBuf(buf,Count);
  // петля
  if cbxLoop.Checked then begin
    if cbxOnRSXch.Checked then begin
      try
      ComPort.Write(buf,count);
      except
        cbxOnSendTimer.Checked:=false;
      end;
      frmTraffic1.SendBuf(buf,count);
    end;
  end;
  // ответ из edit
  if cbxAnswEdit.Checked then begin
    // получить буфер из строки
    HexStrToBuffer(cbxSendBuffer.Text,buf,count);
    cbxSendBuffer.Text:=BufferToStr(buf,count);
    if cbxOnRSXch.Checked then begin
      try
      ComPort.Write(buf,count);
      except
        cbxOnSendTimer.Checked:=false;
      end;
      frmTraffic1.SendBuf(buf,count);
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  fn,fp:string;
begin
  fn:=ExtractFileName(ParamStr(0));
  fn:=ChangeFileExt(fn,'.ini');
  fp:=ExtractFilePath(ParamStr(0));
  JvAppIniFileStorage1.FileName:=fp+fn;
  JvFormStorage1.Active:=true;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  lbCBR.Visible := (ComPort.BaudRate = brCustom);
  sedCBR.Visible := (ComPort.BaudRate = brCustom);
  Showed := true;
  btnChRecvPortClick(nil);
end;

procedure TfrmMain.IdUDPServerUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  Port : word;
begin
  frmTraffic1.RecvBuf(AData);
  // петля
  if cbxLoop.Checked then begin
    if cbxOnUDPXCh.Checked then begin
      Port:=StrToInt(edSendPort.Text);
      IdUDPClient.SendBuffer(IPAddress.Text,Port,AData);
      frmTraffic1.SendBuf(AData);
    end;
  end;
end;

procedure TfrmMain.sedTimerIntChange(Sender: TObject);
begin
  tmrSend.Interval := sedTimerInt.Value;
end;

procedure TfrmMain.tmrSendTimer(Sender: TObject);
begin
  btnTransmitClick(nil);
end;

end.
