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
   Ce module contient la classe mixin JDC qui porte les méthodes
   nécessaires pour réaliser la validation d'un objet de type JDC
   dérivé de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilisée par héritage multiple pour composer les traitements.
"""
# Modules EFICAS
import V_MCCOMPO
from Noyau.N_Exception import AsException
from Noyau.N_utils import AsType
from Noyau.strfunc import ufmt


class JDC(V_MCCOMPO.MCCOMPO):

    """
    """

    def report(self):
        """
            Methode pour generation d un rapport de validite
        """
        self.cr.purge()
        self.cr.debut = "DEBUT CR validation : " + self.nom
        self.cr.fin = "FIN CR validation :" + self.nom
        for e in self.etapes:
            if e.isactif():
                self.cr.add(e.report())
        self.state = 'modified'
        self.isvalid(cr='oui')
        return self.cr

    def isvalid(self, cr='non'):
        """
          Méthode booléenne qui retourne 0 si le JDC est invalide, 1 sinon
        """
        # FR : on prend en compte l'état du JDC ('unchanged','modified','undetermined')
        # afin d'accélérer le test de validité du JDC
        if self.state == 'unchanged':
            return self.valid
        else:
            valid = 1
            texte, test = self.verif_regles()
            if test == 0:
                if cr == 'oui':
                    self.cr.fatal(' '.strip(texte))
                valid = 0
            if valid:
                for e in self.etapes:
                    if not e.isactif():
                        continue
                    if not e.isvalid():
                        valid = 0
                        break
            self.state = "unchanged"
            self.valid = valid
            return self.valid

    def verif_regles(self):
        """
        Effectue la vérification de validité des règles du jeu de commandes
        """
        noms_etapes = [etape.nom for etape in self.etapes]
        texte_global = ''
        test_global = 1
        for regle in self.regles:
            texte, test = regle.verif(noms_etapes)
            texte_global = texte_global + texte
            test_global = test_global * test
        return texte_global, test_global
