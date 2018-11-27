# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 2018 Aether Engineering Solutions - www.aethereng.com
# Copyright (C) 2018 Kobe Innovation Engineering - www.kobe-ie.com
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
# aslint: disable=W4004

import string

import aster

from Utilitai.Utmess import UTMESS

from code_aster.Cata.Syntax import _F

from code_aster.Cata.Commands import CREA_CHAMP
from code_aster.Cata.Commands import CREA_RESU
from code_aster.Cata.Commands import CALC_FERRAILLAGE
from code_aster.Cata.Commands import FORMULE
from code_aster.Cata.Commands import DETRUIRE

def combinaison_ferraillage_ops(self, **args):
    """Command to combine results to estimate reinforcement of the structure."""
    self.set_icmd(1)

    #
    # declaration of the return variable.
    #
    self.DeclareOut('resu', self.sd)

    resu         = self.reuse
    combinaison  = self [ 'COMBINAISON' ]
    affe         = self [ 'AFFE' ]
    codification = self [ 'CODIFICATION' ]

    #
    # Retriving MODELE from RESULTAT
    #
    # modele       = self [ 'MODELE' ] changed with dismoi
    iret, ibid, n_modele = aster.dismoi('MODELE', resu.nom, 'RESULTAT', 'F')
    n_model = n_modele.rstrip()
    if len(n_modele) == 0 or n_model == "#PLUSIEURS":
        UTMESS('F', 'COMBFERR_8')

    modele = self.get_concept(n_modele)

    #
    # Retriving CARA_ELEM from RESULTAT
    #
    # caraelem     = self [ 'CARA_ELEM' ] changed with dismoi
    iret, ibid, n_cara_elem = aster.dismoi('CARA_ELEM', resu.nom, 'RESULTAT', 'F')
    n_cara_elem = n_cara_elem.rstrip()

    caraelem = self.get_concept(n_cara_elem.strip())

    if codification != 'EC2':
        UTMESS('F', 'COMBFERR_1')

    # Counting numbers of load combinations.
    #
    nmb_cas = countCase(combinaison)
    aster.affiche( 'MESSAGE', 'number cases = %d' % nmb_cas)

    # Build instant list (lst_inst_value of float) and instant index
    # and control about existing or duplicates NUM_CAS and NUME_ORDRE.
    #
    lst_inst_index, lst_inst_value, resu_nom_cas, resu_num_ord, lst_type_combo = \
        lstInst(nmb_cas,combinaison,resu)

    aster.affiche( 'MESSAGE', '         instant   value = ' + \
        string.join( [str(i) for i in lst_inst_value], '-') )
    aster.affiche( 'MESSAGE', 'seelected from   NOM_CAS = ' + \
        string.join( [str(i) for i in resu_nom_cas], '*') )
    aster.affiche( 'MESSAGE', 'seelected from NUMEORDRE = ' + \
        string.join( [str(i) for i in resu_num_ord], '*') )

    # Controlling overwriting results
    #
    if 'COMB_DIME_ORDRE' in resu_nom_cas:
        UTMESS('A', 'COMBFERR_9')

    if 'COMB_DIME_ACIER' in resu_nom_cas:
        UTMESS('A', 'COMBFERR_10')

    aster.affiche( 'MESSAGE', ' type combo = ' + \
    '\n' + string.join( [str(i) for i in lst_type_combo], '\n') )

    for i_affe in affe :
        structure_type = i_affe.get('TYPE_STRUCTURE')

        # [structure_type] selects design algorithm.
        if structure_type == '2D' :
            # Algorithm is CALC_FERRAILLAGE
            # __resfer = algo_2D(__resfer, i_affe, lst_inst_value, codification, lst_type_combo)
            resu = algo_2D(resu, i_affe, lst_inst_index, codification, lst_type_combo)

        elif structure_type == 'POUTRE' :
            # Algorithm un available
            algo_POUTRE()

        elif structure_type == 'POTEAU' :
            # Algorithm un available
            algo_POTEAU()

        else:
            pass

    # - Build result type EVOL_ELAS from MULTI_ELAS and combo type list in order
    #   to select the right verify. This because CREA_CHAMP does'nt EXTR the
    #   MAXI from multi_elas
    __resfer = \
        evolElasFromMulti(nmb_cas,combinaison,lst_inst_value,resu,modele,caraelem)

    # Maximum reinforcement field (elementwise, component by component)
    __maxifer = CREA_CHAMP (
        RESULTAT = __resfer,
        # RESULTAT = resu,
        NOM_CHAM = 'FERRAILLAGE',
        TYPE_CHAM = 'ELEM_FER2_R',
        OPERATION = 'EXTR',
        TYPE_MAXI = 'MAXI',
        TYPE_RESU = 'VALE' ,
        TOUT_ORDRE = 'OUI',
    )

    # Instant for which maximum reinforcement field is retrieved (elementwise,
    # component by component) Later we want to see the NUME_ORDRE and not the
    # INSTant
    # NUME_ORDRE is not available now as an option of CREA_CHAMP-MAXI
    __instfer = CREA_CHAMP (
          RESULTAT = __resfer,
          # RESULTAT = resu,
          NOM_CHAM = 'FERRAILLAGE',
         TYPE_CHAM = 'ELEM_FER2_R',
         OPERATION = 'EXTR',
         TYPE_MAXI = 'MAXI',
         TYPE_RESU = 'INST',
        TOUT_ORDRE = 'OUI',
    )

    # Adding the field 'FERRAILLAGE' (steel reinforcement) to the MULTI_ELAS result,
    # for all load cases
    # MULTI_ELAS completed by the steel reinforcement field is the OUTPUT of the COMBINAISON_FERRAILLAGE
    # NOTA BENE : CREA_RESU cannot complete the existing NOM_CAS/NUME_ORDRE, it adds new NUME_ORDRE
    #                  see crtype.f90 call rsorac.f90
    #     Here we also test CALC_FERRAILLAGE (non-regression), can become analytical
    # By Luca

    # Build result type EVOL_ELAS from MULTI_ELAS and combo type list in order
    #
    # resu = multiFromEvolElas(nmb_cas, resu_nom_cas, lst_inst_index, lst_inst_value, __resfer, resu, modele, caraelem)
    # The reinforcement has 7 components
    #  DNSXI :
    #  DNSXS :
    #  DNSYI :
    #  DNSYS :
    #   DNST :
    # EPSIBE :
    # SIGMBE :

    # Workaround to Bug: "ELEM_NEUT_R can use only X1"
    __CHP = [None] * 7
    for cmp_index, cmp_name in enumerate(['DNSXI','DNSXS','DNSYI','DNSYS','DNST','SIGMBE','EPSIBE']):

        # Renaming component(s) in COMB_DIME_ORDRE to avoid overlapping with COMB_DIME_ACIER
        __CHORD2=CREA_CHAMP(OPERATION='ASSE',
                          MODELE=modele,
                          TYPE_CHAM='ELEM_NEUT_R',
                          ASSE=(
                                # ~ _F(CHAM_GD=CHORD,TOUT='OUI',NOM_CMP=('DNSXI','DNSXS','DNSYI','DNSYS','DNST','SIGMBE','EPSIBE'),NOM_CMP_RESU=('X8','X9','X10','X11','X12','X13','X14')),
                                _F(CHAM_GD=__instfer,TOUT='OUI',NOM_CMP=cmp_name,NOM_CMP_RESU='X1',),
                              ),
                              PROL_ZERO='OUI',
                              )

        __FDNSXI=FORMULE(NOM_PARA=(cmp_name,'X1'),VALE="X1 if "+cmp_name+" > 0 else -1")

        __CHFMU=CREA_CHAMP(OPERATION='AFFE',
                         TYPE_CHAM='ELEM_NEUT_F',
                         # ~ TYPE_CHAM='CART_NEUT_F',
                         # ~ TYPE_CHAM='ELGA_NEUT_F',
                         MODELE=modele,
                         AFFE=(
                                # ~ _F(TOUT = 'OUI',NOM_CMP = ('X1','X2','X3','X4','X5','X6','X7'),VALE_F = (FDNSXI,FDNSXS,FDNSYI,FDNSYS,FDNST,FSIGMBE,FEPSIBE)),
                                _F(TOUT = 'OUI',NOM_CMP = 'X1',VALE_F = __FDNSXI,),
                              ),
                              PROL_ZERO='OUI',
                              )

        # Bug 3 : cannot EVAL functions on CART_NEUT_F, ELGA_NEUT_F :
        __CHP[cmp_index]=CREA_CHAMP(OPERATION='EVAL',
                          TYPE_CHAM='ELEM_NEUT_R',
                          CHAM_F=__CHFMU,
                          CHAM_PARA=(__maxifer,__CHORD2),
                          )

        DETRUIRE(CONCEPT=(_F(NOM=(__CHORD2,__FDNSXI,__CHFMU)),),)

    # Bug il n y a pas de paramètre  INOUT  associe a la grandeur: FER2_R  dans l option: TOU_INI_ELEM
    # see https://www.code-aster.org/forum2/viewtopic.php?id=21005
    __CHORD4=CREA_CHAMP(OPERATION='ASSE',
                      # ~ TYPE_CHAM='ELEM_FER2_R',
                      TYPE_CHAM='CART_NEUT_R',
                      MODELE=modele,
                      # ~ PROL_ZERO='OUI',
                      ASSE=(
                            _F(TOUT='OUI',CHAM_GD=__CHP[0],NOM_CMP=('X1',), NOM_CMP_RESU=('X1',),),
                            _F(TOUT='OUI',CHAM_GD=__CHP[1],NOM_CMP=('X1',), NOM_CMP_RESU=('X2',),),
                            _F(TOUT='OUI',CHAM_GD=__CHP[2],NOM_CMP=('X1',), NOM_CMP_RESU=('X3',),),
                            _F(TOUT='OUI',CHAM_GD=__CHP[3],NOM_CMP=('X1',), NOM_CMP_RESU=('X4',),),
                            _F(TOUT='OUI',CHAM_GD=__CHP[4],NOM_CMP=('X1',), NOM_CMP_RESU=('X5',),),
                            _F(TOUT='OUI',CHAM_GD=__CHP[5],NOM_CMP=('X1',), NOM_CMP_RESU=('X6',),),
                            _F(TOUT='OUI',CHAM_GD=__CHP[6],NOM_CMP=('X1',), NOM_CMP_RESU=('X7',),),
                          )
                          )

    # Adding COMB_DIME_ACIER and COMB_DIME_ORDRE tu resu
    #
    resu = CREA_RESU(
                    reuse = resu,
                    RESULTAT = resu,
                    OPERATION = 'AFFE',
                    TYPE_RESU = 'MULT_ELAS' ,
                    NOM_CHAM = 'FERRAILLAGE',
                    AFFE = (
                            _F(
                             NOM_CAS = 'COMB_DIME_ACIER',
                             CHAM_GD = __maxifer,
                             MODELE = modele,
                             CARA_ELEM = caraelem,
                                ),
                        ),)

    # Adding COMB_DIME_ACIER and COMB_DIME_ORDRE tu resu
    #
    resu = CREA_RESU(
                    reuse = resu,
                    RESULTAT = resu,
                    OPERATION = 'AFFE',
                    TYPE_RESU = 'MULT_ELAS' ,
                    NOM_CHAM = 'UT01_ELEM',
                    AFFE = (
                            _F(
                             NOM_CAS = 'COMB_DIME_ORDRE',
                             # CHAM_GD = __instfer,
                             CHAM_GD = __CHORD4,
                             MODELE = modele,
                             CARA_ELEM = caraelem,
                                ),
                        ),)

    nc = resu.LIST_VARI_ACCES()['NOM_CAS']

    aster.affiche( 'MESSAGE', ' name case = ' + \
    '\n' + string.join( [str(i) for i in nc], '\n') )

    return 0

