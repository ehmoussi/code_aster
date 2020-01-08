# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

def post_newmark_ops(self, **args):
  """
        Macro commande pour évaluer la stabilité d'un ouvrage en remblai
        (digure / barrage) au séisme par la méthode simplifiée de Newmark.
        Uniquement possible pour une modélisation 2D.
  """
  import aster
  import os,string,types
  import copy
  from code_aster.Cata.Syntax import _F
  from Utilitai.Utmess import UTMESS, ASSERT
  import numpy as np

  ### On importe les definitions des commandes a utiliser dans la macro
  from code_aster.Commands import DEFI_GROUP
  from code_aster.Commands import POST_ELEM
  from code_aster.Commands import MACR_LIGN_COUPE
  from code_aster.Commands import DEFI_FONCTION
  from code_aster.Commands import CALC_FONCTION
  from code_aster.Commands import CALC_CHAMP
  from code_aster.Commands import CREA_TABLE
  from code_aster.Commands import CALC_TABLE
  from code_aster.Commands import PROJ_CHAMP
  from code_aster.Commands import POST_RELEVE_T

 ### RECUPERATION DU RESULTAT
  args = _F(args)
  RESULTAT = args['RESULTAT']

 ### RECUPERATION DES POSITIONS DU CERCLE DE GLISSEMENT
  if args['RAYON'] is not None  :
    TYPE = 'CERCLE'
    r = args['RAYON']
    posx = args['CENTRE_X']
    posy = args['CENTRE_Y']
  else :
    TYPE = "MAILLAGE"
    __mail_2 = args['MAILLAGE_GLIS']

 ### RECUPERATION COEFFICIENT KY
  ky = args['KY']

 ### GROUP_MA DANS LE MODELE
  grpma = args['GROUP_MA_CALC']

 ### gravité
  g=9.81

  ## accélération limite
  ay = ky*g

 ### RECUPERATION DU MAILLAGE DANS LE RESULTAT
  __model = None
  try:
    __model = RESULTAT.getModel()
  except:
    raise NameError("No model")
  __mail = __model.getMesh()

  iret, dim, rbid = aster.dismoi('DIM_GEOM', __mail.getName(), 'MAILLAGE', 'F')
  if dim == 3:
    UTMESS('F', 'POST0_51')

  ## possiblement à gérer par la suite le cas de plusieurs champs matériaux dans
  ## le RESULTAT
  __ch_mat = RESULTAT.getMaterialOnMesh()

  __mail = DEFI_GROUP(reuse = __mail,
                MAILLAGE = __mail,
                CREA_GROUP_MA = _F(NOM = 'ALL',
                                   #TYPE_MAILLE = '2D',
                                   UNION = grpma,),)

   ### AJOUT DU GROUPE GLISSE DANS LE MAILLAGE
  if TYPE == 'CERCLE':
    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  CREA_GROUP_MA = _F(NOM = 'GLISSE_',
                                     #TYPE_MAILLE = '2D',
                                     OPTION = 'SPHERE',
                                     POINT = (posx, posy),
                                     RAYON = r),)

  ### Si maillage de la zone de rupture fourni, il faut pouvoir trouver les mailles
  elif TYPE == 'MAILLAGE':
    if args['GROUP_MA_GLIS'] is not None :
      __mail_2 = DEFI_GROUP(reuse = __mail_2,
                  MAILLAGE = __mail_2,
                  CREA_GROUP_MA = _F(NOM = 'RUPTURE',
                                     UNION = args['GROUP_MA_GLIS'],),)
    else :
      __mail_2 = DEFI_GROUP(reuse = __mail_2,
                  MAILLAGE = __mail_2,
                  CREA_GROUP_MA = _F(NOM = 'RUPTURE',
                                     TYPE_MAILLE='2D',
                                     TOUT='OUI',),)

    DEFI_GROUP(reuse=__mail,   MAILLAGE=__mail,
                 CREA_GROUP_NO=  _F(  NOM = 'GLISSE_', OPTION = 'INCLUSION',
                                      MAILLAGE_INCL = __mail_2,
                                      GROUP_MA_INCL = 'RUPTURE',
                                      GROUP_MA      = 'ALL',
                                      CAS_FIGURE    = '2D'))

    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  CREA_GROUP_MA=_F( NOM = 'GLISSE_',OPTION='APPUI',
                                    TYPE_APPUI='AU_MOINS_UN', GROUP_NO='GLISSE_',))

  __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  CREA_GROUP_MA = _F(NOM = 'GLISSE',
                                     #TYPE_MAILLE = '2D',
                                     INTERSEC = ('GLISSE_','ALL'),),)

  __mail = DEFI_GROUP(reuse = __mail,
              MAILLAGE = __mail,
              CREA_GROUP_NO = _F( GROUP_MA = 'GLISSE')
            )

  #IMPR_RESU(RESU=_F(MAILLAGE=__mail,),FORMAT='ASTER',UNITE=6)

  __tabmas = POST_ELEM(RESULTAT=RESULTAT,
                      MASS_INER=_F(GROUP_MA='GLISSE'),)

  masse = __tabmas['MASSE',1]

