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
 Impossible d'importer le catalogue de la structure de données '%(k1)s'
"""),

    2 : _(u"""
 Objet %(k1)s inexistant.
"""),

    4 : _(u"""
 Arguments incohérents :
      Nom des paramètres : %(k1)s
   Valeur des paramètres : %(k2)s
"""),

    5 : _(u"""
 Arguments invalide
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    30 : _(u"""
 Erreur de programmation (catalogue des SD) :
   Vérification de la structure de donnée %(k1)s
   produite (ou modifiée) par la commande %(k2)s

   Certains objets JEVEUX sont incorrects :
"""),

    31 : _(u"""
      Objet : '%(k1)s'    Message : %(k2)s
"""),

    40 : _(u"""
 Erreur de programmation (catalogue des SD) :
   Vérification d'une structure de donnée :
   Les objets suivants sont interdits dans les SD de type : %(k1)s
"""),

    41 : _(u"""
   Objet '%(k1)s'   INTERDIT
"""),

}
