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

# person_in_charge: nicolas.sellenet at edf.fr

cata_msg = {

    1 : _(u"""
 Le champ %(k1)s est déjà présent dans la structure de données
 à tous les instants demandés.
 Aucun calcul ne sera donc réalisé pour cette option.

Conseil :
 Si vous souhaitez réellement calculer à nouveau cette option,
 créez une nouvelle structure de données.
"""),

    2 : _(u"""
 L'option %(k1)s nécessaire au calcul de l'option %(k2)s est
 manquante dans les structures de données résultat %(k3)s et
 %(k4)s pour le numéro d'ordre %(i1)d.

 Le calcul de cette option n'est donc pas possible.
 L'option demandée n'est calculable sur les éléments du modèle.
"""),

3 : _(u"""
La sortie EPSI_%(k2)s de CALC_CHAMP est incorrecte pour décrire les
composantes de la déformation en grandes déformations.

Conseil:
Avec des déformations de type %(k1)s,
il est préférable d'utiliser EPSG_%(k2)s
"""),

4 : _(u"""
Les contributions de l'amortissement liées à la vitesse pour les 
réactions nodales sont négligées dans la version actuelle du code.
"""),

5: _(u"""
La récupération des chargements concernant le résultat %(k1)s n'est actuellement pas possible.
Code_Aster ne peut donc pas vérifier la cohérence des chargements.

Conseil : Si vous utilisez une commande avec une option qui nécessite la redéfinition des chargements,
il faut vérifier la cohérence des chargements.
"""),

6: _(u"""
Le mot clef EXCIT de la commande n'est pas renseigné et la récupération des chargements concernant
le résultat %(k1)s n'est actuellement pas possible.

Conseil : Il faut renseigner le mot clef EXCIT de la commande CALC_CHAMP,
"""),

19 : _(u"""
Problème lors de l'appel de l'option %(k1)s.

Contactez le support technique.
"""),


23: _(u"""Le modèle doit être le même sur tous les pas de temps pour ce post-traitement.
      Conseil : il faut séparer le post-traitement en le découpant pour garder le même modèle"""),

24: _(u"""Le chargement doit être le même sur tous les pas de temps pour ce post-traitement.
      Conseil : il faut séparer le post-traitement en le découpant pour garder le même chargement"""),

}
