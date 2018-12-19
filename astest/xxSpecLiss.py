#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


# Validation de LISS_SPECTRE/OPTION='CONCEPTION'


def adapte_fic_nappe(adr_fic, unite):
    """
    Met en forme les données d'une nappe issue de IMPR_FONTION, afin
    d'être relu correctement par LIRE_FONCTION
    """
    fic= open(adr_fic,"r")
    lines = fic.readlines()
    fic.close()
    fic= open('fort.%s'%unite,"w")
    
    print 'AMOR\n'
    for line in lines:
        if 'Courbe' in line:
            pass
        elif 'AMOR=' in line:
            ll=line.split('AMOR=')
            fic.write(ll[1])
        else:
            fic.write(line)
    fic.close()


spectre=LIRE_FONCTION(TYPE='NAPPE',
                      INDIC_PARA=(1,1,),
                      NOM_PARA_FONC='FREQ',
                      INDIC_ABSCISSE=(2,1,),
                      INTERPOL_FONC='LOG',
                      PROL_DROITE_FONC='CONSTANT',
                      PROL_GAUCHE_FONC='CONSTANT',
                      DEFI_FONCTION=(_F(INDIC_RESU=(2,2,),),
                                     _F(INDIC_RESU=(2,3,),),
                                     _F(INDIC_RESU=(2,4,),),
                                     _F(INDIC_RESU=(2,5,),),
                                     _F(INDIC_RESU=(2,6,),),
                                     _F(INDIC_RESU=(2,7,),),
                                     _F(INDIC_RESU=(2,8,),),
                                     _F(INDIC_RESU=(2,9,),),
                                     ),
                      UNITE=18,
                      NOM_PARA='AMOR',
                      NOM_RESU='ACCE',
                      INTERPOL='LOG',
                      PROL_DROITE='CONSTANT',
                      PROL_GAUCHE='CONSTANT',
                      TITRE='essai de lecture de spectre',)

spectre2=LIRE_FONCTION(TYPE='NAPPE',
                      INDIC_PARA=(1,1,),
                      NOM_PARA_FONC='FREQ',
                      INDIC_ABSCISSE=(2,1,),
                      INTERPOL_FONC='LOG',
                      PROL_DROITE_FONC='CONSTANT',
                      PROL_GAUCHE_FONC='CONSTANT',
                      DEFI_FONCTION=(_F(INDIC_RESU=(2,2,),),
                                     _F(INDIC_RESU=(2,3,),),
                                     _F(INDIC_RESU=(2,4,),),
                                     _F(INDIC_RESU=(2,5,),),
                                     _F(INDIC_RESU=(2,6,),),
                                     _F(INDIC_RESU=(2,7,),),
                                     _F(INDIC_RESU=(2,8,),),
                                     _F(INDIC_RESU=(2,9,),),
                                     ),
                      UNITE=37,
                      NOM_PARA='AMOR',
                      NOM_RESU='ACCE',
                      INTERPOL='LOG',
                      PROL_DROITE='CONSTANT',
                      PROL_GAUCHE='CONSTANT',
                      TITRE='essai de lecture de spectre',)



# Validation de NAPPE 
#####################

# mots-clés NB_FREQ_LISS, FREQ_MIN, FREQ_MAX, ZPA

# reférence : deux spectres
refcon=CALC_FONCTION(LISS_ENVELOP=_F(NAPPE=(spectre,spectre2),
                                  OPTION = 'CONCEPTION',
                                  NB_FREQ_LISS = 50,
                                  FREQ_MIN = 0.5,
                                  FREQ_MAX = 35.5,
                                  ZPA   = 2.25793
                                  ),
                                  NOM_PARA='AMOR',
                                  NOM_RESU='ACCE',
                                  NOM_PARA_FONC='FREQ',) 


TEST_FONCTION(VALEUR=(_F(VALE_CALC=0.14547896587493,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.005, 0.505),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon,
                         ),
                      _F(VALE_CALC= 2.303422103133 ,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.02, 3.50270E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon,
                         ),
                      _F(VALE_CALC=1.828400125991,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.04, 2.12500E+00),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon,
                         ),
                       _F(VALE_CALC=5.777960568348,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.05, 1.46850E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon,
                         ),
                       )
)                         

# test pour les nappes '_verif'

refcon2=CALC_FONCTION(LISS_ENVELOP=_F(NAPPE=(spectre,spectre2),
                                  OPTION = 'CONCEPTION',
                                  NB_FREQ_LISS = 624,
                                  FREQ_MIN = 0.5,
                                  FREQ_MAX = 35.5,
                                  ZPA   = 2.25793
                                  ),
                                  NOM_PARA='AMOR',
                                  NOM_RESU='ACCE',
                                  NOM_PARA_FONC='FREQ',) 


