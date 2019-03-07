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

    1 : _("""
La limite mémoire demandée de %(r1).0f octets est supérieure
au maximum adressable sur cette plate-forme (%(r2).0f octets).

Conseil :
    Diminuez la mémoire totale demandée pour le calcul.
"""),

    2 : _("""
 Pointeur de longueur externe interdit maintenant.
"""),

    3 : _("""
Le chemin d'accès au catalogue d'éléments est trop long. Il doit être inférieur
à %(i1)d caractères. Il est défini par la variable d'environnement '%(k1)s'.

Conseil :
    Installer Code_Aster dans un chemin plus accessible, ou bien, créer
    un lien symbolique pour réduire la longueur du chemin.
"""),

    6 : _("""
Appel invalide, la marque devient négative
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    7 : _("""Destruction de '%(k1)s'
"""),

    8 : _("""
 La base  %(k1)s  a été constituée avec la version  %(k2)s
 et vous utilisez la version  %(k3)s

Conseil :
 En général, la base ne peut-être utilisée qu'avec la version du code l'ayant construite,
 les catalogues d'éléments sont stockés dans la base lors de sa création, or certaines structures de 
 données s'appuient sur leur description qui peut varier d'une version à l'autre.
"""),

    10 : _("""
Le nom demandé existe déjà dans la base %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    11 : _("""
 Erreur lors de la fermeture de la base  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    12 : _("""
 Fichier associé à la base  %(k1)s n'existe pas.
 Nom du fichier :  %(k2)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    13 : _("""
 Erreur de lecture du premier bloc de  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    14 : _("""
 Erreur lors de la fermeture de  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    18 : _("""
 Le segment de valeurs associé à l'objet : %(k1)s, n'existe pas en mémoire et
 l'objet ne possède pas d'image disque.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    19 : _("""
 Le nom d'un objet ne doit pas commencer par un blanc.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    21 : _("""
     Nom de la base                          :  %(k1)s
     Créée avec la version                   :  %(k2)s
     Nombre d'enregistrements utilisés       :  %(i1)d
     Nombre d'enregistrements maximum        :  %(i2)d
     Longueur d'enregistrement (octets)      :  %(i3)d
     Nombre d'identificateurs utilisés       :  %(i4)d
     Taille maximum du répertoire            :  %(i5)d
     Pourcentage d'utilisation du répertoire :  %(i6)d %%
"""),

    22 : _("""

     Nom de la base                          :  %(k1)s
     Nombre d'enregistrements utilisés       :  %(i1)d
     Nombre d'enregistrements maximum        :  %(i2)d
     Longueur d'enregistrement (octets)      :  %(i3)d
     Nombre total d'accès en lecture         :  %(i4)d
     Volume des accès en lecture             :  %(r1)12.2f Mo.
     Nombre total d'accès en écriture        :  %(i5)d
     Volume des accès en écriture            :  %(r2)12.2f Mo.
     Nombre d'identificateurs utilisés       :  %(i6)d
     Taille maximum du répertoire            :  %(i7)d
     Pourcentage d'utilisation du répertoire :  %(i8)d %%
"""),

    23 : _("""
     Nom de collection ou de Répertoire de noms inexistant :  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    24 : _("""
Collection ou répertoire de noms  :  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    25 : _("""
Nom de collection ou de répertoire inexistant : %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    26 : _("""
Objet inexistant dans les bases ouvertes : %(k1)s
l'objet n'a pas été créé ou il a été détruit
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    27 : _("""
     Objet simple  inexistant en mémoire et sur disque : %(k1)s
     le segment de valeurs est introuvable
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    28 : _("""
     Collection inexistante en mémoire et sur disque : %(k1)s
     le segment de valeurs est introuvable
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    29 : _("""
     Objet %(i1)d de collection inexistant en mémoire et sur disque : %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    30 : _("""
     Objet de collection inexistant : %(k1)s
     l'objet n'a pas été créé ou il a été détruit
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    31 : _("""
     La routine n'a pas prévu de redimensionner l'objet :%(k1)s
     de type :%(k2)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),


    36 : _("""
     Le nombre d'enregistrements maximum de la base %(k1)s sera modifié
     de %(i1)d a %(i2)d
"""),

    38 : _("""
     Numéro d'objet invalide %(i1)d
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    39 : _("""
     Taille de répertoire demandé trop grande.
     Le maximum est de %(i1)d
     La valeur réclamée est de %(i2)d

"""),

    40 : _("""
     Erreur écriture de l'enregistrement %(i1)d sur la base : %(k1)s %(i2)d
     code retour : %(i3)d
     Erreur probablement provoquée par une taille trop faible du répertoire de travail.
"""),

    41 : _("""
     Erreur lecture de l'enregistrement %(i1)d sur la base : %(k1)s %(i2)d
     code retour : %(i3)d
"""),

    42 : _("""
     Fichier saturé, le nombre maximum d'enregistrement %(i1)d de la base %(k1)s est atteint
     il faut relancer le calcul en passant une taille maximum de base sur la ligne de commande
     argument "-max_base" suivi de la valeur en Mo.
"""),

    43 : _("""
     Erreur d'ouverture du fichier %(k1)s , code retour %(i1)d
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    44 : _("""
  Ouverture en lecture du fichier %(k1)s
"""),

    45 : _("""
  Ouverture en écriture du fichier %(k1)s
"""),

    47 : _("""
 Erreur lors de la relecture d'un enregistrement sur le fichier d'accès direct.
"""),

    48 : _("""
 Erreur lors de l'écriture d'un enregistrement sur le fichier d'accès direct.
"""),

    51 : _("""
 Relecture au format HDF impossible.
"""),

    52 : _("""
 Erreur de relecture des paramètres du DATASET HDF.
"""),

    53 : _("""
 Relecture au format HDF impossible.
"""),

    54 : _("""
 Impossible d'ouvrir le fichier HDF %(k1)s.
"""),

    55 : _("""
 Impossible de fermer le fichier HDF %(k1)s.
"""),

    56 : _("""
 Fermeture du fichier HDF %(k1)s.
"""),

    58 : _("""
 Le répertoire est saturé.
"""),

    59 : _("""
Le nom demandé existe déjà dans le répertoire %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    60 : _("""
 Erreur lors de l'allocation dynamique. Il n'a pas été possible d'allouer
 une zone mémoire de longueur %(i1)d (octets).
 La dernière opération de libération mémoire a permis de récupérer %(i2)d (octets).

"""),

    62 : _("""
 Erreur lors de l'allocation dynamique. Il n'a pas été possible d'allouer
 une zone mémoire de longueur %(i1)d Mo, on dépasse la limite maximum
 fixée à %(i2)d Mo et on occupe déjà %(i3)d Mo.
 La dernière opération de libération mémoire a permis de récupérer %(i4)d Mo.

"""),

    63 : _("""

 Critère de destruction du fichier (%(r2).2f %%) associé à la base %(k1)s dépassé %(r1).2f %%
 Nombre d'enregistrements utilisés : %(i1)d
 Volume disque occupé              : %(i2)d Mo.
 Nombre maximum d'enregistrements  : %(i3)d

"""),


    64 : _("""

 ATTENTION la taille de répertoire de noms atteint %(i1)d pour la base %(k1)s.
 Il sera impossible de l'agrandir.
  -> Conseil :
     Il faut réduire le nombre de concepts sur la base GLOBALE en utilisant
     la commande DETRUIRE.

"""),

    65 : _("""

 ATTENTION la taille de répertoire de noms atteint %(i1)d pour la base %(k1)s.
 Il sera impossible de l'agrandir.
  -> Conseil :
     Il y a trop d'objets créés sur la base VOLATILE, cela peut provenir d'une
     erreur dans la programmation de la commande.

"""),

    66 : _("""

 La base au format HDF de nom %(k1)s ne peut être créée.
 La fonction renvoie un code retour : %(i1)d

"""),


    67 : _("""
Le nombre d'objets de la collection %(k1)s est inférieur ou égal à 0
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),


    68 : _("""

 Le fichier associé à la base demandée %(k1)s n'est pas ouvert.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    69 : _("""

 Le nom %(k1)s est déjà utilise pour un objet simple.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    70 : _("""

 Le type de stockage %(k1)s de la collection est erroné.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    71 : _("""

 La longueur variable pour la collection %(k1)s est incompatible avec le genre.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    72 : _("""

 La longueur du type caractère n'est pas valide pour la collection %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    73 : _("""

 Le nom %(k1)s du pointeur de longueurs est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    74 : _("""

 Le pointeur de longueurs %(k1)s n'a pas été créé dans la bonne base.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    75 : _("""

 Le pointeur de longueurs %(k1)s n'est pas de la bonne taille.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    76 : _("""

 Le type du pointeur de longueurs %(k1)s n'est pas correct (différent d'un entier).
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    77 : _("""

 Le nom du répertoire de noms %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    78 : _("""

Le répertoire de noms %(k1)s n'a pas été créé dans la bonne base.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    79 : _("""

 Le répertoire de noms %(k1)s n'est pas de la bonne taille.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    80 : _("""

 L'objet %(k1)s n'est pas un répertoire de noms.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    81 : _("""
Le type d'accès %(k1)s est inconnu.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    82 : _("""
Le type d'accès %(k1)s de la collection est erroné.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    83 : _("""
Le nom du pointeur d'accès %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    84 : _("""
La longueur du nom %(k1)s est invalide (> 24 caractères).
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    85 : _("""
Le nom %(k1)s est déjà utilisé pour une collection.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    86 : _("""
La longueur du type caractère n'est pas définie pour l'objet %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    87 : _("""
Un objet de genre répertoire doit être de type caractère %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    88 : _("""
La longueur du type caractère %(k1)s n'est pas valide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    89 : _("""
Un objet de genre répertoire doit être de type caractère de longueur multiple de 8 %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    90 : _("""
Un objet de genre répertoire doit être de type caractère de longueur inférieure ou égale à 24 %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    91 : _("""
Le type %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    92 : _("""
La longueur ou la position de la sous chaîne %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    93 : _("""
Les longueurs des sous chaînes %(k1)s sont différentes.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    94 : _("""
Les sous chaînes %(k1)s sont identiques.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    95 : _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    96 : _("""
L'accès est interdit %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    97 : _("""
Erreur lors de l'appel à  %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    98 : _("""
L'attribut %(k1)s est uniquement destiné aux collections contiguës.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    99 : _("""
L'attribut est incompatible avec le genre %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

}
