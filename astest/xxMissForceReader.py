#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAIL=LIRE_MAILLAGE(FORMAT='MED',);
MAIL=DEFI_GROUP(reuse =MAIL,
                MAILLAGE=MAIL,
                CREA_GROUP_MA=(_F(NOM='ST_B_ARM',
                                  UNION=
                                  ('SRADIER','TOP','FACELAT2',),),),);

MODELE=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=(_F(GROUP_MA=('ST_B_ARM'),
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DKT',),
                            _F(GROUP_MA=('RADIER'),
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DIS_TR',),),);
BETARM00=DEFI_MATERIAU(ELAS=_F(E=3.5000000000E10,
                               NU=0.20000000000000001,
                               RHO=1.E-3,
                               AMOR_ALPHA=4.95E-4,
                               AMOR_BETA=3.9100000000000001,),);

BETARM=DEFI_MATERIAU(ELAS=_F(E=3.5000000000E10,
                             NU=0.20000000000000001,
                             RHO=2500.0,
                             AMOR_ALPHA=4.95E-4,
                             AMOR_BETA=3.9100000000000001,),);

BETARML=DEFI_MATERIAU(ELAS=_F(E=3.5000000000E10,
                               NU=0.20000000000000001,
                               RHO=3000.,
                               AMOR_ALPHA=4.95E-4,
                               AMOR_BETA=3.9100000000000001,),);


BETARMXL=DEFI_MATERIAU(ELAS=_F(E=3.5000000000E10,
                               NU=0.20000000000000001,
                               RHO=6000.,
                               AMOR_ALPHA=4.95E-4,
                               AMOR_BETA=3.9100000000000001,),);


MATER=AFFE_MATERIAU(MAILLAGE=MAIL,
                    AFFE=(_F(GROUP_MA=('SRADIER'),
                             MATER=BETARM00,),
                          _F(GROUP_MA=('TOP'),
                             MATER=BETARMXL,),
                          _F(GROUP_MA=('FACELAT2'),
                             MATER=BETARMXL,),),);        

ELEM=AFFE_CARA_ELEM(MODELE=MODELE,
                    COQUE=(_F(GROUP_MA=('SRADIER'),
                              EPAIS=5.0,),
                           _F(GROUP_MA=('FACELAT2',),
                              EPAIS=1.3,),
                           _F(GROUP_MA=('TOP'),
                              EPAIS=2.5,),),
                     DISCRET=(
                             _F(GROUP_MA='RADIER', CARA='K_TR_D_N',
                                VALE=(0.,0.,0.,0.,0.,0.,),),
                             _F(GROUP_MA='RADIER', CARA='M_TR_D_N',
                                VALE=(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0),),
                                ),);

MATERB=AFFE_MATERIAU(MAILLAGE=MAIL,
                    AFFE=(_F(GROUP_MA=('SRADIER'),
                             MATER=BETARML,),
                          _F(GROUP_MA=('TOP'),
                             MATER=BETARM00,),
                          _F(GROUP_MA=('FACELAT2'),
                             MATER=BETARM00,),),);    

ELEMB=AFFE_CARA_ELEM(MODELE=MODELE,
                       RIGI_PARASOL=_F(VALE=(5.40000000000E11,5.40000000000E11,6.E11,6.50000000000000E14,6.50000000000000E14,1.090000000000000E15,),
                                       COEF_GROUP=1.0,
                                       CARA=('K_TR_D_N',),
                                       GROUP_MA='SRADIER',
                                       GROUP_MA_POI1='RADIER',
                                       GROUP_NO_CENTRE='PO'),
                       COQUE=(_F(COQUE_NCOU=1,
                                 COEF_RIGI_DRZ=1.0000000000000001E-05,
                                 MODI_METRIQUE='NON',
                                 GROUP_MA=('SRADIER',),
                                 EPAIS=5.0),
                           _F(GROUP_MA=('FACELAT2',),
                              EPAIS=1.3,),
                           _F(GROUP_MA=('TOP'),
                              EPAIS=2.5,),),
                       INFO=1,
                       );

MAIL=DEFI_GROUP(reuse =MAIL,
                MAILLAGE=MAIL,
                CREA_GROUP_NO=_F(GROUP_MA=('SRADIER'),),);

CH_CLDYN=AFFE_CHAR_MECA(MODELE=MODELE,
                        DDL_IMPO=_F(GROUP_NO=('SRADIER'),
                                    DX=0.0,
                                    DY=0.0,
                                    DZ=0.0,
                                    DRX=0.0,
                                    DRY=0.0,
                                    DRZ=0.0,),);

RIGIELEM=CALC_MATR_ELEM(OPTION='RIGI_MECA',
                        MODELE=MODELE,
                        CHARGE=CH_CLDYN,
                        CHAM_MATER=MATER,
                        CARA_ELEM = ELEM);

MASELEM=CALC_MATR_ELEM(OPTION='MASS_MECA',
                       MODELE=MODELE,
                       CHARGE=CH_CLDYN,
                        CHAM_MATER=MATER,
                       CARA_ELEM = ELEM);

NUM_DYN=NUME_DDL(MATR_RIGI=RIGIELEM);

MATMASS=ASSE_MATRICE(MATR_ELEM=MASELEM,
                     NUME_DDL=NUM_DYN,);

MATRIGI=ASSE_MATRICE(MATR_ELEM=RIGIELEM,
                     NUME_DDL=NUM_DYN,);
print "alors le type", MATRIGI.getType()
print "alors le type", MATMASS.getType()
MOD_DYN=CALC_MODES(MATR_RIGI=MATRIGI,SOLVEUR=_F(METHODE='MULT_FRONT'),
                   #FILTRE_MODE=_F(CRIT_EXTR='MASS_EFFE_UN',
                   #               SEUIL=1.E-3,),
                   #NORM_MODE=_F(INFO=1,
                   #                      NORME='TRAN_ROTA',),
                   CALC_FREQ=_F(NMAX_FREQ=3,
                                ),
                   MATR_MASS=MATMASS,
                   )



STARIELE=CALC_MATR_ELEM(OPTION='RIGI_MECA',
                        MODELE=MODELE,
                        CHAM_MATER=MATERB,
                        CARA_ELEM = ELEMB);

STAMAELE=CALC_MATR_ELEM(OPTION='MASS_MECA',
                        MODELE=MODELE,
                        CHAM_MATER=MATERB,
                        CARA_ELEM = ELEMB);

NUM_STA=NUME_DDL(MATR_RIGI=STARIELE);

MASSETAT=ASSE_MATRICE(MATR_ELEM=STAMAELE,
                      NUME_DDL=NUM_STA,);

RIGISTAT=ASSE_MATRICE(MATR_ELEM=STARIELE,
                      NUME_DDL=NUM_STA,);

MOD_STA=CALC_MODES(MATR_RIGI=RIGISTAT,SOLVEUR=_F(METHODE='MULT_FRONT'),
                   MATR_MASS=MASSETAT,
                   CALC_FREQ=_F(NMAX_FREQ=40,
                                ),
                   )


BASMO=DEFI_BASE_MODALE(RITZ=(_F(MODE_MECA=MOD_DYN,),
                             _F(NMAX_MODE=40,
                                MODE_INTF=MOD_STA,),),
                       NUME_REF=NUM_DYN,);



nddlgen = NUME_DDL_GENE( BASE= BASMO,
                          STOCKAGE= 'PLEIN',);


fosx0 = LIRE_FORC_MISS(BASE=BASMO,  NUME_DDL_GENE=nddlgen,
                       NOM_CMP='DX',NOM_CHAM='ACCE',
                       UNITE_RESU_FORC=28, FREQ_EXTR=0.,);

impe0 = LIRE_IMPE_MISS(BASE=BASMO,  NUME_DDL_GENE=nddlgen,
                       UNITE_RESU_IMPE=38, FREQ_EXTR=0.,);

test.assertEqual(fosx0.getType(), "VECT_ASSE_GENE")
test.assertEqual(impe0.getType(), "MATR_ASSE_GENE_C")



test.printSummary()

FIN()
