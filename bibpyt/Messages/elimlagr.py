# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Mais la version du programme ne dispose pas du solveur PETSC
   qui est nécessaire à cette fonctionnalité.

 Risques & conseils :
   Il faut utiliser la version MPI avec un seul processeur.
"""),

    2 : _(u"""
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Il y a plusieurs processeurs actifs.
 Risques & conseils :
   Il faut utiliser la version MPI avec un seul processeur.
"""),

    3 : _(u"""
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   La matrice n'est pas réelle (mais sans doute complexe).
   C'est interdit pour l'instant.
 Risques & conseils :
   Il faut ne faut pas utiliser SOLVEUR / ELIM_LAGR='OUI'.
"""),

    4 : _(u"""
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Certaines conditions aux limites sont réalisées par AFFE_CHAR_CINE.
   C'est interdit pour l'instant.
 Risques & conseils :
   Il faut remplacer AFFE_CHAR_CINE par AFFE_CHAR_MECA..
"""),

    5 : _(u"""
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Mais la matrice n'est pas symétrique.
   C'est interdit pour l'instant.
 Risques & conseils :
   Il ne faut pas utiliser SOLVEUR / ELIM_LAGR='OUI'.
"""),

    6 : _(u"""
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Mais la matrice est une matrice généralisée.
   C'est interdit.
 Risques & conseils :
   Il ne faut pas utiliser SOLVEUR / ELIM_LAGR='OUI'.
"""),

    7 : _(u"""
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Mais la matrice "réduite" est de taille nulle.
   (tous les ddls sont imposés)
   C'est interdit pour l'instant.
 Risques & conseils :
   Il ne faut pas utiliser SOLVEUR / ELIM_LAGR='OUI'.
"""),

 8 : _(u"""
 Erreur d'utilisation :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Mais une étape du calcul a échoué (calcul du noyau de la matrice des contraintes).
 Risques & conseils :
   Il ne faut pas utiliser SOLVEUR / ELIM_LAGR='OUI'.
"""),


    10 : _(u"""
 Erreur :
   On veut utiliser la fonctionnalité SOLVEUR / ELIM_LAGR='OUI'
   (ou la commande ELIM_LAGR).
   Mais les coefficients des relations linéaires sont tous nuls
   dans la matrice %(k1)s .
 Risques & conseils :
   Par exemple, il ne faut pas utiliser SOLVEUR / ELIM_LAGR='OUI' avec
   une matrice de masse.
"""),

    11 : _(u"""
 Erreur utilisateur :
   On veut utiliser la commande ELIM_LAGR pour éliminer les équations
   de Lagrange dans une matrice qui n'est pas une matrice de rigidité.
   Il faut d'abord utiliser la commande ELIM_LAGR sur la matrice
   de rigidité.

 Risques & conseils :
   La séquence d'appel doit ressembler à :
      K2=ELIM_LAGR(MATR_RIGI=K1, )
      M2=ELIM_LAGR(MATR_RIGI=K1, MATR_ASSE=M1)
"""),

}
