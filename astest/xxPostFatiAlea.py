import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

LOIDOM1=DEFI_FONCTION(
         INTERPOL=('LOG', 'LOG',),
         NOM_PARA='SIGM',
         VALE=(
          1.,             3.125E+11,
          2.,        976562.5E+4,
          5.,             1.E+8,
         25.,         32000.,
         30.,         12860.09,
         35.,          5949.899,
         40.,          3051.76,
         45.,          1693.51,
         50.,          1000.0,
         55.,           620.921,
         60.,           401.8779,
         65.,           269.329,
         70.,           185.934,
         75.,           131.6869,
         80.,            95.3674,
         85.,            70.4296,
         90.,            52.9221,
         95.,            40.3861,
        100.,            31.25,
        105.,            24.4852,
        110.,            19.40379,
        115.,            15.5368,
        120.,            12.55869,
        125.,            10.23999,
        130.,             8.41653,
        135.,             6.96917,
        140.,             5.81045,
        145.,             4.8754,
        150.,             4.11523,
        155.,             3.49294,
        160.,             2.98023,
        165.,             2.55523,
        170.,             2.20093,
        175.,             1.90397,
        180.,             1.65382,
        185.,             1.44209,
        190.,             1.26207,
        195.,             1.10835,
        200.,             0.976562,
               ),
         PROL_GAUCHE='LINEAIRE',
         PROL_DROITE='LINEAIRE'
         )

#----------------------------------------------------------------------
MAT0=DEFI_MATERIAU(   FATIGUE=_F(  A_BASQUIN = 1.001730939E-14,
                                  BETA_BASQUIN = 4.065)  )

TAB1=POST_FATI_ALEA(    MOMENT_SPEC_0=182.5984664,
                          MOMENT_SPEC_2=96098024.76,
                               COMPTAGE='NIVEAU',
                                  DUREE=1.,
                                DOMMAGE='WOHLER',
                                  MATER=MAT0          )

test.assertTrue( True )

FIN()