def algo_2D (_resfer, affe, lst_nume_ordre, code, type_combo):

    dict_affe = affe.List_F()[0]
    dict_affe.pop('TYPE_STRUCTURE') # print dict_affe

    for idx, nume_ordre in enumerate(lst_nume_ordre):

        # seelction of mot-clè TYPE_COMB by [lst_type_combo]
        dic_type_comb = {}
        
        # saving dict_affe
        affe_for_cf = dict_affe.copy();

        if type_combo [idx]  == 'ELS_CARACTERISTIQUE':
            dic_type_comb['TYPE_COMB'] = 'ELS'

        elif type_combo [idx]  == 'ELU_FONDAMENTAL':
            dic_type_comb['TYPE_COMB'] = 'ELU'
            
            affe_for_cf.update({'GAMMA_S':affe_for_cf['GAMMA_S_FOND']})
            affe_for_cf.update({'GAMMA_C':affe_for_cf['GAMMA_C_FOND']})  

        elif type_combo [idx]  == 'ELU_ACCIDENTEL':
            dic_type_comb['TYPE_COMB'] = 'ELU'
            
            affe_for_cf.update({'GAMMA_S':affe_for_cf['GAMMA_S_ACCI']})
            affe_for_cf.update({'GAMMA_C':affe_for_cf['GAMMA_C_ACCI']})            

        else:
            dic_type_comb['TYPE_COMB'] = 'ELU'

        # adjusting affe for calc_ferraillage        
        affe_for_cf.pop('GAMMA_C_FOND')
        affe_for_cf.pop('GAMMA_S_FOND')
        affe_for_cf.pop('GAMMA_C_ACCI')
        affe_for_cf.pop('GAMMA_S_ACCI')

        dic_calc_ferraillage = dict(dic_type_comb.items() + [('CODIFICATION', code)])

        _resfer = CALC_FERRAILLAGE (
            reuse = _resfer,
            RESULTAT = _resfer,
            NUME_ORDRE = nume_ordre,
            AFFE = _F(**affe_for_cf),
            **dic_calc_ferraillage
        )

    return _resfer

