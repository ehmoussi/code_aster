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
    1 : _(u"""'%(k1)s' doit être une liste de 2 ou 3 listes de réels de même longueur.
"""),

    2 : _(u"""'%(k1)s' doit être une liste de 2 ou 3 chaînes de caractères.
"""),

    3 : _(u"""Le format est inconnu : %(k1)s.
"""),

    4 : _(u"""On limite la fenêtre aux abscisses positives.
"""),

    5 : _(u"""On limite la fenêtre aux ordonnées positives.
"""),

    6 : _(u"""Des erreurs se sont produites :
   %(k1)s
"""),

    7 : _(u"""La variable DISPLAY n'est pas définie.
"""),

    8 : _(u"""On fixe la variable DISPLAY à %(k1)s.
"""),

    9 : _(u"""Erreur lors de l'utilisation du filtre '%(k1)s'.
Le fichier retourné est le fichier au format texte de xmgrace.
"""),

    10 : _(u"""
   <I> Informations sur le fichier '%(k1)s' :
      Nombre de courbes    : %(i1)3d
      Bornes des abscisses : [ %(r1)13.6G , %(r2)13.6G ]
      Bornes des ordonnées : [ %(r3)13.6G , %(r4)13.6G ]
"""),

    11 : _(u"""
   Le fichier '%(k1)s' ne semble pas être au format texte de xmgrace.
   On ne peut donc pas recalculer les valeurs extrêmes.
   Le pilote ne permet probablement pas d'imprimer plusieurs
   graphiques dans le même fichier.

Conseil :
   N'utilisez pas le mot-clé PILOTE et produisez l'image en
   utilisant xmgrace.
"""),

}
