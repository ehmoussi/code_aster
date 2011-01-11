#@ MODIF vmis_isot_line Comportement  DATE 10/01/2011   AUTEUR PROIX J-M.PROIX 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
# (AT YOUR OPTION) ANY LATER VERSION.                                                  
#                                                                       
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
#                                                                       
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.        
# ======================================================================
# RESPONSABLE PROIX J.M.PROIX

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'VMIS_ISOT_LINE',
   doc = """Loi de plasticit� de Von Mises � �crouissage lin�aire [R5.03.02]""",
   num_lc         = 1,
   nb_vari        = 2,
   nom_vari       = ('DEFPLCUM', 'INDICAT',),
   mc_mater       = ('ELAS', 'ECRO_LINE'),
   modelisation   = ('3D', 'AXIS', 'C_PLAN', 'D_PLAN', '1D','GRADVARI'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP', 'SIMO_MIEHE','GDEF_LOG','GDEF_HYPO_ELAS','GREEN_REAC'),
   nom_varc       = ('TEMP','SECH','HYDR'),
   algo_inte      = 'ANALYTIQUE',
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


