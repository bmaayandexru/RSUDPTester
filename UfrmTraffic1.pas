unit UfrmTraffic1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  JvComponentBase, JvFormPlacement, JvAppStorage, JvAppIniStorage, bmaTools,
  Vcl.Samples.Spin, IdGlobal;

type
  TfrmTraffic1 = class(TForm)
    Panel1: TPanel;
    memSend: TMemo;
    sbSend: TStatusBar;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    memRecv: TMemo;
    sbRecv: TStatusBar;
    Panel4: TPanel;
    JvFormStorage1: TJvFormStorage;
    Label1: TLabel;
    Label2: TLabel;
    cbxRChars: TCheckBox;
    cbxSBEShow: TCheckBox;
    sedSB: TSpinEdit;
    sedSE: TSpinEdit;
    cbxRBEShow: TCheckBox;
    sedRB: TSpinEdit;
    sedRE: TSpinEdit;
    cbxRSize: TCheckBox;
    cbxSSize: TCheckBox;
    cbxSChars: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure sbSendDblClick(Sender: TObject);
    procedure sbRecvDblClick(Sender: TObject);
    procedure memSendDblClick(Sender: TObject);
    procedure memRecvDblClick(Sender: TObject);
    procedure Panel2DblClick(Sender: TObject);
  private
    { Private declarations }
    drtime, dstime, rtime, stime: longword;
  public
    { Public declarations }
    SPacks, SBytes, RPacks, RTPacks, RBytes:longword;
    SSTime, SRTime:longword;
    procedure SendBuf(const buf; count:integer); overload;
    procedure SendBuf(const idBuf:TIdBytes); overload;
    procedure RecvBuf(const buf; count: integer); overload;
    procedure RecvBuf(const idBuf: TIdBytes); overload;
    procedure RecvPack(const buf; count: integer);
    procedure WriteLine(const s: string);
  end;

var
  frmTraffic1: TfrmTraffic1;

implementation
uses UfrmMain;
{$R *.dfm}


procedure TfrmTraffic1.FormCreate(Sender: TObject);
begin
  JvFormStorage1.Active:=true;
  SSTime:=GetTickCount;
  SRTime:=SSTime;
end;

procedure TfrmTraffic1.SendBuf(const buf; count:integer);
var
  s, ssize: string;
  sw: integer;
begin
  if cbxSBEShow.Checked then begin
    // начало и хвост
    s:=BufferToStrBE(buf,count,sedSB.Value,sedSE.Value);
  end
  else s:=BufferToStr(buf,count);
  ssize:='';
  if cbxSSize.Checked then begin
    ssize:=format('[%3d]',[count]);
  end;
  s:='P'+ssize+': '+s;
  memSend.Lines.Add(s);
  if cbxSChars.Checked then begin
    s:=BufferToCharStr(buf,count);
    memSend.Lines.Add('C:('+s+')');
  end;
  inc(SPacks);
  inc(SBytes,count);
  s:='Передано байт: '+IntToStr(SBytes)+' пакетов: '+IntToStr(SPacks);
  sw:=sbSend.Canvas.TextWidth(s) + 10;
  sbSend.Panels[0].Width := sw ;
  sbSend.Panels[0].Text := s;
  dstime:=GetTickCount-stime;
  if (dstime > 0) and ((GetTickCount-SSTime) > 0)  then
  sbSend.Panels[1].Text:='Скорость бод: '+IntToStr(trunc(count*8*1000/dstime))+' интегр.: '+format('%d',[round(SBytes*8*1000.0/(GetTickCount-SSTime))]);
  stime:=GetTickCount();
end;

procedure TfrmTraffic1.SendBuf(const idbuf:TIdBytes);
var
  s, ssize: string;
  sw, count: integer;
begin

  if cbxSBEShow.Checked then begin
    // начало и хвост
    s:=IdBufToStrBE(idbuf,sedSB.Value,sedSE.Value);
  end
  else s:=IdBufToStr(idbuf);
  ssize:='';
  count:=Length(idbuf);
  if cbxSSize.Checked then begin
    ssize:=format('[%3d]',[count]);
  end;
  s:='P'+ssize+': '+s;
  memSend.Lines.Add(s);
  if cbxSChars.Checked then begin
    s:=IdBufToCharStr(idbuf);
    memSend.Lines.Add('C:('+s+')');
  end;
  inc(SPacks);
  inc(SBytes,count);
  s:='Передано байт: '+IntToStr(SBytes)+' пакетов: '+IntToStr(SPacks);
  sw:=sbSend.Canvas.TextWidth(s) + 10;
  sbSend.Panels[0].Width := sw ;
  sbSend.Panels[0].Text := s;
  dstime:=GetTickCount-stime;
  if (dstime > 0) and ((GetTickCount-SSTime) > 0)  then
  sbSend.Panels[1].Text:='Скорость бод: '+IntToStr(trunc(count*8*1000/dstime))+' интегр.: '+format('%d',[round(SBytes*8*1000.0/(GetTickCount-SSTime))]);
  stime:=GetTickCount();

end;

procedure TfrmTraffic1.WriteLine(const s:string);
begin
  memSend.Lines.Add(s);
end;

procedure TfrmTraffic1.memRecvDblClick(Sender: TObject);
begin
  memRecv.Clear;
end;

procedure TfrmTraffic1.memSendDblClick(Sender: TObject);
begin
  memSend.Clear;
end;

procedure TfrmTraffic1.Panel2DblClick(Sender: TObject);
var
  onTimer: boolean;