TEST_FONCTION(VALEUR=(_F(VALE_CALC=0.14326800000000,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.005, 0.505),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon2,
                         ),
                      _F(VALE_CALC= 2.293118742702 ,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.02, 3.50270E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon2,
                         ),
                      _F(VALE_CALC=1.808750000000,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.04, 2.12500E+00),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon2,
                         ),
                       _F(VALE_CALC=5.684006259129,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.05, 1.46850E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=refcon2,
                         ),
                       )
)                         




LISS_SPECTRE(SPECTRE=(_F(NAPPE=spectre, NOM='ETAGE', BATIMENT='BATIMENT', 
                         COMMENTAIRE='PRECISIONS', DIRECTION = 'X',),
                      _F(NAPPE=spectre2, NOM='ETAGE', BATIMENT='BATIMENT', 
                         COMMENTAIRE='PRECISIONS', DIRECTION = 'X',),), 
             OPTION = 'CONCEPTION',
             NB_FREQ_LISS = 50,
             FREQ_MIN = 0.5,
             FREQ_MAX = 35.5,
             ZPA   = 2.25793,
             BORNE_X=(0.1,100),
             BORNE_Y=(0.01,100),
             ECHELLE_X = 'LOG',
             ECHELLE_Y = 'LOG',
             LEGENDE_X = 'Frequence (Hz)',
             LEGENDE_Y = 'Pseudo-acceleration (g)',)

adapte_fic_nappe('./REPE_OUT/BATIMENT_ETAGE_X.txt',86)


NAPLIS=LIRE_FONCTION(TYPE='NAPPE',
                      INDIC_PARA=(1,1,),
                      NOM_PARA_FONC='FREQ',
                      INDIC_ABSCISSE=(2,1,),
                      INTERPOL_FONC='LOG',
                      PROL_DROITE_FONC='CONSTANT',
                      PROL_GAUCHE_FONC='CONSTANT',
                      DEFI_FONCTION=(_F(INDIC_RESU=(2,2,),),
                                     _F(INDIC_RESU=(2,3,),),
                                     _F(INDIC_RESU=(2,4,),),
                                     _F(INDIC_RESU=(2,5,),),
                                     _F(INDIC_RESU=(2,6,),),
                                     _F(INDIC_RESU=(2,7,),),
                                     _F(INDIC_RESU=(2,8,),),
                                     _F(INDIC_RESU=(2,9,),),
                                     ),
                      UNITE=86,
                      NOM_PARA='AMOR',
                      NOM_RESU='ACCE',
                      INTERPOL='LOG',
                      PROL_DROITE='CONSTANT',
                      PROL_GAUCHE='CONSTANT',
                      TITRE='essai de lecture de spectre',)


# Comparaison à refcon (ref AUTRE_ASTER), le manque de précision est du
# à l'écriture/relecture du ficher

TEST_FONCTION(VALEUR=(_F(VALE_CALC=0.14547916410928,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.005, 0.505),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS,
                         VALE_REFE=0.14547896587493,
                         REFERENCE='AUTRE_ASTER',
                         ),
                      _F(VALE_CALC= 2.303420000000 ,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.02, 3.50270E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS,
                         VALE_REFE= 2.303422103133 ,
                         REFERENCE='AUTRE_ASTER',
                         ),
                      _F(VALE_CALC=1.828400000000,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.04, 2.12500E+00),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS,
                         VALE_REFE=1.828400125991,
                         REFERENCE='AUTRE_ASTER',
                         ),
                       _F(VALE_CALC=5.777959923999,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.05, 1.46850E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS,
                         VALE_REFE=5.777960568348,
                         REFERENCE='AUTRE_ASTER',
                         ),
                       )
)                         


adapte_fic_nappe('./REPE_OUT/BATIMENT_ETAGE_X_verif.txt',86)


NAPVER=LIRE_FONCTION(TYPE='NAPPE',
                      INDIC_PARA=(1,1,),
                      NOM_PARA_FONC='FREQ',
                      INDIC_ABSCISSE=(2,1,),
                      INTERPOL_FONC='LOG',
                      PROL_DROITE_FONC='CONSTANT',
                      PROL_GAUCHE_FONC='CONSTANT',
                      DEFI_FONCTION=(_F(INDIC_RESU=(2,2,),),
                                     _F(INDIC_RESU=(2,3,),),
                                     _F(INDIC_RESU=(2,4,),),
                                     _F(INDIC_RESU=(2,5,),),
                                     _F(INDIC_RESU=(2,6,),),
                                     _F(INDIC_RESU=(2,7,),),
                                     _F(INDIC_RESU=(2,8,),),
                                     _F(INDIC_RESU=(2,9,),),
                                     ),
                      UNITE=86,
                      NOM_PARA='AMOR',
                      NOM_RESU='ACCE',
                      INTERPOL='LOG',
                      PROL_DROITE='CONSTANT',
                      PROL_GAUCHE='CONSTANT',
                      TITRE='essai de lecture de spectre',)


