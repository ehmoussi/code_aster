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
Le type de résultat DYNA_TRANS ne supporte pas les données complexes.
"""),

    2 : _("""
Le type de résultat DYNA_HARMO ne supporte pas les données réelles.
"""),

    3 : _("""
On ne traite pas les déformations complexes.
"""),

    4 : _("""
Le nombre de DATASET de type 58 est supérieur au produit du nombre de noeuds par le nombre de composantes.
"""),

    5 : _("""
Erreur lors de la lecture du fichier IDEAS.
"""),

    6 : _("""
Seules les données de type déplacement, vitesse, accélération, déformation
 ou contrainte sont traitées.
"""),

    9 : _("""
On ne traite pas la redéfinition des orientations pour les champs de contrainte.
"""),

    10 : _("""
On ne traite pas la redéfinition des orientations pour les champs de déformation.
"""),

    11 : _("""
La condition GAMMA/KSI <= 1 n'est pas respectée.
"""),

    12 : _("""
Incohérence des relations SIGMA_C, SIGMA_P1, M_PIC, A_PIC, A_E et M_E.
"""),

    16 : _("""
Le profil de la matrice n'est sûrement pas plein.
On continue pour vérifier.
"""),

    17 : _("""
Le profil de la matrice n'est sûrement pas plein.
On continue pour vérifier.
"""),

    18 : _("""
Le profil de la matrice n'est pas plein.
On arrête tout.
"""),

    19 : _("""
Le déterminant de la matrice à inverser est nul.
"""),

    23 : _("""
Le pas de temps minimal a été atteint. Le calcul s'arrête.
"""),

    24 : _("""
Données erronées.
"""),

    26 : _("""
Dispositif anti-sismique :  la distance entre les noeuds 1 et 2 est nulle.
"""),

    27 : _("""
Le noeud  %(k1)s  n'est pas un noeud du maillage %(k2)s .
"""),

    28 : _("""
On n'a pas trouvé le ddl DX pour le noeud  %(k1)s .
"""),

    29 : _("""
On n'a pas trouvé le ddl DY pour le noeud  %(k1)s .
"""),

    30 : _("""
On n'a pas trouvé le ddl DZ pour le noeud  %(k1)s .
"""),

    31 : _("""
 calcul non-linéaire par sous-structuration :
 le mot-clé SOUS_STRUC_1 est obligatoire
"""),

    32 : _("""
 argument du mot-clé "%(k1)s" n'est pas un nom de sous-structure
"""),

    35 : _("""
  obstacle BI_CERC_INT : DIST_2 doit être supérieur ou égal a DIST_1
"""),

    36 : _("""
 calcul non-linéaire par sous-structuration :
 pas de dispositif anti-sismique ou de flambage possible
"""),

    37 : _("""
 La sous-structuration en présence de multiappui n'est pas développée.
"""),

    38 : _("""
 conflit entre choc et flambage au même lieu de choc :
 le calcul sera de type flambage
"""),

    39 : _("""
 argument du mot-clé "REPERE" inconnu
"""),

    40 : _("""
 les rigidités de chocs doivent être strictement positives
"""),

    41 : _("""
 les listes AMOR_POST_FL, DEPL_POST_FL et RIGI_POST_FL doivent avoir la même longueur
"""),

    42 : _("""
 les bases utilisées pour la projection sont différentes.
"""),

    43 : _("""
 les bases utilisées n'ont pas le même nombre de vecteurs.
"""),

    46 : _("""
 on n'a pas pu trouver les déplacements initiaux
"""),

    47 : _("""
 on n'a pas pu trouver les vitesses initiales
"""),

    48 : _("""
 on n'a pas pu trouver les variables internes initiales :
 reprise choc avec flambage
"""),

    54 : _("""
 le calcul de la réponse temporelle n'est pas possible pour le type
 de structure étudiée.
"""),

    55 : _("""
 le couplage fluide-structure n'a pas été pris en compte en amont.
"""),

    57 : _("""
Le GROUP_NO %(k1)s ne doit pas contenir plus d'un noeud.
"""),

    64 : _("""
 l'argument du mot-clé "SOUS_STRUC" n'est pas un nom de sous-structure
"""),

    66 : _("""
 le taux de souplesse négligée est supérieur au seuil.
"""),

    76 : _("""
 NUME_ORDRE plus grand que le nombre de modes de la base
"""),

    79 : _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    82 : _("""
Vous réalisez une poursuite d'un calcul avec DYNA_VIBRA.
Le nombre de dispositif de choc est différent.
    Avant      : %(i1)d
    Maintenant : %(i2)d

Conseil :
   Vérifier vos données concernant les dispositifs de choc.
"""),

    83 : _("""
Vous réalisez une poursuite d'un calcul avec DYNA_VIBRA.
La nature, les noeuds du des non-linéarités localisées sont différents.

              Avant     Maintenant
    Nature    %(k1)8s   %(k2)8s
    Noeud1    %(k3)8s   %(k4)8s
    Noeud2    %(k5)8s   %(k6)8s

Conseil :
   Vérifier vos données concernant les dispositifs de choc.
"""),


    84 : _("""
 les données dans la liste DEPL_POST_FL doivent être classées par ordre croissant
"""),

    85 : _("""
 les données dans listes DEPL_POST_FL et RIGI_POST_FL conduisent à des déformations
 totales qui ne sont pas classées par ordre croissant.
 le résultat de DEPL_POST_FL+FNOR_POST_FL/RIGI_POST_FL doit être croissant
"""),

    86 : _("""
 la déformation courante est supérieure à la dernière valeur spécifiée dans RIGI_POST_FL
 La raideur utilisée est à présent constante
"""),

}
