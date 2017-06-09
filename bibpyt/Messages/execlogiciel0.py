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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {
    1 : _(u"""
Format SALOME, l'argument 1 doit être le nom du fichier MED produit
par le script SALOME. Les autres arguments ne sont pas utilisés.
"""),

    2 : _(u"""
On ne sait pas traiter le format %(k1)s
"""),

    3 : _(u"""
Code retour incorrect (MAXI %(i1)d) : %(i2)d

"""),

    6 : _(u"""
Le fichier %(k1)s n'existe pas.
"""),

    8 : _(u"""
 Commande :
   %(k1)s
"""),

    9 : _(u"""
----- Sortie standard (stdout) ---------------------------------------------------
%(k1)s
----- fin stdout -----------------------------------------------------------------
"""),

    10 : _(u"""
----- Sortie erreur standard (stderr) --------------------------------------------
%(k1)s
----- fin stderr -----------------------------------------------------------------
"""),

    11 : _(u"""
 Code retour = %(i2)d      (maximum toléré : %(i1)d)
"""),

    24 : _(u"""
Le nom du répertoire contenant les outils externes est trop long pour être stocké
dans la variable prévue (de longueur %(i1)d).

Conseil :
    - Vous pouvez déplacer/copier les outils dans un autre répertoire de nom plus court
      et utiliser l'argument optionnel "-rep_outils /nouveau/chemin" pour contourner
      le problème.
"""),

}
