# coding=utf-8

from Cata.Syntax import *
from Cata.DataStructure import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: jacques.pellet at edf.fr

MODI_MODELE=OPER(nom="MODI_MODELE",op= 103,sd_prod=modele_sdaster,reentrant='o',
         UIinfo={"groupes":("Modélisation",)},
         fr=tr("Modifier la partition d'un modèle (parallélisme) "),

         MODELE          =SIMP(statut='o',typ=modele_sdaster,min=1,max=1,),

         PARTITION         =FACT(statut='d',
             PARALLELISME    =SIMP(statut='f',typ='TXM',defaut="GROUP_ELEM",
                                   into=("MAIL_CONTIGU","MAIL_DISPERSE","SOUS_DOMAINE","CENTRALISE","GROUP_ELEM")),
             b_dist_maille          =BLOC(condition = "PARALLELISME in ('MAIL_DISPERSE','MAIL_CONTIGU')",
                 CHARGE_PROC0_MA =SIMP(statut='f',typ='I',defaut=100,val_min=0),
             ),
             b_dist_sd          =BLOC(condition = "PARALLELISME == 'SOUS_DOMAINE'",
                 PARTITION       =SIMP(statut='o',typ=sd_partit),
                 CHARGE_PROC0_SD =SIMP(statut='f',typ='I',defaut=0,val_min=0),
             ),
         ),
)  ;
