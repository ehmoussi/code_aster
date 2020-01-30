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
from code_aster.Commands import AFFE_CARA_ELEM
import copy, math
from random import *

def DEFI_ANGLES(Ng,prefix_nomgr):
###################################################################
#affectation aleatoire des orientations de chaque grain
###################################################################
#en entree :
#Ng : NOMBRE DE GERMES
#en sortie :
#LISTE_GROUP : MOT-CLE FACTEUR MASSIF de AFFE_CARA_ELEM
###################################################################


   # On boucle sur les arguments de la fonction pour
   # creer une liste de mots-cle facteurs que l'on va
   # retourner pour l'utiliser dans AFFE_CARA_ELEM
   # Noter que comme MASSIF est un mot-cle facteur, il
   # contient une liste de dictionnaires

   # coef=2*math.pi
   coef=360.

   LISTE_ANGLES=[]
   for ig in range(Ng):

         mon_dico={}
         mon_dico["GROUP_MA"]=prefix_nomgr+str(ig+1)
         angles=[coef*random(), coef/(2.*math.pi)*math.acos(2.*(random()-1./2.)), coef*random()]
         mon_dico["ANGL_EULER"]=angles
         LISTE_ANGLES.append(mon_dico)

   return LISTE_ANGLES


def F_AFFE_CARA_ELEM(MO, Ng, prefix_nomgr) :
        LISTE_ANGL = DEFI_ANGLES(Ng, prefix_nomgr)
        ORIELEM = AFFE_CARA_ELEM(MODELE=MO, MASSIF=LISTE_ANGL)
        return ORIELEM
