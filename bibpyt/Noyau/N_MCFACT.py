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
    Ce module contient la classe MCFACT qui sert à controler la valeur
    d'un mot-clé facteur par rapport à sa définition portée par un objet
    de type ENTITE
"""

import N_MCCOMPO


class MCFACT(N_MCCOMPO.MCCOMPO):

    """
    """
    nature = "MCFACT"

    def __init__(self, val, definition, nom, parent):
        """
           Attributs :
            - val : valeur du mot clé simple
            - definition
            - nom
            - parent
        """
        self.definition = definition
        self.nom = nom
        self.val = val
        self.parent = parent
        self.valeur = self.GETVAL(self.val)
        if parent:
            self.jdc = self.parent.jdc
            self.niveau = self.parent.niveau
            self.etape = self.parent.etape
        else:
            # Le mot cle a été créé sans parent
            self.jdc = None
            self.niveau = None
            self.etape = None
        self.mc_liste = self.build_mc()

    def GETVAL(self, val):
        """
            Retourne la valeur effective du mot-clé en fonction
            de la valeur donnée. Defaut si val == None
        """
        if (val is None and hasattr(self.definition, 'defaut')):
            return self.definition.defaut
        else:
            return val

    def get_valeur(self):
        """
            Retourne la "valeur" d'un mot-clé facteur qui est l'objet lui-meme.
            Cette valeur est utilisée lors de la création d'un contexte
            d'évaluation d'expressions à l'aide d'un interpréteur Python
        """
        return self

    def get_val(self):
        """
            Une autre méthode qui retourne une "autre" valeur du mot clé facteur.
            Elle est utilisée par la méthode get_mocle
        """
        return [self]

    def __getitem__(self, key):
        """
            Dans le cas d un mot cle facteur unique on simule une liste de
            longueur 1
        """
        if key == 0:
            return self
        return self.get_mocle(key)

    def accept(self, visitor):
        """
           Cette methode permet de parcourir l'arborescence des objets
           en utilisant le pattern VISITEUR
        """
        visitor.visitMCFACT(self)

    def makeobjet(self):
        return self.definition.class_instance(val=None, nom=self.nom,
                                              definition=self.definition, parent=self.parent)

    def List_F(self):
        """Identique à `MCList.List_F()` pour une occurrence unique."""
        return [self.cree_dict_toutes_valeurs(), ]
