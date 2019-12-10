# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()
MESH=code_aster.Mesh()
MESH.readMedFile("sslv113c.mmed")

MO=AFFE_MODELE(MAILLAGE=MESH,

               AFFE=_F(TOUT='OUI',
                       PHENOMENE='MECANIQUE',
                       MODELISATION='AXIS',),);

MESH=MODI_MAILLAGE(reuse =MESH,
                   MAILLAGE=MESH,
                   ORIE_PEAU_2D=_F(GROUP_MA=('GRMA1','GRMA2','GRMA3','GRMA4',),),);

##IMPR_RESU(FORMAT="RESULTAT",
##FORMAT='MED',
##
##RESU=_F(MAILLAGE=MESH,),
##);

MA1=DEFI_MATERIAU(ELAS=_F(E=2.0,
                          NU=0.3,
                          ALPHA=0.0,),);

MA2=DEFI_MATERIAU(ELAS=_F(E=1.0,
                          NU=0.3,
                          ALPHA=0.0,),);

CM=AFFE_MATERIAU(MAILLAGE=MESH,
                 AFFE=(_F(GROUP_MA='DOM1',
                          MATER=MA1,),
                       _F(GROUP_MA='DOM2',
                          MATER=MA2,),),);

#-----------------------------------------------------------------------
#
#  RESOLUTION DU PROBLEME PRIMAL
#    =>ASSEMBLAGE DE L(.)
#    =>ASSEMBLAGE DE A(.,.)
#    =>RESOLUTION
#    =>CALCUL DE L'ESTIMATEUR EN RESIDU POUR LE PRIMAL
#
#-----------------------------------------------------------------------

CHARPRIM=AFFE_CHAR_MECA(MODELE=MO,
                        FACE_IMPO=(_F(GROUP_MA='GRMA1',
                                      DY=0.0,),
                                   _F(GROUP_MA='GRMA2',
                                      DY=0.91333,),),
                        FORCE_CONTOUR=(_F(GROUP_MA='GRMA3',
                                          FX=1.0,),
                                       _F(GROUP_MA='GRMA4',
                                          FX=-2.0,),),);

RESUPRIM=MECA_STATIQUE(MODELE=MO,
                       CHAM_MATER=CM,
                       EXCIT=_F(CHARGE=CHARPRIM,),);

RESUPRIM=CALC_ERREUR(reuse =RESUPRIM,
                   RESULTAT=RESUPRIM,
                   TOUT_ORDRE='OUI',
                   OPTION='ERME_ELEM',);

# #-----------------------------------------------------------------------
# #
# #  RESOLUTION DU PROBLEME DUAL
# #    =>ASSEMBLAGE DE Q(.)
# #    =>ASSEMBLAGE DE A(.,.)
# #    =>RESOLUTION
# #    =>CALCUL DE L'ESTIMATEUR EN RESIDU POUR LE DUAL
# #
# #-----------------------------------------------------------------------

# CHARDUAL=AFFE_CHAR_MECA(MODELE=MO,
#                         FACE_IMPO=(_F(GROUP_MA='GRMA1',
#                                       DY=0.0,),
#                                    _F(GROUP_MA='GRMA2',
#                                       DY=0.91333,),),
#                         FORCE_CONTOUR=(_F(GROUP_MA='GRMA3',
#                                           FX=0.0,),
#                                        _F(GROUP_MA='GRMA4',
#                                           FX=0.0,),),
#                         PRE_EPSI =_F(TOUT='OUI',
#                                      EPXX=1.0,),);

# RESUDUAL=MECA_STATIQUE(MODELE=MO,
#                        CHAM_MATER=CM,
#                        EXCIT=_F(CHARGE=CHARDUAL,),);

# RESUDUAL=CALC_ERREUR(reuse =RESUDUAL,
#                    RESULTAT=RESUDUAL,
#                    TOUT_ORDRE='OUI',
#                    OPTION='ERME_ELEM',);

# #-----------------------------------------------------------------------
# #
# #  CALCUL DE L'ESTIMATEUR D'ERREUR EN QUANTITE D'INTERET
# #
# #-----------------------------------------------------------------------

# RESUPRIM=CALC_ERREUR(reuse =RESUPRIM,
#                    RESULTAT=RESUPRIM,
#                    OPTION=('QIRE_ELEM','QIRE_ELNO',),
#                    RESU_DUAL=RESUDUAL,);

#-----------------------------------------------------------------------
#
#  TESTS DE NON REGRESSION
#
#-----------------------------------------------------------------------

TEST_RESU(RESU=_F(NUME_ORDRE=1,
                  POINT=1,
                  RESULTAT=RESUPRIM,
                  NOM_CHAM='ERME_ELEM',
                  NOM_CMP='ERREST',
                  VALE_CALC=0.015854340000000001,

                  CRITERE='RELATIF',
                  MAILLE='M1',),
          )


test.assertEqual(RESUPRIM.getType(), "EVOL_ELAS")

test.printSummary()

FIN()
