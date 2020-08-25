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

# Messages for DEFI_BASE_REDUITE

cata_msg = {

    1 : _("""Lecture des paramètres spécifiques pour les méthodes POD."""),

    2 : _("""Lecture des paramètres spécifiques pour la méthode GLOUTON."""),

    3 : _("""Lecture des paramètres spécifiques pour la méthode de troncature."""),

    4 : _("""Lecture des paramètres spécifiques pour la méthode d'orthogonalisation."""),

   10 : _("""Initialisation de la base pour les méthodes POD."""),

   11 : _("""Initialisation de la base linéique."""),

   12 : _("""Préparation de la numérotation des modes linéiques."""),

   13 : _("""Tolérance pour détecter les noeuds: %(r1)19.12e."""),

   14 : _("""Pour les modèles linéiques, le nombre de composantes par noeud doit être constant. Vérifiez que vous n'avez pas de chargements de Dirichlet appliqués avec AFFE_CHAR_MECA."""),

   15 : _("""Initialisation de la base pour la méthode GLOUTON."""),

   16 : _("""Initialisation de la base pour la méthode de troncature."""),

   17 : _("""Lecture de la base à tronquer. La base tronquée aura le même nom que la base à tronquer."""),

   18 : _("""Lecture de la base à tronquer. La base tronquée sera nouvelle."""),

   19 : _("""Création du nouveau profil de numérotation du champ tronqué."""),

   20 : _("""Création de la nouvelle base tronquée."""),

   21 : _("""Vous avez donné le nom de la base alors que vous voulez modifier une base déjà existante."""),

   22 : _("""Initialisation de la base pour la méthode d'orthogonalisation."""),

   23 : _("""Lecture de la base à orthonormaliser. La base orthonormalisée aura le même nom que la base initiale."""),

   24 : _("""Lecture de la base à orthonormaliser. La base orthonormalisée sera nouvelle."""),

   25 : _("""Création de la nouvelle base orthonormalisée."""),

   29 : _("""Initialisation de l'algorithme pour la méthode d'orthogonalisation."""),

   30 : _("""Initialisation de l'algorithme pour les méthodes POD."""),

   31 : _("""Initialisation de l'algorithme pour la méthode GLOUTON."""),

   32 : _("""Initialisation de l'algorithme pour la méthode de troncature."""),

   33 : _("""Création de la nouvelle numérotation sur le domaine tronqué."""),

   34 : _("""Création de la nouvelle numérotation sur le domaine initial."""),

   35 : _("""Vérification des paramètres pour la méthode d'orthogonalisation."""),

   36 : _("""On ne peut pas procéder à l'orthogonalisation d'une base avec des modes définis sur un autre support que les noeuds (ici le support est %(k1)s)."""),
 
   37 : _("""Vérification des paramètres pour les méthodes POD."""),

   38 : _("""On ne peut pas enrichir une base existante avec la méthode %(k1)s."""),

   39 : _("""Vérification des paramètres pour la méthode GLOUTON."""),

   40 : _("""Le calcul d'une base réduite pour le calcul multi-paramétrique avec réduction de modèle nécessite de faire varier les coefficients."""),

   41 : _("""On ne peut pas calculer une base avec des modes définis sur un autre support que les noeuds (ici le support est %(k1)s)."""),

   42 : _("""Vérification des paramètres pour la méthode de troncature."""),

   43 : _("""La base est construite sur un maillage différent du modèle. Ce n'est pas possible."""),

   44 : _("""Les deux modèles sont identiques, on ne peut rien tronquer !"""),

   45 : _("""On ne peut pas tronquer une base avec des modes définis sur un autre support que les noeuds (ici le support est %(k1)s)."""),

   46 : _("""Paramètres spécifiques pour la méthode d'orthogonalisation."""),

   47 : _("""Paramètre pour l'algorithme d'orthogonalisation : %(r1)13.6G."""),

   48 : _("""Paramètres spécifiques pour les méthodes POD."""),

   49 : _("""Nombre de modes maximum de la base: %(i1)d."""),

   50 : _("""Création de la base à partir de champs de type %(k1)s."""),

   51 : _("""Tolérance pour les valeurs singulières: %(r1)13.6G."""),

   52 : _("""Tolérance pour l'algorithme incrémental: %(r1)13.6G."""),

   53 : _("""Paramètres spécifiques pour la méthode GLOUTON."""),

   54 : _("""Nombre de modes maximum de la base: %(i1)d."""),

   55 : _("""Tolérance pour l'algorithme glouton: %(r1)19.12e."""),

   56 : _("""Paramètres spécifiques pour la méthode de troncature: aucun."""),

   57 : _("""Orthogonalisation de la base."""),

   58 : _("""Calcul de la base par la méthode POD."""),

   59 : _("""Calcul de la base par la méthode POD incrémentale."""),

   60 : _("""Calcul de la base par la méthode GLOUTON."""),

   61 : _("""Calcul du mode initial."""),

   62 : _("""Calcul du mode %(i1)d."""),

   63 : _("""Calcul de la base tronquée."""),
}
