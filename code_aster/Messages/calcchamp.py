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

# person_in_charge: nicolas.sellenet at edf.fr

from ..Utilities import _

cata_msg = {

    1 : _("""
 Le champ %(k1)s est déjà présent dans la structure de données
 à tous les instants demandés.
 Aucun calcul ne sera donc réalisé pour cette option.

Conseil :
 Si vous souhaitez réellement calculer à nouveau cette option,
 créez une nouvelle structure de données.
"""),

    2 : _("""
 L'option %(k1)s nécessaire au calcul de l'option %(k2)s est
 manquante dans les structures de données résultat %(k3)s et
 %(k4)s pour le numéro d'ordre %(i1)d.

 Le calcul de cette option n'est donc pas possible.
 L'option demandée n'est calculable sur les éléments du modèle.
"""),

3 : _("""
La sortie EPSI_%(k2)s de CALC_CHAMP est incorrecte pour décrire les
composantes de la déformation en grandes déformations.

Conseil:
Avec des déformations de type %(k1)s,
il est préférable d'utiliser %(k2)s
"""),

4 : _("""
Les contributions de l'amortissement liées à la vitesse pour les
réactions nodales sont négligées dans la version actuelle du code.
"""),

5: _("""
La récupération des chargements concernant le résultat %(k1)s n'est actuellement pas possible.
Code_Aster ne peut donc pas vérifier la cohérence des chargements.

Conseil : Si vous utilisez une commande avec une option qui nécessite la redéfinition des chargements,
il faut vérifier la cohérence des chargements.
"""),

6: _("""
Le mot clef EXCIT de la commande n'est pas renseigné et la récupération des chargements concernant
le résultat %(k1)s n'est actuellement pas possible.

Conseil : Il faut renseigner le mot clef EXCIT de la commande CALC_CHAMP,
"""),

7 : _("""
Le champ STRX_ELGA n'est pas possible sur une modélisation XFEM.
"""),

19 : _("""
Problème lors de l'appel de l'option %(k1)s.

Contactez le support technique.
"""),


23: _("""Le modèle doit être le même sur tous les pas de temps pour ce post-traitement.
      Conseil : il faut séparer le post-traitement en le découpant pour garder le même modèle"""),

24: _("""Le chargement doit être le même sur tous les pas de temps pour ce post-traitement.
      Conseil : il faut séparer le post-traitement en le découpant pour garder le même chargement"""),

89: _("""
 Le champ  %(k1)s  n'a pas pu être calculé.
 Risques & conseils :
   * Si le champ est un champ par éléments, c'est que le calcul élémentaire n'est pas disponible
     pour les éléments finis utilisés. Cela peut se produire soit parce que ce
     calcul n'a pas été encore programmé, soit parce que ce calcul n'a pas de sens.
     Par exemple, le champ EFGE_ELNO n'a pas de sens pour les éléments de la modélisation '3D'.
   * Si le champ est un champ aux noeuds (XXXX_NOEU), cela veut dire que le champ XXXX_ELNO
     n'existe pas sur les éléments spécifiés.
     Par exemple, le calcul de SIGM_NOEU sur les éléments de bord est impossible.

"""),

}
