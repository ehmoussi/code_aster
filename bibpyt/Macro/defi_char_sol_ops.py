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

import os
import copy
from math import log, sqrt, floor, pi, sin
from numpy import sqrt as nsqrt


def defi_char_sol_ops(self, TITRE, INFO, **args):
    """
       Macro DEFI_SOL_EQUI
    """
    import aster
    from code_aster.Cata.Syntax import _F
    from Utilitai.UniteAster import UniteAster
    from Utilitai.Utmess import UTMESS
    from Utilitai.Table import Table
    # from math import log, sqrt, floor, pi, sin
    from numpy import sqrt as nqsrt
    import numpy as np
    #from SD.sd_maillage      import sd_maillage
    #from code_aster.Cata.DataStructure import maillage_sdaster

  #--------------------------------------------------------------------------------
  # On importe les definitions des commandes a utiliser dans la macro
  #
    DEFI_FONCTION = self.get_cmd('DEFI_FONCTION')
    CALC_FONCTION = self.get_cmd('CALC_FONCTION')
    IMPR_FONCTION = self.get_cmd('IMPR_FONCTION')
    CALC_TABLE = self.get_cmd('CALC_TABLE')
    CREA_RESU = self.get_cmd('CREA_RESU')
    LIRE_FONCTION = self.get_cmd('LIRE_FONCTION')
    AFFE_CHAR_MECA = self.get_cmd('AFFE_CHAR_MECA')
    AFFE_CHAR_MECA_F = self.get_cmd('AFFE_CHAR_MECA_F')
    DEFI_GROUP = self.get_cmd('DEFI_GROUP')
    LIRE_MAILLAGE=self.get_cmd('LIRE_MAILLAGE')
    CREA_MAILLAGE = self.get_cmd('CREA_MAILLAGE')
    MODI_MAILLAGE = self.get_cmd('MODI_MAILLAGE')
    DETRUIRE = self.get_cmd('DETRUIRE')
    DEFI_NAPPE = self.get_cmd('DEFI_NAPPE')
    ier = 0
    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)
    self.DeclareOut("charout", self.sd)

    # Le concept sortant (de type char_meca)

    modele = args['MODELE']

    lforcn = 'NON'
    ltranin = 'NON'
    llcara = 'NON'
    lresu = 'NON'

    # type de modelisation : 2D ou 3D
    dime = "2D"
    nompar = 'Y'
    if args['CHARGEMENT'] != 'ONDE_PLANE':
       lforcn = 'OUI'

    if args['UNITE_TRAN_INIT'] != None :
      ltranin = 'OUI'
      if "AXE" in args:
        if args['AXE']!=None  :
          dime = "3D"
          if args['NOM_CMP'] == 'DX':
            if lforcn != 'OUI' :
              nompar = 'Z'
              if args['AXE']=='X'  :
                typs = 'SV'
                if args['NOM_PARA']=='Y'  :
                  typs = 'SH'
                  nompar='Y'
              if args['AXE']=='Y'  :
                typs = 'SH'
              if args['AXE']=='Z'  :
                typs = 'SV'
                nompar='Y'
            else:
              nompar=args['AXE']
        
          if args['NOM_CMP'] == 'DY':
            if lforcn != 'OUI' :
              nompar=args['AXE']
            else:
              nompar = 'Z'
              if args['AXE']=='Z'  :
                nompar = 'Y'
              if args['AXE']=='X'  :
                if args['NOM_PARA']=='Y'  :
                  nompar='Y'
          dire = (0., 0., 1.)
          if nompar == 'Y' :   
            dire = (0., 1., 0.)  
          if nompar == 'X' :   
            dire = (1., 0., 0.)       

      print 'dime=',dime
      # Possibilite d utiliser une longueur caracteristique :
      # llcara ='OUI' ou 'NON'
      if args['LONG_CARA'] != None :
        llcara = 'OUI'
    if args['RESU_INIT'] != None :
      lresu = 'OUI'

