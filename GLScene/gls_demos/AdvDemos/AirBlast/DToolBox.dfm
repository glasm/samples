object DMToolBox: TDMToolBox
  OldCreateOrder = False
  Left = 314
  Top = 94
  Height = 150
  Width = 215
  object GLScene: TGLScene
    Left = 24
    Top = 16
    object FreeForm: TGLFreeForm
      Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {0000000000000000000080BF00000000}
      UseMeshMaterials = False
    end
    object GLCamera: TGLCamera
      DepthOfView = 100
      FocalLength = 50
      CameraStyle = csOrthogonal
    end
  end
  object MemoryViewer: TGLMemoryViewer
    Camera = GLCamera
    Buffer.BackgroundColor = clWhite
    Buffer.ContextOptions = [roDestinationAlpha]
    Buffer.Lighting = False
    Buffer.AntiAliasing = aa4x
    Buffer.ColorDepth = cd24bits
    Left = 112
    Top = 16
  end
end