#  print('masse = ',masse)

##############################################################################
##   METHODE : CALCUL DE L'ACCELERATION MOYENNE A PARTIR DE LA RESULTANTE
##             LE LONG DE LA SURFACE DE GLISSEMENT
##############################################################################

  __RESU3 = CALC_CHAMP(
           RESULTAT = RESULTAT,
           MODELE = __model,
           CHAM_MATER = __ch_mat,
           FORCE = ('FORC_NODA'),
           )

  if TYPE == 'CERCLE':
    __tabFLI = MACR_LIGN_COUPE(RESULTAT = __RESU3,
                        NOM_CHAM = 'FORC_NODA',
                        LIGN_COUPE = _F(TYPE = 'ARC',
                                      OPERATION = 'EXTRACTION',
                                      RESULTANTE   = ('DX','DY'),
                                      NB_POINTS = 1000,
                                      CENTRE = (posx, posy),
                                      COOR_ORIG = (posx-r,posy),
                                      ANGLE = 360.),)

#    IMPR_TABLE(TABLE = __tabFLI,UNITE=10)

  elif TYPE == 'MAILLAGE':
    if args['GROUP_MA_LIGNE'] is not None :

      DEFI_GROUP(reuse=__mail_2,   MAILLAGE=__mail_2,
                   CREA_GROUP_NO=  _F(  NOM = args['GROUP_MA_LIGNE'], OPTION = 'INCLUSION',
                                        MAILLAGE_INCL = __mail,
                                        GROUP_MA_INCL = 'ALL',
                                        GROUP_MA      = args['GROUP_MA_LIGNE'],
                                        CAS_FIGURE    = '2D'))

#      IMPR_RESU(RESU=_F(MAILLAGE=__mail_2,),FORMAT='MED',UNITE=22)

      __recou = PROJ_CHAMP(METHODE='COLLOCATION',
                     RESULTAT=__RESU3,
                     MAILLAGE_1=__mail,
                     MAILLAGE_2=__mail_2,
                     TYPE_CHAM='NOEU',
                     NOM_CHAM='FORC_NODA',
                     PROL_ZERO='OUI',
#                     DISTANCE_MAX=0.1,
                     )

#      IMPR_RESU(RESU=_F(RESULTAT = __recou,),FORMAT='MED',UNITE=24)

      __tabitm = POST_RELEVE_T(ACTION=_F(
                                        INTITULE = 'RESU',
                                        OPERATION = 'EXTRACTION',
                                        GROUP_NO = args['GROUP_MA_LIGNE'],
                                        RESULTANTE   = ('DX','DY'),
                                        RESULTAT = __recou,
                                        NOM_CHAM = 'FORC_NODA',),
                                        )

    else :
      seg=[]
      iret, ibid, yaseg2 = aster.dismoi('EXI_SEG2', __mail_2.getName(), 'MAILLAGE', 'F')
      if yaseg2 == 'OUI':

        seg.append('LIGNE_2')
        __mail_2 = DEFI_GROUP(reuse = __mail_2,
                    MAILLAGE = __mail_2,
                    CREA_GROUP_MA = _F(NOM = 'LIGNE_2',
                                       TYPE_MAILLE=('SEG2'),
                                       TOUT='OUI',),)

      iret, ibid, yaseg3 = aster.dismoi('EXI_SEG3', __mail_2.getName(), 'MAILLAGE', 'F')
      if yaseg3 == 'OUI':
        seg.append('LIGNE_3')
        __mail_2 = DEFI_GROUP(reuse = __mail_2,
                    MAILLAGE = __mail_2,
                    CREA_GROUP_MA = _F(NOM = 'LIGNE_3',
                                       TYPE_MAILLE=('SEG3'),
                                       TOUT='OUI',),)

      DEFI_GROUP(reuse=__mail_2,   MAILLAGE=__mail_2,
                   CREA_GROUP_NO=  _F(  NOM = 'LIGNE_', OPTION = 'INCLUSION',
                                        MAILLAGE_INCL = __mail,
                                        GROUP_MA_INCL = 'ALL',
                                        GROUP_MA      = seg,
                                        CAS_FIGURE    = '2D'))

