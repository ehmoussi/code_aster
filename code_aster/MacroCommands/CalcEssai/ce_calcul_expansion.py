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

# person_in_charge: albert.alarcon at edf.fr

import random

import numpy

import aster
from libaster import AsterError

from ...Cata.DataStructure import (dyna_harmo, maillage_sdaster,
                                   matr_asse_depl_r, mode_meca, modele_sdaster)
from ...Cata.Syntax import _F
from ...Commands import (AFFE_MODELE, CREA_CHAMP, CREA_RESU, DEFI_FICHIER,
                         DETRUIRE, IMPR_RESU, INFO_EXEC_ASTER, LIRE_MAILLAGE,
                         MAC_MODES, MACRO_EXPANS)
from ...Messages import UTMESS
from ...Messages import MessageLog as mess
from ...Supervis import CO
from .cata_ce import DynaHarmo, Resultat


def extract_mac_array(mac_mode, nom_table="MAC"):
    """!Reconstruit un tableau numpy de modes MAC

    /param mac_mode concept Table aster
    """
    data1 = mac_mode.EXTR_TABLE().Array('NUME_MODE_1', nom_table)
    data2 = mac_mode.EXTR_TABLE().Array('NUME_MODE_2', nom_table)
    N = int(numpy.maximum.reduce(data1[:, 0]))
    M = int(numpy.maximum.reduce(data2[:, 0]))
    mac = numpy.zeros((N, M))
    for i in range(data1.shape[0]):
        i1 = int(data1[i, 0]) - 1
        i2 = int(data2[i, 0]) - 1
        mac[i1, i2] = data1[i, 1]
    return mac


class CalcEssaiExpansion:

    """!Classe qui s'occupe des calculs de l'interface correlation

    Cette classe un peu fourre-tout a pour but de separer les calculs
    specifique aster de l'interface graphique. L'objectif etant de pouvoir
    tester plus rapidement l'interface graphique en cours de developpement.

    """

    def __init__(self, macro, mess, objects):
        """!Constructeur

        macro: le self de l'objet macro provenant de calc_essai_ops
        """
        self.resu_num = None
        self.resu_exp = None
        self.norme_num = None
        self.norme_exp = None
        self.ce_objects = objects
        self.proj_meth = "SVD"
        self.proj_param = (1.e-2,)
        self.concepts = {}       # mapping number -> (name,owned)
        self.concepts_names = {}  # mapping name -> number
        self.macro = macro
        self.mess = mess

    def __setitem__(self, n, val):
        """!Emulation d'un dictionnaire

        On implemente __setitem__
        pour faire croire au superviseur qu'on cree
        un concept dans une liste"""
        self.concepts[n] = val

    def __getitem__(self, n):
        """!Emulation d'un dictionnaire

        On implemente __getitem__ pour les meme raison, et pour
        faire de l'allocation dynamique de numero de concept
        on se comporte comme une liste"""
        return self.concepts[n]

    def setup(self, resu_num, mode_num_list,
              resu_exp, mode_exp_list,
              param):
        """  on donne a Aster les donnees numerique spour le calcul d'expansion
        """
        self.resu_num = resu_num
        self.mode_num_list = mode_num_list
        self.resu_exp = resu_exp
        self.mode_exp_list = mode_exp_list
        self.param = param

    def calc_proj_resu(self):
        """Lancement de MACRO_EPXANS et export des resultats si demande
        4 resultats sont crees, nommes basename + suffix, ou
        suffix = ['_NX','_EX','_ET','_RD']"""
        self.mess.disp_mess("Debut de MACRO_EXPANS")
        mdo = self.ce_objects

        # Preparation des donnees de mesure
        nume = None
        mcfact_mesure = {'MODELE': self.resu_exp.modele.obj,
                         'MESURE': self.resu_exp.obj,
                         'NOM_CHAM': self.resu_exp.nom_cham}
        args = {}

        # modif : la partie commentee ci-dessus devrait marcher bien comme ca
        if self.mode_exp_list:
            # res_EX est genere que si on a selectionne une partie des modes
            res_EX = CO("EX")
            args.update({'RESU_EX': res_EX})
            mcfact_mesure.update({'NUME_ORDRE': tuple(self.mode_exp_list)})
            if self.resu_exp.obj.getType() == "DYNA_HARMO":
                nume = self.resu_exp.nume_ddl  # aller chercher a la main le nume_ddl

        # Preparation des donnees numeriques pour la base d'expansion
        mcfact_calcul = {'MODELE': self.resu_num.modele.obj,
                         'BASE': self.resu_num.obj}
        if self.mode_num_list:
            # res_NX est genere que si on a selectionne une partie des modes
            res_NX = CO("NX")
            args.update({'RESU_NX': res_NX})
            mcfact_calcul.update({'NUME_ORDRE': tuple(self.mode_num_list)})

        # Parametres de resolution
        parametres = self.param

        try:
            result = MACRO_EXPANS(
                __use_namedtuple__=True,
                MODELE_CALCUL=mcfact_calcul,
                MODELE_MESURE=mcfact_mesure,
                NUME_DDL=nume,
                RESU_ET=CO("ET"),
                RESU_RD=CO("RD"),
                RESOLUTION=parametres,
                **args
            )

        except AsterError as err:
            message = "ERREUR ASTER : " + err.message
            self.mess.disp_mess(message)
            UTMESS('A', 'CALCESSAI0_7')
            return

        self.mess.disp_mess("Fin de MACRO_EXPANS")
        self.mess.disp_mess(" ")
        return result

    def calc_mac_mode(self, resu1, resu2, norme):
        """!Calcul de MAC entre deux bases modales compatibles"""
        try:
            __MAC = MAC_MODES(BASE_1=resu1,
                              BASE_2=resu2,
                              MATR_ASSE=norme,
                              INFO=1)
        except AsterError as err:
            message = "ERREUR ASTER : " + err.message
            self.mess.disp_mess(message)
            UTMESS('A', 'CALCESSAI0_3')
            return
        self.mess.disp_mess(("      "))
        mac = extract_mac_array(__MAC, 'MAC')
        DETRUIRE(CONCEPT=_F(NOM=(__MAC,)), INFO = 1)
        return mac
