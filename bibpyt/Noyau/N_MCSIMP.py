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
    Ce module contient la classe MCSIMP qui sert à controler la valeur
    d'un mot-clé simple par rapport à sa définition portée par un objet
    de type ENTITE
"""

from copy import copy

from Noyau.N_ASSD import ASSD
from Noyau.N_CO import CO
import N_OBJECT
from N_CONVERT import ConversionFactory
from N_types import force_list, is_sequence


class MCSIMP(N_OBJECT.OBJECT):

    """
    """
    nature = 'MCSIMP'

    def __init__(self, val, definition, nom, parent):
        """
           Attributs :

            - val : valeur du mot clé simple

            - definition

            - nom

            - parent

          Autres attributs :

            - valeur : valeur du mot-clé simple en tenant compte de la valeur par défaut

        """
        self.definition = definition
        self.nom = nom
        self.val = val
        self.parent = parent
        self.convProto = ConversionFactory('type', typ=self.definition.type)
        self.valeur = self.GETVAL(self.val)
        if parent:
            self.jdc = self.parent.jdc
            self.niveau = self.parent.niveau
            self.etape = self.parent.etape
        else:
            # Le mot cle simple a été créé sans parent
            self.jdc = None
            self.niveau = None
            self.etape = None

    def GETVAL(self, val):
        """
            Retourne la valeur effective du mot-clé en fonction
            de la valeur donnée. Defaut si val == None
        """
        if (val is None and hasattr(self.definition, 'defaut')):
            val = self.definition.defaut
        if self.convProto:
            val = self.convProto.convert(val)
        return val

    def get_valeur(self):
        """
            Retourne la "valeur" d'un mot-clé simple.
            Cette valeur est utilisée lors de la création d'un contexte
            d'évaluation d'expressions à l'aide d'un interpréteur Python
        """
        v = self.valeur
        # Si singleton et max=1, on retourne la valeur.
        # Si une valeur simple et max='**', on retourne un singleton.
        # (si liste de longueur > 1 et max=1, on sera arrêté plus tard)
        # Pour accepter les numpy.array, on remplace : "type(v) not in (list, tuple)"
        # par "not has_attr(v, '__iter__')".
        if v is None:
            pass
        elif is_sequence(v) and len(v) == 1 and self.definition.max == 1:
            v = v[0]
        elif not is_sequence(v) and self.definition.max != 1:
            v = (v, )
        # traitement particulier pour les complexes ('RI', r, i)
        if 'C' in self.definition.type and self.definition.max != 1 \
                and v[0] in ('RI', 'MP'):
            v = (v, )
        return v

    def get_val(self):
        """
            Une autre méthode qui retourne une "autre" valeur du mot clé simple.
            Elle est utilisée par la méthode get_mocle
        """
        return self.valeur

    def accept(self, visitor):
        """
           Cette methode permet de parcourir l'arborescence des objets
           en utilisant le pattern VISITEUR
        """
        visitor.visitMCSIMP(self)

    def copy(self):
        """ Retourne une copie de self """
        objet = self.makeobjet()
        # il faut copier les listes et les tuples mais pas les autres valeurs
        # possibles (réel,SD,...)
        if type(self.valeur) in (list, tuple):
            objet.valeur = copy(self.valeur)
        else:
            objet.valeur = self.valeur
        objet.val = objet.valeur
        return objet

    def makeobjet(self):
        return self.definition(val=None, nom=self.nom, parent=self.parent)

    def reparent(self, parent):
        """
           Cette methode sert a reinitialiser la parente de l'objet
        """
        self.parent = parent
        self.jdc = parent.jdc
        self.etape = parent.etape

    def get_sd_utilisees(self):
        """
            Retourne une liste qui contient la ou les SD utilisée par self si c'est le cas
            ou alors une liste vide
        """
        l = []
        if isinstance(self.valeur, ASSD):
            l.append(self.valeur)
        elif type(self.valeur) in (list, tuple):
            for val in self.valeur:
                if isinstance(val, ASSD):
                    l.append(val)
        return l

    def get_sd_mcs_utilisees(self):
        """
            Retourne la ou les SD utilisée par self sous forme d'un dictionnaire :
              - Si aucune sd n'est utilisée, le dictionnaire est vide.
              - Sinon, la clé du dictionnaire est le mot-clé simple ; la valeur est
                la liste des sd attenante.

                Exemple ::
                        { 'VALE_F': [ <Cata.cata.fonction_sdaster instance at 0x9419854>,
                                      <Cata.cata.fonction_sdaster instance at 0x941a204> ] }
        """
        l = self.get_sd_utilisees()
        dico = {}
        if len(l) > 0:
            dico[self.nom] = l
        return dico

    def get_mcs_with_co(self, co):
        """
            Cette methode retourne l'objet MCSIMP self s'il a le concept co
            comme valeur.
        """
        if co in force_list(self.valeur):
            return [self, ]
        return []

    def get_all_co(self):
        """
            Cette methode retourne la liste de tous les concepts co
            associés au mot cle simple
        """
        return [co for co in force_list(self.valeur)
                if isinstance(co, CO) and co.is_typco()]
