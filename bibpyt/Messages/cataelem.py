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
 l option :  %(k1)s  est probablement composée (vieillot)
"""),

    2: _(u"""
 l option :  %(k1)s  a plusieurs paramètres de mêmes noms.
"""),

    3: _(u"""
 mode local incorrect
 pour le paramètre:  %(k1)s
 pour l'option    :  %(k2)s
 pour le type     :  %(k3)s
"""),

    4: _(u"""
 le paramètre :  %(k1)s  pour l'option :  %(k2)s
 existe pour le type :  %(k3)s mais n'existe pas dans l'option.
"""),

    5: _(u"""
 le paramètre :  %(k1)s  pour l'option :  %(k2)s  et pour le TYPE_ELEMENT :  %(k3)s
 n'est pas associe à la bonne grandeur.
"""),

    6: _(u"""
 le paramètre :  %(k1)s  pour l'option :  %(k2)s  et pour le TYPE_ELEMENT :  %(k3)s
 n'a pas le bon nombre de noeuds.
"""),

    7: _(u"""
 le paramètre :  %(k1)s  pour l option :  %(k2)s  et pour le TYPE_ELEMENT :  %(k3)s
 n'est pas du bon type:  %(k4)s
"""),

    8: _(u"""
 les grandeurs : %(k1)s  et  %(k2)s  doivent avoir exactement les mêmes composantes.
"""),

    9: _(u"""
 erreurs de cohérence dans les catalogues d'éléments finis.
"""),

    20: _(u"""
 Erreur lors de l'accès à la composante %(i1)d dans le champ de nom %(k1)s et de type %(k2)s.
 Les arguments sont hors bornes ou la composante est déjà affectée (écrasement).
 Contactez le support.
"""),

}
