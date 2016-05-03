/**
 * @file CrackShape.cxx
 * @brief Class to describe the possible shape of cracks for XFEM
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
#include "CrackShape.h"

CrackShapeInstance::CrackShapeInstance()
{
    _shape=Shape::NoShape;
};


void CrackShapeInstance::setEllipseCrackShape(double semiMajorAxis, double semiMinorAxis, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY, std::string crackSide)
{
    _shape=Shape::Ellipse;
    _semiMajorAxis=semiMajorAxis;
    _semiMinorAxis=semiMinorAxis;
    _center=center;
    _vectX=vectX;
    _vectY=vectY;
    _crackSide=crackSide;
};

void CrackShapeInstance::setSquareCrackShape(double semiMajorAxis, double semiMinorAxis, double filletRadius, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY, std::string crackSide)
{
    _shape=Shape::Square;
    _semiMajorAxis=semiMajorAxis;
    _semiMinorAxis=semiMinorAxis;
    _filletRadius=filletRadius;
    _center=center;
    _vectX=vectX;
    _vectY=vectY;
    _crackSide=crackSide;
};

void CrackShapeInstance::setCylinderCrackShape(double semiMajorAxis, double semiMinorAxis, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY)
{
    _shape=Shape::Cylinder;
    _semiMajorAxis=semiMajorAxis;
    _semiMinorAxis=semiMinorAxis;
    _center=center;
    _vectX=vectX;
    _vectY=vectY;
};

void CrackShapeInstance::setNotchCrackShape(double halfLength, double filletRadius, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY)
{
    _shape=Shape::Notch;
    _halfLength=halfLength;
    _filletRadius=filletRadius;
    _center=center;
    _vectX=vectX;
    _vectY=vectY;
};

void CrackShapeInstance::setHalfPlaneCrackShape(std::vector<double> endPoint, std::vector<double> normal, std::vector<double> tangent)
{
    _shape=Shape::HalfPlane;
    _endPoint=endPoint;
    _normal=normal;
    _tangent=tangent;
};
void CrackShapeInstance::setSegmentCrackShape(std::vector<double> startingPoint, std::vector<double> endPoint)
{
    _shape=Shape::Segment;
    _startingPoint=startingPoint;
    _endPoint=endPoint;
};

void CrackShapeInstance::setHalfLineCrackShape(std::vector<double> startingPoint, std::vector<double> tangent)
{
    _shape=Shape::HalfLine;
    _startingPoint=startingPoint;
    _tangent=tangent;
};

void CrackShapeInstance::setLineCrackShape(std::vector<double> startingPoint, std::vector<double> tangent)
{
    _shape=Shape::Line;
    _startingPoint=startingPoint;
    _tangent=tangent;
};


