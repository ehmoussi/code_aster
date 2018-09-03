# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

"""Commande LIRE_MAILLAGE"""



def catalog_op():
    """Define the catalog of the fortran operator."""
    from code_aster.Cata.Commands.lire_maillage import keywords as main_keywords
    from code_aster.Cata.DataStructure import maillage_sdaster
    from code_aster.Cata.Syntax import MACRO, SIMP, tr

    keywords = dict()
    keywords.update(main_keywords)
    del keywords['b_format_ideas']
    keywords['FORMAT'] = SIMP(statut='f', typ='TXM',
                            defaut='MED',
                            into=('ASTER', 'MED'))

    cata = MACRO(nom="LIRE_MAILLAGE_OP",
                 op=1,
                 sd_prod=maillage_sdaster,
                 fr=tr("Crée un maillage par lecture d'un fichier"),
                 reentrant='n',
                 **keywords
    )
    return cata


def lire_maillage_ops(self, **args):
    """Corps de la macro CALC_FONCTION"""
    from code_aster.Cata.Commands import PRE_GIBI, PRE_GMSH, PRE_IDEAS
    from Utilitai.UniteAster import UniteAster

    self.set_icmd(1)

    self.DeclareOut('mesh', self.sd)

    need_conversion = ('GIBI', 'GMSH', 'IDEAS')
    unit = args['UNITE']
    fmt = args['FORMAT']
    if fmt in need_conversion:
        UL = UniteAster()
        unit_op = UL.Libre(action='ASSOCIER')
        args['FORMAT'] = 'ASTER'
    else:
        unit_op = unit

    if fmt == 'GIBI':
        PRE_GIBI(UNITE_GIBI=unit, UNITE_MAILLAGE=unit_op)
    elif fmt == 'GMSH':
        PRE_GMSH(UNITE_GMSH=unit, UNITE_MAILLAGE=unit_op)
    elif fmt == 'IDEAS':
        coul = args.pop('CREA_GROUP_COUL', 'NON')
        PRE_IDEAS(UNITE_IDEAS=unit, UNITE_MAILLAGE=unit_op,
                  CREA_GROUP_COUL=coul)

    args['UNITE'] = unit_op

    LIRE_MAILLAGE_OP = catalog_op()
    mesh = LIRE_MAILLAGE_OP(**args)

    if fmt in need_conversion:
        UL.EtatInit(unit_op)
    return 0
