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
  Degré de liberté physique associé au noeud %(k1)s et à la composante %(k2)s.
"""),

    2: _(u"""
  Degré de liberté de Lagrange associé au blocage du noeud %(k1)s et de la composante %(k2)s.
"""),

    3: _(u"""
  Degré de liberté de Lagrange associé à une relation linéaire entre plusieurs degrés de liberté.
  La relation linéaire a été définie par la commande ayant produit le concept de nom %(k1)s.
  La liste des noeuds impliqués dans cette relation linéaire est la suivante:
"""),

    4: _(u"""    Noeud %(k1)s"""),

    5: _(u"""
  Degré de liberté d'un système généralisé pour le macro-élément %(k1)s et l'équation %(i1)d.
"""),

    6: _(u"""
  Degré de liberté d'un système généralisé pour la liaison %(i1)d et l'équation %(i2)d.
"""),
}