//  tc: longword;
begin
  // запоминаем значение таймера передачи
  onTimer:=frmMain.tmrSend.Enabled;
  // останавливаем таймер передачи
  frmMain.tmrSend.Enabled:=false;
  // ждем гарантированной отработки последнего события (проверить!!!! может и не надо! НЕ НАДО!!! ПРОВЕРЕНО)
  // tc:=GetTickCount();
  // while (GetTickCount()-tc) < 1000{frmMain.tmrSend.Interval} do ;
  // сбрасываем статистику
  sbRecvDblClick(sbRecv);
  sbSendDblClick(sbSend);
  memSendDblClick(memSend);
  memRecvDblClick(memRecv);
  // возвращаем таймер в исходное состояние
  frmMain.tmrSend.Enabled:=onTimer;
end;

procedure TfrmTraffic1.RecvBuf(const buf; count:integer);
var
  s,ssize,sdrop:string;
  sw, bdrop: integer;
begin
  if cbxRBEShow.Checked then begin
    // начало и хвост
    s:=BufferToStrBE(buf,count,sedRB.Value,sedRE.Value);
  end
  else s:=BufferToStr(buf,count);
  ssize:='';
  if cbxRSize.Checked then begin
    ssize:=format('[%3d]',[count]);
  end;
  s:='T'+ssize+': '+s;
  memRecv.Lines.Add(s);
  if cbxRChars.Checked then begin
    s:=BufferToCharStr(buf,count);
    memRecv.Lines.Add('C:('+s+')');
  end;
  inc(RTPacks);
  inc(RBytes,count);
  // потери петли
  bdrop := SBytes-RBytes;
  sdrop := '('+IntToStr(bdrop)+')';
  s := 'Принято байт: '+IntToStr(RBytes)+ sdrop +' пакетов: '+IntToStr(RTPacks)+ '('+IntToStr(RPacks) + ')';
  sw := sbRecv.Canvas.TextWidth(s) + 10;
  sbRecv.Panels[0].Width := sw;
  sbRecv.Panels[0].Text := s;
  drtime := GetTickCount-rtime;
  if (drtime > 0) and ((GetTickCount-SRTime) > 0) then
  sbRecv.Panels[1].Text:='Скорость бод: '+IntToStr(trunc(count*8*1000/drtime))+' интегр.: '+format('%d',[round(RBytes*8*1000.0/(GetTickCount-SRTime))]);
  rtime:=GetTickCount();
end;

procedure TfrmTraffic1.RecvBuf(const idBuf: TIdBytes);
var
  s,ssize,sdrop:string;
  sw, bdrop, count: integer;
begin
  if cbxRBEShow.Checked then begin
    // начало и хвост
    s:=IdBufToStrBE(idBuf,sedRB.Value,sedRE.Value);
  end
  else s:=IdBufToStr(idBuf);
  ssize:='';
  count:=Length(idBuf);
  if cbxRSize.Checked then begin
    ssize:=format('[%3d]',[count]);
  end;
  s:='T'+ssize+': '+s;
  count:=Length(idBuf);
  memRecv.Lines.Add(s);
  if cbxRChars.Checked then begin
    s:=IdBufToCharStr(idBuf);
    memRecv.Lines.Add('C:('+s+')');
  end;
  inc(RTPacks);
  inc(RBytes,count);
  // потери петли
  bdrop := SBytes-RBytes;
  sdrop := '('+IntToStr(bdrop)+')';
  s := 'Принято байт: '+IntToStr(RBytes)+ sdrop +' пакетов: '+IntToStr(RTPacks)+ '('+IntToStr(RPacks) + ')';
  sw := sbRecv.Canvas.TextWidth(s) + 10;
  sbRecv.Panels[0].Width := sw;
  sbRecv.Panels[0].Text := s;
  drtime := GetTickCount-rtime;
  if (drtime > 0) and ((GetTickCount-SRTime) > 0) then
  sbRecv.Panels[1].Text:='Скорость бод: '+IntToStr(trunc(count*8*1000/drtime))+' интегр.: '+format('%d',[round(RBytes*8*1000.0/(GetTickCount-SRTime))]);
  rtime:=GetTickCount();
end;

procedure TfrmTraffic1.RecvPack(const buf; count:integer);
var
  s:string;
begin
  if cbxRBEShow.Checked then begin
    // начало и хвост
    s:=BufferToStrBE(buf,count,sedRB.Value,sedRE.Value);
  end
  else s:=BufferToStr(buf,count);
  memRecv.Lines.Add('P: '+s);
  inc(RPacks);
//  inc(RBytes,count);
  sbRecv.Panels[0].Text:='Принято байт: '+IntToStr(RBytes)+' пакетов: '+IntToStr(RTPacks)+ '('+IntToStr(RPacks) + ')';;
end;

procedure TfrmTraffic1.sbRecvDblClick(Sender: TObject);
begin
  RPacks:=0;
  RTPacks:=0;
  RBytes:=0;
  SRTime:=GetTickCount;
  sbRecv.Panels[0].Text:='Принято байт: '+IntToStr(RBytes)+' пакетов: '+IntToStr(RTPacks)+ '('+IntToStr(RPacks) + ')';;
  sbRecv.Panels[1].Text:='Скорость бод: --- интегр.: ---';
end;

procedure TfrmTraffic1.sbSendDblClick(Sender: TObject);
begin
  SPacks:=0;
  SBytes:=0;
  SSTime:=GetTickCount;
  sbSend.Panels[0].Text:='Передано байт: '+IntToStr(SBytes)+' пакетов: '+IntToStr(SPacks);
  sbSend.Panels[1].Text:='Скорость бод: --- интегр.: ---';
end;

end.
