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

# person_in_charge: nicolas.tardieu@edf.fr

from code_aster import Mesh, XfemCrack, CrackShape
from code_aster.Cata import Commands
from code_aster.Cata.SyntaxChecker import checkCommandSyntax
from code_aster.Utilities.CppToFortranGlossary import FortranGlossary


def DEFI_FISS_XFEM( **kwargs ):
    """Operator to define XFEM cracks"""
    checkCommandSyntax( Commands.DEFI_FISS_XFEM, kwargs )

    glossary = FortranGlossary()

    crack = XfemCrack(kwargs[ "MAILLAGE" ])

    if kwargs[ "MAILLAGE_GRILLE" ] != None:
        crack.setAuxiliaryGrid(kwargs[ "MAILLAGE_GRILLE" ])
    else:
        crack.setExistingCrackWithGrid(kwargs[ "FISS_GRILLE" ])

    crack.setDiscontinuityType(kwargs[ "TYPE_DISCONTINUITE" ])

    fkwDefi = kwargs.get( "DEFI_FISS" )

    shapeName = fkwDefi.get("FORM_FISS")

    if fkwDefi.get("FORM_FISS") != None:
        crackShape=CrackShape()

    if shapeName == "ELLIPSE":
        crackShape.setEllipseCrackShape(fkwDefi.get("DEMI_GRAND_AXE"), fkwDefi.get("DEMI_PETIT_AXE"), fkwDefi.get("CENTRE"), fkwDefi.get("VECT_X"), fkwDefi.get("VECT_Y"), fkwDefi.get("COTE_FISS"))
    elif shapeName == "RECTANGLE":
        crackShape.setSquareCrackShape(fkwDefi.get("DEMI_GRAND_AXE"), fkwDefi.get("DEMI_PETIT_AXE"), fkwDefi.get("RAYON_CONGE"), fkwDefi.get("CENTRE"), fkwDefi.get("VECT_X"), fkwDefi.get("VECT_Y"), fkwDefi.get("COTE_FISS"))
    elif shapeName == "CYLINDRE":
        crackShape.setCylinderCrackShape(fkwDefi.get("DEMI_GRAND_AXE"), fkwDefi.get("DEMI_PETIT_AXE"), fkwDefi.get("CENTRE"), fkwDefi.get("VECT_X"), fkwDefi.get("VECT_Y"))
    elif shapeName == "ENTAILLE":
        crackShape.setNotchCrackShape(fkwDefi.get("DEMI_LONGUEUR"), fkwDefi.get("RAYON_CONGE"), fkwDefi.get("CENTRE"), fkwDefi.get("VECT_X"), fkwDefi.get("VECT_Y"))
    elif shapeName == "DEMI_PLAN":
        crackShape.setHalfPlaneCrackShape(fkwDefi.get("PFON"), fkwDefi.get("DTAN"), fkwDefi.get("NORMALE"))
    elif shapeName == "SEGMENT":
        crackShape.setSegmentCrackShape(fkwDefi.get("PFON_ORIG"), fkwDefi.get("PFON_EXTR"))
    elif shapeName == "DEMI_DROITE":
        crackShape.setHalfLineCrackShape(fkwDefi.get("PFON"), fkwDefi.get("DTAN"))
    elif shapeName == "DROITE":
        crackShape.setLineCrackShape(fkwDefi.get("POINT"), fkwDefi.get("DTAN"))

    if fkwDefi.get("FORM_FISS") != None:
        crack.setCrackShape(crackShape)

    if fkwDefi.get("CHAM_NO_LSN") != None:
        crack.setNormalLevelSetField(fkwDefi.get("CHAM_NO_LSN"))
    if fkwDefi.get("CHAM_NO_LST") != None:
        crack.setTangentialLevelSet(fkwDefi.get("CHAM_NO_LST"))

    if kwargs[ "GROUP_MA_ENRI" ] != None:
        crack.setEnrichedElements(kwargs[ "GROUP_MA_ENRI" ])
        crack.setDiscontinuousField(kwargs[ "CHAM_DISCONTINUITE" ])
        crack.setEnrichmentType(kwargs[ "TYPE_FOND_ENRI" ])
        if kwargs[ "TYPE_FOND_ENRI" ] == "GEOMETRIQUE":
            if kwargs[ "RAYON_ENRI" ] != None:
                crack.setEnrichmentRadiusZone(kwargs[ "RAYON_ENRI" ])
            else:
                crack.setEnrichedLayersNumber(kwargs[ "NB_COUCHES" ])



    if kwargs[ "MAILLAGE_GRILLE" ] == None and kwargs[ "FISS_GRILLE" ] == None:
        fkwJunction = kwargs.get( "JONCTION" )
        for junc in fkwJunction.get( "FISSURE"):
            crack.insertJunctingCracks(junc)
        crack.setPointForJunction(fkwJunction.get( "POINT"))

        shapeName = fkwDefi.get("FORM_FISS")

    crack.build()
    return crack
