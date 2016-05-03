/**
 * @file XfemCrack.cxx
 * @brief Implementation de MaterialInstance
 * @author Nicolas Tardieu
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

/* person_in_charge: nicolas.tardieu at edf.fr */

#include "astercxx.h"

#include "Modeling/XfemCrack.h"
#include "RunManager/CommandSyntaxCython.h"

#include "Modeling/CrackShape.h"

XfemCrackInstance::XfemCrackInstance(MeshPtr supportMesh):
    DataStructure( getNewResultObjectName(), "FISS_XFEM" ),
    _jeveuxName( getResultObjectName() ),
    _supportMesh(supportMesh),
    _auxiliaryGrid(MeshPtr()),
    _existingCrackWithGrid(XfemCrackPtr()),
    //_existingCrackWithGrid(NULL),
    _discontinuityType("Crack"),
    _crackLipsEntity(),
    _crackTipEntity(),
    _normalLevelSetFunction(FunctionPtr()),
    _tangentialLevelSetFunction(FunctionPtr()),
    _crackShape(CrackShapePtr()),
    _enrichedElements(),
    _discontinuousField(std::string()),
    _enrichmentType(std::string()),
    _enrichmentRadiusZone(0),
    _enrichedLayersNumber(0),

    _tangentialLevelSetField(new FieldOnNodesDoubleInstance( _jeveuxName + "      .LTNO" ) ),
    _normalLevelSetField(new FieldOnNodesDoubleInstance( _jeveuxName + "      .LNNO" ) ),
    _tangentialLevelSetGradient(new FieldOnNodesDoubleInstance( _jeveuxName + "    .GRLTNO" ) ),
    _normalLevelSetGradient(new FieldOnNodesDoubleInstance( _jeveuxName + "    .GRLNNO" ) ),
    _localBasis(new FieldOnNodesDoubleInstance( _jeveuxName + "    .BASLOC" ) ),
    _crackTipCoords(JeveuxVectorDouble( _jeveuxName + ".FONDFISS" ) ),
    _crackTipBasis(JeveuxVectorDouble( _jeveuxName + ".BASEFOND" ) ),
    _crackTipMultiplicity(JeveuxVectorLong( _jeveuxName + ".FONDMULT" ) ),
    _crackTipCharacteristics(JeveuxVectorDouble( _jeveuxName + ".CARAFOND" ) ),
    _elementSize(JeveuxVectorDouble( _jeveuxName + ".FOND.TAILLE_R" ) ),
    _enrichedNodes(JeveuxVectorLong( _jeveuxName + ".GROUP_NO_ENRI" ) ),
    _crackTipElements(JeveuxVectorLong( _jeveuxName + ".MAILFISS.CTIP" ) ),
    _heavisideElements(JeveuxVectorLong( _jeveuxName + ".MAILFISS.HEAV" ) ),
    _crackTipAndHeavisideElements(JeveuxVectorLong( _jeveuxName + ".MAILFISS.HECT" ) )
{
    assert(_jeveuxName.size() == 8);
};