def algo_POUTRE ():
    print "def option_POUTRE:"
    UTMESS('A', 'COMBFERR_2')
    return None

def algo_POTEAU ():
    print "def option_POTEAU:"
    UTMESS('A', 'COMBFERR_3')
    return None


def combdimferr(fer):
    if fer <= 0.:
        return 0.
    else:
        return 1.

# Counting numbers of load combinations.
#
def countCase(comb):
    nmb_cas = 0
    for idx_i_combo, i_combo in enumerate(comb) :
        # Case number from MULTI_ELAS
        lst_nomcas = i_combo.get('NOM_CAS')
        lst_numord = i_combo.get('NUME_ORDRE')
        if lst_nomcas == None:
            nmb_cas = nmb_cas + len(lst_numord)      # combinations number
        else:
            nmb_cas = nmb_cas + len(lst_nomcas)
    return nmb_cas


def lstInst(ncas, comb, resultat):

    lst_inst_value = [None] * ncas # list of float value as time for AFFE
    lst_inst_index = [None] * ncas # list of int value as index
    type_combo     = [None] * ncas # list of string as type of combo

    # Recupero i numeri d'ordine e nomi dei casi
    resu_nume_ordre = resultat.LIST_VARI_ACCES()['NUME_ORDRE']
    resu_nom_cas = resultat.LIST_VARI_ACCES()['NOM_CAS']

    # Deblanking di [resu_nom_cas]
    for idx, val in enumerate(resu_nom_cas):
        resu_nom_cas[idx]=val.strip()

    idx_shift = 0
    for idx_i_combo, i_combo in enumerate( comb ) :
        # Case number from MULTI_ELAS
        lst_nomcas = i_combo.get('NOM_CAS')
        lst_numord = i_combo.get('NUME_ORDRE')
        if lst_nomcas == None:
            lst_combo = lst_numord
            key_name_combo = 'NUME_ORDRE'
        else:
            lst_combo = lst_nomcas
            key_name_combo = 'NOM_CAS'

        for idx_combo, val_combo in enumerate( lst_combo ):

            # type combo list couple with instant
            type_combo [idx_shift] = i_combo.get('TYPE')

            if key_name_combo == 'NUME_ORDRE':
                inst = val_combo
                if not (inst in resu_nume_ordre):
                    UTMESS('F', 'COMBFERR_7')
                if inst in lst_inst_index:
                    UTMESS('F', 'COMBFERR_4')
            else:
                if not (val_combo in resu_nom_cas):
                    UTMESS('F', 'COMBFERR_6')
                # Index needs to be [inst_index + 1] because MUME_ORDRE is index + 1
                inst = resu_nom_cas.index(val_combo) + 1
                if inst in lst_inst_index:
                    UTMESS('F', 'COMBFERR_5')

            lst_inst_index [ idx_shift ] = inst
            lst_inst_value [ idx_shift ] = float(inst)
            idx_shift = idx_shift + 1

    return lst_inst_index, lst_inst_value, resu_nom_cas, resu_nume_ordre, type_combo



