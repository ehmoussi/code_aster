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

#-------------------------------------------------------
# POST_NEWMARK : calcul de stabilite ouvrage en remblai au seisme
#-------------------------------------------------------

def post_newmark_ops(self,**args):
  """
        Macro commande pour évaluer la stabilité d'un ouvrage en remblai
        (digure / barrage) au séisme par la méthode simplifiée de Newmark.
        Uniquement possible pour une modélisation 2D.
  """

  import aster
  import os,string,types
  from code_aster.Cata.Syntax import _F
  from Utilitai.Utmess import UTMESS, ASSERT
  import numpy as np
  from Macro.macr_lign_coupe_ops import crea_mail_lig_coup
  from Macro.post_endo_fiss_utils import crea_sd_mail

  ier= 0
  # La macro compte pour 1 dans la numerotation des commandes
  self.set_icmd(1)
  self.DeclareOut('tabout',self.sd)

  ### On importe les definitions des commandes a utiliser dans la macro
  DEFI_GROUP     = self.get_cmd('DEFI_GROUP')
  POST_ELEM      = self.get_cmd('POST_ELEM')
  MACR_LIGN_COUPE        = self.get_cmd('MACR_LIGN_COUPE')
  DEFI_FONCTION        = self.get_cmd('DEFI_FONCTION')
  CALC_FONCTION        = self.get_cmd('CALC_FONCTION')
  CALC_CHAMP        = self.get_cmd('CALC_CHAMP')
  CREA_TABLE        = self.get_cmd('CREA_TABLE')
  CALC_TABLE        = self.get_cmd('CALC_TABLE')

 ### RECUPERATION DU RESULTAT
  RESULTAT = args['RESULTAT']

 ### RECUPERATION DES POSITIONS DU CERCLE DE GLISSEMENT
  r = args['RAYON']
  posx = args['CENTRE_X']
  posy = args['CENTRE_Y']

 ### RECUPERATION COEFFICIENT KY
  ky = args['KY']

 ### GROUP_MA DANS LE MODELE
  grpma = args['GROUP_MA_CALC'] 

 ### gravité
  g=9.81

  ## accélération limite
  ay = ky*g

 ### RECUPERATION DU MAILLAGE DANS LE RESULTAT
  iret, ibid, n_modele = aster.dismoi('MODELE', RESULTAT.nom, 'RESULTAT', 'F')
  if n_modele == '#AUCUN' :
    iret, ibid, numddl = aster.dismoi('NUME_DDL', RESULTAT.nom, 'RESU_DYNA', 'F')
    iret, ibid, nom_ma = aster.dismoi('NOM_MAILLA', numddl, 'NUME_DDL', 'F')
  else :
    __model = self.get_concept(n_modele.strip())
    iret, ibid, nom_ma = aster.dismoi('NOM_MAILLA', n_modele.strip(), 'MODELE', 'F')
  __mail = self.get_concept(nom_ma.strip())

  iret, dim, rbid = aster.dismoi('DIM_GEOM', __mail.nom, 'MAILLAGE', 'F')
  if dim == 3:
    UTMESS('F', 'POST0_51')

  iret, ibid, nom_chamat = aster.dismoi('CHAM_MATER', RESULTAT.nom, 'RESULTAT', 'F')
  ## possiblement à gérer par la suite le cas de plusieurs champs matériaux dans
  ## le RESULTAT
  __ch_mat = self.get_concept(nom_chamat.strip())


 ### AJOUT DU GROUPE GLISSE DANS LE MAILLAGE 
  __mail = DEFI_GROUP(reuse = __mail,
                MAILLAGE = __mail,
                CREA_GROUP_MA = _F(NOM = 'GLISSE_',
                                   #TYPE_MAILLE = '2D',
                                   OPTION = 'SPHERE',
                                   POINT = (posx, posy),
                                   RAYON = r),)

  if len(grpma)>1:
    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  CREA_GROUP_MA = _F(NOM = 'ALL',
                                     #TYPE_MAILLE = '2D',
                                     UNION = grpma,),)

    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  CREA_GROUP_MA = _F(NOM = 'GLISSE',
                                     #TYPE_MAILLE = '2D',
                                     INTERSEC = ('GLISSE_','ALL'),),)
  else:
    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  CREA_GROUP_MA = _F(NOM = 'GLISSE',
                                     #TYPE_MAILLE = '2D',
                                     INTERSEC = ('GLISSE_',grpma),),)

  __mail = DEFI_GROUP(reuse = __mail,
              MAILLAGE = __mail,
              CREA_GROUP_NO = _F( GROUP_MA = 'GLISSE')
            )

#  IMPR_RESU(RESU=_F(MAILLAGE=__mail,),FORMAT='MED',UNITE=21)

  __tabmas = POST_ELEM(RESULTAT=RESULTAT,
                      MASS_INER=_F(GROUP_MA='GLISSE'),)

  tabmasse = __tabmas.EXTR_TABLE()

  masse = __tabmas['MASSE',1] 
  cdgx = __tabmas['CDG_X',1]
  cdgy = __tabmas['CDG_Y',1]

