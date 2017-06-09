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
   Ce module contient la classe mixin PROC_ETAPE qui porte les méthodes
   nécessaires pour réaliser la validation d'un objet de type PROC_ETAPE
   dérivé de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilisée par héritage multiple pour composer les traitements.
"""
# Modules EFICAS
import V_ETAPE
from Noyau.N_Exception import AsException
from Noyau.N_utils import AsType
from Noyau.strfunc import ufmt


class PROC_ETAPE(V_ETAPE.ETAPE):

    """
       On réutilise les méthodes report,verif_regles
       de ETAPE par héritage.
    """

    def isvalid(self, sd='oui', cr='non'):
        """
           Methode pour verifier la validité de l'objet PROC_ETAPE. Cette méthode
           peut etre appelée selon plusieurs modes en fonction de la valeur
           de sd et de cr (sd n'est pas utilisé).

           Si cr vaut oui elle crée en plus un compte-rendu.

           Cette méthode a plusieurs fonctions :

            - retourner un indicateur de validité 0=non, 1=oui

            - produire un compte-rendu : self.cr

            - propager l'éventuel changement d'état au parent
        """
        if CONTEXT.debug:
            print "ETAPE.isvalid ", self.nom
        if self.state == 'unchanged':
            return self.valid
        else:
            valid = self.valid_child()
            valid = valid * self.valid_regles(cr)
            if self.reste_val != {}:
                if cr == 'oui':
                    self.cr.fatal(
                        _(u"Mots clés inconnus : %s"), ','.join(self.reste_val.keys()))
                valid = 0
            self.set_valid(valid)
            return self.valid
