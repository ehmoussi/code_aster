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

#import sys
import numpy as np

import aster
from ..Cata.Syntax import _F
from ..Objects.table_py import Table
from ..Commands import (CALC_CHAMP, CALC_FONCTION, CALC_TABLE,
                                 CREA_TABLE, DEFI_FONCTION, DEFI_GROUP,
                                 MACR_LIGN_COUPE, POST_ELEM, POST_RELEVE_T,
                                 PROJ_CHAMP,MODI_MAILLAGE,CREA_CHAMP,
                                 CREA_RESU,PROJ_CHAMP,IMPR_RESU,IMPR_TABLE,
                                 AFFE_MODELE,DEFI_MATERIAU,AFFE_MATERIAU,
                                 CALC_MATR_ELEM,NUME_DDL,ASSE_MATRICE,DETRUIRE,
                                 FORMULE,CREA_MAILLAGE,DEFI_FICHIER)
from ..Messages import ASSERT, UTMESS, MasquerAlarme, RetablirAlarme
from ..Helpers import LogicalUnitFile

def get_static_shear(sign_static,sigt_static,phi,cohesion):
    tanphi = np.tan(np.pi*np.array(phi)/180.)

    available_shear = np.sum(np.array(sign_static)*tanphi - np.array(cohesion))
    static_shear = np.sum(np.array(sigt_static))

    return available_shear,static_shear

def get_static_shear_vector(sign_static,sigt_static,phi,cohesion):

    tanphi = np.tan(np.pi*np.array(phi)/180.)

    available_shear = np.array(sign_static)*tanphi - np.array(cohesion)
    static_shear = np.array(sigt_static)

    return available_shear,static_shear


def get_dynamic_shear(sigt1_dyn,inst):

    dynamic_shear = []
    for  jj in range(len(inst)) :
      ###### VALEUR LIMITEE A FS STATIQUE
#      for j,value in enumerate(sigt1_dyn[jj].valeurs):
#        if value > 0:
#          sigt1_dyn[jj].valeurs[j] = 0

      dynamic_shear.append(np.sum(np.array(sigt1_dyn[jj].valeurs)))

    dynamic_shear = np.array(dynamic_shear)
    
    return dynamic_shear

def get_dynamic_shear_vector(sigt1_dyn,inst):

    dynamic_shear = []
    for  jj in range(len(inst)) :
      ###### VALEUR LIMITEE A FS STATIQUE
#      for j,value in enumerate(sigt1_dyn[jj].valeurs):
#        if value < 0:
#          sigt1_dyn[jj].valeurs[j] = 0

      dynamic_shear.append(np.array(sigt1_dyn[jj].valeurs))

    dynamic_shear = np.array(dynamic_shear)

    return dynamic_shear

def get_local_FS(sign,sigt,phi,cohesion,):

    tanphi = np.tan(np.pi*phi/180.)
    static_shear = sign*tanphi-cohesion
    try:
      FS = static_shear / sigt
    except:
      FS = 0.
    
    return FS


