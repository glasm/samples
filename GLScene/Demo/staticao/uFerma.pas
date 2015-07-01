unit uFerma;

interface

uses
  Windows, Classes, Forms, SysUtils,

  GLScene, GLFile3DS, GLVectorFileObjects, VectorGeometry, VectorTypes,
  VectorLists;


type

  //
  // task
  //
  TTaskClass = class of TTask;
  TTask = class end;

  TTaskA = class(TTask)
  public

    FObj,FInd: integer;
    FNorm: TVector3f;
    FVert: TVector;
    FCol: single;

    constructor Create( AObj,AInd:integer; ANorm:TVector3f; AVert:TVector );

  end;


  //
  // pack
  //
  TPackA = record

    useOctree: boolean;
    LnFilter: boolean;
    modelName: string;
    modelSize: single;
    rays: array of TVector;

  end;

  TOnJobComplete = procedure ( ATaskClass:TTaskClass ) of object;


  //
  // worker
  //
  TWorkerThreadClass = class of TWorkerThread;
  TWorkerThread = class(TThread)
  protected

    FActive: boolean;
    FTaskClass: TTaskClass;
    FTaskList: TList;
    FResList: TList;
    FOnComplete: TNotifyEvent;

    function getTaskCount: integer;
    procedure complete;

  public

    constructor Create( AOwner:TComponent );
    destructor Destroy; override;

    procedure pushTask( ATask:TTask );
    function popResult: TTask;

    property taskClass: TTaskClass read FTaskClass;
    property taskCount: integer read getTaskCount;
    property active: boolean read FActive write FActive;

  end;

  // worker A
  //
  TWorkerA = class(TWorkerThread)
  protected

    FUseOctree: boolean;
    FLnFilter: boolean;
    FF: TGLFreeForm;
    FTris: TAffineVectorList;
    FRays: array of TVector;
    FD: single;

    procedure Execute; override;
    procedure progress;    

  public

    constructor Create( AOwner:TComponent );
    destructor Destroy;

    procedure load( APack:TPackA );

  end;


  //
  // ferma
  //
  TFerma = class(TComponent)
  protected

    FPackA: TPackA;
    FCPUs: integer;
    FWorkerList: TList;
    FWorkerTask: integer;
    FOnJobComplete: TOnJobComplete;

    function getAllTaskCount: integer;
    function getAllWorkerCount: integer;
    procedure WorkerComplete( ASender:TObject );

  public

    constructor Create( AOwner:TComponent );
    destructor Destroy; override;

    procedure clear;
    procedure start;
    procedure stop;
    procedure addWorker( AWorker:TWorkerThreadClass; ACount:integer = 1 );
    procedure pushTask( ATask:TTask );
    function popResult( ATaskClass:TTaskClass ): TTask;
    function getTaskCount( ATaskClass:TTaskClass ): integer;
    function getWorkerCount( AWorkerClass:TWorkerThreadClass ): integer;

    property packA: TPackA read FPackA write FPackA;
    property CPUs: integer read FCPUs;
    property taskCount: integer read getAllTaskCount;
    property workerCount: integer read getAllWorkerCount;
    property onJobComplete: TOnJobComplete read FOnJobComplete
      write FOnJobComplete;

  end;


implementation


//
// TTaskA
// constructor
//
constructor TTaskA.Create( AObj,AInd:integer; ANorm:TVector3f; AVert:TVector );
begin

  inherited Create;

  FObj := AObj;
  FInd := AInd;
  FNorm := ANorm;
  FVert := AVert;

end;




//
// TWorkerThread
// constructor
//
constructor TWorkerThread.Create( AOwner:TComponent );
begin

  inherited Create( false );

  FActive := false;
  FTaskClass := TTask;
  FTaskList := TList.Create;
  FResList := TList.Create;

end;


//
// TWorkerThread
// destructor
//
destructor TWorkerThread.Destroy;
begin

  FTaskList.Free;
  FResList.Free;

  inherited;

end;


//
// TWorkerThread
// getTaskCount
//
function TWorkerThread.getTaskCount: integer;
begin

  result := FTaskList.Count;

end;


//
// TWorkerThread
// complete
//
procedure TWorkerThread.complete;
begin

  FOnComplete( self );

end;


//
// TWorkerThread
// pushTask
//
procedure TWorkerThread.pushTask( ATask:TTask );
begin

  if ATask <> nil then
    FTaskList.Add( ATask );

end;


//
// TWorkerThread
// popResult
//
function TWorkerThread.popResult: TTask;
begin

  if FResList.Count = 0 then
    result := nil
  else begin
    result := TTask( FResList[0] );
    FResList.Delete(0);
  end;

end;




//
// TWorkerA
// constructor
//
constructor TWorkerA.Create( AOwner:TComponent );
begin

  inherited Create( AOwner );

  FTaskClass := TTaskA;
  FF := TGLFreeForm.Create( AOwner );

end;


//
// TWorkerA
// destructor
//
destructor TWorkerA.Destroy;
begin

  if FF <> nil then begin
    FF.Free;
    FF := nil;
  end;
  FTris.Clear;
  finalize( FRays );

  inherited;

end;


//
// TWorkerA
// execute
//
procedure TWorkerA.Execute;
begin

  while not Terminated do begin

    sleep(1);

    if FActive then begin
      while (FTaskList.Count > 0) and FActive do begin
        progress;
        FResList.Add(FTaskList[0]);
        FTaskList.Delete(0);
      end;
      FActive := false;
      Synchronize( complete );
    end;

  end;

end;


//
// TWorkerA
// progress
//
procedure TWorkerA.progress;
var
    i,j,k,t0: integer;
    d, minD: Single;
    p: TVector;
    raycast: boolean;
