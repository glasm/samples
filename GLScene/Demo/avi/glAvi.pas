unit glAvi;

interface

uses

  Windows, Classes, Graphics, Dialogs,

  GLScene, VectorGeometry, XOpenGL, OpenGLTokens, OpenGLAdapter, GLContext,
  GLTexture, GLSVFW, GLGraphics, GLRenderContextInfo, GLCrossPlatform,
  GLHUDObjects, GLCoordinates, BaseClasses;


type

  TAVIUpdateEvent = procedure (sender:TObject;FrameIndex:integer) of object;

  TGLAvi = class
  private
    fFilename: string;
    currdelta: single;
    fFrameindex, fFirstFrame, fLastFrame: integer;
    fUpdateRate: integer;
    PAvi: IAVIFile;
    PAvis: IAVIStream;
    AviInfo: TAVISTREAMINFOA;
    pFrame: IGetFrame;
    pBmi: PBitmapInfoHeader;
    pColors: pRGBTriple;
    fAviOpened: boolean;
    CurrTime: Double;
    CurrFrameCount: integer;
    FileOrPosChanged:boolean;

    fwidth, fheight: single;

    fCurrentFrameRate, FUserFrameRate: integer;
    fTargetFrameRate: single;
    fAutoFrameRate: boolean;
    fOnUpdate: TAVIUpdateEvent;

    fTexture: TGLTexture;
    fBmp: TBitmap;
    fDx,fDy: Word;

    function OpenAvi: boolean;
    procedure ReadToTexture;

  protected
    procedure SetFilename(val: string);
    procedure SetTexture(tex: TGLTexture);
    procedure SetFrameIndex(val:integer);
    procedure SetAutoFrameRate(val:boolean);

  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure update( ct,dt: single );

    procedure CloseAvi;

    function GetFrame( f: integer): boolean;

    property UserFrameRate: integer read fUserFrameRate write fUserFrameRate;
    property FrameIndex: longint read fFrameindex write SetFrameIndex;
    property FirstFrame: longint read fFirstFrame write fFirstFrame;
    property LastFrame: longint read fLastFrame write fLastFrame;

    property Filename: string read fFilename write SetFilename;
    property Texture: TGLTexture read fTexture write SetTexture;

    property AviOpened: boolean read fAviOpened;

    property width: single read fWidth;
    property height: single read fHeight;
    property CurrentFrameRate: integer read fCurrentFrameRate; //current number of frames shown per second
    property TargetFrameRate: single read fTargetFrameRate; //Actual avi file frame rate
    property AutoFrameRate: boolean read fAutoFrameRate write SetAutoFrameRate; //Ignores UserFrameRate and uses TargetFrameRate instead

    property OnUpdate:TAVIUpdateEvent read fOnUpdate write fOnUpdate;

  end;

implementation


procedure TGLAvi.SetAutoFrameRate( val: boolean );
begin

  fAutoFrameRate := val;
  FileOrPosChanged := true;

end;

procedure TGLAvi.SetFrameIndex( val: integer );
begin

  fFrameIndex := val;
  FileOrPosChanged := true;

end;

procedure TGLAvi.SetFilename( val: string );
begin

  fFilename := val;
  openavi;

end;


procedure TGLAvi.SetTexture( tex: TGLTexture );
begin

  fTexture := tex;

end;


constructor TGLAvi.Create;
begin

  inherited;

  fFrameIndex := 0;
  fFirstFrame := 0;
  fLastFrame := 0;
  fUpdateRate := 10;
  pBmi := nil;
  pColors := nil;
  fCurrentFrameRate := 0;
  CurrTime := 0;
  CurrFrameCount := 0;
  fTargetFrameRate := 0;
  fAutoFrameRate := true;

end;

destructor TGLAvi.Destroy;
begin

  fBmp.Free;

  inherited;

end;


procedure TGLAvi.update( ct,dt: single );
var t:single;
begin

  inherited;

  if fAutoFrameRate then t:=fTargetFrameRate
    else t:=fUserFrameRate;

  if(t=0)or(not fAviOpened)then exit;

  CurrDelta := CurrDelta + dt;

  if ( CurrDelta >= 1/t ) or FileOrPosChanged then begin

    CurrDelta := CurrDelta - 1/t;
    getframe( fFrameIndex );

    ReadToTexture;

    inc(fFrameIndex);

    if fFrameIndex > fLastFrame then
      fFrameIndex := fFirstFrame;

    CurrFrameCount := CurrFrameCount + 1;
    if ( ct >= CurrTime + 1 ) or FileOrPosChanged then begin
      if FileOrPosChanged then begin
        CurrTime := ct;
        CurrDelta := 0;
        FileOrPosChanged := false;
      end else CurrTime := CurrTime + 1;

      fCurrentFrameRate := CurrFrameCount;
      CurrFrameCount := 0;
      if assigned(fOnUpdate) then
        fOnUpdate( self, fFrameIndex );

    end;

  end;

