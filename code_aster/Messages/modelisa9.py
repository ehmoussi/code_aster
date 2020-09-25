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
Erreur utilisateur dans la commande CREA_CHAMP / EXTR / TABLE :
   Dans la table %(k1)s, pour créer un champ de type %(k2)s,
   certains paramètres sont obligatoires et d'autres sont interdits :

     NOEU :
       obligatoire : NOEUD
       interdit    : MAILLE, POINT, SOUS_POINT
     ELGA :
       obligatoire : MAILLE, POINT
       interdit    : NOEUD
     ELNO :
       obligatoire : MAILLE, NOEUD (ou POINT)
     ELEM :
       obligatoire : MAILLE
       interdit    : NOEUD, POINT
"""),

    2 : _("""
 Erreur utilisateur dans la commande CREA_CHAMP / EXTR / TABLE  :
   Les paramètres de la table doivent être :
     - soit : MAILLE, NOEUD, POINT, SOUS_POINT
     - soit le nom d'une composante de la grandeur.

   L'une (au moins) des valeurs de la liste : %(ktout)s
   n'est pas le nom d'une composante de la grandeur.

 Conseil :
   Si la table fournie provient de la commande CREA_TABLE / RESU, il faut
   probablement utiliser la commande CALC_TABLE + OPERATION='EXTR' pour
   éliminer les colonnes RESULTAT, NUME_ORDRE, ....
"""),

    3 : _("""
Alarme de programmation :
   Plusieurs matériaux ont été affectés sur la maille %(k1)s.
   Le programme cherche un paramètre matériel (%(k2)s) sans préciser le matériau.
   On utilise le premier matériau de la liste affectée sur la maille.

Risques et conseils :
   Le comportement du code est dangereux car les résultats dépendent de l'ordre
   des matériaux affectés dans la commande AFFE_MATERIAU.
   Il faut sans doute émettre une demande de correction du code.
"""),

    4 : _("""
Alarme de programmation :
   Plusieurs matériaux ont été affectés.
   Le programme cherche un paramètre matériel (%(k1)s) sans préciser le matériau.
   On utilise le premier matériau de la liste affectée sur la maille.

Risques et conseils :
   Le comportement du code est dangereux car les résultats dépendent de l'ordre
   des matériaux affectés dans la commande AFFE_MATERIAU.
   Il faut sans doute émettre une demande de correction du code.
"""),

    5 : _("""
 Erreur utilisateur :
   On cherche à créer un CHAM_ELEM / ELNO à partir d'une table (%(k1)s).
   La maille  %(k2)s a %(i2)d noeuds mais dans la table,
   une ligne concerne un noeud "impossible" :
   noeud de numéro local  %(i1)d  ou noeud de nom %(k3)s
"""),

    6 : _("""
Erreur utilisateur :
   Plusieurs valeurs dans la table %(k1)s pour :
   Maille: %(k2)s
   Point : %(i1)d  ou Noeud : %(k3)s
   Sous-point : %(i2)d
"""),

    7 : _("""
Erreur utilisateur dans la commande CREA_CHAMP / EXTR / TABLE :
   Dans la table %(k1)s, la colonne NOEUD ou la colonne MAILLE
   doit être obligatoirement de type K8, or elle est de type %(k2)s
"""),

    8 : _("""
Erreur :
   On cherche à transformer un CHAM_ELEM en carte.
   CHAM_ELEM : %(k1)s  carte : %(k2)s
   Pour la maille numéro %(i3)d le nombre de points (ou de sous-points) est > 1
   ce qui est interdit.
   Point:       %(i1)d
   Sous-point : %(i2)d
"""),

    10 : _("""
Erreur utilisateur :
   Comportement 'HUJEUX'
   Non convergence pour le calcul de la loi de comportement (NB_ITER_MAX
atteint).

Conseil :
   Augmenter NB_ITER_MAX (ou diminuer la taille des incréments de charge)

"""),

    11 : _("""
 mot-clé facteur non traite :  %(k1)s
"""),

    15 : _("""
 pas de FREQ initiale définie : on prend la fréquence mini des modes calcules
   %(r1)f
"""),

    16 : _("""
 pas de fréquence finale définie : on prend la fréquence max des modes calcules
 %(r1)f
"""),

    17 : _("""
 votre fréquence de coupure   %(r1)f
"""),

    18 : _("""
 est inférieure a celle  du modèle de turbulence adopte :  %(r1)f
"""),

    19 : _("""
 on prend la votre.
"""),

    20 : _("""
 votre fréquence de coupure :   %(r1)f
"""),

    21 : _("""
 est supérieure a celle  du modèle de turbulence adopte :   %(r1)f
"""),

    22 : _("""
 on prend celle du modèle.
"""),

    23 : _("""
 erreur dans les données mot clé facteur  %(k1)s  occurrence  %(i1)d
"""),

    24 : _("""
 le maillage est "plan" ou "z_CSTE"
"""),

    25 : _("""
 le maillage est "3d"
"""),

    26 : _("""
 il y a  %(i1)d  valeurs pour le mot clé  %(k1)s il en faut  %(i2)d
"""),

    27 : _("""
 erreur dans les données mot clé facteur  %(k1)s  occurrence  %(i1)d
 pour le mot clé  %(k2)s
  le noeud n'existe pas  %(k3)s
"""),

    28 : _("""
 erreur dans les données mot clé facteur  %(k1)s  occurrence  %(i1)d
 pour le mot clé  %(k2)s
  le GROUP_NO n'existe pas  %(k3)s
