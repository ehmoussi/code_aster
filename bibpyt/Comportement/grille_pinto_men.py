#@ MODIF grille_pinto_men Comportement  DATE 07/12/2010   AUTEUR GENIAUT S.GENIAUT 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'GRILLE_PINTO_MEN',
   doc = """Relation de comportement des grilles d'armatures de b�ton arm�, � comportement cyclique ph�nom�nologique de Pinto et Menegotto""",
   num_lc         = 9999,
   nb_vari        = 16,
   nom_vari       = ('EPSRN-1','EPSRN','SIGRN','EPSM+V5','DEPS-TH','CYCL','KHI','INDIFLAM','VIDE','VIDE','VIDE','VIDE','VIDE','VIDE','VIDE','VIDE',),
   modelisation   = ('GRILLE_MEMBRANE','GRILLE_EXCENTRE','1D'),
   deformation    = ('PETIT','PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP'),
   algo_inte         = ('ANALYTIQUE'),
   type_matr_tang = None,
   proprietes     = None,
)

