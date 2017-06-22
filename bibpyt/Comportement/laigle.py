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

# person_in_charge: samuel.geniaut at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'LAIGLE',
    doc            =   """Relation de comportement pour la modélisation des roches suivant le modèle de Laigle, cf. le document [R7.01.15].
   Pour faciliter l'intégration de ce modèle, on peut utiliser le redécoupage automatique local du pas de temps (ITER_INTE_PAS)."""      ,
    num_lc         = 33,
    nb_vari        = 4,
    nom_vari       = ('EPSPEQ','EPSPVOL','DOMCOMP','INDIPLAS',),
    mc_mater       = ('ELAS','LAIGLE',),
    modelisation   = ('3D','AXIS','D_PLAN','THM',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
)
