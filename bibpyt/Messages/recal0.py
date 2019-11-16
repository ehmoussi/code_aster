# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

from code_aster import _

cata_msg = {
    1 : _("""

 <INFO> Fichier d'informations de MACR_RECAL

"""),

    2 : _("""Impossible d'importer le module as_profil ! Vérifier la variable
d'environnement ASTER_ROOT ou mettez à jour ASTK.
"""),

    3 : _("""Le logiciel GNUPLOT ou le module python Gnuplot n'est pas disponible.
On désactive l'affichage des courbes par Gnuplot.
"""),

    4 : _("""Il n'y a pas de fichier .export dans le répertoire de travail !
"""),

    5 : _("""Il y a plus d'un fichier .export dans le répertoire de travail !
"""),

    6 : _("""Pour les calculs DISTRIBUES en mode INTERACTIF, il faut spécifier une valeur pour mem_aster
(menu Option de ASTK) pour limiter la mémoire allouée au calcul maître.
"""),

    7 : _("""Pour pouvoir lancer les calculs esclaves en MPI, le calcul maître doit être lancé
en MPI sur un processeur."""),

    8 : _("""Vérifier les valeurs des paramètres mem_aster et memjeveux.
"""),

    # 9 : _(u""" """),

    10 : _("""Pour l'algorithme %(k1)s, on ne peut tracer qu'à la dernière itération.
"""),

    11 : _("""Pour l'algorithme %(k1)s, on ne tient pas compte des bornes sur les paramètres.
"""),

    12 : _("""Recalage :
   %(k1)s
"""),

    13 : _("""Lancement de l'optimisation avec la méthode : %(k1)s.
"""),

    14 : _("""Les dérivées sont calculées par Aster.
"""),

    15 : _("""Les dérivées sont calculées par l'algorithme.
"""),

    16 : _("""
--> Calcul du gradient par différences finies <--

"""),

    17 : _("""Tracé des graphiques
"""),

    18 : _("""Erreur dans l'algorithme de bornes de MACR_RECAL.
"""),

    19 : _("""Erreur dans le test de convergence de MACR_RECAL.
"""),

    23 : _("""Impossible d'importer le module de lecture des tables !
"""),

    24 : _("""Impossible de récupérer les résultats de calcul esclave (lecture des tables) !
Message d'erreur :
   %(k1)s
"""),

    25 : _("""
Calcul de F avec les paramètres :
     %(k1)s
"""),

    26 : _("""
Calcul de F et G avec les paramètres :
     %(k1)s
"""),

    27 : _("""
Calcul de G avec les paramètres :
   %(k1)s
"""),

    28 : _("""
--> Mode de lancement BATCH impossible sur : %(k1)s, on bascule en INTERACTIF <--

"""),

    29 : _("""
--> Mode de lancement des calculs esclaves : %(k1)s <--

"""),

    30 : _("""
Informations de convergence :
======================================================================
"""),

    31 : _("""Itération %(i1)d :

"""),

    32 : _("""
=> Paramètres :
     %(k1)s

"""),

    33 : _("""=> Fonctionnelle                        = %(r1)f
"""),

    34 : _("""=> Résidu                               = %(r1)f
"""),

    35 : _("""=> Norme de l'erreur                    = %(r1)f
"""),

    36 : _("""=> Erreur                               = %(r1)f
"""),

    37 : _("""=> Variation des paramètres (norme L2)  = %(r1)f
"""),

    38 : _("""=> Variation de la fonctionnelle        = %(r1)f
"""),

    39 : _("""=> Nombre d'évaluation de la fonction   = %(k1)s
"""),

    # 40 : _(u""" """),

    41 : _("""Tracé des courbes dans le fichier : %(k1)s
"""),

    42 : _("""Problème lors de l'affichage des courbes. On ignore et on continue.
Erreur :
   %(k1)s
"""),

    43 : _("""Erreur :
   %(k1)s
"""),

    44 : _("""Problème de division par zéro dans la normalisation de la fonctionnelle.
Une des valeurs de la fonctionnelle initiale est nulle ou inférieure à la précision machine : %(r1).2f
"""),

    45 : _("""Problème de division par zéro dans le calcul de la matrice de sensibilité.
Le paramètre %(k1)s est nul ou plus petit que la précision machine.
"""),

    46 : _("""Le paramètre %(k1)s est en butée sur un bord du domaine admissible.
"""),

    47 : _("""Les paramètres %(k1)s sont en butée sur un bord du domaine admissible.
"""),

    48 : _("""Problème lors de l'interpolation du calcul dérivé sur les données expérimentale !
Valeur à interpoler              :  %(k1)s
Domaine couvert par l'expérience : [%(k2)s : %(k3)s]
"""),

    50 : _("""
--> Critère d'arrêt sur le résidu atteint, la valeur du résidu est : %(r1)f <--
"""),

    51 : _("""
--> Critère d'arrêt TOLE_PARA atteint, la variation des paramètres est : %(r1)f <--
"""),

    52 : _("""
--> Critère d'arrêt TOLE_FONC atteint, la variation de la fonctionnelle est : %(r1)f <--
"""),

    53 : _("""
--> Arrêt par manque de temps CPU <--
"""),

    54 : _("""
--> Le nombre maximum d'évaluations de la fonction (ITER_FONC_MAXI) a été atteint <--
"""),

    55 : _("""
--> Le nombre maximum d'itérations de l'algorithme (ITER_MAXI) a été atteint <--
"""),

    56 : _("""
======================================================================
                       CONVERGENCE ATTEINTE

"""),

    57 : _("""
======================================================================
                      CONVERGENCE NON ATTEINTE

"""),

    58 : _("""
                 ATTENTION : L'OPTIMUM EST ATTEINT AVEC
                 DES PARAMÈTRES EN BUTÉE SUR LE BORD
                     DU DOMAINE ADMISSIBLE
"""),

    60 : _("""
Valeurs propres du Hessien:
%(k1)s
"""),

    61 : _("""
Vecteurs propres associés:
%(k1)s
"""),

    62 : _("""

              --------

"""),

    63 : _("""
On peut en déduire que :

"""),

    64 : _("""
Les combinaisons suivantes de paramètres sont prépondérantes pour votre calcul :

"""),

    65 : _("""%(k1)s
      associée à la valeur propre %(k2)s

"""),

    66 : _("""
Les combinaisons suivantes de paramètres sont insensibles pour votre calcul :

"""),

    67 : _("""
Calcul avec les paramètres suivants (point courant) :
     %(k1)s
"""),

    68 : _("""
Calcul avec les paramètres suivants (perturbation du paramètre %(k2)s pour le gradient) :
     %(k1)s
"""),


    69 : _("""
Information : les calculs esclaves seront lancés en BATCH avec les paramètres suivants :
     Temps          : %(k1)s sec
     Mémoire totale : %(k2)s Mo
     dont Aster     : %(k3)s Mo
     Classe         : %(k4)s

"""),

    72 : _("""
Fonctionnelle au point X0:
     %(k1)s
"""),

    73 : _("""
Gradient au point X0:
"""),

    74 : _("""
Calcul numéro:  %(k1)s - Diagnostic: %(k2)s
"""),

    75 : _("""
                                    ----------------
                                      Informations

    Lors du calcul du gradient par différences finies, un paramètre perturbé sort de l'intervalle de validité :
        Paramètre                   : %(k1)s
        Paramètre perturbée         : %(k2)s
        Valeur minimale autorisée   : %(k3)s
        Valeur maximale autorisée   : %(k4)s

    --> On continue avec ce paramètre, mais l'étude esclave peut avoir des soucis.

    Pour information, voici le paramètre de perturbation (mot-clé PARA_DIFF_FINI), vérifier qu'il est suffisamment petit
    pour un calcul de gradient par différences finies :
        Paramètre de perturbation   : %(k5)s

                                    ----------------

"""),


    76 : _("""
Le paramètre de perturbation (mot-clé PARA_DIFF_FINI) a pour valeur : %(k1)s

Vérifier qu'il est suffisamment petit pour un calcul de gradient par différences finies

--> On continue avec ce paramètre mais le calcul du gradient pourrait être faux.

"""),

    # 77 : _(u""" """),

    # 78 : _(u""" """),

    79 : _("""

======================================================================
"""),

    80 : _("""======================================================================


"""),

    81 : _("""

Répertoire contenant les exécutions Aster :
   %(k1)s

"""),

    82 : _("""Impossible de créer le répertoire temporaire : %(k1)s
"""),

    83 : _("""
======================================================================

Erreur! Le calcul esclave '%(k1)s' ne s'est pas arrêté correctement!
Les fichiers output et error du job sont recopiés dans l'output du
maître juste au dessus de ce message.

L'output du job est également dans : %(k2)s

======================================================================
"""),

    84 : _("""
Erreur! Au moins un calcul esclave ne s'est pas arrêté correctement! Vérifier le répertoire : %(k1)s
"""),

    85 : _(""" Erreur dans le calcul esclave:
   %(k1)s
"""),

    86 : _("""
Erreur! Le calcul esclave '%(k1)s' n'a pas pu démarrer !
   Diagnostic : %(k2)s

Il s'agit vraisemblablement d'un problème de configuration du serveur de calcul ou de ressources disponibles.
Mettre UNITE_SUIVI et INFO=2 permettra d'avoir des messages supplémentaires dans l'output du maître.
"""),

    # 87 : _(u""" """),

    # 88 : _(u""" """),

    # 89 : _(u""" """),

    # 90 : _(u""" """),

    # 91 : _(u""" """),

    # 92 : _(u""" """),

    # 93 : _(u""" """),

    # 94 : _(u""" """),

    # 95 : _(u""" """),

    # 96 : _(u""" """),

    # 97 : _(u""" """),

    # 98 : _(u""" """),

    99 : _("""Impossible de déterminer l'emplacement de Code_Aster !
Fixer le chemin avec la variable d'environnement ASTER_ROOT.
"""),

}
