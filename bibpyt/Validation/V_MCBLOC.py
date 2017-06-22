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
   Ce module contient la classe mixin MCBLOC qui porte les méthodes
   nécessaires pour réaliser la validation d'un objet de type MCBLOC
   dérivé de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilisée par héritage multiple pour composer les traitements.
"""
# Modules EFICAS
import V_MCCOMPO
from Noyau.strfunc import ufmt


class MCBLOC(V_MCCOMPO.MCCOMPO):

    """
       Cette classe a un attribut de classe :

       - txt_nat qui sert pour les comptes-rendus liés à cette classe
    """

    txt_nat = u"Bloc :"

    def isvalid(self, sd='oui', cr='non'):
        """
           Methode pour verifier la validité du MCBLOC. Cette méthode
           peut etre appelée selon plusieurs modes en fonction de la valeur
           de sd et de cr.

           Si cr vaut oui elle crée en plus un compte-rendu
           sd est présent pour compatibilité de l'interface mais ne sert pas
        """
        if self.state == 'unchanged':
            return self.valid
        else:
            valid = 1
            if hasattr(self, 'valid'):
                old_valid = self.valid
            else:
                old_valid = None
            for child in self.mc_liste:
                if not child.isvalid():
                    valid = 0
                    break
            # Après avoir vérifié la validité de tous les sous-objets, on vérifie
            # la validité des règles
            text_erreurs, test_regles = self.verif_regles()
            if not test_regles:
                if cr == 'oui':
                    self.cr.fatal(
                        _(u"Règle(s) non respectée(s) : %s"), text_erreurs)
                valid = 0
            self.valid = valid
            self.state = 'unchanged'
            if not old_valid or old_valid != self.valid:
                self.init_modif_up()
            return self.valid