def post_newmark_ops(self,**args):
  """
        Macro commande pour évaluer la stabilité d'un ouvrage en remblai
        (digue / barrage) au séisme par la méthode simplifiée de Newmark.
        Uniquement possible pour une modélisation 2D.
  """

  MasquerAlarme('MODELE1_63')
  MasquerAlarme('MODELE1_64')
  ##sys.stdout.flush() pour vider les #prints

  args = _F(args)

  ONLY_FS=False
  if args['RESULTAT'] is not None : 
    RESULTAT = args['RESULTAT']
    __model = None
    ### RECUPERATION DU MAILLAGE DANS LE RESULTAT DYNAMIQUE
    try:
      __model = RESULTAT.getModel()
    except:
      raise NameError("No model")
    __mail = __model.getMesh()
    dim = __mail.getDimension()
    if dim == 3:
      UTMESS('F', 'POST0_51')
    ## possiblement à gérer par la suite le cas de plusieurs champs matériaux dans
    ## le RESULTAT
    __ch_mat = RESULTAT.getMaterialField()

  else:
    ONLY_FS=True

  if args['RESULTAT_PESANTEUR'] is not None : 
    RESULTAT_PESANTEUR = args['RESULTAT_PESANTEUR']
    __modST = None
    try:
      __modST = RESULTAT_PESANTEUR.getModel()
    except:
      raise NameError("No model")
    ### RECUPERATION DU MAILLAGE DANS LE RESULTAT STATIQUE
    if ONLY_FS:
      __mail = __modST.getMesh()
      dim = __mail.getDimension()
      if dim == 3:
        UTMESS('F', 'POST0_51')
    else:
      __mailST = __modST.getMesh()
      dim = __mailST.getDimension()
      if dim == 3:
        UTMESS('F', 'POST0_51')

 ### RECUPERATION COEFFICIENT KY
  if args['KY'] is not None  :
    ky = args['KY']
   ### gravité
    g=9.81
    ## accélération limite
    ay = ky*g

 ### GROUP_MA DANS LE MODELE
  grpma = args['GROUP_MA_CALC']

  __mail = DEFI_GROUP(reuse = __mail,
                MAILLAGE = __mail,
                CREA_GROUP_MA = _F(NOM = 'ALL',
                                   #TYPE_MAILLE = '2D',
                                   UNION = grpma,),)

 ### RECUPERATION DES POSITIONS DU CERCLE DE GLISSEMENT
  if args['RAYON'] is not None  :
    TYPE = 'CERCLE'
    r = args['RAYON']
    posx = args['CENTRE_X']
    posy = args['CENTRE_Y']
  else : 
    TYPE = "MAILLAGE"
    __mail_1 = args['MAILLAGE_GLIS']

    __mail_1 = DEFI_GROUP(reuse = __mail_1,
                MAILLAGE = __mail_1,
                CREA_GROUP_MA = _F(NOM = 'ALL',
                                   #TYPE_MAILLE = '2D',
                                   TOUT = 'OUI',),)

    DEFI_GROUP(reuse=__mail_1,   MAILLAGE=__mail_1,
                 CREA_GROUP_NO=  _F(  NOM = 'DOMAIN_', OPTION = 'INCLUSION',
                                      MAILLAGE_INCL = __mail,
                                      GROUP_MA_INCL = 'ALL',
                                      GROUP_MA      = 'ALL',
                                      CAS_FIGURE    = '2D'))

    DEFI_GROUP(reuse=__mail_1,   MAILLAGE=__mail_1,
                 CREA_GROUP_MA=  _F(  NOM = 'DOMAIN_', OPTION = 'APPUI',
                                      TYPE_APPUI='AU_MOINS_UN',
                                      GROUP_NO      = 'DOMAIN_',),
                                      ),

    if args['GROUP_MA_GLIS'] is not None :
      __mail_1 = DEFI_GROUP(reuse = __mail_1,
                  MAILLAGE = __mail_1,
                  CREA_GROUP_MA = _F(NOM = 'RUPTURE',
                                     UNION = args['GROUP_MA_GLIS'],),)
    else :
      __mail_1 = DEFI_GROUP(reuse = __mail_1,
                  MAILLAGE = __mail_1,
                  CREA_GROUP_MA = _F(NOM = 'RUPTURE',
                                     TYPE_MAILLE='2D',
                                     TOUT='OUI',),)

    if args['GROUP_MA_LIGNE'] is not None :

      ma_ligne = args['GROUP_MA_LIGNE']

    #### Utlisateur n'a pas fournit GROUP_MA_LIGNE : On considere toutes les
    #### mailles SEG2 et SEG3 du maillage
    else :
      seg=[]
      _, _, yaseg2 = aster.dismoi('EXI_SEG2', __mail_1.getName(), 'MAILLAGE', 'F')
      if yaseg2 == 'OUI':

        seg.append('LIGNE_2')
        __mail_2 = DEFI_GROUP(reuse = __mail_1,
                    MAILLAGE = __mail_1,
                    CREA_GROUP_MA = _F(NOM = 'LIGNE_2',
                                       TYPE_MAILLE=('SEG2'),
                                       TOUT='OUI',),)

      _, _, yaseg3 = aster.dismoi('EXI_SEG3', __mail_1.getName(), 'MAILLAGE', 'F')
      if yaseg3 == 'OUI':
        seg.append('LIGNE_3')
        __mail_1 = DEFI_GROUP(reuse = __mail_1,
                    MAILLAGE = __mail_1,
                    CREA_GROUP_MA = _F(NOM = 'LIGNE_3',
                                       TYPE_MAILLE=('SEG3'),
                                       TOUT='OUI',),)

      ma_ligne = seg

    DEFI_GROUP(reuse=__mail_1,   MAILLAGE=__mail_1,
                 CREA_GROUP_NO=  _F(  NOM = 'LIGNE_', OPTION = 'INCLUSION',
                                      MAILLAGE_INCL = __mail,
                                      GROUP_MA_INCL = 'ALL',
                                      GROUP_MA      = ma_ligne,
                                      CAS_FIGURE    = '2D'))

    DEFI_GROUP(reuse=__mail_1,   MAILLAGE=__mail_1,
                 CREA_GROUP_MA=  _F(  NOM = 'LIGNE_', OPTION = 'APPUI',
                                      TYPE_APPUI='SOMMET',
                                      GROUP_NO      = 'LIGNE_',),
                                      ),

    # Orientation des mailles surfaciques
    __mail_1 = MODI_MAILLAGE(reuse        = __mail_1,
                       MAILLAGE     = __mail_1,
                       ORIE_PEAU_2D =_F(GROUP_MA=('LIGNE_',),),);

    ##### ON RESTREINT LE MAILLAGE PATCH A LA ZONE COMMUNE AVEC LE MAILLAGE DU
    ##### RESULTAT A CONSIDERER 
    __mail_2 = CREA_MAILLAGE(MAILLAGE=__mail_1,#INFO=2,
                             RESTREINT=_F(GROUP_MA=('LIGNE_','DOMAIN_','RUPTURE'),
                                          GROUP_NO=('LIGNE_','DOMAIN_',),
                            ),)

    #IMPR_RESU(RESU=_F(MAILLAGE = __mail_2,),FORMAT='MED',UNITE=23)


    __mail_L = CREA_MAILLAGE(MAILLAGE=__mail_2,#INFO=2,
                             RESTREINT=_F(GROUP_MA=('LIGNE_',),
                                          GROUP_NO=('LIGNE_',),
                            ),)


