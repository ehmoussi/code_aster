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
# person_in_charge: mickael.abbas at edf.fr
#
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import C_RELATION


def C_COMPORTEMENT(COMMAND=None) :  #COMMUN#

    assert COMMAND in ('MACR_ASCOUF_CALC','MACR_ASPIC_CALC','CALC_G','POST_GP','CALC_ESSAI_GEOMECA','CALC_EUROPLEXUS',
                       'CALC_POINT_MAT','SIMU_POINT_MAT', 'DYNA_NON_LINE','STAT_NON_LINE','CALCUL','CALC_FORC_NONL',
                       'CALC_IFS_DNL','CALC_PRECONT','CREA_RESU','LIRE_RESU','MACR_ECREVISSE','TEST_COMPOR',None)

    if COMMAND =='CALC_EUROPLEXUS':
        mcfact = FACT(statut='o',min=1,max='**',  #COMMUN#

           RELATION  = SIMP( statut='f',typ='TXM',defaut="ELAS",into=('ELAS',
                                                                      'GLRC_DAMAGE',
                                                                      'VMIS_ISOT_TRAC',
                                                                      'VMIS_JOHN_COOK',
                                                                      'BPEL_FROT')),
           GROUP_MA  = SIMP(statut='o',typ=grma,validators=NoRepeat(),max='**'),
        )
    elif COMMAND =='CALC_ESSAI_GEOMECA':
        mcfact = FACT(statut='o',min=1,max='**',  #COMMUN#

           RELATION  = SIMP( statut='o',typ='TXM',into=('HUJEUX',
                                                        'DRUCK_PRAGER',
                                                        'DRUCK_PRAG_N_A',
                                                        'CAM_CLAY',
                                                        'CJS',
                                                        'MOHR_COULOMB',
                                                        'Iwan',
                                                        'MFRONT')),
           b_mfront      = BLOC(condition = """equal_to('RELATION', 'MFRONT') """,
                                             fr=tr("Comportement utilisateur de type MFRONT"),
                               regles=(UN_PARMI('UNITE_LIBRAIRIE','LIBRAIRIE')),
                               UNITE_LIBRAIRIE=SIMP(statut='f',typ=UnitType(), inout='in',),
                               LIBRAIRIE = SIMP(statut='f', typ='TXM',validators=LongStr(1,128),
                                    fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement MFRONT")),
                               NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                                    fr=tr("Nom de la routine MFRONT dans la bibliothèque")),
                               VERI_BORNE = SIMP(statut='f', typ='TXM',
                                                 defaut="ARRET",into=('ARRET','SANS','MESSAGE'),
                                    fr=tr("Vérification des bornes physiques de la loi de comportement MFRONT"),)),
           DEFORMATION  =SIMP(statut='f',typ='TXM',defaut="PETIT",
                                               into=("PETIT","GDEF_LOG")),
    # Parametres d'integration

                b_mfront_resi      = BLOC(condition = """equal_to('RELATION', 'MFRONT')""",
                    RESI_INTE_MAXI    =SIMP(statut='f',typ='R',defaut= 1.0E-8),
                    ITER_INTE_MAXI    =SIMP(statut='f',typ='I',defaut= 100 ),
                ),

                b_no_mfront      = BLOC(condition = """not equal_to('RELATION', 'MFRONT')""",
                    RESI_INTE_RELA    =SIMP(statut='f',typ='R',defaut= 1.0E-6),
                    ITER_INTE_MAXI    =SIMP(statut='f',typ='I',defaut= 20 ),
                ),

                b_redec_local      = BLOC(condition = """is_in('DEFORMATION', ('PETIT','PETIT_REAC','GROT_GDEP'))""",
                                     fr=tr("Nombre de redécoupages internes du pas de temps"),
                                    ITER_INTE_PAS   =SIMP(statut='f',typ='I',defaut= 0 ),
                                     ),

                ALGO_INTE         =SIMP(statut='f',typ='TXM',into=("ANALYTIQUE", "SECANTE", "DEKKER", "NEWTON_1D","BRENT",
                                                              "NEWTON", "NEWTON_RELI", "NEWTON_PERT", "RUNGE_KUTTA",
                                                              "SPECIFIQUE", "SANS_OBJET")),

                TYPE_MATR_TANG    =SIMP(statut='f',typ='TXM',into=("PERTURBATION","VERIFICATION",)),

                SYME_MATR_TANG    =SIMP(statut='f',typ='TXM',into=("OUI","NON"), defaut = "OUI"),

                b_perturb         =BLOC(condition = """ (exists("TYPE_MATR_TANG")) """,
                                   fr=tr("Calcul de la matrice tangente par perturbation, valeur de la perturbation"),
                    VALE_PERT_RELA  =SIMP(statut='f',typ='R',defaut= 1.0E-5),
                                  ),

                PARM_THETA      =SIMP(statut='f',typ='R',val_min=0.,val_max=1., defaut= 1.),

                b_radi          =BLOC(condition = """not exists("TYPE_MATR_TANG")""", RESI_RADI_RELA  =SIMP(statut='f',typ='R', ),),

        )
    elif COMMAND == 'CREA_RESU' or COMMAND == 'LIRE_RESU' or COMMAND == 'CALC_FORC_NONL':
        mcfact =   FACT(statut='f',min=1,max='**',
                        regles=(PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),),
            TOUT        = SIMP( statut='f',typ='TXM',into=("OUI",) ),
            GROUP_MA    = SIMP( statut='f',typ=grma,validators=NoRepeat(),max='**'),
            MAILLE      = SIMP( statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
            RELATION    = SIMP( statut='f',typ='TXM',defaut="ELAS",into=C_RELATION(COMMAND)),
            b_monox     = BLOC( condition = """equal_to("RELATION", 'MONOCRISTAL') """,
                                fr=tr("SD issue de DEFI_COMPOR"),
                                COMPOR          = SIMP(statut='o',typ=compor_sdaster,max=1),
                              ),
            b_polyx     = BLOC( condition = """equal_to("RELATION", 'POLYCRISTAL') """,
                                fr=tr("SD issue de DEFI_COMPOR"),
                                COMPOR          = SIMP(statut='o',typ=compor_sdaster,max=1),
                              ),
            b_umat      = BLOC( condition = """equal_to("RELATION", 'UMAT') """,
                                fr=tr("Comportement utilisateur de type UMAT"),
                                NB_VARI         = SIMP(statut='o',typ='I',max=1,
                                fr=tr("Nombre de variables internes")),
                                LIBRAIRIE       = SIMP(statut='o', typ='TXM',validators=LongStr(1,128),
                                fr=tr("Chemin vers la bibliothèque dynamique pour UMAT")),
                                NOM_ROUTINE     = SIMP(statut='o', typ='TXM',
                                fr=tr("Nom de la routine UMAT dans la bibliothèque")),
                              ),
            b_mfront    = BLOC( condition = """equal_to("RELATION", 'MFRONT') """,
                                fr=tr("Comportement utilisateur de type MFRONT"),
                                regles=(UN_PARMI('UNITE_LIBRAIRIE','LIBRAIRIE')),
                                UNITE_LIBRAIRIE=SIMP(statut='f',typ=UnitType(), inout='in',),
                                LIBRAIRIE       = SIMP(statut='f', typ='TXM',validators=LongStr(1,128),
                                fr=tr("Chemin vers la bibliothèque dynamique pour MFRONT")),
                                NOM_ROUTINE     = SIMP(statut='o', typ='TXM',
                                fr=tr("Nom de la routine MFRONT dans la bibliothèque")),
                                VERI_BORNE      = SIMP(statut='f', typ='TXM', defaut="ARRET",
                                                       into=('ARRET','SANS','MESSAGE'),
                                fr=tr("Vérification des bornes physiques de la loi")),
                                ALGO_CPLAN      = SIMP(statut='f', typ='TXM', defaut="DEBORST",
                                                       into=('DEBORST','ANALYTIQUE'),),
                              ),
            b_kit_ddi   = BLOC( condition = """equal_to("RELATION", 'KIT_DDI') """,
                                fr=tr("relations de couplage fluage-plasticite"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,
                                                      validators=NoRepeat(),
                                                 into=  (
                                                        "VMIS_CINE_LINE",
                                                        "VMIS_ISOT_TRAC",
                                                        "VMIS_ISOT_LINE",
                                                        "VMIS_ISOT_PUIS",
                                                        "GLRC_DM",
                                                        "BETON_GRANGER",
                                                        "BETON_GRANGER_V",
                                                        "BETON_UMLV",
                                                        "ROUSS_PR",
                                                        "BETON_DOUBLE_DP",
                                                        "ENDO_ISOT_BETON",
                                                        "MAZARS",
                                                        "ENDO_PORO_BETON",
                                                        "FLUA_PORO_BETON"
                                                        ),
                                                      ),
                              ),
            b_kit_cg    = BLOC( condition = """equal_to("RELATION", 'KIT_CG') """,
                                fr=tr("relations pour elements cables gaines"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,
                                                      validators=NoRepeat(),
                                                 into=  (
                                                        "CABLE_GAINE_FROT",
                                                        "VMIS_ISOT_LINE",
                                                        "VMIS_ISOT_TRAC",
                                                        "VMIS_CINE_LINE",
                                                        "PINTO_MENEGOTTO",
                                                        "ELAS",
                                                        "SANS"
                                                        ),
                                                      ),
                              ),
            b_kit_thm   = BLOC( condition = """is_in("RELATION", ['KIT_HHM','KIT_HH', 'KIT_H','KIT_HM','KIT_THHM','KIT_THH','KIT_THM','KIT_THV','KIT_THH2M','KIT_HH2M','KIT_HH2','KIT_THH2'])""",
                                fr=tr("lois de comportements thermo-hydro-mecaniques"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',max=9,
                                                      validators=NoRepeat(),
                                                      into=C_RELATION(COMMAND)+("GAZ",
                                                        "LIQU_SATU",
                                                        "LIQU_GAZ_ATM",
                                                        "LIQU_VAPE_GAZ",
                                                        "LIQU_AD_GAZ_VAPE",
                                                        "LIQU_AD_GAZ",
                                                        "LIQU_VAPE",
                                                        "LIQU_GAZ",
                                                        "HYDR_UTIL",
                                                        "HYDR_VGM",
                                                        "HYDR_VGC",
                                                        "HYDR_ENDO",
                                                        ),
                                                     ),
                                b_mfr_thm   = BLOC( condition = """'MFRONT' in value("RELATION_KIT")""",
                                    fr=tr("Comportement utilisateur meca THM de type MFRONT"),
                                    regles=(UN_PARMI('UNITE_LIBRAIRIE','LIBRAIRIE')),
                                    UNITE_LIBRAIRIE=SIMP(statut='f',typ=UnitType(), inout='in',),
                                    LIBRAIRIE   = SIMP(statut='f', typ='TXM',
                                    fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement MFRONT"),
                                                       ),
                                    NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                                    fr=tr("Nom de la routine MFRONT dans la bibliothèque")
                                                      ),
                                    VERI_BORNE  = SIMP(statut='f', typ='TXM',
                                                       defaut="ARRET",
                                                       into=('ARRET','SANS','MESSAGE'),
                                    fr=tr("Vérification des bornes physiques de la loi de comportement MFRONT"),
                                                       ),
                                    ALGO_CPLAN  = SIMP(statut='f', typ='TXM',
                                                       defaut="DEBORST",
                                                       into=('DEBORST','ANALYTIQUE'),
                                                      ),
                                                  ),
                              ),
            b_kit_meta  = BLOC( condition = """value("RELATION").startswith('META_')""",
                                fr=tr("nombre de phases metallurgiques"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',max=1,
                                                      validators=NoRepeat(),
                                                      into=("ACIER","ZIRC"),
                                                     ),
                             ),
            DEFORMATION     =SIMP(statut='f',typ='TXM',defaut="PETIT",
                                  into=("PETIT","PETIT_REAC","GROT_GDEP","SIMO_MIEHE","GDEF_LOG")),
            RESI_CPLAN_MAXI =SIMP(statut='f',typ='R',
                                  fr=tr("Critère d'arret absolu pour assurer la condition de contraintes planes")),
            b_resi_cplan   = BLOC(condition = """ not exists("RESI_CPLAN_MAXI") """,
                                  RESI_CPLAN_RELA   =SIMP(statut='f',typ='R',defaut= 1.0E-6,
                                  fr=tr("Critère d'arret relatif pour assurer la condition de contraintes planes")
                                                           ),
                                  ),
            ITER_CPLAN_MAXI =SIMP(statut='f',typ='I',defaut= 1,
                                      fr=tr("Nombre d'itérations maxi pour assurer la condition de contraintes planes")
                                 ),
        )
    else:
        opts = {}
        if COMMAND == 'STAT_NON_LINE' or 'DYNA_NON_LINE':
            opts['b_crirupt'] = BLOC(condition = """is_in("RELATION", ('VMIS_ISOT_LINE','VMIS_ISOT_TRAC','VISCOCHAB','VISC_ISOT_LINE','VISC_ISOT_TRAC',))""",
                                   fr=tr("Critere de rupture selon une contrainte critique"),
                    POST_ITER    =SIMP(statut='f',typ='TXM',into=("CRIT_RUPT",), ),
                                  )
        if COMMAND == 'STAT_NON_LINE':
            opts['b_anneal'] = BLOC(condition = """is_in("RELATION", ('VMIS_ISOT_LINE','VMIS_CINE_LINE','VMIS_ECMI_LINE','VMIS_ISOT_TRAC','VMIS_CIN1_CHAB','VMIS_CIN2_CHAB'))""",
                                   fr=tr("Restauration d'écrouissage"),
                    POST_INCR    =SIMP(statut='f',typ='TXM',into=("REST_ECRO",), ),
                                  )
        mcfact =   FACT(statut='f',min=1,max='**',
                        regles=(PRESENT_ABSENT('TOUT','GROUP_MA','MAILLE'),),
            TOUT        = SIMP( statut='f',typ='TXM',into=("OUI",) ),
            GROUP_MA    = SIMP( statut='f',typ=grma,validators=NoRepeat(),max='**'),
            MAILLE      = SIMP( statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
            RELATION    = SIMP( statut='f',typ='TXM',defaut="ELAS",into=C_RELATION(COMMAND)),
            b_monox     = BLOC( condition = """equal_to("RELATION", 'MONOCRISTAL') """,
                                fr=tr("SD issue de DEFI_COMPOR"),
                                COMPOR =SIMP(statut='o',typ=compor_sdaster,max=1),
                              ),
            b_polyx     = BLOC( condition = """equal_to("RELATION", 'POLYCRISTAL') """,
                                fr=tr("SD issue de DEFI_COMPOR"),
                                COMPOR =SIMP(statut='o',typ=compor_sdaster,max=1),
                              ),
            b_umat      = BLOC( condition = """equal_to("RELATION", 'UMAT') """,
                                fr=tr("Comportement utilisateur de type UMAT"),
                                NB_VARI         = SIMP(statut='o',typ='I',max=1,
                                fr=tr("Nombre de variables internes")),
                                LIBRAIRIE       = SIMP(statut='o', typ='TXM',validators=LongStr(1,128),
                                fr=tr("Chemin vers la bibliothèque dynamique pour UMAT")),
                                NOM_ROUTINE     = SIMP(statut='o', typ='TXM',
                                fr=tr("Nom de la routine UMAT dans la bibliothèque")),
                              ),
            b_mfront    = BLOC( condition = """equal_to("RELATION", 'MFRONT') """,
                                fr=tr("Comportement utilisateur de type MFRONT"),
                                regles=(UN_PARMI('UNITE_LIBRAIRIE','LIBRAIRIE')),
                                UNITE_LIBRAIRIE=SIMP(statut='f',typ=UnitType(), inout='in',),
                                LIBRAIRIE       = SIMP(statut='f', typ='TXM',validators=LongStr(1,128),
                                fr=tr("Chemin vers la bibliothèque dynamique pour MFRONT")),
                                NOM_ROUTINE     = SIMP(statut='o', typ='TXM',
                                fr=tr("Nom de la routine MFRONT dans la bibliothèque")),
                                VERI_BORNE      = SIMP(statut='f', typ='TXM', defaut="ARRET",
                                                       into=('ARRET','SANS','MESSAGE'),
                                fr=tr("Vérification des bornes physiques de la loi")),
                                ALGO_CPLAN      = SIMP(statut='f', typ='TXM', defaut="DEBORST",
                                                       into=('DEBORST','ANALYTIQUE'),),
                              ),
            b_kit_ddi   = BLOC( condition = """equal_to("RELATION", 'KIT_DDI') """,
                                fr=tr("relations de couplage fluage-plasticite"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,
                                                      validators=NoRepeat(),
                                                 into=  (
                                                        "VMIS_CINE_LINE",
                                                        "VMIS_ISOT_TRAC",
                                                        "VMIS_ISOT_LINE",
                                                        "VMIS_ISOT_PUIS",
                                                        "GLRC_DM",
                                                        "BETON_GRANGER",
                                                        "BETON_GRANGER_V",
                                                        "BETON_UMLV",
                                                        "ROUSS_PR",
                                                        "BETON_DOUBLE_DP",
                                                        "ENDO_ISOT_BETON",
                                                        "MAZARS",
                                                        ),
                                                      ),
                              ),
            b_kit_cg    = BLOC( condition = """equal_to("RELATION", 'KIT_CG') """,
                                fr=tr("relations pour elements cables gaines"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',min=2,max=2,
                                                      validators=NoRepeat(),
                                                 into=  (
                                                        "CABLE_GAINE_FROT",
                                                        "VMIS_ISOT_LINE",
                                                        "VMIS_ISOT_TRAC",
                                                        "VMIS_CINE_LINE",
                                                        "PINTO_MENEGOTTO",
                                                        "ELAS",
                                                        "SANS"
                                                        ),
                                                      ),
                              ),
            b_kit_thm   = BLOC( condition = """is_in("RELATION", ['KIT_HHM','KIT_HH', 'KIT_H','KIT_HM','KIT_THHM', 'KIT_THH','KIT_THM','KIT_THV','KIT_THH2M','KIT_HH2M','KIT_HH2','KIT_THH2'])""",
                                fr=tr("lois de comportements thermo-hydro-mecaniques"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',max=9,
                                                      validators=NoRepeat(),
                                                      into=C_RELATION(COMMAND)+("GAZ",
                                                        "LIQU_SATU",
                                                        "LIQU_GAZ_ATM",
                                                        "LIQU_VAPE_GAZ",
                                                        "LIQU_AD_GAZ_VAPE",
                                                        "LIQU_AD_GAZ",
                                                        "LIQU_VAPE",
                                                        "LIQU_GAZ",
                                                        "HYDR_UTIL",
                                                        "HYDR_VGM",
                                                        "HYDR_VGC",
                                                        "HYDR_ENDO",
                                                        ),
                                                     ),
                                b_mfr_thm   = BLOC( condition = """'MFRONT' in value("RELATION_KIT")""",
                                    fr=tr("Comportement utilisateur meca THM de type MFRONT"),
                                    regles=(UN_PARMI('UNITE_LIBRAIRIE','LIBRAIRIE')),
                                    UNITE_LIBRAIRIE=SIMP(statut='f',typ=UnitType(), inout='in',),
                                    LIBRAIRIE   = SIMP(statut='f', typ='TXM',
                                    fr=tr("Chemin vers la bibliothèque dynamique définissant le comportement MFRONT"),
                                                       ),
                                    NOM_ROUTINE = SIMP(statut='o', typ='TXM',
                                    fr=tr("Nom de la routine MFRONT dans la bibliothèque")
                                                      ),
                                    VERI_BORNE  = SIMP(statut='f', typ='TXM',
                                                       defaut="ARRET",
                                                       into=('ARRET','SANS','MESSAGE'),
                                    fr=tr("Vérification des bornes physiques de la loi de comportement MFRONT"),
                                                       ),
                                    ALGO_CPLAN  = SIMP(statut='f', typ='TXM',
                                                       defaut="DEBORST",
                                                       into=('DEBORST','ANALYTIQUE'),
                                                      ),
                                    RESI_INTE_MAXI    =SIMP(statut='f',typ='R',defaut= 1.0E-8),
                                    ITER_INTE_MAXI    =SIMP(statut='f',typ='I',defaut= 100 ),
                                                  ),
                              ),
            b_kit_meta  = BLOC( condition = """value("RELATION").startswith('META_')""",
                                fr=tr("nombre de phases metallurgiques"),
                                RELATION_KIT    =SIMP(statut='o',typ='TXM',max=1,
                                                      validators=NoRepeat(),
                                                      into=("ACIER","ZIRC"),
                                                     ),
                             ),
            DEFORMATION     =SIMP(statut='f',typ='TXM',defaut="PETIT",
                                  into=("PETIT","PETIT_REAC","GROT_GDEP","SIMO_MIEHE","GDEF_LOG")),
            RESI_CPLAN_MAXI =SIMP(statut='f',typ='R',
                                  fr=tr("Critère d'arret absolu pour assurer la condition de contraintes planes")),
            b_resi_cplan   = BLOC(condition = """ not exists("RESI_CPLAN_MAXI") """,
                                  RESI_CPLAN_RELA   =SIMP(statut='f',typ='R',defaut= 1.0E-6,
                                  fr=tr("Critère d'arret relatif pour assurer la condition de contraintes planes")
                                                           ),
                                  ),
            ITER_CPLAN_MAXI =SIMP(statut='f',typ='I',defaut= 1,
                                      fr=tr("Nombre d'itérations maxi pour assurer la condition de contraintes planes")
                                 ),
            # Parametres d'integration

            b_mfront_resi      = BLOC(condition = """(equal_to("RELATION", 'MFRONT'))""",
                RESI_INTE_MAXI    =SIMP(statut='f',typ='R',defaut= 1.0E-8),
                ITER_INTE_MAXI    =SIMP(statut='f',typ='I',defaut= 100 ),
            ),
            b_no_mfront        = BLOC(condition = """not equal_to("RELATION", 'MFRONT')""",
                RESI_INTE_RELA    =SIMP(statut='f',typ='R',defaut= 1.0E-6),
                ITER_INTE_MAXI    =SIMP(statut='f',typ='I',defaut= 20 ),
            ),

            b_redec_local      = BLOC(condition = """is_in("DEFORMATION", ('PETIT','PETIT_REAC','GROT_GDEP'))""",
                                 fr=tr("Nombre de redécoupages internes du pas de temps"),
                                ITER_INTE_PAS   =SIMP(statut='f',typ='I',defaut= 0 ),
                                 ),

            ALGO_INTE         =SIMP(statut='f',typ='TXM',into=("ANALYTIQUE", "SECANTE", "DEKKER", "NEWTON_1D","BRENT",
                                                          "NEWTON", "NEWTON_RELI", "NEWTON_PERT", "RUNGE_KUTTA",
                                                          "SPECIFIQUE", "SANS_OBJET")),

            TYPE_MATR_TANG    =SIMP(statut='f',typ='TXM',into=("PERTURBATION","VERIFICATION",)),

            SYME_MATR_TANG    =SIMP(statut='f',typ='TXM',into=("OUI","NON"), defaut = "OUI"),

            b_perturb         =BLOC(condition = """ (exists("TYPE_MATR_TANG")) """,
                               fr=tr("Calcul de la matrice tangente par perturbation, valeur de la perturbation"),
                VALE_PERT_RELA  =SIMP(statut='f',typ='R',defaut= 1.0E-5),
                              ),

            b_tangsec        = BLOC(condition = """ equal_to("TYPE_MATR_TANG", 'TANGENTE_SECANTE') """,
                               fr=tr("Modification evolutive de la matrice tangente/secante"),
                SEUIL        =SIMP(statut='f',typ='R',defaut= 3. ),
                AMPLITUDE    =SIMP(statut='f',typ='R',defaut= 1.5 ),
                TAUX_RETOUR  =SIMP(statut='f',typ='R',defaut= 0.05 ),
                              ),


            PARM_THETA      =SIMP(statut='f',typ='R',val_min=0.,val_max=1., defaut= 1.),

            b_radi          =BLOC(condition = """not exists("TYPE_MATR_TANG")""", RESI_RADI_RELA  =SIMP(statut='f',typ='R', ),),

            **opts
        )


    return mcfact
