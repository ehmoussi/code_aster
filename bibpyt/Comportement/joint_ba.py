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

# person_in_charge: sylvie.michel-ponnelle at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'JOINT_BA',
    doc            =   """Relation de comportement locale en 2D décrivant le phénomène de la liaison acier - béton pour les structures en béton armé.
   Elle permet de rendre compte de l'influence de la liaison dans la redistribution des contraintes dans le corps du béton ainsi que la prédiction des fissures et leur espacement.
   Disponible pour des chargements en monotone et en cyclique, elle prend en compte les effets du frottement des fissures, et du confinement.
   Une seule variable d'endommagement scalaire est utilisée (cf. [R7.01.21] pour plus de détails)."""          ,
    num_lc         = 13,
    nb_vari        = 6,
    nom_vari       = ('ENDONOR','ENDOTAN','ECRISOM1','ECRISOM2','GLIS',
        'ECROCINE',),
    mc_mater       = ('ELAS','JOINT_BA',),
    modelisation   = ('AXIS','PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON_1D',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
