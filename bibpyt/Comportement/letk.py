# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: alexandre.foucault at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'LETK',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement pour la modélisation élasto visco plastique des roches suivant le modèle de Laigle et Kleine, cf. [R7.01.24].
   L'opérateur relatif à la prédiction élastique est celui de l'élasticité non linéaire spécifique à la loi."""              ,
    num_lc         = 35,
    nb_vari        = 9,
    nom_vari       = ('XIP','GAMMAP','XIVP','GAMMAVP','INDICDIL',
        'INDIVISC','INDIPLAS','DOMAINE','INDIC',),
    mc_mater       = ('ELAS','LETK',),
    modelisation   = ('3D','AXIS','D_PLAN','THM',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON','NEWTON_PERT','SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
