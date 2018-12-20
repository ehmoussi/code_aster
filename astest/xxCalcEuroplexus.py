import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAILLAGE = code_aster.Mesh()
MAILLAGE.readAsterMeshFile("plexu03a.mail")

MODELE=AFFE_MODELE(
                 MAILLAGE=MAILLAGE,AFFE=(
                     _F(  GROUP_MA = 'GROUPE__CABLE001',
                            PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'BARRE')
                            ) )

CARAELEM=AFFE_CARA_ELEM(
                      MODELE=MODELE,
                       BARRE=_F(  GROUP_MA = 'GROUPE__CABLE001',
                               SECTION = 'GENERALE',
                               CARA = ( 'A', ),
                               VALE = ( 1.5E-4, ))
                               )


ACIER = DEFI_MATERIAU(ELAS=_F(
                    E = 200000*1000000.0,
                    NU = 0.3,
                    RHO = 7500.,
                   ),
                  );

CHMATER=AFFE_MATERIAU(
                   MAILLAGE=MAILLAGE,AFFE=(
                       _F(  GROUP_MA = 'GROUPE__CABLE001',
                              MATER = ACIER)
                              )
                              )

BLOQ=AFFE_CHAR_MECA(
            MODELE=MODELE,
            DDL_IMPO=(
                      _F(GROUP_MA='GROUPE__CABLE001',
                         DY = 0.,DZ = 0.,),
                      _F(GROUP_NO='GRNC1',
                         DX = 0.,),
                      ),
            INFO=1 )

TRAC=AFFE_CHAR_MECA(
            MODELE=MODELE,
            DDL_IMPO=(
                      _F(GROUP_NO='GRNC2',
                         DX = 0.025,),
                      _F(GROUP_NO='GRNC3',
                         DX = 0.05,),
                      _F(GROUP_NO='GRNC4',
                         DX = 0.075,),
                      _F(GROUP_NO='GRNC5',
                         DX = 0.1,),
                      ),
            INFO=1 )

FONCCB=DEFI_FONCTION(NOM_PARA='INST',
                     VALE=(0.0,    0,
                           2e-3,  1.0,
                           3e-3,  1.0,
                           ),
                     PROL_DROITE='CONSTANT',
                     PROL_GAUCHE='CONSTANT',
                     );


#U = CALC_EUROPLEXUS(
   #MODELE=MODELE,
   #CHAM_MATER=CHMATER,
   #COMPORTEMENT =(_F(
                  #RELATION = 'ELAS',
                  #GROUP_MA = ('GROUPE__CABLE001',),
                 #),
              #),
   #CARA_ELEM=CARAELEM,
   #EXCIT=(_F(CHARGE=BLOQ,),
          #_F(CHARGE=TRAC,FONC_MULT=FONCCB,),
         #),
   #LANCEMENT ='OUI',
   #CALCUL = _F(TYPE_DISCRETISATION  ='UTIL',
               #INST_INIT = 0,
               #INST_FIN  = 2e-3,
               #NMAX      = 100,
               #PASFIX    = 2e-5,
               #),
   #ARCHIVAGE   = _F(PAS_NBRE=10,),
   #);

test.assertTrue( True )

test.printSummary()

FIN()
