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


    7 : _(u"""
 pas d'orthotropie non linéaire
"""),

    8 : _(u"""
 loi de comportement hyper-élastique non prévue
"""),


    10 : _(u"""
 COMP1D et SIMO_MIEHE incompatibles
"""),

    61 : _(u"""
 option  %(k1)s  non traitée
"""),

    63 : _(u"""
 pas existence de solution pour le saut
"""),

    64 : _(u"""
 existence d'un élément à discontinuité trop grand
 non unicité du saut
"""),

    65 : _(u"""
 non convergence du NEWTON pour le calcul du saut numéro 1
"""),

    66 : _(u"""
 non convergence du NEWTON pour le calcul du saut numéro 2
"""),

    67 : _(u"""
 non convergence du NEWTON pour le calcul du saut numéro 3
"""),

    68 : _(u"""
 erreur dans le calcul du saut
"""),

    69 : _(u"""
 loi %(k1)s  non implantée pour les éléments discrets
"""),





    74 : _(u"""
  valeur de D_SIGM_EPSI non trouvée
"""),

    75 : _(u"""
  valeur de SY non trouvée
"""),

    76 : _(u"""
 développement non implanté
"""),

    80 : _(u"""
 loi de comportement avec irradiation, le paramètre PHI_ZERO doit être supérieur à 0
"""),

    81 : _(u"""
 loi de comportement avec irradiation, le paramètre phi/K.PHI_ZERO+L doit être supérieur ou égal à 0
"""),

    82 : _(u"""
 loi de comportement avec irradiation, le paramètre phi/K.PHI_ZERO+L vaut 0. Dans ces conditions le paramètre BETA doit être positif ou nul
"""),

    98 : _(u"""
 il faut déclarer FONC_DESORP sous ELAS_FO pour le fluage de dessiccation
 intrinsèque avec SECH comme paramètre
"""),

}
