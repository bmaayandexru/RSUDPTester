unit bmaTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, CPort, Vcl.StdCtrls, Vcl.ExtCtrls,
  CPortCtl, IdGlobal, IdUDPServer;

const
  HexDigits: set of char = ['0'..'9','a'..'f','A'..'F'];
  LowHexDigits: set of char = ['a'..'f'];
  DecDigits: set of char = ['0'..'9'];

type
  // 32k
  TBA = TByteArray;
  // 1k
  TBAS = array[0..1023] of byte;
  TBA256 = array[0..255] of byte;
  TBA64 = array[0..63] of byte;

function ExPortParamsStr(const Port: TComPort):string;
function PortParamsStr(const Port: TComPort):string;

function BufferToIdBuf(const buf; size:integer; var idbuf: TIdBytes):boolean;
function IdBufToBuffer(const idbuf : TIdBytes; var buf; var size:integer):boolean;

//function BufferToStr(const Buffer; Count: integer):string;
function BufferToStr(const Buffer; Count: integer; Delim:string=' '):string;

function IdBufToStr(const Buf: TIdBytes):string;  overload;
function IdBufToStr(const Buf: TIdBytes; Ofs, Count: integer):string; overload;

function BufferToStrBE(const Buffer; Count: integer; bc, ec : integer):string;
//
function IdBufToStrBE(const Buf:TIdBytes; bc, ec : integer):string;

function BufferToCharStr(const Buffer; Count: integer):string;
//
function IdBufToCharStr(const Buf:TIdBytes):string;
procedure HexStrToBuffer(const sin:string; var Buffer;var Count:integer);
//
procedure HexStrToIdBuf(const sin:string; var Buf:TIdBytes);
procedure CharStrToBuffer(const sin:string; var Buffer;var Count:integer);
procedure CharStrToIdBuf(const sin:string; var IdBuf: TIdBytes);

function HexEditToInt(ed:TCustomEdit):integer;
function EditToInt(ed:TCustomEdit; DefVal:integer=0):integer;
function MakeCSb(const buf; count : integer):byte;
function MakeCSw(const buf; count : integer):word;

procedure ReCreateUDPServer(var serv:TIdUDPServer; AOwner:TComponent; DefPort: integer);

procedure SaveGridToFile(stg: TStringGrid);
procedure LoadGridFromFile(stg: TStringGrid; NoZero:boolean=false);
procedure DefaultDirs();

procedure FiltrHexDigits(var Key: Char);
procedure FiltrDigits(var Key: Char);

procedure ChangeEditLen(Sender: TLabeledEdit; Len: Integer);

procedure GenRandBuffer(var buf; count: Integer);
procedure GenCounterBuffer(var buf; count: Integer);

function GetBit(const b; shift:integer):boolean;
procedure SetBit(var buf; shift:integer);
procedure ClrBit(var buf; shift:integer);

implementation

var
  DefaultIniDir:string;
  iGenCounter: int64;

procedure SetBit(var buf; shift: integer);
var
  nbyte, nbit:integer;
begin
  try
    nbyte := shift div 8;
    nbit := shift mod 8;
    TBA(buf)[nbyte] := TBA(buf)[nbyte] or (1 shl nbit);
  except
  end;
end;

procedure ClrBit(var buf; shift:integer);
var
  nbyte, nbit:integer;
begin
  try
    nbyte := shift div 8;
    nbit := shift mod 8;
    TBA(buf)[nbyte] := TBA(buf)[nbyte] and (not (1 shl nbit));
  except
  end;
end;

function GetBit(const b; shift:integer):boolean;
var
  nbyte, nbit:integer;
begin
  try
    nbyte := shift div 8;
    nbit := shift mod 8;
    Result := ((TBA(b)[nbyte] and (1 shl nbit)) = (1 shl nbit))
  except
    Result := false;
  end;
end;