# Build result type EVOL_ELAS from MULTI_ELAS
#
def evolElasFromMulti(ncas, comb, lst_inst_value, resu, modele, caraelem):

    __EFGE         = [None] * ncas
    lst_AFFE_EFGE  = [None] * ncas
    # type_combo     = [None] * ncas # list of string as type of combo

    idx_shift = 0
    for idx_i_combo, i_combo in enumerate( comb ) :

        # Case number from MULTI_ELAS
        lst_nomcas = i_combo.get('NOM_CAS')
        lst_numord = i_combo.get('NUME_ORDRE')
        if lst_nomcas == None:
            lst_combo = lst_numord                   # list with combinations
            key_name_combo = 'NUME_ORDRE'
        else:
            lst_combo = lst_nomcas
            key_name_combo = 'NOM_CAS'


        for idx_combo, val_combo in enumerate( lst_combo ):

            # type combo list couple with instant
            # type_combo [idx_shift] = i_combo.get('TYPE')

            dic_idx_combo = { key_name_combo : val_combo }

            __EFGE[ idx_shift ] = CREA_CHAMP (

            OPERATION = 'EXTR',
            RESULTAT = resu,
            # TYPE_CHAM = 'ELNO_SIEF_R',
            # NOM_CHAM = 'EFGE_ELNO',
            TYPE_CHAM = 'ELEM_FER2_R',
            NOM_CHAM = 'FERRAILLAGE',
            **dic_idx_combo
            )

            lst_AFFE_EFGE [ idx_shift ] = _F (
                 INST = lst_inst_value [ idx_shift ],
              CHAM_GD = __EFGE [ idx_shift ],
               MODELE = modele,
            CARA_ELEM = caraelem,
            )

            idx_shift = idx_shift  + 1

    _resfer = CREA_RESU (
        OPERATION='AFFE',
        TYPE_RESU ='EVOL_ELAS',
        # NOM_CHAM ='EFGE_ELNO',
        NOM_CHAM ='FERRAILLAGE',
        AFFE = lst_AFFE_EFGE,
    )

    return _resfer# , type_combo
