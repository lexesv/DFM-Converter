program Project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { DFMConverter }

  DFMConverter = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    function Dfm2Txt(Src, Dest: string): boolean;
    function Txt2DFM(Src, Dest: string): boolean;
  end;


{ DFMConverter }

procedure DFMConverter.DoRun;
var
  From, Input, Output: String;
begin

  From := GetOptionValue('f', 'from');
  Input := GetOptionValue('i', 'input');

  // parse parameters
  if (HasOption('h', 'help')) or (From = '') or (Input = '') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  Output := GetOptionValue('o', 'output');
  if Output = '' then  begin
     Output := 'result.out';
  end;

  writeln('');
  writeln('From format: '+From);

  if From = 'bin' then begin
    if Dfm2Txt(Input, Output) then begin
       writeln('successfully converted');
    end else begin
       writeln('error');
    end;
  end;

  if From = 'text' then begin
    if Txt2DFM(Input, Output) then begin
       writeln('successfully converted');
    end else begin
       writeln('error');
    end;
  end;
  writeln('');

  { add your program here }

  // stop program loop
  Terminate;
end;

constructor DFMConverter.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor DFMConverter.Destroy;
begin
  inherited Destroy;
end;

procedure DFMConverter.WriteHelp;
begin
  { add your help code here }
  writeln('');
  writeln('Usage: ', ExtractFileName(ExeName), ' --from=bin|text -i <file1> -o <file2>');
  writeln('       -f --from= : from format bin or text');
  writeln('       -i --input= : input file name');
  writeln('       -o --output= : output file name');
  writeln('');
end;


// convert a binary dfm file to a text dfm file
function DFMConverter.Dfm2Txt(Src, Dest: string): boolean;
var
  SrcS, DestS: TFileStream;
begin
  if Src = Dest then
  begin
    writeln('Error converting dfm file to binary! The source file and destination file names are the same');
    result := False;
    exit;
  end;
  SrcS := TFileStream.Create(Src, fmOpenRead);
  DestS := TFileStream.Create(Dest, fmCreate);
  try
    ObjectResourceToText(SrcS, DestS);
    if FileExists(Src) and FileExists(Dest) then
      Result := True
    else
      Result := False;
  finally
    SrcS.Free;
    DestS.Free;
  end;
end;

// convert a text DFM file to a binary DFM file
function DFMConverter.Txt2DFM(Src, Dest: string): boolean;
var
  SrcS, DestS: TFileStream;
begin
  if Src = Dest then
  begin
    writeln('Error converting dfm file to binary!. '
      + 'The source file and destination file names are the same');
    Result := False;
    exit;
  end;
  SrcS := TFileStream.Create(Src, fmOpenRead);
  DestS := TFileStream.Create(Dest, fmCreate);
  try
    ObjectTextToResource(SrcS, DestS);
    if FileExists(Src) and FileExists(Dest) then
      Result := True
    else
      Result := False;
  finally
    SrcS.Free;
    DestS.Free;
  end;
end;

var
  Application: DFMConverter;
begin
  Application:=DFMConverter.Create(nil);
  Application.Title:='DFM Converter';
  Application.Run;
  Application.Free;
end.


