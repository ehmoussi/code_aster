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

# person_in_charge: romeo.fernandes at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

def calc_mac3coeur_prod(self,RESU_DEF,DEPL_DAMAC,**args):
    if RESU_DEF:
        self.type_sdprod(RESU_DEF,evol_noli)
    if DEPL_DAMAC:
        self.type_sdprod(DEPL_DAMAC,evol_noli)
    return evol_noli

CALC_MAC3COEUR = MACRO(nom="CALC_MAC3COEUR",
                       op=OPS("Mac3coeur.mac3coeur_calcul.calc_mac3coeur_ops"),
                       sd_prod=calc_mac3coeur_prod,

         TYPE_COEUR   = SIMP(statut='o',typ='TXM',into=("MONO","MONO_FROID","TEST","900","1300","N4","LIGNE900","LIGNE1300","LIGNEN4")),
         # TYPE DE COEUR A CONSIDERER
         TABLE_N      = SIMP(statut='o',typ=table_sdaster),         # TABLE INITIALE DES DAMAC A L INSTANT N
         MAILLAGE_N   = SIMP(statut='f',typ=maillage_sdaster),      # MAILLAGE EN ATTENDANT MIEUX ???
         RESU_DEF     = SIMP(statut='f',typ=CO,defaut=None),
         DEPL_DAMAC     = SIMP(statut='f',typ=CO,defaut=None),
         FLUENCE_CYCLE = SIMP(statut='o',typ='R',max=1,defaut=0.),

         ETAT_INITIAL = FACT(statut='f',max=1,
                          fr=tr("Estimation d'un etat initial a partir d un DAMAC"),
               UNITE_THYC   = SIMP(statut='f',typ=UnitType(), max=1, inout='in' ),            # Unite Logique du fichier THYC
               NIVE_FLUENCE =  SIMP(statut='o',typ='R',max=1), # FLUENCE MAXIMALE DANS LE COEUR
               TYPE_MAINTIEN = SIMP(statut='f',typ='TXM',into=("DEPL_PSC",),defaut="DEPL_PSC" ),
               ARCHIMEDE = SIMP(statut='f',typ='TXM',into=("OUI", ),defaut="OUI" ),
            ),

         LAME = FACT(statut='f',max=1, fr=tr("Estimation des lames d'eau entre AC"),
                     UNITE_THYC   = SIMP(statut='o',typ=UnitType(), max=1, inout='in'),            # Unite Logique du fichier THYC
                     ),
         
         # choix du maintien dans le cas mono-assemblage
         b_maintien_mono = BLOC(condition = """exists("TYPE_COEUR") and TYPE_COEUR.startswith('MONO')""",

         DEFORMATION  = FACT(statut='f',max=1, fr=tr("Estimation des deformations des AC"),
              
               RESU_INIT    = SIMP(statut='f',typ=resultat_sdaster),
               NIVE_FLUENCE = SIMP(statut='o',typ='R',max=1), # FLUENCE MAXIMALE DANS LE COEUR
               UNITE_THYC      = SIMP(statut='o',typ=UnitType(), max=1, inout='in'),                   # Unite Logique du fichier THYC

               TYPE_MAINTIEN = SIMP(statut='o',typ='TXM',into=("FORCE","DEPL_PSC"), ),

               b_maintien_mono_force = BLOC(condition = """equal_to("TYPE_MAINTIEN", 'FORCE')""",
                                 fr=tr("valeur de l'effort de maintien imposée"),
                                 FORCE_MAINTIEN           =SIMP(statut='o',typ='R', max=1),),
               ARCHIMEDE = SIMP(statut='o',typ='TXM',into=("OUI","NON"), ),
          ),),
          
          # choix du maintien dans le cas d'un coeur à plusieurs assemblages
          b_maintien_coeur = BLOC(condition = """exists("TYPE_COEUR") and not TYPE_COEUR.startswith('MONO')""",
          DEFORMATION  = FACT(statut='f',max=1,
                      fr=tr("Estimation des deformations des AC"),
               RESU_INIT    = SIMP(statut='f',typ=resultat_sdaster),
               NIVE_FLUENCE = SIMP(statut='o',typ='R',max=1), # FLUENCE MAXIMALE DANS LE COEUR
               UNITE_THYC      = SIMP(statut='o',typ=UnitType(), max=1, inout='in'),                   # Unite Logique du fichier THYC

               TYPE_MAINTIEN = SIMP(statut='f',typ='TXM',into=("DEPL_PSC",),defaut="DEPL_PSC" ),
               ARCHIMEDE = SIMP(statut='f',typ='TXM',into=("OUI", ),defaut="OUI" ),


          ),),

);
