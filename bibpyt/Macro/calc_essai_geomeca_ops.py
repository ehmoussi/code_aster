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

from geomec_utils import *
from geomec_essais import *

def calc_essai_geomeca_ops(self, MATER, COMPORTEMENT, CONVERGENCE, INFO,
                           ESSAI_TRIA_DR_M_D,
                           ESSAI_TRIA_ND_M_D,
                           ESSAI_CISA_DR_C_D,
                           ESSAI_TRIA_ND_C_F,
                           ESSAI_TRIA_ND_C_D,
                           ESSAI_TRIA_DR_C_D,
                           ESSAI_OEDO_DR_C_F,
                           ESSAI_ISOT_DR_C_F,
                           # ESSAI_XXX,
                           **args):
    """
    Objet : Programme principal CALC_ESSAI_GEOMECA
    """

    ier     = 0
    str_num = None

    # La macro compte pour 1 dans la numerotation des commandes
    # -------------------------------------------------------------
    self.set_icmd(1)

    # Verifs supplementaires des valeurs renseignees pr les MCF ESSAI_*
    # -------------------------------------------------------------
    verif_essais(COMPORTEMENT,
                 ESSAI_TRIA_DR_M_D,
                 ESSAI_TRIA_ND_M_D,
                 ESSAI_CISA_DR_C_D,
                 ESSAI_TRIA_ND_C_F,
                 ESSAI_TRIA_ND_C_D,
                 ESSAI_TRIA_DR_C_D,
                 ESSAI_OEDO_DR_C_F,
                 ESSAI_ISOT_DR_C_F,)
                 # ESSAI_XXX,)
                 
    # ---
    # Essai TRIA_DR_M_D
    # ---
    if ESSAI_TRIA_DR_M_D != None:
                 
        nb_essai = len(ESSAI_TRIA_DR_M_D.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_DR_M_D.List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai)
            
            essai_TRIA_DR_M_D(self, str_num, DicoEssai,
                              MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai TRIA_ND_M_D
    # ---
    if ESSAI_TRIA_ND_M_D != None:
                 
        nb_essai = len(ESSAI_TRIA_ND_M_D.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_ND_M_D.List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai)
            
            essai_TRIA_ND_M_D(self, str_num, DicoEssai,
                              MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai CISA_DR_C_D
    # ---
    if ESSAI_CISA_DR_C_D != None:
                 
        nb_essai = len(ESSAI_CISA_DR_C_D.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_CISA_DR_C_D.List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai)
            
            essai_CISA_DR_C_D(self, str_num, DicoEssai,
                              MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai TRIA_ND_C_F
    # ---
    if ESSAI_TRIA_ND_C_F != None:
                 
        nb_essai = len(ESSAI_TRIA_ND_C_F.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_ND_C_F .List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai)
            
            essai_TRIA_ND_C_F (self, str_num, DicoEssai,
                               MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai TRIA_ND_C_D
    # ---
    if ESSAI_TRIA_ND_C_D != None:
                 
        nb_essai = len(ESSAI_TRIA_ND_C_D.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_ND_C_D .List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai)
            
            essai_TRIA_ND_C_D (self, str_num, DicoEssai,
                               MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai TRIA_DR_C_D
    # ---
    if ESSAI_TRIA_DR_C_D != None:
                 
        nb_essai = len(ESSAI_TRIA_DR_C_D.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_DR_C_D.List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai,)
            
            essai_TRIA_DR_C_D(self, str_num, DicoEssai,
                              MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai OEDO_DR_C_F
    # ---
    if ESSAI_OEDO_DR_C_F != None:
                 
        nb_essai = len(ESSAI_OEDO_DR_C_F.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_OEDO_DR_C_F.List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai,)
            
            essai_OEDO_DR_C_F(self, str_num, DicoEssai,
                              MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai ISOT_DR_C_F
    # ---
    if ESSAI_ISOT_DR_C_F != None:
                 
        nb_essai = len(ESSAI_ISOT_DR_C_F.List_F())

        for iocc, DicoEssai in enumerate(ESSAI_ISOT_DR_C_F.List_F()):
        
            if nb_essai>1:
               str_num = int_2_str(iocc+1, nb_essai,)
            
            essai_ISOT_DR_C_F(self, str_num, DicoEssai,
                              MATER, COMPORTEMENT, CONVERGENCE, INFO)
    # ---
    # Essai 'XXX'
    # ---
    # if ESSAI_XXX != None : ...
    return ier
