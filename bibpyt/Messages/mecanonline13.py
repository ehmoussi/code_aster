# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

cata_msg = {

    1  : _(u"""Initialisations des structures de données."""),

    2  : _(u""" Initialisations pour la gestion des lois de comportement."""),

    3  : _(u""" Initialisations des structures de données pour la gestion du contact."""),

    4  : _(u""" Initialisations du post-traitement."""),

    5  : _(u""" Initialisations pour la gestion des mesures et des statistiques."""),

    6  : _(u""" Initialisations pour la gestion des paramètres de l'algorithme de résolution non-linéaire."""),

    7  : _(u""" Initialisations pour la gestion des critères de convergence."""),

    8  : _(u""" Initialisations pour les paramètres des matériaux."""),

    9  : _(u""" Initialisations pour la gestion de l'affichage."""),

   11  : _(u""" Initialisations des fonctionnalités actives."""),

   12  : _(u""" Initialisations de la numérotation des inconnues."""),

   13  : _(u""" Initialisations de la dynamique."""),

   14  : _(u""" Initialisations de l'archivage."""),

   15  : _(u""" Initialisations de la discrétisation temporelle."""),

   16  : _(u""" Initialisations de la subdivision des pas de temps."""),

   17  : _(u""" Initialisations du pilotage."""),

   18  : _(u""" Initialisations des matrices élémentaires constantes durant le calcul."""),

   19  : _(u"""  Calcul des matrices pour les conditions limites dualisées (multiplicateurs de Lagrange)."""),

   20  : _(u"""  Calcul des matrices de masse."""),

   21  : _(u"""  Calcul des matrices pour les macro-éléments statiques."""),

   22  : _(u""" Initialisations des matrices assemblées constantes durant le calcul."""),

   23  : _(u"""  Assemblage de la matrice de masse."""),

   24  : _(u"""  Assemblage de la matrice d'amortissement."""),

   25  : _(u""" Initialisations pour la structure de données résultat."""),

   26  : _(u""" Initialisations pour l'état initial."""),

   27  : _(u""" Initialisations des structures de données pour la résolution du contact."""),

   28  : _(u""" Initialisations pour les lois de comportement."""),

   29  : _(u""" Initialisations des structures de données pour la résolution des liaisons unilatérales."""),

   30  : _(u""" Initialisations du nouveau pas de temps."""),

   31  : _(u"""  Initialisations du tableau de convergence."""),

   32  : _(u"""  Initialisations des données pour le matériau (variables de commande)."""),

   33  : _(u"""Phase de prédiction."""),

   34  : _(u""" Prédiction de type Euler."""),

   35  : _(u"""  Calcul de la matrice en prédiction."""),

   36  : _(u"""   Nouvelle numérotation des inconnues."""),

   37  : _(u"""   On assemblera la matrice d'amortissement."""),

   38  : _(u"""   On n'assemblera pas la matrice d'amortissement."""),

   39  : _(u"""   On assemblera la matrice globale du système."""),

   40  : _(u"""   On n'assemblera pas la matrice globale du système."""),

   41  : _(u"""   Calcul de la matrice globale du système."""),

   42  : _(u"""   Factorisation de la matrice globale du système."""),

   43  : _(u"""Correction des déplacements."""),

   44  : _(u""" Mise à jour des efforts extérieurs."""),

   45  : _(u""" Conversion des incréments suivant le schéma."""),

   46  : _(u"""  Incrément des déplacements obtenus par prédiction."""),
   47  : _(u"""  Incrément des vitesses obtenues par prédiction."""),
   48  : _(u"""  Incrément des accélérations obtenues par prédiction."""),

   49  : _(u""" Ajustement de la direction de descente (pilotage et recherche linéaire si ils sont activés)."""),

   50  : _(u"""  Coefficient de recherche linéaire: %(r1)4.3G"""),
   51  : _(u"""  Coefficient de pilotage: %(r1)4.3G"""),
   52  : _(u"""  Coefficient de décalage pour le pilotage: %(r1)4.3G"""),

   53  : _(u"""  Incrément des déplacements obtenus à l'itération de Newton courante."""),
   54  : _(u"""  Incrément des vitesses obtenues à l'itération de Newton courante."""),
   55  : _(u"""  Incrément des accélérations obtenues à l'itération de Newton courante."""),

   56  : _(u""" Mise à jour des champs solutions."""),

   57  : _(u"""  Déplacements."""),
   58  : _(u"""  Incrément des déplacements depuis le début du pas de temps."""),

   59  : _(u"""  Vitesses."""),
   60  : _(u"""  Incrément des vitesses depuis le début du pas de temps."""),

   61  : _(u"""  Accélérations."""),
   62  : _(u"""  Incrément des accélérations depuis le début du pas de temps."""),

   63  : _(u"""Correction des forces."""),

   64  : _(u"""Évaluation de la convergence."""),

   65  : _(u""" Calcul des résidus."""),

   66  : _(u""" Calcul du résidu d'équilibre."""),

   67  : _(u"""Calcul de la direction de descente."""),

   68  : _(u""" Calcul de la matrice en correction."""),

   69  : _(u""" Calcul de la matrice pour le post-traitement modal."""),

   70  : _(u"""  Assemblage des matrices élémentaires de rigidité."""),

   71  : _(u"""  Assemblage des matrices élémentaires d'amortissement."""),

   72  : _(u"""  Assemblage des matrices élémentaires de masse."""),

   73  : _(u"""  Assemblage des matrices élémentaires des macro-éléments."""),

   76  : _(u"""  Calcul de la matrice pour l'accélération initiale."""),

   77  : _(u"""  Résolution du système global."""),

   80  : _(u"""  Calcul des matrices élémentaires de rigidité."""),

   81  : _(u"""  Calcul des matrices élémentaires de rigidité géométrique."""),

   82  : _(u"""  Calcul des matrices élémentaires de masse."""),

   83  : _(u"""  Calcul des matrices élémentaires d'amortissement."""),

   84  : _(u"""  Calcul des matrices élémentaires pour les charges suiveuses."""),

   85  : _(u"""  Calcul des matrices élémentaires des macro-éléments."""),

   86  : _(u""" Initialisations pour la gestion de l'énergie."""),

}
