# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: sam.cuvilliez at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def calc_essai_geomeca_prod(self, **args):
    for key, fact in args.items():
        if not key.startswith('ESSAI_'):
            continue
        if not fact:
            continue
        for occurrence in fact:
            res = occurrence.get('TABLE_RESU')
            if not res:
                continue
            for table in res:
                self.type_sdprod(table, table_sdaster)
    return None


CALC_ESSAI_GEOMECA = MACRO(nom="CALC_ESSAI_GEOMECA",
                     op=OPS('Macro.calc_essai_geomeca_ops.calc_essai_geomeca_ops'),
                     sd_prod=calc_essai_geomeca_prod,
                     reentrant='n',
                     MATER       = SIMP(statut='o',typ=mater_sdaster),
                     COMPORTEMENT   = C_COMPORTEMENT('CALC_ESSAI_GEOMECA'),
                     CONVERGENCE = C_CONVERGENCE('SIMU_POINT_MAT'),
                     regles=(AU_MOINS_UN('COMPORTEMENT'), # car COMPORTEMENT est facultatif dans C_COMPORTEMENT
                             AU_MOINS_UN(
                                         'ESSAI_TD'    ,
                                         'ESSAI_TND'   ,
                                         'ESSAI_CISA_C',
                                         'ESSAI_TND_C' ,
                                         'ESSAI_TD_A' ,
                                         'ESSAI_TD_NA' ,
                                         'ESSAI_OEDO_C' ,
                                         'ESSAI_ISOT_C' ,
                                         #'ESSAI_XXX'   ,
                                         ),),
                     # ---
                     # Essai Triaxial Monotone Draine ('TD')
                     # ---
                     ESSAI_TD = FACT(statut='f',max='**',

                          PRES_CONF   = SIMP(statut='o',typ='R',max='**',),
                          EPSI_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          NB_INST     = SIMP(statut='f',typ='I',val_min=100,defaut=100),
                          KZERO      = SIMP(statut='f',typ='R',defaut=1.,),

                          TABLE_RESU  = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE   = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('P-Q','EPS_AXI-Q','EPS_AXI-EPS_VOL','P-EPS_VOL',),
                                             defaut=('P-Q','EPS_AXI-Q','EPS_AXI-EPS_VOL','P-EPS_VOL',),),
                          TABLE_REF   = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),

                     # ---
                     #  Essai Triaxial Monotone Non Draine ('TND')
                     # ---
                     ESSAI_TND = FACT(statut='f',max='**',

                          PRES_CONF   = SIMP(statut='o',typ='R',max='**',),
                          EPSI_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          BIOT_COEF   = SIMP(statut='f',typ='R',defaut=1.,),
                          KZERO      = SIMP(statut='f',typ='R',defaut=1.,),
                          NB_INST     = SIMP(statut='f',typ='I',val_min=100,defaut=100),

                          TABLE_RESU  = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE   = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('P-Q','EPS_AXI-Q','EPS_AXI-PRE_EAU',),
                                             defaut=('P-Q','EPS_AXI-Q','EPS_AXI-PRE_EAU',),),
                          TABLE_REF   = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),

                     # ---
                     #  Essai de Cisaillement Cyclique Draine ('CISA_C')
                     # ---
                     ESSAI_CISA_C = FACT(statut='f',max='**',

                          PRES_CONF    = SIMP(statut='o',typ='R',max='**',),
                          GAMMA_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          GAMMA_ELAS   = SIMP(statut='f',typ='R',defaut=1.E-7,val_max=1.E-7),
                          NB_CYCLE     = SIMP(statut='o',typ='I',val_min=1),
                          KZERO        = SIMP(statut='f',typ='R',defaut=1.,),
                          NB_INST      = SIMP(statut='f',typ='I',val_min=25,defaut=25),

                          TABLE_RESU   = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE    = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('GAMMA-SIGXY','GAMMA-G','GAMMA-D','G-D',),
                                             defaut=('GAMMA-SIGXY','GAMMA-G','GAMMA-D','G-D',),),
                          TABLE_REF    = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),

                     # ---
                     #  Essai Triaxial Non Draine Cyclique ('TND_C')
                     # ---
                     ESSAI_TND_C = FACT(statut='f',max='**',

                          PRES_CONF   = SIMP(statut='o',typ='R',max='**',),
                          SIGM_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          BIOT_COEF   = SIMP(statut='f',typ='R',defaut=1.,),
                          KZERO      = SIMP(statut='f',typ='R',defaut=1.,),
                          UN_SUR_K    = SIMP(statut='o',typ='R',),
                          RU_MAX      = SIMP(statut='f',typ='R',defaut=0.8,),
                          NB_CYCLE    = SIMP(statut='o',typ='I',val_min=1),
                          NB_INST     = SIMP(statut='f',typ='I',val_min=25,defaut=25),

                          TABLE_RESU  = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE   = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('NCYCL-DSIGM','P-Q','SIG_AXI-PRE_EAU','EPS_AXI-PRE_EAU','EPS_AXI-Q',),
                                             defaut=('NCYCL-DSIGM','P-Q','SIG_AXI-PRE_EAU','EPS_AXI-PRE_EAU','EPS_AXI-Q',),),
                          TABLE_REF   = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),

                     # ---
                     # Essai Triaxial Draine Cylique Alterné ('TD_A')
                     # ---
                     ESSAI_TD_A = FACT(statut='f',max='**',

                          PRES_CONF   = SIMP(statut='o',typ='R',max='**',),
                          EPSI_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          EPSI_ELAS   = SIMP(statut='f',typ='R',defaut=1.E-7,val_max=1.E-7),
                          NB_INST     = SIMP(statut='f',typ='I',val_min=25,defaut=25),
                          NB_CYCLE    = SIMP(statut='o',typ='I',val_min=1),
                          KZERO       = SIMP(statut='f',typ='R',defaut=1.,),

                          TABLE_RESU  = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE   = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('P-Q','EPS_AXI-Q','EPS_VOL-Q','EPS_AXI-EPS_VOL','P-EPS_VOL','EPSI-E'),
                                             defaut=('P-Q','EPS_AXI-Q','EPS_VOL-Q','EPS_AXI-EPS_VOL','P-EPS_VOL','EPSI-E'),),
                          TABLE_REF   = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),

                     # ---
                     # Essai Triaxial Draine Cylique non Alterné ('TD_NA')
                     # ---
                     ESSAI_TD_NA = FACT(statut='f',max='**',

                          PRES_CONF   = SIMP(statut='o',typ='R',max='**',),
                          EPSI_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          EPSI_ELAS   = SIMP(statut='f',typ='R',defaut=1.E-7,val_max=1.E-7),
                          NB_INST     = SIMP(statut='f',typ='I',val_min=25,defaut=25),
                          NB_CYCLE    = SIMP(statut='o',typ='I',val_min=1),
                          KZERO       = SIMP(statut='f',typ='R',defaut=1.,),

                          TABLE_RESU  = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE   = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('P-Q','EPS_AXI-Q','EPS_VOL-Q','EPS_AXI-EPS_VOL','P-EPS_VOL','EPSI-E'),
                                             defaut=('P-Q','EPS_AXI-Q','EPS_VOL-Q','EPS_AXI-EPS_VOL','P-EPS_VOL','EPSI-E'),),
                          TABLE_REF   = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),

                     # ---
                     #  Essai Oedometrique Draine Cyclique  ('OEDO_C')
                     # ---
                     ESSAI_OEDO_C = FACT(statut='f',max='**',

                          PRES_CONF   = SIMP(statut='o',typ='R',max='**',),
                          SIGM_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          SIGM_DECH   = SIMP(statut='o',typ='R',max='**',),
                          KZERO       = SIMP(statut='f',typ='R',defaut=1.,),
                          NB_INST     = SIMP(statut='f',typ='I',val_min=25,defaut=25),

                          TABLE_RESU  = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE   = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('P-EPS_VOL','SIG_AXI-EPS_VOL'),
                                             defaut=('P-EPS_VOL','SIG_AXI-EPS_VOL'),),
                          TABLE_REF   = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),

                     # ---
                     #  Essai De Comsolidation Isotrope Drainee Cyclique  ('ISOT_C')
                     # ---
                     ESSAI_ISOT_C = FACT(statut='f',max='**',

                          PRES_CONF    = SIMP(statut='o',typ='R',max='**',),
                          SIGM_IMPOSE = SIMP(statut='o',typ='R',max='**',),
                          SIGM_DECH   = SIMP(statut='o',typ='R',max='**',),
                          KZERO      = SIMP(statut='f',typ='R',defaut=1.,),
                          NB_INST     = SIMP(statut='f',typ='I',val_min=25,defaut=25),

                          TABLE_RESU = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                          GRAPHIQUE  = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                                             into=  ('P-EPS_VOL', ),
                                             defaut='P-EPS_VOL',),
                          TABLE_REF  = SIMP(statut='f',typ=table_sdaster,max='**',),

                                      ),



                     # ---
                     #  Essai ... ('XXX')
                     # ---
                     #ESSAI_XXX = FACT(statut='f',max='**',
                     #
                     #     PRES_CONF  = SIMP(statut='o',typ='R',max='**',),
                     #     ...
                     #
                     #     TABLE_RESU = SIMP(statut='f',typ=CO,max='**',validators=NoRepeat(),),
                     #     GRAPHIQUE  = SIMP(statut='f',typ='TXM',max='**',validators=NoRepeat(),
                     #                        into=  ('XXX','XXX','XXX',),
                     #                        defaut=('XXX','XXX','XXX',),),
                     #     TABLE_REF  = SIMP(statut='f',typ=table_sdaster,max='**',),
                     #
                     #                 ),

                    INFO = SIMP(statut='f',typ='I',defaut= 1,into=(1,2) ),)