TEST_FONCTION(VALEUR=(_F(VALE_CALC=0.14326800000000,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.005, 0.505),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPVER,
                         VALE_REFE=0.14326800000000,
                         REFERENCE='AUTRE_ASTER',
                         ),
                      _F(VALE_CALC= 2.293120000000 ,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.02, 3.50270E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPVER,
                         VALE_REFE= 2.293118742702 ,
                         REFERENCE='AUTRE_ASTER',
                         ),
                      _F(VALE_CALC=1.808750000000,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.04, 2.12500E+00),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPVER,
                         VALE_REFE=1.808750000000,
                         REFERENCE='AUTRE_ASTER',
                         ),
                       _F(VALE_CALC=5.684010000000 ,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.05, 1.46850E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPVER,
                         VALE_REFE=5.684006259129,
                         REFERENCE='AUTRE_ASTER',
                         ),
                       )
)


                    
# Validation de TABLE
#####################


# TABSPEC doit être égale à la nappe spectre après transformation par LISS_SPECTRE
# TABSPEC2 doit être égale à la nappe spectre2 après transformation par LISS_SPECTRE
TABSPEC = LIRE_TABLE(UNITE=38, FORMAT='ASTER', NUME_TABLE=1)
TABSPEC2 = LIRE_TABLE(UNITE=39, FORMAT='ASTER', NUME_TABLE=1)

LISS_SPECTRE(SPECTRE=(_F(TABLE=TABSPEC,),
                      _F(TABLE=TABSPEC2,),), 
             OPTION = 'CONCEPTION',
             NB_FREQ_LISS = 50,
             FREQ_MIN = 0.5,
             FREQ_MAX = 35.5,
             ZPA   = 2.25793,
             BORNE_X=(0.1,100),
             BORNE_Y=(0.01,100),
             ECHELLE_X = 'LOG',
             ECHELLE_Y = 'LOG',
             LEGENDE_X = 'Frequence (Hz)',
             LEGENDE_Y = 'Pseudo-acceleration (g)',)

adapte_fic_nappe('./REPE_OUT/BATI_P_1_H.txt',86)


NAPLIS2=LIRE_FONCTION(TYPE='NAPPE',
                      INDIC_PARA=(1,1,),
                      NOM_PARA_FONC='FREQ',
                      INDIC_ABSCISSE=(2,1,),
                      INTERPOL_FONC='LOG',
                      PROL_DROITE_FONC='CONSTANT',
                      PROL_GAUCHE_FONC='CONSTANT',
                      DEFI_FONCTION=(_F(INDIC_RESU=(2,2,),),
                                     _F(INDIC_RESU=(2,3,),),
                                     _F(INDIC_RESU=(2,4,),),
                                     _F(INDIC_RESU=(2,5,),),
                                     _F(INDIC_RESU=(2,6,),),
                                     _F(INDIC_RESU=(2,7,),),
                                     _F(INDIC_RESU=(2,8,),),
                                     _F(INDIC_RESU=(2,9,),),
                                     ),
                      UNITE=86,
                      NOM_PARA='AMOR',
                      NOM_RESU='ACCE',
                      INTERPOL='LOG',
                      PROL_DROITE='CONSTANT',
                      PROL_GAUCHE='CONSTANT',
                      TITRE='essai de lecture de spectre',)


# Comparaison à refcon (ref AUTRE_ASTER), le manque de précision est du
# à l'écriture/relecture du ficher

TEST_FONCTION(VALEUR=(_F(VALE_CALC=0.14547916410928,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.005, 0.505),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS2,
                         VALE_REFE=0.14547896587493,
                         REFERENCE='AUTRE_ASTER',
                         ),
                      _F(VALE_CALC= 2.303420000000 ,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.02, 3.50270E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS2,
                         VALE_REFE= 2.303422103133 ,
                         REFERENCE='AUTRE_ASTER',
                         ),
                      _F(VALE_CALC=1.828400000000,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.04, 2.12500E+00),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS2,
                         VALE_REFE=1.828400125991,
                         REFERENCE='AUTRE_ASTER',
                         ),
                       _F(VALE_CALC=5.777959923999,
                         CRITERE='ABSOLU',
                         VALE_PARA=(0.05, 1.46850E+01),
                         NOM_PARA=('AMOR', 'FREQ'),
                         FONCTION=NAPLIS2,
                         VALE_REFE=5.777960568348,
                         REFERENCE='AUTRE_ASTER',
                         ),
                       )
)                        




test.printSummary()

FIN()
