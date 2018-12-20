#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# tps_job 480 mem_job 32Mo ncpus 1 liste_test S
import math
MPa = 1.e6
#-----------------------------------------------
# PARAMETRES DU CALCUL
#-----------------------------------------------  
## BETON
# epaisseur de la plaque
ep_beton = 0.50
# largeur de la plaque
lg_beton = 0.2
# module de Young  beton
E_beton = 37272*MPa
# coefficient de poisson  beton
Nu_beton = 0.2
# masse volumique beton
Rho_beton =2400.0
# contrainte limite de traction
ft =3.9*MPa
# pente post-pic en traction
DE_beton = -E_beton
# contrainte limite en compressio
fc = -38.3*MPa

## ACIER moyenne
# section acier longitudinal inf (mm2) par barres
section_acier_haut = math.pi*(8e-3*0.5)**2
# section acier longitudinal sup (mm2) par barres
section_acier_bas = math.pi*(32.E-3*0.5)**2
# section acier lonigitudinal inf (mm2/m)
section_acier = (section_acier_haut+section_acier_bas)/lg_beton
# excentrement des aciers
excentr = ep_beton*0.5-0.032
# module de Young acier
E_acier = 200000*MPa
# coefficient de Poisson acier
Nu_acier = 0.0
# limite elastique acier
sy_acier = 400*MPa
# module d'ecrouissage acier
Dsde_acier = 3280*MPa 
# masse volumique acier
Rho_acier = 7800.0

###


#-----------------------------------------------
# DEFINTION DES MATERIAUX 
#-----------------------------------------------    
BETON=DEFI_MATERIAU(ELAS=_F(E=E_beton,
                            NU=Nu_beton,
                            RHO=Rho_beton,),
                    BETON_ECRO_LINE=_F(D_SIGM_EPSI=(DE_beton),
                                       SYT=ft,
                                       SYC=-fc,),);

ACIER=DEFI_MATERIAU(ELAS=_F(E=E_acier,
                            NU=Nu_acier,
                            RHO=Rho_acier,),
                    ECRO_LINE=_F(D_SIGM_EPSI=Dsde_acier,
                                 SY=sy_acier,),);
 
MAT_T=DEFI_GLRC(RELATION='GLRC_DM',
                BETON=_F(MATER=BETON,
                         EPAIS=ep_beton),
                NAPPE=_F(MATER=ACIER,
                         OMX=section_acier,
                         OMY=section_acier,
                         RX=excentr/ep_beton*2,
                         RY=excentr/ep_beton*2,),
                INFO=2,);

test.assertEqual(MAT_T.getType(), "MATER_SDASTER")

test.printSummary()

FIN()