###############################################################################
####
#### CALCUL DU FACTEUR DE SECURITE STATIQUE
####
###############################################################################

  if args['RESULTAT_PESANTEUR'] is not None : 

    #### ASSERT A CREER SI MODELE D'ORIGINE PLUS COMPLEXE QUE D_PLAN
    ##### MODELE SUR LE MAILLAGE PATCH
    __MODST= AFFE_MODELE(MAILLAGE = __mail_2,
                  AFFE  = (_F(TOUT='OUI',
                              PHENOMENE    = 'MECANIQUE',
                              MODELISATION = 'D_PLAN',),),
                  VERI_JACOBIEN = 'NON',);

    __MODL= AFFE_MODELE(MAILLAGE = __mail_L,
                  AFFE  = (_F(TOUT='OUI',
                              PHENOMENE    = 'MECANIQUE',
                              MODELISATION = 'D_PLAN',),),
                  VERI_JACOBIEN = 'NON',);

    # CREATION D'UN MATERIAU BIDON POUR CREA_RESU 
    __MATBID = DEFI_MATERIAU(ELAS=_F(E = 1.,NU = 0.3,RHO = 1. ))

    __MATST = AFFE_MATERIAU(MAILLAGE = __mail_2,
                            AFFE=_F(MATER=__MATBID,TOUT='OUI',),
                            )
                               

    # OBTENTION DU CHAMP DES CONTRAINTES STATIQUE SUR LE MODELE AUXILAIRE 
    # CREATION D'UN RESULTAT AVEC MATERIAU BIDON POUR CALCUL DE SIRO_ELEM

    __instFS = RESULTAT_PESANTEUR.LIST_PARA()['INST'][-1]

    __CSTPGO = CREA_CHAMP(OPERATION = 'EXTR',
                        NOM_CHAM = 'SIEF_ELGA',
                        TYPE_CHAM = 'ELGA_SIEF_R',
                        RESULTAT = RESULTAT_PESANTEUR,
                        INST = __instFS,
                        )

    __CSTPGF = PROJ_CHAMP(METHODE='ECLA_PG',
                   CHAM_GD = __CSTPGO,
                    MODELE_1 = __modST,
                    MODELE_2 = __MODST,
                    CAS_FIGURE='2D', 
                    PROL_ZERO='OUI',
#                     DISTANCE_MAX=0.1,
                   )

    #### CREATION DU RESULTAT STATIQUE  AVEC CHAMP SIEF_ELGA PROJETE SUR LE MAILLAGE PATCH
    __recoST = CREA_RESU(OPERATION='AFFE',
                  TYPE_RESU='DYNA_TRANS',
                  NOM_CHAM='SIEF_ELGA',
                  AFFE=(_F(MODELE = __MODST,
                          CHAM_MATER = __MATST,
                          CHAM_GD=__CSTPGF,
                          INST=0.,),),);

    __recoST = CALC_CHAMP(reuse = __recoST,
             RESULTAT = __recoST,
             GROUP_MA = 'LIGNE_',
             MODELE = __MODST,
             CONTRAINTE = ('SIRO_ELEM',),
             );

    #### EXTRACTION DES COMPOSANTES DE SIRO_ELEM DU CALCUL STATIQUE
    __CSIST = CREA_CHAMP(OPERATION = 'EXTR',
                        NOM_CHAM = 'SIRO_ELEM',
                        TYPE_CHAM = 'ELEM_SIEF_R',
                        RESULTAT = __recoST,
                        NUME_ORDRE = 1,
                        )

    SIGN_stat = __CSIST.EXTR_COMP('SIG_N',[])
    SIGTN_stat = __CSIST.EXTR_COMP('SIG_TN',[])

    ##### CHAMPS PHI ET COHESION POUR CALCUL DE STABILITE STATIQUE
    __chPHNO = PROJ_CHAMP(METHODE='COLLOCATION',
                   CHAM_GD=args['CHAM_PHI'],
                   MAILLAGE_1=__mail,
                   MAILLAGE_2=__mail_2,
                   PROL_ZERO='OUI',
#                     DISTANCE_MAX=0.1,
                   )

    __chPHEL = CREA_CHAMP(OPERATION = 'DISC',
                        CHAM_GD  = __chPHNO,
                        MODELE = __MODST,
                        TYPE_CHAM = 'ELEM_NEUT_R',
                        PROL_ZERO='OUI',
                        )

    __chCONO = PROJ_CHAMP(METHODE='COLLOCATION',
                   CHAM_GD=args['CHAM_COHESION'],
                   MAILLAGE_1=__mail,
                   MAILLAGE_2=__mail_2,
                   PROL_ZERO='OUI',
#                     DISTANCE_MAX=0.1,
                   )

    __chCOEL = CREA_CHAMP(OPERATION = 'DISC',
                        CHAM_GD  = __chCONO,
                        MODELE = __MODST,
                        TYPE_CHAM = 'ELEM_NEUT_R',
                        PROL_ZERO='OUI',
                        #INFO=2,
                        )

    __chCPEL = CREA_CHAMP(OPERATION ='ASSE',
                     TYPE_CHAM ='ELEM_NEUT_R',
                     MODELE    =__MODST,
                     PROL_ZERO = 'OUI',
                     ASSE=(_F(GROUP_MA='LIGNE_',
                             CHAM_GD = __chPHEL,
                             CUMUL   = 'OUI',
                             COEF_R  = 1.,),
                          _F(GROUP_MA='LIGNE_',
                             CHAM_GD = __chCOEL,
                             CUMUL   = 'OUI',
                             COEF_R  = 1.,
                            ),),
                      )

    ##### CHAMP DES VALEURS PHI ET COHESION SUR LA LIGNE DE GLISSEMENT
    __chCPLG = PROJ_CHAMP(METHODE='COLLOCATION',
                   CHAM_GD=__chCPEL,
                   MODELE_1=__MODST,
                   MODELE_2=__MODL,
                   CAS_FIGURE='1.5D',
                   PROL_ZERO='OUI',
                   INFO=2,
#                     DISTANCE_MAX=0.1,
                   )

    ##### CALCUL DU FACTEUR DE SECURITE STATIQUE LOCAL

    __FstS = FORMULE(VALE = 'get_local_FS(SIG_N,SIG_TN,X1,X2)',
                             NOM_PARA=('SIG_N','SIG_TN','X1','X2'),get_local_FS=get_local_FS)

    __chSTSF = CREA_CHAMP(OPERATION = 'AFFE',
                          TYPE_CHAM = 'ELEM_NEUT_F',
                          MODELE = __MODST,
                          PROL_ZERO='OUI',
                          AFFE = _F(GROUP_MA = 'LIGNE_',
                               NOM_CMP  = 'X1',
                               VALE_F   = __FstS,),)

    __chSTSR = CREA_CHAMP(TYPE_CHAM = 'ELEM_NEUT_R',
               OPERATION = 'EVAL',
               CHAM_F    = __chSTSF,
               CHAM_PARA = (__CSIST,__chCPEL),
               INFO=1,)

    __chSTSL = PROJ_CHAMP(METHODE='COLLOCATION',
                   CHAM_GD=__chSTSR,
                   MODELE_1=__MODST,
                   MODELE_2=__MODL,
                   CAS_FIGURE='1.5D',
                   PROL_ZERO='OUI',
                   INFO=2,
#                     DISTANCE_MAX=0.1,
                   )

    ####### CALCUL DU FACTEUR DE SECURITE STATIQUE GLOBAL

    phiL = __chCPLG.EXTR_COMP('X1',[])
    cohesionL = __chCPLG.EXTR_COMP('X2',[])

    available_shear,static_shear = get_static_shear(SIGN_stat.valeurs,
                                              SIGTN_stat.valeurs,phiL.valeurs,cohesionL.valeurs)
    available_shear_v,static_shear_v = get_static_shear_vector(SIGN_stat.valeurs,
                                              SIGTN_stat.valeurs,phiL.valeurs,cohesionL.valeurs)

    FSp = available_shear / (static_shear)

    FSpL = []
    for k in range(len(available_shear_v)):
      try:
        FSpL.append(available_shear_v[k] / (static_shear_v[k] ))
      except:
        FSpL.append(0.)

    #### PREPARATION TABLE DU FACTEUR DE SECURITE
    if args['RESULTAT'] is None : 
      tabini = Table(para=["INST", "FS"],
                 typ=["R", "R"])
      if args['RESULTAT'] is None : 
        tabini.append({'INST': 0.0, 'FS': FSp})
        self.register_result(__chSTSL, args["CHAM_FS"])

      dprod = tabini.dict_CREA_TABLE()
      tabout = CREA_TABLE(**dprod)

