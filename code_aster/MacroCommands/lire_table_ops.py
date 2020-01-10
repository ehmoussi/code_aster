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

# person_in_charge: mathieu.courtois at edf.fr

import os.path as osp

import aster
from ..Commands import CREA_TABLE
from ..Helpers import LogicalUnitFile
from Utilitai.TableReader import TableReaderFactory, unique_parameters
from Utilitai.Utmess import UTMESS, raise_UTMESS


def lire_table_ops(self, UNITE, FORMAT, SEPARATEUR, NUME_TABLE, **args):
    """Méthode corps de la macro LIRE_TABLE
    """

    RENOMME_PARA = args.get('RENOMME_PARA')
    TITRE = args.get('TITRE')
    INFO = args.get('INFO')

    # On importe les definitions des commandes a utiliser dans la macro

    # Lecture de la table dans un fichier d unité logique UNITE
    nomfich = LogicalUnitFile.filename_from_unit(UNITE)
    if not osp.isfile(nomfich):
        UTMESS('F', 'FONCT0_41', valk=nomfich)

    with open(nomfich, 'r') as f:
        texte = f.read()

    check_para = None
    if RENOMME_PARA == "UNIQUE":
        check_para = unique_parameters

    reader = TableReaderFactory(texte, FORMAT, SEPARATEUR, debug=(INFO == 2))
    try:
        tab = reader.read(NUME_TABLE, check_para=check_para)
    except TypeError as exc:
        UTMESS('F', 'TABLE0_45', valk=str(exc))
    except aster.error as exc:
        raise_UTMESS(exc)

    UTMESS('I', 'TABLE0_44', valk=("", tab.titr),
           vali=(len(tab.rows), len(tab.para)))

    # création de la table ASTER :
    motscles = tab.dict_CREA_TABLE()
    if TITRE:
        motscles['TITRE'] = TITRE
    ut_tab = CREA_TABLE(**motscles)

    return ut_tab