bool XfemCrackInstance::build() throw( std::runtime_error )
{
    CommandSyntaxCython cmdSt( "DEFI_FISS_XFEM" );
    cmdSt.setResult( getResultObjectName(), "FISS_XFEM" );

    SyntaxMapContainer dict;

    dict.container["MAILLAGE"] = _supportMesh->getName();


    if (_auxiliaryGrid) {
        dict.container["MAILLAGE_GRILLE"] = _auxiliaryGrid->getName();
    }
    if (_existingCrackWithGrid) {
        dict.container["FISS_GRILLE"] = _existingCrackWithGrid->getName();
    }

    if (_discontinuityType == "Crack")      dict.container["TYPE_DISCONTINUITE"] = "FISSURE";
    if (_discontinuityType == "Interface")  dict.container["TYPE_DISCONTINUITE"] = "INTERFACE";
    if (_discontinuityType == "Cohesive")   dict.container["TYPE_DISCONTINUITE"] = "COHESIVE";

    SyntaxMapContainer dict2;
    if (_crackLipsEntity.size()!=0) {
        dict2.container["GROUP_MA_FISS"] = _crackLipsEntity;
        if (_crackTipEntity.size()!=0) {
            dict2.container["GROUP_MA_FOND"] = _crackTipEntity;
        }
    }

    if (_normalLevelSetFunction) {
        dict2.container["FONC_LN"] = _normalLevelSetFunction->getName();
        if (_tangentialLevelSetFunction) {
            dict2.container["FONC_LT"] = _tangentialLevelSetFunction->getName();
        }
    }

    if (_crackShape->getShape()!=Shape::NoShape) {
        if (_crackShape->getShape()==Shape::Ellipse) {
            dict2.container["DEMI_GRAND_AXE"] = _crackShape->getSemiMajorAxis();
            dict2.container["DEMI_PETIT_AXE"] = _crackShape->getSemiMinorAxis();
            dict2.container["CENTRE"] = _crackShape->getCenter();
            dict2.container["VECT_X"] = _crackShape->getVectX();
            dict2.container["VECT_Y"] = _crackShape->getVectY();
            dict2.container["COTE_FISS"] = _crackShape->getCrackSide();
        } else if (_crackShape->getShape()==Shape::Square) {
            dict2.container["DEMI_GRAND_AXE"] = _crackShape->getSemiMajorAxis();
            dict2.container["DEMI_PETIT_AXE"] = _crackShape->getSemiMinorAxis();
            dict2.container["RAYON_CONGE"] = _crackShape->getFilletRadius();
            dict2.container["CENTRE"] = _crackShape->getCenter();
            dict2.container["VECT_X"] = _crackShape->getVectX();
            dict2.container["VECT_Y"] = _crackShape->getVectY();
            dict2.container["COTE_FISS"] = _crackShape->getCrackSide();
        } else if (_crackShape->getShape()==Shape::Cylinder) {
            dict2.container["DEMI_GRAND_AXE"] = _crackShape->getSemiMajorAxis();
            dict2.container["DEMI_PETIT_AXE"] = _crackShape->getSemiMinorAxis();
            dict2.container["CENTRE"] = _crackShape->getCenter();
            dict2.container["VECT_X"] = _crackShape->getVectX();
            dict2.container["VECT_Y"] = _crackShape->getVectY();
        } else if (_crackShape->getShape()==Shape::Notch) {
            dict2.container["DEMI_LONGUEUR"] = _crackShape->getHalfLength();
            dict2.container["RAYON_CONGE"] = _crackShape->getFilletRadius();
            dict2.container["CENTRE"] = _crackShape->getCenter();
            dict2.container["VECT_X"] = _crackShape->getVectX();
            dict2.container["VECT_Y"] = _crackShape->getVectY();
        } else if (_crackShape->getShape()==Shape::HalfPlane) {
            dict2.container["PFON"] = _crackShape->getEndPoint();
            dict2.container["DTAN"] = _crackShape->getTangent();
            dict2.container["NORMALE"] = _crackShape->getNormal();
        } else if (_crackShape->getShape()==Shape::Segment) {
            dict2.container["PFON_ORIG"] = _crackShape->getStartingPoint();
            dict2.container["PFON_EXTR"] = _crackShape->getEndPoint();
        } else if (_crackShape->getShape()==Shape::HalfLine) {
            dict2.container["PFON"] = _crackShape->getStartingPoint();
            dict2.container["DTAN"] = _crackShape->getTangent();
        } else if (_crackShape->getShape()==Shape::Line) {
            dict2.container["POINT"] = _crackShape->getStartingPoint();
            dict2.container["DTAN"] = _crackShape->getTangent();
        }
        dict2.container["FORM_FISS"] = _crackShape->getShapeName();
    }

    if (_normalLevelSetField) {
        dict2.container["CHAM_NO_LSN"] = _normalLevelSetField->getName();
        if (_tangentialLevelSetField) {
            dict2.container["CHAM_NO_LST"] = _tangentialLevelSetField->getName();
        }
    }

    ListSyntaxMapContainer crackDefinition;
    crackDefinition.push_back(dict2);
    dict.container["DEFI_FISS"] = crackDefinition;


    if (_enrichedElements.size()!=0) dict.container["GROUP_MA_ENRI"] = _enrichedElements;

    if (_enrichmentType=="GEOMETRIQUE") {
        dict.container["TYPE_FOND_ENRI"] = "GEOMETRIQUE";
        if (_enrichmentRadiusZone) {
            dict.container["RAYON_ENRI"] = _enrichmentRadiusZone;
        } else {
            dict.container["NB_COUCHES"] = _enrichedLayersNumber;
        }
    }

    if (_junctingCracks.size()!=0) {
        SyntaxMapContainer dict3;
        std::vector<std::string> junctingCracksNames;
        for (std::vector<XfemCrackPtr>::iterator  crack = _junctingCracks.begin(); crack != _junctingCracks.end(); ++crack) {
            junctingCracksNames.push_back((*(*crack)).getName());
        }
        dict3.container["FISSURE"]=junctingCracksNames;
        dict3.container["POINT"]=_pointForJunctingCracks;
        ListSyntaxMapContainer junctionDefinition;
        junctionDefinition.push_back(dict3);
    }

    cmdSt.define( dict );


    try {
        INTEGER op = 41;
        CALL_EXECOP( &op );
    } catch( ... ) {
        throw;
    }
    return true;
};

