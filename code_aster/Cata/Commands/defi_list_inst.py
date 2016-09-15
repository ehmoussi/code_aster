# coding=utf-8

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: mickael.abbas at edf.fr



# Bloc pour decoupe automatique
bloc_auto   =BLOC(fr                = tr("Subdivision de type automatique"),
                  condition         = "SUBD_METHODE == 'AUTO'",
                  SUBD_PAS_MINI     = SIMP(fr                = tr("Pas de temps en dessous duquel on ne subdivise plus"),
                                           statut            = 'f',
                                           typ               = 'R',
                                           val_min           = 0.0,
                                           max               = 1,
                                           defaut            = 0.,
                                           ),
                  )

# Bloc pour decoupe manuel
bloc_manu   =BLOC(fr                = tr("Subdivision de type manuel"),
                  condition         = "SUBD_METHODE == 'MANUEL'",
                  regles            = (AU_MOINS_UN('SUBD_NIVEAU','SUBD_PAS_MINI'),),
                  SUBD_PAS          = SIMP(fr                = tr("Nombre de subdivision d'un pas de temps"),
                                           statut            = 'f',
                                           typ               = 'I',
                                           val_min           = 2,
                                           max               = 1,
                                           defaut            = 4,
                                           ),

                  SUBD_NIVEAU       = SIMP(fr                = tr("Nombre maximum de niveau de subdivision d'un pas de temps"),
                                           statut            = 'f',
                                           typ               = 'I',
                                           val_min           = 2,
                                           max               = 1,
                                           defaut            = 3,
                                           ),
                  SUBD_PAS_MINI     = SIMP(fr                = tr("Pas de temps en dessous duquel on ne subdivise plus"),
                                           statut            = 'f',
                                           typ               = 'R',
                                           val_min           = 0.0,
                                           max               = 1,
                                           defaut            = 0.,
                                           ),
                 )

# Bloc pour decoupe automatique - Cas de la collision
bloc_auto2  =BLOC(fr                = tr("Subdivision de type automatique"),
                  condition         = "SUBD_METHODE == 'AUTO'",
                  SUBD_INST         = SIMP(fr                = tr("Parametre de decoupe fine du pas de temps"),
                                           statut            = 'o',
                                           typ               = 'R',
                                           val_min           = 0.0,
                                           max               = 1,
                                           ),
                  SUBD_DUREE        = SIMP(fr                = tr("Duree de decoupe apres collision"),
                                           statut            = 'o',
                                           typ               = 'R',
                                           val_min           = 0.0,
                                           max               = 1,
                                           ),
                  )

# Bloc pour decoupe du pas de temps
bloc_deco   =BLOC(fr                = tr("Action de decoupe du pas temps"),
                  condition         = "ACTION == 'DECOUPE' or ACTION == 'AUTRE_PILOTAGE'",
                  SUBD_METHODE      = SIMP(fr                = tr("Méthode de subdivision des pas de temps en cas de divergence"),
                                           statut            = 'f',
                                           typ               = 'TXM',
                                           max               = 1,
                                           into              = ("MANUEL","AUTO"),
                                           defaut            = "MANUEL",
                                           ),
                  b_deco_manu       = bloc_manu,
                  b_deco_auto       = bloc_auto,
                 )


# Bloc pour decoupe du pas de temps - special pour collision
bloc_deco2  =BLOC(fr                = tr("Action de decoupe du pas temps"),
                  condition         = "ACTION == 'DECOUPE'",
                  SUBD_METHODE      = SIMP(fr                = tr("Méthode de subdivision des pas de temps en cas de collision"),
                                           statut            = 'f',
                                           typ               = 'TXM',
                                           max               = 1,
                                           into              = ("MANUEL","AUTO"),
                                           defaut            = "AUTO",
                                           ),



                  b_deco_manu       = bloc_manu,
                  b_deco_auto       = bloc_auto2,
                 )

