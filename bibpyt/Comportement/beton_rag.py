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


from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'BETON_RAG',
    doc            =   """Loi RAG pour le beton""",
    num_lc         = 145,
    nb_vari        = 33,
    nom_vari       = (
        # 01:07 : Contraintes seuils d'endommagement : Tenseur traction + compression
        'BR_SUT11','BR_SUT22','BR_SUT33','BR_SUT12','BR_SUT13','BR_SUT23','BR_SIGDP',
        # 08:14 : Déformations de fluage : Tenseur déviatorique + partie sphérique
        'BR_EFU11','BR_EFU22','BR_EFU33','BR_EFU12','BR_EFU13','BR_EFU23','BR_EFUSP',
        # 15:21 : Déformations de fluage interne : Tenseur déviatorique + partie sphérique
        'BR_EP111','BR_EP122','BR_EP133','BR_EP112','BR_EP113','BR_EP123','BR_EP1SP',
        # 22 : Avancement chimique
        'BR_AVCHI',
        # 23:25 : Endommagement viscoplastique de la RAG
        'BR_DVRAG1','BR_DVRAG2','BR_DVRAG3',
        # 26:31  : Déformations viscoplastique due à la RAG
        'BR_EPV11','BR_EPV22','BR_EPV33','BR_EPV12','BR_EPV13','BR_EPV23',
        # 32 : Pression du gel
        'BR_PRGEL',
        # 33 : Étude réalisée
        'BR_ETUDE',
    ),
    mc_mater       = ('ELAS','BETON_RAG',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
