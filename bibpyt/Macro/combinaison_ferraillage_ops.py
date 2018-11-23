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

# I need this to print free users messages
#
#     aster.affiche( 'MESSAGE', chaine_de_caracteres)
#     aster.affiche('RESULTAT', chaine_de_caracteres)
#
import aster

# I need this to print messages from catalog
#
#                    UTMESS('A', 'COMBFERR_1')
#
from Utilitai.Utmess import UTMESS

# import Messages
# import GCMessages
# import copy

# necssario per usare _F
from code_aster.Cata.Syntax import _F

# Comandi ASTER da usare nella macro
from code_aster.Cata.Commands import CREA_CHAMP
from code_aster.Cata.Commands import CREA_RESU
from code_aster.Cata.Commands import CALC_FERRAILLAGE

#
# TODO 01:  Controllare la presenza dei campi necessari al CALC_FERRAILLAGE
# TODO 02:  Controllare Se si fornisce il gruppo di maglie che possa essere
#           conforme al tipo strutturale richiesto.

# macro body
#
def combinaison_ferraillage_ops(self, **args):

    # magic always required
    self.set_icmd(1)

    # olddict = copy.copy(Messages.__dict__)        # TEMP-TEMP-TEMP-TEMP
    # Messages.__dict__.update(GCMessages.__dict__) # TEMP-TEMP-TEMP-TEMP

    #
    # declaration of the return variable.
    #
    self.DeclareOut('resu', self.sd)

    resu         = self.reuse
    combinaison  = self [ 'COMBINAISON' ]
    modele       = self [ 'MODELE' ]
    affe         = self [ 'AFFE' ]
    caraelem     = self [ 'CARA_ELEM' ]
    codification = self [ 'CODIFICATION' ]

    if codification != 'EC2':
        UTMESS('F', 'COMBFERR_1')

    # Counting numbers of load combinations.
    #
    nmb_cas = countCase(combinaison)
    aster.affiche( 'MESSAGE', 'number cases = %d' % nmb_cas)

    # Build instant list (lst_inst_value of float) and instant index
    # and control about existing or duplicates NUM_CAS and NUME_ORDRE.
    #
    lst_inst_index, lst_inst_value, resu_nom_cas, resu_num_ord = \
        lstInst(nmb_cas,combinaison,resu)

    aster.affiche( 'MESSAGE', '         instant   value = ' + \
        string.join( [str(i) for i in lst_inst_value], '-') )
    aster.affiche( 'MESSAGE', 'seelected from   NOM_CAS = ' + \
        string.join( [str(i) for i in resu_nom_cas], '*') )
    aster.affiche( 'MESSAGE', 'seelected from NUMEORDRE = ' + \
        string.join( [str(i) for i in resu_num_ord], '*') )

    # - Build result type EVOL_ELAS from MULTI_ELAS and combo type list in order
    #   to select the right verify.
    # - [lst_type_combo] and [inst] heve a relationship one-to-one
    #
    __resfer, lst_type_combo = \
        evolElasFromMulti(nmb_cas,combinaison,lst_inst_value,resu,modele,caraelem)

    aster.affiche( 'MESSAGE', ' type combo = ' + \
    '\n' + string.join( [str(i) for i in lst_type_combo], '\n') )

    for i_affe in affe :
        structure_type = i_affe.get('TYPE_STRUCTURE')

        # [structure_type] selects design algorithm.
        if structure_type == '2D' :
            # Algorithm is CALC_FERRAILLAGE
            __resfer = algo_2D(__resfer, i_affe, lst_inst_value, codification, lst_type_combo)

        elif structure_type == 'POUTRE' :
            # Algorithm un available
            algo_POUTRE()

        elif structure_type == 'POTEAU' :
            # Algorithm un available
            algo_POTEAU()

        else:
            pass

    print "champs FERRAILLAGE -->", __resfer.LIST_CHAMPS()['FERRAILLAGE']

    # Maximum reinforcement field (elementwise, component by component)
    __maxifer = CREA_CHAMP (
        # INFO = 2,
        RESULTAT = __resfer,
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
          NOM_CHAM = 'FERRAILLAGE',
         TYPE_CHAM = 'ELEM_FER2_R',
         OPERATION = 'EXTR',
         TYPE_MAXI = 'MAXI',
         TYPE_RESU = 'INST',
        TOUT_ORDRE = 'OUI',
    );

    # Adding the field 'FERRAILLAGE' (steel reinforcement) to the MULTI_ELAS result, for all load cases
    #	 MULTI_ELAS completed by the steel reinforcement field is the OUTPUT of the COMBINAISON_FERRAILLAGE
    #	 NOTA BENE : CREA_RESU cannot complete the existing NOM_CAS/NUME_ORDRE, it adds new NUME_ORDRE
    #	 			 see crtype.f90 call rsorac.f90
    # 	Here we also test CALC_FERRAILLAGE (non-regression), can become analytical
    # By Luca

    # Build result type EVOL_ELAS from MULTI_ELAS and combo type list in order
    #
    resu = multiFromEvolElas(nmb_cas, resu_nom_cas, lst_inst_index, lst_inst_value, __resfer, resu, modele, caraelem)


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
							_F(
							 NOM_CAS = 'COMB_DIME_ORDRE',
							 CHAM_GD = __instfer,
							 MODELE = modele,
							 CARA_ELEM = caraelem,
								),
						),)

    nc = resu.LIST_VARI_ACCES()['NOM_CAS']

    aster.affiche( 'MESSAGE', ' name case = ' + \
    '\n' + string.join( [str(i) for i in nc], '\n') )

    # Messages.__dict__.update(olddict) # TEMP-TEMP-TEMP-TEMP
    return 0

