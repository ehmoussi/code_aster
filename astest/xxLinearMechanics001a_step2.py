# coding: utf-8

import code_aster
from code_aster.Commands import *

POURSUITE()

resu=CALC_CHAMP(reuse=resu,
                RESULTAT=resu,TOUT_ORDRE='OUI',
                CONTRAINTE=('SIGM_NOEU'),
                )

FIN()