end;

function TGLAvi.GetFrame( f: integer): boolean;
var
    tbmi: PBitmapInfoHeader;
begin

  if not fAviOpened then begin
    result := false;
    exit;
  end;

  try
    tbmi := AVIStreamGetFrame( pFrame, f );
    result := assigned( tbmi );
    if result then begin
      pbmi := tbmi;
      pcolors := PRGBtriple( DWORD(pbmi) + pbmi^.bisize );
    end;
  except
    result := false;
  end;

end;


// openAvi
//
function TGLAvi.OpenAvi: boolean;
var
    m: integer;
begin

  fFirstFrame := 0;
  fFrameIndex := 0;
  flastFrame := 0;

  result := AVIFileOpen( pavi, PChar(fFilename), OF_READ, nil) = AVIERR_OK;
  if not result then exit;

  result := AVIFILEGetStream( pavi, pavis, streamtypeVIDEO, 0) = AVIERR_OK;
  if not result then exit;

  result := AVIStreamInfo( pavis, AviInfo, sizeof(TAVISTREAMINFOA)) = AVIERR_OK;
  if not result then exit;

  if AviInfo.dwRate > 1000 then begin
    if AviInfo.dwRate > 100000 then m := 10000
      else if AviInfo.dwRate > 10000 then m := 1000
        else m := 100;
  end else m := 1;

  fTargetFrameRate := AviInfo.dwRate / m;

  fFirstFrame := AVIStreamStart(pavis);
  fLastFrame := AVIStreamENd(pavis);

  pFrame := AVIStreamGetFrameOpen(pavis, nil);
  result := assigned(pFrame);

  AVIStreamBeginStreaming(pavis, fFirstFrame, fLastFrame, 1000);

  if not result then begin
    closeAvi;
    showMessage('Codec not found.');
  end else begin
    fAviOpened := true;
    GetFrame(fFirstFrame);
    currdelta := 0;
    CurrFrameCount := 0;
    FileOrPosChanged := true;
  end;

end;


// closeAvi
//
procedure TGLAvi.CloseAvi;
begin

  AVIStreamEndStreaming(pavis);
  AVIStreamGetFrameClose(pFrame);

  AVIStreamrelease(pavis);

  if assigned(pbmi) then begin
    pbmi := nil;
    pcolors := nil;
  end;

  fFirstFrame := 0;
  fFrameIndex := 0;
  flastFrame := 0;
  fAviOpened := false;

end;


// ReadToTexture
//
procedure TGLAvi.ReadToTexture;
var
    a1,a2,wi,hi: integer;
    p: PByteArray;
    rgb: PRGBTriple;
begin

  if fFilename='' then exit;

  if fBmp = nil then begin
    fBmp := TBitmap.Create;
    fBmp.PixelFormat := pf24bit;
  end;
  
  wi := ceil( log2( pbmi^.biWidth ));
  hi := ceil( log2( pbmi^.biHeight ));
  with fBmp do
    if ( Width * Height = 0 ) or ( Width <> 1 shl wi ) or ( Height <> 1 shl hi )then begin
      Width := 1 shl wi;
      Height := 1 shl hi;
      for a2 := Height-1 downto 0 do begin
        p := fBmp.ScanLine[a2];
        for a1 := 0 to Width*3-1 do
          p[a1] := 0;
      end;
      fDx := ( Width - pbmi^.biWidth ) div 2;
      fDy := ( Height - pbmi^.biHeight ) div 2;
    end;

  rgb := pcolors;
  for a2 := pbmi^.biHeight-1 downto 0 do begin
    p := fBmp.ScanLine[fDy+a2];
    system.move( rgb^, p^[fDx*3], pbmi^.biWidth * 3 );
    inc( rgb, pbmi^.biWidth );
  end;

  fTexture.Image.Assign(fBmp);

end;

initialization
    avifileinit;
finalization
    avifileExit;

end.

