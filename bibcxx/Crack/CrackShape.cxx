/**
 * @file CrackShape.cxx
 * @brief Class to describe the possible shape of cracks for XFEM
 * @author Nicolas Tardieu
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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
#include "CrackShape.h"

CrackShapeClass::CrackShapeClass() { _shape = Shape::NoShape; };

void CrackShapeClass::setEllipseCrackShape( double semiMajorAxis, double semiMinorAxis,
                                               VectorReal center,
                                               VectorReal vectX,
                                               VectorReal vectY,
                                               std::string crackSide ) {
    _shape = Shape::Ellipse;
    _semiMajorAxis = semiMajorAxis;
    _semiMinorAxis = semiMinorAxis;
    _center = center;
    _vectX = vectX;
    _vectY = vectY;
    _crackSide = crackSide;
};

void CrackShapeClass::setSquareCrackShape( double semiMajorAxis, double semiMinorAxis,
                                              double filletRadius, VectorReal center,
                                              VectorReal vectX,
                                              VectorReal vectY, std::string crackSide ) {
    _shape = Shape::Square;
    _semiMajorAxis = semiMajorAxis;
    _semiMinorAxis = semiMinorAxis;
    _filletRadius = filletRadius;
    _center = center;
    _vectX = vectX;
    _vectY = vectY;
    _crackSide = crackSide;
};

void CrackShapeClass::setCylinderCrackShape( double semiMajorAxis, double semiMinorAxis,
                                                VectorReal center,
                                                VectorReal vectX,
                                                VectorReal vectY ) {
    _shape = Shape::Cylinder;
    _semiMajorAxis = semiMajorAxis;
    _semiMinorAxis = semiMinorAxis;
    _center = center;
    _vectX = vectX;
    _vectY = vectY;
};

void CrackShapeClass::setNotchCrackShape( double halfLength, double filletRadius,
                                             VectorReal center,
                                             VectorReal vectX,
                                             VectorReal vectY ) {
    _shape = Shape::Notch;
    _halfLength = halfLength;
    _filletRadius = filletRadius;
    _center = center;
    _vectX = vectX;
    _vectY = vectY;
};

void CrackShapeClass::setHalfPlaneCrackShape( VectorReal endPoint,
                                                 VectorReal normal,
                                                 VectorReal tangent ) {
    _shape = Shape::HalfPlane;
    _endPoint = endPoint;
    _normal = normal;
    _tangent = tangent;
};
void CrackShapeClass::setSegmentCrackShape( VectorReal startingPoint,
                                               VectorReal endPoint ) {
    _shape = Shape::Segment;
    _startingPoint = startingPoint;
    _endPoint = endPoint;
};

void CrackShapeClass::setHalfLineCrackShape( VectorReal startingPoint,
                                                VectorReal tangent ) {
    _shape = Shape::HalfLine;
    _startingPoint = startingPoint;
    _tangent = tangent;
};

void CrackShapeClass::setLineCrackShape( VectorReal startingPoint,
                                            VectorReal tangent ) {
    _shape = Shape::Line;
    _startingPoint = startingPoint;
    _tangent = tangent;
};


std::string CrackShapeClass::getShapeName() const {
    if ( _shape == Shape::NoShape )
        return "NoShape";
    else if ( _shape == Shape::Ellipse )
        return "ELLIPSE";
    else if ( _shape == Shape::Square )
        return "RECTANGLE";
    else if ( _shape == Shape::Cylinder )
        return "CYLINDRE";
    else if ( _shape == Shape::Notch )
        return "ENTAILLE";
    else if ( _shape == Shape::HalfPlane )
        return "DEMI_PLAN";
    else if ( _shape == Shape::Segment )
        return "SEGMENT";
    else if ( _shape == Shape::HalfLine )
        return "DEMI_DROITE";
    else if ( _shape == Shape::Line )
        return "DROITE";
};