# Bloc pour extrapolation du nombre d'iterations de Newton
bloc_supp   =BLOC(fr                = tr("Action d'extrapolation du nombre d'iterations de Newton"),
                  condition         = "ACTION == 'ITER_SUPPL'",
                  PCENT_ITER_PLUS   = SIMP(fr                = tr("Pourcentage d'itérations autorisées en plus"),
                                           statut            = 'f',
                                           typ               = 'I',
                                           val_min           = 20,
                                           max               = 1,
                                           defaut            = 50,
                                           ),
                  SUBD_METHODE      = SIMP(fr                = tr("Méthode de subdivision des pas de temps en cas de divergence"),
                                           statut            = 'f',
                                           typ               = 'TXM',
                                           max               = 1,
                                           into              = ("MANUEL","AUTO"),
                                           defaut            = "MANUEL",
                                           ),
                  b_deco_manu       = bloc_manu,
                  b_deco_auto       = bloc_auto,
                 )

# Bloc pour adaptation du coefficient de penalisation
bloc_pene   =BLOC(fr                = tr("Action d' adaptation du coefficient de penalisation"),
                  condition         = "ACTION == 'ADAPT_COEF_PENA'",
                  COEF_MAXI         = SIMP(fr                = tr("Coefficient multiplicateur maximum du coefficient de penalisation"),
                                           statut            = 'f',
                                           typ               = 'R',
                                           val_min           = 1.,
                                           max               = 1,
                                           defaut            = 1E12,
                                           ),
                 )