begin
        
  with TTaskA(FTaskList[0]) do begin

    FCol := 1;

    for i := 0 to high(FRays) do begin

      if FUseOctree then
        raycast := not FF.Octree.RayCastIntersect( FVert, FRays[i])
      else begin
        minD := -1;
        j := 0;
        while j < FTris.Count do begin
          if RayCastTriangleIntersect( FVert, FRays[i], FTris.List^[j],
            FTris.List^[j + 1], FTris.List^[j + 2], @p ) then begin
            d := VectorDistance2( FVert, p );
            if (d < minD) or (minD < 0) then
              minD := d;
          end;
          inc(j, 3);
        end;
        raycast := minD < 0;
      end;

      if (vectordotproduct( FRays[i], FNorm ) > 0.01) and raycast then
        continue;
      FCol := FCol - FD;

    end;

    if FLnFilter then
      FCol := ln( FCol * 2.7183 + 1 )
    else
      FCol := sqrt( 1 - ( 1 - FCol ) * ( 1 - FCol ));

  end;

end;


//
// TWorkerA
// load pack
//
procedure TWorkerA.load( APack:TPackA );
begin

  FUseOctree := APack.useOctree;
  FLnFilter := APack.lnFilter;

  FF.LoadFromFile( APack.modelName );
  FF.Scale.Scale( APack.modelSize / FF.BoundingSphereRadius );
  FF.BuildOctree( 1 );
  FTris := FF.MeshObjects.ExtractTriangles;

  setLength( FRays, length( APack.rays ));
  move( APack.rays[0], FRays[0], length( APack.rays ) * 16);
  FD := 1 / length( FRays );

end;




//
// TFerma
// constructor
//
constructor TFerma.Create( AOwner:TComponent );
var
    si: TSystemInfo;
begin

  inherited Create( AOwner );

  FWorkerList := TList.Create;

  getSystemInfo( si );
  FCPUs := si.dwNumberOfProcessors;

end;


//
// TFerma
// destructor
//
destructor TFerma.Destroy;
begin

  FWorkerList.free;

  inherited;

end;


//
// TFerma
// get current task count
//
function TFerma.getAllTaskCount: integer;
var
    i: integer;
begin

  result := 0;
  for i := 0 to FWorkerList.Count - 1 do
    inc( result, TWorkerThread(FWorkerList[i]).taskCount );

end;


//
// TFerma
// get task count by class
//
function TFerma.getTaskCount( ATaskClass:TTaskClass ): integer;
var
    i: integer;
begin

  result := 0;
  for i := 0 to FWorkerList.Count - 1 do
    with TWorkerThread(FWorkerList[i]) do
      if taskClass = ATaskClass then
        inc( result, taskCount );

end;


//
// TFerma
// get current worker count
//
function TFerma.getAllWorkerCount: integer;
begin

  result := FWorkerList.Count;

end;


//
// TFerma
// get worker count by class
//
function TFerma.getWorkerCount( AWorkerClass:TWorkerThreadClass ): integer;
var
    i: integer;
begin

  result := 0;
  for i := 0 to FWorkerList.Count - 1 do
    if TWorkerThread(FWorkerList[i]) is AWorkerClass then
      inc( result );
      
end;


//
// TFerma
// on worker complete
//
procedure TFerma.WorkerComplete( ASender:TObject );
var
    tc: TTaskClass;
begin

  if not assigned(FOnJobComplete) then
    exit;

  tc := TWorkerThread(ASender).taskClass;
  if getTaskCount( tc ) = 0 then
    FOnJobComplete( tc );

end;


//
// TFerma
// remove workers
//
procedure TFerma.clear;
var
    i: integer;
begin

  for i := 0 to FWorkerList.Count - 1 do begin
    TWorkerThread(FWorkerList[0]).Free;
    FWorkerList.Delete(0);
    end;

  FWorkerTask := 0;

end;


//
// TFerma
// start
//
procedure TFerma.start;
var
    i: integer;
begin

  for i := 0 to FWorkerList.Count - 1 do
    TWorkerThread(FWorkerList[i]).active := true;

end;


//
// TFerma
// stop
//
procedure TFerma.stop;
var
    i: integer;
begin

  for i := 0 to FWorkerList.Count - 1 do
    TWorkerThread(FWorkerList[i]).active := false;

end;


//
// TFerma
// add worker(s)
//
procedure TFerma.addWorker( AWorker:TWorkerThreadClass; ACount:integer = 1 );
var
    i: integer;
    w: TWorkerThread;
begin

  if (ACount < 1) or (ACount > 500) then exit;
  for i := 0 to ACount - 1 do
    if AWorker = TWorkerA then begin
      w := TWorkerA.Create( self );
      w.FOnComplete := WorkerComplete;
      TWorkerA(w).load( FPackA );
      FWorkerList.Add( w );
    end;

end;


//
// TFerma
// push new task to next worker
//
procedure TFerma.pushTask( ATask:TTask );
var
    i: integer;
begin

  for i := 0 to FWorkerList.Count - 1 do
    with TWorkerThread(FWorkerList[FWorkerTask]) do begin
      FWorkerTask := (FWorkerTask + 1) mod FWorkerList.Count;
      if ATask is taskClass then begin
        pushTask( ATask );
        exit;
      end;
    end;

end;


//
// TFerma
// get result
//
function TFerma.popResult( ATaskClass:TTaskClass ): TTask;
var
    i: integer;
begin

  result := nil;
  for i := 0 to FWorkerList.Count - 1 do
    with TWorkerThread(FWorkerList[i]) do
      if ATaskClass = taskClass then begin
        result := popResult;
        if result <> nil then
          exit;
      end;

end;

end.

