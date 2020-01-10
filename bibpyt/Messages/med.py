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

from code_aster.Utilities import _

cata_msg = {

    1 : _("""
  -> Absence de localisation de points de Gauss dans le fichier MED
     pour l'élément de référence %(k1)s.
     On suppose que l'ordre des points de Gauss est celui de Code_Aster.
  -> Risque & Conseil :
     Risque de résultats faux.
"""),

    2 : _("""
  -> Le nombre de points de Gauss est différent entre le fichier MED et Aster:
      - nombre de points de Gauss contenu dans le fichier MED : %(i1)d
      - nombre de points de Gauss défini dans Aster           : %(i2)d

     Cette partie du champ ne sera pas relu.

  -> Conseil :
      - Choisissez des éléments finis compatibles entre Aster et le code tiers
"""),

    3 : _("""
  -> Les point de Gauss MED/Aster ne correspondent pas géométriquement.
  -> Risque & Conseil:
     Risque de résultats faux à cause cette incompatibilité.
"""),

    4 : _("""

     Point De Gauss : %(i1)d              MED               ASTER
"""),

    5 : _("""
        %(k1)s                          %(r1)f          %(r2)f
"""),

    6 : _("""
  -> Une ou plusieurs permutations ont été effectuées sur l'ordre des points
     de Gauss pour que la localisation MED corresponde à celle de Code_Aster.
"""),

    7 : _("""
  -> Le nom de groupe "%(k1)s" est trop long. Il sera ignoré dans le maillage
     utilisé par le calcul.

  -> Conseil:
     Si vous voulez utiliser ce groupe dans le calcul, il faut le renommer en limitant
     à 24 caractères son nom.
"""),

    8 : _("""
Création du fichier au format MED %(i1)d.%(i2)d.%(i3)d.
"""),

    9 : _("""
On ne peut pas écrire au format MED %(i1)d.%(i2)d.%(i3)d.
"""),

    10 : _("""
  -> Le nom de groupe "%(k1)s" contient des caractères interdits.
     Le groupe "%(k1)s" est renommé en "%(k2)s".
"""),



    12 : _("""
  -> Erreur, code retour = %(k1)s
  -> Risque & Conseil :
     Vérifier l'intégrité du fichier MED avec medconforme/mdump.
     Si le maillage a été produit par un code externe, vérifier que les
     noms de maillage, de groupes, de familles ne contiennent pas de
     blancs à la fin.
     Dans SALOME, on peut renommer ces entités et supprimer les espaces
     invalides.
"""),



    17 : _("""
  -> Aucune famille n'est présente dans ce fichier MED.
  -> Risque & Conseil :
     Vérifier l'intégrité du fichier MED avec medconforme/mdump.
"""),



    19 : _("""
  -> Les mailles  %(k1)s ne sont pas nommées dans le fichier MED.
"""),



    21 : _("""
  -> Il manque les coordonnées !
"""),



    23 : _("""
  -> Mailles  %(k1)s
"""),

    24 : _("""
  -> Le fichier n'a pas été construit avec la même version de MED.
  -> Risque & Conseil :
     La lecture du fichier peut échouer !

"""),

    25 : _("""
   Version de la bibliothèque MED utilisée par Code_Aster:  %(i1)d %(i2)d %(i3)d
"""),

    26 : _("""
   Version de la bibliothèque MED qui a créé le fichier  : < 2.1.5
"""),

    27 : _("""
   Version de la bibliothèque MED pour créer le fichier  :  %(i1)d %(i2)d %(i3)d
"""),

    28 : _("""

   Un utilitaire vous permet peut-être de convertir votre fichier (medimport)
"""),

    29 : _("""
  -> Il manque les mailles !
"""),

    30: _("""
  -> Votre modèle semble être composé de plusieurs modélisations, les composantes
      de %(k1)s qui n'existent pas pour une partie du modèle ont été
      mises à zéro.

     Dans certains cas, le fichier MED produit peut devenir volumineux. Dans ce
     cas, l'utilisation du mot-clé NOM_CMP est conseillée.
"""),

    31 : _("""
  -> Ce champ existe déjà dans le fichier MED avec un nombre de composantes
     différent à un instant précédent. On ne peut pas le créer de nouveau.

     Nom MED du champ : "%(k1)s"

  -> Risque & Conseil :
     On ne peut pas imprimer un champ dont le nombre de composantes varie en
     fonction du temps. Plusieurs possibilités s'offrent à vous:
     - si vous souhaitez disposer d'un champ disposant des mêmes composantes
     à chaque instant, il faut renseigner derrière le mot-clé NOM_CMP le nom
     des composantes commun aux différents instants.
     - si vous souhaitez imprimer un champ avec l'ensemble des composantes
     Aster qu'il contient, il suffit de faire plusieurs IMPR_RESU et de
     renseigner pour chaque impression une liste d'instants ad hoc.
"""),

    32 : _("""
     Le champ %(k1)s est inconnu dans le fichier MED.
"""),

    33 : _("""
     Il manque des composantes.
"""),

    34 : _("""
     Aucune valeur n'est présente à cet instant.
"""),

    35 : _("""
     Aucune valeur n'est présente à ce numéro d'ordre.
"""),

    36 : _("""
     Le nombre de valeurs n'est pas correct.
"""),

    37 : _("""
  -> La lecture est donc impossible.
  -> Risque & Conseil :
     Veuillez vérifier l'intégrité du fichier MED avec medconforme/mdump.
"""),

    38 : _("""
  -> Incohérence catalogue - fortran
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    39 : _("""
  -> Incohérence catalogue - fortran
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    40 : _("""
  -> Ouverture du fichier MED en mode  %(k1)s  %(k2)s
"""),

    41 : _("""
  -> Incohérence de version détectée.
"""),

    42 : _("""
  -> Le type d'entité  %(k1)s  est inconnu.
"""),

    43 : _("""
  Le champ %(k1)s est introuvable dans le fichier MED.
"""),

    44 : _("""
  -> Pas d'écriture pour  %(k1)s
"""),

    45 : _("""
     Issu de  %(k1)s
"""),

    46 : _("""
  -> Le type de champ est inconnu :  %(k1)s
"""),

    47 : _("""
  -> Création des tableaux de valeurs à écrire avec :
"""),

    48 : _("""
  -> Renumérotation impossible avec plus d'un sous-point.
"""),

    49 : _("""
  -> Véritable écriture des tableaux de valeurs
"""),

    50 : _("""
  -> Pas de maillage dans  %(k1)s
"""),

    51 : _("""
  -> Maillage  %(k1)s  inconnu dans  %(k2)s
"""),

    52 : _("""
  ->  Instant inconnu pour ce champ et ces supports dans le fichier.
"""),

    53 : _("""
  ->  La version de la lib MED utilisée par Code_Aster est plus récente que
      celle qui a produit votre fichier MED.
  ->  Conséquence:  On considère les champs aux noeuds par élément
      comme des pseudo champs aux points de Gauss.
      (On utilise pour la lecture du champ %(k1)s
       contenu dans votre fichier MED, le type d'entité MED_MAILLE au lieu
       de MED_NOEUD_MAILLE).
"""),

    54 : _("""
  -> Le maillage fourni à la commande n'est pas cohérent avec le type de structure
     de données résultat que vous souhaitez produire.
"""),


    55 : _("""
  -> Lecture impossible pour  %(k1)s  au format MED
"""),

    56 : _("""
     En effet, le phénomène %(k1)s de votre modèle n'est pas compatible avec une
     SD Résultat de type %(k2)s.
  -> Risque & Conseil :
     Veuillez fournir à LIRE_RESU un autre modèle ou changer de TYPE_RESU.
"""),

    57 : _("""
  -> Le champ  %(k1)s n'existe pas dans le fichier MED.
  -> Conseils :
     Vérifier la présence du champ demandé dans le fichier.
     Vérifier l'intégrité du fichier MED avec medconforme/mdump.

  Remarque : Les champs disponibles dans ce fichier sont listés ci-dessous :
"""),

    58 : _("""
  -> Le nombre de type de maille présent dans le fichier MED est
      différent du nombre de type de maille présent dans le maillage fourni.
  -> Risque & Conseil :
     Le modèle sur lequel le résultat a été créé n'est pas le même
      que le modèle fourni.
     Vérifiez le maillage de votre modèle !
"""),
    59 : _("""
     Les éléments du modèle fourni ont pour support géométrique des
     mailles ne figurant pas dans le fichier MED.
     Par exemple, il y %(i1)d mailles de types %(k1)s dans le fichier MED,
     alors que le modèle en contient %(i2)d.
  -> Risque & Conseil :
     Veuillez fournir un modèle dont le maillage correspond à celui présent
     dans le fichier MED.
"""),

    60 : _("""
  -> On ne traite pas les maillages distants.
"""),

    61 : _("""
     Le maillage contenu dans le fichier MED contient plus de mailles
     que celui associé au maillage en entrée de la commande.
     Par exemple, on dénombre %(i1)d mailles de types %(k1)s dans le maillage
     MED, alors que le maillage aster n'en contient que %(i2)d !
  -> Risque & Conseil :
     Veuillez vérifier que le maillage fourni ne résulte pas d'une restriction,
     ou que l'un des maillages est quadratique et l'autre linéaire.
"""),

    62 : _("""
  -> Impossible de déterminer un nom de maillage MED.
"""),

    63 : _("""
  -> Le mot clé "INFO_MAILLAGE" est réservé au format MED.
"""),

    64 : _("""
  -> Le CARA_ELEM fournit à IMPR_RESU (%(k1)s) est différent de celui lu
     dans le résultat a imprimer (%(k2)s). Cela n'est pas autorisé.
"""),

    65 : _("""
  -> Grandeur inconnue.
"""),

    66 : _("""
  -> Composante inconnue pour la grandeur.
"""),

    67 : _("""
  -> Le maillage %(k2)s est déjà présent dans le fichier MED %(k1)s.
"""),

    68 : _("""
  -> Instant voulu :  %(r1)f
"""),

    69 : _("""
  -> Numéro d'ordre :  %(i1)d numéro de pas de temps :  %(i2)d

"""),

    70 : _("""
  -> Trop de composantes pour la grandeur.
"""),

    71 : _("""
  -> le mot-clé MODELE est obligatoire pour lire un CHAM_ELEM
"""),

    72 : _("""
  -> Nom de composante tronqué à 8 caractères ( %(k1)s  >>>  %(k2)s )
"""),

    73 : _("""
  -> Impossible de trouver la composante ASTER associée a  %(k1)s
"""),

    74 : _("""
  -> Écriture des localisations des points de gauss.
"""),

    75 : _("""
  -> Problème dans la lecture du nom du champ et de ses composantes.
"""),

    76 : _("""
  -> Problème dans le diagnostic.
"""),

    77: _("""
  -> On ne peut lire aucune valeur du champ %(k1)s dans le fichier d'unité %(i1)d.
  -> Risques et conseils:
     Ce problème est peut-être lié à une incohérence entre le champ à lire dans
     le fichier MED (NOEU/ELGA/ELNO/...) et le type du champ que vous avez demandé
     (mot clé TYPE_CHAM).
"""),

    78: _("""
  Problème à l'ouverture du fichier MED sur l'unité %(k1)s
  -> Conseil :
     Vérifier la présence de ce fichier dans le répertoire de lancement de l'étude.
"""),

    79 : _("""
  -> Attention le maillage n'est pas de type non structuré
"""),

    80 : _("""
  -> Le maillage ' %(k1)s ' est inconnu dans le fichier.
"""),

    81 : _("""
  -> Attention, il s'agit d'un maillage structuré
"""),

    82 : _("""
  Le champ %(k1)s ne repose pas sur le groupe de maille sur lequel l'impression au format
  MED est demandée.

  Pour ce champ aucune impression ne sera faite.
"""),

    83 : _("""
Le nombre de valeurs lues dans le fichier MED pour le champ  %(k1)s est différent du
 nombre de valeurs réellement affectées dans le champ dans la structure de données
 résultat :
  - valeurs lues dans le fichier        : %(i1)d
  - valeurs non affectées dans le champ : %(i2)d

Risques :
  Soit le modèle n'est pas adapté au champ que vous souhaitez lire, auquel cas vous risquez
   d'obtenir des résultats faux. Soit le modèle est constitué d'un mélange de modélisations
   qui ne portent pas les mêmes composantes sur les différents éléments du maillage auquel
   cas, cette alarme n'est pas légitime.

Conseil :
  Vérifiez la cohérence du modèle et du fichier MED.
"""),

    84 : _("""
  Le champ relu n'est pas du bon type. Un champ de réel est attendu
  mais le champ contenu dans le fichier MED n'est pas de ce type.

  La relecture de ce champ n'est pas possible.
"""),

    85 : _("""
  -> Maillage présent :  %(k1)s
"""),

    86 : _("""
  -> champ à lire :  %(k1)s type  %(i1)d type  %(i2)d
     instant voulu :  %(r1)f
     --> numéro d'ordre :  %(i3)d
     --> numéro de pas de temps :  %(i4)d
Ce message est un message d'erreur développeur.
Contactez le support technique.

"""),

    87 : _("""
  Le numéro d'ordre %(i1)d que vous avez renseigné ne figure pas
  dans la liste des numéros d'ordre du résultat MED.
  Conséquence: le champ correspondant ne figurera pas dans la
  SD Résultat %(k1)s
"""),


    88 : _("""
  -> Fichier MED :  %(k1)s, nombre de maillages présents : %(i1)d
"""),

    89 : _("""
  -> Écriture impossible pour  %(k1)s  au format MED.
"""),

    90 : _("""
     Début de l'écriture MED de  %(k1)s
"""),

    91 : _("""
  -> Impossible de déterminer un nom de champ MED.
  -> Risque & Conseil:
"""),

    92 : _("""
  -> Le type de champ  %(k1)s  est inconnu pour MED.
  -> Risque & Conseil:
     Veuillez vérifier la mise en données du mot-clé NOM_CHAM_MED
     (LIRE_RESU) ou NOM_MED (LIRE_CHAMP).
"""),

    93 : _("""
     Fin de l'écriture MED de  %(k1)s
"""),

    94 : _("""
  Vous imprimez un champ dont le maillage change au cours du temps.
  Ce type de champ n'est pas autorisé.
  -> Conseil :
     Si la structure de données résultat a été produite par
     CREA_RESU, vérifiez que les champs fournis à cette commande
     reposent sur un seul et même maillage.
"""),

    95 : _("""
  -> Le champ MED %(k1)s est introuvable.
  -> Risque & Conseil:
     Veuillez vérifier la mise en données du mot-clé NOM_CHAM_MED
     ainsi que le fichier MED fourni à l'opérateur.
"""),

    96 : _("""
  -> NOM_MED absent !
  -> Risque & Conseil:
     Veuillez renseigner le mot-clé NOM_MED de l'opérateur LIRE_CHAMP.
"""),

    97 : _("""
  -> Fichier MED :  %(k1)s, Champ :  %(k2)s, Instant voulu :  %(r1)f
     - Type :  %(i1)d
     - Type :  %(i2)d

"""),

    98 : _("""
  -> Fichier MED :  %(k1)s champ :  %(k2)s
"""),

    99 : _("""
  Le nombre de composantes à imprimer est trop grand pour le champ %(k1)s.
  Le format MED accepte au maximum 80 composantes dans un champ.

  Le champ ne sera donc pas imprimé au format MED.
"""),

}
