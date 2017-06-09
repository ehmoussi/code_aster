# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

_root = None
_cata = None
debug = 0
from Noyau.N_info import message, SUPERV

# Le "current step" est l'étape courante.
# Une macro se déclare étape courante dans sa méthode Build avant de construire
# ses étapes filles ou dans BuildExec avant de les exécuter.
# Les étapes simples le font aussi : dans Execute et BuildExec.
# (Build ne fait rien pour une étape)


def set_current_step(step):
    """
       Fonction qui permet de changer la valeur de l'étape courante
    """
    global _root
    if _root:
        raise Exception("Impossible d'affecter _root. Il devrait valoir None")
    _root = step
    # message.debug(SUPERV, "current_step = %s", step and step.nom,
    # stack_id=-1)


def get_current_step():
    """
       Fonction qui permet d'obtenir la valeur de l'étape courante
    """
    return _root


def unset_current_step():
    """
       Fonction qui permet de remettre à None l'étape courante
    """
    global _root
    _root = None


def set_current_cata(cata):
    """
       Fonction qui permet de changer l'objet catalogue courant
    """
    global _cata
    if _cata:
        raise Exception("Impossible d'affecter _cata. Il devrait valoir None")
    _cata = cata


def get_current_cata():
    """
       Fonction qui retourne l'objet catalogue courant
    """
    return _cata


def unset_current_cata():
    """
       Fonction qui permet de remettre à None le catalogue courant
    """
    global _cata
    _cata = None
