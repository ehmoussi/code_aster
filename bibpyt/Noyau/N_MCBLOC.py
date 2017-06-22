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
    Ce module contient la classe MCBLOC qui sert à controler la valeur
    d'un bloc de mots-clés par rapport à sa définition portée par un objet
    de type ENTITE
"""

import types

import N_MCCOMPO


class MCBLOC(N_MCCOMPO.MCCOMPO):

    """
       Classe support d'un bloc de mots-clés.

    """

    nature = "MCBLOC"

    def __init__(self, val, definition, nom, parent):
        """
           Attributs :

            - val : valeur du bloc (dictionnaire dont les clés sont des noms de mots-clés et les valeurs
                    les valeurs des mots-clés)

            - definition : objet de définition de type BLOC associé au bloc (porte les attributs de définition)

            - nom : nom du bloc. Ce nom lui est donné par celui qui crée le bloc de mot-clé

            - parent : le créateur du bloc. Ce peut etre un mot-clé facteur ou un autre objet composite de type
                       OBJECT. Si parent vaut None, le bloc ne possède pas de contexte englobant.

            - mc_liste : liste des sous-objets du bloc construite par appel à la méthode build_mc

        """
        self.definition = definition
        self.nom = nom
        self.val = val
        self.parent = parent
        self.valeur = val
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

    def get_valeur(self):
        """
           Retourne la "valeur" de l'objet bloc. Il s'agit d'un dictionnaire dont
           les clés seront les noms des objets de self.mc_liste et les valeurs
           les valeurs des objets de self.mc_liste obtenues par application de
           la méthode get_valeur.

           Dans le cas particulier d'un objet bloc les éléments du dictionnaire
           obtenu par appel de la méthode get_valeur sont intégrés au niveau
           supérieur.

        """
        dico = {}
        for mocle in self.mc_liste:
            if mocle.isBLOC():
                # Si mocle est un BLOC, on inclut ses items dans le dictionnaire
                # représentatif de la valeur de self. Les mots-clés fils de blocs sont
                # donc remontés au niveau supérieur.
                dico.update(mocle.get_valeur())
            else:
                dico[mocle.nom] = mocle.get_valeur()

        # On rajoute tous les autres mots-clés locaux possibles avec la valeur
        # par défaut ou None
        # Pour les mots-clés facteurs, on ne traite que ceux avec statut défaut ('d')
        # et caché ('c')
        # On n'ajoute aucune information sur les blocs. Ils n'ont pas de défaut seulement
        # une condition.
        for k, v in self.definition.entites.items():
            if not dico.has_key(k):
                if v.label == 'SIMP':
                    # Mot clé simple
                    dico[k] = v.defaut
                elif v.label == 'FACT':
                    if v.statut in ('c', 'd'):
                        # Mot clé facteur avec défaut ou caché provisoire
                        dico[k] = v(val=None, nom=k, parent=self)
                        # On demande la suppression des pointeurs arrieres
                        # pour briser les eventuels cycles
                        dico[k].supprime()
                    else:
                        dico[k] = None

        return dico

    def isBLOC(self):
        """
            Indique si l'objet est un BLOC
        """
        return 1

    def accept(self, visitor):
        """
           Cette methode permet de parcourir l'arborescence des objets
           en utilisant le pattern VISITEUR
        """
        visitor.visitMCBLOC(self)

    def makeobjet(self):
        return self.definition(val=None,  nom=self.nom, parent=self.parent)
