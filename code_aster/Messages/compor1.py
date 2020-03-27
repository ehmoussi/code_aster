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

    1: _("""
 HUJEUX : nombre de variables internes incorrect:
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    2: _("""
 HUJEUX : on ne calcule pas la dérivée pour K=4.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    3: _("""
 CAM_CLAY : Le coefficient de poisson et/ou le module de YOUNG ne sont pas corrects
            dans la maille %(k1)s.

             Vérifiez la cohérence des données mécaniques suivantes :
                 E, NU, l'indice des vides, KAPA
                 (contrainte volumique initiale) et KCAM la compressibilité
                 initiale. Si PTRAC et KCAM sont nuls, il faut initialiser les contraintes.

                 Il faut notamment vérifier ceci:
"""),

    4: _("""
 HUJEUX : les modélisations autorisées sont 3D D_PLAN ou AXIS
"""),

    5: _("""
 HUJEUX : Pour le mécanisme isotrope
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    6: _("""
 HUJEUX : erreur inversion par pivot de Gauss
"""),

    7: _("""
 HUJEUX : EPSI_VP est trop grand:
           l'exponentielle explose
"""),

    8: _("""
 HUJEUX : mécanisme indéterminé
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    9 : _("""
Arrêt suite à l'échec de l'intégration de la loi de comportement.
Vérifiez vos paramètres, la cohérence des unités.
Essayez d'augmenter ITER_INTE_MAXI, ou de subdiviser le pas de temps
localement via ITER_INTE_PAS.
"""),

    10: _("""
 HUJEUX : mot-clé inconnu
"""),

    11: _("""
 HUJEUX : modélisation inconnue
"""),

    12: _("""
 HUJEUX : l'incrément de déformation est nul:
           on ne peut pas trouver le zéro de la fonction.
"""),

   13 : _("""
Les contraintes planes ou les modèles unidimensionnels avec la méthode DEBORST et les grandes déformations GDEF_LOG ou SIMO_MIEHE sont incompatibles.
Seules quelques lois de comportement qui ne nécessitent pas la méthode Deborst sont utilisables en grandes déformations.
"""),

    14: _("""
 HUJEUX : erreur dans le calcul de la matrice tangente
"""),

    15: _("""On ne peut pas utiliser les contraintes planes en élasticité avec une déformation de type GROT_GDEP.
    Conseil: utilisez une loi élastoplastique sur laquelle vous aurez mis une limite d'élasticité très grande.
"""),

    17 : _("""
  HUJEUX : Soit le zéro n'existe pas, soit il se trouve hors des
            bornes admissibles.
"""),

    18 : _("""
  HUJEUX : Cas de traction à l'instant moins.
"""),

    19 : _("""
  MONOCRISTAL : écrouissage cinématique non trouvé.
"""),

    20 : _("""
  MONOCRISTAL : écoulement non trouvé.
"""),

    21 : _("""
  MONOCRISTAL : écrouissage isotrope non trouvé.
"""),

    23 : _("""
  MONOCRISTAL : la matrice d'interaction est définie avec
  4 coefficients. Ceci n'est applicable qu'avec 24 systèmes de
  glissement (famille BCC24).
"""),

    24 : _("""
  MONOCRISTAL : la matrice d'interaction est définie avec
  6 coefficients. Ceci n'est applicable qu'avec 12 systèmes de
  glissement.
"""),

    25 : _("""
  MONOCRISTAL : la matrice d'interaction est définie avec
  un nombre de coefficients incorrect : il en faut 1, ou 4, ou 6.
"""),

    26: _("""
 LETK : paramètres de la loi LETK non cohérents
"""),

    27 : _("""
  comportement cristallin  : les coefficients matériau ne peuvent dépendre de la température.
"""),

    28 : _("""
  comportement cristallin homogénéisé : les coefficients matériau ne peuvent dépendre de la température.
"""),

    29: _("""
 LETK : division par zéro - entrée en plasticité avec un déviateur  nul.
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le déviateur.
"""),

    30: _("""
 LETK : division par zéro - entrée en plasticité avec un déviateur nul.
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le déviateur.
"""),

    31: _("""
 LETK : division par zéro - entrée en plasticité avec un déviateur nul.
 le pas de temps est trop petit - augmenter le pas de temps pour augmenter le déviateur.
"""),

    32: _("""
 Comportement  %(k1)s : pour la viscosité, renseigner le mot-clé LEMAITRE dans DEFI_MATERIAU.
 Si vous voulez seulement de l'élastoplasticité, il faut utiliser %(k2)s
"""),

    33: _("""
 HUJEUX : ELAS/ELAS_ORTH : erreur de lecture des propriétés matériaux.
"""),

    34: _("""
 HUJEUX : ELAS/ELAS_ORTH : cas non prévu.
"""),

    35: _("""
 HUJEUX : ELAS/ELAS_ORTH : cas non prévu.
"""),

    36: _("""
 HUJEUX : ELAS/ELAS_ORTH : cas non prévu.
"""),

    37: _("""
 HUJEUX : ELAS/ELAS_ORTH : cas non prévu.
"""),

    38: _("""
 HUJEUX : ELAS/ELAS_ORTH : cas non prévu.
"""),

    39: _("""
 HUJEUX : ELAS/ELAS_ORTH : cas non prévu.
"""),

    40: _("""
 HUJEUX : ELAS/ELAS_ORTH : cas non prévu.
"""),


    41: _("""
 CAM_CLAY :
 Pour la maille <%(k1)s> une des exponentielles pose un problème numérique.
 La subdivision du pas de temps au niveau global est déclenchée.
 Il faut pour cela l'autoriser avec la commande DEFI_LIST_INST.
 Information sur les bornes :
   Valeur max :   <%(r1)E>
   borne correspondant à <%(k2)s> : <%(r2)E>
   borne correspondant à <%(k3)s> : <%(r3)E>
"""),

    42: _("""
 CAM_CLAY :  KCAM et PTRAC doivent vérifier la relation suivante :
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),


    43: _("""
Le numéro de loi de comportement %(i1)d n'existe pas.
Conseil:
Vous utilisez probablement une loi de comportement qui est incompatible avec la modélisation.
Si ce n'est pas le cas, contactez le support technique.
"""),


    44: _("""
 Le type de déformation choisi <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

    45: _("""
 Le type d'algorithme d'intégration choisi : <%(k1)s> (sous COMPORTEMENT/%(k2)s) est incompatible avec le comportement <%(k3)s>.

Conseil :
Ne renseignez pas le mot-clé COMPORTEMENT/%(k2)s, afin de sélectionner l'algorithme par défaut.
"""),

    46: _("""
 Le type de matrice tangente choisi <%(k1)s> est incompatible avec le comportement <%(k2)s>
"""),

    47: _("""
  L'algorithme de réactualisation des grandes rotations est tel que les rotations doivent être inférieures à 2 pi radians.
  Assurez-vous que les rotations ne soient pas très grandes au risque de résultats faux.
"""),

    48: _("""
  La modélisation DKT n'est compatible avec DEFORMATION='GROT_GDEP' que lorsque RELATION = 'ELAS' est utilisé.
  Pour prendre en compte correctement les grands déplacements, et surtout les grandes rotations,
  il est recommandé d’utiliser la modélisation COQUE_3D, avec DEFORMATION='GROT_GDEP'.
"""),

    49: _("""  La modélisation HHO n'est pas compatible ni avec DEFORMATION='SIMO_MIEHE' ni avec DEFORMATION='PETIT_REAC'."""),

    53: _("""
 ECRO_LINE : la plasticité parfaite n'est pas autorisée !
             Par conséquent la pente d'écrouissage H doit être strictement positive.
             (H doit également être inférieure à E).
             Ici, H vaut <%(r1)E>. (E vaut <%(r2)E>)
"""),

    54: _("""
 ECRO_LINE : la pente d'écrouissage H et/ou le module de YOUNG E ne sont pas compatibles :
             H doit être strictement inférieur à E. Ici H=<%(r1)E>, et E=<%(r2)E>.
             Pour modéliser l'élasticité linéaire, il suffit de choisir SY grand, et H < E.
"""),

    55: _("""
La <%(k1)s> dichotomie pour la loi IRRAD3M n'a pas trouvé de solution pour
le nombre d'itération donné <%(i1)d>.
Information pour le débogage
   Borne 0                 : <%(r1).15E>
   Borne 1                 : <%(r2).15E>
   Puissance N             : <%(r3).15E>
   Pas pour la recherche   : <%(r4).15E>
   RM                      : <%(r5).15E>
   EU                      : <%(r6).15E>
   R02                     : <%(r7).15E>
   Précision demandée      : <%(r8).15E>
Valeurs initiales
   N0                      : <%(r9).15E>
   Borne 0                 : <%(r10).15E>
   Borne 1                 : <%(r11).15E>
   Borne E                 : <%(r12).15E>
"""),

    56: _("""
L'irradiation diminue au cours du temps. C'EST PHYSIQUEMENT IMPOSSIBLE.
Grandeurs au point de Gauss :
   Irradiation a t- : <%(r1).15E>
   Irradiation a t+ : <%(r2).15E>
"""),

    57: _("""
Pour information
   Température a t- : <%(r1)E>
   Température a t+ : <%(r2)E>
"""),

    58: _("""
Le franchissement du seuil de fluage ne se fait pas dans la tolérance donnée dans DEFI_MATERIAU
pour la loi IRRAD3M, par le mot clef TOLER_ET.
   Tolérance sur le franchissement du seuil : <%(r1)E>
   Erreur sur le franchissement du seuil    : <%(r2)E>
La subdivision du pas de temps est déclenchée.
Il faut pour cela l'autoriser avec le mot clef SUBD_METHODE de la commande STAT_NON_LINE.
"""),

    59: _("""
Aucune des mailles déclarées dans l'occurrence numéro %(i1)d du mot-clé COMPORTEMENT
n'est présente dans le modèle.
Il faut supprimer cette occurrence pour que le calcul fonctionne.
"""),

    60: _("""
Toutes les mailles déclarées dans l'occurrence numéro %(i1)d du mot-clé COMPORTEMENT
sont des éléments de bord qui ne portent pas de rigidité.
Il faut supprimer cette occurrence pour que le calcul fonctionne.
"""),

    61: _("""
Vous utilisez un comportement élastique non-linéaire avec un état initial.
Cet état initial ne sera pas pris en compte.
"""),


    67 : _("""
Dans la définition du matériau RUPT_DUCT les coefficients de forme de la loi CZM_TRA_MIX doivent vérifier : COEF_EXTR <= COEF_PLAS
"""),

    71 : _("""
Erreur dans le calcul du tenseur équivalent au sens de HILL.
"""),

    72: _("""
 Le nombre de variables internes initiales est incorrect : %(i1)d ; il devrait valoir %(i2)d
"""),

    73: _("""
Lors d'un calcul avec des poutres multifibres, il est nécessaire de renseigner le mot-clé
AFFE_COMPOR dans AFFE_MATERIAU.
"""),

    74: _("""
Vous utilisez la loi de comportement %(k1)s et vous avez définit la caractéristique matériau %(k2)s.
Le champ %(k3)s n'existe pas, on ne peut donc pas en tenir compte.

Pour prendre en compte l'effet de %(k3)s, déformation correspondante non nulle :
- il faut donner %(k2)s et %(k3)s.

Pour ne pas prendre en compte l'effet de %(k3)s, déformation correspondante nulle :
- vous ne donnez pas la caractéristique %(k2)s (valeur par défaut nulle).
- vous donnez la caractéristique %(k2)s, avec une valeur nulle pour le champ %(k3)s.
"""),

    75 : _(""" == Paramètres de la loi %(k1)s ==
 Partie élasticité :
   %(k2)s
 Partie non-linéaire :
   %(k3)s
 Pour information :
   %(k4)s
 =================================================="""),

    76 : _("""
Pour le comportement %(k1)s les paramètres %(k2)s et %(k3)s sont obligatoires.
"""),

    77 : _("""
Le calcul de ENEL_ELGA  n'est pas possible avec DEFORMATION= %(k1)s.
"""),

    78 : _("""
Le calcul de ENER_TOTALE  n'est pas possible avec DEFORMATION= %(k1)s.
"""),

    79 : _("""
Le calcul de ETOT_ELGA  n'est pas possible avec DEFORMATION= %(k1)s.
"""),

    80 : _("""
DELTA1 = %(r1)f doit toujours rester entre 0 et 1.
"""),

    81 : _("""
DELTA2 = %(r1)f doit toujours rester entre 0 et 1.
"""),

    82 : _("""
La température est obligatoire pour le comportement cristallin %(k1)s.
"""),

    83 : _("""
L'état initial des contraintes n'est pas compatible avec le mécanisme isotrope du modèle de HUJEUX.
Conseils: Vérifier l'état des contraintes initiales ou modifier les paramètres matériaux PC0 et/ou D du modèle de HUJEUX.
"""),

    84 : _("""
Comportement  %(k1)s : le paramètre %(k2)s devrait rester positif. Il vaut actuellement <%(r1).15E>.
Conseils: modifiez sa valeur dans CIN1_CHAB / CIN2_CHAB.
"""),

    85: _("""
Aucun groupe de fibres n'a de comportement.
"""),

    86 : _("""
Le ratio FC/FT (%(r1)E) est inférieur à 5.83 (valeur limite pour le modèle ENDO_FISS_BETON).
"""),

    87 : _("""
L'identification numérique des paramètres SIG0 et TAU à partir de FT et FC a échoué : valeurs exotiques ?
"""),

    88 : _("""
Comportement  %(k1)s : avec ELAS_ORTH, il faut renseigner le mot clé MU_MOY.
"""),

    91: _("""
 REST_ECRO : la fonction de restauration d'écrouissage vaut %(r1)E or elle doit être comprise entre 0 et 1.

Vérifiez les valeurs de la fonction.
"""),

    92 : _("""
Seule la modélisation 3D est disponible avec la loi d'endommagement de KIT_RGI.
"""),

    93 : _("""
La donnée de l'énergie de fissuration initiale G_INIT est trop élevée. Elle doit être inférieure à 0.453*GF.
"""),

    94 : _("""
La largeur de bande est trop grande par rapport à la longueur de la zone cohésive si bien que
m=%(r1)f et p=%(r2)f ne respectent pas la contrainte m>p+2.
"""),

    95 : _("""
ITER_INTE_PAS ne peut admettre qu'une valeur positive pour un comportement MFRONT.
 """),

    96 : _("""
Loi de comportement BETON_RAG :
Au temps %(r1)f, une grandeur liée au séchage est inférieure au seuil %(r2)f, ce qui n'a pas de sens physique.
    Séchage au temps précédent : %(r3)f
    Séchage au temps actuel    : %(r4)f
    Séchage de référence       : %(r5)f
 """),

}
