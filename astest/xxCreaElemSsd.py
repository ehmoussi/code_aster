import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA_BRAS = code_aster.Mesh()
MA_BRAS.readMedFile("sdls129a.20")

MA_CENTR = code_aster.Mesh()
MA_CENTR.readMedFile("sdls129a.22")

MO_BRAS=AFFE_MODELE(MAILLAGE=MA_BRAS,
                    AFFE=_F(GROUP_MA='bras',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DKT',),);

MO_CENTR=AFFE_MODELE(MAILLAGE=MA_CENTR,
                     AFFE=_F(GROUP_MA='centre',
                             PHENOMENE='MECANIQUE',
                             MODELISATION='DKT',),);

                             
ACIER=DEFI_MATERIAU(ELAS=_F(E=2.1e11,
                            NU=0.3,
                            RHO=7800.,),);

CH_BRAS=AFFE_MATERIAU(MODELE=MO_BRAS,
                      MAILLAGE=MA_BRAS,
                      AFFE=_F(GROUP_MA='bras',
                              MATER=ACIER,),);

CH_CENTR=AFFE_MATERIAU(MODELE=MO_CENTR,
                       MAILLAGE=MA_CENTR,
                       AFFE=_F(GROUP_MA='centre',
                               MATER=ACIER,),);

CA_BRAS=AFFE_CARA_ELEM(MODELE=MO_BRAS,
                       COQUE=_F(GROUP_MA='bras',
                                EPAIS=0.005,),);

CA_CENTR=AFFE_CARA_ELEM(MODELE=MO_CENTR,
                        COQUE=_F(GROUP_MA='centre',
                                 EPAIS=0.005,),);

CL_BRAS=AFFE_CHAR_MECA(MODELE=MO_BRAS,
                       DDL_IMPO=(_F(GROUP_NO=('intf',),
                                    DX=0.,
                                    DY=0.,
                                    DZ=0.,
                                    DRX=0.,
                                    DRY=0.,
                                    DRZ=0.,
                                   ),
                                 _F(GROUP_NO=('CL',),
                                    DX=0.,
                                    DY=0.,
                                    DZ=0.,
                                    DRX=0.,
                                    DRY=0.,
                                    DRZ=0.,),  
                                   ),);

CL_CENTR=AFFE_CHAR_MECA(MODELE=MO_CENTR,
                        DDL_IMPO=_F(GROUP_NO=('intf_px','intf_py','intf_my',),
                                    DX=0.,
                                    DY=0.,
                                    DZ=0.,
                                    DRX=0.,
                                    DRY=0.,
                                    DRZ=0.,
                                    ),);

BRAS=CREA_ELEM_SSD(MODELE=MO_BRAS,
                   CHAM_MATER=CH_BRAS,
                   CARA_ELEM=CA_BRAS,
                   NUME_DDL=CO('NU_BRAS'),
                   CHARGE=CL_BRAS,
                   INTERFACE=_F(NOM='INT_BR',
                                TYPE='CRAIGB',
                                GROUP_NO='intf',),
                   CALC_FREQ=_F(NMAX_FREQ=10,
                                  APPROCHE='REEL',
                                  STOP_ERREUR='OUI',
                                  OPTION='PLUS_PETITE',),             
                   BASE_MODALE=_F(TYPE='CLASSIQUE',),
                   );

test.assertTrue( True )

FIN()
