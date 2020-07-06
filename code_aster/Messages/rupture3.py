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

    1 : _("""
Vérification des paramètres d'entrée
"""),

    2 : _("""
Calcul du champ thêta
"""),

    3 : _("""
Les rayons inférieur et supérieur pour le calcul de thêta ne sont pas valables. Ils doivent être positifs et le rayon inférieur doit être strictement plus petit que le rayon supérieur:
    Rayon inférieur: %(r1)f
    Rayon supérieur: %(r2)f
"""),

    4 : _("""
Le nombre de couches d'élément inférieur et supérieur pour le calcul de thêta ne sont pas valables. Ils doivent être positifs et le nombre de couches inférieur doit être strictement plus petit que le nombre de couches supérieur:
    Nombre de couches inférieur: %(i1)d
    Nombre de couches supérieur: %(i2)d
"""),

    5 : _("""
Calcul de l'option: %(k1)s
"""),

    6: _("""
Dans le cas d'une structure de données résultat de type DYNA_TRANS ou MODE_MECA,
le mot-clé EXCIT est obligatoire.
Veuillez le renseigner.
"""),

    7: _("""
Dans le cas d'une structure de données résultat de type EVOL_ELAS ou EVOL_NOLI,
le mot-clé EXCIT est interdit. Le chargement sera directement lu dans las structure de donnée RESULTAT
Veuillez l'enlever.
"""),

    8: _("""
Le modèle et la fissure ne sont pas tout les deux FEM ou XFEM. Un mélange FEM-XFEM n'est pas autorisé.

Conseil: Vérifiez votre mise en donnée
"""),

}
