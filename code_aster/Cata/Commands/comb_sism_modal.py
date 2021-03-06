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

# person_in_charge: sylvie.audebert at edf.fr

from ..Commons import *
from ..Language.DataStructure import *
from ..Language.Syntax import *

COMB_SISM_MODAL=OPER(nom="COMB_SISM_MODAL",op= 109,sd_prod=mode_meca,
                     fr=tr("Réponse sismique par recombinaison modale par une méthode spectrale"),
                     reentrant='n',
         regles=(EXCLUS('TOUT_ORDRE','NUME_ORDRE','FREQ','NUME_MODE','LIST_FREQ','LIST_ORDRE'),
                 UN_PARMI('AMOR_REDUIT','LIST_AMOR','AMOR_GENE' ),
                 UN_PARMI('MONO_APPUI','MULTI_APPUI' ),),
         MODE_MECA       =SIMP(statut='o',typ=mode_meca),
         TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
         LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster ),
         NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
         FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
         LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster ),
         b_freq          =BLOC(condition = """exists("FREQ") or exists("LIST_FREQ")""",
           PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-3 ),
           CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU") ),
         ),
         MODE_CORR       =SIMP(statut='f',typ=mode_meca ),
         FREQ_COUP = SIMP(statut='f',typ='R',min=1,max=1),

         AMOR_REDUIT     =SIMP(statut='f',typ='R',max='**'),
         LIST_AMOR       =SIMP(statut='f',typ=listr8_sdaster ),
         AMOR_GENE       =SIMP(statut='f',typ=matr_asse_gene_r ),

         MASS_INER       =SIMP(statut='f',typ=table_sdaster ),
         CORR_FREQ       =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON") ),

         MONO_APPUI      =SIMP(statut='f',typ='TXM',into=("OUI",),
                                 fr=tr("excitation imposée unique") ),
         MULTI_APPUI      =SIMP(statut='f',typ='TXM',into=("DECORRELE","CORRELE"),
                                 fr=tr("excitation imposée unique") ),

         b_mult_appui    =BLOC(condition = """(exists("MULTI_APPUI"))""",
            EXCIT           =FACT(statut='o',max='**',
              regles=(UN_PARMI('AXE','TRI_AXE','TRI_SPEC' ),UN_PARMI('NOEUD','GROUP_NO' ),),
              AXE             =SIMP(statut='f',typ='R',max=3,fr=tr("Excitation suivant un seul axe"),),
              TRI_AXE         =SIMP(statut='f',typ='R',max=3,fr=tr("Excitation suivant les trois axes mais avec le meme spectre"),),
              TRI_SPEC        =SIMP(statut='f',typ='TXM',into=("OUI",), fr=tr("Excitation suivant les trois axes  avec trois spectres")),
              b_axe           =BLOC(condition = """exists("AXE")""",fr=tr("Excitation suivant un seul axe"),
                SPEC_OSCI       =SIMP(statut='o',typ=(nappe_sdaster,formule),),
                ECHELLE         =SIMP(statut='f',typ='R',),
              ),
              b_tri_axe       =BLOC(condition = """exists("TRI_AXE")""",fr=tr("Excitation suivant les trois axes mais avec le meme spectre"),
                SPEC_OSCI       =SIMP(statut='o',typ=(nappe_sdaster,formule),),
                ECHELLE         =SIMP(statut='f',typ='R',),
              ),
              b_tri_spec      =BLOC(condition = """exists("TRI_SPEC")""",fr=tr("Excitation suivant les trois axes  avec trois spectres"),
                SPEC_OSCI       =SIMP(statut='o',typ=(nappe_sdaster,formule),min=3,max=3 ),
                ECHELLE         =SIMP(statut='f',typ='R',min=3,max=3),
              ),
              NATURE          =SIMP(statut='f',typ='TXM',defaut="ACCE",into=("ACCE","VITE","DEPL") ),
              NOEUD           =SIMP(statut='c',typ=no  ,validators=NoRepeat(),max='**'),
              GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
            ), # fin mcf_excit
         ), # fin b_mult_appui
         b_not_mult_appui    =BLOC(condition = """(not exists("MULTI_APPUI"))""",
            EXCIT           =FACT(statut='o',max='**',
              regles=(UN_PARMI('AXE','TRI_AXE','TRI_SPEC' ),),
              AXE             =SIMP(statut='f',typ='R',max=3,fr=tr("Excitation suivant un seul axe"),),
              TRI_AXE         =SIMP(statut='f',typ='R',max=3,fr=tr("Excitation suivant les trois axes mais avec le meme spectre"),),
              TRI_SPEC        =SIMP(statut='f',typ='TXM',into=("OUI",), fr=tr("Excitation suivant les trois axes  avec trois spectres")),
              b_axe           =BLOC(condition = """exists("AXE")""",fr=tr("Excitation suivant un seul axe"),
                SPEC_OSCI       =SIMP(statut='o',typ=(nappe_sdaster,formule),),
                ECHELLE         =SIMP(statut='f',typ='R',),
              ),
              b_tri_axe       =BLOC(condition = """exists("TRI_AXE")""",fr=tr("Excitation suivant les trois axes mais avec le meme spectre"),
                SPEC_OSCI       =SIMP(statut='o',typ=(nappe_sdaster,formule),),
                ECHELLE         =SIMP(statut='f',typ='R',),
              ),
              b_tri_spec      =BLOC(condition = """exists("TRI_SPEC")""",fr=tr("Excitation suivant les trois axes  avec trois spectres"),
                SPEC_OSCI       =SIMP(statut='o',typ=(nappe_sdaster,formule),min=3,max=3 ),
                ECHELLE         =SIMP(statut='f',typ='R',min=3,max=3),
              ),
              NATURE          =SIMP(statut='f',typ='TXM',defaut="ACCE",into=("ACCE","VITE","DEPL") ),
            ), # fin mcf_excit
         ), # fin b_not_mult_appui

         b_decorrele     =BLOC(condition = """equal_to("MULTI_APPUI", 'DECORRELE') """,
           GROUP_APPUI     =FACT(statut='f',max='**',
           regles=(UN_PARMI('NOEUD','GROUP_NO' ),),
           NOEUD           =SIMP(statut='c',typ=no  ,validators=NoRepeat(),max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),),

         ),
         b_correle =BLOC(condition = """equal_to("MULTI_APPUI", 'CORRELE') """,
           COMB_MULT_APPUI =FACT(statut='f',max='**',
           regles=(UN_PARMI('TOUT','NOEUD','GROUP_NO' ),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           NOEUD           =SIMP(statut='c',typ=no  ,validators=NoRepeat(),max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           TYPE_COMBI      =SIMP(statut='f',typ='TXM',into=("QUAD","LINE",) ),),
         ),

         COMB_MODE       =FACT(statut='o',
           TYPE            =SIMP(statut='o',typ='TXM',into=("SRSS","CQC","DSC","ABS","DPC","GUPTA") ),
           DUREE           =SIMP(statut='f',typ='R' ),
         b_gupta =BLOC(condition = """equal_to("TYPE", 'GUPTA') """,
           FREQ_1      =SIMP(statut='o',typ='R',),
           FREQ_2      =SIMP(statut='o',typ='R',),
         ),
         ),
         COMB_DIRECTION  =FACT(statut='f',
           TYPE            =SIMP(statut='f',typ='TXM',into=("QUAD","NEWMARK") ),
         ),
         COMB_DEPL_APPUI=FACT(statut='f',max='**',
           regles=(UN_PARMI('TOUT','LIST_CAS'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",)),
           LIST_CAS       =SIMP(statut='f',typ='I',max='**'),
           TYPE_COMBI      =SIMP(statut='f',typ='TXM',into=("QUAD","LINE","ABS") ),
         ),
         DEPL_MULT_APPUI =FACT(statut='f',max='**',
           regles=(UN_PARMI('NOEUD','GROUP_NO'),EXCLUS('NOEUD_REFE','GROUP_NO_REFE'),
                   AU_MOINS_UN('DX','DY','DZ' ),),
           NOM_CAS         =SIMP(statut='o',typ='TXM',max='**'),
           NUME_CAS        =SIMP(statut='o',typ='I',max='**'),
           MODE_STAT       =SIMP(statut='o',typ=mode_meca, ),
           NOEUD_REFE      =SIMP(statut='c',typ=no,max=1),
           GROUP_NO_REFE   =SIMP(statut='f',typ=grno,max=1),
           NOEUD           =SIMP(statut='c',typ=no  ,validators=NoRepeat(),max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           DX              =SIMP(statut='f',typ='R' ),
           DY              =SIMP(statut='f',typ='R' ),
           DZ              =SIMP(statut='f',typ='R' ),
         ),
         OPTION          =SIMP(statut='o',typ='TXM',validators=NoRepeat(),max=9,
                               into=("DEPL","VITE","ACCE_ABSOLU","SIGM_ELNO","SIEF_ELGA",
                                     "EFGE_ELNO","REAC_NODA","FORC_NODA","SIEF_ELNO",
                                     "SIPO_ELNO") ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2 ) ),
         IMPRESSION      =FACT(statut='f',max='**',
           regles=(EXCLUS('TOUT','NIVEAU'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           NIVEAU          =SIMP(statut='f',typ='TXM',into=("SPEC_OSCI","MASS_EFFE","MAXI_GENE"),validators=NoRepeat(),max=3 ),
         ),
         TITRE           =SIMP(statut='f',typ='TXM'),
)  ;
