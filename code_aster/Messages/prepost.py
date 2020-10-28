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
Opérateur CALC_CHAMP et parallélisme en temps.
Le modèle du calcul semble changer au cours du transitoire. Dans ce cas de
figure le parallélisme en temps n'est pas encore disponible.

Conseil
=======
Relancer le calcul en désactivant ce type de parallélisme avec
PARALLELISME_TEMPS='NON'.
"""),
    3 : _("""
 Dans le cas d'un défaut SEMI_ELLIPSE, les mots-clés suivants doivent être présents :

   - EPAIS_MDB : épaisseur du métal de base
   - MATER_MDB : matériau constituant le métal de base
"""),

    4 : _("""
 La méthode %(k1)s est illicite
"""),

    5 : _("""
 Dans le cas d'un défaut de type ELLIPSE, la longueur du défaut n'est pas en accord :

   - Décalage >= 0 : avec la table coté métal de base,
   - Décalage <  0 : avec les tables définies cote revêtement et coté métal de base.
"""),

    6 : _("""
 Attention: le nombre de points de la table TABL_MECA_MDB est de %(i1)d. Il doit
 être égale a 5.
"""),

    7 : _("""
  Dans le cas d'un défaut ELLIPSE le mot-clé TABL_MECA_REV est obligatoire.
"""),

    8 : _("""
 prolongement à gauche exclu
"""),

    9 : _("""
 prolongement à droite exclu
"""),

    10 : _("""
 phénomène non valide
"""),

    11 : _("""
 la macro-commande POST_ERREUR prend en charge seulement le phénomène MECANIQUE.
"""),

    12 : _("""
 une et une seule fonction doit être associée à chaque GROUP_MA, pour la composante %(k1)s.
"""),

    13 : _("""
 Les valeurs non existantes du champ %(k1)s lues sur le maillage donné
 sont considérées nulles.
"""),
    15 : _("""
Opérateur CALC_CHAMP et parallélisme en temps:
Le calcul n'a pas pu bénéficier de ce type de parallélisme. Sans doute n'a-t-il
été lancé que sur 1 processus MPI ou avec un nombre d'instants inférieur à
celui des processus MPI.

Le calcul continue en ne bénéficiant, éventuellement, que du parallélisme en
espace (comme si le mot-clé PARALLELISME_TEMPS était renseigné à 'NON'). Cela
pourrait le ralentir sur ce calcul d'option.

Conseil
=======
Vérifier votre nombre de processus MPI ou votre liste d'instants. Sinon
relancer en posant PARALLELISME_TEMPS='NON' afin d'éteindre cette alarme.
"""),
    16 : _("""
Opérateur CALC_CHAMP et parallélisme en temps.
Le NUME_DDL du calcul semble changer au cours du transitoire. Dans ce cas
de figure le parallélisme en temps n'est pas encore disponible.

Conseil
=======
Relancer le calcul en désactivant ce parallélisme (PARALLELISME_TEMPS='NON').
"""),
    17 : _("""
Opérateur CALC_CHAMP et parallélisme en temps.
Le champ calculé semble changer de taille au cours du transitoire. Dans ce cas
de figure le parallélisme en temps n'est pas encore disponible.

Conseil
=======
Relancer le calcul en désactivant ce parallélisme (PARALLELISME_TEMPS='NON').
"""),
    18 : _("""
Opérateur CALC_CHAMP et parallélisme en temps.
La configuration du calcul a conduit à une alarme non encore gérée avec ce
type de parallélisme. Le comportement du calcul risque d'être différent du
mode séquentiel. On arrête donc le calcul au cas où.

Conseil
=======
Relancer le calcul en désactivant ce parallélisme (PARALLELISME_TEMPS='NON')
ou en remédiant à cette alarme.
"""),
    19 : _("""
Opérateur CALC_CHAMP et parallélisme en temps:
Le calcul n'a pas pu bénéficier de ce type de parallélisme car il n'est pas
encore disponible pour les options de calcul du mot-clé facteur CHAMP_UTIL.

Le calcul continue en ne bénéficiant, éventuellement, que du parallélisme en
espace (comme si le mot-clé PARALLELISME_TEMPS était renseigné à 'NON').

Conseil
=======
Relancer en posant PARALLELISME_TEMPS='NON' afin d'éteindre cette alarme.
"""),
    21 : _("""
 Intersection Droite / Cercle
 pas d'intersection trouvée
"""),
    22 : _("""
Nombre de pas de temps=%(i1)d
Calcul option=%(k1)s --> parallélisme en temps activé
"""),
    23 : _("""
Calcul option=%(k1)s --> parallélisme en espace activé
"""),
    24 : _("""
Calcul option=%(k1)s --> parallélisme en espace désactivé
"""),
    25 : _("""
Calcul option=%(k1)s --> calcul sur 1 processus, aucun parallélisme MPI activé
"""),
    28 : _("""
 volume supérieur à 1.d6
"""),

    31 : _("""
 structure de données RESULTAT inconnue  %(k1)s
"""),

    36 : _("""
 Le champ de:  %(k1)s  a des éléments ayant des sous-points.
 Ces éléments ne seront pas traités.
"""),

    38 : _("""
 le vecteur défini sous le mot clé ACTION/AXE_Z a une norme nulle.
"""),

    39 : _("""
 Le résultat généralisé en entrée (%(k1)s) est issu d'un calcul en sous-structuration,
 et non pas d'un calcul standard avec une simple projection sur base modale.

 Les opérations de restitution par POST_GENE_PHYS sont actuellement limitées aux calculs
 du dernier type (projections simples).

 Conseil :
 Utilisez l'un des deux opérateurs REST_GENE_PHYS ou REST_SOUS_STRUC pour restituer sur
 base physique vos résultats en coordonnées généralisées.
