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
    nom            = 'DHRC',
    lc_type        = ('MECANIQUE',),
    doc            =   """Ce modèle homogénéisé permet de représenter l'endommagement et le glissement interne périodique d'une plaque en béton armé pour des sollicitations modérées.
   La loi de comportement s'écrit directement en terme de contraintes et de déformations généralisées.
   La modélisation jusqu'à la rupture n'est pas recommandée, puisque les phénomènes de plastification des aciers et de propagation de fissures ne sont pas
   pris en compte. L'identification des paramètres nécessaires à cette loi de comportement se fait via une procédure préalable d'homogénéisation.
   Pour les précisions sur la formulation du modèle voir [R7.01.36]"""            ,
    num_lc         = 0,
    nb_vari        = 11,
    nom_vari       = ('ENDOSUP','ENDOINF','GLISXSUP','GLISYSUP','GLISXINF',
        'GLISYINF','DISSENDO','DISSGLIS','DISSIP','ADOUMEMB',
        'ADOUFLEX',),
    mc_mater       = ('DHRC',),
    modelisation   = ('DKTG',),
    deformation    = ('PETIT','GROT_GDEP',),
    algo_inte      = ('NEWTON',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
