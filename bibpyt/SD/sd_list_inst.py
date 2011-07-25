#@ MODIF sd_list_inst SD  DATE 12/07/2011   AUTEUR ABBAS M.ABBAS 
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

from SD import *

class sd_list_inst(AsBase):
    nomj = SDNom(fin=8)

# 1) objets relatifs a la liste

    LIST_INFOR = AsVR(SDNom(nomj='.LIST.INFOR'),lonmax=10,)
    LIST_DITR  = AsVR(SDNom(nomj='.LIST.DITR'))

    ECHE_EVENR = AsVR(SDNom(nomj='.ECHE.EVENR'))
    ECHE_EVENK = AsVK16(SDNom(nomj='.ECHE.EVENK'))
    ECHE_SUBDR = AsVR(SDNom(nomj='.ECHE.SUBDR'))

    ADAP_EVENR = Facultatif(AsVR(SDNom(nomj='.ADAP.EVENR')))
    ADAP_EVENK = Facultatif(AsVK8(SDNom(nomj='.ADAP.EVENK')))
    ADAP_TPLUR = Facultatif(AsVR(SDNom(nomj='.ADAP.TPLUR')))
    ADAP_TPLUK =Facultatif( AsVK16(SDNom(nomj='.ADAP.TPLUK')))
