# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

from code_aster import Mesh
from code_aster.Cata import Commands, checkSyntax


def LIRE_MAILLAGE( **kwargs ):
    """Opérateur de relecture du maillage"""
    checkSyntax( Commands.LIRE_MAILLAGE, kwargs )
    mesh = Mesh.create()
    fileName = "fort." + str( kwargs["UNITE"] )
    format = kwargs["FORMAT"]
    if format == "MED":
        mesh.readMedFile( fileName )
    elif format == "GMSH":
        mesh.readGmshFile( fileName )
    elif format == "GIBI":
        mesh.readGibiFile( fileName )
    return mesh