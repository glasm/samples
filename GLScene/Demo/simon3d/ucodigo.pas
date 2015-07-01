unit ucodigo;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Forms, Dialogs, GLScene, GLObjects, VectorGeometry,
  GLWin32Viewer, GLVectorFileObjects, Vectortypes, GLMaterial, GLState,
  MMSystem, GLBitmapFont, GLWindowsFont, Menus, GLFile3DS,
  ExtCtrls, StdCtrls, ComCtrls, GLHUDObjects, GLTexture, Graphics,
  GLCoordinates, GLCrossPlatform, Controls, BaseClasses;

type
  TForm1 = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    DummyCube1: TGLDummyCube;
    Red1: TGLFreeForm;
    Green4: TGLFreeForm;
    Yellow3: TGLFreeForm;
    Blue2: TGLFreeForm;
    Button2: TButton;
    Timer1: TTimer;
    Base1: TGLFreeForm;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Jogo1: TMenuItem;
    Ajuda1: TMenuItem;
    Novo1: TMenuItem;
    Contedo1: TMenuItem;
    N1: TMenuItem;
    Sobre1: TMenuItem;
    GLLightSource1: TGLLightSource;
    GLLightSource2: TGLLightSource;
    N2: TMenuItem;
    Sair1: TMenuItem;
    N3: TMenuItem;
    Recordes1: TMenuItem;
    Exibir1: TMenuItem;
    Perspectiva1: TMenuItem;
    VistaSuperior1: TMenuItem;
    N4: TMenuItem;
    Wireframe1: TMenuItem;
    procedure LoadResourceTexture(ResourceName: String; Texture: TGLTexture);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure TocaSom(Sons: String);

    Procedure Roda(pedaco: tGLfreeform);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Novo1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Recordes1Click(Sender: TObject);
    procedure Contedo1Click(Sender: TObject);
    procedure Perspectiva1Click(Sender: TObject);
    procedure VistaSuperior1Click(Sender: TObject);
    procedure Wireframe1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  mdx, mdy : Integer;
  cor_antiga, cor_nova: Tvector4f;
  cor_a, cor_n: Tvector4f;
  notacerta, notaclicada: string;
  jogoiniciado: boolean;
  S1, S2, S3, S4:string;
  Pontos: integer;
  pickdown : TGLCustomSceneObject;
  pickup : TGLCustomSceneObject;
  
Const
 clrWhite: TVector = (1, 1, 1, 1);

implementation

uses frmsobre, frmrecorde;

{$R *.dfm}
{$R SimonRec.RES}

procedure TForm1.LoadResourceTexture(ResourceName: String; Texture: TGLTexture);
var B: TBitmap;
      RS: TResourceStream;
begin
    RS := TResourceStream.Create(0, ResourceName, 'BMP');
    try
      B := TBitmap.Create;
      try
        B.LoadFromStream(RS);
        Texture.Image.Assign(B);
      finally
         B.Free;
      end;
    finally
      RS.Free;
    end;
end;

procedure TForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   //if Shift<>[] then
   if Shift=[ssRight] then
      GLCamera1.MoveAroundTarget(mdy-y, mdx-x);
	mdx:=x; mdy:=y;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
PedacoR, BaseR: Tresourcestream;
redt, bluet, yellowt, greent: TGLTexture;
begin
  Redt:=TGLTexture.Create(self);
  LoadResourceTexture('Red1', Redt);
  Bluet:=TGLTexture.Create(self);
  LoadResourceTexture('Blue2', Bluet);
  Yellowt:=TGLTexture.Create(self);
  LoadResourceTexture('Yellow3', Yellowt);
  Greent:=TGLTexture.Create(self);
  LoadResourceTexture('Green4', Greent);
PedacoR:=tresourcestream.Create(hinstance, 'pedaco', '3DS');
BaseR:=tresourcestream.Create(hinstance, 'base', '3DS');
Red1.LoadFromStream('pedaco.3ds', PedacoR);
Red1.Material.Texture.image:=redt.image;
Blue2.LoadFromStream('pedaco.3ds', PedacoR);
Blue2.Material.Texture.image:=bluet.image;
Yellow3.LoadFromStream('pedaco.3ds', PedacoR);
Yellow3.Material.Texture.image:=yellowt.image;
Green4.LoadFromStream('pedaco.3ds', PedacoR);
Green4.Material.Texture.image:=Greent.image;
Base1.LoadFromStream('base.3ds', BaseR);
jogoiniciado:= false;
StatusBar1.Panels[0].Text:='';
Statusbar1.Panels[1].text:='';
Pontos:=0;
end;

procedure TForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button = mbLeft then   //testa se o botão do mouse clicado foi o esquerdo
 begin
   pickdown:=(GLSceneViewer1.Buffer.GetPickedObject(x, y) as TGLCustomSceneObject);
   if Assigned(pickdown) and (pickdown is TGLfreeform) then
        begin
        cor_antiga:=pickdown.Material.FrontProperties.Emission.Color;
        cor_nova:=vectorlerp(cor_antiga, clrwhite, 0.25);
         if pickdown.Name='Base1' then
         pickdown.Material.FrontProperties.Emission.Color:=cor_antiga
         else
         pickdown.Material.FrontProperties.Emission.Color:=cor_nova;
        end;
 end;
