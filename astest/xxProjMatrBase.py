import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readAsterMeshFile("sdld107a.mail")

MAILLA=CREA_MAILLAGE(MAILLAGE=MA,
    CREA_POI1=(
        _F(NOM_GROUP_MA='MASSE',   GROUP_NO='MASSE', ),
    ),
)

MODNUM=AFFE_MODELE(MAILLAGE=MAILLA,
                   AFFE=(_F(GROUP_MA='RESSORT',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DIS_T',),
                         _F(GROUP_MA='MASSE',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DIS_T',),),);

CARE=AFFE_CARA_ELEM(MODELE=MODNUM,
                     DISCRET=(_F(CARA='K_T_D_L',
                                 GROUP_MA='RESSORT',
                                 VALE=(1.,0.,0.,),),
                               _F(CARA='M_T_D_L',
                                  GROUP_MA='RESSORT',
                                  VALE = (0.,),),
                              _F(CARA='M_T_D_N',
                                 GROUP_MA='MASSE',
                                 VALE=1.,),),);

CHARGE_L=AFFE_CHAR_MECA(MODELE=MODNUM,
                        DDL_IMPO=(_F(TOUT='OUI',
                                     DY=0.,
                                     DZ=0.,),
                                  _F(NOEUD='NO1',
                                     DX=0.,),
                                  _F(NOEUD='NO5',
                                     DX=0.,),),);

ASSEMBLAGE(MODELE=MODNUM,
           CARA_ELEM=CARE,
           CHARGE=CHARGE_L,
           NUME_DDL=CO("NU"),
           MATR_ASSE=(_F(  MATRICE = CO("K"),  OPTION = 'RIGI_MECA'),
                      _F(  MATRICE = CO("M"),  OPTION = 'MASS_MECA'),),
           );

CHAR_G=AFFE_CHAR_MECA(MODELE=MODNUM,DDL_IMPO=(_F(  GROUP_NO = 'OBSPOINT',  DX=0.  ),),);

ASSEMBLAGE(MODELE=MODNUM,
           CARA_ELEM=CARE,
           CHARGE=(CHAR_G,CHARGE_L),
           NUME_DDL=CO("NU_G"),
           MATR_ASSE=(_F(  MATRICE = CO("K1"),  OPTION = 'RIGI_MECA'),
                      _F(  MATRICE = CO("M1"),  OPTION = 'MASS_MECA'),),
           );

MOD_STA=MODE_STATIQUE(MATR_RIGI=K1,
                      MATR_MASS=M1,
                      MODE_STAT=(_F(GROUP_NO='OBSPOINT',
                                    AVEC_CMP=('DX',),),),);

NUME_RED=NUME_DDL_GENE(BASE=MOD_STA,STOCKAGE='PLEIN');

MA_RE=PROJ_MATR_BASE(BASE=MOD_STA,NUME_DDL_GENE=NUME_RED,MATR_ASSE=M);

test.assertTrue( True )

FIN()
