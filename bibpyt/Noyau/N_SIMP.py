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


""" Ce module contient la classe de definition SIMP
    qui permet de spécifier les caractéristiques des mots clés simples
"""

import types

import N_ENTITE
import N_MCSIMP
from strfunc import ufmt


class SIMP(N_ENTITE.ENTITE):

    """
     Classe pour definir un mot cle simple

     Cette classe a deux attributs de classe

     - class_instance qui indique la classe qui devra etre utilisée
             pour créer l'objet qui servira à controler la conformité d'un
             mot-clé simple avec sa définition

     - label qui indique la nature de l'objet de définition (ici, SIMP)

    """
    class_instance = N_MCSIMP.MCSIMP
    label = 'SIMP'

    def __init__(self, typ, fr="", statut='f', into=None, defaut=None,
                 min=1, max=1, homo=1, position=None,
                 val_min='**', val_max='**', docu="", validators=None,
                 sug=None, inout=None):
        """
            Un mot-clé simple est caractérisé par les attributs suivants :
            - type : cet attribut est obligatoire et indique le type de valeur attendue
            - fr : chaîne documentaire en français
            - statut : obligatoire ou facultatif ou caché
            - into : valeurs autorisées
            - defaut : valeur par défaut
            - min : nombre minimal de valeurs
            - max : nombre maximal de valeurs
            - homo : ?
            - position : si global, le mot-clé peut-être lu n'importe où dans la commande
            - val_min : valeur minimale autorisée
            - val_max : valeur maximale autorisée
            - docu : ?
            - sug : ?
            - inout : statut de l'unité logique pour un fichier in ou out
        """
        N_ENTITE.ENTITE.__init__(self, validators)
        # Initialisation des attributs
        if type(typ) == types.TupleType:
            self.type = typ
        else:
            self.type = (typ,)
        self.fr = fr
        self.statut = statut
        self.into = into
        self.defaut = defaut
        self.min = min
        self.max = max
        self.homo = homo
        self.position = position
        self.val_min = val_min
        self.val_max = val_max
        self.docu = docu
        self.sug = sug
        self.inout = inout

    def verif_cata(self, nom=None):
        """
            Cette methode sert à valider les attributs de l'objet de définition
            de la classe SIMP
            La vérification est réalisée dans le test vocab01a
        """
        self.check_min_max()
        self.check_fr()
        self.check_statut()
        self.check_homo()
        self.check_into()
        self.check_position()
        self.check_validators()
        self.check_defaut()
        self.check_inout()
        self.check_unit(nom)

    def __call__(self, val, nom, parent=None):
        """
            Construit un objet mot cle simple (MCSIMP) a partir de sa definition (self)
            de sa valeur (val), de son nom (nom) et de son parent dans l arboresence (parent)
        """
        return self.class_instance(nom=nom, definition=self, val=val, parent=parent)

    def check_statut(self, into=('o', 'f', 'c')):
        """Vérifie l'attribut statut."""
        N_ENTITE.ENTITE.check_statut(self, into)