end;

procedure TForm1.GLSceneViewer1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
pedaco: string;
tammenor, tammaior: integer;
Nome: string;
begin
if Button = mbLeft then  //testa se o botão do mouse clicado foi o esquerdo
 begin
  pickup:=(GLSceneViewer1.Buffer.GetPickedObject(x, y) as TGLCustomSceneObject);
  if Assigned(pickup)  then
       if  (pickup=pickdown) and (pickup is TGLfreeform) then
         begin
         pickup.Material.FrontProperties.Emission.Color:=cor_antiga;
         if pickup.Name='Red1' then
           begin
           S1:=S1+'1';
           //sndPlaySound('red.wav',snd_ASync);
           PlaySound('Red', HInstance, SND_RESOURCE or SND_ASYNC);
           end;
         if pickup.Name='Blue2' then
            begin
            S1:=S1+'2';
//            sndPlaySound('Blue.wav',snd_ASync);
            PlaySound('Blue', HInstance, SND_RESOURCE or SND_ASYNC);
            end;
         if pickup.Name='Yellow3' then
             begin
             S1:=S1+'3';
             //sndPlaySound('Yellow.wav',snd_ASync);
             PlaySound('Yellow', HInstance, SND_RESOURCE or SND_ASYNC);
             end;
         if pickup.Name='Green4' then
            begin
            S1:=S1+'4';
            //sndPlaySound('Green.wav',snd_ASync);
            PlaySound('Green', HInstance, SND_RESOURCE or SND_ASYNC);
            end;
         end;
if (pickdown is TGLfreeform) and (pickup<>pickdown) then
         begin
         pickdown.Material.FrontProperties.Emission.Color:=cor_antiga;
         if pickdown.Name='Red1' then
            begin
            S1:=S1+'1';
            //sndPlaySound('red.wav',snd_ASync);
            PlaySound('Red', HInstance, SND_RESOURCE or SND_ASYNC);
            end;
         if pickdown.Name='Blue2' then
            begin
            S1:=S1+'2';
            //sndPlaySound('blue.wav',snd_ASync);
            PlaySound('Blue', HInstance, SND_RESOURCE or SND_ASYNC);
            end;
         if pickdown.Name='Yellow3' then
            begin
            S1:=S1+'3';
            //sndPlaySound('yellow.wav',snd_ASync);
            PlaySound('Yellow', HInstance, SND_RESOURCE or SND_ASYNC);            end;
         if pickdown.Name='Green4' then
            begin
            S1:=S1+'4';
            //sndPlaySound('green.wav',snd_ASync);
            PlaySound('Green', HInstance, SND_RESOURCE or SND_ASYNC);
            end;
         end;
tammenor:= length(S1);
tammaior:=length(S2);
pedaco:=copy(S2, 1, tammenor);
if (jogoiniciado=true) and (CompareStr(pedaco, S1) <> 0) then
  begin
  //sndPlaySound('error.wav',snd_ASync);
  PlaySound('Error', HInstance, SND_RESOURCE or SND_ASYNC);
  jogoiniciado:=false;
  Button2.Visible:=false;
  S3:='Fim de Jogo';
  //começa bloco dos Recordes
  Application.CreateForm(TForm2, Form2);{Carrega form na memória}
  if form2.TestaRecorde(inttostr(pontos)) then
       begin
        Nome:=InputBox('Best Scores', 'Type your name', '');
        Form2.AcrescentaRecorde(inttostr(Pontos), Nome);
        Form2.ShowModal;{Mostra form em modo exclusivo}
        Form2.Free; {Libera Memória}
        end;
  //Fim do Bloco dos Recordes
  end else
   if (tammenor=tammaior) and (jogoiniciado=true) then
     begin
     S1:='';
     S3:='Stage completed';
     Inc(Pontos);
     S4:=inttostr(Pontos) + ' Points';
     Button2.Visible:=true;
     end else
       S3:='';
end;
end;

Procedure TForm1.TocaSom(Sons: String);
Var
I, K: integer;
J: String;
begin
S2:='';
K:=length(Sons);
 for I:=1 to k do
  begin
    J:=Sons[I];
    if (J = '1') then
      begin
      S2:=S2+'1';
      roda(Red1);
      end;
    if (J = '2') then
      begin
      S2:=S2+'2';
      roda(Blue2);
      end;
    if (J = '3') then
       begin
       S2:=S2+'3';
       roda(Yellow3);
       end;
    if (J = '4') then
      begin
      S2:=S2+'4';
      roda(Green4);
      end;
    sleep(450);
    end;
end;

