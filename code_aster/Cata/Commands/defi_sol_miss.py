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
# person_in_charge: mathieu.courtois at edf.fr


DEFI_SOL_MISS = MACRO(nom="DEFI_SOL_MISS",
                      op=OPS('Macro.defi_sol_miss_ops.defi_sol_miss_ops'),
                      sd_prod=table_sdaster,
                      fr=tr("Définition des données de sol pour Miss"),
                      reentrant='n',
                      UIinfo={"groupes":("Modélisation","Outils-métier",)},
   regles=(UN_PARMI('COUCHE','COUCHE_AUTO'),),
   MATERIAU = FACT(statut='o', max='**',
            fr=tr("Définition des matériaux"),
      E         = SIMP(statut='o', typ='R', fr=tr("Module d'Young")),
      NU        = SIMP(statut='o', typ='R', fr=tr("Coefficient de Poisson")),
      RHO       = SIMP(statut='o', typ='R', fr=tr("Masse volumique")),
      AMOR_HYST = SIMP(statut='o', typ='R', fr=tr("Coefficient d'amortissement")),
   ),
   COUCHE = FACT(statut='f', max='**',
                 fr=tr("Définition des couches"),
      regles=(AU_MOINS_UN('EPAIS','SUBSTRATUM'),),
      SUBSTRATUM           = SIMP(statut='f', typ='TXM', into=("OUI","NON"),),
      EPAIS                = SIMP(statut='f', typ='R', fr=tr("Epaisseur de la couche")),
      RECEPTEUR            = SIMP(statut='f', typ='TXM', defaut="NON", into=("OUI", "NON"),),
      SOURCE               = SIMP(statut='f', typ='TXM', defaut="NON", into=("OUI", "NON"),),
      NUME_MATE            = SIMP(statut='o', typ='I', fr=tr("Numéro du matériau")),
   ),
   COUCHE_AUTO = FACT(statut='f', max=1,
                 fr=tr("Définition automatique des couches"),
      Z0                   = SIMP(statut='f', typ='R', max=1,fr=tr("Position de la surface libre")),
      HOMOGENE             = SIMP(statut='o', typ='TXM', into=("OUI","NON"),),
      SURF                 = SIMP(statut='f', typ='TXM', into=("OUI","NON",), defaut="NON"),
      EPAIS_PHYS           = SIMP(statut='o', typ='R', max='**',fr=tr("Epaisseur des couches")),
   b_stratifie   = BLOC(condition="HOMOGENE == 'NON'",
       NUME_MATE_SUBSTRATUM = SIMP(statut='o', typ='I',fr="Numéro du matériau du substratum"),      
       NUME_MATE            = SIMP(statut='o', typ='I', max='**',fr=tr("Numéro du matériau")),
   ),
   b_surf   = BLOC(condition="SURF == 'OUI'",
      regles=(PRESENT_PRESENT('GROUP_MA_CONTROL','MAILLAGE'),),
      GROUP_MA_CONTROL     = SIMP(statut='f', typ=grma, max=1,
                                  fr=tr("Groupe de mailles des points de contrôle")),  
      MAILLAGE             = SIMP(statut='f',typ=maillage_sdaster),
   ),
   b_enfonce   = BLOC(condition="SURF == 'NON'",
      regles=(UN_PARMI('GROUP_MA','GROUP_NO'),),
      GROUP_MA             = SIMP(statut='f', typ=grma, max=1,
                                  fr=tr("Groupe de mailles donnant les cotes verticales")),
      GROUP_NO             = SIMP(statut='f', typ=grno, max=1,
                                  fr=tr("Groupe de noeuds donnant les cotes verticales")),
      NOMBRE_RECEPTEUR     = SIMP(statut='f', typ='I', defaut=4, max = 1,
                                  fr="Nombre de récépteurs par element"),
      GROUP_MA_INTERF      = SIMP(statut='f', typ=grma, max=1,
                               fr="Groupe de mailles de l'interface"),
      GROUP_MA_CONTROL     = SIMP(statut='f', typ=grma, max=1,
                                  fr=tr("Groupe de mailles des points de contrôle")),  
      MAILLAGE             = SIMP(statut='o',typ=maillage_sdaster),
      TOLERANCE            = SIMP(statut='f',typ='R',defaut= 1.0E-5 ),
      DECALAGE_AUTO        = SIMP(statut='f', typ='TXM', into=("OUI","NON",), defaut="OUI"),
   ),      
   ),   
   TITRE = SIMP(statut='f', typ='TXM', max='**',
                fr=tr("Titre de la table produite")),
   INFO  = SIMP(statut='f', typ='I', defaut=1, into=(1,2)),
)
