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
    1: _(u"""
  !!! mode no : %(i1)d
    linéairement dépendant a déformation statique valeur singulière min :  %(r1)f
    !! nous la forçons a :  %(r2)f
"""),

    2: _(u"""
  pour le mode no : %(i1)d participation :  %(r1)f
"""),

    4: _(u"""
 mot-clef "AMOR_MECA" interdit :
 il est déjà calcule.
"""),

    5: _(u"""
 mot-clef "AMOR_MECA" interdit :
 le résultat :  %(k1)s  existe déjà.
"""),

    7: _(u"""
 -> Le groupe de mailles %(k1)s est vide. On ne le crée donc pas !
 -> Risque & Conseil:
    Veuillez vous assurer que le type de mailles souhaité soit cohérent
    avec votre maillage.
"""),

    8 : _(u"""
  Aucun DDL actif n'a été trouve pour les interfaces données
   => Les modes d'attaches, de contrainte ou de couplage ne peuvent pas être calcules.

  CONSEIL : Vérifiez la cohérence de la définition des interfaces (conditions limites)
            avec la méthode retenue :
             - CRAIGB   : le modèle doit être défini avec des interfaces encastrées,
             - CB_HARMO : le modèle doit être défini avec des interfaces encastrées,
             - MNEAL    : le modèle doit être défini avec des interfaces libres.
"""),


    9 : _(u"""
 Le support indiqué pour la restitution %(k1)s n'est
  pas cohérent avec le support utilisé pour la base modale %(k2)s.
 CONSEIL : Renseigner le bon support de restitution dans le fichier de commande.
"""),

    10 : _(u"""
 Lors de la copie du groupe de mailles %(k1)s appartenant à la sous-structure %(k2)s,
 le nom qui lui sera affecté dans squelette dépasse 8 caractères. La troncature peut
 générer un conflit plus tard avec les noms des autres groupes de mailles.
"""),

    11 : _(u"""
 Vous avez traité plusieurs champs simultanément.
 On ne peut pas utiliser les résultats obtenus pour des calculs de modification structurale.
"""),

    12 : _(u"""
fréquences non identique pour les différentes interfaces.
on retient FREQ = %(r1)f
"""),

}
