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

# person_in_charge: serguei.potapov at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def calc_europlexus_prod(self,COURBE=None,**args):
  if args.get('__all__'):
      return ([evol_noli], [None, table_sdaster])

  if COURBE is not None:
      self.type_sdprod(args['TABLE_COURBE'],table_sdaster)
  return evol_noli

CALC_EUROPLEXUS = MACRO(nom="CALC_EUROPLEXUS",
                        op=OPS('Macro.calc_europlexus_ops.calc_europlexus_ops'),
                        sd_prod=calc_europlexus_prod,
                        reentrant='n',
                        fr=tr("Chainage Code_Aster-Europlexus"),
                        regles=(UN_PARMI('ETAT_INIT','MODELE'),
                                UN_PARMI('ETAT_INIT','CHAM_MATER'),
                                EXCLUS('ETAT_INIT','FONC_PARASOL'),
                                AU_MOINS_UN('COMPORTEMENT'),),
        LOGICIEL = SIMP(statut='f', typ='TXM'),
        LANCEMENT = SIMP(statut='f', typ='TXM', defaut='OUI',into=('OUI','NON')),
        VERSION_EUROPLEXUS =  SIMP(statut='f',typ='TXM',defaut="EPX2017",
                        into=("2014", "2015", "2015_DEV", "DEV" , "2016" , "EPX2016p1" , "EPX2017" , "EPXASTER_DEV"),
                        fr=tr("Version d'EUROPLEXUS"),
                        ),

        ETAT_INIT = FACT(statut='f',
           RESULTAT   = SIMP(statut='o', typ=evol_noli),
           CONTRAINTE = SIMP(statut='f', typ='TXM', defaut='NON',into=('OUI','NON')),
           EQUILIBRE  = SIMP(statut='f', typ='TXM', defaut='OUI',into=('OUI','NON')),
           b_niter          =BLOC(condition = """equal_to("CONTRAINTE", 'NON') """,
                                 NITER = SIMP(statut='f',typ='I',defaut=1),
                                 ),
           b_cont          =BLOC(condition = """equal_to("CONTRAINTE", 'OUI') """,
                                 VITESSE    = SIMP(statut='f', typ='TXM', defaut='NON',into=('OUI','NON')),
                                 VARI_INT   = SIMP(statut='f', typ='TXM', defaut='NON',into=('OUI','NON')),
                                 ),
        ),
        MODELE     = SIMP(statut='f',typ=modele_sdaster),
        CARA_ELEM  = SIMP(statut='f',typ=cara_elem),

        FONC_PARASOL = FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('NFKT','NFAT'),),
           NFKT       = SIMP(statut='f',typ=(fonction_sdaster,)),
           NFKR       = SIMP(statut='f',typ=(fonction_sdaster,)),
           NFAT       = SIMP(statut='f',typ=(fonction_sdaster,)),
           NFAR       = SIMP(statut='f',typ=(fonction_sdaster,)),
           GROUP_MA   = SIMP(statut='o',typ=grma,validators=NoRepeat(),max='**'),
           ),


        CHAM_MATER = SIMP(statut='f',typ=cham_mater),
        COMPORTEMENT  =C_COMPORTEMENT('CALC_EUROPLEXUS'),

        EXCIT      = FACT(statut='o',max='**',
           CHARGE         = SIMP(statut='o',typ=(char_meca,)),
           FONC_MULT      = SIMP(statut='f',typ=(fonction_sdaster,)),
          ),

        CALCUL = FACT(statut='o',max=1,
           TYPE_DISCRETISATION  = SIMP(statut='f',typ='TXM',defaut='AUTO',into=('AUTO','UTIL')),
           INST_FIN             = SIMP(statut='o',typ='R'),
           INST_INIT            = SIMP(statut='o',typ='R'),
           NMAX                 = SIMP(statut='f',typ='R'),

           b_auto =BLOC( condition = """equal_to("TYPE_DISCRETISATION", 'AUTO')""",
              CSTAB  = SIMP(statut='f',typ='R',defaut=0.3),
#              DTMAX  = SIMP(statut='f',typ='R'),
                       ),

           b_util =BLOC( condition = """equal_to("TYPE_DISCRETISATION", 'UTIL')""",
              PASFIX   = SIMP(statut='o',typ='R'),
                       ),
           ),

        AMORTISSEMENT = FACT(statut='f',max=1,regles=( ENSEMBLE('INST_DEB_AMOR','INST_FIN_AMOR',),
                                     ),
                TYPE_AMOR  = SIMP(statut='f',typ='TXM',defaut='QUASI_STATIQUE',into=('QUASI_STATIQUE', )),
                FREQUENCE  = SIMP(statut='o',typ='R'),
                COEF_AMOR  = SIMP(statut='o',typ='R'),
                INST_DEB_AMOR  = SIMP(statut='f',typ='R'),
                INST_FIN_AMOR  = SIMP(statut='f',typ='R'),
           ),

        OBSERVATION     =FACT(statut='f',max=1,
                            regles=( AU_MOINS_UN('PAS_NBRE','PAS_INST','INST','NUME_ORDRE'),
                                     AU_MOINS_UN('GROUP_NO','TOUT_GROUP_NO','GROUP_MA','TOUT_GROUP_MA',),
                                        EXCLUS('GROUP_NO','TOUT_GROUP_NO',),
                                        EXCLUS('GROUP_MA','TOUT_GROUP_MA',), ),
           NOM_CHAM        = SIMP(statut='f',typ='TXM',validators=NoRepeat(),min=1, max='**',defaut=('DEPL',),into=('DEPL'
                                         ,'VITE','ACCE','SIEF_ELGA','EPSI_ELGA','VARI_ELGA'),),
           PAS_INST        = SIMP(statut='f',typ='R'),
           PAS_NBRE        = SIMP(statut='f',typ='I'),
           INST            = SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
           NUME_ORDRE      = SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
           GROUP_NO        = SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           GROUP_MA        = SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           TOUT_GROUP_NO   = SIMP(statut='f',typ='TXM',into=('OUI',),),
           TOUT_GROUP_MA   = SIMP(statut='f',typ='TXM',into=('OUI',),),
        ),


        ARCHIVAGE        =FACT(statut='o', regles=( AU_MOINS_UN('PAS_NBRE','PAS_INST','INST','NUME_ORDRE'),),
           PAS_INST     = SIMP(statut='f',typ='R'),
           PAS_NBRE     = SIMP(statut='f',typ='I'),
           INST         = SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
           NUME_ORDRE   = SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                             ),
        COURBE  =  FACT(statut='f',max='**', regles=(UN_PARMI('GROUP_NO','GROUP_MA')),
            NOM_CHAM   = SIMP(statut='o',typ='TXM', into=('DEPL','VITE','ACCE','SIEF_ELGA','EPSI_ELGA','VARI_ELGA')),
            NOM_CMP    = SIMP(statut='o',typ='TXM'),
            GROUP_NO   = SIMP(statut='f',typ=grno,max=1),
            GROUP_MA   = SIMP(statut='f',typ=grma,max=1),
            NOM_COURBE = SIMP(statut='o',typ='TXM'),

            b_maille = BLOC(condition = """exists("GROUP_MA")""", regles=(AU_MOINS_UN('NUM_GAUSS')),
              NUM_GAUSS = SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),),
         ),
        b_courbe = BLOC(condition = """exists("COURBE")""",
                        regles=(AU_MOINS_UN('PAS_NBRE_COURBE','PAS_INST_COURBE','INST_COURBE','NUME_ORDRE_COURBE'),
                                AU_MOINS_UN('TABLE_COURBE',)),
          PAS_INST_COURBE      = SIMP(statut='f',typ='R'),
          PAS_NBRE_COURBE      = SIMP(statut='f',typ='I'),
          INST_COURBE          = SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
          NUME_ORDRE_COURBE    = SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                  TABLE_COURBE      = SIMP(statut='f', typ=CO),
          ),
        DOMAINES = FACT(statut='f',max='**',
             GROUP_MA = SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             IDENTIFIANT =  SIMP(statut='f',typ='I'),),
        INTERFACES = FACT(statut='f',max='**',
             GROUP_MA_1 = SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             GROUP_MA_2 = SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
             TOLE        =  SIMP(statut='f',typ='R'),
             IDENT_DOMAINE_1  = SIMP(statut='f',typ='I'),
             IDENT_DOMAINE_2  = SIMP(statut='f',typ='I'),),

         INFO            =SIMP(statut='f',typ='I',defaut=1,into=( 1, 2 ) ),
        ) ;
