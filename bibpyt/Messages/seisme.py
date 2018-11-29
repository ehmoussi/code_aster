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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1: _("""
 le noeud %(k1)s n'appartient pas au maillage: %(k2)s
"""),

    2: _("""
 le groupe de noeuds %(k1)s n'appartient pas au maillage: %(k2)s
"""),

    3: _("""
 le noeud %(k1)s n'est pas un noeud support.
"""),

    4: _("""
 le vecteur directeur du spectre est nul.
"""),

    5: _("""
 cas du MONO_APPUI: vous avez déjà donné un spectre pour cette direction.
"""),

    6: _("""
 erreur(s) rencontrée(s) lors de la lecture des supports.
"""),

    7: _("""
 vous avez déjà donné un spectre pour le support %(k1)s
"""),

    8: _("""
 on ne peut pas traiter du MONO_APPUI et du MULTI_APPUI simultanément.
"""),

    9: _("""
 -------Échantillonnage temporel et fréquentiel des signaux -------
        fréquence de coupure     : %(r1).2f Hz
        pas de fréquence         : %(r2)f Hz
        intervalle de temps      : %(r4)f s
        pas de temps    : PAS_INST = %(r3)f s
        nombre de points: NB_POIN  = %(i1)d
        fréquence du filtre temporel passe-haut: FREQ_FILTRE = %(k1)s

"""),

    10: _("""
 correction statique non prise en compte pour l'option: %(k1)s
"""),

    11: _("""
 trop d'amortissements modaux
   nombre d'amortissement: %(i1)d
   nombre de mode        : %(i2)d
"""),

    13: _("""
 il manque des amortissements modaux
   nombre d'amortissements: %(i1)d
   nombre de modes        : %(i2)d
"""),

    14: _("""
 on ne peut pas demander de réponse secondaire sans la réponse primaire
"""),

    15: _("""
 analyse spectrale :
   la base modale utilisée est               : %(k1)s
   le nombre de vecteurs de base est         : %(i1)d
   la règle de combinaison modale est        : %(k2)s
   les options de calcul demandées sont      : %(k3)s """
          ),

    16: _("""
                                               %(k1)s """
          ),

    17: _("""
   la nature de l'excitation est             : %(k1)s """
          ),

    18: _("""
   la règle de combinaison des réponses
   directionnelles est                       : %(k1)s """
          ),

    19: _("""
   la règle de combinaison des contributions
   de chaque mouvement d'appui est           : %(k1)s """
          ),

    20: _("""
 erreur dans les données
   la masse de la structure n'existe pas dans la table: %(k1)s
"""),

    21: _("""
 il faut au moins 2 occurrences de DEPL_MULT_APPUI pour la combinaison des appuis.
"""),

    22: _("""
 COMB_DEPL_APPUI: il faut au moins définir 2 cas derrière le mot clé LIST_CAS.
"""),

    23: _("""
 données incompatibles
   pour la direction   : %(k1)s
   nombre de blocage   : %(i1)d
   nombre d'excitations: %(i2)d
"""),

    24: _("""
 données incompatibles
   pour les modes mécaniques : %(k1)s
   il manque l'option        : %(k2)s
"""),

    25: _("""
  problème stockage
    option de calcul: %(k1)s
    occurrence       : %(i1)d
    nom du champ    : %(k3)s
"""),

    26: _("""
  problème stockage
    option de calcul: %(k1)s
    direction       : %(k2)s
    nom du champ    : %(k3)s
"""),

    27: _("""
  La base modale utilisé %(k1)s ne contient pas tous les paramètres modaux
  nécessaires au calcul.
  Il faut que le concept soit issu d'un calcul sur coordonnées physiques et
  non pas généralisées.
"""),

    28: _("""
  Dans le cas d'excitations décorrélées,
  le mot-clé COMB_MULT_APPUI n'est pas pris en compte.
"""),

    29: _("""
  La définition du groupe d'appuis n'est pas correcte dans le cas décorrélé:
  au moins une excitation appartient à plusieurs groupes d'appuis.
  Les groupes d'appuis doivent être disjoints.
"""),

    30: _("""
  La définition du groupe d'appuis n'est pas correcte dans le cas décorrélé.
  Un seul groupe d'appuis a été constitué contenant tous les appuis.
  Relancez le calcul avec le mot-clé MULTI_APPUI=CORRELE.
"""),

    31: _("""
 Attention,
 il n'y a pas de déplacements différentiels pris en compte dans votre calcul
 spectral multiappui.
"""),

    32: _("""
 Il n'est pas possible d'utiliser la combinaison GUPTA en MULTI_APPUI.
"""),

    33: _("""
 Dans le cadre de l'utilisation de la combinaison de type GUPTA il faut que F1 < F2.
"""),

    34: _("""
 Il n'y a pas de points d'appui sur la structure.
  -> Conseil : Vérifiez dans ASSEMBLAGE que les conditions aux limites sont présentes.
"""),


    35: _("""
Attention, FREQ_FOND < 0 à l'instant t= %(k1)s s.
"""),

    36: _("""
Tolérance sur l'ajustement du spectre au tirage %(i1)d:
L'erreur %(k1)s vaut %(r1).2f %% ce qui est supérieur à la borne de %(r2).2f %% demandée.
"""),

    37: _("""
La fréquence maximale du spectre vaut %(k1)s Hz.
Il faut des fréquences inférieures à 100 Hz pour la modélisation SPEC_FRACTILE.
"""),

    38: _("""
Il faut faire plus d'un seul tirage avec l'option SPEC_MEDIANE.
"""),

    39: _("""
Attention:
    La durée de la simulation vaut %(k1)s s. Elle est inférieure à 1.5 fois la phase forte.
    Ceci peut conduire à des résultats moins bons.
Conseil:
    Augmenter NB_POINT ou réduire la durée de la phase forte.
"""),

    40: _("""
 Le MULT_APPUI n'est compatible qu'avec les modes classiques et ne fonctionne pas avec les modes issus de la sous-structuration
"""),

    41: _("""
 Erreur minimale optimisation multi-objectifs = %(r1).2f %% à l'itération %(i1)d
 Erreur absolue maximale = %(r2).2f  %% pour la fréquence %(r3)f Hz
 Erreur négative max     = %(r4).2f  %% pour la fréquence %(r5)f Hz
 Erreur ZPA max = %(r6).3f %%
 Erreur RMS max = %(r7).3f %%
"""),

    42: _("""
 Itération %(i1)d sur %(i2)d : erreur multi-objectifs = %(r1).2f %%
"""),

    43: _("""
 Erreurs initiales à l'itération 0:
 Erreur ZPA = %(r1).2f %%, erreur max = %(r2).2f %%, erreur RMS = %(r3).2f %%
 Erreur multi-objectifs = %(r4).2f %%
"""),

    44: _("""
 ------- Modulation temporelle         ----------------------------
        paramètres de la fonction de modulation %(k1)s: %(k2)s
        durée de phase forte: %(r1).2f s
        instants de début et de fin phase forte: %(r2).2f s et %(r3).2f s
"""),

    45: _("""Il n'y a pas de fonctions d'excitation de type '%(k1)s'.

Conseil:
    Vérifier le mot-clé NOM_CHAM et que vous souhaitez bien faire un
    calcul de type multi-appui ou avec prise en compte de la correction statique.
"""),

    46: _("""
 --- GRANDEURS MODALES ---
                              FACTEUR DE   MASSE MODALE       FRACTION
 MODE     FREQUENCE  DIR   PARTICIPATION      EFFECTIVE   MASSE TOTALE   CUMUL
"""),

    47: _(""" %(i1)4d  %(r1)12.5e    %(k1)s    %(r2)12.5e   %(r3)12.5e   %(r4)12.4f   %(r5)12.4f
"""),

    48: _("""
 --- GRANDEURS MODALES ---
                              FACTEUR DE   MASSE MODALE
 MODE     FREQUENCE  DIR   PARTICIPATION      EFFECTIVE
"""),

    49: _(""" %(i1)4d  %(r1)12.5e    %(k1)s    %(r2)12.5e    %(r3).5e
"""),

    50: _("""
 MASSE TOTALE DE LA STRUCTURE :  %(r1).5e
"""),

    51: _("""
 MASSE MODALE EFFECTIVE CUMULÉE : 
"""),

    52: _("""       DIRECTION : %(k1)s, CUMUL :  %(r1).5e, SOIT %(r2)12.3f %%
"""),

    53: _("""
 --- VALEURS DU SPECTRE ---
 MODE      FREQUENCE    AMORTISSEMENT    DIR         SPECTRE
"""),

    54: _(""" %(i1)4d   %(r1)12.5e     %(r2)12.5e      %(k1)s    %(r3)12.5e 
"""),

    55: _("""                                           %(k1)s    %(r1)12.5e 
"""),

    56: _("""
 --- VALEURS LUES SUR LE SPECTRE POUR LA CORRECTION STATIQUE ---
 DIRECTION
"""),

    57: _("""         %(k1)s    %(r1)12.5e 
"""),

    58: _("""                       %(k1)s    %(r1)12.5e   %(r2)12.5e   %(r3)12.4f   %(r4)12.4f
"""),

    59: _("""
 --- VALEURS DU SPECTRE ---
 MODE      FREQUENCE   AMORTISSEMENT   DIR   SUPPORT         SPECTRE
"""),

    60: _(""" %(i1)4d   %(r1)12.5e    %(r2)12.5e   %(k1)s     %(k2).8s         %(r3)12.5e 
"""),

    61: _("""                                             %(k1).8s         %(r1)12.5e 
"""),

    62: _("""
 --- VALEURS CORRECTION STATIQUE ---
  DIRECTION                          
"""),

    63: _("""          %(k1)s  %(k2).8s     %(r1)12.5e 
"""),

    64: _("""             %(k1).8s    %(r1)12.5e 
"""),

    65: _("""
--------------------------------------------------------------------------------
"""),

    66: _("""
 --- COMPOSANTE PRIMAIRE ---
 COMBI SUPPORT
"""),

    67: _("""  %(k1)s
"""),

    68: _("""
  --- COMPOSANTE SECONDAIRE ---
   CAS      SUPPORT     CMP        VALEUR    NOEUD_REFE  NOM_CAS
"""),

    69: _("""  %(i1)4d      %(k1).8s       %(k2).8s       %(r1)12.5e   %(k3).8s          %(k4).8s
"""),

    70: _("""
 GROUPE DE CAS
 NUME_ORDRE     COMBI     LIST_CAS
"""),

    71: _("""  %(i1)4d            %(k1)s
"""),

    72: _("""
  SOMME QUADRATIQUE DES OCCURRENCES DE COMB_DEPL_APPUI    

 NUME_ORDRE     CUMUL
"""),

    73: _("""                                       %(k1)s     %(k2).8s         %(r1)12.5e 
"""),

    74: _("""
  COMBINAISON DIRECTION :  %(k1)s   
"""),

    75: _("""       DIRECTION : %(k1)s , CUMUL :  %(r1)12.5e
"""),

    76: _("""                       %(k1)s    %(r1)12.5e   %(r2)12.5e
"""),

    77: _("""  Les coordonnées du noeud de référence COOR_REFE sont : ( %(r1).2f   %(r2).2f   %(r3).2f )              
"""),

    78: _("""  Le temps d'arrivée est négatif: 
                il faut changer les coordonnées du noeud de référence COOR_REFE.            
"""),


    79: _(""" évaluation de la cohérence pour la phase forte du signal:
        instants de début et de fin phase forte: %(r1).2f s et %(r2).2f s
"""),

    80: _("""
Les signaux renseignés dans les opérandes %(k1)s et %(k2)s de EXCIT_SOL n'ont pas
le même nombres de valeurs.           
"""),

    81: _("""
Les valeurs numéro %(i1)d  des abscisses des signaux renseignés dans les opérandes 
%(k1)s et %(k2)s de EXCIT_SOL sont différentes.
"""),

    82: _("""
Il faut renseigner le spectre à un sigma jusque 0.1 Hz pour SPEC_FRACTILE.
"""),

    83: _("""
-------Tirages aléatoires:         ----------------------------
        Le germe pour les tirages aléatoires vaut %(i1)d.
"""),

    84: _("""
La valeur du mot-clé FREQ_MIN est inférieure à la fréquence minimale de la moyenne des spectres calculés
ou du spectre cible fourni dans SPEC_OSCI.
"""),

    85: _("""
La valeur du mot-clé FREQ_MAX est supérieure à la fréquence maximale de la moyenne des spectres calculés
ou du spectre cible fourni dans SPEC_OSCI.
"""),

    86: _("""
La moyenne des spectres calculées est supérieure ou égale au spectre cible sur tout l'intervalle définit
par FREQ_MIN et FREQ_MAX. Il n'y a pas de correction à apporter au spectre moyen.
"""),

    87: _("""
Facteur de correction apporté au spectre moyen : %(r1).2f
"""),

    88: _("""
La table fournie n'est pas issue de GENE_ACCE_SEISME.
"""),

    89: _("""
La valeur du mot-clé DUREE est supérieure à la durée totale des accélérogrammes.
   
   Valeur fournie        : %(r1).2f
   Durée accélérogrammes : %(r2).2f
"""),

    90: _("""
Les spectres fournis par les mots-clés SPEC_OSCI et SPEC_1_SIGMA n'ont pas
les mêmes valeurs de fréquence.

Le calcul du spectre cible "moins un sigma" n'est pas possible.
"""),

    91: _("""
Vous avez renseigné le mot-clé RATIO_HV or il n'y a pas de spectre vertical
dans les données fournies. Ce mot-clé n'a donc aucun impact.
"""),

    92: _("""
Il y a un spectre vertical dans les données fournies, cependant vous n'avez pas renseigné
le mot-clé RATIO_HV. Cette valeur est fixée à 1.
"""),

}
