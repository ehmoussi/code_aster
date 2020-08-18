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

    4 : _("""Comptage du nombre de modes empiriques à sélectionner."""),

    5 : _("""On a %(i1)d valeurs singulières comprises entre %(r1)13.6G et %(r2)13.6G . Avec les paramètres, on a retenu %(i2)d modes empiriques."""),

    6 : _("""Le critère de sélection des valeurs singulières ne permet pas d'extraire au moins un mode empirique. Il faut changer la tolérance ou le nombre de modes."""),

    7 : _("""Calcul des modes empiriques par décomposition aux valeurs singulières."""),

    8 : _("""Échec lors du calcul des modes empiriques."""),

   14 : _("""Échec dans l'orthogonalisation des modes empiriques."""),

   30 : _("""Vérification des paramètres pour le calcul non-linéaire avec réduction de modèle."""),

   31 : _("""La base empirique ne repose pas sur le même maillage sur le calcul non-linéaire."""),

   32 : _("""La base empirique n'est pas construite sur le bon type de champ."""),

   33 : _("""Le groupe de noeuds %(k1)s ne fait pas parti du maillage."""),

   34 : _("""La recherche linéaire est interdite avec la réduction de modèle."""),

   35 : _("""La base empirique est vide."""),

   36 : _("""Les modes empiriques ne sont pas nodaux."""),

   37 : _("""Initialisation pour réaliser le calcul non-linéaire avec réduction de modèle."""),

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

   62 : _("""Calcul du second membre du système complet."""),

   63 : _("""Calcul de la matrice du système complet."""),

   64 : _("""Post-traitement et sauvegardes."""),

   65 : _("""Résolution du système complet."""),

   66 : _("""Calcul du second membre du système réduit."""),

   67 : _("""Calcul de la matrice du système réduit."""),

   69 : _("""Le pilotage est interdit avec la réduction de modèle."""),

   70 : _("""La dynamique est interdite avec la réduction de modèle."""),

   71 : _("""Le contact est interdit avec la réduction de modèle."""),

   81 : _("""Paramètres de la base primale utilisée."""),

   82 : _("""Calcul hyper-réduit (sur un domaine réduit)."""),

   83 : _("""Calcul réduit (sur le domaine complet)."""),

   84 : _("""Calcul avec correction par un calcul élément fini complet."""),

   85 : _("""Le raccord sur l'interface utilise un coefficeint de pénalisation de %(r1)19.12e."""),

   93 : _("""Évaluation des coefficients pour la valeur initiale des paramètres."""),

   94 : _("""Copie de la valeur des paramètres initiaux."""),

}
