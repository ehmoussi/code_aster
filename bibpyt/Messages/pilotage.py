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

    1  : _(u"""
 Le pilotage de type PRED_ELAS n'est pas possible en modélisation C_PLAN.
"""),

    2  : _(u"""
 Pour le cas de l'endommagement saturé dans ENDO_ISOT_BETON, on ne pilote pas.
"""),

    3  : _(u"""
 Le paramètre COEF_MULT pour le pilotage ne doit pas valoir zéro.
"""),

    4  : _(u"""
 La recherche linéaire en pilotage n'est possible qu'avec l'option PILOTAGE dans RECH_LINEAIRE  (sauf pour le cas DDL_IMPO).
"""),

    48 : _(u"""
 ETA_PILO_MAX doit être inférieur à ETA_PILO_R_MAX
"""),

    49 : _(u"""
 ETA_PILO_MIN doit être supérieur à ETA_PILO_R_MIN
"""),

    50 : _(u"""
 Il ne faut pas plus d'un noeud pour le pilotage DDL_IMPO.
"""),

    55 : _(u"""
 La liste des directions est vide pour le mot-clef %(k1)s pour le pilotage %(k2)s.
"""),

    56 : _(u"""
 Il faut une et une seule direction pour le mot-clef %(k1)s pour le pilotage de type %(k2)s.
"""),

    57 : _(u"""
 Il faut plus d'un noeud pour le pilotage LONG_ARC.
"""),

    58 : _(u"""
 Renseigner le mot clef FISSURE du mot clef facteur PILOTAGE pour le pilotage
  SAUT_IMPO ou SAUT_L_ARC.
"""),

    59 : _(u"""
 Renseigner le mot-clé FISSURE du mot-clé facteur PILOTAGE avec les sélections
  ANGL_INCR_DEPL ou NORM_INCR_DEPL avec un modèle X-FEM.
"""),

    60 : _(u"""
 Les types de pilotage SAUT_IMPO et SAUT_L_ARC ne sont disponibles qu'avec un
 modèle X-FEM.
"""),

    61 : _(u"""
 Le noeud pilote %(i1)d n appartient pas à une arête intersectée par la fissure
"""),

    62 : _(u"""
 Il y a plus de noeuds utilisateur que d'arêtes vitales.
 Diminuer le nombre de noeuds pilotés.
"""),

    63 : _(u"""
 Les noeuds pilotés %(i1)d et %(i2)d sont deux extrémités d'une arête intersectée.
 Il est conseillé d'entrer des noeuds qui sont tous du même coté de la fissure.
"""),

    64 : _(u"""
 Les noeuds pilotés %(i1)d et %(i2)d sont deux extrémités d'une arête intersectée.
 Il est conseillé d'entrer des noeuds qui sont tous du même coté de la fissure.
"""),

    83 : _(u"""
 Problème lors du pilotage.
 Nombre maximum d'itérations atteint.
"""),

    84 : _(u"""
 Problème lors du pilotage.
 Précision machine dépassée.
"""),

    85 : _(u"""
 Problème lors du pilotage.
 Il y a trois solutions ou plus.
"""),

    86 : _(u"""
 Problème lors du pilotage.
 La matrice locale n'est pas inversible.
"""),

    87 : _(u"""
 Problème lors du pilotage.
"""),

    88 : _(u"""
 La loi de comportement <%(k1)s> n'est pas disponible pour le pilotage de type PRED_ELAS.
"""),

}
