# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

POUTRE = code_aster.Mesh()
POUTRE.readAsterMeshFile("sdll117a.mail")

POUTRE=MODI_MAILLAGE(MAILLAGE=POUTRE,ABSC_CURV=_F(NOEUD_ORIG='N001',TOUT='OUI'))

POUTRE=DEFI_GROUP( reuse=POUTRE,   MAILLAGE=POUTRE,
                   CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))

RHOE=DEFI_FONCTION(
                  NOM_PARA='ABSC',
                  ABSCISSE=(0.00000000000000E+00, 1.00000000000000E+00),
                  ORDONNEE=(1000., 1000.,),
                         )

RHOI=DEFI_FONCTION(
                  NOM_PARA='ABSC',
                  ABSCISSE=(0.00000000000000E+00, 1.00000000000000E+00),
                  ORDONNEE=(1000., 1000.,),
                         )

#
# FORCE FLUIDE ELASTIQUE
# ----------------------
# CALCUL AVEC UNE ZONE D EXCITATION DU FLUIDE
# -------------------------------------------
# VITESSE DU FLUIDE: 1 M/S SUR TOUTE LA ZONE
# ------------------------------------------
# CELLULE DE TUBES VIBRANTS EN DEBUT DE FAISCEAU VISCACHE1
# --------------------------------------------------------
#

PROFVI1=DEFI_FONC_FLUI(
                   MAILLAGE=POUTRE,
                 NOEUD_INIT='N001',
                  NOEUD_FIN='N200',
                       VITE=_F(
                               PROFIL = 'UNIFORME',
                               VALE = 1.0)
                           )

PROFVI7=DEFI_FONC_FLUI(
                   MAILLAGE=POUTRE,
                 NOEUD_INIT='N001',
                  NOEUD_FIN='N200',
                       VITE=_F(
                               PROFIL = 'UNIFORME',
                               VALE = 0.5)
                           )

MODELE=AFFE_MODELE(
                  MAILLAGE=POUTRE,
               AFFE=_F( TOUT = 'OUI', PHENOMENE = 'MECANIQUE',
                        MODELISATION = 'POU_D_T'))

CARA=AFFE_CARA_ELEM(  MODELE=MODELE,
                      POUTRE=_F(  GROUP_MA = 'TOUT',
                                  SECTION = 'CERCLE',
                                  CARA = ( 'R'     , 'EP'    ,),
                                  VALE = (9.525E-03, 1.09E-03,)))

TYPEFLU1=DEFI_FLUI_STRU(
                 FAISCEAU_TRANS=_F(
                 COUPLAGE = 'OUI',
                 CARA_ELEM = CARA,
                 PROF_RHO_F_INT = RHOI,
                 PROF_RHO_F_EXT = RHOE,
                 NOM_CMP = 'DX',
                 TYPE_PAS = 'CARRE_LIGN',
                 PAS = 1.5,
                 PROF_VITE_FLUI = PROFVI1,
                 TYPE_RESEAU = 1001)
                           )

SPECTR7=DEFI_SPEC_TURB(
                  SPEC_LONG_COR_3=_F(
                  LONG_COR = 3.4,
                  PROF_VITE_FLUI = PROFVI7)
                           )

# at least it pass here!
test.assertTrue( True )
test.printSummary()

FIN()
