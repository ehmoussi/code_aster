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

from ..Utilities import _

cata_msg = {

    6 : _("""
 type inconnu" %(k1)s "
"""),

    7 : _("""
 Le fichier correspondant à l'unité logique renseignée pour l'écriture de résultats au format MED
 est de type ASCII. Cela peut engendrer l'affichage de messages intempestifs provenant de la
 bibliothèque MED. Il n'y a toutefois aucun risque de résultats faux.

 Conseils : pour supprimer l'émission de ce message d'alarme, il faut donner la valeur BINARY au
 mot-clé TYPE de DEFI_FICHIER."
"""),

    9 : _("""
 type de base inconnu:  %(k1)s
"""),

    10 : _("""
 soit le fichier n'existe pas, soit c'est une mauvaise version de HDF (utilise par MED).
"""),


    31 : _("""
 on n'a pas trouvé le numéro d'ordre à l'adresse indiquée
"""),

    32 : _("""
 on n'a pas trouvé l'instant à l'adresse indiquée
"""),

    33 : _("""
 on n'a pas trouvé la fréquence à l'adresse indiquée
"""),

    34 : _("""
 on n'a pas trouvé dans le fichier UNV le type de champ
"""),

    35 : _("""
 on n'a pas trouvé dans le fichier UNV le nombre de composantes à lire
"""),

    36 : _("""
 on n'a pas trouvé dans le fichier UNV la nature du champ
 (réel ou complexe)
"""),

    37 : _("""
 le type de champ demandé est différent du type de champ à lire
"""),

    38 : _("""
 le champ demande n'est pas de même nature que le champ à lire
 (réel/complexe)
"""),

    39 : _("""
 le mot clé MODELE est obligatoire pour un CHAM_ELEM
"""),

    40 : _("""
 Problème correspondance noeud IDEAS
"""),

    41 : _("""
 le champ de type ELGA n'est pas supporté
"""),





    75 : _("""
 fichier GIBI créé par SORT FORMAT non supporté dans cette version
"""),

    76 : _("""
 version de GIBI non supportée, la lecture peut échouer
"""),

    77 : _("""
 fichier GIBI erroné
"""),

    78 : _("""
 le fichier maillage GIBI est vide
"""),

    81 : _("""
 Il n'a pas été possible de récupérer d'information concernant la matrice de masse
 assemblée de la structure. Le calcul de l'option %(k1)s n'est donc pas possible.
 """),

    84 : _("""
Il manque interspectre NUME_ORDRE_I : %(i1)d
                       NUME_ORDRE_J : %(i2)d
dans la matrice interspectrale : %(k1)s
"""),

    85 : _("""
Il manque interspectre NOEUD_I/NOM_CMP_I : %(k1)s,%(k2)s
                       NOEUD_J/NOM_CMP_J : %(k3)s,%(k4)s
dans la matrice interspectrale : %(k5)s
"""),

    93 : _("""
 la fonction n'existe pas.
"""),

    94 : _("""
 il faut définir deux paramètres pour une nappe.
"""),

    95 : _("""
 pour le paramètre donné on n'a pas trouvé la fonction.
"""),

    96 : _("""
 Pour les calculs harmoniques, la version actuelle du code ne permet pas de
 restreindre l'estimation de REAC_NODA sur un groupe de mailles.
"""),


}
