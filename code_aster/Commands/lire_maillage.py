# coding: utf-8

# Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: nicolas.sellenet@edf.fr

from ..Objects import Mesh
from .ExecuteCommand import ExecuteCommand
from code_aster.RunManager import LogicalUnitFile


def catalog_op():
    """Define the catalog of the fortran operator."""
    from code_aster.Cata.Commands.lire_maillage import keywords as main_keywords
    from code_aster.Cata.DataStructure import maillage_sdaster
    from code_aster.Cata.Syntax import OPER, SIMP, tr

    keywords = dict()
    keywords.update(main_keywords)
    del keywords['b_format_ideas']
    keywords['FORMAT'] = SIMP(statut='f', typ='TXM',
                            defaut='MED',
                            into=('ASTER', 'MED'))

    cata = OPER(nom="LIRE_MAILLAGE_OP",
                 op=1,
                 sd_prod=maillage_sdaster,
                 fr=tr("Crée un maillage par lecture d'un fichier"),
                 reentrant='n',
                 **keywords
    )
    return cata


class MeshReader(ExecuteCommand):
    """Command that creates a :class:`~code_aster.Objects.Mesh` from a file."""
    command_name = "LIRE_MAILLAGE"

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        from code_aster.Commands import PRE_GIBI, PRE_GMSH, PRE_IDEAS

        need_conversion = ('GIBI', 'GMSH', 'IDEAS')
        unit = keywords.get('UNITE')
        fmt = keywords['FORMAT']
        if fmt in need_conversion:
            tmpfile = LogicalUnitFile.new_free(None)
            unit_op = tmpfile.unit
            keywords['FORMAT'] = 'ASTER'
        else:
            unit_op = unit

        if fmt == 'GIBI':
            PRE_GIBI(UNITE_GIBI=unit, UNITE_MAILLAGE=unit_op)
        elif fmt == 'GMSH':
            PRE_GMSH(UNITE_GMSH=unit, UNITE_MAILLAGE=unit_op)
        elif fmt == 'IDEAS':
            coul = keywords.pop('CREA_GROUP_COUL', 'NON')
            PRE_IDEAS(UNITE_IDEAS=unit, UNITE_MAILLAGE=unit_op,
                      CREA_GROUP_COUL=coul)

        if fmt in need_conversion:
            tmpfile.release()

        keywords['UNITE'] = unit_op

        super(MeshReader, self).exec_(keywords)


    def create_result(self, keywords):
        """Create the :class:`~code_aster.Objects.Mesh`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Mesh()


LIRE_MAILLAGE = MeshReader.run
