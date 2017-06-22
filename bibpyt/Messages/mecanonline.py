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

    1 : _(u"""
 Échec dans le calcul des matrices élastiques pour l'amortissement.
"""),

    2 : _(u"""
 Lors de la recopie du champ %(k1)s donné dans ETAT_INIT de la commande
 STAT_NON_LINE vers le champ %(k2)s, certaines composantes de %(k2)s
 ont du être mises à zéro.

 Ce problème survient lorsque le champ donné dans ETAT_INIT ne comporte
 pas assez de composantes, on complète donc par des zéros.
"""),

    3 : _(u"""
Erreur utilisateur :
  Vous essayez de faire un calcul non-linéaire mécanique ou un post-traitement sur un modèle dont les éléments
  ne sont pas programmés pour cela.
  On arrête le calcul.
Risques & conseils :
  Vous devriez changer de modélisation.
"""),

    4 : _(u"""
Erreur utilisateur :
  Vous essayez de faire un calcul non-linéaire mécanique en utilisant un concept résultat sans préciser l'état
  initial (mot clé ETAT_INIT).
  On arrête le calcul.
"""),

    23 : _(u"""
 Le calcul de l'accélération initiale a ignoré les chargements de type:
 - ONDE_PLANE
 - LAPLACE
 - GRAPPE_FLUIDE
"""),

    24 : _(u"""
 L'état initial n'a pas d'accélération donnée.
 On la calcule.
 """),

    43 : _(u"""
 Contact et pilotage sont des fonctionnalités incompatibles
"""),

    59 : _(u"""
 Cette loi de comportement n'est pas disponible pour le pilotage de type PRED_ELAS
"""),

    60 : _(u"""
 Le pilotage de type PRED_ELAS nécessite ETA_PILO_R_MIN et ETA_PILO_R_MAX pour la loi %(k1)s
"""),

    61 : _(u"""
 Le pilotage de type DEFORMATION n'est pas disponible pour la modélisation %(k1)s
"""),

    62 : _(u"""
 Pilotage: SELECTION='MIXTE' incompatible avec ACTION='AUTRE_PILOTAGE' dans DEFI_LIST_INST
"""),

    69 : _(u"""
 Problème rencontré :
   la matrice de masse est non inversible.
   On ne peut donc pas s'en servir pour calculer l'accélération initiale.
   => on initialise l'accélération à zéro.

 Conseils :
   Avez-vous bien affecté une masse sur tous les éléments ?

 Certains éléments ne peuvent évaluer de matrice masse.
 Dans ce cas, vous pouvez donner un champ d'accélération explicitement nul dans ETAT_INIT pour supprimer l'alarme.
"""),

    70 : _(u"""
 Problème rencontré :
   Le calcul de l'accélération initiale a échoué lors de la phase de résolution.
   => on initialise l'accélération à zéro.

 Conseils :
   Avez-vous bien affecté une masse sur tous les éléments ?

 Certains éléments ne peuvent évaluer de matrice masse.
 Dans ce cas, vous pouvez donner un champ d'accélération explicitement nul dans ETAT_INIT pour supprimer l'alarme.
"""),




    78 : _(u"""
 Problème rencontré :
   la matrice de masse est quasi singulière.
   On se sert de cette matrice pour calculer l'accélération initiale.
   => l'accélération initiale calculée est peut être excessive en quelques noeuds.

 Conseils :
   Ces éventuelles perturbations initiales sont en général sans influence sur
   la suite du calcul car elles sont localisées.
   Néanmoins, il peut être bénéfique de laisser ces perturbations s'amortir au
   début du calcul en faisant plusieurs pas avec chargement transitoire nul,
   avec, éventuellement, un schéma d'intégration choisi volontairement très
   dissipatif (par exemple HHT avec alpha=-0.3).
   On peut ensuite reprendre en poursuite avec un schéma moins dissipatif si besoin est.
"""),





}
