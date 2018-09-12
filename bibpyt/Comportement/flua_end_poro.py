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

# person_in_charge: etienne.grimal at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'FLUA_ENDO_PORO',
    lc_type        = ('MECANIQUE',),
    doc            =   """lois de fluage et d'endommagement couplées pour le béton"""            ,
    num_lc         = 167,
    nb_vari        = 108,
    nom_vari=(
 #         deformations elastiques
           'EPE1',
           'EPE2',
           'EPE3',
           'EPE4',
           'EPE5',
           'EPE6',
 #         deformation de l etage de Kelvin          
           'EPK1',
           'EPK2',
           'EPK3',
           'EPK4',
           'EPK5',
           'EPK6',
 #         deformations de l etage de Maxwell          
           'EPM1',
           'EPM2',
           'EPM3',
           'EPM4',
           'EPM5',
           'EPM6',
 #         contraintes effective squelette solide (sans pression rgi)          
           'SIG1',
           'SIG2',
           'SIG3',
           'SIG4',
           'SIG5',
           'SIG6',         
 #         dissipation etage de Mawell          
           'PHIM',
 #         energie elastique          
           'WELA',
 #         endomagement par fluage
           'DFLU',
 #         variation de volume meca total
           'TEPS',
 #         variation de volume par fissuration rgi          
           'TEPG',
 #         deformation plastique de traction         
           'EPT1',
           'EPT2',
           'EPT3',
           'EPT4',
           'EPT5',
           'EPT6',
 #         deformation plastique fissuration rgi
           'EPG1', 
           'EPG2', 
           'EPG3',
           'EPG4', 
           'EPG5', 
           'EPG6', 
 #         deformations plastiques de druker prager       
           'EPC1', 
           'EPC2',
           'EPC3',  
           'EPC4', 
           'EPC5', 
           'EPC6',  
 #         hydratation fin de pas
           'HYDF',
 #         endommagement thermique isotrope
           'DTHE',  
 #         contraintes elastiques de l etage de Kelvin
           'SKE1',
           'SKE2',
           'SKE3',
           'SKE4',
           'SKE5',
           'SKE6',
 #         pression capillaire de l eau
           'PSHR',      
 #         perte de viscosité par séchage (coeff de consolidation par séchage)
           'CSHR',
 #         volume d eau capillaire (necessaire sous iteration fluage3d)
           'WSHR',
 #         vide pour l eau  capillaire (necessaire sous iteration fluage3d)
           'VSHR', 
 #         potentiel des phases neoformees
           'PHIG',
 #         pression de RGI
           'PRGI', 
 #         avancement AAR
           'AAAR', 
 #         avancement DEF
           'ADEF',
 #         indicateur premier pas (1 si premier pas passé sinon 0)
           'PPAS',
 #         coeff de Biot effectif pour les RGI
           'BIOG',
 #         coeff de Biot effectif pour la capillarite
           'BIOW',
 #         deformation plastique equivalente en cisaillement
           'EPLC',
 #         deformation plastique maximale atteinte en traction
           'EMT1',
           'EMT2',
           'EMT3',
           'EMT4',
           'EMT5',
           'EMT6',  
 #         Cumul des surpessions capillaires en dessiccation sous charge
           'DSW1',
           'DSW2',
           'DSW3',
           'DSW4',
           'DSW5',
           'DSW6',
 #         endommagements principaux de traction directe 
           'DTL1',
           'DTL2',
           'DTL3',        
 #         endommagements principaux de refermeture 
           'DRL1',
           'DRL2',
           'DRL3',
 #         endommagements principaux de traction diffus RGI
           'DTG1',
           'DTG2',
           'DTG3',
 #         endommagements principaux de compression difffus RGI
           'DCG1',
           'DCG2',
           'DCG3',
 #         partie plastique de l ouverture de fissure localisee
           'WL1',
           'WL2',
           'WL3', 
 #         endommagement de compression
           'DC',  
 #         endommagement de traction diffus pre pic
           'DTPP',
 #         sulfo aluminates pour la def 
           'AFT1',
           'AFM1',
           'AFT2',
           'AFM2',
           'ATIL',
           'STIL',
 #       tenseur des ouvertures plastiques de fissures en base globale
           'WID1',
           'WID2',
           'WID3',
           'WID4',
           'WID5',
           'WID6',
),
    mc_mater = ('ELAS', 'ENDO3D'),
    modelisation   = ('3D','D_PLAN','AXIS'),
    deformation    = ('PETIT','PETIT_REAC',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = ('ELTSIZE2',),
    deform_ldc     = ('OLD',),
)
