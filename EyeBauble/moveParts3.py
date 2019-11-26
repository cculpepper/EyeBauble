import sys
sys.path.append("/usr/local/lib/python2.7/site-packages")
import math
import pcbnew
import numpy as np

def cart2pol(x, y):
    rho = np.sqrt(x**2 + y**2)
    phi = np.arctan2(y, x)
    return(rho, phi)

def pol2cart(rho, phi):
    x = rho * np.cos(math.radians(phi))
    y = rho * np.sin(math.radians(phi))
    return(x, y)

def moveLeds():
    start=15
    by=.17
    r=9999
    minDist=1.9
    height=1.6

    cX=90
    cY=90
    rot=0
    x=cX+pol2cart(r,rot)[0]
    y=cY+pol2cart(r,rot)[1]

    innerR=r-height/2
    angleDifference=2*math.degrees(np.arcsin(minDist/2/innerR))
    

    board=pcbnew.GetBoard()
    board=pcbnew.LoadBoard("EyeBauble.kicad_pcb")
    modules=board.GetModules()
    for mod in modules:
        x=(cX+pol2cart(r,rot)[0])
        y=(cY+pol2cart(r,rot)[1])
        #import pdb;pdb.set_trace()

        mod.SetPosition(pcbnew.wxPointMM(float(x),float(y)))
        mod.SetOrientation((-rot)*10)
        #mod.SetOrientation(0)

        rot+=angleDifference
        print(mod.GetReference() + " to " +str(x) + ", " + str(y) + ", rot:" + str(rot))
    board.Save("output3.kicad_pcb")
moveLeds()
