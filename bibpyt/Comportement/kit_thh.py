#@ MODIF kit_thh Comportement  DATE 07/12/2010   AUTEUR GENIAUT S.GENIAUT 
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
# RESPONSABLE GRANET S.GRANET

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'KIT_THH',
   doc = """KIT associ� au comportement des milieux poreux (mod�lisations thermo-hydro-m�canique).
   Pour plus de d�tails sur les mod�lisations thermo-hydro-m�caniques et les mod�les de comportement, 
   on pourra consulter les documents [R7.01.10] et [R7.01.11], ainsi que la notice d'utilisation [U2.04.05].
   Les relations KIT_XXXX permettent de r�soudre simultan�ment de deux � quatre �quations d'�quilibre. 
   Les �quations consid�r�es d�pendent du suffixe XXXX avec la r�gle suivante :
   - M d�signe l'�quation d'�quilibre m�canique,
   - T d�signe l'�quation d'�quilibre thermique,
   - H d�signe une �quation d'�quilibre hydraulique.
   - V d�signe la pr�sence d'une phase sous forme vapeur (en plus du liquide)
   Les probl�mes thermo-hydro-m�caniques associ�s sont trait�s de facon totalement coupl�e.
   Une seule lettre H signifie que le milieu poreux est satur� (une seule variable de pression p), 
   par exemple soit de gaz, soit de liquide, soit d'un m�lange liquide/gaz (dont la pression du gaz est constante).
   Deux lettres H signifient que le milieu poreux est non satur� (deux variables de pression p), par exemple 
   un m�lange liquide/vapeur/gaz. La pr�sence des deux lettres HV signifie que le milieu poreux est satur� par 
   un composant (en pratique de l'eau), mais que ce composant peut �tre sous forme liquide ou vapeur. 
   Il n'y a alors qu'une �quation de conservation de ce composant, donc un seul degr� de libert� pression, 
   mais il y a un flux liquide et un flux vapeur.
   """,
   num_lc         = 9999,
   nb_vari        = 0,
   nom_vari       = None, # depend des modeles de comportement 
   mc_mater       = None,
   modelisation   = ('D_PLAN_THH','D_PLAN_THHD','D_PLAN_THHS','AXIS_THH','AXIS_THHD','AXIS_THHS','3D_THH','3D_THHD','3D_THHS','D_PLAN_THH2D','AXIS_THH2D','3D_THH2D','D_PLAN_THH2S','AXIS_THH2S','3D_THH2S'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = None,
   algo_inte         = ('SANS_OBJET'),
   type_matr_tang = None,
   proprietes     = None,
)

