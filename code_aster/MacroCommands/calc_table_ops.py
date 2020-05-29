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

# person_in_charge: mathieu.courtois at edf.fr

import os
from pprint import pformat

import numpy as np

import aster
from ..Messages import UTMESS

from ..Cata.DataStructure import *
from ..Cata.DataStructure import table_container, table_fonction
from ..Cata.Syntax import _F
from ..Commands import CREA_TABLE, DETRUIRE
from ..Objects.table_py import Table, merge, remove_twins
from ..Utilities import force_list
from ..Utilities.misc import get_titre_concept


def calc_table_prod(TABLE, ACTION, **args):
   """Typage du concept produit.
   """
   l_typ = [AsType(TABLE),]
   for mcf in ACTION:
      if mcf.get('TABLE') is not None:
         l_typ.append(AsType(mcf['TABLE']))
   # une table_fonction étant une table
   if table_fonction in l_typ:
      return table_fonction, 'TABLE_FONCTION'
   elif table_container in l_typ:
      return table_container, 'TABLE_CONTAINER'
   else:
      return table_sdaster, 'TABLE'

def calc_table_ops(self, TABLE, ACTION, INFO, **args):
    """
    Macro CALC_TABLE permettant de faire des opérations sur une table
    """


    args = _F(args)

    new_table, typ_tabout = calc_table_prod(TABLE, ACTION)

    tab = TABLE.EXTR_TABLE()

    # Réinitialiser le titre si on n'est pas réentrant
    if args['reuse'] is None:
        tab.titr = get_titre_concept(TABLE)

    # Boucle sur les actions à effectuer
    for fOP in ACTION:
        occ = fOP.cree_dict_valeurs(fOP.mc_liste)
        for mc, val in list(occ.items()):
            if val is None:
                del occ[mc]

        # 1. Traitement du FILTRE
        # format pour l'impression des filtres
        form_filtre = '\nFILTRE -> NOM_PARA: %-16s CRIT_COMP: %-4s VALE: %s'
        if occ['OPERATION'] == 'FILTRE':
            # peu importe le type, c'est la meme méthode d'appel
            opts = [occ[k]
                    for k in ('VALE', 'VALE_I', 'VALE_C', 'VALE_K') if k in occ]
            kargs = {}
            for k in ('CRITERE', 'PRECISION'):
                if k in occ:
                    kargs[k] = occ[k]

            col = getattr(tab, occ['NOM_PARA'])
            tab = getattr(col, occ['CRIT_COMP'])(*opts, **kargs)

            # trace l'operation dans le titre
            # if FORMAT in ('TABLEAU', 'ASTER'):
            tab.titr += form_filtre % (occ['NOM_PARA'], occ['CRIT_COMP'],
                                       ' '.join([str(v) for v in opts]))

        # 2. Traitement de EXTR
        if occ['OPERATION'] == 'EXTR':
            lpar = force_list(occ['NOM_PARA'])
            for p in lpar:
                if not p in tab.para:
                    UTMESS('F', 'TABLE0_2', valk=[p, TABLE.getName()])
            tab = tab[lpar]

        # 3. Traitement de SUPPRIME
        if occ['OPERATION'] == 'SUPPRIME':
            lpar = force_list(occ['NOM_PARA'])
            keep = []
            for p in tab.para:
                if not p in lpar:
                    keep.append(p)
            tab = tab[keep]

        # 4. Traitement de RENOMME
        if occ['OPERATION'] == 'RENOMME':
            try:
                tab.Renomme(*occ['NOM_PARA'])
            except KeyError as msg:
                UTMESS('F', 'TABLE0_3', valk=msg)

        # 5. Traitement du TRI
        if occ['OPERATION'] == 'TRI':
            tab.sort(CLES=occ['NOM_PARA'], ORDRE=occ['ORDRE'])

        # 6. Traitement de COMB
        if occ['OPERATION'] == 'COMB':
            tab2 = occ['TABLE'].EXTR_TABLE()
            lpar = []
            if occ.get('NOM_PARA') is not None:
                lpar = force_list(occ['NOM_PARA'])
                for p in lpar:
                    if not p in tab.para:
                        UTMESS('F', 'TABLE0_2', valk=[p, TABLE.getName()])
                    if not p in tab2.para:
                        UTMESS('F', 'TABLE0_2', valk=[p, occ['TABLE'].getName()])
            restrict = occ.get('RESTREINT') == 'OUI'
            format_r = occ.get('FORMAT_R')
            tab = merge(tab, tab2, lpar, restrict=restrict, format_r=format_r)

        # 7. Traitement de OPER
        if occ['OPERATION'] == 'OPER':
            if occ.get('NOM_COLONNE') \
                    and len(occ['NOM_COLONNE']) != len(occ['FORMULE'].getVariables()):
                UTMESS('F', 'TABLE0_19', vali=len(occ['FORMULE'].getVariables()))
            # ajout de la colonne dans la table
            tab.fromfunction(occ['NOM_PARA'], occ['FORMULE'],
                             l_para=occ.get('NOM_COLONNE'))
            if INFO == 2:
                vectval = getattr(tab, occ['NOM_PARA']).values()
                aster.affiche('MESSAGE', 'Ajout de la colonne %s : %s'
                              % (occ['NOM_PARA'], repr(vectval)))

        # 8. Traitement de AJOUT_LIGNE
        if occ['OPERATION'] == 'AJOUT_LIGNE':
            lpar = force_list(occ['NOM_PARA'])
            lval = force_list(occ['VALE'])
            if len(lpar) != len(lval):
                UTMESS('F', 'TABLE0_14', valk=('NOM_PARA', 'VALE'))
            dnew = dict(list(zip(lpar, lval)))
            # ajout de la ligne avec vérification des types
            tab.append(dnew)

        # 9. Traitement de AJOUT_COLONNE
        if occ['OPERATION'] == 'AJOUT_COLONNE':
            lpar = force_list(occ['NOM_PARA'])
            lcol = occ.get('VALE_COLONNE')
            if lcol:
                lcol = force_list(lcol)
                if len(lpar) != 1:
                    UTMESS('F', 'TABLE0_4')
                tab[lpar[0]] = lcol[:len(tab)]
            else:
                lval = force_list(occ['VALE'])
                if len(lpar) != len(lval):
                    UTMESS('F', 'TABLE0_14', valk=('NOM_PARA', 'VALE'))
                for para, value in zip(lpar, lval):
                    nval = [value, ] * len(tab)
                    tab[para] = nval

        # 10. Suppression des doublons
        if occ['OPERATION'] == 'UNIQUE':
            format_r = occ.get('FORMAT_R')
            lpar = force_list(occ['NOM_PARA'])
            remove_twins(tab, lpar, format_r)

        # Traitement de STATISTIQUES
        if occ['OPERATION'] == 'STATISTIQUES':
            for nom_para in ('STAT_NOM', 'STAT_VALE'):
                if nom_para in tab.para:
                    UTMESS('F', 'TABLE0_24', valk=nom_para)
            nbVide = 0
            for col in tab.values().values():
                nbVide += sum([1 for i in col if i is None])
            # be care to extract the statistics before changing `tab`!
            tab['STAT_VALE'] = [len(tab), len(tab.para), nbVide]
            tab['STAT_NOM'] = ['NB_LIGNES', 'NB_COLONNES', 'NB_VIDE']

        # 12. Traitement de CALCUL # NOM_PARA, TYPE_CALCUL
        if occ['OPERATION'] == 'CALCUL':
            lpar = force_list(occ['NOM_PARA'])
            lcalc = force_list(occ['TYPE_CALCUL'])

            # vérifier le type des variables dans les colonnes
            for ipar in lpar :
                if tab[ipar].type[0] not in ['R', 'I'] :
                    UTMESS('F', 'TABLE0_16')

            # décider le format de la nouvelle table
            if args['reuse'] is not None:
                tab.add_para('TYPE_CALCUL','K8')
                tab_new = tab
            else :
                tab_new = Table([],tab.para, tab.type)
                for ipar in tab.para :
                    if ipar not in lpar : del tab_new[ipar]
                tab_new.add_para('TYPE_CALCUL','K8')

            val_new =[]
            # Boucle de calcul pour chaque colonne
            for ipar in lpar :
                # vérifier les vides dans la colonne
                lval = tab[ipar].values()[ipar]

                # supprimer les vides
                lval2 = [x for x in lval if x is not None]
                lval3 = []
                # lcalc_new = []
                for icalc in lcalc :
                    if icalc == 'MAXI' :
                        lval3.append( max(lval2) )
                    elif icalc == 'MINI' :
                        lval3.append( min(lval2) )
                    elif icalc == 'SOMM' :
                        lval3.append( sum(lval2) )
                    elif icalc == 'MOY' :
                        lval3.append( np.mean(lval2) )
                    elif icalc == 'MAXI_ABS' :
                        lval4 = []
                        for ival in range(len(lval2)):
                            lval4.append(abs(lval2[ival]))
                        lval3.append( max(lval4) )
                    elif icalc == 'MINI_ABS' :
                        lval4 = []
                        for ival in range(len(lval2)):
                            lval4.append(abs(lval2[ival]))
                        lval3.append( min(lval4) )
                    elif icalc == 'SOMM_ABS' :
                        lval4 = []
                        for ival in range(len(lval2)):
                            lval4.append(abs(lval2[ival]))
                        lval3.append( sum(lval4) )

                val_new.append(lval3)

            val_new.append(lcalc)
            # mettre les valeurs calculées dans la nouvelle table
            lpar.append('TYPE_CALCUL')
            for icalc in range(len(lcalc)) :
                ilval = [val_new[x][icalc] for x in range(len(lpar))]
                dnew = dict(zip(lpar, ilval))
                tab_new.append(dnew)

            tab = tab_new


    # 99. Création de la table_sdaster résultat
    # cas réentrant : il faut détruire l'ancienne table_sdaster
    if args['reuse'] is not None:
        DETRUIRE(CONCEPT=_F(NOM=TABLE), INFO=1)

    dprod = tab.dict_CREA_TABLE()
    if INFO == 2:
        echo_mess = ['']
        echo_mess.append(repr(tab))
        echo_mess.append(pformat(dprod))
        echo_mess.append('')
        texte_final = os.linesep.join(echo_mess)
        aster.affiche('MESSAGE', texte_final)

    # surcharge par le titre fourni
    tit = args.get('TITRE')
    if tit is not None:
        if type(tit) not in (list, tuple):
            tit = [tit]
        dprod['TITRE'] = tuple(['%-80s' % lig for lig in tit])
    # type de la table de sortie à passer à CREA_TABLE
    tabout = CREA_TABLE(TYPE_TABLE=typ_tabout,
                        **dprod)
    return tabout
