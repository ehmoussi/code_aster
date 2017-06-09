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

# person_in_charge: j-pierre.lefebvre at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


FIN = FIN_PROC(nom="FIN",
               op=9999,
               repetable='n',
               fr=tr("Fin d'une étude, fin du travail engagé par une des commandes DEBUT ou POURSUITE"),

        # FIN est appelé prématurément en cas d'exception ("SIGUSR1", ArretCPUError,
        # NonConvergenceError..., erreurs <S> ou erreurs <F> récupérées).
        # En cas d'ArretCPUError, on limite au maximum le travail à faire dans FIN.
        # Pour cela, on force certains mots-clés dans Execution/E_JDC.py.
        FORMAT_HDF=SIMP(
            fr=tr("sauvegarde de la base GLOBALE au format HDF"),
            statut='f', typ='TXM', defaut="NON", into=("OUI", "NON",)),
        RETASSAGE=SIMP(
            fr=tr("provoque le retassage de la base GLOBALE"),
            statut='f', typ='TXM', defaut="NON", into=("OUI", "NON",)),
        INFO_RESU=SIMP(
            fr=tr("provoque l'impression des informations sur les structures de données"),
            statut='f', typ='TXM', defaut="OUI", into=("OUI", "NON",)),

        PROC0=SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),

        UNITE=SIMP(
            statut='f', typ=UnitType(), defaut=6, inout='out'),
        # hidden keyword used to ensure that the fortran knows that an error occurred
        # because when an exception is raised, the global status is reset by utmess.
        STATUT=SIMP(
            statut='c', typ='I', defaut=0),
)
