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

# person_in_charge : ayaovi-dzifa.kudawoo at edf.fr


import os

def calc_pression_ops(self, MAILLAGE, RESULTAT,TOUT_ORDRE, GROUP_MA, INST,
                      GEOMETRIE,CRITERE,PRECISION, **args):
    """
           Macro permettant le calcul des pressions aux interfaces d'un solide
           à partir du champ de contraintes sigma_n. Elle fonctionne
           uniquement pour les modèles massif. On exclut du périmètre d'utilisation
           les éléments de structures types discret, poutre, plaque, coques,...
    """
    import aster
    from code_aster.Cata.Syntax import _F
    from Utilitai.Utmess import MasquerAlarme, RetablirAlarme, UTMESS
    from code_aster.Cata.DataStructure import (evol_elas, evol_noli)

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

     # Le concept sortant (de type cham_no) est chpout
    self.DeclareOut('__RESU', self.sd)
    Mail = self.DeclareOut('Mail', MAILLAGE)

    # On importe les definitions des commandes a utiliser dans la macro
    # Le nom de la variable doit etre obligatoirement le nom de la commande
    CREA_CHAMP = self.get_cmd('CREA_CHAMP')
    CALC_CHAMP = self.get_cmd('CALC_CHAMP')
    CREA_RESU = self.get_cmd('CREA_RESU')
    MODI_MAILLAGE = self.get_cmd('MODI_MAILLAGE')
    FORMULE = self.get_cmd('FORMULE')
    DETRUIRE = self.get_cmd('DETRUIRE')

    # RESULTAT
    __RESU = self['RESULTAT']
    typ_resu = 'EVOL_NOLI' if isinstance(RESULTAT, evol_noli) else 'EVOL_ELAS'
    insts = INST or RESULTAT.LIST_VARI_ACCES()['INST']
    
    # Modele
    # Recupération à partir de ASTER.DISMOI
    iret, ibid, n_modele = aster.dismoi(
        'MODELE', __RESU.nom, 'RESULTAT', 'F')
    auto_modele = n_modele.rstrip()
    if auto_modele in ('', '#AUCUN'):
        UTMESS('I', 'POST0_23', valk=nomresu)
    elif auto_modele == '#PLUSIEURS':
        UTMESS('F', 'CALCPRESSION0_2')

    MODELE = self['MODELE']
    if MODELE is None:
        n_modele = auto_modele
    else:
        n_modele = MODELE.nom
        if not n_modele == auto_modele :
            UTMESS('F', 'CALCPRESSION0_1')

    __model = self.get_concept(n_modele)

    # BLINDAGE : on poursuit le calcul uniquement que si le groupe n'a pas de
    # élément de structure
    iret, ibid, test_structure = aster.dismoi(
        'EXI_RDM', __model.nom, 'MODELE', 'F')
    # si non dans tout le modele
    if test_structure == 'NON':
        iret, dim, rbid = aster.dismoi('DIM_GEOM', __model.nom, 'MODELE', 'F')
    else :
    # si oui dans le modele, ensuite check toutes les mailles dans les group_ma
        for grm in GROUP_MA:
            iret = aster.gmardm(grm, __model.nom)
            if iret == 1 : UTMESS('F', 'CALCPRESSION0_3')
        iret, dim, rbid = aster.dismoi('DIM_GEOM', __model.nom, 'MODELE', 'F')

    MasquerAlarme('CALCCHAMP_1')
    # Champ de contraintes de Cauchy aux noeuds
    __RESU = CALC_CHAMP(reuse =RESULTAT,
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
            Mail = MODI_MAILLAGE(reuse=MAILLAGE,
                                 MAILLAGE=MAILLAGE,
                                 DEFORME=_F(OPTION='TRAN',
                                            DEPL=__depl,),)
            
        __NormaleF = CREA_CHAMP(TYPE_CHAM='NOEU_GEOM_R',
                                OPERATION='NORMALE',
                                MODELE=__model,
                                GROUP_MA=GROUP_MA,
                                )
 
        if  GEOMETRIE == 'DEFORMEE' :
            Mail = MODI_MAILLAGE(reuse=MAILLAGE,
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
 
        __chp[i] = CREA_CHAMP(TYPE_CHAM='NOEU_PRES_R',
                              OPERATION='ASSE',
                              MODELE=__model,
                              ASSE=_F(GROUP_MA=GROUP_MA,
                                      CHAM_GD=__pF,
                                      NOM_CMP='X1',
                                      NOM_CMP_RESU='PRES',),)     

        DETRUIRE(CONCEPT=_F(NOM=__sigm,), INFO=1)
        DETRUIRE(CONCEPT=_F(NOM=__NormaleF,), INFO=1)
        DETRUIRE(CONCEPT=_F(NOM=__Pres,), INFO=1)
        DETRUIRE(CONCEPT=_F(NOM=__pF,), INFO=1)
        if  GEOMETRIE == 'DEFORMEE' :
            DETRUIRE(CONCEPT=_F(NOM=__depl,), INFO=1)
            DETRUIRE(CONCEPT=_F(NOM=__mdepl,), INFO=1)

    MasquerAlarme('ALGORITH11_87')  
    MasquerAlarme('COMPOR2_23') 

    __RESU = CREA_RESU(reuse=RESULTAT,
                       RESULTAT=RESULTAT,
                       TYPE_RESU=typ_resu,
                       NOM_CHAM='PRES_NOEU',
                       OPERATION='AFFE',
                       AFFE=[_F(INST=inst,
                                CHAM_GD=__chp[i],
                                MODELE=__model,
                                PRECISION=PRECISION,
                                CRITERE=CRITERE,)
                             for i, inst in enumerate(insts)])
    
    RetablirAlarme('COMPOR2_23')
    RetablirAlarme('ALGORITH11_87')     

    for i in __chp :
        DETRUIRE(CONCEPT=_F(NOM=i,), INFO=1)
    
    return