#      IMPR_RESU(RESU=_F(MAILLAGE=__mail_2,),FORMAT='MED',UNITE=23)

      __recou = PROJ_CHAMP(METHODE='COLLOCATION',
                     RESULTAT=__RESU3,
                     MAILLAGE_1=__mail,
                     MAILLAGE_2=__mail_2,
                     TYPE_CHAM='NOEU',
                     NOM_CHAM='FORC_NODA',
                     PROL_ZERO='OUI',
#                     DISTANCE_MAX=0.1,
                     )

#      IMPR_RESU(RESU=_F(RESULTAT = __recou,),FORMAT='MED',UNITE=25)

      __tabitm = POST_RELEVE_T(ACTION=_F(
                                        INTITULE = 'RESU',
                                        OPERATION = 'EXTRACTION',
                                        GROUP_NO = 'LIGNE_',
                                        RESULTANTE   = ('DX','DY'),
                                        RESULTAT = __recou,
                                        NOM_CHAM = 'FORC_NODA',),
                                        )

    dictab = __tabitm.EXTR_TABLE()
    if 'RESU' in dictab.para:
        del dictab['RESU']
    if 'NOEUD' in dictab.para:
        del dictab['NOEUD']
    dprod = dictab.dict_CREA_TABLE()

    __tabFLI = CREA_TABLE(**dprod)

#    IMPR_TABLE(TABLE = __tabFLI,UNITE=10)



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

# nettoyage des groupes crées dans les maillages

  __mail = DEFI_GROUP(reuse = __mail,
                MAILLAGE = __mail,
                DETR_GROUP_MA = _F(NOM = ('GLISSE_','GLISSE','ALL'),),
                DETR_GROUP_NO = _F(NOM = ('GLISSE'),),
                )

  if TYPE == 'MAILLAGE':
    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  DETR_GROUP_NO = _F(NOM = ('GLISSE_'),),
                  )
    __mail_2 = DEFI_GROUP(reuse = __mail_2,
                  MAILLAGE = __mail_2,
                  DETR_GROUP_MA = _F(NOM = ('RUPTURE',),),)
    if args['GROUP_MA_LIGNE'] is  None :
      __mail_2 = DEFI_GROUP(reuse = __mail_2,
                    MAILLAGE = __mail_2,
                    DETR_GROUP_NO = _F(NOM = ('LIGNE_',),),)
      if yaseg2 == 'OUI':
        __mail_2 = DEFI_GROUP(reuse = __mail_2,
                      MAILLAGE = __mail_2,
                      DETR_GROUP_NO = _F(NOM = ('LIGNE_2',),),)
      if yaseg3 == 'OUI':
        __mail_2 = DEFI_GROUP(reuse = __mail_2,
                      MAILLAGE = __mail_2,
                      DETR_GROUP_NO = _F(NOM = ('LIGNE_3',),),)

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
  for i in range(len(time)):
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
  for i in range(len(time)-1):
    if (vitAFv[i+1] - vitAFv[i])>eps or (vitAFv[i+1] - vitAFv[i])< (-1.)*eps:
      vitA[i] = vitAFv[i]
      ind[i] = True

  vini = 0.
  for i in range(len(time)):
    if ind[i]:
      vitA[i] = vitA[i]-vini
    else :
      vini = vitAFv[i]

  for i in range(len(time)):
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

  return tabout
