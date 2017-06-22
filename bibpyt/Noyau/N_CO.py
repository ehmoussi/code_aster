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


from N_ASSD import ASSD
from N_Exception import AsException
from N_VALIDATOR import ValError
import N_utils

from asojb import AsBase


class CO(ASSD, AsBase):

    def __init__(self, nom):
        ASSD.__init__(self, etape=None, sd=None, reg='oui')
        self._as_co = 1
        #
        #  On demande le nommage du concept
        #
        if self.parent:
            try:
                self.parent.NommerSdprod(self, nom)
            except AsException, e:
                appel = N_utils.callee_where(niveau=2)
                raise AsException(
                    "Concept CO, fichier: ", appel[1], " ligne : ", appel[0], '\n', e)
        else:
            self.nom = nom

    def __convert__(cls, valeur):
        if valeur.is_typco():
            return valeur
        raise ValError("Pas un concept CO")
    __convert__ = classmethod(__convert__)
