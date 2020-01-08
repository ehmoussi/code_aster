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
# aslint: disable=C4007

"""Macro-commande INCLUDE_MATERIAU

Définition des mots-clés et fonctions utilisables dans les catalogues :
  - extraction : indique si un mot-clé facteur doit être conservé en
    fonction de la présence d'EXTRACTION.
      - Si extraction == True, on conserve le mot-clé facteur si
        EXTRACTION est présent.
      - Si extraction == False, on conserve le mot-clé facteur si
        EXTRACTION est absent.
      - Si extraction n'est pas indiqué (vaut None), le mot-clé facteur
        est conservé que EXTRACTION soit présent ou non.
  - temp_eval : indique qu'une fonction doit être évaluée en fonction de
    la température.
  - coef_unit : fonction qui renvoie un coefficient multiplicatif selon
    l'unité
      - en m : retourne 1.
      - en mm : retourne 10^expo
  - prol : dictionnaire qui renvoie le type de prolongement :
      prol['droite'], prol['gauche']
  - defi_motscles : fonction qui définit tous les mots-clés, filtrés
    ensuite en fonction de EXTRACTION.
  - motscles : objet résultat de DEFI_MOTSCLES contenant les mots-clés
    à utiliser dans DEFI_MATERIAU.

On définit ici la liste des commandes utilisables dans un matériau.
"""

import os.path as osp
import pprint
from math import pow

import aster
import aster_core
from . import Commands
from ..Cata.DataStructure import formule
from ..Cata.Syntax import _F
from ..Commands import DEFI_MATERIAU
from Utilitai.Utmess import UTMESS

EXTR = 'extraction'
FTEMP = 'temp_eval'
FCOEF = 'coef_unit'
DPROL = 'prol'
DEFI_MOTSCLES = 'defi_motscles'
MOTSCLES = 'motscles'
COMMANDES = [
    'DEFI_LIST_REEL', 'DEFI_FONCTION', 'DEFI_CONSTANTE', 'DEFI_NAPPE',
    'FORMULE', 'CALC_FONCTION', 'CALC_FONC_INTERP',
    'DETRUIRE',
]


def build_context(unite, temp, prol):
    """Construit le contexte pour exécuter un catalogue matériau."""
    # définition du coefficient multiplicatif selon l'unité.
    unite = unite.lower()
    assert unite in ("m", "mm")
    if unite == "m":
        coef_unit = lambda expo: 1.
    else:
        coef_unit = lambda expo: pow(10., expo)

    # extraction à une température donnée
    if temp is not None:
        func_temp = lambda f: f(temp)
    else:
        func_temp = lambda x: x

    # fonction pour récupérer les mots clés
    def defi_motscles(**kwargs):
        return kwargs

    context = {
        FCOEF: coef_unit,
        DPROL: prol,
        FTEMP: func_temp,
        DEFI_MOTSCLES: defi_motscles,
    }
    return context


def include_materiau_ops(self,
                         EXTRACTION=None, UNITE_LONGUEUR=None, INFO=None,
                         PROL_GAUCHE=None, PROL_DROITE=None, **args):
    """Macro INCLUDE_MATERIAU"""
    fmat = args.get('FICHIER')
    if not fmat:
        bnmat = ''.join([args['NOM_AFNOR'], '_', args['TYPE_MODELE'],
                         '_', args['VARIANTE'], '.', args['TYPE_VALE']])
        rcdir = aster_core.get_option("rcdir")
        fmat = osp.join(rcdir, "materiau", bnmat)

    if not osp.exists(fmat):
        UTMESS('F', 'FICHIER_1', valk=fmat)

    # extraction à une température donnée
    extract = EXTRACTION is not None
    if extract:
        TEMP_EVAL = EXTRACTION['TEMP_EVAL']
        keep_compor = lambda compor: compor in EXTRACTION['COMPOR']
    else:
        TEMP_EVAL = None
        keep_compor = lambda compor: True

    # définition du prolongement des fonctions
    dict_prol = {
        'droite': PROL_DROITE,
        'gauche': PROL_GAUCHE,
    }

    context = build_context(UNITE_LONGUEUR, TEMP_EVAL, dict_prol)
    # ajout des commandes autorisées
    commandes = dict([(cmd, getattr(Commands, cmd)) for cmd in COMMANDES])
    context.update(commandes)
    context['_F'] = _F

    # exécution du catalogue
    with open(fmat) as f:
        exec(compile(f.read(), fmat, 'exec'), context)
    kwcata = context.get(MOTSCLES)
    if kwcata is None:
        UTMESS('F', 'SUPERVIS2_6', valk=bnmat)
    # certains concepts cachés doivent être connus plus tard (au moins les
    # objets FORMULE)
    to_add = dict([(v.getName(), v)
                  for k, v in list(context.items()) if isinstance(v, formule)])
    self.sdprods.extend(list(to_add.values()))
    if INFO == 2:
        aster.affiche('MESSAGE', " Mots-clés issus du catalogue : \n%s"
                      % pprint.pformat(kwcata))
        aster.affiche(
            'MESSAGE', 'Concepts transmis au contexte global :\n%s' % to_add)

    # filtre des mots-clés
    for mcf, value in list(kwcata.items()):
        if not keep_compor(mcf):
            del kwcata[mcf]
            continue
        if type(value) not in (list, tuple):
            value = [value, ]
        if type(value) in (list, tuple) and len(value) != 1:
            UTMESS('F', 'SUPERVIS2_7', valk=(bnmat, mcf))
        for occ in value:
            if occ.get(EXTR) in (None, extract):
                if occ.get(EXTR) is not None:
                    del occ[EXTR]
            else:
                del kwcata[mcf]
    MAT = DEFI_MATERIAU(**kwcata)
    return MAT
