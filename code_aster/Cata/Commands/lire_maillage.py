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

# person_in_charge: jacques.pellet at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


LIRE_MAILLAGE=OPER(nom="LIRE_MAILLAGE",op=   1,sd_prod=maillage_sdaster,
                   fr=tr("Crée un maillage par lecture d'un fichier au format Aster ou Med"),
                   
                   reentrant='n',

         UNITE           =SIMP(statut='f',typ=UnitType(),defaut= 20 , inout='in'),

         FORMAT          =SIMP(statut='f',typ='TXM',defaut="MED",into=("ASTER","MED"),
                            fr=tr("Format du fichier : ASTER ou MED."),
                            ),

         VERI_MAIL       =FACT(statut='d',
               VERIF         =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
               APLAT         =SIMP(statut='f',typ='R',defaut= 1.0E-3 ),
         ),

         b_format_med =BLOC( condition = """ ( equal_to("FORMAT", 'MED') ) """ ,
                             fr=tr("Informations complémentaires pour la lecture MED."),
                             

# Pour une lecture dans un fichier MED, on peut préciser le nom sous lequel
# le maillage y a été enregistré. Par défaut, on va le chercher sous le nom du concept à créer.
            NOM_MED    = SIMP(statut='f',typ='TXM',
                              fr=tr("Nom du maillage dans le fichier MED."),
                              ),
            INFO_MED   = SIMP(statut='f',typ='I',defaut= 1,into=(1,2,3) ),

         ),

         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=(1,2) ),
         translation={
            "LIRE_MAILLAGE": "Read a mesh",
            "FORMAT": "Mesh file format",
            "UNITE": "Mesh file location",
            "VERI_MAIL": "Mesh check",
            "VERIF": "Check",
            "APLAT": "Flat criterion",
         }
)  ;
