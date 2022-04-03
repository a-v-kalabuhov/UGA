unit EzZLibUtil;

interface

uses classes;

procedure CompressMemStream(s: TMemoryStream; compressionLevel: integer);
procedure DecompressMemStream(s: TMemoryStream);

implementation

uses Windows, SysUtils, EzZLib;

procedure CompressBuf(
  const inBuf: Pointer;     { input: pointer to source data }
        inBytes: Integer;   { input: # of bytes in inBuf }
        level: Integer;     { input: compression level }
    var outBuf: Pointer;    { output: pointer to newly allocated buffer with compressed data }
    var outBytes: Integer); { output: # of bytes in outBuf }
{ This routine compresses data. Level may vary from 0 to 9 (3 to 6 may
  be a reasonable trade-off between speed and compression).

  Compression levels:
    0 = no compression                 (Z_NO_COMPRESSION constant)
    1 = best speed                     (Z_BEST_SPEED constant)
    9 = best compression, but slowest  (Z_BEST_COMPRESSION constant) }

  function Check(code: Integer): Integer;
  begin
    Result := code;
    if (code < 0) then
      raise Exception.Create('Compression error: '+z_errmsg[2-code]);
  end;

var
  strm: z_stream;
begin
  FillChar(strm, sizeof(strm), 0);
  outBytes := ((inBytes + (inBytes div 10) + 12) + 255) and not 255;
  GetMem(outBuf, outBytes);
  try
    strm.next_in := inBuf;
    strm.avail_in := inBytes;
    strm.next_out := outBuf;
    strm.avail_out := outBytes;
    Check(deflateInit(strm, level));
    try
      while Check(deflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        Inc(outBytes, 256);
        ReallocMem(outBuf, outBytes);
        strm.next_out := pBytef(Integer(outBuf) + strm.total_out);
        strm.avail_out := 256;
      end;
    finally
      Check(deflateEnd(strm));
    end;
    ReallocMem(outBuf, strm.total_out);
    outBytes := strm.total_out;
  except
    FreeMem(outBuf);
    raise;
  end;
end;

procedure DecompressBuf(
  const inBuf: Pointer;     { input: pointer to compressed data }
        inBytes: Integer;   { input: # of bytes in inBuf }
    var outBuf: Pointer;    { output: pointer to newly allocated buffer with decompressed data }
    var outBytes: Integer); { output: # of bytes in outBuf }
{ This routine decompresses data that was compressed with CompressBuf. }

  function Check(code: Integer): Integer;
  begin
    Result := code;
    if (code < 0) then
      raise Exception.Create('Decompression error: '+z_errmsg[2-code]);
  end;

var
  strm: z_stream;
  bufInc: Integer;
begin
  FillChar(strm, sizeof(strm), 0);
  bufInc := (inBytes + 255) and not 255;
  outBytes := bufInc;
  GetMem(outBuf, outBytes);
  try
    strm.next_in := inBuf;
    strm.avail_in := inBytes;
    strm.next_out := outBuf;
    strm.avail_out := outBytes;
    Check(inflateInit(strm));
    try
      while Check(inflate(strm, Z_NO_FLUSH)) <> Z_STREAM_END do
      begin
        Inc(outBytes, bufInc);
        ReallocMem(outBuf, outBytes);
        strm.next_out := pBytef(Integer(outBuf) + strm.total_out);
        strm.avail_out := bufInc;
      end;
    finally
      Check(inflateEnd(strm));
    end;
    ReallocMem(outBuf, strm.total_out);
    outBytes := strm.total_out;
  except
    FreeMem(outBuf);
    raise;
  end;
end;

procedure CompressMemStream(s: TMemoryStream; compressionLevel: integer);
var
  inBuf, outBuf: Pointer;
  inBytes,outBytes: Integer;
begin
  inBuf := nil;
  outBuf := nil;
  try
    inBytes := s.Size;
    GetMem(inBuf, inBytes);
    s.Position:=0;
    s.ReadBuffer(inBuf^, inBytes);
    s.Clear;
    CompressBuf(inBuf, inBytes, compressionLevel, outBuf, outBytes);
    s.WriteBuffer(outBuf^, outBytes);
  finally
    FreeMem(inBuf);
    FreeMem(outBuf);
  end;
end;

procedure DecompressMemStream(s: TMemoryStream);
var
  inBuf, outBuf: Pointer;
  inBytes, outBytes: Integer;
begin
  inBuf:=nil;
  outBuf:=nil;
  try
    inBytes:=s.Size;
    GetMem(inBuf, inBytes);
    s.Position:=0;
    s.ReadBuffer(inBuf^, inBytes);
    s.Clear;
    DecompressBuf(inBuf, inBytes, outBuf, outBytes);
    s.WriteBuffer(outBuf^, outBytes);
  finally
    FreeMem(inBuf);
    FreeMem(outBuf);
  end;
end;

end.
