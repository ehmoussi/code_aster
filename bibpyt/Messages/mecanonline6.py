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

# Attention a ne pas faire de retour à la ligne !

cata_msg = {

    1 : _(u"""
 Instant de calcul: %(r1)19.12e - Niveau de découpe: %(i1)d
"""),

    2 : _(u"""
 Post-traitement: calcul d'un mode de flambement
"""),

    3 : _(u"""
 Post-traitement: calcul d'un mode vibratoire
"""),

    4 : _(u"""
 La gestion automatique du pas de temps (DEFI_LIST_INST/METHODE='AUTO')
 avec le schéma IMPLEX (DEFI_LIST_INST/MODE_CALCUL_TPLUS='IMPLEX') nécessite
 de traiter la résolution par la méthode IMPLEX (STAT/DYNA_NON_LINE/METHODE='IMPLEX').
 Conseil :
   - Choisissez STAT/DYNA_NON_LINE/METHODE='IMPLEX'
   - ou bien choisissez un autre schéma d'adaptation du pas de temps (DEFI_LIST_INST/MODE_CALCUL_TPLUS).
 """),

    5 : _(u"""
 Nombre total de noeuds esclaves pour le contact: %(i1)d
"""),

    6 : _(u"""
 Instant de calcul: %(r1)19.12e
"""),

    7 : _(u"""
 Nombre total de macro-éléments pour le contact: %(i1)d soit %(i2)d éléments en contact.
"""),

    10 : _(u"""
  Le mode vibratoire de numéro d'ordre %(i1)d a pour fréquence %(r1)19.12e
"""),

    11 : _(u"""
  Le mode de flambement de numéro d'ordre %(i1)d a pour charge critique %(r1)19.12e
"""),

    12 : _(u"""
  Le mode de stabilité de numéro d'ordre %(i1)d a pour charge critique %(r1)19.12e
"""),

    13 : _(u"""
 On ne peut pas utiliser CRIT_STAB en calcul parallèle
"""),

    14 : _(u"""
  Le mode vibratoire stocké a pour fréquence %(r1)19.12e
"""),

    15 : _(u"""
  Le mode de flambement stocké a pour charge critique %(r1)19.12e
"""),

    16 : _(u"""
  Le mode de stabilité stocké a pour charge critique %(r1)19.12e
"""),

    60 : _(u"""
  Critère(s) de convergence atteint(s)
"""),

    61 : _(u"""
      Attention ! Convergence atteinte avec RESI_GLOB_RELA car on est au premier instant avec RESI_COMP_RELA.
"""),

    62 : _(u"""
      Attention ! Convergence atteinte avec RESI_GLOB_MAXI au lieu de RESI_GLOB_RELA pour cause de chargement presque nul.
"""),

    70 : _(u"""    Le résidu de type <%(k1)s> vaut %(r1)19.12e au noeud et degré de liberté <%(k2)s>"""),


}
