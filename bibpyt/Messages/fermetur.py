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

    1: _(u"""
Le solveur "MUMPS" n'est pas installé dans cette version de Code_Aster.

Conseil : Vérifiez que vous avez sélectionné la bonne version de Code_Aster.
          Attention, certains solveurs ne sont disponibles que dans les versions parallèles de Code_Aster.
"""),

    2: _(u"""
La bibliothèque "MED" n'est pas installée dans cette version de Code_Aster.
"""),

    3: _(u"""
La bibliothèque "HDF5" n'est pas installée dans cette version de Code_Aster.
"""),

    5: _(u"""
Erreur de programmation :
    On essaie d'utiliser un opérateur qui n'est pas encore programmé.
"""),

    # identique au précédent mais il faudrait modifier tous les appelants dans
    # fermetur
    6: _(u"""
Erreur de programmation :
    On essaie d'utiliser un opérateur qui n'est pas encore programmé.
"""),

    7: _(u"""
Le renuméroteur "SCOTCH" n'est pas installé dans cette version de Code_Aster.
"""),

    8: _(u"""
Erreur de programmation :
    On essaie d'utiliser une routine de calcul élémentaire
    qui n'est pas encore programmée.
"""),

    9: _(u"""
Erreur de programmation :
    On essaie d'utiliser une routine d'initialisation élémentaire
    qui n'est pas encore programmée.
"""),

    10: _(u"""
Le solveur "PETSc" n'est pas installé dans cette version de Code_Aster.

Conseil : Vérifiez que vous avez sélectionné la bonne version de Code_Aster.
          Attention, certains solveurs ne sont disponibles que dans les versions parallèles de Code_Aster.
"""),

    11: _(u"""
Erreur de programmation :
    On essaie d'utiliser une routine de comportement
    qui n'est pas encore programmée.
"""),

    12: _(u"""
La bibliothèque "YACS" n'est pas installée dans cette version de Code_Aster.
"""),

    13 : _(u"""
La bibliothèque %(k1)s n'a pas pu être chargée.

Nom de la bibliothèque : %(k2)s

Conseil : Vérifiez que l'environnement est correctement défini,
          notamment la variable LD_LIBRARY_PATH.
"""),

    14 : _(u"""
Le symbole demandé n'a pas été trouvé dans la bibliothèque %(k1)s.

Nom de la bibliothèque : %(k2)s
        Nom du symbole : %(k3)s

Conseil : Vérifiez que l'environnement est correctement défini,
          notamment la variable LD_LIBRARY_PATH.
"""),

    15 : _(u"""
La bibliothèque "METIS" n'est pas installée dans cette version de Code_Aster.
"""),

}
