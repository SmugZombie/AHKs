#include FcnLib.ahk

file:="C:\joe.jpg"
nl:=100
nt:=100
nw:=200
nh:=200
pToken:=Gdip_Startup()
pBitmap:=Gdip_BitmapFromScreen(nL "|" nT "|" nW "|" nH)
Gdip_SaveBitmapToFile(pBitmap, file, 100)
Gdip_Shutdown(pToken)

while NOT FileExist(file)
   Sleep, 10

