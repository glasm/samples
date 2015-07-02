unit u_MainMathTest;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls,

  GLCrossPlatform, BaseClasses, GLScene, GLObjects, GLGeomObjects,
  GLCoordinates, GLWin32Viewer, GLCadencer, VectorGeometry, VectorTypes, //Math,

  uVMath, uMath, uATimer;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    cam: TGLCamera;
    dc: TGLDummyCube;
    light: TGLLightSource;
    GLCylinder1: TGLCylinder;
    cad: TGLCadencer;
    GLPoints1: TGLPoints;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    tb1: TTrackBar;
    GroupBox1: TGroupBox;
    Button3: TButton;
    cb1: TComboBox;
    ch1: TCheckBox;
    tb2: TTrackBar;
    GroupBox2: TGroupBox;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    procedure cadProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure tb1Change(Sender: TObject);
    procedure tb2Change(Sender: TObject);
  end;

var
  Form1: TForm1;

  gCol: array[0..500000] of Vec3;


implementation

{$R *.dfm}

procedure TForm1.Button3Click(Sender: TObject);
var
    i,c: integer;
    v1,v2: TVector;
    cv2: Vec2;
    cv3: Vec3;
    cv4: Vec4;
    m: TMatrix;
begin

  c := tb1.Position * 50000;

  glpoints1.Positions.Clear;
  glpoints1.Positions.Capacity := c + 1;

  TATimer.Tick;

  if sender = button1 then begin

    for i := 0 to c do
      glpoints1.Positions.Add( TVector4f( TVector( vtRndBox ).F ));

    end
  else if sender = button2 then begin

    for i := 0 to c do
      glpoints1.Positions.Add( TVector4f( TVector( vtRndSph ).F ));

    end
  else if sender = button3 then begin

    case cb1.ItemIndex of

      0:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.Lerp( -1, 1, (F[0]+1) / 2 ),
            F[2] * TMath.abs(1 - F[0]) / 2 );

      1:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpSmooth( -1, 1, (F[0]+1) / 2 ),
            F[2] * TMath.abs(1 - F[0]) / 2 );

      2:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpSin( -1, 1, (F[0]+1) / 2 ),
            F[2] * TMath.abs(1 - F[0]) / 2 );

      3:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpSinAlt( -1, 1, (F[0]+1) / 2 ),
            F[2] * TMath.abs(1 - F[0]) / 2 );

      4:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpTan( -1, 1, (F[0]+1) / 2 ),
            F[2] * TMath.abs(1 - F[0]) / 2 );

      5:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpPower( -1, 1, (F[0]+1) / 2,
            tb2.Position * 0.1 ), F[2] * TMath.abs(1 - F[0]) / 2 );

      6:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpLn( -1, 1, (F[0]+1) / 2,
            tb2.Position * 0.1 ), F[2] * TMath.abs(1 - F[0]) / 2 );

      7:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpExp( -1, 1, (F[0]+1) / 2,
            tb2.Position * 0.1 ), F[2] * TMath.abs(1 - F[0]) / 2 );

      8:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpF1( -1, 1, (F[0]+1) / 2,
            ch1.Checked ), F[2] * TMath.abs(1 - F[0]) / 2 );

      9:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpF2( -1, 1, (F[0]+1) / 2,
            ch1.Checked ), F[2] * TMath.abs(1 - F[0]) / 2 );

      10:for i := 0 to c do
        with TVector( vtRndBox ) do
          glpoints1.Positions.Add( F[0], TMath.LerpF3( -1, 1, (F[0]+1) / 2,
            ch1.Checked ), F[2] * TMath.abs(1 - F[0]) / 2 );

      end
    end
  else if sender = button4 then begin

    for i := 0 to c do begin
      //m.SetIdentity;
      //m := Matrix( [25,31,17,43, 75,94,53,132, 75,94,54,134, 25,32,20,48] );
      m.V[0].VectorSet( 25, 31, 17, 43 );
      m.V[1].VectorSet( 75, 94, 53, 132 );
      m.V[2].VectorSet( 75, 94, 54, 134 );
      m.V[3].VectorSet( 25, 32, 20, 48 );
      m.Determinant;
      end;

    end
  else if sender = button5 then begin

    for i := 0 to c do begin
      v1 := Vector( 25, 31, 17, 43 );
      v2 := Vector( 75, 94, 53, 132 );
      v1.CrossSet( v2 );
      end;

    end
  else if sender = button14 then begin

    for i := 0 to c do begin
      v1 := Vector( 25, 31, 17, 43 );
      v2 := Vector( 75, 94, 53, 132 );
      v1.Cross( v2 ).Norm;
      end;

    end
  else if sender = button6 then begin

    for i := 0 to c do begin
      v1 := Vector( 25, 31, 17, 43 );
      v2 := Vector( 75, 94, 53, 132 );
      v1.Dot( v2 );
      end;

    end
  else if sender = button7 then begin

    for i := 0 to c do begin
      v1 := vtRndBox;
      v2 := vtRndBox;
      glpoints1.Positions.Add( TVector4f( v1.Lerp( v2, Random ).F ));
      end;

    end
  else if sender = button8 then begin

    for i := 0 to c do begin
      v1 := vtRndBox;
      v2 := vtRndBox;
      glpoints1.Positions.Add( TVector4f( v1.LerpSmooth( v2, Random ).F ));
      end;

    end
  else if sender = button9 then begin

    for i := 0 to c do begin
      cv2[0] := random - 0.5;
      cv2[1] := random - 0.5;
      with TVector( cv2 ) do
        glpoints1.Positions.Add( F[0], Random - 0.5, F[1] );
      end;

    end
  else if sender = button10 then begin

    for i := 0 to c do begin
      cv3[0] := random - 0.5;
      cv3[1] := random - 0.5;
      cv3[2] := random - 0.5;
      with TVector( cv3 ) do
        glpoints1.Positions.Add( F[0], F[1], F[2] );
      end;

    end
  else if sender = button11 then begin

    for i := 0 to c do begin
      cv4[0] := random - 0.5;
      cv4[1] := random - 0.5;
      cv4[2] := random - 0.5;
      cv4[3] := random - 0.5;
      with TVector( cv4 ) do
        glpoints1.Positions.Add( F[0], F[1], F[2] );
      end;

    end
  else if sender = button12 then begin

    for i := 0 to c do begin
      with TVector( random - 0.5 ) do
        glpoints1.Positions.Add( F[0], F[1], F[2] );
      end;

    end
  else if sender = button13 then begin

    for i := 0 to c do begin
      cv4[0] := random - 0.5;
      cv4[1] := random - 0.5;
      cv4[2] := random - 0.5;
      cv4[3] := random - 0.5;
      with TVector( @cv4[0] ) do
        glpoints1.Positions.Add( F[0], F[1], F[2] );
      end;

    end;

  caption := floattostr( TATimer.DeltaTime );

end;

procedure TForm1.cadProgress;
begin

  dc.Turn(deltatime * 30);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
    i: integer;
    m: TMatrix;
    v: TVector;
begin

  randomize;
  glpoints1.Colors.Capacity := 500001;
  for i := 0 to high( gCol ) do
    glpoints1.Colors.Add( vectormake( random, random, random, 1 ));

  m.IdentitySet;
  m.V[0] := Vector( 25, 31, 17, 43 );
  m.V[1] := Vector( 75, 94, 53, 132 );
  m.V[2] := Vector( 75, 94, 54, 134 );
  m.V[3] := Vector( 25, 32, 20, 48 );

  v := Vector( 25, 31, 17, 43 ); //m.V[0].Cross( m.V[1] ).Norm;

  caption := floattostr( m.Determinant );
//  caption := format( '%.3f %.3f %.3f', [m.V[0].F[0], m.V[0].F[1], m.V[0].F[2]] );

end;

procedure TForm1.tb1Change(Sender: TObject);
begin

  tb1.Hint := inttostr(tb1.Position * 50) + ' 000';

end;

procedure TForm1.tb2Change(Sender: TObject);
begin

  tb2.Hint := format( 'Distortion %.2f', [ tb2.Position * 0.1 ]);

end;

end.
