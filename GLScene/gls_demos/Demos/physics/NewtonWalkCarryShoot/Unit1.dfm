object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 384
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 580
    Height = 384
    Camera = GLCamera1
    FieldOfView = 150.806854248046900000
    Align = alClient
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseUp = GLSceneViewer1MouseUp
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 16
    Top = 8
    object Body: TGLTorus
      Pickable = False
      MajorRadius = 0.400000005960464500
      MinorRadius = 0.100000001490116100
      BehavioursData = {
        0458434F4C02010201060D54474C4E474444796E616D69630200060B4E474420
        44796E616D696302000201060D474C4E47444D616E6167657231080209050000
        0000000AD7A3F83F1200000000020109050000000000CDCCCCFB3F0500000000
        00000080FF3F0905000000000000000000000200080200080200095455D53054
        55D530000000000000803F020008}
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      TargetObject = Body
      Position.Coordinates = {0000404000004040000040400000803F}
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        SpotCutOff = 180.000000000000000000
      end
    end
    object World: TGLDummyCube
      CubeSize = 1.000000000000000000
      object Beer: TGLFreeForm
      end
      object Mushroom: TGLFreeForm
      end
      object Chair: TGLFreeForm
      end
      object Teapot: TGLFreeForm
      end
      object Map: TGLFreeForm
      end
    end
    object GLDummyCube1: TGLDummyCube
      Position.Coordinates = {0000000000002041000000000000803F}
      CubeSize = 1.000000000000000000
      VisibleAtRunTime = True
    end
    object GLLines1: TGLLines
      Pickable = False
      Nodes = <
        item
          X = -0.625000000000000000
          Y = -0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = -0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = -0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = 0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = 0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = 0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = 0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = -0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = -0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = -0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = -0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = 0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = 0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = 0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = 0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = -0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = -0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = -0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = -0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = -0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = 0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = 0.625000000000000000
          Y = 0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = 0.625000000000000000
          Z = 0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
          X = -0.625000000000000000
          Y = 0.625000000000000000
          Z = -0.224999994039535500
          Color.Color = {0000803F0000803F000000000000803F}
        end
        item
        end
        item
          Y = 1.000000000000000000
        end
        item
        end
        item
          X = 1.000000000000000000
        end>
      NodesAspect = lnaInvisible
      SplineMode = lsmSegments
      Options = [loUseNodeColorForLines]
    end
    object GLHUDCross: TGLHUDSprite
      Pickable = False
    end
  end
  object GLSimpleNavigation1: TGLSimpleNavigation
    Form = Owner
    GLSceneViewer = GLSceneViewer1
    ZoomSpeed = 1.100000023841858000
    MoveAroundTargetSpeed = 0.250000000000000000
    FormCaption = 'Form1 - %FPS'
    KeyCombinations = <
      item
        ShiftState = [ssRight]
        Action = snaMoveAroundTarget
      end>
    Left = 56
    Top = 8
  end
  object GLNGDManager1: TGLNGDManager
    NewtonSurfaceItem = <>
    NewtonSurfacePair = <>
    DebugOption.NGDManagerDebugs = [mdShowAABB, mdShowJoint]
    Line = GLLines1
    NewtonJoint = <
      item
        JointType = nj_UpVector
        ParentObject = Body
      end
      item
        JointType = nj_UpVector
        ParentObject = Body
        UPVectorDirection.Coordinates = {0000803F000000000000000000000000}
      end>
    Left = 136
    Top = 8
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 96
    Top = 8
  end
end
