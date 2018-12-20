#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


# Read the mesh
mesh=code_aster.Mesh()
mesh.readMedFile("zzzz395a.mmed")

# Thermic model
model=AFFE_MODELE(MAILLAGE=mesh,
                 AFFE=_F(TOUT='OUI',
                         PHENOMENE='THERMIQUE',
                         MODELISATION='3D',),);

base_p=LIRE_RESU(TYPE_RESU  = 'MODE_EMPI',
                 FORMAT     = 'MED',
                 MODELE     = model,
                 UNITE      = 70,
                 FORMAT_MED =_F(NOM_CHAM_MED = 'base_p__TEMP',
                                NOM_CHAM     = 'TEMP',),
                 TOUT_ORDRE = 'OUI',);


base_d=LIRE_RESU(TYPE_RESU  = 'MODE_EMPI',
                 FORMAT     = 'MED',
                 MODELE     = model,
                 UNITE      = 71,
                 FORMAT_MED = _F(NOM_CHAM_MED = 'base_d__FLUX_NOEU',
                                 NOM_CHAM     = 'FLUX_NOEU',),
                 TOUT_ORDRE = 'OUI',);

TEST_RESU(MAILLAGE = _F(MAILLAGE    = mesh,
                        CARA        = 'NB_GROUP_MA',
                        REFERENCE   = 'ANALYTIQUE',
                        CRITERE     = 'ABSOLU',
                        VALE_REFE_I = 2,
                        VALE_CALC_I = 2,)
          )

mesh=DEFI_DOMAINE_REDUIT(reuse=mesh,INFO=2,
            MAILLAGE=mesh,
            BASE_PRIMAL=base_p,
            BASE_DUAL=base_d,
            NOM_DOMAINE='RID',
            GROUP_NO_INTERF='INF',);

# # IMPR_RESU(FORMAT='MED', UNITE = 80, RESU=_F(MAILLAGE = mesh))

TEST_RESU(MAILLAGE = _F(MAILLAGE    = mesh,
                        CARA        = 'NB_GROUP_MA',
                        REFERENCE   = 'ANALYTIQUE',
                        CRITERE     = 'ABSOLU',
                        VALE_REFE_I = 3,
                        VALE_CALC_I = 3)
          )

TEST_RESU(MAILLAGE = _F(MAILLAGE    = mesh,
                        CARA        = 'NB_GROUP_NO',
                        REFERENCE   = 'ANALYTIQUE',
                        CRITERE     = 'ABSOLU',
                        VALE_REFE_I = 1,
                        VALE_CALC_I = 1,)
          )

TEST_RESU(MAILLAGE = _F(MAILLAGE    = mesh,
                        CARA        = 'NB_MA_GROUP_MA',
                        NOM_GROUP_MA= 'RID',
                        REFERENCE   = 'ANALYTIQUE',
                        CRITERE     = 'ABSOLU',
                        VALE_REFE_I = 65,
                        VALE_CALC_I = 65,)
          )

TEST_RESU(MAILLAGE = _F(MAILLAGE    = mesh,
                        CARA        = 'NB_NO_GROUP_NO',
                        NOM_GROUP_NO= 'INF',
                        REFERENCE   = 'ANALYTIQUE',
                        CRITERE     = 'ABSOLU',
                        VALE_REFE_I = 26,
                        VALE_CALC_I = 26,)
          )


test.assertEqual(mesh.getType(), "MAILLAGE_SDASTER")

test.printSummary()

FIN()
