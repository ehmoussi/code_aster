# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 2019 Aether Engineering Solutions - www.aethereng.com
# Copyright (C) 2019 Kobe Innovation Engineering - www.kobe-ie.com
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
# aslint: disable=W4004

from ..Language.Syntax import *
from ..Language.DataStructure import *
from ..Commons import *

def gc_open_prod(self,TABLE,**args) :
    self.type_sdprod(TABLE,table_sdaster)
    return maillage_sdaster

CALC_COUPURE =MACRO(nom='CALC_COUPURE',
                    op=OPS('Macro.calc_coupure_ops.calc_coupure_ops'),
                    sd_prod=table_sdaster,
                    reentrant='n',
                    fr=tr("Extraction des résultantes dans une table sur "
                               "des lignes de coupe définies par deux points et un intervalle"),
                    RESULTAT        =SIMP(statut='o',typ=(evol_elas, mode_meca, mult_elas) ),
                    # UNITE_MAILLAGE: pour rester optionnel dans AsterStudy,
                    # la valeur par défaut est définie dans 'ops'
                    UNITE_MAILLAGE  =SIMP(statut='f',typ=UnitType(), inout='out'),
                    OPERATION       =SIMP(statut='f',typ='TXM',into=("EXTRACTION","RESULTANTE"),defaut="RESULTANTE",),

                    b_extrac        =BLOC(condition = """exists("RESULTAT")""",fr=tr("extraction des résultats"),
                                         regles=(EXCLUS('TOUT_ORDRE','NUME_ORDRE','NUME_MODE','FREQ','LIST_FREQ','NOM_CAS'), ),
                        TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
                        NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                        NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
                        NOM_CAS         =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),
                        FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
                        LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
                        b_freq_reel     =BLOC(condition="""exists("LIST_FREQ")""",
                         CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
                         b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                             PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
                         b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                             PRECISION       =SIMP(statut='o',typ='R',),),
                        )
                    ),

                    LIGN_COUPE     =FACT(statut='o',max='**',
                    INTITULE        =SIMP(statut='f',typ='TXM',),
                    NB_POINTS       =SIMP(statut='o',typ='I',max=1),
                    COOR_ORIG       =SIMP(statut='o',typ='R',min=2,max=3),
                    COOR_EXTR       =SIMP(statut='o',typ='R',min=2,max=3),
                    GROUP_MA        =SIMP(statut='o',typ=grma, max=1),
                    DISTANCE_MAX    =SIMP(statut='f',typ='R', defaut=0.,
                        fr=tr("Si la distance entre un noeud de la ligne de coupe et le maillage coupé "
                        "est > DISTANCE_MAX, ce noeud sera ignoré.")),
                    DISTANCE_ALARME =SIMP(statut='f',typ='R',
                        fr=tr("Si la distance entre un noeud de la ligne de coupe et le maillage coupé "
                        "est > DISTANCE_ALARME, une alarme sera émise.")),
                        ),

                    b_comb          =BLOC(condition = """(is_type("RESULTAT") in (mode_meca,)) and (equal_to("OPERATION", 'RESULTANTE'))""",fr=tr("résultat modale"),
                        COMB_MODE=FACT(statut='o',max='**',regles=(UN_PARMI('AMOR_REDUIT','LIST_AMOR', ),),
                            NOM_CAS         =SIMP(statut='f',typ='TXM',),
                            TYPE             =SIMP(statut='f',typ='TXM',defaut="CQC_SIGNE",into=("CQC_SIGNE",),),
                            SPEC_OSCI        =SIMP(statut='o',typ=(nappe_sdaster),min=3,max=3),
                            ECHELLE          =SIMP(statut='f',typ='R',defaut=(1.0,1.0,1.0),min=3,max=3),
                            MODE_SIGNE       =SIMP(statut='o',typ='I',min=3,max=3),
                            AMOR_REDUIT      =SIMP(statut='f',typ='R',max='**'),
                            LIST_AMOR        =SIMP(statut='f',typ=listr8_sdaster ),
                            ),
                        ),
)
