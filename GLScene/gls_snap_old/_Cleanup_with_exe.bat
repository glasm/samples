echo off
del *.dcu /s
del *.ddp /s
del *.ppu /s
del *.o /s
del *.~* /s
del *.log /s
del *.dsk /s
del *.dof /s
del *.bk? /s
del *.mps /s
del *.rst /s
del *.s /s
del *.a /s
del *.map /s
del *.rsm /s
del *.drc /s
del *.2007 /s
del *.local /s

echo _
echo ************************************************
echo             Don't delete some files
echo ************************************************
echo _

attrib +R "AdvDemos/Q3Demo/Model/animation.cfg"
attrib +R "Source/DesignTime/Resources/lazres.exe"

del *.exe /s
del *.cfg /s

attrib -R "AdvDemos/Q3Demo/Model/animation.cfg"
attrib -R "Source/DesignTime/Resources/lazres.exe"