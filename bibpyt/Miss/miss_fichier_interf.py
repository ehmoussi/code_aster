# coding=utf-8
# --------------------------------------------------------------------
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

# person_in_charge: mathieu.courtois at edf.fr

"""Module permettant de produire les fichiers :
    - de données de Miss (.in),
    - de maillage de l'interface (.mvol),
    - des modes d'interface (.chp).
"""

import os
from functools import partial

from Miss.miss_domain import MissDomains
from Miss.miss_utils import dict_format, en_ligne


def fichier_mvol(struct):
    """Produit le contenu du fichier de maillage mvol.
    """
    cont = ["COUPLAGE MISS ASTER", ]
    cont.extend(
        en_ligne([struct.noeud_nb, struct.maille_nb_tot], dict_format['sI'], 2, ""))
    fmtR_fort = "3E%s" % (dict_format['R'].replace("E", ""))
    cont.append("(%s)" % fmtR_fort)
    cont.extend(en_ligne(struct.noeud_coor, dict_format['sR'], 3, ""))
    for i, connec in enumerate(struct.maille_connec):
        ngr = i + 1
        cont.extend(en_ligne(connec, dict_format['sI'], 20,
                             format_ligne="%%(valeurs)s     GR    %d" % ngr))
    cont.append("")
    return os.linesep.join(cont)


def fichier_chp(param, struct):
    """Produit le contenu du fichier chp"""
    domain = MissDomains(param['_hasPC'], param["ISSF"] == "OUI", param['_hasSL'])
    group = domain.group
    cont = []
    # groupes des interfaces (sol-struct + struct OU fluide-struct)
    grp = "GROUPE %4d" % group['sol-struct']
    if group.get('fluide-struct'):
        grp += "%4d" % group['fluide-struct']
        if domain.def_all_domains:
            grp += "%4d" % group['struct']
    else:
        grp += "%4d" % group['struct']
    # modes statiques
    cont.append(grp)
    cont.append(("MODE   " + dict_format["sI"]) % struct.mode_stat_nb)
    fmt_ligne = partial(en_ligne, format=dict_format['sR'], cols=3,
                        format_ligne="%(index_1)6d%(valeurs)s")
    mult = struct.noeud_nb * 3
    for i in range(struct.mode_stat_nb):
        cont.extend(fmt_ligne(struct.mode_stat_vale[i * mult:(i + 1) * mult]))
        cont.append("FIN")
    # groupes des interfaces (struct OU fluide-struct)
    # pas l'interface sol-struct car hypothèse d'encastrement
    grp = "GROUPE "
    if group.get('fluide-struct'):
        grp += "%4d" % group['fluide-struct']
        if domain.def_all_domains:
            grp += "%4d" % group['struct']
    else:
        grp += "%4d" % group['struct']
    # modes dynamiques
    cont.append(grp)
    cont.append(("MODE   " + dict_format["sI"]) % struct.mode_dyna_nb)
    mult = struct.noeud_nb * 3
    for i in range(struct.mode_dyna_nb):
        cont.extend(fmt_ligne(struct.mode_dyna_vale[i * mult:(i + 1) * mult]))
        cont.append("FIN")
    if param["ISSF"] == "OUI":
        cont.append("GROUPE %4d" % group['sol-fluide'])
        if param['ALLU'] != 0.:
            refl = param['ALLU']
            kimp = refl / (2. - refl)
            simp = str(kimp)
            cont.append("FLUI " + simp + " BEM")
        else:
            cont.append("DEPN  BEM")
    if param['_hasSL']:
        cont.append("GROUPE %4d" % group['sol libre'])
        cont.append("LIBRE")
    if param['_hasPC']:
        cont.append("GROUPE %4d" % group['pc'])
        cont.append("LIBRE")
    cont.append("FINC")
    cont.append("EOF")
    cont.append("")
    return os.linesep.join(cont)


def fichier_ext(struct):
    """Produit le contenu du fichier ext"""
    dval = struct.__dict__
    dval['_useamor'] = ''
    amosta = struct.mode_stat_amor
    if len(amosta) > 0:
        dval['_useamor'] = 'AMORTISSEMENT'
    cont = ['CRAIG  %(mode_stat_nb)5d%(mode_dyna_nb)5d %(_useamor)s' % dval]
    fmt_ligne = partial(en_ligne, format="%17.10E", cols=5)
    # stat
    dec = struct.mode_stat_nb
    massta = struct.mode_stat_mass
    for i in range(struct.mode_stat_nb):
        cont.extend(fmt_ligne(massta[i * dec:(i + 1) * dec]))
    rigsta = struct.mode_stat_rigi
    for i in range(struct.mode_stat_nb):
        cont.extend(fmt_ligne(rigsta[i * dec:(i + 1) * dec]))
    if len(amosta) > 0:
        for i in range(struct.mode_stat_nb):
            cont.extend(fmt_ligne(amosta[i * dec:(i + 1) * dec]))
    # dyn et coupl
    fmt3 = dict_format['sR'] * 3
    frqdyn = struct.mode_dyna_freq
    masdyn = struct.mode_dyna_mass
    amodyn = struct.mode_dyna_amor
    mascou = struct.coupl_mass
    rigcou = struct.coupl_rigi
    amocou = struct.coupl_amor
    dec = struct.mode_stat_nb
    for i in range(struct.mode_dyna_nb):
        cont.append(fmt3 % (frqdyn[i], masdyn[i], amodyn[i]))
        cont.extend(fmt_ligne(mascou[i * dec:(i + 1) * dec]))
        cont.extend(fmt_ligne(rigcou[i * dec:(i + 1) * dec]))
        if len(amocou) > 0:
            cont.extend(fmt_ligne(amocou[i * dec:(i + 1) * dec]))
    cont.append("")
    return os.linesep.join(cont)


def fichier_sign(param):
    """Produit le contenu du fichier .sign"""
    import numpy as NP
    if param["FREQ_MIN"] is not None:
        lfreq = list(NP.arange(param["FREQ_MIN"],
                               param["FREQ_MAX"] + param["FREQ_PAS"],
                               param["FREQ_PAS"]))
    if param["LIST_FREQ"] is not None:
        lfreq = list(param['LIST_FREQ'])
    lfreq.insert(0, 0.)
    nbfr = len(lfreq)
    cont = ["TABU %5d ACCE MULT" % nbfr]
    fmt3 = dict_format['sR'] * 3
    for freq in lfreq:
        cont.append(fmt3 % (freq, 1., 0.))
    cont.append("")
    return os.linesep.join(cont)
