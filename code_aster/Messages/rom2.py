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

    4 : _("""Lecture des données pour sélectionner les clichés."""),

    6 : _("""Tolérance pour détecter les noeuds: %(r1)19.12e."""),

    8 : _("""Création de la liste des équations sur le mode empirique."""),

    9 : _("""Base empirique créée à partir de %(i1)d clichés."""),

   10 : _("""Vous n'avez sélectionné aucun cliché."""),

   11 : _("""On n'a pas réussi à extraire les informations de la structure de données %(k1)s
pour le numéro d'ordre %(i1)d.

Conseil: Vérifier la liste renseignée dans SNAPSHOT"""),

   12 : _("""Initialisation de la base empirique dans le cas d'une méthode POD."""),

   13 : _("""On ne peut pas enrichir une base empirique avec la méthode %(k1)s."""),

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

   28 : _("""Initialisation de la base empirique dans le cas d'une méthode GLOUTON."""),

   29 : _("""Le nombre de coefficients pour faire varier les fonctions n'est pas le même pour tous les paramètres."""),

   31 : _("""Le coefficient devant le second membre est une fonction et il n'y a aucune donnée sur la variation de cette fonction."""),

   32 : _("""Initialisation des coefficients pour le problème multi-paramétrique."""),

   33 : _("""Création des objets pour le système réduit."""),

   34 : _("""Initialisation des produits matrices par mode."""),

   35 : _("""Taille du système: %(i1)d."""),

   36 : _("""Le système résultant sera complexe."""),

   37 : _("""Le système résultant sera réel."""),

   38 : _("""Pas de lecture des données pour la variation des coefficients."""),

   39 : _("""Initialisation de la base empirique dans le cas d'une méthode de troncature."""),

   40 : _("""Initialisation de l'algorithme pour les méthodes POD."""),

   41 : _("""Initialisation de l'algorithme pour la méthode GLOUTON."""),

   42 : _("""Initialisation pour l'algorithme GLOUTON."""),

   43 : _("""Le calcul d'une base réduite pour le calcul multi-paramétrique avec réduction de modèle nécessite de faire varier les coefficients."""),

   44 : _("""Résolution du système réduit."""),

   45 : _("""Calcul des coefficients réduits."""),

   46 : _("""Pour le coefficient %(i1)d."""),

   47 : _("""Initialisation pour la troncature de la base empirique."""),

   48 : _("""Création de la nouvelle numérotation sur le domaine tronqué."""),

   49 : _("""Norme du résidu pour le coefficient %(i1)d: %(r1)19.12e."""),

   50 : _("""Évaluation du résidu."""),

   51 : _("""Calcul des coefficients réduits pour le paramètre %(i1)d."""),

   52 : _("""Coefficient réduit pour le mode %(i1)d et le paramètre %(i2)d: (%(r1)19.12e,%(r2)19.12e)."""),

   53 : _("""Initialisation de la numérotation pour STAB_IFS."""),

   55 : _("""Création du nouveau profil de numérotation du champ tronqué."""),

   56 : _("""Lecture de la base à tronquer. La base tronquée aura le même nom que la base à tronquer."""),

   57 : _("""Lecture de la base à tronquer. La base tronquée sera nouvelle."""),

   58 : _("""Création de la nouvelle base tronquée."""),

   59 : _("""Création de la nouvelle numérotation sur le domaine complet."""),

   60 : _("""Initialisation de la base empirique dans le cas d'une orthogonalisation."""),

   61 : _("""Lecture de la base à orthonormaliser. La base orthonormalisée aura le même nom que la base initiale."""),

   62 : _("""Lecture de la base à orthonormaliser. La base orthonormalisée sera nouvelle."""),

   63 : _("""Création de la nouvelle base orthonormalisée."""),

}
