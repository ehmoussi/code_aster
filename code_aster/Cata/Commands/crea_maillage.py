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
# person_in_charge: jacques.pellet at edf.fr
CREA_MAILLAGE=OPER(nom="CREA_MAILLAGE",op= 167,sd_prod=maillage_sdaster,
            reentrant='n',fr=tr("Crée un maillage à partir d'un maillage existant"),
            UIinfo={"groupes":("Maillage",)},
         regles=(UN_PARMI('COQU_VOLU', 'CREA_FISS', 'CREA_MAILLE', 'CREA_POI1',
                         'ECLA_PG', 'HEXA20_27', 'LINE_QUAD', 'MODI_MAILLE',
                        'QUAD_LINE', 'REPERE','RESTREINT','PENTA15_18','GEOM_FIBRE', 'DECOUPE_LAC'),),



         # le MAILLAGE est inutile si ECLA_PG et GEOM_FIBRE
         MAILLAGE        =SIMP(statut='f',typ=maillage_sdaster ),
         GEOM_FIBRE           = SIMP(statut='f',max=1,typ=gfibre_sdaster),

         CREA_POI1       =FACT(statut='f',max='**',fr=tr("Création de mailles de type POI1 à partir de noeuds"),
           regles=(AU_MOINS_UN('TOUT','GROUP_MA','MAILLE','GROUP_NO','NOEUD' ),),
           NOM_GROUP_MA    =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD           =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
         ),
         CREA_MAILLE     =FACT(statut='f',max='**',fr=tr("Duplication de mailles"),
           regles=(AU_MOINS_UN('TOUT','MAILLE','GROUP_MA'),),
           NOM             =SIMP(statut='o',typ='TXM'),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           PREF_MAILLE     =SIMP(statut='o',typ='TXM' ),
           PREF_NUME       =SIMP(statut='f',typ='I' ),
         ),
         RESTREINT   =FACT(statut='f',fr=tr("Restreindre un maillage à des groupes de mailles"),max=1,
           regles=(AU_MOINS_UN('GROUP_MA','MAILLE',),),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE          =SIMP(statut='f',typ=ma,validators=NoRepeat(),max='**'),
           TOUT_GROUP_MA   =SIMP(statut='f',typ='TXM',defaut='NON',into=('OUI','NON'),),
           GROUP_NO        =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           TOUT_GROUP_NO   =SIMP(statut='f',typ='TXM',defaut='NON',into=('OUI','NON'),),
         ),
         COQU_VOLU   =FACT(statut='f',
                           fr=tr("Creation de mailles volumiques à partir de mailles surfaciques"),
           NOM             =SIMP(statut='o',typ='TXM'),
           GROUP_MA        =SIMP(statut='o',typ=grma,validators=NoRepeat(),max ='**'),
           EPAIS           =SIMP(statut='o',typ='R' ),
           PREF_MAILLE     =SIMP(statut='f',typ='TXM',defaut="MS" ),
           PREF_NOEUD      =SIMP(statut='f',typ='TXM',defaut="NS" ),
           PREF_NUME       =SIMP(statut='f',typ='I'  ,defaut=1 ),
           PLAN            =SIMP(statut='o',typ='TXM',into=("SUP","MOY","INF")),
           b_MOY =BLOC(condition = "PLAN == 'MOY'",
             TRANSLATION   =SIMP(statut='o',typ='TXM',into=("SUP","INF") ),
           ),
         ),
         MODI_MAILLE     =FACT(statut='f',max='**',fr=tr("Modification du type de mailles"),
           regles=(AU_MOINS_UN('TOUT','MAILLE','GROUP_MA' ),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           MAILLE          =SIMP(statut='f',typ=ma,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma  ,validators=NoRepeat(),max='**'),
           OPTION          =SIMP(statut='o',typ='TXM',into=("TRIA6_7","QUAD8_9","SEG3_4","QUAD_TRIA3"),validators=NoRepeat(),
                                 fr=tr("Choix de la transformation") ),
           b_NOS =BLOC(condition = "OPTION == 'TRIA6_7'  or  OPTION == 'QUAD8_9'  or  OPTION == 'SEG3_4'",
             PREF_NOEUD      =SIMP(statut='f',typ='TXM',defaut="NS"),
             PREF_NUME       =SIMP(statut='f',typ='I',defaut= 1 ),
           ),
           b_QTR =BLOC(condition = "OPTION == 'QUAD_TRIA3'",
             PREF_MAILLE     =SIMP(statut='f',typ='TXM',defaut="MS" ),
             PREF_NUME       =SIMP(statut='f',typ='I',defaut= 1 ),
           ),
         ),
         CREA_FISS = FACT(statut='f',max='**',fr=tr("Creation d'une fissure potentielle avec elts de joint ou elts à disc"),
           NOM             =SIMP(statut='o',typ='TXM'),
           GROUP_NO_1      =SIMP(statut='o',typ=grno),
           GROUP_NO_2      =SIMP(statut='o',typ=grno),
           PREF_MAILLE     =SIMP(statut='o',typ='TXM'),
           PREF_NUME       =SIMP(statut='f',typ='I',defaut=1 ),
         ),
         LINE_QUAD     =FACT(statut='f',fr=tr("Passage linéaire -> quadratique"),
           regles=(AU_MOINS_UN('TOUT','MAILLE','GROUP_MA' ),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           MAILLE          =SIMP(statut='f',typ=ma,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma  ,validators=NoRepeat(),max='**'),
           PREF_NOEUD      =SIMP(statut='f',typ='TXM',defaut="NS"),
           PREF_NUME       =SIMP(statut='f',typ='I',defaut= 1 ),
         ),
         HEXA20_27     =FACT(statut='f',fr=tr("Passage HEXA20 -> HEXA27"),
           regles=(AU_MOINS_UN('TOUT','MAILLE','GROUP_MA' ),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           MAILLE          =SIMP(statut='f',typ=ma,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma  ,validators=NoRepeat(),max='**'),
           PREF_NOEUD      =SIMP(statut='f',typ='TXM',defaut="NS"),
           PREF_NUME       =SIMP(statut='f',typ='I',defaut= 1 ),
         ),
         PENTA15_18     =FACT(statut='f',fr=tr("Passage PENTA15 -> PENTA18"),
           regles=(AU_MOINS_UN('TOUT','MAILLE','GROUP_MA' ),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           MAILLE          =SIMP(statut='f',typ=ma,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma  ,validators=NoRepeat(),max='**'),
           PREF_NOEUD      =SIMP(statut='f',typ='TXM',defaut="NS"),
           PREF_NUME       =SIMP(statut='f',typ='I',defaut= 1 ),
         ),
         QUAD_LINE     =FACT(statut='f',fr=tr("Passage quadratique -> linéaire"),
           regles=(AU_MOINS_UN('TOUT','MAILLE','GROUP_MA' ),),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           MAILLE          =SIMP(statut='f',typ=ma,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma  ,validators=NoRepeat(),max='**'),
         ),
         REPERE          =FACT(statut='f',max='**',
                               fr=tr("changement de repère servant à déterminer les caractéristiques d'une section de poutre"),
           TABLE           =SIMP(statut='o',typ=table_sdaster,
                                 fr=tr("Nom de la table contenant les caractéristiques de la section de poutre") ),
           NOM_ORIG        =SIMP(statut='f',typ='TXM',into=("CDG","TORSION"),fr=tr("Origine du nouveau repère") ),
           NOM_ROTA        =SIMP(statut='f',typ='TXM',into=("INERTIE",),fr=tr("Direction du repére")  ),
           b_cdg =BLOC(condition = "NOM_ORIG == 'CDG'",
             GROUP_MA        =SIMP(statut='f',typ=grma,
                                   fr=tr("Nom du groupe de mailles dont le centre de gravité sera l origine du nouveau repère")),
           ),
         ),
         DECOUPE_LAC     =FACT(statut='f',fr="creation des patchs LAC pour le  contact",
           regles=(AU_MOINS_UN('GROUP_MA' ),),
           GROUP_MA        =SIMP(statut='o',typ=grma  ,validators=NoRepeat(),max='**'),
         ),
         ECLA_PG         =FACT(statut='f',
                               fr=tr("Eclatement des mailles en petites mailles contenant chacune un seul point de gauss"),
           MODELE          =SIMP(statut='o',typ=modele_sdaster ),
           TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           MAILLE          =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           SHRINK          =SIMP(statut='f',typ='R',defaut= 0.9, fr=tr("Facteur de réduction") ),
           TAILLE_MIN      =SIMP(statut='f',typ='R',defaut= 0.0, fr=tr("Taille minimale d'un coté") ),
           NOM_CHAM        =SIMP(statut='o',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO('ELGA'),),
         ),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
#
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=(1,2) ),
)  ;
