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
# Modules Python
import string
import types

# Modules Eficas
from Noyau.N_MCSIMP import MCSIMP
from Noyau.N_MCFACT import MCFACT
from Noyau.N_MCBLOC import MCBLOC
from Noyau.N_MCLIST import MCList
from Noyau.N_Exception import AsException


class OBJECT:

    """
    """

    def getfac(self, nom_motfac):
        """
            Method : MCBLOC.getfac
            Auteur : Antoine Yessayan
            Intention : Rechercher le nombre d'occurences d'un mot-cle de nom
                        nom_motcle parmi les fils d'un MCBLOC.
                        Cette methode est appelee par
                        EXECUTION.getfac (commandes.py)
        """
        nomfac = string.strip(nom_motfac)
        taille = 0
        # On cherche d'abord dans les mots cles presents a l'exclusion des
        # BLOCs
        for child in self.mc_liste:
            if child.nom == nomfac:
                if isinstance(child, MCFACT):
                    taille = 1
                    return taille
                elif isinstance(child, MCList):
                    taille = len(child.data)
                    return taille
                else:
                    raise AsException("incoherence de type dans getfac")

        # Ensuite on cherche dans les eventuels defauts
        # Recherche dans la definition de l'existence d'une occurrence du mot-cle de nom
        # nomfac.
        if taille == 0:
            assert(hasattr(self, 'definition'))
            assert(hasattr(self.definition, 'entites'))
            if self.definition.entites.has_key(nomfac):
                assert(
                    type(self.definition.entites[nomfac]) == types.InstanceType)
                assert(hasattr(self.definition.entites[nomfac], 'statut'))
                if self.definition.entites[nomfac].statut == 'd':
                    taille = 1
                    return taille

        # Enfin on explore les BLOCs
        for child in self.mc_liste:
            if isinstance(child, MCBLOC):
                taille = child.getfac(nom_motfac)
                if taille:
                    break
        return taille

    def getlfact(self):
        """
            Retourne :
              la liste des noms de mots cles facteur sous l etape
        """
        liste = []
        for child in self.mc_liste:
            if isinstance(child[0], MCFACT):
                liste.append(child[0].nom)
            elif isinstance(child, MCBLOC):
                liste = liste + child.getlfact()
        return liste

    def getlsimp(self):
        """
            Retourne :
              la liste des noms de mots cles simples sous self
        """
        liste = []
        for child in self.mc_liste:
            if isinstance(child, MCSIMP):
                liste.append(child)
            elif isinstance(child, MCBLOC):
                liste = liste + child.getlsimp()
        return liste