"""),

    29 : _("""
 trop de noeuds dans le GROUP_NO mot clé facteur  %(k1)s  occurrence  %(i1)d
   noeud utilise:  %(k2)s
"""),

    31 : _("""
 poutre : occurrence %(i2)d :
 "CARA" nombre de valeurs entrées:  %(i2)d
 "VALE" nombre de valeurs entrées:  %(i3)d
 vérifiez vos données

"""),

    32 : _("""
 erreur dans les données mot clé facteur  %(k1)s  occurrence  %(i1)d
"""),





    35 : _("""
 il y a  %(i1)d  valeurs pour le mot clé  ANGL_NAUT il en faut  %(i2)d
"""),

    36 : _("""
 erreur dans les données mot clé facteur  %(k1)s  occurrence  %(i1)d
"""),

    39 : _("""
 il y a  %(i1)d  valeurs pour le mot clé  %(k1)s il en faut  %(i2)d
"""),

    40 : _("""
 erreur dans les données mot clé facteur  %(k1)s  occurrence  %(i1)d
"""),

    43 : _("""
 il y a  %(i1)d  valeurs pour le mot clé  %(k1)s il en faut  %(i2)d
"""),

    44 : _("""
 fichier MED :  %(k1)s maillage :  %(k2)s erreur numéro  %(i1)d
"""),

    51 : _("""
 fichier MED :  %(k1)s maillage :  %(k2)s erreur numéro  %(i1)d
"""),

    52 : _("""
 fichier MED :  %(k1)s maillage :  %(k2)s erreur numéro  %(i1)d
"""),

    53 : _("""

 l'identifiant d'une maille dépasse les 8 caractères autorisés:
   %(k1)s
 maille      : %(k2)s
 PREF_MAILLE : %(k3)s
"""),

    54 : _("""
 l'utilisation de 'PREF_NUME' est recommandée.
"""),




    57 : _("""
Erreur d'utilisation pour la commande CREA_MAILLAGE / CREA_GROUP_MA :
  Le programme tente de créer une maille appelée %(k1)s
  mais cette maille a déjà été crée par une occurrence précédente de ce mot clé facteur.

Risques et conseils :
  Pour éviter cette erreur, vous pouvez changer la valeur
  de PREF_MAILLE pour chaque occurrence du mot clé CREA_GROUP_MA.
  """),




    59 : _("""
 erreur lors de la définition de la courbe de traction : %(k1)s
 le premier point de la courbe de traction %(k2)s a pour abscisse:  %(r1)f

"""),

    60 : _("""
 erreur lors de la définition de la courbe de traction :%(k1)s
 le premier point de la courbe de traction %(k2)s a pour ordonnée:  %(r1)f

"""),

    61 : _("""
 Erreur lors de la définition de la courbe de traction : %(k1)s

 la courbe de traction doit satisfaire les conditions suivantes :
 - les abscisses (déformations) doivent être strictement croissantes,
 - la pente entre 2 points successifs doit être inférieure a la pente
   élastique (module de Young) entre 0 et le premier point de la courbe.

 pente initiale (module de Young) :   %(r1)f
 pente courante                  :   %(r2)f
 pour l'abscisse                 :   %(r3)f

"""),

    62 : _("""
 Courbe de traction : %(k1)s points presque alignés. Risque de PB dans
 STAT_NON_LINE en particulier en C_PLAN
  pente initiale :     %(r1)f
  pente courante:      %(r2)f
  précision relative:  %(r3)f
  pour l'abscisse:     %(r4)f

"""),

    63 : _("""
 erreur lors de la définition de la courbe de traction %(k1)s
 le premier point de la fonction indicée par :  %(i1)d de la nappe  %(k2)s
 a pour abscisse:  %(r1)f

"""),

    64 : _("""
 erreur lors de la définition de la courbe de traction %(k1)s
 le premier point de la fonction indicée par :  %(i1)d de la nappe  %(k2)s
 a pour ordonnée:  %(r1)f

"""),

    65 : _("""
 erreur lors de la définition de la courbe de traction %(k1)s
 pente initiale :   %(r1)f
 pente courante:    %(r2)f
 pour l'abscisse:  %(r3)f

"""),



    73 : _("""
Le matériau '%(k1)s' n'a pas été affecté.

Conseil:
    Vérifiez que le mot-clé facteur '%(k1)s' a bien été renseigné dans
    DEFI_MATERIAU et que ce matériau a bien été affecté (par AFFE_MATERIAU)
    sur cette partie du modèle.
"""),

    74 : _("""
 comportement :%(k1)s non trouvé
"""),

    75 : _("""
Le matériau '%(k1)s' n'a pas été affecté à la maille %(k2)s.

Conseil:
    Vérifiez que le mot-clé facteur '%(k1)s' a bien été renseigné dans
    DEFI_MATERIAU et que ce matériau a bien été affecté (par AFFE_MATERIAU)
    sur cette partie du modèle.
"""),

    77 : _("""
 manque le paramètre  %(k1)s
"""),

    78 : _("""
 pour la maille  %(k1)s
"""),

    81 : _("""
  La maille de nom %(k1)s n'est pas de type SEG3 ou SEG4,
  elle ne sera pas affectée par %(k2)s
"""),

    82 : _("""
  GROUP_MA : %(k1)s
"""),

    94 : _("""
     On ne peut pas appliquer un cisaillement 2d sur une modélisation 3D
"""),
    95 : _("""
     ERREUR: l'auto-spectre est a valeurs négatives
"""),

}