Procedure TForm1.roda(pedaco: TGLFreeForm);
begin
if pedaco.Name = 'Red1' then
        begin
        cor_a:=form1.Red1.Material.FrontProperties.Emission.Color;
        cor_n:=vectorlerp(cor_a, clrwhite, 0.25);
        Red1.Material.FrontProperties.Emission.Color:=cor_n;
        GLSceneViewer1.Update;
        sleep(50);
        Red1.Material.FrontProperties.Emission.Color:=cor_a;
        //sndPlaySound('red.wav',snd_ASync);
        PlaySound('Red', HInstance, SND_RESOURCE or SND_ASYNC);
        end;
if pedaco.Name = 'Blue2' then
        begin
        cor_a:=form1.Blue2.Material.FrontProperties.Emission.Color;
        cor_n:=vectorlerp(cor_a, clrwhite, 0.25);
        Blue2.Material.FrontProperties.Emission.Color:=cor_n;
        GLSceneViewer1.Update;
        sleep(50);
        Blue2.Material.FrontProperties.Emission.Color:=cor_a;
        //sndPlaySound('blue.wav',snd_ASync);
        PlaySound('Blue', HInstance, SND_RESOURCE or SND_ASYNC);
        end;
if pedaco.Name = 'Yellow3' then
        begin
        cor_a:=form1.Yellow3.Material.FrontProperties.Emission.Color;
        cor_n:=vectorlerp(cor_a, clrwhite, 0.25);
        Yellow3.Material.FrontProperties.Emission.Color:=cor_n;
        GLSceneViewer1.Update;
        sleep(50);
        Yellow3.Material.FrontProperties.Emission.Color:=cor_a;
        //sndPlaySound('yellow.wav',snd_ASync);
        PlaySound('Yellow', HInstance, SND_RESOURCE or SND_ASYNC);
        end;
if pedaco.Name = 'Green4' then
        begin
        cor_a:=form1.Green4.Material.FrontProperties.Emission.Color;
        cor_n:=vectorlerp(cor_a, clrwhite, 0.25);
        Green4.Material.FrontProperties.Emission.Color:=cor_n;
        GLSceneViewer1.Update;
        sleep(50);
        Green4.Material.FrontProperties.Emission.Color:=cor_a;
        //sndPlaySound('green.wav',snd_ASync);
        PlaySound('Green', HInstance, SND_RESOURCE or SND_ASYNC);
        end;
end;
procedure TForm1.Button2Click(Sender: TObject);
begin

if jogoiniciado=true then
  begin
  button2.Visible:=false;
  Randomize;
  Notacerta:=notacerta+Inttostr(Random(4)+1);
  tocasom(notacerta);
  S1:='';
  S3:='';
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   //Caption:=Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  // GLSceneViewer1.ResetPerformanceMonitor;
 StatusBar1.Panels[0].Text:=S4;
 Statusbar1.Panels[1].text:=S3;
end;

procedure TForm1.Novo1Click(Sender: TObject);
begin
 jogoiniciado:=true;
 Notacerta:='';
 Button2.Click;
 S4:='0 Points';
 S3:='';
 Pontos:=0;
end;

procedure TForm1.Sobre1Click(Sender: TObject);
begin
 Application.CreateForm(TAboutBox, AboutBox);{Carrega form na memória}
 AboutBox.ShowModal;{Mostra form em modo exclusivo}
 AboutBox.Free; {Libera Memória}
end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Recordes1Click(Sender: TObject);
begin
 Application.CreateForm(TForm2, Form2);{Carrega form na memória}
 Form2.ShowModal;{Mostra form em modo exclusivo}
 Form2.Free; {Libera Memória}
end;

procedure TForm1.Contedo1Click(Sender: TObject);
begin
//Application.HelpFile:='Simon3D.hlp';
//Application.helpcommand(HELP_CONTENTS,0);
end;

procedure TForm1.Perspectiva1Click(Sender: TObject);
begin
GLCamera1.Position.X:=6;
GLCamera1.Position.Y:=6;
GLCamera1.Position.Z:=6;
end;

procedure TForm1.VistaSuperior1Click(Sender: TObject);
begin
GLCamera1.Position.X:=0;
GLCamera1.Position.Y:=10;
GLCamera1.Position.Z:=0;
GLCamera1.MoveAroundTarget(-45, 0);
//GLSceneViewer1.Update;
end;

procedure TForm1.Wireframe1Click(Sender: TObject);
begin
if Red1.Material.PolygonMode=pmfill then
 begin
 Red1.Material.PolygonMode:=pmlines;
 Wireframe1.Checked:=true;
 end
 else
 begin
 Red1.Material.PolygonMode:=pmfill;
 Wireframe1.Checked:=false;
 end;
if blue2.Material.PolygonMode=pmfill then
blue2.Material.PolygonMode:=pmlines else
blue2.Material.PolygonMode:=pmfill;
if Yellow3.Material.PolygonMode=pmfill then
Yellow3.Material.PolygonMode:=pmlines else
Yellow3.Material.PolygonMode:=pmfill;
if Green4.Material.PolygonMode=pmfill then
Green4.Material.PolygonMode:=pmlines else
Green4.Material.PolygonMode:=pmfill;
if Base1.Material.PolygonMode=pmfill then
Base1.Material.PolygonMode:=pmlines else
Base1.Material.PolygonMode:=pmfill;
end;

end.
