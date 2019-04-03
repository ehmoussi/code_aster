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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    5 : _("""
La force normale est nulle.
"""),

    6 : _("""
La somme des impacts écrouissage est inférieure à la somme des glissements.
"""),

    7 : _("""
NOM_CAS n'est pas une variable d'accès d'un résultat de type EVOL_THER.
"""),

    8 : _("""
NUME_MODE n'est pas une variable d'accès d'un résultat de type EVOL_THER.
"""),

    9 : _("""
NUME_MODE n'est pas une variable d'accès d'un résultat de type MULT_ELAS.
"""),

    10 : _("""
INST n'est pas une variable d'accès d'un résultat de type MULT_ELAS.
"""),

    11 : _("""
NOM_CAS n'est pas une variable d'accès d'un résultat de type FOURIER_ELAS.
"""),

    12 : _("""
INST n'est pas une variable d'accès d'un résultat de type FOURIER_ELAS.
"""),

    13 : _("""
NOM_CAS n'est pas une variable d'accès d'un résultat de type FOURIER_THER.
"""),

    14 : _("""
INST n'est pas une variable d'accès d'un résultat de type FOURIER_THER.
"""),

    15 : _("""
Le mot-clef RESU_INIT est obligatoire.
"""),

    16 : _("""
Le mot-clef MAILLAGE_INIT est obligatoire.
"""),

    17 : _("""
Le mot-clef RESU_FINAL est obligatoire.
"""),

    18 : _("""
Le mot-clef MAILLAGE_FINAL est obligatoire.
"""),

    24 : _("""
Absence de potentiel permanent.
"""),

    25 : _("""
Le modèle fluide n'est pas thermique.
"""),

    26 : _("""
Le modèle interface n'est pas thermique.
"""),

    27 : _("""
Le modèle fluide est incompatible avec le calcul de masse ajoutée.
Utilisez les modélisations PLAN ou 3D ou AXIS.
"""),

    29 : _("""
Le nombre d'amortissement modaux est différent du nombre de modes dynamiques.
"""),

    30 : _("""
Il n y a pas le même nombre de modes retenus  dans l'excitation modale et
dans la base modale
"""),

    32 : _("""
Avec SOUR_PRESS et SOUR_FORCE, il faut deux points par degré de liberté d'application
"""),

    33 : _("""
Mauvais accord entre le nombre d'appuis et le nombre de valeur dans le mot-clé EXCIT/NUME_ORDRE ou EXCIT/NOEUD
"""),

    34 : _("""
Il faut autant de nom de composantes EXCIT/NOM_CMP
                que de nom de noeuds EXCIT/NOEUD
"""),

    35 : _("""
Précisez le mode statique.
"""),

    36 : _("""
Le mode statique n'est pas nécessaire.
"""),

    37 : _("""
La fréquence minimale doit être plus petite que la fréquence maximale.
"""),

    79 : _("""
Pas d'interpolation possible.
"""),

    82 : _("""
Erreur de la direction de glissement.
 Angle ALPHA: %(k1)s
 Angle BETA : %(k2)s
"""),

    83 : _("""
Arrêt par manque de temps CPU.
"""),

    86 : _("""
La perturbation est trop petite, calcul impossible.
"""),

    87 : _("""
Champ déjà existant
Le champ %(k1)s à l'instant %(r1)g est remplacé par le champ %(k2)s à l'instant %(r2)g avec la précision %(r3)g.
"""),

    88 : _("""
Arrêt débordement assemblage : ligne.
"""),

    90 : _("""
Arrêt débordement assemblage : colonne.
"""),

    92 : _("""
Arrêt pour nombre de sous-structures invalide :
 Il en faut au minimum : %(i1)d
 Vous en avez défini   : %(i2)d
"""),

    93 : _("""
Arrêt pour nombre de noms de sous-structures invalide :
 Il en faut exactement : %(i1)d
 Vous en avez défini   : %(i2)d
"""),

    94 : _("""
Arrêt pour nombre de MACR_ELEM invalide :
 Sous-structure %(k1)s
 Il en faut exactement : %(i2)d
 Vous en avez défini   : %(i1)d
"""),

    95 : _("""
Arrêt pour nombre d'angles nautiques invalide :
 Sous-structure %(k1)s
 Il en faut exactement : %(i2)d
 Vous en avez défini   : %(i1)d
"""),

    96 : _("""
Arrêt pour nombre de translations invalide :
 Sous-structure %(k1)s
 Il en faut exactement : %(i2)d
 Vous en avez défini   : %(i1)d
"""),

    97 : _("""
Arrêt pour nombre de liaisons définies invalide :
 Il en faut exactement : %(i2)d
 Vous en avez défini   : %(i1)d
"""),

    98 : _("""
Arrêt pour nombre de mots-clés invalide :
 Numéro liaison : %(i1)d
 Mot-clé        : %(k1)s
 Il en faut exactement : %(i3)d
 Vous en avez défini   : %(i2)d
"""),

    99 : _("""
Arrêt pour sous-structure indéfinie :
 Numéro liaison    : %(i1)d
 Nom sous-structure: %(k1)s
"""),

}