###############################################################################
####
#### CALCUL POUR RESULTAT DYNAMIQUE
####
###############################################################################

  if args['RESULTAT'] is not None : 

##### OPERATIONS SUR LE MAILLAGE DYNAMIQUE POUR CALCUL DU CENTRE DE MASSE DE LA ZONE
##### QUI GLISSE 

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

  #### Calcul de la masse de la zone qui glisse à partir du GROUP_MA 'GLISSE'

    __tabmas = POST_ELEM(RESULTAT=RESULTAT,
                        MASS_INER=_F(GROUP_MA='GLISSE'),)

    masse = __tabmas['MASSE',1]
    cdgx = __tabmas['CDG_X',1]
    cdgy = __tabmas['CDG_Y',1]


##############################################################################
##   METHODE : CALCUL DE L'ACCELERATION MOYENNE A PARTIR DE LA RESULTANTE
##             LE LONG DE LA SURFACE DE GLISSEMENT
##############################################################################

  #### Il faut que SIEF_ELGA soit prélablement calculé par l'utilisateur

    __RESU3 = CALC_CHAMP(
             RESULTAT = RESULTAT,
             MODELE = __model,
             CHAM_MATER = __ch_mat,
             FORCE = ('FORC_NODA'),
             #CONTRAINTE = ('SIEF_ELGA',),
             );


  ##### Calcul de la résultante sur la ligne de glissement du calcul dynamique

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

    elif TYPE == 'MAILLAGE':