DEFI_LIST_INST = OPER(nom="DEFI_LIST_INST",op=  28,sd_prod=list_inst,reentrant='n',
                      UIinfo={"groupes":("Fonctions",)},
                      fr=tr("Définition de la gestion de la liste d'instants"),

# ----------------------------------------------------------------------------------------------------------------------------------
# mot-cle pour la definition a priori de la liste d'instant
# ----------------------------------------------------------------------------------------------------------------------------------

DEFI_LIST   =FACT(fr                = tr("Definition a priori de la liste d'instants"),
                  statut            = 'o',
                  max               = 1,
                  METHODE           = SIMP(fr                = tr("Methode de definition de la liste d'instants"),
                                           statut            = 'o',
                                           typ               = 'TXM',
                                           max               = 1,
                                           position          = 'global',
                                           into              = ("MANUEL","AUTO",),
                                           defaut            = "MANUEL",
                                           ),
                  b_manuel          = BLOC(fr                = tr("Liste d'instants donnée par l'utilisateur"),
                                           condition         = "METHODE == 'MANUEL' ",
                                           regles=(UN_PARMI('LIST_INST','VALE','RESULTAT'),
                                                   PRESENT_PRESENT('RESULTAT','SUBD_PAS'),),
                                           VALE              = SIMP(statut          = 'f',
                                                                    typ             = 'R',
                                                                    max             = '**'),
                                           LIST_INST         = SIMP(statut          = 'f',
                                                                    typ             = listr8_sdaster,
                                                                    ),
                                           RESULTAT          = SIMP(statut          = 'f',
                                                                    typ             = resultat_sdaster,
                                                                    ),
                                           SUBD_PAS          = SIMP(statut          = 'f',
                                                                    typ             = 'I',
                                                                    max             = 1,
                                                                    val_min         = 1,
                                                                    ),

                                           ),
                  b_auto            = BLOC(fr                = tr("Gestion automatique de la liste d'instants"),
                                           condition         = "(METHODE == 'AUTO') ",
                                           regles=(UN_PARMI('LIST_INST','VALE',),),
                                           VALE              = SIMP(statut          = 'f',
                                                                    typ             = 'R',
                                                                    max             = '**'),
                                           LIST_INST         = SIMP(statut          = 'f',
                                                                    typ             = listr8_sdaster,
                                                                    ),
                                           PAS_MINI          = SIMP(statut          = 'f',
                                                                    typ             = 'R',
                                                                    max             = 1,
                                                                    val_min         = 1.e-12,
                                                                    ),
                                           PAS_MAXI          = SIMP(statut          = 'f',
                                                                    typ             = 'R',
                                                                    max             = 1,
                                                                    ),
                                           NB_PAS_MAXI       = SIMP(statut          = 'f',
                                                                    typ             = 'I',
                                                                    max             = 1,
                                                                    val_max         = 1000000,
                                                                    defaut          = 1000000,
                                                                    ),
                                           ),
                 ),
# ----------------------------------------------------------------------------------------------------------------------------------
# mot-cle pour le comportement en cas d'echec (on doit recommencer le meme instant)
# ----------------------------------------------------------------------------------------------------------------------------------

ECHEC       =FACT(fr                = tr("Comportement en cas d'echec"),
                  statut            = 'd',
                  max               = '**',
                  EVENEMENT         = SIMP(fr                = tr("Type de l'evenement"),
                                           statut            = 'f',
                                           typ               = 'TXM',
                                           max               = 1,
                                           into              = ("ERREUR","DELTA_GRANDEUR","COLLISION","RESI_MAXI",
                                                                "INTERPENETRATION","DIVE_RESI","INSTABILITE"),
                                           defaut            = "ERREUR",
                                           ),
                  b_erreur          = BLOC(fr                = tr("Event: erreur ou iter_maxi"),
                                           condition         = "EVENEMENT == 'ERREUR' ",
                                           ACTION            = SIMP(fr              = tr("Actions possibles"),
                                                                    statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("ARRET","DECOUPE",
                                                                                       "ITER_SUPPL","AUTRE_PILOTAGE"),
                                                                    defaut          = "DECOUPE",
                                                                    ),
                                           b_deco            = bloc_deco,
                                           b_supp            = bloc_supp,
                                           ),
                  b_edelta          = BLOC(fr                = tr("Event: l'increment d'une composante d'un champ depasse le seuil"),
                                           condition         = "EVENEMENT == 'DELTA_GRANDEUR' ",
                                           VALE_REF          = SIMP(fr              = tr("Valeur du seuil"),
                                                                    statut          = 'o',
                                                                    typ             = 'R',
                                                                    max             = 1,
                                                                    ),
                                           NOM_CHAM          = SIMP(fr              = tr("Nom du champ"),
                                                                    statut          = 'o',
                                                                    typ             = 'TXM',
                                                                    max             = 1,
                                                                    into            = ("DEPL","VARI_ELGA","SIEF_ELGA",),
                                                                    ),
                                           NOM_CMP           = SIMP(fr              = tr("Nom de la composante"),
                                                                    statut          = 'o',
                                                                    typ             = 'TXM',
                                                                    max             = 1,
                                                                    ),
                                           ACTION            = SIMP(fr              = tr("Actions possibles"),
                                                                    statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("ARRET","DECOUPE",),
                                                                    defaut          = "DECOUPE",
                                                                    ),
                                           b_deco            = bloc_deco,
                                           ),
                  b_colli           = BLOC(fr                = tr("Event: collision"),
                                           condition         = "EVENEMENT == 'COLLISION' ",
                                           ACTION            = SIMP(fr              = tr("Actions possibles"),
                                                                    statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("ARRET","DECOUPE",),
                                                                    defaut          = "DECOUPE",
                                                                    ),
                                           b_deco2           = bloc_deco2,
                                           ),
                  b_penetration     = BLOC(fr                = tr("Event: interpenetration des surfaces en contact"),
                                           condition         = "EVENEMENT == 'INTERPENETRATION' ",
                                           PENE_MAXI         = SIMP(fr              = tr("Valeur maxi de l'interpenetration"),
                                                                    statut          = 'o',
                                                                    typ             = 'R',
                                                                    max             = 1,
                                                                    ),


                                           ACTION            = SIMP(fr              = tr("Actions possibles"),
                                                                    statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("ARRET","ADAPT_COEF_PENA",),
                                                                    defaut          = "ADAPT_COEF_PENA",
                                                                    ),
                                           b_pene            = bloc_pene,
                                           ),
                  b_dive_resi       = BLOC(fr                = tr("Event: divergence du residu"),
                                           condition         = "EVENEMENT == 'DIVE_RESI' ",
                                           ACTION            = SIMP(fr              = tr("Actions possibles"),
                                                                    statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("DECOUPE",),
                                                                    defaut          = "DECOUPE",
                                                                    ),
                                           b_deco            = bloc_deco,
                                           ),
                  b_resi_maxi       = BLOC(fr                = tr("Event: residu troup grande"),
                                           condition         = "EVENEMENT == 'RESI_MAXI' ",
                                           RESI_GLOB_MAXI    = SIMP(fr              = tr("Valeur du seuil"),
                                                                    statut          = 'o',
                                                                    typ             = 'R',
                                                                    max             = 1,
                                                                    ),
                                           ACTION            = SIMP(fr              = tr("Actions possibles"),
                                                                    statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("DECOUPE",),
                                                                    defaut          = "DECOUPE",
                                                                    ),
                                           b_deco            = bloc_deco,
                                           ),
                  b_instabilite     = BLOC(fr                = tr("Event: instabilite"),
                                           condition         = "EVENEMENT == 'INSTABILITE' ",
                                           ACTION            = SIMP(fr              = tr("Actions possibles"),
                                                                    statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("ARRET","CONTINUE",),
                                                                    defaut          = "CONTINUE",
                                                                    ),
                                           ),

                 ),

# ----------------------------------------------------------------------------------------------------------------------------------
# Mot-cle pour le comportement en cas de succes (on a bien converge)
# ----------------------------------------------------------------------------------------------------------------------------------

b_adap  =   BLOC(condition="METHODE == 'AUTO'",

ADAPTATION  =FACT(fr                = tr("Parametres de l'evenement declencheur de l'adaptation du pas de temps"),
                  statut            = 'd',
                  max               = '**',
                  EVENEMENT         = SIMP(fr                = tr("Nom de l'evenement declencheur de l'adaptation"),
                                           statut            = 'f',
                                           max               = 1,
                                           typ               = 'TXM',
                                           into              = ("SEUIL","TOUT_INST","AUCUN"),
                                           defaut            = "SEUIL",
                                           ),
                  b_adap_seuil      = BLOC(fr                = tr("Seuil d'adaptation"),
                                           condition         = "EVENEMENT == 'SEUIL' ",
                                           regles            = (PRESENT_PRESENT('NB_INCR_SEUIL','NOM_PARA',),
                                                                PRESENT_PRESENT('NB_INCR_SEUIL','CRIT_COMP',),
                                                                PRESENT_PRESENT('NB_INCR_SEUIL','CRIT_COMP',),),
                                           NB_INCR_SEUIL     = SIMP(statut          = 'f',
                                                                    typ             = 'I',
                                                                    defaut          =  2,
                                                                   ),
                                           NOM_PARA          = SIMP(statut          = 'f',
                                                                    typ             = 'TXM',
                                                                    into            = ("NB_ITER_NEWTON",),
                                                                    defaut          = "NB_ITER_NEWTON",
                                                                    ),
                                           CRIT_COMP         = SIMP(statut          = 'f',
                                                                    typ             = 'TXM',
                                                                    into            = ("LT","GT","LE","GE"),
                                                                    defaut          = "LE",
                                                                    ),
                                           b_vale_I          = BLOC(fr              = tr("Valeur entiere"),
                                                                    condition       = "NOM_PARA == 'NB_ITER_NEWTON' ",
                                                                    VALE_I          = SIMP(statut='f',typ='I',),
                                                                    ),
                                           ),


#
#  Parametres du mode de calcul de dt+
#      dans le cas FIXE            :(deltaT+) = (deltaT-)x(1+PCENT_AUGM/100)
#      dans le cas DELTA_GRANDEUR : (deltaT+) = (deltaT-)x(VALREF/deltaVAL) : l'acceleration est inversement proportionnelle
#                                                                             a la variation de la grandeur
#      dans le cas ITER_NEWTON    : (deltaT+) = (deltaT-) x sqrt(VALREF/N)  : l'acceleration est inversement proportionnelle
#                                                                             au nombre d'iterations de Newton precedent

                  MODE_CALCUL_TPLUS = SIMP(fr                = tr("Parametres du mode de calcul de dt+"),
                                           statut            = 'f',
                                           max               = 1,
                                           typ               = 'TXM',
                                           into              = ("FIXE","DELTA_GRANDEUR","ITER_NEWTON","IMPLEX"),
                                           defaut            = 'FIXE',
                                           ),

                  b_mfixe           = BLOC(fr                = tr("Mode de calcul de dt+: fixe"),
                                           condition         = "MODE_CALCUL_TPLUS == 'FIXE' ",
                                           PCENT_AUGM        = SIMP(statut          = 'f',
                                                                    max             = 1,
                                                                    typ             = 'R',
                                                                    defaut          = 100.,
                                                                    val_min         = -100.,
                                                                    ),
                                           ),
                  b_mdelta          = BLOC(fr                = tr("Mode de calcul de dt+: increment d'une grandeur"),
                                           condition         = "MODE_CALCUL_TPLUS == 'DELTA_GRANDEUR' ",
                                           VALE_REF          = SIMP(statut          = 'o',
                                                                    max             = 1,
                                                                    typ             = 'R',
                                                                    ),
                                           NOM_CHAM          = SIMP(statut          = 'o',
                                                                    max             = 1,
                                                                    typ             = 'TXM',
                                                                    into            = ("DEPL","VARI_ELGA","SIEF_ELGA",),
                                                                    ),
                                           NOM_CMP           = SIMP(statut          = 'o',
                                                                    max             = 1,
                                                                    typ             = 'TXM',),
                                           ),
                  b_mitnew          = BLOC(fr                = tr("Mode de calcul de dt+: nb iterations de Newton"),
                                           condition         = "MODE_CALCUL_TPLUS == 'ITER_NEWTON' ",
                                           NB_ITER_NEWTON_REF= SIMP(statut          = 'o',
                                                                    max             = 1,
                                                                    typ             = 'I',
                                                                    ),
                                           ),
# les schemas pre-definis :
#  abaqus :
#      EVENEMENT       ='SEUIL'
#      NB_INCR_SEUIL     = 2
#      NOM_PARA          ='NB_ITER_NEWTON'
#      CRIT_COMP         ='LE'
#      VALE_I            = 5
#      MODE_CALCUL_TPLUS ='FIXE'
#      PCENT_AUGM        = 50.
#  Zebulon 1 :
#      EVENEMENT       ='TOUT_INST'
#      MODE_CALCUL_TPLUS ='DELTA_GRANDEUR'
#      VALE_REF          = valref
#      NOM_CHAM          ='VARI_ELGA'
#      NOM_CMP           ='V1'
#  Zebulon 2 :
#      EVENEMENT       ='TOUT_INST'
#      MODE_CALCUL_TPLUS ='ITER_NEWTON'
#      NB_ITER_NEWTON_REF= nc
#  Tough2 :
#      EVENEMENT       ='SEUIL'
#      NB_INCR_SEUIL     = 1
#      NOM_PARA          ='NB_ITER_NEWTON'
#      CRIT_COMP         ='LE'
#      VALE_I            = n
#      MODE_CALCUL_TPLUS ='FIXE'
#      PCENT_AUGM        = 100.
#  Oliver :
#      EVENEMENT       ='TOUT_INST'
#      MODE_CALCUL_TPLUS ='FORMULE'
#      NOM_SCHEMA        ='OLIVER'

             ),
      ),
# ----------------------------------------------------------------------------------------------------------------------------------

    INFO                  =SIMP(statut='f',typ='I',defaut= 1,into=(1,2) ),

)  ;
