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

# person_in_charge: mickael.abbas at edf.fr

from ..Utilities import _

cata_msg = {

   11 : _("""On n'a pas réussi à extraire le champ de type %(k1)s pour le numéro d'ordre %(i1)d."""),

   14 : _("""La matrice du système sera complexe."""),

   15 : _("""La matrice du système sera réelle."""),

   16 : _("""Le second membre du système sera complexe."""),

   17 : _("""Le second membre du système sera réel."""),

   18 : _("""Échec lors de la résolution.
              La matrice est presque singulière à la fréquence."""),

   19 : _("""Initialisation pour le problème multi-paramétrique."""),

   20 : _("""Lecture des données pour le calcul multi-paramétrique avec réduction de modèle."""),

   21 : _("""Les matrices et les vecteurs ne reposent pas toutes sur la même numérotation."""),

   22 : _("""Les matrices doivent être symétriques."""),

   23 : _("""Lecture des données pour la construction du système - Le second membre."""),

   24 : _("""Lecture des données pour la variation des coefficients."""),

   25 : _("""Lecture des données pour la construction du système - Les matrices."""),

   26 : _("""Évaluation du type du système (réel ou complexe)."""),

   27 : _("""Création des objets pour le système complet."""),

   29 : _("""Le nombre de coefficients pour faire varier les fonctions n'est pas le même pour tous les paramètres."""),

   31 : _("""Le coefficient devant le second membre est une fonction et il n'y a aucune donnée sur la variation de cette fonction."""),

   32 : _("""Initialisation des coefficients pour le problème multi-paramétrique."""),

   33 : _("""Création des objets pour le système réduit."""),

   34 : _("""Initialisation des produits matrices par mode."""),

   35 : _("""Taille du système: %(i1)d."""),

   36 : _("""Le système résultant sera complexe."""),

   37 : _("""Le système résultant sera réel."""),

   38 : _("""Pas de lecture des données pour la variation des coefficients."""),

   42 : _("""Initialisation pour l'algorithme GLOUTON."""),

   44 : _("""Résolution du système réduit."""),

   45 : _("""Calcul des coefficients réduits."""),

   46 : _("""Pour le coefficient %(i1)d."""),

   49 : _("""Norme du résidu pour le coefficient %(i1)d: %(r1)19.12e."""),

   50 : _("""Évaluation du résidu."""),

   51 : _("""Calcul des coefficients réduits pour le paramètre %(i1)d."""),

   52 : _("""Coefficient réduit pour le mode %(i1)d et le paramètre %(i2)d: (%(r1)19.12e,%(r2)19.12e)."""),

   53 : _("""Initialisation de la numérotation pour STAB_IFS."""),

}