### CHAMP FORC_NODA POUR CALCUL RESULTANTE
      __recou = PROJ_CHAMP(METHODE='COLLOCATION',
                     RESULTAT=__RESU3,
                     MAILLAGE_1=__mail,
                     MAILLAGE_2=__mail_2,
                     TYPE_CHAM='NOEU',
                     NOM_CHAM=('FORC_NODA'),
                     PROL_ZERO='OUI',
#                     DISTANCE_MAX=0.1,
                     )

    #### TABLE AVEC RESULTANTE CALCUL DYNAMIQUE DANS LE REPERE GLOBAL
    #### UTILISE POUR CALCUL DE L'ACCELERATION MOYENNE
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


################################################################################
####
#### CALCUL FACTEUR DE SECURITE EN DYNAMIQUE (uniquemnt si RESULTAT_PESANTEUR est fourni)
#### Dans ce cas, il faut qu'une phase statique prélable au calcul dynamique soit
#### réalisé, afin que les contraintes du résultat dynamique intégrent les
#### contraintes statiques
####
################################################################################


##### CETTE PARTIE MARCHE UNIQUMENT AVEC MAILLAGE PATCH POUR L'INSTANT
    if args['RESULTAT_PESANTEUR'] is not None : 

    ### BOUCLE POUR CREATION DU RESULTAT DYNAMIQUE PROJETE DANS LES PG
    ### DU MODELE AUXILIAIRE (MAILLAGE PATCH)

      __MODYN= AFFE_MODELE(MAILLAGE = __mail_2,
                  AFFE  = (_F(TOUT='OUI',
                              PHENOMENE    = 'MECANIQUE',
                              MODELISATION = 'D_PLAN',),),
                  VERI_JACOBIEN = 'NON',);

      # CREATION D'UN MATERIAU BIDON POUR CREA_RESU 
      __MATBIDD = DEFI_MATERIAU(ELAS=_F(E = 1.,NU = 0.3,RHO = 1. ))

      __MATDYN = AFFE_MATERIAU(MAILLAGE = __mail_2,
                              AFFE=_F(MATER=__MATBIDD,TOUT='OUI',),
                              )
                               

      __instSD = RESULTAT.LIST_PARA()['INST']

      __CSDPGI = CREA_CHAMP(OPERATION = 'EXTR',
                          NOM_CHAM = 'SIEF_ELGA',
                          TYPE_CHAM = 'ELGA_SIEF_R',
                          RESULTAT = RESULTAT,
                          INST = __instSD[0],
                          )

      __CSDPGF = PROJ_CHAMP(METHODE='ECLA_PG',
                     CHAM_GD = __CSDPGI,
                      MODELE_1 = __model,
                      MODELE_2 = __MODYN,
                      CAS_FIGURE='2D', 
                      PROL_ZERO='OUI',
#                     DISTANCE_MAX=0.1,
                     )
      #### CREATION DU RESULTAT DYNAMIQUE AVEC CHAMP SIEF_ELGA PROJETE SUR LE MAILLAGE PATCH
      __recoSD = CREA_RESU(OPERATION='AFFE',
                    TYPE_RESU='DYNA_TRANS',
                    NOM_CHAM='SIEF_ELGA',
                    AFFE=(_F(MODELE = __MODYN,
                            CHAM_MATER = __MATDYN,
                            CHAM_GD=__CSDPGF,
                            INST=__instSD[0],),),);

      DETRUIRE(INFO=1,CONCEPT=_F(NOM=(__CSDPGI,__CSDPGF)));

      for inst in __instSD[1:]:

        __CSDPGI = CREA_CHAMP(OPERATION = 'EXTR',
                          NOM_CHAM = 'SIEF_ELGA',
                          TYPE_CHAM = 'ELGA_SIEF_R',
                          RESULTAT = RESULTAT,
                          INST = inst,
                          )

        __CSDPGF = PROJ_CHAMP(METHODE='ECLA_PG',
                         CHAM_GD = __CSDPGI,
                          MODELE_1 = __model,
                          MODELE_2 = __MODYN,
                          CAS_FIGURE='2D', 
                          PROL_ZERO='OUI',
    #                     DISTANCE_MAX=0.1,
                         )

        __recoSD = CREA_RESU(reuse = __recoSD,
                    RESULTAT = __recoSD,
                    OPERATION='AFFE',
                    TYPE_RESU='DYNA_TRANS',
                    NOM_CHAM='SIEF_ELGA',
                    AFFE=(_F(MODELE = __MODYN,
                            CHAM_MATER = __MATDYN,
                            CHAM_GD=__CSDPGF,
                            INST=inst,),),);

        DETRUIRE(INFO=1,CONCEPT=_F(NOM=(__CSDPGI,__CSDPGF)));

    #### CALCUL DES CHAMPS SIRO_ELEM DANS LA LIGNE DE RUPTURE
    #### UTILISE POUR ESTIMATION DES CONTRAINTES RESISTANTES ET MOBILISEES

      __recoSD = CALC_CHAMP(reuse = __recoSD,
               RESULTAT = __recoSD,
               GROUP_MA = 'LIGNE_',
               MODELE = __MODYN,
               CONTRAINTE = ('SIRO_ELEM',),
               );

    
    #### TABLE AVEC CONTRAINTES CALCUL DYNAMIQUE DANS LA LIGNE DE RUPTURE DANS LE REPERE LOCAL
    #### UTILISE POUR CALCUL DE LA CONTRAINTE DE CISAILLEMENT MOBILISEE

      SIGN_dyn = []
      SIGT_dyn = []

      for inst in __instSD:

        #print ("Instant de calcul = "+str(inst))

        __CSISD = CREA_CHAMP(OPERATION = 'EXTR',
                            NOM_CHAM = 'SIRO_ELEM',
                            TYPE_CHAM = 'ELEM_SIEF_R',
                            RESULTAT = __recoSD,
                            INST = inst,
                            )

        SIGN_dyna = __CSISD.EXTR_COMP('SIG_N',[])
        SIGTN_dyna = __CSISD.EXTR_COMP('SIG_TN',[])

        SIGN_dyn.append(SIGN_dyna)
        SIGT_dyn.append(SIGTN_dyna)

        DETRUIRE(INFO=1,CONCEPT=_F(NOM=(__CSISD,)));

      #### CALCUL DE LA CONTRAINTE DE CISAILLEMENT MOBILISEE DU CALCUL DYNAMIQUE
      dynamic_shear = get_dynamic_shear(SIGT_dyn,__instSD)
      dynamic_shear_v = get_dynamic_shear_vector(SIGT_dyn,__instSD)

      ##### CALCUL DU FACTEUR DE SECURITE

      FSp = available_shear / (static_shear - dynamic_shear)

      FSpL = []
      for k in range(len(available_shear_v)):
        try:
          FSpL.append(available_shear_v[k] / (static_shear_v[k] - dynamic_shear_v[k]))
        except:
          FSpL.append(0.)

      tabini = Table(para=["INST", "FS"],
                       typ=["R", "R"])

      #### PRPARATION TABLE DU FACTEUR DE SECURITE DYNAMIQUE
      for j in range(len(__instSD)):
        tabini.append({'INST': __instSD[j], 'FS': FSp[j]})

      dprod = tabini.dict_CREA_TABLE()
      __TFS = CREA_TABLE(**dprod)


