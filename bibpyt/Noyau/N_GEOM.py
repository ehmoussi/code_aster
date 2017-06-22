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


"""

"""
from N_ASSD import ASSD


class GEOM(ASSD):

    """
       Cette classe sert à définir les types de concepts
       géométriques comme GROUP_NO, GROUP_MA,NOEUD et MAILLE

    """

    def __init__(self, nom, etape=None, sd=None, reg='oui'):
        """
        """
        self.etape = etape
        self.sd = sd
        if etape:
            self.parent = etape.parent
        else:
            self.parent = CONTEXT.get_current_step()
        if self.parent:
            self.jdc = self.parent.get_jdc_root()
        else:
            self.jdc = None

        if not self.parent:
            self.id = None
        elif reg == 'oui':
            self.id = self.parent.reg_sd(self)
        self.nom = nom

    def get_name(self):
        return self.nom

    def __convert__(cls, valeur):
        if isinstance(valeur, (str, unicode)) and len(valeur.strip()) <= 8:
            return valeur.strip()
        raise ValueError(
            _(u'On attend une chaine de caractères (de longueur <= 8).'))
    __convert__ = classmethod(__convert__)


class geom(GEOM):
    pass