# Groupes de mailles et maillage
    iret,ibid,nom_mail = aster.dismoi('NOM_MAILLA',modele.nom,'MODELE','F')
    mail0 = self.get_concept(nom_mail)
    
    #if dime == "3D":
    #    grma_tot = args['GROUP_MA_LIGNE']

#

    if ltranin == 'OUI' :
      utranin = args['UNITE_TRAN_INIT']

      if args['TABLE_MATER_ELAS'] != None:
        __TMAT = CALC_TABLE( TABLE=args['TABLE_MATER_ELAS'],
         ACTION=_F(OPERATION='EXTR',NOM_PARA=('Y','M','RHO','Emax','NU','AH','GDgam')));
        tmat = __TMAT.EXTR_TABLE()
        NCOU = len(tmat) - 1
        text = ('NCOU=' + str(NCOU) )
        aster.affiche('MESSAGE', text)

      grma_droit = args['GROUP_MA_DROITE']
      grma_gauch = args['GROUP_MA_GAUCHE']
      z0 = args['Z0']

      NPC = NCOU+3
      if args['NOM_CMP'] == 'DX':
        coef = 0.5
      else:
        coef = 1.0
      coef2 = -1.0*coef

      if lforcn == 'OUI':
        l_para = []
        l_foncy1 = []
        l_foncy2 = []

        for k in range(1, NPC):
          if k < NPC-1 :
            __faccex0=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[6,1],INDIC_RESU=[6,NPC+1-k],
                   );
            l_para.append(z0-1.0*__TMAT['Y',NPC-1-k])
                   
          else:
            __faccex0=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[6,1],INDIC_RESU=[6,2],
                   );
            l_para.append(z0)
               
          __ffy1=CALC_FONCTION(COMB=(
                       _F(FONCTION=__faccex0,COEF=coef,),
                             ),
                       );
          __ffy2=CALC_FONCTION(COMB=(
                       _F(FONCTION=__faccex0,COEF=coef2,),
                             ),
                       );
          DETRUIRE(CONCEPT=_F(NOM=(__faccex0,),), INFO = 1);

          l_foncy1.append(__ffy1)
          l_foncy2.append(__ffy2)
  
        __NSEISM1 = DEFI_NAPPE(NOM_PARA=nompar,
          PARA= tuple(l_para),    
          FONCTION=tuple(l_foncy1), 
          );

        __NSEISM2 = DEFI_NAPPE(NOM_PARA=nompar,
          PARA= tuple(l_para),    
          FONCTION=tuple(l_foncy2), 
          );

      else:
        l_para = []
        l_foncx = []
        l_vitex = []
        l_deplx = []

        l_group = []
        if grma_gauch != None:
          l_group.append(grma_gauch)
        if grma_droit != None:
          l_group.append(grma_droit)

        for k in range(1, NPC):
          if k < NPC-1 :
             __fvitex=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[2,1],INDIC_RESU=[2,NPC+2-k],
                   );
             if llcara == 'OUI' :
               __fdeplx=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
                 INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
                 INDIC_PARA=[3,1],INDIC_RESU=[3,NPC+2-k],
                   );
             l_para.append(z0-1.0*__TMAT['Y',NPC-1-k])
          else:
             __fvitex=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
               INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
               INDIC_PARA=[2,1],INDIC_RESU=[2,2],
                   );
             if llcara == 'OUI' :
               __fdeplx=LIRE_FONCTION(UNITE=utranin,NOM_PARA='INST',
                 INTERPOL = 'LIN',PROL_DROITE = 'CONSTANT',
                 INDIC_PARA=[3,1],INDIC_RESU=[3,2],
                   );
             l_para.append(z0)           
          l_vitex.append(__fvitex)
          if llcara == 'OUI' :
            l_deplx.append(__fdeplx)

        __FONCVX = DEFI_NAPPE(NOM_PARA='X', INTERPOL=('LIN','LIN',),                     
                               PROL_GAUCHE='CONSTANT', PROL_DROITE='CONSTANT',
                               PARA= tuple(l_para), FONCTION=tuple(l_vitex),);
        if llcara == 'OUI' :
          __FONCDX = DEFI_NAPPE(NOM_PARA='X', INTERPOL=('LIN','LIN',),                     
                               PROL_GAUCHE='CONSTANT', PROL_DROITE='CONSTANT',
                               PARA= tuple(l_para), FONCTION=tuple(l_deplx),);

      #if ltranin == 'OUI' :
      if dime == "2D": 
            if args['NOM_CMP'] == 'DX':
                  if lforcn == 'OUI' :
                    Force_Nodale = []
                    if grma_gauch != None:
                      Force_Nodale.append(_F(GROUP_NO=grma_gauch,FY=__NSEISM1,),)
                    if grma_droit != None:
                      Force_Nodale.append(_F(GROUP_NO=grma_droit,FY=__NSEISM2,),)
                    charout=AFFE_CHAR_MECA_F(MODELE=modele,
                      FORCE_NODALE=Force_Nodale,
                      );
                  else:
                    if llcara == 'OUI' :
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,), 
                        TYPE_ONDE = 'S',
                        DEPL_IMPO=__FONCDX,
                        FONC_SIGNAL = __FONCVX, GROUP_MA=tuple(l_group),) #(grma_gauch,grma_droit))
                          );
                    else:
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,), 
                        TYPE_ONDE = 'S',
                        FONC_SIGNAL = __FONCVX, GROUP_MA=tuple(l_group),) #(grma_gauch,grma_droit))
                          );

            else:
                  if lforcn == 'OUI' :
                    Force_Nodale = []
                    if grma_gauch != None:
                      Force_Nodale.append(_F(GROUP_NO=grma_gauch,FX=__NSEISM1,),)
                    if grma_droit != None:
                      Force_Nodale.append(_F(GROUP_NO=grma_droit,FX=__NSEISM2,),)
                    charout=AFFE_CHAR_MECA_F(MODELE=modele,
                      FORCE_NODALE=Force_Nodale,
                      );
                  else:
                    if llcara == 'OUI' :
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,), 
                        TYPE_ONDE = 'P',
                        DEPL_IMPO=__FONCDX,
                        FONC_SIGNAL = __FONCVX, GROUP_MA=(grma_gauch,grma_droit))
                          );
                    else:
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = (0., 1., 0.,), 
                        TYPE_ONDE = 'P',
                        FONC_SIGNAL = __FONCVX, GROUP_MA=(grma_gauch,grma_droit))
                          );
      if dime == "3D": 
            if args['NOM_CMP'] == 'DX':
                  if lforcn == 'OUI' :
                    Force_Nodale = []
                    if nompar=='Z' :
                      if grma_gauch != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_gauch,FZ=__NSEISM1,),)
                      if grma_droit != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_droit,FZ=__NSEISM2,),)
                    if nompar=='X' :
                      if grma_gauch != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_gauch,FX=__NSEISM1,),)
                      if grma_droit != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_droit,FX=__NSEISM2,),)
                    if nompar=='Y' :
                      if grma_gauch != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_gauch,FY=__NSEISM1,),)
                      if grma_droit != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_droit,FY=__NSEISM2,),)
                    charout=AFFE_CHAR_MECA_F(MODELE=modele,
                      FORCE_ARETE=Force_Nodale,
                      );
                  else:
                    if llcara == 'OUI' :
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = dire, #(0., 0., 1.,), 
                        TYPE_ONDE = typs, #'S',
                        DEPL_IMPO=__FONCDX,
                        FONC_SIGNAL = __FONCVX, GROUP_MA=tuple(l_group),) #(grma_gauch,grma_droit))
                          );
                    else:
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = dire, #(0., 0., 1.,),  
                        TYPE_ONDE = typs, #'S',
                        FONC_SIGNAL = __FONCVX, GROUP_MA=tuple(l_group),) #(grma_gauch,grma_droit))
                          );

            else:
                  if lforcn == 'OUI' :
                    if args['AXE']=='X'  :
                      Force_Nodale = []
                      if grma_gauch != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_gauch,FX=__NSEISM1,),)
                      if grma_droit != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_droit,FX=__NSEISM2,),)
                      charout=AFFE_CHAR_MECA_F(MODELE=modele,
                        FORCE_ARETE=Force_Nodale,
                        );   
                    if args['AXE']=='Y'  :
                      Force_Nodale = []
                      if grma_gauch != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_gauch,FY=__NSEISM1,),)
                      if grma_droit != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_droit,FY=__NSEISM2,),)
                      charout=AFFE_CHAR_MECA_F(MODELE=modele,
                        FORCE_ARETE=Force_Nodale,
                        );
                    if args['AXE']=='Z'  :
                      Force_Nodale = []
                      if grma_gauch != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_gauch,FZ=__NSEISM1,),)
                      if grma_droit != None:
                        Force_Nodale.append(_F(GROUP_MA=grma_droit,FZ=__NSEISM2,),)
                      charout=AFFE_CHAR_MECA_F(MODELE=modele,
                        FORCE_ARETE=Force_Nodale,
                        );
                  else:
                    if llcara == 'OUI' :
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = dire, #(0., 0., 1.,),  
                        TYPE_ONDE = 'P',
                        DEPL_IMPO=__FONCDX,
                        FONC_SIGNAL = __FONCVX, GROUP_MA=tuple(l_group),) #(grma_gauch,grma_droit))
                          );
                    else:
                      charout=AFFE_CHAR_MECA_F(  MODELE=modele,
                        ONDE_PLANE=_F( DIRECTION = dire, #(0., 0., 1.,), 
                        TYPE_ONDE = 'P',
                        FONC_SIGNAL = __FONCVX, GROUP_MA=tuple(l_group),) #(grma_gauch,grma_droit))
                          );
    else:
        if lforcn == 'OUI' :
            __resuon=CREA_RESU(OPERATION='CONV_RESU',
                  TYPE_RESU='EVOL_CHAR', #'DYNA_TRANS',
                  CONV_RESU=_F(NUME_DDL=args['NUME_DDL'],
                          NOM_CHAM_INIT='FORC_NODA',
                          COEF=args['COEF'], #-1.0 par défaut
                          #MATR_AMOR=args['MATR_AMOR'],
                          PRECISION=args['PRECISION'], #1.E-6 par défaut
                          CRITERE=args['CRITERE'], #'RELATIF' par défaut
                          LIST_INST=args['LIST_INST'],
                          RESU_INIT=args['RESU_INIT'],),
                );

        else:
          if args['MATR_RIGI'] != None: 
            __resuon=CREA_RESU(OPERATION='KUCV',
                  TYPE_RESU='EVOL_CHAR', #'DYNA_TRANS',
                  KUCV=_F(MATR_RIGI=args['MATR_RIGI'],
                          MATR_AMOR=args['MATR_AMOR'],
                          PRECISION=args['PRECISION'], #1.E-6 par défaut
                          CRITERE=args['CRITERE'], #'RELATIF' par défaut
                          LIST_INST=args['LIST_INST'],
                          RESU_INIT=args['RESU_INIT'],),
                );
          else: 
            __resuon=CREA_RESU(OPERATION='KUCV',
                  TYPE_RESU='EVOL_CHAR', #'DYNA_TRANS',
                  KUCV=_F(
                          MATR_AMOR=args['MATR_AMOR'],
                          PRECISION=args['PRECISION'], #1.E-6 par défaut
                          CRITERE=args['CRITERE'], #'RELATIF' par défaut
                          LIST_INST=args['LIST_INST'],
                          RESU_INIT=args['RESU_INIT'],),
                );

        charout=AFFE_CHAR_MECA(MODELE=modele, EVOL_CHAR=__resuon,);
    return ier
