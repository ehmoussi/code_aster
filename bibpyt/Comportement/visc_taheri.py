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

# person_in_charge: said.taheri at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'VISC_TAHERI',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement (visco)-plastique de S.Taheri modélisant la réponse de matériaux sous chargement plastique cyclique,
   et en particulier permettant de représenter les effets de rochet.
   Les données nécessaires sont fournies dans l'opérateur DEFI_MATERIAU [U4.43.01],
   sous les mots clés TAHERI(_FO) pour la description de l'écrouissage, LEMAITRE(_FO) pour la viscosité
   et ELAS(_FO) (Cf. [R5.03.05] pour plus de détails).
   En l'absence de LEMAITRE, la loi est purement élasto-plastique."""              ,
    num_lc         = 18,
    nb_vari        = 9,
    nom_vari       = ('EPSPEQ','SIGMAPIC','EPSPXX','EPSPYY','EPSPZZ',
        'EPSPXY','EPSPXZ','EPSPYZ','INDIPLAS',),
    mc_mater       = ('ELAS','TAHERI','LEMAITRE',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('SECANTE','BRENT',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
