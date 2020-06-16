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

# For DEBUG (INFO=2)

from ..Utilities import _

cata_msg = {

    1  : _("""Initialisations des structures de données."""),

    2  : _(""" Initialisations pour la gestion des lois de comportement."""),

    3  : _(""" Initialisations des structures de données pour la gestion du contact."""),

    4  : _(""" Initialisations du post-traitement."""),

    5  : _(""" Initialisations pour la gestion des mesures et des statistiques."""),

    6  : _(""" Initialisations pour la gestion des paramètres de l'algorithme de résolution non-linéaire."""),

    7  : _(""" Initialisations pour la gestion des critères de convergence."""),

    8  : _(""" Initialisations pour les paramètres des matériaux."""),

    9  : _(""" Initialisations pour la gestion de l'affichage."""),

   10  : _(""" Initialisations pour le système à résoudre."""),

   11  : _(""" Initialisations des fonctionnalités actives."""),

   12  : _(""" Initialisations de la numérotation des inconnues."""),

   13  : _(""" Initialisations de la dynamique."""),

   14  : _(""" Initialisations de l'archivage."""),

   15  : _(""" Initialisations de la discrétisation temporelle."""),

   16  : _(""" Initialisations de la subdivision des pas de temps."""),

   17  : _(""" Initialisations du pilotage."""),

   18  : _(""" Initialisations des matrices élémentaires constantes durant le calcul."""),

   19  : _("""  Calcul des matrices pour les conditions limites dualisées (multiplicateurs de Lagrange)."""),

   20  : _("""  Calcul des matrices de masse."""),

   21  : _("""  Calcul des matrices pour les macro-éléments statiques."""),

   22  : _(""" Initialisations des matrices assemblées constantes durant le calcul."""),

   23  : _("""  Assemblage de la matrice de masse."""),

   24  : _("""  Assemblage de la matrice d'amortissement."""),

   25  : _(""" Initialisations pour la structure de données résultat."""),

   26  : _(""" Initialisations pour l'état initial."""),

   27  : _(""" Initialisations des structures de données pour la résolution du contact."""),

   29  : _(""" Initialisations des structures de données pour la résolution des liaisons unilatérales."""),

   30  : _(""" Initialisations du nouveau pas de temps."""),

   31  : _("""  Initialisations du tableau de convergence."""),

   32  : _("""  Initialisations des données pour le matériau (variables de commande)."""),

   33  : _("""Phase de prédiction."""),

   34  : _(""" Prédiction de type Euler."""),

   35  : _("""  Calcul de la matrice en prédiction."""),

   36  : _("""   Nouvelle numérotation des inconnues."""),

   41  : _("""   Calcul de la matrice globale du système."""),

   42  : _("""   Factorisation de la matrice globale du système."""),

   43  : _("""Correction des déplacements."""),

   44  : _(""" Mise à jour des efforts extérieurs."""),

   45  : _(""" Conversion des incréments suivant le schéma."""),

   46  : _("""  Incrément des déplacements obtenus par prédiction."""),
   47  : _("""  Incrément des vitesses obtenues par prédiction."""),
   48  : _("""  Incrément des accélérations obtenues par prédiction."""),

   49  : _(""" Ajustement de la direction de descente (pilotage et recherche linéaire si ils sont activés)."""),

   50  : _("""  Coefficient de recherche linéaire: %(r1)4.3G"""),
   51  : _("""  Coefficient de pilotage: %(r1)4.3G"""),
   52  : _("""  Coefficient de décalage pour le pilotage: %(r1)4.3G"""),

   53  : _("""  Incrément des déplacements obtenus à l'itération de Newton courante."""),
   54  : _("""  Incrément des vitesses obtenues à l'itération de Newton courante."""),
   55  : _("""  Incrément des accélérations obtenues à l'itération de Newton courante."""),

   56  : _(""" Mise à jour des champs solutions."""),

   57  : _("""  Déplacements."""),
   58  : _("""  Incrément des déplacements depuis le début du pas de temps."""),

   59  : _("""  Vitesses."""),
   60  : _("""  Incrément des vitesses depuis le début du pas de temps."""),

   61  : _("""  Accélérations."""),
   62  : _("""  Incrément des accélérations depuis le début du pas de temps."""),

   63  : _("""Correction des forces."""),

   64  : _("""Évaluation de la convergence."""),

   65  : _(""" Calcul des résidus."""),

   66  : _(""" Calcul du résidu d'équilibre."""),

   67  : _("""Calcul de la direction de descente."""),

   68  : _(""" Calcul de la matrice en correction."""),

   69  : _(""" Calcul de la matrice pour le post-traitement modal."""),

   70  : _("""  Assemblage des matrices élémentaires de rigidité."""),

   71  : _("""  Assemblage des matrices élémentaires d'amortissement."""),

   72  : _("""  Assemblage des matrices élémentaires de masse."""),

   73  : _("""  Assemblage des matrices élémentaires des macro-éléments."""),

   74  : _(""" Initialisations pour les critères de qualité."""),

   76  : _("""  Calcul de la matrice pour l'accélération initiale."""),

   77  : _("""  Résolution du système global."""),

   80  : _("""  Calcul des matrices élémentaires de rigidité."""),

   81  : _("""  Calcul des matrices élémentaires de rigidité géométrique."""),

   82  : _("""  Calcul des matrices élémentaires de masse."""),

   83  : _("""  Calcul des matrices élémentaires d'amortissement."""),

   84  : _("""  Calcul des matrices élémentaires pour les charges suiveuses."""),

   85  : _("""  Calcul des matrices élémentaires des macro-éléments."""),

   87  : _(""" Calcul de l'indicateur d'erreur en THM."""),

   86  : _(""" Initialisations pour la gestion de l'énergie."""),

}
