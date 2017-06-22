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

cata_msg = {

    1 : _(u"""
Aucun noeud n'est apparié. Cette alarme peut entraîner des résultats faux si elle apparaît dans la résolution du contact en Newton généralisé.
Conseils :
1. On préconise d'utiliser CONTACT_INIT='OUI' pour initialiser le contact en tout point de la zone
2. Vérifiez la définition de vos surfaces ou de vos paramètres d'appariement
3. Vérifier TOLE_PROJ_EXT (prolongement fictif de la maille maître).
4. Vérifier les déplacements induits par votre modélisation.
5. Si l'alarme persiste, changez d'algorithme avec ALGO_RESO_GEOM='POINT_FIXE' dans DEFI_CONTACT
"""),

    13 : _(u"""
L'algorithme de Newton a échoué lors de la projection du point de coordonnées
  (%(r1)f,%(r2)f,%(r3)f)
sur la maille %(k1)s.
Erreur de définition de la maille ou projection difficile.
"""),

    14 : _(u"""
Les vecteurs tangents sont nuls au niveau du projeté du noeud %(k2)s sur la maille %(k1)s.
Erreur de définition de la maille ou projection difficile.
"""),

    15 : _(u"""
Le vecteur normal est nul au niveau du noeud %(k2)s sur la maille %(k1)s.
Erreur de définition de la maille ou projection difficile.
"""),

    16 : _(u"""
Le vecteur normal résultant est nul au niveau du noeud %(k1)s.
Erreur de définition de la maille ou projection difficile.
"""),

    17 : _(u"""
Les vecteurs tangents résultants sont nuls au niveau du noeud %(k1)s.
Erreur de définition de la maille ou projection difficile.
"""),

    34 : _(u"""
Échec de l'orthogonalisation du repère tangent construit au niveau du projeté du point de coordonnées
  (%(r1)f,%(r2)f,%(r3)f)
sur la maille %(k1)s,
Erreur de définition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

    36 : _(u"""
La maille %(k1)s est de type 'POI1', ce n'est pas autorisé sur une maille maître dans le cas d'un appariement MAIT_ESCL.
"""),

    38 : _(u"""
La maille %(k1)s est de type poutre et sa tangente est nulle.
Vérifiez votre maillage.
"""),

    61 : _(u"""
La maille %(k1)s est de type poutre, elle nécessite la définition d'une base locale.
"""),

    62 : _(u"""
La maille %(k1)s est de type 'POI1', elle nécessite la définition explicite de sa normale.
"""),

    63 : _(u"""
La maille %(k1)s est de type 'POI1', elle nécessite la définition explicite d'une normale non nulle.
"""),

    75 : _(u"""
Un élément de type POI1 ne peut pas être une maille maître.
"""),


}
