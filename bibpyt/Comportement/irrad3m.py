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

# person_in_charge: jean-luc.flejou at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'IRRAD3M',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement élasto-plastique sous irradiation des aciers inoxydables 304 et 316,
   matériaux dont sont constitués les structures internes de cuve des réacteurs nucléaires (cf. [R5.03.13]).
   Le champ de fluence est défini par le mot-clé AFFE_VARC de la commande AFFE_MATERIAU.
   Le modèle prend en compte la plasticité, le fluage sous irradiation, le gonflement sous flux neutronique."""              ,
    num_lc         = 30,
    nb_vari        = 7,
    nom_vari       = ('EPSPEQ','SEUIL','EPEQIRRA','GONF','INDIPLAS',
        'IRRA','TEMP',),
    mc_mater       = ('ELAS','IRRAD3M',),
    modelisation   = ('3D','AXIS','D_PLAN','C_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON','NEWTON_RELI',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
