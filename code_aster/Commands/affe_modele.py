# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

from code_aster import Mesh, Model
from code_aster.Cata import Commands
from code_aster.Utilities.CppToFortranGlossary import FortranGlossary


def AFFE_MODELE( **kwargs ):
    """Opérateur d'affection de modélisations"""
    retour = Commands.AFFE_MODELE.getDefaultKeywords( kwargs )

    glossary = FortranGlossary()

    model = Model()
    model.setSupportMesh(  kwargs[ "MAILLAGE" ] )

    fkwAffe = kwargs.get( "AFFE" )
    if fkwAffe != None:
        if type( fkwAffe ) == tuple:
            for curDict in fkwAffe:
                physique = glossary.getPhysics( curDict.get( "PHENOMENE" ) )
                modelisation = glossary.getModeling( curDict.get( "MODELISATION" ) )

                kwTout = curDict.get( "TOUT" )
                kwGroupMa = curDict.get( "GROUP_MA" )
                kwGroupNo = curDict.get( "GROUP_NO" )
                if kwTout != None:
                    model.addModelingOnAllMesh( physique, modelisation )
                elif kwGroupMa != None:
                    model.addModelingOnGroupOfElements( physique, modelisation, kwGroupMa )
                elif kwGroupMa != None:
                    model.addModelingOnGroupOfNodes( physique, modelisation, kwGroupNo )
        elif type( fkwAffe ) == dict:
            physique = glossary.getPhysics( fkwAffe.get( "PHENOMENE" ) )
            modelisation = glossary.getModeling( fkwAffe.get( "MODELISATION" ) )

            kwTout = fkwAffe.get( "TOUT" )
            kwGroupMa = fkwAffe.get( "GROUP_MA" )
            kwGroupNo = fkwAffe.get( "GROUP_NO" )
            if kwTout != None:
                model.addModelingOnAllMesh( physique, modelisation )
            elif kwGroupMa != None:
                model.addModelingOnGroupOfElements( physique, modelisation, kwGroupMa )
            elif kwGroupMa != None:
                model.addModelingOnGroupOfNodes( physique, modelisation, kwGroupNo )

    model.build()

    return model
