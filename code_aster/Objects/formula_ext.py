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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`Function` --- Function object
****************************************
"""

from libaster import Formula

from ..Utilities import deprecated, force_list


class injector(object):
    class __metaclass__(Formula.__class__):
        def __init__(self, name, bases, dict):
            for b in bases:
                if type(b) not in (self, type):
                    for k, v in dict.items():
                        setattr(b, k, v)
            return type.__init__(self, name, bases, dict)


class ExtendedFormula(injector, Formula):
    cata_sdj = "SD.sd_fonction.sd_formule"

    def __call__(self, *val):
        """Evaluation of the formula.

        Arguments:
            val (list[float]): List of the values of the parameters.

        Returns:
            float: Value of the formula for these parameters.
        """
        result = self.evaluate(force_list(val))
        if self.getType() == "FORMULE_C":
            result = complex(*result)
        else:
            result = result[0]
        return result

    @property
    @deprecated(help="Use 'getVariables()' instead.")
    def nompar(self):
        """Return the variables names."""
        return self.getVariables()

    def Parametres(self):
        """
        Retourne un dictionnaire contenant les parametres de la fonction ;
        le type jeveux (FONCTION, FONCT_C, NAPPE) n'est pas retourne,
        le dictionnaire peut ainsi etre fourni a CALC_FONC_INTERP tel quel.
        """
        from Utilitai.Utmess import UTMESS
        prol = self.sdj.PROL.get()
        if prol == None:
            objev = '%-19s.PROL' % self.get_name()
            UTMESS('F', 'SDVERI_2', valk=[objev])
        dico = {
            'INTERPOL': ['LIN', 'LIN'],
            'NOM_PARA': [i.strip() for i in self.sdj.NOVA.get()],
            'NOM_RESU': prol[3][0:16].strip(),
            'PROL_DROITE': "EXCLU",
            'PROL_GAUCHE': "EXCLU",
        }
        return dico
