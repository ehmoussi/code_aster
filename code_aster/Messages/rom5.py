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

    1 : _("""Création de la matrice des clichés."""),

    2 : _("""Sauvegarde des %(i1)d modes empiriques dans la base empirique."""),

    4 : _("""Comptage du nombre de modes empiriques à sélectionner."""),

    5 : _("""On a %(i1)d valeurs singulières comprises entre %(r1)13.6G et %(r2)13.6G . Avec les paramètres, on a retenu %(i2)d modes empiriques."""),

    6 : _("""Le critère de sélection des valeurs singulières ne permet pas d'extraire au moins un mode empirique. Il faut changer la tolérance ou le nombre de modes."""),

    7 : _("""Calcul des modes empiriques par décomposition aux valeurs singulières."""),

    8 : _("""Échec lors du calcul des modes empiriques."""),

    9 : _("""Initialisation de toutes les structures de données."""),

   10 : _("""Lecture de tous les paramètres de la commande."""),

   11 : _("""On ne trouve pas de champ de type %(k1)s dans la structure de données résultat."""),

   12 : _("""Préparation de la numérotation des modes linéiques."""),

   13 : _("""On a détecté %(i1)d tranches pour la définition des modes linéiques."""),

   14 : _("""Échec dans l'orthogonalisation des modes empiriques."""),

   15 : _("""Le nombre de couches du domaine est inférieur au nombre de couches de l'interface, on aura peut-être un problème de convergence"""),

   16 : _("""Méthode de construction de la base empirique: %(k1)s """),

   17 : _("""Nombre de modes maximum de la base empirique: %(i1)d """),

   18 : _("""Lecture des paramètres pour la méthode POD ou POD_INCR."""),

   19 : _("""Vérifications de la conformité de la structure de données résultat utilisée."""),

   20 : _("""On ne peut utiliser des bases empiriques qu'avec des maillages tridimensionnels."""),

   21 : _("""Tolérance pour l'algorithme glouton: %(r1)19.12e."""),

   22 : _("""Un mode empirique contient des conditions limites dualisés (AFFE_CHAR_THER ou AFFE_CHAR_MECA).
              Ce n'est pas possible, utilisez AFFE_CHAR_CINE"""),

   23 : _("""Un mode empirique contient la composante %(k1)s qui n'est pas autorisée. Vous utilisez un modèle qui n'est actuellement pas compatible avec la réduction de modèle."""),

   24 : _("""Paramètres généraux de DEFI_BASE_REDUITE."""),

   25 : _("""Le champ d'entrée ne contient pas la composante %(k1)s. Vous utilisez un modèle qui n'est actuellement pas compatible avec la réduction de modèle."""),

   27 : _("""Lecture des paramètres pour la méthode GLOUTON."""),

   28 : _("""Lecture des paramètres pour la méthode d'orthogonalisation."""),

   29 : _("""Lecture des paramètres pour la méthode de troncature."""),

   30 : _("""Vérification des paramètres pour le calcul non-linéaire avec réduction de modèle."""),

   31 : _("""La base empirique ne repose pas sur le même maillage sur le calcul non-linéaire."""),

   32 : _("""La base empirique n'est pas construite sur le bon type de champ."""),

   33 : _("""Le groupe de noeuds %(k1)s ne fait pas parti du maillage."""),

   34 : _("""La recherche linéaire est interdite avec la réduction de modèle."""),

   35 : _("""La base empirique est vide."""),

   36 : _("""Les modes empiriques ne sont pas nodaux."""),

   37 : _("""Initialisation pour réaliser le calcul non-linéaire avec réduction de modèle."""),

   38 : _("""Création de la table pour sauver les coordonnées réduites."""),

   39 : _("""Sauvegarde des %(i1)d coordonnées réduites pour %(i2)d modes empiriques."""),

   40 : _("""Résolution du problème réduit."""),

   41 : _("""Lecture des paramètres pour réaliser le calcul non-linéaire avec réduction de modèle."""),

   44 : _("""Évaluation des coefficients pour la valeur %(i1)d des paramètres."""),

   45 : _("""Valeur du coefficient réel pour le vecteur de nom %(k1)s : %(r1)19.12e."""),

   46 : _("""Valeur du coefficient complexe pour le vecteur de nom %(k1)s : (%(r1)19.12e,%(r2)19.12e)."""),

   47 : _("""Valeur du coefficient réel pour la matrice de nom %(k1)s : %(r1)19.12e."""),

   48 : _("""Valeur du coefficient complexe pour la matrice de nom %(k1)s : (%(r1)19.12e,%(r2)19.12e)."""),

   49 : _("""La base empirique ne repose pas sur le même modèle sur le calcul non-linéaire. Si vous utilisez le mode d'intégration sur domaine réduit, vérifiez que vous avez bien tronqué les bases (OPERATION='TRONCATURE' dans la commande DEFI_BASE_REDUITE)."""),

   51 : _("""Valeur des paramètres pour la variation d'indice %(i1)d."""),

   52 : _("""Le paramètre %(k1)s vaut %(r1)19.12e."""),

   53 : _("""Pour les modèles linéiques, le nombre de composantes par noeud doit être constant. Vérifiez que vous n'avez pas de chargements de Dirichlet appliqués avec AFFE_CHAR_MECA."""),

   54 : _("""Il n'y a pas de modèle attaché à la structure de données résultat en entrée, il faut renseigner le modèle dans la commande avec le mot-clef MODELE."""),

   55 : _("""    Sauvegarde des coordonnées réduites pour %(i1)d modes empiriques dans la table."""),

   60 : _("""Calcul par la méthode GLOUTON."""),

   61 : _("""Calcul du mode empirique %(i1)d."""),

   62 : _("""Calcul du second membre du système complet."""),

   63 : _("""Calcul de la matrice du système complet."""),

   64 : _("""Post-traitement et sauvegardes."""),

   65 : _("""Résolution du système complet."""),

   66 : _("""Calcul du second membre du système réduit."""),

   67 : _("""Calcul de la matrice du système réduit."""),

   68 : _("""Troncature de la base empirique."""),

   69 : _("""Le pilotage est interdit avec la réduction de modèle."""),

   70 : _("""La dynamique est interdite avec la réduction de modèle."""),

   71 : _("""Le contact est interdit avec la réduction de modèle."""),

   72 : _("""Orthogonalisation de la base empirique."""),

   80 : _("""Vérification de la conformité de la table des coordonnées réduites fournies par l'utilisateur."""),

   92 : _("""Calcul du mode empirique initial."""),

   93 : _("""Évaluation des coefficients pour la valeur initiale des paramètres."""),

   94 : _("""Copie de la valeur des paramètres initiaux."""),

}
