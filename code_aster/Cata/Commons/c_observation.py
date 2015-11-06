# coding=utf-8

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
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

def C_OBSERVATION(PHYSIQUE) : 

        assert PHYSIQUE in ('MECANIQUE','THERMIQUE')
        _meca = False
        _ther = False
        _meca = PHYSIQUE == 'MECANIQUE'
        _ther = PHYSIQUE == 'THERMIQUE'

# Select nodal fields
        _BlocNode  = {}
        _BlocNode['TOUT']       = SIMP(statut='d',typ='TXM',into=("OUI",) )
        _BlocNode['NOEUD']      = SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**')
        _BlocNode['GROUP_NO']   = SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**')
        _BlocNode['MAILLE']     = SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**')
        _BlocNode['GROUP_MA']   = SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**')

# Select element fields
        _BlocElem = {}
        _BlocElem['TOUT']       = SIMP(statut='d',typ='TXM',into=("OUI",) )
        _BlocElem['MAILLE']     = SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**')
        _BlocElem['GROUP_MA']   = SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**')
        _BlocElem['EVAL_ELGA']  = SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=1,defaut='VALE',into=("MIN","MAX","VALE",),)

# All keywords
        _Keywords={}
        _Keywords['TITRE']          = SIMP(statut='f',typ='TXM',max=1)
        _Keywords['OBSE_ETAT_INIT'] = SIMP(statut='f',typ='TXM',into=("OUI","NON"),defaut='OUI' )
        _Keywords['EVAL_CHAM']      = SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=1,defaut='VALE',
                                                into=("MIN","MAX","MOY","MAXI_ABS","MINI_ABS","VALE",),)
        _Keywords['NOM_CMP']        = SIMP(statut='o',typ='TXM',max=20)
        _Keywords['EVAL_CMP']       = SIMP(statut='f',typ='TXM',validators=NoRepeat(),max=1,defaut='VALE',
                                                 into=("VALE","FORMULE",),)
        _Keywords['INST']           = SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' )
        _Keywords['LIST_INST']      = SIMP(statut='f',typ=listr8_sdaster)
        _Keywords['PAS_OBSE']       = SIMP(statut='f',typ='I')
        _Keywords['CRITERE']        = SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") )
        if _meca :
            _Keywords['NOM_CHAM'] = SIMP(statut='o',typ='TXM',validators=NoRepeat(),max=1,
                                   into=("CONT_NOEU","FORC_NODA",
                                         "DEPL","VITE","ACCE",
                                         "SIEF_ELGA","VARI_ELGA","EPSI_ELGA",
                                         "DEPL_ABSOLU","VITE_ABSOLU","ACCE_ABSOLU",))
        if _ther :
            _Keywords['NOM_CHAM'] = SIMP(statut='o',typ='TXM',validators=NoRepeat(),max=1,
                                   into=("TEMP",))

        mcfact = FACT(statut='f', max=99,

            b_formule       =BLOC(condition="(EVAL_CMP=='FORMULE')",
                                   FORMULE = SIMP(statut='o',typ=formule,max=1),),

            b_cham_no       =BLOC(condition="(NOM_CHAM=='DEPL') or \
                                        (NOM_CHAM=='VITE') or \
                                        (NOM_CHAM=='ACCE') or \
                                        (NOM_CHAM=='TEMP') or \
                                        (NOM_CHAM=='FORC_NODA') or \
                                        (NOM_CHAM=='CONT_NOEU') or \
                                        (NOM_CHAM=='DEPL_ABSOLU') or \
                                        (NOM_CHAM=='VITE_ABSOLU') or \
                                        (NOM_CHAM=='ACCE_ABSOLU')",
                             regles   =(UN_PARMI('NOEUD','GROUP_NO','GROUP_MA','MAILLE','TOUT')),
                             **_BlocNode
                            ),

            b_cham_elga     =BLOC(condition="(NOM_CHAM=='SIEF_ELGA') or \
                                        (NOM_CHAM=='EPSI_ELGA') or \
                                        (NOM_CHAM=='VARI_ELGA')",
                             regles          =(UN_PARMI('GROUP_MA','MAILLE','TOUT')), 
                                 b_elga_vale     =BLOC(condition="(EVAL_ELGA=='VALE')",
                                   POINT           =SIMP(statut='o',typ='I'  ,validators=NoRepeat(),max='**'),
                                   SOUS_POINT      =SIMP(statut='f',typ='I'  ,validators=NoRepeat(),max='**'),
                                 ),
                             **_BlocElem
                                ),
            b_prec_rela=BLOC(condition="(CRITERE=='RELATIF')",
                             PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
            b_prec_abso=BLOC(condition="(CRITERE=='ABSOLU')",
                             PRECISION       =SIMP(statut='o',typ='R',),),
            **_Keywords
            )

        return mcfact
