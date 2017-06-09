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

# person_in_charge: mathieu.courtois at edf.fr

import os.path as osp


def lire_table_ops(self, UNITE, FORMAT, SEPARATEUR, NUME_TABLE, RENOMME_PARA,
                   INFO, TITRE, **args):
    """Méthode corps de la macro LIRE_TABLE
    """
    import aster
    from Utilitai.Utmess import UTMESS, raise_UTMESS
    from Utilitai.UniteAster import UniteAster
    from Utilitai.TableReader import TableReaderFactory, unique_parameters

    ier = 0
    # On importe les definitions des commandes a utiliser dans la macro
    CREA_TABLE = self.get_cmd('CREA_TABLE')

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # Lecture de la table dans un fichier d unité logique UNITE
    UL = UniteAster()
    nomfich = UL.Nom(UNITE)
    if not osp.isfile(nomfich):
        UTMESS('F', 'FONCT0_41', valk=nomfich)

    texte = open(nomfich, 'r').read()
    # remet UNITE dans son état initial
    UL.EtatInit()

    check_para = None
    if RENOMME_PARA == "UNIQUE":
        check_para = unique_parameters

    reader = TableReaderFactory(texte, FORMAT, SEPARATEUR, debug=(INFO == 2))
    try:
        tab = reader.read(NUME_TABLE, check_para=check_para)
    except TypeError, exc:
        UTMESS('F', 'TABLE0_45', valk=str(exc))
    except aster.error, exc:
        raise_UTMESS(exc)

    UTMESS('I', 'TABLE0_44', valk=(self.sd.nom, tab.titr),
           vali=(len(tab.rows), len(tab.para)))

    # création de la table ASTER :
    self.DeclareOut('ut_tab', self.sd)
    motscles = tab.dict_CREA_TABLE()
    if TITRE:
        motscles['TITRE'] = TITRE
    ut_tab = CREA_TABLE(**motscles)

    return ier