procedure GenCounterBuffer(var buf; count: Integer);
var
  val:int64;
begin
  inc(iGenCounter);
  val:=$00000007FFFFFFFF - iGenCounter;
  Move(val,buf,Count);
end;

procedure GenRandBuffer(var buf; count: Integer);
var
  i: Integer;
begin
  for i := 0 to count-1 do
    TBA(buf)[i] := Random(256);
end;


procedure ChangeEditLen(Sender: TLabeledEdit; Len: Integer);
var
  s : String;
  ss : integer;
begin
  with (Sender as TLabeledEdit) do begin
    if Length(Text) > Len then begin
      ss := SelStart;
      s := Text;
      if ss < Length(s)
        then Delete(s,ss+1,1)
        else Delete(s,1,1);
      Text := s;
      SelStart := ss;
    end;
  end;
end;

procedure FiltrHexDigits(var Key: Char);
begin
  if (Key in HexDigits) or (Key = #8)  then begin
    if (Key in LowHexDigits) then Key:=Upcase(Key);
  end
  else Key:=#0
end;

procedure FiltrDigits(var Key: Char);
begin
  if (Key in DecDigits) or (Key = #8) then Key:=Upcase(Key)
  else Key:=#0
end;

procedure SaveGridToFile(stg: TStringGrid);
var
  f  : Text;
  fn : String;
  i,j  : Integer;
  s,scell : String;
begin
  fn := DefaultIniDir+stg.Name+'.ini';
  AssignFile(f, fn);
  Rewrite(f);
  for i := 1 to stg.RowCount-1 do begin
    s:='';
    for j := 1 to stg.ColCount-1 do begin
      // набираем строку
      scell :=stg.Cells[j,i];
      if scell='' then scell:='0';
      if j < stg.ColCount-1
        then s:=s+scell+' '
        else s:=s+scell;
    end;
    // пишем строку
    WriteLn(f,s);
  end;
  CloseFile(f);
end;

function NextSubStr(var s : String; sep : string = ' '):string;
var
  resstr : String;
begin
  resstr:='';
  if Length(s) > 0 then begin
    while (Length(s) > 0) and (s[1] <> sep) do begin
      // добавляем в результат и удаляем
      resstr := resstr + s[1];
      Delete(s,1,1);
    end;
    if Length(s) > 0 then Delete(s,1,1);
  end;
  Result:=resstr;
end;

procedure LoadGridFromFile(stg: TStringGrid; NoZero : Boolean=false);
var
  f  : Text;
  fn : String;
  i,j  : Integer;
  s, scell : String;
begin
  fn := DefaultIniDir+stg.Name+'.ini';
  AssignFile(f, fn);
  try
    Reset(f);
  except
    exit;
  end;
  for i := 1 to stg.RowCount-1 do begin
    // прочитали строку
    try
      ReadLn(f,s);
    except
      break;
    end;
    // разбиваем на подстроки
    for j := 1 to stg.ColCount-1 do begin
      scell := NextSubStr(s,' ');
      if scell = '' then Break;
      if (scell = '0') and NoZero then scell:='';
      stg.Cells[j,i]:=scell;
    end;
  end;
  CloseFile(f);
end;

procedure DefaultDirs();
begin
  CreateDir('ini');
  DefaultIniDir:=ExtractFilePath(ParamStr(0))+'ini\';
end;


function BufferToIdBuf(const buf; size:integer; var idbuf: TIdBytes):boolean;
var
  i : integer;
begin
  Result := true;
  if (size <= 0) then begin Result:=false; exit; end;
  SetLength(idbuf, size);
  for i:=0 to size-1 do idbuf[i]:=TBA(buf)[i];
end;

function IdBufToBuffer(const idbuf : TIdBytes; var buf; var size:integer):boolean;
var
  i : integer;
begin
  Result := true;
  if SizeOf(buf) > Length(idbuf) then begin Result:=false; exit; end;
  if (idbuf = Nil) then begin Result:=false; exit; end;
  for i:=0 to size-1 do TBA(buf)[i]:=idbuf[i]
end;

function MakeCSw(const buf; count : integer):word;
var
  cs:word;
  i:integer;
begin
  cs := 0;
  for i:=0 to count-1 do cs := cs + TBA(buf)[i];
  Result := cs;
end;

function MakeCSb(const buf; count : integer):byte;
var
  cs:byte;
  i:integer;
begin
  cs := 0;
  for i := 0 to count-1 do cs:=cs + TBA(buf)[i];
  Result := cs;
end;

function HexEditToInt(ed : TCustomEdit):integer;
var
  tmpi: integer;
begin
  if not TryStrToInt('$'+ed.Text,tmpi) then begin
    tmpi := 0;
    ed.Text := '0';
  end;
  Result := tmpi;
end;

function EditToInt(ed:TCustomEdit; DefVal:integer=0):integer;
var
  tmpi: integer;
begin
  if not TryStrToInt(ed.Text,tmpi) then begin
    tmpi := DefVal;
    ed.Text := IntToStr(DefVal);
  end;
  Result := tmpi;
end;

function ExPortParamsStr(const Port: TComPort):string;
begin
  Result:='Com Port - '+PortParamsStr(Port);
end;

function PortParamsStr(const Port: TComPort):string;
begin
  if Port = nil then begin
    Result:='not defined';
  end else begin
    if Port.BaudRate = brCustom then begin
      Result:=Port.Port +', '+
              BaudRateToStr(Port.BaudRate)+' ('+
              IntToStr(Port.CustomBaudRate)+'), '+
              DataBitsToStr(Port.DataBits)+', '+
              StopBitsToStr(Port.StopBits)+', '+
              ParityToStr(Port.Parity.Bits)+', '+
              FlowControlToStr(Port.FlowControl.FlowControl);
    end else begin
      Result:=Port.Port +', '+
              BaudRateToStr(Port.BaudRate)+', '+
              DataBitsToStr(Port.DataBits)+', '+
              StopBitsToStr(Port.StopBits)+', '+
              ParityToStr(Port.Parity.Bits)+', '+
              FlowControlToStr(Port.FlowControl.FlowControl);
    end;
  end;
end;

function BufferToStr(const Buffer; Count: integer; Delim:string=' '):string;
var
  s:string;
  i:integer;
begin
  s:='';
  if Count > 0 then begin
    s:=IntToHex(TBA(Buffer)[0],2);
    for i := 1 to Count-1 do
      s := s + Delim + IntToHex(TBA(Buffer)[i],2);
  end;
  Result:=s;
end;

function IdBufToStr(const Buf: TIdBytes):string; overload;
var
  s:string;
  i:integer;
  Count: integer;
begin
  s:='';
  Count:=Length(Buf);
  if Count > 0 then begin
    s:=IntToHex(Buf[0],2);
    for i := 1 to Count-1 do
      s:=s+' '+IntToHex(Buf[i],2);
  end;
  Result:=s;
end;

function IdBufToStr(const Buf: TIdBytes; Ofs, Count: integer):string; overload;
var
  s:string;
  i:integer;
  len:integer;
begin
  s:='';
  len:= Length(Buf);
  if (Ofs+Count <= len) and (Count > 0) and (Ofs >= 0) and (Ofs < len) then begin
    s:=IntToHex(Buf[Ofs],2);
    for i := 1 to Count-1 do
      s:=s+' '+IntToHex(Buf[Ofs+i],2);
  end;
  Result:=s;
end;

function BufferToStrBE(const Buffer; Count: integer; bc,ec:integer):string;
begin
  if (bc+ec) >= Count then Result:=BufferToStr(Buffer,Count)
  else begin
    Result:=BufferToStr(Buffer,bc)+' ... '+BufferToStr(TBA(Buffer)[Count-ec],ec);
  end;
end;

function IdBufToStrBE(const Buf:TIdBytes; bc, ec : integer):string;
var
  Count: integer;
begin
  Count:=Length(Buf);
  if (bc+ec) >= Count then Result:=IdBufToStr(Buf)
  else begin
    Result := IdBufToStr(Buf,0,bc) + ' ... ' + IdBufToStr(Buf,Count-ec,ec);
  end;
end;

function BufferToCharStr(const Buffer; Count: integer):string;
var
  s:string;
  i:integer;
begin
  s:='';
  s:=chr(TBA(Buffer)[0]);
  for i := 1 to Count-1 do
    s:=s+chr(TBA(Buffer)[i]);
  Result:=s;
end;

function IdBufToCharStr(const Buf:TIdBytes):string;
var
  s:string;
  Count, i:integer;

begin
  s:='';
  Count:= Length(Buf);
  if Count > 0 then begin
    s:=chr(Buf[0]);
    for i := 1 to Count-1 do
      s:=s+chr(Buf[i]);
  end;
  Result:=s;
end;


procedure HexStrToBuffer(const sin:string;var Buffer;var Count:integer);
var
  s,sval : string;
  i,ival : integer;
  buf : TBA;
begin
  s:=sin;
  // alltrim
  s:=Trim(s);
  i:=0;
  while Length(s)>0 do begin
    // get 2 chars
    sval:=Copy(s,1,2);
    // del 2 chars
    Delete(s,1,2);
    // alltrim
    sval:=Trim(sval);
    // 0xSS to int
    // buf[i]:=StrToInt('$'+sval);
    if not TryStrToInt('$'+sval,ival) then ival:=0;
    buf[i]:=ival;
    inc(i);
    // alltrim
    s:=Trim(s);
  end;
  if i > 0 then begin
    Move(buf,Buffer,i);
  end;
  Count:=i;
end;

procedure HexStrToIdBuf(const sin:string; var Buf:TIdBytes);
var
  s,sval : string;
  ii,i,ival : integer;
  buffer : TBA;
begin
  s:=sin;
  // alltrim
  s:=Trim(s);
  i:=0;
  while Length(s)>0 do begin
    // get 2 chars
    sval:=Copy(s,1,2);
    // del 2 chars
    Delete(s,1,2);
    // alltrim
    sval:=Trim(sval);
    // 0xSS to int
    // buf[i]:=StrToInt('$'+sval);
    if not TryStrToInt('$'+sval,ival) then ival:=0;
    buffer[i]:=ival;
    inc(i);
    // alltrim
    s:=Trim(s);
  end;
  if i > 0 then begin
    SetLength(Buf, i);
    for ii:=0 to i-1  do Buf[ii]:=buffer[ii];
//    Move(buffer,buf,i);
  end;
end;

procedure CharStrToBuffer(const sin:string; var Buffer;var Count:integer);
var
  i:integer;
begin
  Count:=Length(sin);
  if Count > 0 then begin
    for i := 1 to Length(sin) do
      TBA(Buffer)[i-1]:=Ord(sin[i]);
  end;
end;

procedure CharStrToIdBuf(const sin:string; var IdBuf: TIdBytes);
var
  len, i:integer;
begin
  len:=Length(sin);
  if len > 0 then begin
    SetLength(IdBuf, len);
    for i := 1 to len do
      IdBuf[i-1]:=Ord(sin[i]);
  end;
end;

procedure ReCreateUDPServer(var serv:TIdUDPServer; AOwner:TComponent; DefPort: integer);
var
  sre:TUDPReadEvent;
begin
  sre:=serv.OnUDPRead;
  FreeAndNil(serv);
  serv:=TIdUDPServer.Create(AOwner);
  serv.DefaultPort:=DefPort;
  serv.OnUDPRead:=sre;
  serv.Active:=true;
end;

end.