################################################################################
####
#### CACUL DE L'ACCELERATION MOYENNE A PARTIR DE LA RESULTANTE ET DE LA MASSE
#### DE LA ZONE DE GLISSEMENT
####
################################################################################

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

    initial = True
    vini = 0.
    for i in range(len(time)):
      if ind[i]:
        vitA[i] = vitA[i]-vini
        initial = False
      else :
        initial = True
        vini = vitAFv[i]
        ##print vini

    for i in range(len(time)):
      if vitA[i]<0:
        vitA[i]=0.

    __vitAF = DEFI_FONCTION(NOM_RESU = 'VITE',
                  NOM_PARA = 'INST',
                  ABSCISSE = time,
                  ORDONNEE = list(vitA)),

    __deplAF = CALC_FONCTION(INTEGRE=_F(FONCTION=__vitAF,))


## CREATION DE LA TABLE DE SORTIE

    __tabaAF = CREA_TABLE(FONCTION=_F(FONCTION=__accAF),)
    __tabvAF = CREA_TABLE(FONCTION=_F(FONCTION=__vitAF),)
    __tabdAF = CREA_TABLE(FONCTION=_F(FONCTION=__deplAF),)

    tabout = CREA_TABLE(FONCTION=_F(FONCTION=__accyFL),)

    act_table = []
    act_table.append(_F(OPERATION='COMB',
                        TABLE=__tabaAF, NOM_PARA='INST'),)
    act_table.append(_F(OPERATION='COMB',
                        TABLE=__tabvAF, NOM_PARA='INST'),)
    act_table.append(_F(OPERATION='COMB',
                        TABLE=__tabdAF, NOM_PARA='INST'),)

    tabout = CALC_TABLE(reuse=tabout , TABLE=tabout ,
                        ACTION=act_table)

    if args['RESULTAT_PESANTEUR'] is not None : 
      tabout = CALC_TABLE(TABLE=tabout ,
                        ACTION=_F(OPERATION='COMB',
                                  TABLE=__TFS, NOM_PARA='INST'),)