def algo_2D (_resfer, affe, inst_value, code, type_combo):
    print "def option_2D:"

    dict_affe = affe.List_F()[0]
    dict_affe.pop('TYPE_STRUCTURE') # print dict_affe

    for idx_inst, inst in enumerate(inst_value):

        # seelction of mot-clè TYPE_COMB by [lst_type_combo]
        dic_type_comb = {}
        if type_combo [idx_inst]  == 'ELS_CARACTERISTIQUE':
            dic_type_comb['TYPE_COMB'] = 'ELS'

        elif type_combo [idx_inst]  == 'ELU_FONDAMENTAL':
            dic_type_comb['TYPE_COMB'] = 'ELU'

        elif type_combo [idx_inst]  == 'ELU_ACCIDENTEL':
            dic_type_comb['TYPE_COMB'] = 'ELU'

        else:
            dic_type_comb['TYPE_COMB'] = 'ELU'

        dic_calc_ferraillage = dict(dic_type_comb.items() + [('CODIFICATION', code)])

        _resfer = CALC_FERRAILLAGE (
            reuse = _resfer,
            RESULTAT = _resfer,
            INST = inst,
            TOUT_ORDRE = 'OUI',
            AFFE = _F(**dict_affe),
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

    return lst_inst_index, lst_inst_value, resu_nom_cas, resu_nume_ordre

# Build result type MULTI_ELAS from EVOL_ELAS
#
def multiFromEvolElas(ncas, resu_nom_cas, inst_index, inst_value, resfer, resu, modele, caraelem):

    __ACIER        = [None] * ncas
    lst_AFFE_ACIER = [None] * ncas

    for i, inst_index in enumerate(inst_index):
        __ACIER [ i ] = CREA_CHAMP(
            OPERATION='EXTR',
            # INFO = 1,
            TYPE_CHAM = 'ELEM_FER2_R',
            NOM_CHAM = 'FERRAILLAGE',
            RESULTAT = resfer,
            INST = inst_value [ i ],
                             )

        # Index needs to be [inst_index - 1] because MUME_ORDRE is index + 1
        #
        nomcas = resu_nom_cas [ inst_index - 1]
        print 'NOME CASO --> ', nomcas  # TEMP-TEMP-TEMP-TEMP

        lst_AFFE_ACIER [ i ] = _F(
            NOM_CAS = nomcas + 'F',
            CHAM_GD = __ACIER [ i ],
            MODELE = modele,
            # CHAM_MATER = affe,
            CARA_ELEM = caraelem,
        )

    resu = CREA_RESU(
        reuse = resu,
        RESULTAT = resu,
        OPERATION = 'AFFE',
        TYPE_RESU = 'MULT_ELAS' ,
        NOM_CHAM = 'FERRAILLAGE',
        AFFE = lst_AFFE_ACIER,
    )
    return resu

# Build result type EVOL_ELAS from MULTI_ELAS
#
def evolElasFromMulti(ncas, comb, lst_inst_value, resu, modele, caraelem):

    __EFGE         = [None] * ncas
    lst_AFFE_EFGE  = [None] * ncas
    type_combo = [None] * ncas # list of string as type of combo

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
            type_combo [idx_shift] = i_combo.get('TYPE');

            dic_idx_combo = { key_name_combo : val_combo }

            __EFGE[ idx_shift ] = CREA_CHAMP (
            TYPE_CHAM = 'ELNO_SIEF_R',
            OPERATION = 'EXTR',
            RESULTAT = resu,
            NOM_CHAM = 'EFGE_ELNO',
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
        NOM_CHAM ='EFGE_ELNO',
        AFFE = lst_AFFE_EFGE,
    )

    return _resfer, type_combo

# INFODEV
#
# Moving file in ../bibpyt/Macro
#
# INFODEV
