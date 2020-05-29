# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import aster

from ..Cata.Syntax import _F
from ..Commands import (CALC_CHAMP, CREA_CHAMP, CREA_RESU, FORMULE,
                        MODI_MAILLAGE)
from ..Messages import UTMESS, MasquerAlarme, RetablirAlarme


def calc_pression_ops(self, MAILLAGE, RESULTAT, GROUP_MA,
                      GEOMETRIE, CRITERE, PRECISION, **args):
    """
           Macro permettant le calcul des pressions aux interfaces d'un solide
           à partir du champ de contraintes sigma_n. Elle fonctionne
           uniquement pour les modèles massif. On exclut du périmètre d'utilisation
           les éléments de structures types discret, poutre, plaque, coques,...
    """

    typ_resu = RESULTAT.getType()
    insts = args.get("INST") or RESULTAT.LIST_VARI_ACCES()['INST']

    model = args.get('MODELE')
    if model == None:
        UTMESS('A', 'CALCPRESSION0_1')
        model = RESULTAT.getModel()

    # BLINDAGE : on poursuit le calcul uniquement que si le groupe n'a pas
    # d'élément de structure
    test_structure = aster.dismoi('EXI_RDM', model.getName(), 'MODELE', 'F')[-1]
    # si oui dans le modele, ensuite check toutes les mailles dans les group_ma
    if test_structure != 'NON':
        for grm in GROUP_MA:
            iret = aster.gmardm(grm, model.getName())
            if iret == 1:
                UTMESS('F', 'CALCPRESSION0_3')
    dim = MAILLAGE.getDimension()

    MasquerAlarme('CALCCHAMP_1')
    # Champ de contraintes de Cauchy aux noeuds
    RESULTAT = CALC_CHAMP(reuse=RESULTAT,
                        RESULTAT=RESULTAT,
                        PRECISION=PRECISION,
                        CRITERE=CRITERE,
                        CONTRAINTE='SIEF_NOEU',)
    RetablirAlarme('CALCCHAMP_1')

    # Pression à l'interface
    if dim == 3:
    # Formule en dimension 3 :
        __Pression = FORMULE(
            VALE='(SIXX*X*X+SIYY*Y*Y+SIZZ*Z*Z+2*SIXY*X*Y+2*SIXZ*X*Z+2*SIYZ*Y*Z)',
            NOM_PARA=('SIXX', 'SIYY', 'SIZZ', 'SIXY', 'SIXZ', 'SIYZ', 'X', 'Y', 'Z'),)
    else:
    # Formule en dimension 2 :
        __Pression = FORMULE(VALE='(SIXX*X*X+SIYY*Y*Y+2*SIXY*X*Y)',
                             NOM_PARA=('SIXX', 'SIYY', 'SIXY', 'X', 'Y'),)

    # Corps de la commande
    __chp = [None]*len(insts)
    for i, inst in enumerate(insts):
        __sigm = CREA_CHAMP(TYPE_CHAM='NOEU_SIEF_R',
                            OPERATION='EXTR',
                            RESULTAT=RESULTAT,
                            NOM_CHAM='SIEF_NOEU',
                            INST=inst,
                            PRECISION=PRECISION,
                            CRITERE=CRITERE,
                            )
        
        if  GEOMETRIE == 'DEFORMEE' :
            __depl = CREA_CHAMP(TYPE_CHAM='NOEU_DEPL_R',
                                OPERATION='EXTR',
                                RESULTAT=RESULTAT,
                                NOM_CHAM='DEPL',
                                INST=inst,
                                PRECISION=PRECISION,
                                CRITERE=CRITERE,
            )
            __mdepl = CREA_CHAMP(TYPE_CHAM='NOEU_DEPL_R',
                                 OPERATION='COMB',
                                 COMB=_F(CHAM_GD=__depl,
                                         COEF_R=-1.0,),
                                )
        # Normale sur la configuration finale
        if GEOMETRIE == 'DEFORMEE' :
            MAILLAGE = MODI_MAILLAGE(reuse=MAILLAGE,
                                     MAILLAGE=MAILLAGE,
                                     DEFORME=_F(OPTION='TRAN',
                                                DEPL=__depl,),)

        __NormaleF = CREA_CHAMP(TYPE_CHAM='NOEU_GEOM_R',
                                OPERATION='NORMALE',
                                MODELE=model,
                                GROUP_MA=GROUP_MA,
                                )

        if  GEOMETRIE == 'DEFORMEE' :
            MAILLAGE = MODI_MAILLAGE(reuse=MAILLAGE,
                                     MAILLAGE=MAILLAGE,
                                     DEFORME=_F(OPTION='TRAN',
                                                DEPL=__mdepl,),)

        __Pres = CREA_CHAMP(TYPE_CHAM='NOEU_NEUT_F',
                            OPERATION='AFFE',
                            MAILLAGE=MAILLAGE,
                            AFFE=_F(GROUP_MA=GROUP_MA,
                                    NOM_CMP='X1',
                                    VALE_F=__Pression,),)
        __pF = CREA_CHAMP(TYPE_CHAM='NOEU_NEUT_R',
                          OPERATION='EVAL',
                          CHAM_F=__Pres,
                          CHAM_PARA=(__NormaleF, __sigm,),)
#
        __chp[i] = CREA_CHAMP(TYPE_CHAM='NOEU_PRES_R',
                              OPERATION='ASSE',
                              MODELE=model,
                              ASSE=_F(GROUP_MA=GROUP_MA,
                                      CHAM_GD=__pF,
                                      NOM_CMP='X1',
                                      NOM_CMP_RESU='PRES',),)


    MasquerAlarme('ALGORITH11_87')  
    MasquerAlarme('COMPOR2_23') 

    RESULTAT = CREA_RESU(reuse=RESULTAT,
                         RESULTAT=RESULTAT,
                         TYPE_RESU=typ_resu,
                         NOM_CHAM='PRES_NOEU',
                         OPERATION='AFFE',
                         AFFE=[_F(INST=inst,
                                  CHAM_GD=__chp[i],
                                  MODELE=model,
                                  PRECISION=PRECISION,
                                  CRITERE=CRITERE,)
                               for i, inst in enumerate(insts)])
    
    RetablirAlarme('COMPOR2_23')
    RetablirAlarme('ALGORITH11_87')     
    
    return RESULTAT
