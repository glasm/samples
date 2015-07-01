unit main;

interface

uses
    Windows, SysUtils, Classes, Graphics, Forms, Dialogs, Buttons, ExtCtrls,
    StdCtrls, jpeg,

    GLCadencer, GLObjects, GLScene, GLGraph, GLWin32Viewer, GLKeyboard,
    GLNavigator, GLTexture, GLVectorFileObjects, GLMesh, VectorGeometry,
    VectorTypes,  meshutils, vectorlists, PersistentClasses,
    GLMaterial, GLCoordinates, GLCrossPlatform, Controls, BaseClasses;

type
    TForm1 = class(TForm)
        SpeedButton7: TSpeedButton;
        SpeedButton8: TSpeedButton;
        Panel1: TPanel;
        GLScene1: TGLScene;
        GLDummyCube1: TGLDummyCube;
        GLCube1: TGLCube;
        GLDummyCube2: TGLDummyCube;
        GLCamera1: TGLCamera;
        GLXYZGrid1: TGLXYZGrid;
        GLCadencer1: TGLCadencer;
        GLUserInterface1: TGLUserInterface;
        GLNavigator1: TGLNavigator;
        GLXYZGrid2: TGLXYZGrid;
        Label8: TLabel;
        XLabel: TLabel;
        Label10: TLabel;
        YLabel: TLabel;
        Label12: TLabel;
        ZLabel: TLabel;
        GLFreeForm1: TGLFreeForm;
        GLMaterialLibrary1: TGLMaterialLibrary;
        Edit1: TEdit;
        Label7: TLabel;
        Label9: TLabel;
        Label11: TLabel;
        Label13: TLabel;
        r0RB: TRadioButton;
        r90RB: TRadioButton;
        r180RB: TRadioButton;
        r270RB: TRadioButton;
        Label14: TLabel;
        TopCB: TCheckBox;
        BottomCB: TCheckBox;
        LeftCB: TCheckBox;
        RightCB: TCheckBox;
        Label15: TLabel;
        FrontCB: TCheckBox;
        BackCB: TCheckBox;
        Button1: TButton;
        GLSceneViewer4: TGLSceneViewer;
        WidthEdit: TEdit;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        FrontHeightedit: TEdit;
        SpeedButton3: TSpeedButton;
        SpeedButton4: TSpeedButton;
        BackHeightEdit: TEdit;
        SpeedButton5: TSpeedButton;
        SpeedButton6: TSpeedButton;
        DepthEdit: TEdit;
        SpeedButton9: TSpeedButton;
        SpeedButton10: TSpeedButton;
        Memo1: TMemo;
        GLNavigator2: TGLNavigator;
        procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
            newTime: Double);
        procedure GLSceneViewer4MouseDown(Sender: TObject;
            Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure GLSceneViewer4MouseUp(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure SpeedButton7Click(Sender: TObject);
        procedure SpeedButton8Click(Sender: TObject);
        procedure GLSceneViewer4Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure rRBClick(Sender: TObject);
        procedure PartsCBClick(Sender: TObject);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure Edit1KeyPress(Sender: TObject; var Key: Char);
        procedure Button1Click(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure SpeedButton2Click(Sender: TObject);
    PRIVATE
        { Private declarations }
        oldpt: TPoint; //used to keep track of where the mouse button was pressed
        rotangle: integer;
        addextravertex: boolean;
    PUBLIC
        { Public declarations }
        procedure BuildCube(x, y, z, w, fh, bh, d, yoffs, rot: single; front, back, top, bottom, left, right, addextravertex: boolean);
        procedure deleteobject;
    end;

var
    Form1: TForm1;

implementation

{$R *.dfm}


function s2f(s:string):single;
var fs:TFormatSettings;
begin

  fs.DecimalSeparator := ',';
  if not trystrtofloat(s,result,fs) then begin
    fs.DecimalSeparator := '.';
    if not trystrtofloat(s,result,fs) then
      result := 0;
  end;

end;


procedure TForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
    newTime: Double);
var
    i: integer;
label
    update;
begin
    //camera movement n stuff
    i := 0;

    //delete a cube
    if iskeydown(vk_Delete) then
    begin
        deleteobject;
        edit1.SetFocus;
        while isKeydown(vk_Delete) and (i < 5) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;

    //move forward
    if iskeydown(VK_UP) then
    begin
        edit1.SetFocus;
        gldummycube1.Move(1);
        GLDummycube2.Position := GLDummyCube1.Position;
        while isKeydown(VK_UP) and (i < 2) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;

    //move back
    if iskeydown(VK_DOWN) then
    begin
        edit1.SetFocus;
        gldummycube1.Move(-1);
        GLDummycube2.Position := GLDummyCube1.Position;
        while isKeydown(VK_DOWN) and (i < 2) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;

    //move left
    if iskeydown(VK_LEFT) then
    begin
        edit1.SetFocus;
        gldummycube1.Slide(-1);
        GLDummycube2.Position := GLDummyCube1.Position;
        while isKeydown(VK_LEFT) and (i < 2) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;

    //move right
    if iskeydown(VK_RIGHT) then
    begin
        edit1.SetFocus;
        gldummycube1.Slide(1);
        GLDummycube2.Position := GLDummyCube1.Position;
        while isKeydown(VK_RIGHT) and (i < 2) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;

    //move down
    if iskeydown(VK_NEXT) then
    begin
        edit1.SetFocus;
        gldummycube1.Lift(-1);
        GLDummycube2.Position := GLDummyCube1.Position;
        while isKeydown(VK_NEXT) and (i < 2) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;

    //move up
    if iskeydown(VK_PRIOR) then
    begin
        edit1.SetFocus;
        gldummycube1.Lift(1);
        GLDummycube2.Position := GLDummyCube1.Position;
        while isKeydown(VK_PRIOR) and (i < 2) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;

    //add a cube
    if iskeydown(VK_SPACE) then
    begin
        edit1.SetFocus;
        //delete a cube that is in the currently selected
        //area before adding another one.
        Deleteobject;
        with GLDummycube1.position do
            BuildCube(x, y, z, s2f(widthedit.text), s2f(frontheightedit.text),
                s2f(backheightedit.text), s2f(depthedit.text), 0.5, rotangle, frontcb.checked,
                backcb.checked, topcb.checked, bottomcb.checked, leftcb.checked, rightcb.checked, addextravertex);
        while isKeydown(VK_SPACE) and (i < 5) do
        begin
            inc(i);
            sleep(100);
            application.ProcessMessages;
        end;
        goto update;
    end;
    //update the mouselook
    GLUserInterface1.MouseLook;
    GLUserInterface1.MouseUpdate;

    update:
    //makes the movement a little less confusing as the view is rotated
    //Get GLNavigator.pas from CVS with the CurrentHAngle property added
    GLDummycube1.TurnAngle := round((glnavigator2.CurrentHAngle / 90)) * 90;
    //update the coord status
    XLabel.Caption := format('%.2f', [GLDummycube1.position.x]);
    YLabel.Caption := format('%.2f', [GLDummycube1.position.y]);
    ZLabel.Caption := format('%.2f', [GLDummycube1.position.z]);
end;

procedure TForm1.deleteobject;
var
    i: integer;
    v1, v2, v3, v4, v5, v6: TVector3f;
begin
    //a silly little procedure to detect and delete cubes from the freeform that are
    //occupying the currently selected area
    for i := GLFreeform1.MeshObjects.count - 1 downto 0 do
    begin
        with GLDummycube1.position do
        begin
            makevector(v1, (x * 10) + (gldummycube1.CubeSize * 5) - 0.1, (y * 10), (z * 10));
            makevector(v2, (x * 10) - (gldummycube1.CubeSize * 5) + 0.1, (y * 10), (z * 10));
            makevector(v3, (x * 10), (y * 10) + (gldummycube1.CubeSize * 5) - 0.1, (z * 10));
            makevector(v4, (x * 10), (y * 10) - (gldummycube1.CubeSize * 5) + 0.1, (z * 10));
            makevector(v5, (x * 10), (y * 10), (z * 10) + (gldummycube1.CubeSize * 5) - 0.1);
            makevector(v6, (x * 10), (y * 10), (z * 10) - (gldummycube1.CubeSize * 5) + 0.1);
        end;
        with glfreeform1.MeshObjects[i] do
            if PointInObject(v1) or PointInObject(v2) or
                PointInObject(v3) or PointInObject(v4) or
                PointInObject(v5) or PointInObject(v6) then
            begin
                glfreeform1.MeshObjects.Delete(i);
                glfreeform1.StructureChanged;
            end;
    end;
end;

procedure TForm1.GLSceneViewer4MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if button = mbleft then
    begin
        //take the focus away from the other controls,
        edit1.SetFocus;
        //store old mouse pos
        oldpt := GLSceneViewer4.clienttoscreen(point(x, y));
        //and activate the mouse look
        GLUserInterface1.MouseLookActivate;
    end;
end;

procedure TForm1.GLSceneViewer4MouseUp(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //deactivate the mouse look and restore the old mouse pos
    if button = mbleft then
    begin
        GLUserInterface1.MouseLookDeActivate;
        SetCursorPos(oldpt.x, oldpt.y);
    end;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
    //zoom in
    if GLCamera1.Position.z < -2 then
        GLCamera1.Position.z := GLCamera1.Position.z + 1;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
    //zoom out
    if GLCamera1.Position.z > -16 then
        GLCamera1.Position.z := GLCamera1.Position.z - 1;
end;

procedure TForm1.BuildCube(x, y, z, w, fh, bh, d, yoffs, rot: single; front, back, top, bottom, left, right, addextravertex: boolean);
var
    FaceGroup: TFGVertexIndexList;
    i: integer;
    vect: TVector3f;
    Obj: TMeshObject;
    n: integer; //number of vertices added
begin
    //scale the dimensions with the freeform scale
    w := (w / GLFreeform1.Scale.x) / 2;
    //remove all the {} in this proc to centre the cube vertically
    fh := (fh / GLFreeform1.Scale.y) {/ 2}; //remove all the {} in this proc to centre the cube vertically
    bh := (bh / GLFreeform1.Scale.y) {/ 2};
    d := (d / GLFreeform1.Scale.z) / 2;

    x := (x / GLFreeform1.Scale.x);
    y := (y / GLFreeform1.Scale.y) - (yoffs / GLFreeform1.Scale.y);
    z := (z / GLFreeform1.Scale.z);

    //create a mesh object to work with
    obj := TMeshObject.CreateOwned(GLFreeform1.MeshObjects);
    //work in facegroup mode
    obj.Mode := momFacegroups;

    n := 0;

    if front then
    begin
        // front
        with obj.Vertices do
        begin
            //one for each corner of the quad
            Add(-w, 0 {-fh}, -d); Add(-w, fh, -d); Add(w, fh, -d); Add(w, 0 {-fh}, -d);
        end;

        //set the tex coords to cover the whole quad
        with obj.TexCoords do
        begin
            //bottom left, bottom right, top right, top left
            Add(1, 0); Add(1, 1); Add(0, 1); Add(0, 0);
        end;
        //add a new facegroup
        facegroup := TFGVertexIndexList.CreateOwned(obj.FaceGroups);
        //and set the material
        facegroup.MaterialName := 'DefaultFront';
        with facegroup do
        begin
            //triangle 1
            //vertex 0, vertex 1, vertex 2
            add(0); add(1); add(2);
            //triangle 2
            //vertex 2, vertex 3, vertex 0
            add(2); add(3); add(0);
        end;
        //4 vertices added so far
        inc(n, 4);
    end;

    // all the other parts are added in exactly the same way.
    // I had to experiment until the faces appeared how I wanted them.
    // The only way I could change the normals was by changing the order I added
    // to the facegroup
    if back then
    begin
        //back
        with obj.Vertices do
        begin
            Add(w, 0 {- bh}, d); Add(w, bh, d); Add(-w, bh, d); Add(-w, 0 { - bh}, d);
        end;

        with obj.TexCoords do
        begin
            Add(1, 0); add(1, 1); Add(0, 1); Add(0, 0);
        end;
        facegroup := TFGVertexIndexList.CreateOwned(obj.FaceGroups);
        facegroup.MaterialName := 'DefaultBack';
        with facegroup do
        begin
            add(n); add(1 + n); add(2 + n);
            add(2 + n); add(3 + n); add(n);
        end;
        inc(n, 4);
    end;

    if top then
    begin
        // top
        with obj.Vertices do
        begin
            Add(-w, bh, d); Add(w, bh, d); Add(w, fh, -d); Add(-w, fh, -d);
        end;
        with obj.TexCoords do
        begin
            Add(1, 1); Add(0, 1); Add(0, 0); Add(1, 0);
        end;
        facegroup := TFGVertexIndexList.CreateOwned(obj.FaceGroups);
        facegroup.MaterialName := 'DefaultTop';
        with facegroup do
        begin
            add(n); add(1 + n); add(2 + n);
            add(2 + n); add(3 + n); add(n);
        end;
        inc(n, 4);
    end;

    if bottom then
    begin
        // bottom
        with obj.Vertices do
        begin
            Add(-w, 0 {- fh}, -d); Add(w, 0 {- fh}, -d); Add(w, 0 {- bh}, d); Add(-w, 0 { - bh}, d);
        end;
        with obj.TexCoords do
        begin
            Add(1, 1); Add(0, 1); Add(0, 0); Add(1, 0);
        end;
        facegroup := TFGVertexIndexList.CreateOwned(obj.FaceGroups);
        facegroup.MaterialName := 'DefaultBottom';
        with facegroup do
        begin
            add(n); add(1 + n); add(2 + n);
            add(2 + n); add(3 + n); add(n);
        end;
        inc(n, 4);
    end;

    if left then
    begin
        // left
        with obj.Vertices do
        begin
            Add(w, bh, d); Add(w, 0 {- bh}, d); Add(w, 0 {- fh}, -d); Add(w, fh, -d);
        end;
        with obj.TexCoords do
        begin
            Add(0, 1); Add(0, 0); Add(1, 0); Add(1, 1);
        end;
        facegroup := TFGVertexIndexList.CreateOwned(obj.FaceGroups);
        facegroup.MaterialName := 'DefaultLeft';
        with facegroup do
        begin
            add(n); add(1 + n); add(2 + n);
            add(2 + n); add(3 + n); add(n);
        end;
        inc(n, 4);
    end;

    if right then
    begin
        // right
        with obj.Vertices do
        begin
            Add(-w, bh, d); Add(-w, fh, -d); Add(-w, 0 {- fh}, -d); Add(-w, 0 {- bh}, d);
        end;
        with obj.TexCoords do
        begin
            Add(1, 1); Add(0, 1); Add(0, 0); Add(1, 0);
        end;
        facegroup := TFGVertexIndexList.CreateOwned(obj.FaceGroups);
        facegroup.MaterialName := 'DefaultRight';
        with facegroup do
        begin
            add(n); add(1 + n); add(2 + n);
            add(2 + n); add(3 + n); add(n);
        end;
    end;

    FaceGroup.Mode := fgmmTriangles;
    //I dunno if this is the correct way to rotate vertices, but it works for this purpose
    if rot <> 0 then
        for i := 0 to glfreeform1.meshobjects[glfreeform1.meshobjects.Count - 1].Vertices.count - 1 do
        begin
            vect := glfreeform1.meshobjects[glfreeform1.meshobjects.Count - 1].Vertices[i];
            RotateVectorAroundY(vect, degToRad(rot));
            glfreeform1.meshobjects[glfreeform1.meshobjects.Count - 1].Vertices[i] := vect;
        end;

    //move the object into position
    makevector(vect, x, y, z);
    glfreeform1.meshobjects[glfreeform1.meshobjects.Count - 1].Translate(vect);

    //add the dummy vertex if requested
    if addextravertex then
        obj.Vertices.Add(x, y + yoffs, z);

    //update
    glfreeform1.StructureChanged;
end;

procedure TForm1.GLSceneViewer4Click(Sender: TObject);
begin
    //deactivate the mouse look when the mouse button is released
    GLUserInterface1.MouseLookDeactivate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    i: integer;
    dir: string;
begin
    dir := extractfilepath(paramstr(0));
    //load the materials
    GLMaterialLibrary1.AddTextureMaterial('DefaultFront', dir + 'media\fronttex.jpg');
    GLMaterialLibrary1.AddTextureMaterial('DefaultBack', dir + 'media\backtex.jpg');
    GLMaterialLibrary1.AddTextureMaterial('DefaultTop', dir + 'media\toptex.jpg');
    GLMaterialLibrary1.AddTextureMaterial('DefaultBottom', dir + 'media\bottex.jpg');
    GLMaterialLibrary1.AddTextureMaterial('DefaultLeft', dir + 'media\lefttex.jpg');
    GLMaterialLibrary1.AddTextureMaterial('DefaultRight', dir + 'media\righttex.jpg');
    //don't want lighting on these textures
    for i := 0 to GLMaterialLibrary1.Materials.count - 1 do
        GLMaterialLibrary1.Materials[i].Material.materialoptions := [moNoLighting];
    //init globals
    rotangle := 0;
    addextravertex := false;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    //used to take focus away from any of the other controls when moving around the scene
    edit1.SetFocus;
end;

procedure TForm1.rRBClick(Sender: TObject);
begin
    //get the rotation from the radio button's caption (0,90,180 or 270)
    rotangle := round(s2f(TRadiobutton(sender).Caption));
    edit1.SetFocus;
end;

procedure TForm1.PartsCBClick(Sender: TObject);
var
    count: integer;
begin
    count := 0;
    if frontcb.checked then
        inc(count);
    if backcb.checked then
        inc(count);
    if topcb.checked then
        inc(count);
    if bottomcb.checked then
        inc(count);
    if leftcb.checked then
        inc(count);
    if rightcb.checked then
        inc(count);
    //if only one part is selected add a dummy vertex, so the cube can be detected by the deleteobject procedure
    addextravertex := count < 2;
    //we need at least 1 part in the cube :)
    if count < 1 then
        TCheckbox(sender).checked := true;

    edit1.SetFocus;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    //set focus on the hidden edit box
    edit1.SetFocus;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    //ignore any keypresses in the edit box
    key := #0;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    i, j, k: integer;
begin
    //add loadsa cubes
    for i := 0 to 4 do
        for j := 0 to 4 do
            for k := 0 to 4 do
                with GLDummycube1.position do
                    BuildCube(i + x, j + y, k + z, s2f(widthedit.text), s2f(frontheightedit.text),
                        s2f(backheightedit.text), s2f(depthedit.text), 0.5, rotangle, frontcb.checked,
                        backcb.checked, topcb.checked, bottomcb.checked, leftcb.checked, rightcb.checked, addextravertex);
    edit1.SetFocus;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
    //these edit boxes should be replaced by spin edits.
    //I was using jvSpinEdit, but left it out for compatibility sake
    case TSpeedbutton(sender).tag of
        0:
            if s2f(widthedit.text) < 1.01 then
                WidthEdit.Text := format('%.2f', [s2f(widthedit.text) + 0.01]);
        1:
            if s2f(FrontHeightedit.text) < 1.01 then
                FrontHeightedit.Text := format('%.2f', [s2f(FrontHeightedit.text) + 0.01]);
        2:
            if s2f(BackHeightEdit.text) < 1.01 then
                BackHeightEdit.Text := format('%.2f', [s2f(BackHeightEdit.text) + 0.01]);
        3:
            if s2f(DepthEdit.text) < 1.01 then
                DepthEdit.Text := format('%.2f', [s2f(DepthEdit.text) + 0.01]);
    end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
    case TSpeedbutton(sender).tag of
        0:
            if s2f(widthedit.text) > 0.01 then
                WidthEdit.Text := format('%.2f', [s2f(widthedit.text) - 0.01]);
        1:
            if s2f(FrontHeightedit.text) > 0.01 then
                FrontHeightedit.Text := format('%.2f', [s2f(FrontHeightedit.text) - 0.01]);
        2:
            if s2f(BackHeightEdit.text) > 0.01 then
                BackHeightEdit.Text := format('%.2f', [s2f(BackHeightEdit.text) - 0.01]);
        3:
            if s2f(DepthEdit.text) > 0.01 then
                DepthEdit.Text := format('%.2f', [s2f(DepthEdit.text) - 0.01]);
    end;
end;

end.

