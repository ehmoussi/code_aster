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

from ..Utilities import _

cata_msg = {

    1 : _("""
 GAMMA_T et GAMMA_C ne doivent pas être égal à 1 en même temps.
"""),

   2 : _("""
 Pour la détermination des paramètres de la loi GLRC_DM, il faut que la valeur de la limite en compression FCJ soit supérieur à la limite en traction FTJ (en valeur absolue).
 -> Conseil : Modifier les valeurs des paramètres matériaux
"""),

    3 : _("""
 -> Les valeurs des paramètres de la loi GLRC_DM entraîne un seuil d'endommagement nul.
 -> Conseil : Modifier les valeurs des paramètres matériaux
"""),

    4 : _("""
  La valeur de %(k1)s est négative ou trop faible. La valeur est modifiée avec un seuil de 1e-3.
"""),

    5 : _("""
 -> La valeur de déformation maximale %(r1)f est inférieur au seuil d'endommagement %(r2)f.
 -> Le modèle GLRC_DM risque de donner des résultats inattendus.
 -> Conseil : Utilisez une loi élastique ou vérifiez les paramètres d'homogénéisation.
"""),

    6 : _("""
 -> Le pourcentage des aciers ou l'espace des armatures n'est pas identique dans les deux directions et ne respecte donc pas l'isotropie du modèle.
 -> Le modèle GLRC_DM peut donner des résultats inattendus.
 -> Conseil: Choisissez une autre loi de comportement ou couplez le modèle avec un modèle de grille d'acier.
"""),

    8 : _("""
 -> L'objet transmis au mot clé MATER de BETON ne contient pas de propriétés élastique.
 -> Risque & Conseil : Ajouter les propriétés élastique dans le DEFI_MATERIAU du béton.
"""),

    10 : _("""
 -> L'objet transmis au mot clé MATER d'ACIER ne contient pas de propriétés élastique.
 -> Risque & Conseil : Ajouter les propriétés élastique dans le DEFI_MATERIAU de l'acier.
"""),

    11 : _("""
 -> Il est impossible d'utiliser PENTE = ACIER_PLAS si la limite élastique de l'acier SY n'est pas défini.
 -> Risque & Conseil : Ajouter le paramètre SY dans le DEFI_MATERIAU de l'acier
                       ou n'utilisez pas PENTE = ACIER_PLAS
"""),

    13 : _("""
 dimension du problème inconnue
"""),

    16 : _("""
 le fond de fissure d'un maillage 2d ne peut être défini par des mailles
"""),

    17 : _("""
 les mailles à modifier doivent être de type "SEG3" ou "POI1"
"""),

    18 : _("""
 le fond de fissure d'un maillage 2d est défini par un noeud unique
"""),

    19 : _("""
  -> Code Aster a détecté des mailles de type différent lors de la
     correspondance entre les maillages des deux modèles (mesuré/numérique).
     Ce cas n'est pas prévu, Code Aster initialise la correspondance au noeud
     le plus proche.
  -> Conseil :
     Vérifier la correspondance des noeuds et raffiner le maillage si besoin.
"""),

    20 : _("""
 nombre noeuds mesuré supérieur au nombre de noeuds calculé
"""),

    21 : _("""
 NOEU_CALCUL non trouvé
"""),

    22 : _("""
 NOEU_MESURE non trouvé
"""),

    23 : _("""
 nombre de noeuds différent
"""),

    24 : _("""
 traitement manuel correspondance : un couple à la fois
"""),

    25 : _("""
 échec projection
"""),

    26 : _("""
 norme vecteur direction nulle
"""),

    27 : _("""
 le nombre des coefficients de pondération est supérieur
 au nombre de vecteurs de base
"""),

    28 : _("""
 le nombre des coefficients de pondération est inférieur
 au nombre de vecteurs de base
 le dernier coefficient est affecté aux autres
"""),

    29 : _("""
 le nombre des fonctions de pondération est supérieur
 au nombre de vecteurs de base
"""),

    30 : _("""
 le nombre des fonctions de pondération est inférieur
 au nombre de vecteurs de base
 la dernière fonction est affectée aux autres
"""),

    31 : _("""
 le nombre d'abscisses d'une des fonctions d'interpolation
 n'est pas identique au nombre d'abscisses du premier point
 de mesure expérimental
"""),

    32 : _("""
  le critère d'égalité de la liste d'abscisses du premier DATASET 58
  et de la liste d'abscisses d une des fonctions de pondération
  n'est pas vérifié
"""),

    33 : _("""
 incompatibilité NOM_PARA et données mesurées
"""),

    34 : _("""
 L'option RIGI_INIT pour le mot-clé FLEXION conduit à une valeur négative pour
 le paramètre gamma en flexion.
 On modifie donc le moment seuil et la pente de flexion.
"""),

    35 : _("""
 La courbure de calage KAPPA_FLEX est inférieure la limite de courbure de la section élastique,
 égale à %(k1)s. Dans ce cas, on considère le moment d'initiation de la première fissure
 et une pente d'endommagement nulle.
"""),

    36 : _("""
 Le choix de KAPPA_FLEX conduit à un coefficient GAMMA_F négatif.
 On impose donc GAMMA_F = 0.d0 et le moment limite est celui de l'initiation de la fissure.
"""),

    37 : _("""
 Au moins un des paramètres SIGM_LIM et EPSI_LIM est absent du matériau renseigné pour
 le mot-clé NAPPE/MATER. Cela indique que ce matériau n'a pas été créé par DEFI_MATER_GC/ACIER.
 Veuillez utiliser cette procédure pour créer ce matériau.
"""),

    38 : _("""
 Au moins un des paramètres FCJ, EPSI_C et FTJ est absent du matériau renseigné pour
 le mot-clé BETON/MATER. Cela indique que ce matériau n'a pas été créé par DEFI_MATER_GC/BETON_GLRC.
 Veuillez utiliser cette procédure pour créer ce matériau.
"""),

    55 : _("""
 THETA = 1 ou 0.5
"""),

    57 : _("""
 fluence décroissante (PHI<0)
"""),

    58 : _("""
Relation 1d sans loi de fluence appropriée
"""),

    59 : _("""
 erreur direction grandissement
"""),

    61 : _("""
 BARCELONE :
 il faut que la contrainte hydrostatique soit supérieure
 à la  pression de cohésion -KC*PC
"""),

    62 : _("""
 ITER_INTE_MAXI insuffisant lors du calcul de la borne
"""),

    63 : _("""
 CAM_CLAY :
 le cas des contraintes planes n'est pas traité pour ce modèle.
"""),

    64 : _("""
 CAM_CLAY :
 il faut que la contrainte hydrostatique soit supérieure
 a la pression initiale PA
"""),

    67 : _("""
 N doit être strictement positif.
"""),

    68 : _("""
 paramètre UN_SUR_K égal à zéro cas incompatible avec VISC_CINE_CHAB
"""),

    69 : _("""
 loi VISC_CINE_CHAB
 on doit obligatoirement avoir UN_SUR_M = zéro
"""),

    79 : _("""
 F reste toujours positive.
"""),

    80 : _("""
 Problème interprétation variable entière
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    81 : _("""
 Utilisez ALGO_1D="DEBORST" sous %(k2)s pour le comportement %(k1)s.
"""),

    86 : _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    88 : _("""
 erreur dans le type de comportement
"""),

    92 : _("""
 pas de contraintes planes
"""),

    96 : _("""
 Grandes déformations GROT_GDEP requises pour le matériau ELAS_HYPER.
"""),

}
