# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

from code_aster import _

cata_msg = {

    1 : _("""
  Il faut autant de nom pour NOM_CHAM_MED que pour NOM_CHAM.
"""),

    5 : _("""
 Le mot-clé RESTREINT n'est pas autorisé dans EXTR_RESU en reuse.
"""),

    6 : _("""
  Aucune maille n'a été trouvée avec le critère donné.

Conseil :
  Il faut vérifier votre critère ou le supprimer.
"""),

    7 : _("""
Le filtre TYPE_MAILLE a éliminée %(i1)d mailles .
"""),

    8 : _("""
  Aucune maille n'a été trouvée avec le critère donné dans la commande TYPE_MAILLE.
  Vérifiez la dimension du groupe de mailles utilisé.
"""),

    35 : _("""
   désolé on ne sait pas écrire les champs aux noeuds de représentation constante et a valeurs complexes au format  %(k1)s
"""),

    40 : _("""
 aucune des composantes demandées sous le mot-clé NOM_CMP pour l'impression du CHAM_GD  %(k1)s  n'est présente dans la grandeur  %(k2)s
"""),

    41 : _("""
 aucune des composantes demandées sous le mot-clé NOM_CMP pour l'impression du champ  %(k1)s  du concept  %(k2)s  n'est présente dans la grandeur  %(k3)s
"""),

    46 : _("""
  numéro d'ordre  %(k1)s  non licite
"""),

    51 : _("""
 type de structure non traite:  %(k1)s
"""),

    52 : _("""
 on imprime que des champs ELNO
"""),

    53 : _("""
 nombre de composantes différent
"""),

    54 : _("""
 composante inconnue %(k1)s
"""),

    55 : _("""
 L'ordre des composantes établi lorsque que vous avez renseigné le mot-clé
 NOM_CMP est différent de celui du catalogue Aster:
    - ordre des composantes fournies     : %(k1)s %(k2)s %(k3)s %(k4)s %(k5)s %(k6)s
    - ordre des composantes du catalogue : %(k7)s %(k8)s %(k9)s %(k10)s %(k11)s %(k12)s
"""),

    56 : _("""
 on imprime que des champs "ELGA" ou "ELEM"
"""),

    57 : _("""
 nombre de sous-points différent de 1
"""),

    58 : _("""
 pas de correspondance
"""),

    59 : _("""
 aucun champ trouve, pas d'impression au format "GMSH"
"""),

    60 : _("""
 On ne sait pas imprimer au format "GMSH" le champ %(k1)s
 car il est de type %(k2)s.
"""),

    61 : _("""
 erreur de programmation : nombre de composantes différent de 1 ou 3.
"""),

    62 : _("""
 on ne peut pas traiter des éléments a plus de 99 noeuds !
"""),

    63 : _("""
 erreur de programmation
"""),

    67 : _("""
 les champs n'ont pas la même grandeur
"""),

    68 : _("""
 les champs n'ont pas la même numérotation
"""),

    69 : _("""
 les champs n'ont pas le même type de valeurs
"""),

    70 : _("""
   désolé on ne sait pas écrire les champs aux noeuds de représentation constante au format IDEAS
"""),




    77 : _("""
 la dimension du problème est invalide : il faut : 1d, 2d, 3d.
"""),

    78 : _("""
 HEXA27 élément inexistant dans IDEAS, converti en HEXA20
"""),

    79 : _("""
 tria7 élément inexistant dans IDEAS, converti en tria6
"""),

    80 : _("""
 QUAD9 élément inexistant dans IDEAS, converti en QUAD8
"""),

    81 : _("""
 SEG4 élément inexistant dans IDEAS, converti en SEG2
"""),

    82 : _("""
 élément PYRAM5 non disponible dans IDEAS
"""),

    83 : _("""
 élément PYRAM13 non disponible dans IDEAS
"""),

    85 : _("""
 L'élément PENTA18 est inexistant dans IDEAS, il est converti en PENTA15.
"""),

    86 : _("""
 L'élément TETRA8 est inexistant dans IDEAS, il est converti en TETRA4.
"""),

    93 : _("""
 on ne sait pas écrire les mailles de type  %(k1)s
"""),

}
