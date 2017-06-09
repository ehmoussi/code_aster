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

"""Module permettant de produire le fichier des options pour Miss3D (OPTMIS).
"""

import os

import aster
from Miss.miss_utils import dict_format

sfmt = dict_format['sR']


def fichier_option(param):
    """Produit le contenu du fichier OPTMIS à partir des paramètres du calcul."""
    content = []
    # fréquences
    if param['LIST_FREQ']:
        nb = len(param['LIST_FREQ'])
        content.append("LFREQ %d" % nb)
        fmt = (sfmt * nb).strip()
        content.append(fmt % tuple(param['LIST_FREQ']))
    else:
        fmt = "FREQ" + 3 * sfmt
        content.append(fmt %
                       (param['FREQ_MIN'], param['FREQ_MAX'], param['FREQ_PAS']))
    # Z0
    content.append(("Z0" + sfmt) % param['Z0'])
    # SURF / ISSF
    if param['SURF'] == "OUI":
        content.append("SURF")
    if param['ISSF'] == "OUI":
        content.append("ISSF")
    # type binaire/ascii
    if param['TYPE'] == "BINAIRE":
        content.append("BINA")
    # RFIC
    if param['RFIC'] != 0.:
        content.append(("RFIC" + sfmt) % param['RFIC'])
    # terminer le fichier par un retour chariot
    content.append("")
    return os.linesep.join(content)