"""),

    40 : _("""
 La base modale de projection %(k1)s, référencée dans le résultat généralisé, est
 différente de celle donnée en entrée sous le mot-clé MODE_MECA (%(k2)s).

 Vérifiez que les coordonnées généralisées peuvent être restituées sur cette dernière
 base.
"""),

    41 : _("""
 Pour l'observation %(i1)d :

 La restitution du champ %(k1)s n'est possible que si il a préalablement été calculé sur
 la base de projection. Or, dans la base %(k3)s, le champ %(k2)s n'a pas été trouvé.

 Conseil :
 Essayez d'enrichir la base %(k3)s avec un appel préalable à CREA_CHAMP, option %(k2)s.
"""),

    42 : _("""
 Pour l'observation %(i1)d :

 Il n'a pas été possible de trouver le composant %(k1)s dans le champ demandé %(k2)s.

 Conseil :
 Si vous ignorez les noms des composants de votre champ, il est possible d'appeler
 l'opérateur sans spécifier le mot-clé NOM_CMP. Cela permet d'en restituer la totalité.
"""),

    43 : _("""
 Pour l'observation no. %(i1)d :

 Vous avez demandé le champ : %(k2)s. Néanmoins, il n'existe aucune information
 dans le résultat généralisé %(k1)s quant à la présence d'un chargement
 dynamique en multi-appuis.

 Si la structure est entraînée par une accélération en mono-appui, il faudra
 renseigner le mot-clé ACCE_MONO_APPUI afin de prendre en compte cette accélération
 dans le champ ACCE_ABSOLU.

 Le résultat obtenu correspond donc au champ %(k3)s, en relatif.
"""),

    44 : _("""
 Pour l'observation no. %(i1)d :

 Vous avez demandé le champ : %(k2)s. Néanmoins, il n'existe aucune information
 dans le résultat généralisé %(k1)s quant à la présence d'un chargement
 dynamique en multi-appuis.

 Il n'est actuellement pas possible de récupérer déplacements et vitesses absolues
 en mono-appui. Pour l'accélération absolue, ceci est possible mais il est impératif
 de compléter avec le mot-clé ACCE_MONO_APPUI pour restituer le champ ACCE_ABSOLU.

 Le résultat obtenu correspond donc au champ %(k3)s, en relatif.
"""),

    45 : _("""
 Pour l'observation no. %(i1)d :

 Vous avez demandé de restituer l'accélération absolue (ACCE_ABSOLU) en précisant la
 fonction de l'accélération en mono-appui ainsi que sa direction.

 Le résultat généralisé %(k1)s a été calculé en présence des chargements en
 multi-appuis. L'accélération restituée est le cumul de l'accélération relative
 et les différentes accélérations d'entraînement en mono ainsi qu'en multi-appuis.
"""),


    46 : _("""
 erreur dans la création du fichier de maillage au format GIBI.
 Celui-ci ne contient pas d'objet de type maillage.

 Risque & Conseil:
 Assurez vous que votre procédure GIBI sauvegarde bien les objets du maillage (pile 32 dans le formalisme GIBI)
"""),

    51 : _("""
 l'option de calcul " %(k1)s " n'existe pas dans la structure de données %(k2)s
"""),

    52 : _("""
 le champ " %(k1)s " pour l'option de calcul " %(k2)s ", n'a pas été notée
 dans la structure de données %(k3)s
"""),

    53 : _("""
 la dimension du problème est invalide : il faut : 1d, 2d ou 3d.
"""),

    54 : _("""
 nombre de noeuds supérieur au maximum autorisé : 27.
"""),

    55 : _("""
Problème à la lecture des points
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    56 : _("""
 type de maille :  %(k1)s  inconnu de la commande PRE_GIBI.
"""),

    57 : _("""
 nombre d'objets supérieur au maximum autorisé : 99999.
"""),

    59 : _("""
 le maillage GIBI est peut être erroné :
 on continue quand même, mais si vous avez des problèmes plus loin ...
"""),

    60 : _("""
 arrêt sur erreur(s)
"""),

    69 : _("""
 problème à l'ouverture du fichier
"""),

    70 : _("""
 problème à la fermeture du fichier
"""),

    74 : _("""
 la variable  %(k1)s  n'existe pas
"""),

    75 : _("""
 pas d'impression du champ
"""),

    80 : _("""
 on traite les TRIA7 QUAD9 en oubliant le noeud centre
"""),

    83: _("""
 Certaines composantes sélectionnées ne font pas partie du LIGREL
"""),

    84 : _("""
 Élément PYRAM5 non disponible dans IDEAS
"""),

    85 : _("""
 Élément PYRAM13 non disponible dans IDEAS
"""),

    86 : _("""
 Cas particulier pour l'impression des mailles suivantes, on traite :
     - les PENTA18 en oubliant le(s) noeud(s) au centre
     - les SEG4 en oubliant les 2 noeuds centraux
     - les TETRA9 en oubliant les 4 noeuds au centre des faces
     - les TRIA4 en oubliant le noeud central
"""),

    87 : _("""
 On ne sait pas imprimer le champ de type:  %(k1)s
 champ :  %(k2)s
"""),

    90 : _("""
 On ne sait pas imprimer le champ  %(k1)s  au format  %(k2)s
"""),

    91 : _("""
 On ne sait pas imprimer au format 'MED' les cartes de type %(k1)s
"""),

    97 : _("""
 On ne sait pas imprimer les champs de type " %(k1)s "
"""),

}
