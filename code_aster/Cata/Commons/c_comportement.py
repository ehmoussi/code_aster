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
# person_in_charge: david.haboussa at edf.fr
def C_COMPORTEMENT(COMMAND=None) :  #COMMUN#

    assert COMMAND in ('MACR_ASCOUF_CALC','MACR_ASPIC_CALC','CALC_G','POST_GP','CALC_ESSAI_GEOMECA','CALC_EUROPLEXUS',
                       'CALC_POINT_MAT','SIMU_POINT_MAT', 'DYNA_NON_LINE','STAT_NON_LINE','CALCUL','CALC_FORC_NONL',
                       'CALC_IFS_DNL','CALC_PRECONT','CREA_RESU','LIRE_RESU','MACR_ECREVISSE','TEST_COMPOR',None)

    if COMMAND =='CALC_EUROPLEXUS':
        mcfact = FACT(statut='o',min=1,max='**',  #COMMUN#

           RELATION  = SIMP( statut='o',typ='TXM',defaut="ELAS",into=('ELAS',
                                                                      'GLRC_DAMAGE',
                                                                      'VMIS_ISOT_TRAC',
                                                                      'VMIS_JOHN_COOK',
                                                                      'BPEL_FROT')),
           GROUP_MA  = SIMP(statut='o',typ=grma,validators=NoRepeat(),max='**'),
        )
    elif COMMAND == 'CREA_RESU' or COMMAND == 'LIRE_RESU' or COMMAND == 'CALC_FORC_NONL':
        mcfact = FACT(statut='f',min=1,max='**',

           regles=(PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),

           RELATION  =SIMP( statut='o',typ='TXM',defaut="ELAS",into=C_RELATION(COMMAND)),
           b_monox     = BLOC(condition = "RELATION == 'MONOCRISTAL' ",
                                 fr=tr("SD issue de DEFI_COMPOR"),
                   COMPOR =SIMP(statut='o',typ=compor_sdaster,max=1),),
           b_polyx     = BLOC(condition = "RELATION == 'POLYCRISTAL' ",
                                 fr=tr("SD issue de DEFI_COMPOR"),
                   COMPOR =SIMP(statut='o',typ=compor_sdaster,max=1),),
           b_umat      = BLOC(condition = "RELATION == 'UMAT' ",
                                 fr=tr("Comportement utilisateur de type UMAT"),
                   NB_VARI =SIMP(statut='o',typ='I',max=1,fr=tr("Nombre de variables internes")),
                   LIBRAIRIE = SIMP(statut='o', typ='TXM',validators=LongStr(1,128),
                        fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement UMAT")),
                   NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                        fr=tr("Nom de la routine UMAT dans la bibliothèque")),),
           b_mfront      = BLOC(condition = "RELATION == 'MFRONT' ",
                                 fr=tr("Comportement utilisateur de type MFRONT"),
                   LIBRAIRIE = SIMP(statut='o', typ='TXM',validators=LongStr(1,128),
                        fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement MFRONT")),
                   NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                        fr=tr("Nom de la routine MFRONT dans la bibliothèque")),
                   VERI_BORNE = SIMP(statut='f', typ='TXM',
                                     defaut="ARRET",into=('ARRET','SANS','MESSAGE'),
                        fr=tr("Vérification des bornes physiques de la loi de comportement MFRONT"),),),

# KITs
           b_kit_ddi = BLOC(condition = "RELATION == 'KIT_DDI' ",
                            fr=tr("relations de couplage fluage-plasticite"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,validators=NoRepeat(),
                                 into=(
                                       "VMIS_CINE_LINE",
                                       "VMIS_ISOT_TRAC",
                                       "VMIS_ISOT_LINE",
                                       "VMIS_ISOT_PUIS",
                                       "GLRC_DM",
                                       "GRANGER_FP",
                                       "GRANGER_FP_INDT",
                                       "GRANGER_FP_V",
                                       "BETON_UMLV_FP",
                                       "ROUSS_PR",
                                       "BETON_DOUBLE_DP",
                                       "ENDO_ISOT_BETON",
                                       "MAZARS",
                                       "ENDO_PORO_BETON",
                                       "FLUA_PORO_BETON"
                                       ),),
                   ),
           b_kit_cg= BLOC(condition = "RELATION == 'KIT_CG' ",
                            fr=tr("relations pour elements cables gaines"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,validators=NoRepeat(),
                                 into=(
                                       "CABLE_GAINE_FROT",
                                       "VMIS_ISOT_LINE",
                                       "VMIS_ISOT_TRAC",
                                       "VMIS_CINE_LINE",
                                       "PINTO_MENEGOTTO",
                                       "ELAS",
                                       "SANS"
                                       ),),
                   ),

           b_kit_thm = BLOC(condition = "RELATION in ['KIT_HHM','KIT_HH','KIT_H','KIT_HM','KIT_THHM', \
                                                      'KIT_THH','KIT_THM','KIT_THV']",
                            fr=tr("lois de comportements thermo-hydro-mecaniques"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',max=9,validators=NoRepeat(),
                                 into=(
# MECA
                                       "ELAS",
                                       "CJS",
                                       "HUJEUX",
                                       "MOHR_COULOMB",
                                       "CAM_CLAY",
                                       "BARCELONE",
                                       "LAIGLE",
                                       "LETK",
                                       "DRUCK_PRAGER",
                                       "DRUCK_PRAG_N_A",
                                       "VISC_DRUC_PRAG",
                                       "ELAS_GONF",
                                       "HOEK_BROWN_EFF",
                                       "HOEK_BROWN_TOT",
                                       "MAZARS",
                                       "ENDO_ISOT_BETON",
                                       "JOINT_BANDIS",
                                       "CZM_LIN_REG",
                                       "CZM_EXP_REG",
                                       "MFRONT",

# THMC
                                       "GAZ",
                                       "LIQU_SATU",
                                       "LIQU_GAZ_ATM",
                                       "LIQU_VAPE_GAZ",
                                       "LIQU_AD_GAZ_VAPE",
                                       "LIQU_AD_GAZ",
                                       "LIQU_VAPE",
                                       "LIQU_GAZ",
# HYDR
                                       "HYDR_UTIL",
                                       "HYDR_VGM",
                                       "HYDR_VGC",
                                       "HYDR_ENDO",
                                       ),),

 # mfront pour la loi meca de THM
           b_mfront_thm = BLOC(condition = "'MFRONT' in RELATION_KIT",fr=tr("Comportement utilisateur meca THM de type MFRONT"),
                                          LIBRAIRIE = SIMP(statut='o', typ='TXM',
                                                           fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement MFRONT")),
                                          NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                                                           fr=tr("Nom de la routine MFRONT dans la bibliothèque")),
                                          VERI_BORNE = SIMP(statut='f', typ='TXM',
                                                            defaut="ARRET",into=('ARRET','SANS','MESSAGE'),
                                                           fr=tr("Vérification des bornes physiques de la loi de comportement MFRONT"),)
                                      ),

                                       ),

           b_kit_meta = BLOC(condition = "RELATION in ('META_LEMA_ANI','META_P_CL_PT_RE','META_P_CL_PT','META_P_CL_RE','META_P_CL',\
           'META_P_IL_PT_RE','META_P_IL_PT','META_P_IL_RE','META_P_IL','META_P_INL_PT_RE','META_P_INL_PT','META_P_INL_RE','META_P_INL',\
           'META_V_CL_PT_RE','META_V_CL_PT','META_V_CL_RE','META_V_CL','META_V_IL_PT_RE','META_V_IL_PT','META_V_IL_RE','META_V_IL',\
           'META_V_INL_PT_RE','META_V_INL_PT','META_V_INL_RE','META_V_INL')",
                            fr=tr("nombre de phases metallurgiques"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',max=1,validators=NoRepeat(),
                                 into=("ACIER","ZIRC"),),
                                 ),

           DEFORMATION       =SIMP(statut='f',typ='TXM',defaut="PETIT",
                                   into=("PETIT","PETIT_REAC","GROT_GDEP","SIMO_MIEHE","GDEF_HYPO_ELAS","GDEF_LOG")),



           # gestion des contraintes planes par la méthode itérative
            RESI_CPLAN_MAXI    =SIMP(statut='f',typ='R',
                                  fr=tr("Critère d'arret absolu pour assurer la condition de contraintes planes")),

            b_resi_cplan  =BLOC(condition = " RESI_CPLAN_MAXI == None ",
                                RESI_CPLAN_RELA   =SIMP(statut='f',typ='R',defaut= 1.0E-6,
                                fr=tr("Critère d'arret relatif pour assurer la condition de contraintes planes")),
                                ),

            ITER_CPLAN_MAXI =SIMP(statut='f',typ='I',defaut= 1,
                                fr=tr("Nombre d'itérations maxi pour assurer la condition de contraintes planes")),
        )
    else:
        opts = {}
        if COMMAND == 'STAT_NON_LINE' or 'DYNA_NON_LINE':
            opts['b_crirupt'] = BLOC(condition =
                    "RELATION in ('VMIS_ISOT_LINE','VMIS_ISOT_TRAC','VISCOCHAB','VISC_ISOT_LINE','VISC_ISOT_TRAC',)",
                                   fr=tr("Critere de rupture selon une contrainte critique"),
                    POST_ITER    =SIMP(statut='f',typ='TXM',into=("CRIT_RUPT",), ),
                                  )
        if COMMAND == 'STAT_NON_LINE':
            opts['b_anneal'] = BLOC(condition =
                    "RELATION in ('VMIS_ISOT_LINE','VMIS_CINE_LINE','VMIS_ECMI_LINE','VMIS_ISOT_TRAC',)",
                                   fr=tr("Restauration d'écrouissage"),
                    POST_INCR    =SIMP(statut='f',typ='TXM',into=("REST_ECRO",), ),
                                  )
        mcfact = FACT(statut='f',min=1,max='**',

           regles=(PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),

           RELATION  =SIMP( statut='o',typ='TXM',defaut="ELAS",into=C_RELATION(COMMAND)),
           b_monox     = BLOC(condition = "RELATION == 'MONOCRISTAL' ",
                                 fr=tr("SD issue de DEFI_COMPOR"),
                   COMPOR =SIMP(statut='o',typ=compor_sdaster,max=1),),
           b_polyx     = BLOC(condition = "RELATION == 'POLYCRISTAL' ",
                                 fr=tr("SD issue de DEFI_COMPOR"),
                   COMPOR =SIMP(statut='o',typ=compor_sdaster,max=1),),
           b_umat      = BLOC(condition = "RELATION == 'UMAT' ",
                                 fr=tr("Comportement utilisateur de type UMAT"),
                   NB_VARI =SIMP(statut='o',typ='I',max=1,fr=tr("Nombre de variables internes")),
                   LIBRAIRIE = SIMP(statut='o', typ='TXM',validators=LongStr(1,128),
                        fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement UMAT")),
                   NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                        fr=tr("Nom de la routine UMAT dans la bibliothèque")),),
           b_mfront      = BLOC(condition = "RELATION == 'MFRONT' ",
                                 fr=tr("Comportement utilisateur de type MFRONT"),
                   LIBRAIRIE = SIMP(statut='o', typ='TXM',validators=LongStr(1,128),
                        fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement MFRONT")),
                   NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                        fr=tr("Nom de la routine MFRONT dans la bibliothèque")),
                   VERI_BORNE = SIMP(statut='f', typ='TXM',
                                     defaut="ARRET",into=('ARRET','SANS','MESSAGE'),
                        fr=tr("Vérification des bornes physiques de la loi de comportement MFRONT"),)),

# KITs
           b_kit_ddi = BLOC(condition = "RELATION == 'KIT_DDI' ",
                            fr=tr("relations de couplage fluage-plasticite"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,validators=NoRepeat(),
                                 into=(
                                       "VMIS_CINE_LINE",
                                       "VMIS_ISOT_TRAC",
                                       "VMIS_ISOT_LINE",
                                       "VMIS_ISOT_PUIS",
                                       "GLRC_DM",
                                       "GRANGER_FP",
                                       "GRANGER_FP_INDT",
                                       "GRANGER_FP_V",
                                       "BETON_UMLV_FP",
                                       "ROUSS_PR",
                                       "BETON_DOUBLE_DP",
                                       "ENDO_ISOT_BETON",
                                       "MAZARS",
                                       "ENDO_PORO_BETON",
                                       "FLUA_PORO_BETON"
                                       ),),
                   ),
           b_kit_cg= BLOC(condition = "RELATION == 'KIT_CG' ",
                            fr=tr("relations pour elements cables gaines"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,validators=NoRepeat(),
                                 into=(
                                       "CABLE_GAINE_FROT",
                                       "VMIS_ISOT_LINE",
                                       "VMIS_ISOT_TRAC",
                                       "VMIS_CINE_LINE",
                                       "PINTO_MENEGOTTO",
                                       "ELAS",
                                       "SANS"
                                       ),),
                   ),

           b_kit_thm = BLOC(condition = "RELATION in ['KIT_HHM','KIT_HH','KIT_H','KIT_HM','KIT_THHM', \
                                                      'KIT_THH','KIT_THM','KIT_THV']",
                            fr=tr("lois de comportements thermo-hydro-mecaniques"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',max=9,validators=NoRepeat(),
                                 into=(
# MECA
                                       "ELAS",
                                       "CJS",
                                       "HUJEUX",
                                       "MOHR_COULOMB",
                                       "CAM_CLAY",
                                       "BARCELONE",
                                       "LAIGLE",
                                       "LETK",
                                       "DRUCK_PRAGER",
                                       "DRUCK_PRAG_N_A",
                                       "VISC_DRUC_PRAG",
                                       "ELAS_GONF",
                                       "HOEK_BROWN_EFF",
                                       "HOEK_BROWN_TOT",
                                       "MAZARS",
                                       "ENDO_ISOT_BETON",
                                       "JOINT_BANDIS",
                                       "CZM_LIN_REG",
                                       "CZM_EXP_REG",
                                       "MFRONT",

# THMC
                                       "GAZ",
                                       "LIQU_SATU",
                                       "LIQU_GAZ_ATM",
                                       "LIQU_VAPE_GAZ",
                                       "LIQU_AD_GAZ_VAPE",
                                       "LIQU_AD_GAZ",
                                       "LIQU_VAPE",
                                       "LIQU_GAZ",
# HYDR
                                       "HYDR_UTIL",
                                       "HYDR_VGM",
                                       "HYDR_VGC",
                                       "HYDR_ENDO",
                                       ),),

 # mfront pour la loi meca de THM
           b_mfront_thm = BLOC(condition = "'MFRONT' in RELATION_KIT",fr=tr("Comportement utilisateur meca THM de type MFRONT"),
                                          LIBRAIRIE = SIMP(statut='o', typ='TXM',
                                                           fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement MFRONT")),
                                          NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                                                           fr=tr("Nom de la routine MFRONT dans la bibliothèque")),
                                          VERI_BORNE = SIMP(statut='f', typ='TXM',
                                                            defaut="ARRET",into=('ARRET','SANS','MESSAGE'),
                                               fr=tr("Vérification des bornes physiques de la loi de comportement MFRONT"),)
                                      ),

                                       ),

           b_kit_meta = BLOC(condition = "RELATION in ('META_LEMA_ANI','META_P_CL_PT_RE','META_P_CL_PT','META_P_CL_RE','META_P_CL',\
           'META_P_IL_PT_RE','META_P_IL_PT','META_P_IL_RE','META_P_IL','META_P_INL_PT_RE','META_P_INL_PT','META_P_INL_RE','META_P_INL',\
           'META_V_CL_PT_RE','META_V_CL_PT','META_V_CL_RE','META_V_CL','META_V_IL_PT_RE','META_V_IL_PT','META_V_IL_RE','META_V_IL',\
           'META_V_INL_PT_RE','META_V_INL_PT','META_V_INL_RE','META_V_INL')",
                            fr=tr("nombre de phases metallurgiques"),
               RELATION_KIT    =SIMP(statut='o',typ='TXM',max=1,validators=NoRepeat(),
                                 into=("ACIER","ZIRC"),),
                                 ),

           DEFORMATION       =SIMP(statut='f',typ='TXM',defaut="PETIT",
                                   into=("PETIT","PETIT_REAC","GROT_GDEP","SIMO_MIEHE","GDEF_HYPO_ELAS","GDEF_LOG")),



           # gestion des contraintes planes par la méthode itérative
            RESI_CPLAN_MAXI    =SIMP(statut='f',typ='R',
                                  fr=tr("Critère d'arret absolu pour assurer la condition de contraintes planes")),

            b_resi_cplan  =BLOC(condition = " RESI_CPLAN_MAXI == None ",
                                RESI_CPLAN_RELA   =SIMP(statut='f',typ='R',defaut= 1.0E-6,
                                fr=tr("Critère d'arret relatif pour assurer la condition de contraintes planes")),
                                ),

            ITER_CPLAN_MAXI =SIMP(statut='f',typ='I',defaut= 1,
                                fr=tr("Nombre d'itérations maxi pour assurer la condition de contraintes planes")),



            # Parametres d'integration

                b_mfront_resi      = BLOC(condition = "RELATION =='MFRONT'",
                    RESI_INTE_MAXI    =SIMP(statut='f',typ='R',defaut= 1.0E-8),
                    ITER_INTE_MAXI    =SIMP(statut='f',typ='I',defaut= 100 ),
                ),

                b_no_mfront      = BLOC(condition = "RELATION !='MFRONT'",
                    RESI_INTE_RELA    =SIMP(statut='f',typ='R',defaut= 1.0E-6),
                    ITER_INTE_MAXI    =SIMP(statut='f',typ='I',defaut= 20 ),
                ),

                b_redec_local      = BLOC(condition = "DEFORMATION in ('PETIT','PETIT_REAC','GROT_GDEP')",
                                     fr=tr("Nombre de redécoupages internes du pas de temps"),
                                    ITER_INTE_PAS   =SIMP(statut='f',typ='I',defaut= 0 ),
                                     ),

                ALGO_INTE         =SIMP(statut='f',typ='TXM',into=("ANALYTIQUE", "SECANTE", "DEKKER", "NEWTON_1D","BRENT",
                                                              "NEWTON", "NEWTON_RELI", "NEWTON_PERT", "RUNGE_KUTTA",
                                                              "SPECIFIQUE", "SANS_OBJET")),

                TYPE_MATR_TANG    =SIMP(statut='f',typ='TXM',into=("PERTURBATION","VERIFICATION","TANGENTE_SECANTE")),

                b_perturb         =BLOC(condition = " (TYPE_MATR_TANG != None) and (TYPE_MATR_TANG != 'TANGENTE_SECANTE') ",
                                   fr=tr("Calcul de la matrice tangente par perturbation, valeur de la perturbation"),
                    VALE_PERT_RELA  =SIMP(statut='f',typ='R',defaut= 1.0E-5),
                                  ),

                b_tangsec        = BLOC(condition = " TYPE_MATR_TANG == 'TANGENTE_SECANTE' ",
                                   fr=tr("Modification evolutive de la matrice tangente/secante"),
                    SEUIL        =SIMP(statut='f',typ='R',defaut= 3. ),
                    AMPLITUDE    =SIMP(statut='f',typ='R',defaut= 1.5 ),
                    TAUX_RETOUR  =SIMP(statut='f',typ='R',defaut= 0.05 ),
                                  ),


                PARM_THETA      =SIMP(statut='f',typ='R',val_min=0.,val_max=1., defaut= 1.),
                PARM_ALPHA      =SIMP(statut='f',typ='R',defaut= 1. ),

                b_radi          =BLOC(condition = "TYPE_MATR_TANG == None", RESI_RADI_RELA  =SIMP(statut='f',typ='R', ),),

                **opts
            )


    return mcfact
