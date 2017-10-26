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

# person_in_charge: philippe.de-bonnieres at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'LEMAITRE',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement visco-plastique non linéaire de Lemaitre (sans seuil), cf. [R5.03.08].
   Un cas particulier de cette relation (en annulant le paramètre UN_SUR_M) donne une relation de NORTON.
   La correspondance des variables internes permet le chaînage avec un calcul utilisant un comportement
   élasto-plastique avec écrouissage isotrope (VMIS_ISOT_LINE, VMIS_ISOT_TRAC, VMIS_ISOT_PUIS).
   L'ntégration de ce modèle est réalisée par une méthode semi-DEKKER (PARM_THETA=0.5) ou DEKKER (PARM_THETA=1)"""            ,
    num_lc         = 29,
    nb_vari        = 2,
    nom_vari       = ('EPSPEQ','VIDE',),
    mc_mater       = ('ELAS','LEMAITRE',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP','GDEF_LOG',),
    algo_inte      = ('DEKKER',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
