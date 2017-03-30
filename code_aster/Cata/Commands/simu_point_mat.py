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
# person_in_charge: david.haboussa at edf.fr


SIMU_POINT_MAT=MACRO(nom="SIMU_POINT_MAT",
                     op=OPS('Macro.simu_point_mat_ops.simu_point_mat_ops'),
                     sd_prod=table_sdaster,
                     UIinfo={"groupes":("Résolution",)},
                     fr=tr("Calcul de l'évolution mécanique, en quasi-statique, "
                          "d'un point matériel en non linéaire"),

   COMPORTEMENT       =C_COMPORTEMENT(),

   MATER           =SIMP(statut='o',typ=mater_sdaster,max=30),

# --MASSIF : orientation du materiau (monocristal, orthotropie)
   MASSIF          =FACT(statut='f',
     regles=(UN_PARMI('ANGL_REP','ANGL_EULER'),),
     ANGL_REP        =SIMP(statut='f',typ='R',min=1,max=3),
     ANGL_EULER      =SIMP(statut='f',typ='R',min=1,max=3),
   ),

   INCREMENT       =C_INCREMENT('MECANIQUE'),

   NEWTON          =C_NEWTON(),

   CONVERGENCE     =C_CONVERGENCE('SIMU_POINT_MAT'),

   SUPPORT= SIMP(statut='f',typ='TXM',max=1,into=("POINT","ELEMENT",),defaut=("POINT"),),

   b_PM = BLOC(condition="""equal_to("SUPPORT", 'POINT')""",fr=tr("Simulation sans élément fini"),

          FORMAT_TABLE  =SIMP(statut='f',typ='TXM',max=1,into=("CMP_COLONNE","CMP_LIGNE",),defaut=("CMP_COLONNE"),),

          NB_VARI_TABLE  =SIMP(statut='f',typ='I',max=1,),

          OPER_TANGENT  =SIMP(statut='f',typ='TXM',max=1,into=("OUI","NON",),defaut="NON",),
                ARCHIVAGE    =FACT(statut='f',
                LIST_INST       =SIMP(statut='f',typ=(listr8_sdaster) ),
                INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
                PAS_ARCH        =SIMP(statut='f',typ='I' ),
                PRECISION       =SIMP(statut='f',typ='R',defaut= 1.0E-6),
                                ),


          ## ANGLE : rotation de ANGLE autour de Z uniquement, et seulement pour les déformations imposées. Utile pour tests compxxx
          ANGLE      =SIMP(statut='f',typ='R',max=1, defaut=0.),

          regles = (PRESENT_ABSENT('SIGM_IMPOSE','MATR_C1','MATR_C2','VECT_IMPO'),
                    PRESENT_ABSENT('EPSI_IMPOSE','MATR_C1','MATR_C2','VECT_IMPO'),
                    PRESENT_ABSENT('MATR_C1','SIGM_IMPOSE','EPSI_IMPOSE'),
                    PRESENT_ABSENT('MATR_C2','SIGM_IMPOSE','EPSI_IMPOSE'),
                    PRESENT_ABSENT('VECT_IMPO', 'SIGM_IMPOSE','EPSI_IMPOSE'),
                    EXCLUS('EPSI_IMPOSE','GRAD_IMPOSE'),
                    EXCLUS('SIGM_IMPOSE','GRAD_IMPOSE'),
                    ),

          SIGM_IMPOSE=FACT(statut='f',
                SIXX = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIYY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIZZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIXY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIXZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIYZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                            ),
          EPSI_IMPOSE=FACT(statut='f',
                EPXX = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPYY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPZZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPXY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPXZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPYZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                            ),
          GRAD_IMPOSE=FACT(statut='f',
                regles = ( ENSEMBLE('F11','F12','F13','F21','F22','F23','F31','F32','F33',),),
                F11 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F12 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F13 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F21 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F22 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F23 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F31 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F32 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                F33 = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                            ),
          MATR_C1=FACT(statut='f',max='**',
                VALE          =SIMP(statut='o',typ='R',max=1, ),
                NUME_LIGNE    =SIMP(statut='o',typ='I',max=1,val_min=1,val_max=6 ),
                NUME_COLONNE  =SIMP(statut='o',typ='I',max=1,val_min=1,val_max=12 ),
                                    ),
          MATR_C2=FACT(statut='f',max='**',
                VALE          =SIMP(statut='o',typ='R',max=1, ),
                NUME_LIGNE    =SIMP(statut='o',typ='I',max=1,val_min=1,val_max=6 ),
                NUME_COLONNE  =SIMP(statut='o',typ='I',max=1,val_min=1,val_max=12 ),
                                    ),
          VECT_IMPO=FACT(statut='f',max='**',
                VALE          =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule),max=1, ),
                NUME_LIGNE    =SIMP(statut='o',typ='I',max=1,val_min=1,val_max=6 ),
                                    ),
   ),

   b_EF = BLOC(condition="""equal_to("SUPPORT", 'ELEMENT')""",fr=tr("Simulation sur un élément fini"),
          MODELISATION  =SIMP(statut='f',typ='TXM',max=1,into=("3D","C_PLAN","D_PLAN",)),
          RECH_LINEAIRE   =C_RECH_LINEAIRE(),
          ARCHIVAGE       =C_ARCHIVAGE(),
          SUIVI_DDL       =C_SUIVI_DDL(),



          ## ANGLE : rotation de ANGLE autour de Z uniquement, et seulement pour les déformations imposées. Utile pour tests compxxx
          ANGLE      =SIMP(statut='f',typ='R',max=1, defaut=0.),

          SIGM_IMPOSE=FACT(statut='f',
                SIXX = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIYY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIZZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIXY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIXZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                SIYZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                          ),
          EPSI_IMPOSE=FACT(statut='f',
                EPXX = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPYY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPZZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPXY = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPXZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                EPYZ = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule) ),
                          ),

            ),

   SIGM_INIT=FACT(statut='f',
          SIXX = SIMP(statut='f',typ='R',max=1,defaut=0.0E+0),
          SIYY = SIMP(statut='f',typ='R',max=1,defaut=0.0E+0),
          SIZZ = SIMP(statut='f',typ='R',max=1,defaut=0.0E+0),
          SIXY = SIMP(statut='f',typ='R',max=1,defaut=0.0E+0),
          SIXZ = SIMP(statut='f',typ='R',max=1,defaut=0.0E+0),
          SIYZ = SIMP(statut='f',typ='R',max=1,defaut=0.0E+0),
                     ),
   EPSI_INIT=FACT(statut='f',
          EPXX = SIMP(statut='o',typ='R',max=1),
          EPYY = SIMP(statut='o',typ='R',max=1),
          EPZZ = SIMP(statut='o',typ='R',max=1),
          EPXY = SIMP(statut='o',typ='R',max=1),
          EPXZ = SIMP(statut='o',typ='R',max=1),
          EPYZ = SIMP(statut='o',typ='R',max=1),
                     ),
   VARI_INIT=FACT(statut='f',
          VALE = SIMP(statut='o',typ='R',max='**'),
                     ),

     # on permet certaines variables de commandes scalaires, définies par une fonction du temps
     # a priori toutes doivent fonctionner
      AFFE_VARC    = FACT(statut='f',max='**',
         NOM_VARC        =SIMP(statut='o',typ='TXM', into=("TEMP","CORR","IRRA","HYDR","SECH","M_ACIER","M_ZIRC","EPSA","NEUT1","NEUT2")),
         VALE_FONC   = SIMP(statut='f',typ=(fonction_sdaster,formule) ),

         B_VALE_REF          =BLOC(condition="""is_in("NOM_VARC", ('TEMP', 'SECH'))""",
            VALE_REF         =SIMP(statut='o',typ='R'),
                                  ),

             b_ZIRC = BLOC(condition="""equal_to("NOM_VARC", 'M_ZIRC')""",
              V1   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V2   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V3   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V4   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
                          ),

             b_ACIER = BLOC(condition="""equal_to("NOM_VARC", 'M_ACIER')""",
              V1   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V2   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V3   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V4   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V5   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V6   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
              V7   = SIMP(statut='o',typ=(fonction_sdaster,formule) ),
                          ),
                         ),
        # un mot clé caché qui ne sert qu'à boucler sur les VARC possibles :
      LIST_NOM_VARC =SIMP(statut='c',typ='TXM', defaut=("TEMP","CORR","IRRA","HYDR","SECH","EPSA","M_ACIER","M_ZIRC","NEUT1","NEUT2")),


   INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
)