##############################################################################
##   METHODE : CALCUL DE L'ACCELERATION MOYENNE A PARTIR DE LA RESULTANTE 
##             LE LONG DE LA SURFACE DE GLISSEMENT
##############################################################################

  __RESU3 = CALC_CHAMP(
           RESULTAT = RESULTAT,
           MODELE = __model,
           CHAM_MATER = __ch_mat,
           FORCE = ('FORC_NODA'),
           );

  __tabFLI = MACR_LIGN_COUPE(RESULTAT = __RESU3,
                      NOM_CHAM = 'FORC_NODA',
                      LIGN_COUPE = _F(TYPE = 'ARC',
                                    OPERATION = 'EXTRACTION',
                                    RESULTANTE   = ('DX','DY'),
                                    NB_POINTS = 1000,
                                    CENTRE = (posx, posy),
                                    COOR_ORIG = (posx-r,posy),
                                    ANGLE = 360.),)

  fresu = __tabFLI.EXTR_TABLE()
  forcex = fresu.values()['DX']
  forcey = fresu.values()['DY']
  time = fresu.values()['INST']

  accyFLI = np.array(forcey)/masse
  accxFLI = np.array(forcex)/masse

  __accyFL = DEFI_FONCTION(NOM_RESU = 'ACCE_MOY',
                NOM_PARA = 'INST',
                ABSCISSE = time,
                ORDONNEE = list(accyFLI)),

  __accxFL = DEFI_FONCTION(NOM_RESU = 'ACCE_MOY',
                NOM_PARA = 'INST',
                ABSCISSE = time,
                ORDONNEE = list(accxFLI)),

###############################################################################
##    METHODE DE CORRECTION DE L'ACCELERATION POUR CALCUL DES DÉPLACEMENTS 
##    IRREVERSIBLES
##############################################################################

  acc = accyFLI

  ## Calcul de l'accéleration corrigée par ay
  ## on compte les valeurs de a>ay de manière à disposer 
  ## du même nombre de valeurs a<ay. Cela servira pour calculer correctement
  ## les vitesses et les déplacements résiduels.
  ## Partie à modifier si kh variable
  accA=np.zeros(len(time))
  count = 0
  for i in xrange(len(time)):
    if acc[i]>ay:
      accA[i] = acc[i] - ay
      count = count + 1
    else:
      if count > 0 :
        accA[i] = acc[i] - ay
        count = count -1
      else:
        count = 0

  # Accélération corigée par ay
  __accAF = DEFI_FONCTION(NOM_RESU = 'ACCE',
                NOM_PARA = 'INST',
                ABSCISSE = time,
                ORDONNEE = list(accA)),

  __vitAFa = CALC_FONCTION(INTEGRE=_F(FONCTION=__accAF,))

  ### Etape de correction de la vitesse à partir de
  ### l'accéleration. Cette étape permet d'aboutir au signal en vitesse
  ### avec uniquement v >0 pour intégration vers les déplacements résiduels
  vitAFv = __vitAFa.Ordo()
  vitA=np.zeros(len(time))
  ind=[False]*len(time)
  eps = 1e-9
  for i in xrange(len(time)-1):
    if (vitAFv[i+1] - vitAFv[i])>eps or (vitAFv[i+1] - vitAFv[i])< (-1.)*eps:
      vitA[i] = vitAFv[i]
      ind[i] = True

  initial = True
  vini = 0.
  for i in xrange(len(time)):
    if ind[i]:
      vitA[i] = vitA[i]-vini
      initial = False
    else :
      initial = True
      vini = vitAFv[i]
      #print vini

  for i in xrange(len(time)):
    if vitA[i]<0:
      vitA[i]=0.

  __vitAF = DEFI_FONCTION(NOM_RESU = 'VITE',
                NOM_PARA = 'INST',
                ABSCISSE = time,
                ORDONNEE = list(vitA)),

  __deplAF = CALC_FONCTION(INTEGRE=_F(FONCTION=__vitAF,))


## CREATION DE LA TABLE DE SORTIE

  tabout = CREA_TABLE(FONCTION=_F(FONCTION=__accyFL),)
  __tabaAF = CREA_TABLE(FONCTION=_F(FONCTION=__accAF),)
  __tabvAF = CREA_TABLE(FONCTION=_F(FONCTION=__vitAF),)
  __tabdAF = CREA_TABLE(FONCTION=_F(FONCTION=__deplAF),)

  act_table = []
  act_table.append(_F(OPERATION='COMB',
                      TABLE=__tabaAF, NOM_PARA='INST'),)
  act_table.append(_F(OPERATION='COMB',
                      TABLE=__tabvAF, NOM_PARA='INST'),)
  act_table.append(_F(OPERATION='COMB',
                      TABLE=__tabdAF, NOM_PARA='INST'),)

  tabout = CALC_TABLE(reuse=tabout , TABLE=tabout ,
                      ACTION=act_table)

  return ier
