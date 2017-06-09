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
 Un instant demandé dans POST_ELEM, option CHAR_LIMITE n'est pas présent dans le résultat <%(k1)s>.
"""),

    2: _(u"""
 L'utilisation d'une liste de coefficients COEF_MULT dans POST_ELEM option NORME n'est valable que pour un
 champ de type NEUT_R.
"""),

    3: _(u"""
 Le résultat <%(k1)s> utilisé dans POST_ELEM, option CHAR_LIMITE n'a pas été produit par un STAT_NON_LINE avec pilotage.
 Vérifiez que vous utilisez le bon résultat.
"""),

    4: _(u"""
 Avec le mot-clé RESULTAT, il faut renseigner NOM_CHAM pour identifier le champ sur lequel réaliser le post-traitement.
"""),

    5: _(u"""
Erreur utilisateur :
   Le calcul de POST_ELEM / INTEGRALE pour les champs FORC_NODA et REAC_NODA n'a pas de sens 
   car ces quantités ne sont pas "continues".
"""),

    10: _(u"""Pour le calcul de l'option MASS_INER sur la géométrie déformée, il faut que le résultat contienne plus d'un numéro d'ordre"""),

    11: _(u"""
 Un instant demandé dans POST_ELEM, option TRAV_EXT n'est pas présent dans le résultat <%(k1)s>.
"""),

    20: _(u"""Il faut renseigner le MODELE"""),



}
