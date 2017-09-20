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

from code_aster import MaterialOnMesh
from code_aster.Cata import Commands, checkSyntax


def _addMaterial(materOnMesh, fkw):
    kwTout = fkw.get("TOUT")
    kwGrMa = fkw.get("GROUP_MA")
    mater = fkw[ "MATER" ]

    for mater_i in mater:
        if kwTout != None:
            materOnMesh.addMaterialOnAllMesh(mater_i)
        elif kwGrMa != None:
            if type(kwGrMa) == list:
                for grp in kwGrMa:
                    materOnMesh.addMaterialOnGroupOfElements(mater_i, grp)
            else:
                materOnMesh.addMaterialOnGroupOfElements(mater_i, kwGrMa)
        else:
            assert False


def AFFE_MATERIAU(**kwargs):
    """Opérateur d'affection d'un matériau"""
    checkSyntax( Commands.AFFE_MATERIAU, kwargs )

    mesh = None
    if kwargs.has_key("MAILLAGE"):
        mesh = kwargs["MAILLAGE"]
    else:
        try:
            mesh = kwargs["MODELE"].getSupportMesh()
        except:
            raise NameError("A Mesh or a Model is required")
    materOnMesh = MaterialOnMesh.create(mesh)

    if kwargs.get("AFFE_COMPOR") != None or kwargs.get("AFFE_VARC") != None:
        raise NameError("AFFE_COMPOR or AFFE_VARC not yet implemented")

    fkw = kwargs[ "AFFE" ]
    if type(fkw) == dict:
        _addMaterial(materOnMesh, fkw)
    elif type(fkw) in (list, tuple):
        for curDict in fkw:
            _addMaterial(materOnMesh,curDict )
    else:
        assert False, fkw

    materOnMesh.build()

    return materOnMesh