##### NETTOYAGE DES GROUPES DE MAILLE GENERES

  __mail = DEFI_GROUP(reuse = __mail,
                MAILLAGE = __mail,
                DETR_GROUP_MA = _F(NOM = ('ALL',),),)
                
  if args['RESULTAT'] is not None : 
    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  DETR_GROUP_MA = _F(NOM = ('GLISSE_','GLISSE',),),
                  DETR_GROUP_NO = _F(NOM = ('GLISSE',),),
                )

  if TYPE == 'MAILLAGE':
    __mail = DEFI_GROUP(reuse = __mail,
                  MAILLAGE = __mail,
                  DETR_GROUP_NO = _F(NOM = ('GLISSE_'),),
                  )
    __mail_1 = DEFI_GROUP(reuse = __mail_1,
                  MAILLAGE = __mail_1,
                  DETR_GROUP_MA = _F(NOM = ('RUPTURE','ALL'),),)
    __mail_1 = DEFI_GROUP(reuse = __mail_1,
                  MAILLAGE = __mail_1,
                  DETR_GROUP_NO = _F(NOM = ('LIGNE_','DOMAIN_',),),
                  DETR_GROUP_MA = _F(NOM = ('LIGNE_','DOMAIN_',),)
                  )
    if args['GROUP_MA_LIGNE'] is  None :
      if yaseg2 == 'OUI':
        __mail_1 = DEFI_GROUP(reuse = __mail_1,
                      MAILLAGE = __mail_1,
                      DETR_GROUP_NO = _F(NOM = ('LIGNE_2',),),)
      if yaseg3 == 'OUI':
        __mail_1 = DEFI_GROUP(reuse = __mail_1,
                      MAILLAGE = __mail_1,
                      DETR_GROUP_NO = _F(NOM = ('LIGNE_3',),),)



  RetablirAlarme('MODELE1_63')
  RetablirAlarme('MODELE1_64')
  return tabout
