{: Illustrates the effects of AutoCentering for FreeForms.<p>

   The same mesh is loaded three times and centered with different options
   (by default, the polyhedron is not centered in its mesh).
}

unit Unit1;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GLScene, GLVectorFileObjects, GLObjects, ComCtrls, StdCtrls,
  GLLCLViewer, GLFile3DS, GLCrossPlatform, GLCoordinates, BaseClasses;

type
  TForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera1: TGLCamera;
    DummyCube1: TGLDummyCube;
    DummyCube2: TGLDummyCube;
    DummyCube3: TGLDummyCube;
    FreeForm1: TGLFreeForm;
    FreeForm2: TGLFreeForm;
    FreeForm3: TGLFreeForm;
    GLLightSource1: TGLLightSource;
    DCCamera: TGLDummyCube;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses FileUtil;

procedure TForm1.FormCreate(Sender: TObject);
const
   cFileName = 'polyhedron.3ds';
var
  path: UTF8String;
  p: Integer;
begin
   path := ExtractFilePath(ParamStrUTF8(0));
   p := Pos('DemosLCL', path);
   Delete(path, p+5, Length(path));
   path := IncludeTrailingPathDelimiter(path) + 'media';
   SetCurrentDirUTF8(path);

   // left one
   FreeForm3.AutoCentering:=[macCenterX, macCenterZ];
   FreeForm3.LoadFromFile(cFileName);
   // central one
   FreeForm2.AutoCentering:=[macCenterY];
   FreeForm2.LoadFromFile(cFileName);
   // right one
   FreeForm1.AutoCentering:=[macCenterX, macCenterY, macCenterZ];
   FreeForm1.LoadFromFile(cFileName);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
   DCCamera.PitchAngle:=TrackBar1.Position;
end;

end.
