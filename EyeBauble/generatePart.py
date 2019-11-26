import math
letter = "N"
letterLayer="F.SilkS"
#innerBlockers=40
#outerBlockers=40
#outerOffset=360/outerBlockers/2
distanceIn=3.4
distanceOut=4.0



def viaString(innerBlockers, outerBlockers, genMaskCircle):
    num=1
    out=""
    innerDegrees=360/innerBlockers
    outerDegrees=360/outerBlockers
    outerOffset=360/outerBlockers/2
    for i in range(0,innerBlockers):
        out += "(pad " + str(1) + " thru_hole circle (at " + str(distanceIn*math.sin(math.radians(i*innerDegrees))) + " " + str(distanceIn*math.cos(math.radians(i*innerDegrees))) + ") (size 0.6 0.6) (drill 0.3) (layers *.Cu ))\n"
        num+=1
    

    for i in range(0,outerBlockers):
        out += "(pad " + str(2) + " thru_hole circle (at " + str(distanceOut*math.sin(math.radians(i*outerDegrees+outerOffset))) + " " + str(distanceOut*math.cos(math.radians(i*outerDegrees+outerOffset))) + ") (size 0.6 0.6) (drill 0.3) (layers *.Cu))\n"
        num=num+1
    if (genMaskCircle):
        out +=   "(fp_poly (pts "
        for i in range(0,innerBlockers):
            out += "(xy " + str(distanceIn*math.sin(math.radians(i*innerDegrees))) + " " + str(distanceIn*math.cos(math.radians(i*innerDegrees))) + ") "
        out += ") (layer F.Mask) (width 0.1))\r\n"

    return out 

def partString(letter, innerBlockers, outerBlockers, letterLayer, genMaskCircle):
    out=""
    out += """(module N_Indicator (layer F.Cu) (tedit 5CB8EF7D)
  (fp_text reference REF** (at -6.3 3.5) (layer F.SilkS)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  (fp_text value N_Indicator (at -6.3 2.5) (layer F.Fab)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  (fp_text user """ + letter + """ (at -0.1 -0.1) (layer """ + letterLayer + """)
    (effects (font (size 4 3) (thickness 0.5)))
  )

  """
    out += viaString(innerBlockers, outerBlockers, genMaskCircle)
    out +=")\n"
    return out


parts = [
        ["N", 17,17,"F.SilkS", "4040", True],
        ["N", 17,17,"F.Cu", "4040", True],
        ["N", 17,17,"F.Mask", "4040", False],
        ["N", 14,14,"F.SilkS", "3030", True],
        ["N", 14,14,"F.Cu", "3030", True],
        ["N", 14,14,"F.Mask", "3030", False],
        ["N", 10,10,"F.SilkS", "2020", True],
        ["N", 10,10,"F.Cu", "2020", True],
        ["N", 10,10,"F.Mask", "2020", False],
        ]
for part in parts:
    f=open(part[0]+part[4]+part[3]+".kicad_mod","w+")
    f.write(partString(part[0],part[1], part[2], part[3], part[5]))
    f.close()
    
