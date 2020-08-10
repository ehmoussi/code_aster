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
L'attribut %(k1)s est non modifiable ou déjà défini.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    2 : _("""
L'attribut %(k1)s est non modifiable ou déjà défini pour un objet simple.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    3 : _("""
L'attribut %(k1)s n'est pas compatible avec la valeur de la longueur totale de la collection.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    4 : _("""
L'attribut %(k1)s n'est pas accessible ou non modifiable.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    5 : _("""
Pour une collection contiguë, il faut définit %(k1)s dans l'ordre de création des objets.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    6 : _("""
L'attribut %(k1)s n'est pas modifiable ou déjà défini (attribut non nul).
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    7 : _("""
L'attribut %(k1)s est incompatible avec la valeur initiale de la longueur totale.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    8 : _("""
Le premier argument %(k1)s n'est pas du bon type.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    9 : _("""
L'appel est invalide pour l'objet simple "%(k1)s".
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    10 : _("""
Le nom de l'attribut est incompatible avec le genre %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    11 : _("""
La longueur ou la position de la sous chaîne %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    12 : _("""
L'objet %(k1)s n'est pas de genre répertoire de noms, la requête est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    13 : _("""
Le répertoire de noms %(k1)s contient %(i1)d points d'entrée, la requête
sur le numéro %(i2)d est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    14 : _("""
La collection %(k1)s ne possède pas de pointeur de noms, la requête est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    15 : _("""
Nom de classe %(k1)s invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    16 : _("""

 Nom d'objet attribut %(k1)s invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    17 : _("""
Nom d'attribut %(k1)s invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    18 : _("""
L'impression de l'attribut %(k1)s est invalide. L'objet %(k2)s n'est pas une collection.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    19 : _("""
Le segment de valeurs associé à l'attribut %(k1)s n'est pas accessible en mémoire (adresse nulle).
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    20 : _("""
L'accès au répertoire de noms %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    21 : _("""
L'accès à la collection dispersée %(k1)s n'est pas valide en bloc, il faut y accéder avec un nom ou un
 numéro d'objet de collection.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    22 : _("""
L'objet de la collection %(k1)s contiguë est de longueur nulle.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    23 : _("""
Le nom de l'attribut %(k1)s est invalide pour la requête.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    24 : _("""
L'impression du contenu détaillé des objets en mémoire est désactivée.
Il faut définir '%(k1)s' dans '%(k2)s' pour l'activer.
"""),

    27 : _("""
Le paramètre d'accès %(r1)f est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    28 : _("""
La valeur de l'attribut %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    29 : _("""
Cette requête n'est valide que sur une collection contiguë.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    30 : _("""
L'attribut longueur cumulée n'est valide que sur une collection contiguë.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    31 : _("""
La liste de paramètres de création d'objet est incomplète.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    32 : _("""
La liste de paramètres de création d'objet contient des champs superflus.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    33 : _("""
Le répertoire de noms %(k1)s est saturé, il faut le redimensionner.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    34 : _("""
Le nom %(k1)s est introuvable dans le répertoire de noms %(k2)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    35 : _("""
Le nom %(k1)s existe déjà dans le répertoire de noms %(k2)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    36 : _("""
Impossible d'insérer le nom %(k1)s dans le répertoire de noms %(k2)s, il y trop de collisions avec
 la fonction de hashage.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    38 : _("""
Un objet de genre répertoire de noms doit être de type caractère.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    39 : _("""
Il faut définir la longueur du type caractère.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    40 : _("""
La longueur du type caractère vaut %(i1)d, elle doit être comprise entre 1 et 512 .
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    41 : _("""
Pour un objet de genre répertoire de noms, la longueur du type caractère
 vaut %(i1)d, elle n'est pas un multiple de 8.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    42 : _("""
Pour un objet de genre répertoire de noms, la longueur du type caractère
 vaut %(i1)d, elle ne peut être supérieure à 24.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    43 : _("""
Le type de l'objet %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    44 : _("""
Pour une collection nommée, la création d'objet est uniquement autorisée par nom.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    45 : _("""
L'objet de collection %(i1)d existe déjà.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    46 : _("""
Il est impossible de créer l'objet de collection, le répertoire est saturé.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    47 : _("""
L'accès par nom à une collection numérotée est impossible.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    48 : _("""
Une erreur d'écriture de l'attribut %(k1)s au format HDF s'est produite, l'exécution continue.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    49 : _("""
Un écrasement de l'identificateur de l'objet est détecté, sa valeur ne peut pas être nulle.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    50 : _("""
Un écrasement de la classe de l'objet est détecté, sa valeur %(i1)d est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    51 : _("""
Un écrasement de la classe de l'objet est détecté, sa valeur %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    52 : _("""
Il est impossible d'accéder au DATASET HDF associé à %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    54 : _("""
Un écrasement amont est détecté, la zone mémoire (adresse %(i1)d) a été utilisée devant l'adresse autorisée %(i1)d.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    55 : _("""
Un écrasement aval est détecté, la zone mémoire (adresse %(i1)d) a été utilisée
  au-delà de la longueur autorisée.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    56 : _("""
 La structure du nom de l'objet est invalide au-delà des 24 premiers caractères,
  elle vaut %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    57 : _("""
La structure du nom de l'objet est invalide, elle vaut %(k1)s.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    58 : _("""
La structure du nom de l'objet est invalide, le caractère %(k1)s est illicite.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    59 : _("""
L'objet ne possède pas d'image disque (adresse disque nulle).
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    60 : _("""

L'objet de type chaîne de caractères est déjà alloué en mémoire, il n'est pas
possible de le déplacer sans l'avoir auparavant libéré.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    61 : _("""
L'objet n'est pas en mémoire et ne possède pas d'image disque (adresse disque nulle).
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    62 : _("""
La longueur des objets de collection constante n'a pas été définie.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    63 : _("""
L'attribut %(k1)s n'est pas accessible pour cette collection.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    64 : _("""

 Le volume des données temporaires (objets de la base Volatile) écrites sur disque (%(r3).2f Mo)
 est plus de %(r1).2f fois supérieur au volume de données lues (%(r2).2f Mo).

Risques et conseils :
 Ce déséquilibre n'a pas de conséquence sur les résultats de calcul, il indique simplement que
 certaines structures de données temporaires ont été écrites sur disque et détruites sans avoir
 été relues. C'est le cas lorsque vous utilisez le solveur MUMPS, car certaines structures de
 données sont volontairement déchargées pour maximiser la mémoire lors de la résolution.

"""),

    65 : _("""
Le segment de valeurs associé à l'objet %(i1)d de la collection %(k1)s ne possède
 ni adresse mémoire, ni adresse disque.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),


    66 : _("""
Le segment de valeurs associé à l'objet simple %(k1)s ne possède ni adresse mémoire,
 ni adresse disque.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    67 : _("""
La valeur %(i1)d affectée à l'attribut %(k1)s est invalide.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    68 : _("""
L'accès à l'objet simple %(k1)s est invalide.
 Il faut que l'objet simple soit de genre répertoire de noms.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    69 : _("""
Le nom de répertoire associé à la base Globale est trop long %(k1)s,
 il comporte %(i1)d caractères, il ne doit pas dépasser 119.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    70 : _("""
 Le nom de répertoire associé à la base Volatile est trop long %(k1)s,
 il comporte %(i1)d caractères, il ne doit pas dépasser 119.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    71 : _("""
 La mémoire totale de %(r1).2f Mo allouée à l'étude est insuffisante, il est nécessaire
 de disposer d'au moins %(r3).2f Mo uniquement pour démarrer l'exécution.
"""),

    72 : _("""
 Il n'est pas possible de modifier la valeur limite totale de l'allocation dynamique JEVEUX.
 La valeur fournie en argument vaut %(r2).2f.
 Actuellement %(r1).2f Mo sont nécessaires au gestionnaire de mémoire.
"""),

    73 : _("""
  La mémoire consommée actuellement hors JEVEUX est de %(r1).2f Mo.
  La limite de l'allocation dynamique JEVEUX est fixée à %(r2).2f Mo.
  Cette valeur limite a été réactualisée entre les appels aux différentes commandes
"""),

    74 : _("""
  La mémoire consommée actuellement hors JEVEUX est de %(r1).2f Mo.
  La limite de l'allocation dynamique JEVEUX est fixée à %(r2).2f Mo.
  Cette valeur limite a été réactualisée lors de la mise en oeuvre d'un processus de libération
"""),

    75 : _("""
 La plate-forme utilisée ne permet pas d'avoir accès aux valeurs VmPeak/VmSize.
"""),


    77 : _("""
 La mémoire demandée au lancement est sous estimée, elle est de %(r2).2f Mo.
 Le pic mémoire utilisée est de %(r1).2f Mo.

"""),

    78 : _("""
 La mémoire demandée au lancement est surestimée, elle est de %(r2).2f Mo.
 Le pic mémoire utilisée est de %(r1).2f Mo.

"""),

    97 : _("""

Vérification de l'extension automatique des bases JEVEUX:

    Taille de la base          : %(i1)12d octets
    Taille d'un enregistrement : %(i2)12d octets
    Taille d'un enregistrement : %(i3)12d entiers
    Nombre d'enregistrements   : %(i4)12d
    Taille d'un objet alloué   : %(i5)12d entiers
    Nombre maximal d'objets    : %(i6)12d
    Taille allouée             : %(i7)12d octets
    Taille allouée             : %(i8)12d entiers

"""),

    98 : _("""Objet créé '%(k1)s', taille cumulée %(i1)12d"""),

    99 : _("""

Résultat de VERI_BASE : existence de 'vola.2' :

    %(k1)s   test VERI_BASE

"""),
}
