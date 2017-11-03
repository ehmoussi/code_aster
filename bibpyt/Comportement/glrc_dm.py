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


from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'GLRC_DM',
    lc_type        = ('MECANIQUE',),
    doc            =   """Ce modèle global permet de représenter l'endommagement d'une plaque en béton armé pour des sollicitations modérées.
   Contrairement aux modélisations locales où chaque constituant du matériau est modélisé à part, dans les modèles globaux,
   la loi de comportement s'écrit directement en terme de contraintes et de déformations généralisées.
   La modélisation jusqu'à la rupture n'est pas recommandée, puisque les phénomènes de plastification ne sont pas
   pris en compte, mais le sont dans GLRC_DAMAGE. En revanche, la modélisation du couplage de l'endommagement entre les effets
   de membrane et de flexion dans GLRC_DM est pris en compte, ce qui n'est pas le cas dans GLRC_DAMAGE.
   Pour les précisions sur la formulation du modèle voir [R7.01.32]"""            ,
    num_lc         = 0,
    nb_vari        = 7,
    nom_vari       = ('ENDOFL+','ENDOFL-','INDIEND1','INDIEND2','ADOUTRAC',
        'ADOUCOMP','ADOUFLEX',),
    mc_mater       = ('GLRC_DM',),
    modelisation   = ('DKTG',),
    deformation    = ('PETIT','GROT_GDEP',),
    algo_inte      = ('NEWTON',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
