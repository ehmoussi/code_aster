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

    1 : _(u"""
 GAMMA_T et GAMMA_C ne doivent pas être égal à 1 en même temps.
"""),

   2 : _(u"""
 Pour la détermination des paramètres de la loi GLRC_DM, il faut que la valeur de la limite en compression FCJ soit supérieur à la limite en traction FTJ (en valeur absolue).
 -> Conseil : Modifier les valeurs des paramètres matériaux
"""),

    3 : _(u"""
 -> Les valeurs des paramètres de la loi GLRC_DM entraîne un seuil d'endommagement nul.
 -> Conseil : Modifier les valeurs des paramètres matériaux
"""),

    4 : _(u"""
  La valeur de %(k1)s est négative ou trop faible. La valeur est modifiée avec un seuil de 1e-3.
"""),

    5 : _(u"""
 -> La valeur de déformation maximale %(r1)f est inférieur au seuil d'endommagement %(r2)f.
 -> Le modèle GLRC_DM risque de donner des résultats inattendus.
 -> Conseil : Utilisez une loi élastique ou vérifiez les paramètres d'homogénéisation.
"""),

    6 : _(u"""
 -> Le pourcentage des aciers ou l'espace des armatures n'est pas identique dans les deux directions et ne respecte donc pas l'isotropie du modèle.
 -> Le modèle GLRC_DM peut donner des résultats inattendus.
 -> Conseil: Choisissez une autre loi de comportement ou couplez le modèle avec un modèle de grille d'acier.
"""),

    8 : _(u"""
 -> L'objet transmis au mot clé MATER de BETON ne contient pas de propriétés élastique.
 -> Risque & Conseil : Ajouter les propriétés élastique dans le DEFI_MATERIAU du béton.
"""),

    10 : _(u"""
 -> L'objet transmis au mot clé MATER d'ACIER ne contient pas de propriétés élastique.
 -> Risque & Conseil : Ajouter les propriétés élastique dans le DEFI_MATERIAU de l'acier.
"""),

    11 : _(u"""
 -> Il est impossible d'utiliser PENTE = ACIER_PLAS si la limite élastique de l'acier SY n'est pas défini.
 -> Risque & Conseil : Ajouter le paramètre SY dans le DEFI_MATERIAU de l'acier
                       ou n'utilisez pas PENTE = ACIER_PLAS
"""),

    13 : _(u"""
 dimension du problème inconnue
"""),

    16 : _(u"""
 le fond de fissure d'un maillage 2d ne peut être défini par des mailles
"""),

    17 : _(u"""
 les mailles à modifier doivent être de type "SEG3" ou "POI1"
"""),

    18 : _(u"""
 le fond de fissure d'un maillage 2d est défini par un noeud unique
"""),

    19 : _(u"""
  -> Code Aster a détecté des mailles de type différent lors de la
     correspondance entre les maillages des deux modèles (mesuré/numérique).
     Ce cas n'est pas prévu, Code Aster initialise la correspondance au noeud
     le plus proche.
  -> Conseil :
     Vérifier la correspondance des noeuds et raffiner le maillage si besoin.
"""),

    20 : _(u"""
 nombre noeuds mesuré supérieur au nombre de noeuds calculé
"""),

    21 : _(u"""
 NOEU_CALCUL non trouvé
"""),

    22 : _(u"""
 NOEU_MESURE non trouvé
"""),

    23 : _(u"""
 nombre de noeuds différent
"""),

    24 : _(u"""
 traitement manuel correspondance : un couple à la fois
"""),

    25 : _(u"""
 échec projection
"""),

    26 : _(u"""
 norme vecteur direction nulle
"""),

    27 : _(u"""
 le nombre des coefficients de pondération est supérieur
 au nombre de vecteurs de base
"""),

    28 : _(u"""
 le nombre des coefficients de pondération est inférieur
 au nombre de vecteurs de base
 le dernier coefficient est affecté aux autres
"""),

    29 : _(u"""
 le nombre des fonctions de pondération est supérieur
 au nombre de vecteurs de base
"""),

    30 : _(u"""
 le nombre des fonctions de pondération est inférieur
 au nombre de vecteurs de base
 la dernière fonction est affectée aux autres
"""),

    31 : _(u"""
 le nombre d'abscisses d'une des fonctions d'interpolation
 n'est pas identique au nombre d'abscisses du premier point
 de mesure expérimental
"""),

    32 : _(u"""
  le critère d'égalité de la liste d'abscisses du premier DATASET 58
  et de la liste d'abscisses d une des fonctions de pondération
  n'est pas vérifié
"""),

    33 : _(u"""
 incompatibilité NOM_PARA et données mesurées
"""),

    34 : _(u"""
 L'option RIGI_INIT pour le mot-clé FLEXION conduit à une valeur négative pour
 le paramètre gamma en flexion. 
 On modifie donc le moment seuil et la pente de flexion.
"""),

    35 : _(u"""
 La courbure de calage KAPPA_FLEX est inférieure la limite de courbure de la section élastique,
 égale à %(k1)s. Dans ce cas, on considère le moment d'initiation de la première fissure
 et une pente d'endommagement nulle. 
"""),

    36 : _(u"""
 Le choix de KAPPA_FLEX conduit à un coefficient GAMMA_F négatif.
 On impose donc GAMMA_F = 0.d0 et le moment limite est celui de l'initiation de la fissure.
"""),

    37 : _(u"""
 Au moins un des paramètres SIGM_LIM et EPSI_LIM est absent du matériau renseigné pour
 le mot-clé NAPPE/MATER. Cela indique que ce matériau n'a pas été créé par DEFI_MATER_GC/ACIER.
 Veuillez utiliser cette procédure pour créer ce matériau.
"""),

    38 : _(u"""
 Au moins un des paramètres FCJ, EPSI_C et FTJ est absent du matériau renseigné pour
 le mot-clé BETON/MATER. Cela indique que ce matériau n'a pas été créé par DEFI_MATER_GC/BETON_GLRC.
 Veuillez utiliser cette procédure pour créer ce matériau.
"""),

    55 : _(u"""
 THETA = 1 ou 0.5
"""),

    57 : _(u"""
 fluence décroissante (PHI<0)
"""),

    58 : _(u"""
Relation 1d sans loi de fluence appropriée
"""),

    59 : _(u"""
 erreur direction grandissement
"""),

    61 : _(u"""
 BARCELONE :
 il faut que la contrainte hydrostatique soit supérieure
 à la  pression de cohésion -KC*PC
"""),

    62 : _(u"""
 ITER_INTE_MAXI insuffisant lors du calcul de la borne
"""),

    63 : _(u"""
 CAM_CLAY :
 le cas des contraintes planes n'est pas traité pour ce modèle.
"""),

    64 : _(u"""
 CAM_CLAY :
 il faut que la contrainte hydrostatique soit supérieure
 a la pression initiale PA
"""),

    67 : _(u"""
 N doit être strictement positif.
"""),

    68 : _(u"""
 paramètre UN_SUR_K égal à zéro cas incompatible avec VISC_CINE_CHAB
"""),

    69 : _(u"""
 loi VISC_CINE_CHAB
 on doit obligatoirement avoir UN_SUR_M = zéro
"""),

    79 : _(u"""
 F reste toujours positive.
"""),

    80 : _(u"""
 Problème interprétation variable entière
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    81 : _(u"""
 Utilisez ALGO_1D="DEBORST" sous %(k2)s pour le comportement %(k1)s.
"""),

    86 : _(u"""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    87 : _(u"""
 loi de comportement inexistante
"""),

    88 : _(u"""
 erreur dans le type de comportement
"""),

    92 : _(u"""
 pas de contraintes planes
"""),

    96 : _(u"""
 Grandes déformations GROT_GDEP requises pour le matériau ELAS_HYPER.
"""),

}
