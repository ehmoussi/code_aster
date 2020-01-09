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

# person_in_charge: nicolas.sellenet@edf.fr
"""
:py:class:`Surface` --- Representation of Surface
**********************************************
"""

import aster
from Cata_Utils.t_fonction import t_fonction, t_nappe
from libaster import DataStructure, Surface

from ..Utilities import injector


@injector(Surface)
class ExtendedSurface(object):
    cata_sdj = "SD.sd_fonction.sd_fonction_aster"

    def convert(self):
        """
        Retourne un objet de la classe t_nappe, représentation python de la nappe
        """
        para = self.Parametres()
        vale = self.Valeurs()
        l_fonc = []
        i = 0
        for pf in para[1]:
            para_f = {'INTERPOL': pf['INTERPOL_FONC'],
                      'PROL_DROITE': pf['PROL_DROITE_FONC'],
                      'PROL_GAUCHE': pf['PROL_GAUCHE_FONC'],
                      'NOM_PARA': para[0]['NOM_PARA_FONC'],
                      'NOM_RESU': para[0]['NOM_RESU'],
                      }
            l_fonc.append(t_fonction(vale[1][i][0], vale[1][i][1], para_f))
            i += 1
        return t_nappe(vale[0], l_fonc, para[0], nom=self.getName())

    def Parametres(self):
        """
        Retourne un dictionnaire contenant les parametres de la nappe,
        le type jeveux (NAPPE) n'est pas retourne,
        le dictionnaire peut ainsi etre fourni a CALC_FONC_INTERP tel quel,
        et une liste de dictionnaire des parametres de chaque fonction.
        """
        prol = self.exportExtensionToPython()
        TypeProl = {'E': 'EXCLU', 'L': 'LINEAIRE', 'C': 'CONSTANT'}
        dico = {
            'INTERPOL': [prol[1][0:3], prol[1][4:7]],
           'NOM_PARA': prol[2][0:16].strip(),
           'NOM_RESU': prol[3][0:16].strip(),
           'PROL_DROITE': TypeProl[prol[4][1]],
           'PROL_GAUCHE': TypeProl[prol[4][0]],
           'NOM_PARA_FONC': prol[6][0:4].strip(),
        }
        lparf = []
        nbf = (len(prol) - 7) // 2
        for i in range(nbf):
            dicf = {
                'INTERPOL_FONC': [prol[7 + i * 2][0:3], prol[7 + i * 2][4:7]],
               'PROL_DROITE_FONC': TypeProl[prol[8 + i * 2][1]],
               'PROL_GAUCHE_FONC': TypeProl[prol[8 + i * 2][0]],
            }
            lparf.append(dicf)
        return [dico, lparf]

    def Valeurs(self):
        """
        Retourne la liste des valeurs du parametre,
        et une liste de couples (abscisses,ordonnees) de chaque fonction.
        """
        values = self.exportValuesToPython()
        parameters = self.exportParametersToPython()
        return [parameters, values]

    def __call__(self, val1, val2, tol=1.e-6):
        """Evaluate a function at 'val'. If provided, 'tol' is a relative
        tolerance to match an abscissa value."""
        # Pour EFICAS : substitution de l'instance de classe
        # parametre par sa valeur
        if isinstance(val1, DataStructure):
            val1 = val1.valeur
        if isinstance(val2, DataStructure):
            val2 = val2.valeur
        __ff = self.convert()
        return __ff(val1, val2, tol=tol)
