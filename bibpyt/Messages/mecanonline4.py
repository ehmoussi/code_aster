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

    3 : _(u"""
 Calcul des valeurs propres en grandes déformations
"""),

    14 : _(u"""
 Vous utilisez la méthode CONTINUE pour le traitement du contact et faites une reprise de calcul (mot-clé reuse). De plus, vous n'avez pas activé
 l'initialisation automatique des statuts de contact. L'état initial de contact sera donc non contactant.
 Cela peut entraîner des difficultés de convergence en présence de fortes non-linéarités. En présence de frottement, la solution peut bifurquer
 différemment.

 Conseils :
   - si vous le pouvez, faites votre calcul en une seule fois.
   - activez la détection automatique du contact initial sur toutes les zones (CONTACT_INIT='INTERPENETRE' dans DEFI_CONTACT).
"""),

    15 : _(u"""
 Vous utilisez la méthode CONTINUE pour le traitement du contact et définissez un état initial via le mot-clé ETAT_INIT.  De plus, vous n'avez pas activé
 l'initialisation automatique des statuts de contact. L'état initial de contact sera donc non contactant.

 Il est conseillé d'activer la détection automatique du contact initial sur toutes les zones (CONTACT_INIT='INTERPENETRE' dans DEFI_CONTACT).
"""),

    22 : _(u"""
 On suppose qu'on part d'un état a vitesses nulles
"""),

    23 : _(u"""
 On estime une accélération initiale.
"""),

    47 : _(u"""
 Vous faites une reprise de calcul avec PILOTAGE en longueur d'arc et avec l'option ANGL_INCR_DEPL mais il n'y pas assez d'informations dans
 la structure de données résultat. Il vous faut en effet au moins les deux derniers champs déplacements solutions.
 Changer l'option de PILOTAGE (utilisez NORM_INCR_DEPL) ou refaites le premier calcul pour enrichir la structure de données résultat (modifiez vos options du mot-clé ARCHIVAGE).
"""),

}
