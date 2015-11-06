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
def proj_champ_prod(RESULTAT=None,CHAM_GD=None,METHODE=None,**args ):
    if (RESULTAT == None and CHAM_GD == None) : return corresp_2_mailla
    if  RESULTAT != None                      : return AsType(RESULTAT)
    if  CHAM_GD  != None and METHODE == 'SOUS_POINT' :
        return cham_elem
    else :
        return AsType(CHAM_GD)
    raise AsException("type de concept resultat non prevu")




PROJ_CHAMP=OPER(nom="PROJ_CHAMP",op= 166,sd_prod=proj_champ_prod,reentrant='f',
        UIinfo={"groupes":("Résultats et champs",)},
            fr=tr("Projeter des champs d'un maillage sur un autre"),

     # faut-il projeter les champs ?
     PROJECTION      =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON",),),

     # pour projeter avec une sd_corresp_2_mailla deja calculée :
     MATR_PROJECTION   =SIMP(statut='f',typ=corresp_2_mailla,),



     #-----------------------------------------------------------------------------------------------------------
     # 1er cas : on fait tout d'un coup : creation de la sd_corresp_2_mailla + projection des champs
     #-----------------------------------------------------------------------------------------------
     b_1_et_2   =BLOC(condition= "PROJECTION == 'OUI' and MATR_PROJECTION == None",
         regles=(UN_PARMI('RESULTAT','CHAM_GD'),
                 UN_PARMI('MODELE_1','MAILLAGE_1'),
                 UN_PARMI('MODELE_2','MAILLAGE_2'),
                 ),
         RESULTAT        =SIMP(statut='f',typ=resultat_sdaster),
         CHAM_GD         =SIMP(statut='f',typ=(cham_no_sdaster,cham_elem)),

         METHODE         =SIMP(statut='f',typ='TXM',defaut="AUTO",
                               into=("NUAGE_DEG_0","NUAGE_DEG_1","AUTO","COLLOCATION","ECLA_PG","SOUS_POINT") ),


         MODELE_1        =SIMP(statut='f',typ=modele_sdaster),
         MAILLAGE_1      =SIMP(statut='f',typ=(maillage_sdaster,squelette)),

         MODELE_2        =SIMP(statut='f',typ=modele_sdaster),
         MAILLAGE_2      =SIMP(statut='f',typ=maillage_sdaster),

         # Cas de la projection NUAGE_DEG_0/1 :
         #--------------------------------------------
         b_nuage         =BLOC(condition="METHODE in ('NUAGE_DEG_0','NUAGE_DEG_1')",
             CHAM_NO_REFE    =SIMP(statut='o',typ=cham_no_sdaster),
         ),


         # Cas de la projection COLLOCATION :
         #--------------------------------------------
         b_elem          =BLOC(condition="METHODE in ('COLLOCATION','ECLA_PG','AUTO')",
             CAS_FIGURE      =SIMP(statut='f',typ='TXM',into=("2D","3D","2.5D","1.5D",),
                  fr=tr("Pour indiquer au programme le type de projection souhaité")),
             DISTANCE_MAX    =SIMP(statut='f',typ='R',
                  fr=tr("Distance maximale entre le noeud et l'élément le plus proche, lorsque le noeud n'est dans aucun élément.")),
             DISTANCE_ALARME =SIMP(statut='f',typ='R'),

             TRANSF_GEOM_1   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                  fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                     " aux noeuds du MODELE_1 avant la projection.")),
             TRANSF_GEOM_2   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                  fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                     " aux noeuds du MODELE_2 avant la projection.")),

             ALARME          =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),

             TYPE_CHAM       =SIMP(statut='f',typ='TXM',into=("NOEU",),
                  fr=tr("Pour forcer le type des champs projetés. NOEU -> cham_no")),

             PROL_ZERO       =SIMP(statut='f',typ='TXM',into=("OUI","NON"),defaut="NON",
                  fr=tr("Pour prolonger les champs par zéro là ou la projection ne donne pas de valeurs.")),
         ),

         # Cas de la projection SOUS_POINT :
         #--------------------------------------------
         b_sous_point         =BLOC(condition="METHODE == 'SOUS_POINT'" ,
             CARA_ELEM    =SIMP(statut='o',typ=cara_elem),
             PROL_ZERO       =SIMP(statut='f',typ='TXM',into=("OUI","NON"),defaut="NON",
                  fr=tr("Pour prolonger les champs par zéro là ou la projection ne donne pas de valeurs.")),
             TRANSF_GEOM_1   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                  fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                     " aux noeuds du MODELE_1 avant la projection.")),
             TRANSF_GEOM_2   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                  fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                     " aux noeuds du MODELE_2 avant la projection.")),
         ),


         # Cas de la projection d'une sd_resultat :
         #--------------------------------------------
         b_resultat      =BLOC(condition="RESULTAT != None",
           regles=(EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','FREQ','LIST_INST','LIST_FREQ','LIST_ORDRE'),
                   EXCLUS('TOUT_CHAM','NOM_CHAM',),),
           NOM_PARA        =SIMP(statut='f',typ='TXM', max='**'),
           TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO(),),

           NUME_DDL        =SIMP(statut='f',typ=(nume_ddl_sdaster),
                fr=tr("Utile en dynamique pour pouvoir imposer la numérotation des cham_no.")),

           TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**' ),
           LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
           INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
           LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),
           FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
           LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
           NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**' ),
           NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),

           b_acce_reel     =BLOC(condition="(FREQ != None)or(LIST_FREQ != None)or(INST != None)or(LIST_INST != None)",
              CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
              b_prec_rela=BLOC(condition="(CRITERE=='RELATIF')",
                   PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
              b_prec_abso=BLOC(condition="(CRITERE=='ABSOLU')",
                   PRECISION       =SIMP(statut='o',typ='R',),),
           ),
         ),


         VIS_A_VIS       =FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('TOUT_1','GROUP_MA_1','MAILLE_1','GROUP_NO_1','NOEUD_1'),
                   AU_MOINS_UN('TOUT_2','GROUP_MA_2','MAILLE_2','GROUP_NO_2','NOEUD_2'),),
           TOUT_1          =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA_1      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_1        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO_1      =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD_1         =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           TOUT_2          =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA_2      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_2        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO_2      =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD_2         =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),

           # les mots clés suivants ne sont actifs que si METHODE='COLLOCATION' mais on ne peut pas le vérifier:
               CAS_FIGURE      =SIMP(statut='f',typ='TXM',into=("2D","3D","2.5D","1.5D",) ),
               TRANSF_GEOM_1   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                    fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                       " aux noeuds du MODELE_1 avant la projection.")),
               TRANSF_GEOM_2   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                    fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                       " aux noeuds du MODELE_2 avant la projection.")),
         ),
     ), # fin bloc b_1_et_2



     #-----------------------------------------------------------------------------------------------------------
     # 2eme cas : on s'arrete apres la creation de la sd_corresp_2_mailla
     #-----------------------------------------------------------------------------------------------
     b_1   =BLOC(condition="PROJECTION == 'NON'",

         METHODE         =SIMP(statut='f',typ='TXM',defaut="COLLOCATION",
                               into=("COLLOCATION","COUPLAGE",) ),

         regles=(UN_PARMI('MODELE_1','MAILLAGE_1'),
                 UN_PARMI('MODELE_2','MAILLAGE_2'),
                 ),
         MODELE_1        =SIMP(statut='f',typ=modele_sdaster),
         MAILLAGE_1      =SIMP(statut='f',typ=maillage_sdaster),

         MODELE_2        =SIMP(statut='f',typ=modele_sdaster),
         MAILLAGE_2      =SIMP(statut='f',typ=maillage_sdaster),


         # Cas de la projection COLLOCATION :
         #--------------------------------------------
         b_elem          =BLOC(condition="METHODE in ('COLLOCATION',)",
             CAS_FIGURE      =SIMP(statut='f',typ='TXM',into=("2D","3D","2.5D","1.5D",),
                  fr=tr("Pour indiquer au programme le type de projection souhaité")),
             DISTANCE_MAX    =SIMP(statut='f',typ='R',
                  fr=tr("Distance maximale entre le noeud et l'élément le plus proche, lorsque le noeud n'est dans aucun élément.")),
             DISTANCE_ALARME =SIMP(statut='f',typ='R'),

             TRANSF_GEOM_1   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                  fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                     " aux noeuds du MODELE_1 avant la projection.")),
             TRANSF_GEOM_2   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                  fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                     " aux noeuds du MODELE_2 avant la projection.")),

             ALARME          =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),

         ),

         VIS_A_VIS       =FACT(statut='f',max='**',
           regles=(AU_MOINS_UN('TOUT_1','GROUP_MA_1','MAILLE_1','GROUP_NO_1','NOEUD_1'),
                   AU_MOINS_UN('TOUT_2','GROUP_MA_2','MAILLE_2','GROUP_NO_2','NOEUD_2'),),
           TOUT_1          =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA_1      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_1        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO_1      =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD_1         =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),
           TOUT_2          =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           GROUP_MA_2      =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
           MAILLE_2        =SIMP(statut='f',typ=ma  ,validators=NoRepeat(),max='**'),
           GROUP_NO_2      =SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
           NOEUD_2         =SIMP(statut='f',typ=no  ,validators=NoRepeat(),max='**'),

           # les mots clés suivants ne sont actifs que si METHODE='COLLOCATION' mais on ne peut pas le vérifier:
               CAS_FIGURE      =SIMP(statut='f',typ='TXM',into=("2D","3D","2.5D","1.5D",) ),
               TRANSF_GEOM_1   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                    fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                       " aux noeuds du MODELE_1 avant la projection.")),
               TRANSF_GEOM_2   =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule),min=2,max=3,
                    fr=tr("2 (ou 3) fonctions fx,fy,fz définissant la transformation géométrique à appliquer"
                       " aux noeuds du MODELE_2 avant la projection.")),
         ),
     ), # fin bloc b_1



     #-----------------------------------------------------------------------------------------------------------
     # 3eme cas : on projette les champs avec une sd_corresp_2_mailla déjé calculée
     #-----------------------------------------------------------------------------------------------
     b_2   =BLOC(condition="MATR_PROJECTION != None",
         regles=(UN_PARMI('RESULTAT','CHAM_GD'),),
         RESULTAT        =SIMP(statut='f',typ=resultat_sdaster),
         CHAM_GD         =SIMP(statut='f',typ=(cham_no_sdaster,cham_elem)),

         TYPE_CHAM       =SIMP(statut='f',typ='TXM',into=("NOEU",),
              fr=tr("Pour forcer le type des champs projetés. NOEU -> cham_no")),

         NUME_DDL        =SIMP(statut='f',typ=(nume_ddl_sdaster),
              fr=tr("Parfois utile en dynamique pour pouvoir imposer la numérotation des cham_no.")),

         # nécessaire si l'on projette des cham_elem :
         MODELE_2        =SIMP(statut='f',typ=modele_sdaster),

         PROL_ZERO       =SIMP(statut='f',typ='TXM',into=("OUI","NON"),defaut="NON",
              fr=tr("Pour prolonger les champs par zéro là où la projection ne donne pas de valeurs.")),



         # Cas de la projection d'une sd_resultat :
         #--------------------------------------------
         b_resultat      =BLOC(condition="RESULTAT != None",
           regles=(EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','FREQ','LIST_INST','LIST_FREQ','LIST_ORDRE'),
                   EXCLUS('TOUT_CHAM','NOM_CHAM',),),

           NOM_PARA        =SIMP(statut='f',typ='TXM', max='**'),
           TOUT_CHAM       =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           NOM_CHAM        =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO(),),


           TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
           NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**' ),
           LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
           INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
           LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),
           FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**' ),
           LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster),
           NUME_MODE       =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**' ),
           NOEUD_CMP       =SIMP(statut='f',typ='TXM',validators=NoRepeat(),max='**'),

           b_acce_reel     =BLOC(condition="(FREQ != None)or(LIST_FREQ != None)or(INST != None)or(LIST_INST != None)",
              CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
              b_prec_rela=BLOC(condition="(CRITERE=='RELATIF')",
                   PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
              b_prec_abso=BLOC(condition="(CRITERE=='ABSOLU')",
                   PRECISION       =SIMP(statut='o',typ='R',),),
           ),

         ),
     ), # fin bloc b_2



     TITRE           =SIMP(statut='f',typ='TXM',max='**' ),
     INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2)),
)  ;
