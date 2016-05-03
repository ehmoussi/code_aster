#ifndef CRACKSHAPE_H_
#define CRACKSHAPE_H_

/**
 * @file XfemCrack.h
 * @brief Fichier entete de la classe XfemCrack
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

typedef std::vector< double > VectorDouble;
typedef std::vector< std::string > VectorString;

/**
 * @class CrackShape
 * @brief Class to store the nature of the crack shape
 * @author Nicolas Tardieu
 */
enum Shape { NoShape, Ellipse, Square, Cylinder, Notch, HalfPlane, Segment, HalfLine, Line };
class CrackShapeInstance
{
private:
    Shape                   _shape;
    double                  _semiMajorAxis;
    double              	_semiMinorAxis;
    std::vector<double>     _center;
    std::vector<double>     _vectX;
    std::vector<double>     _vectY;
    std::string             _crackSide;
    double                  _filletRadius;
    double              	_halfLength;
    std::vector<double>     _endPoint;
    std::vector<double>     _normal;
    std::vector<double>     _tangent;
    std::vector<double>     _startingPoint;

public:
    /**
     * @brief Constructeur
     */
    CrackShapeInstance();

    /**
     * @brief Define the Crack Shape as Ellise
     */
    void setEllipseCrackShape(double semiMajorAxis, double semiMinorAxis, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY, std::string crackSide="IN");

    /**
     * @brief Define the Crack Shape as Square
     */
    void setSquareCrackShape(double semiMajorAxis, double semiMinorAxis, double filletRadius, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY, std::string crackSide="IN");

    /**
     * @brief Define the Crack Shape as Cylinder
     */
    void setCylinderCrackShape(double semiMajorAxis, double semiMinorAxis, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY);

    /**
     * @brief Define the Crack Shape as Notch
     */
    void setNotchCrackShape(double halfLength, double filletRadius, std::vector<double> center, std::vector<double> vectX, std::vector<double> vectY);

    /**
     * @brief Define the Crack Shape as Half Plane
     */
    void setHalfPlaneCrackShape(std::vector<double> endPoint, std::vector<double> normal, std::vector<double> tangent);

    /**
     * @brief Define the Crack Shape as Segment
     */
    void setSegmentCrackShape(std::vector<double> startingPoint, std::vector<double> endPoint);

    /**
     * @brief Define the Crack Shape as Half Line
     */
    void setHalfLineCrackShape(std::vector<double> startingPoint, std::vector<double> tangent);

    /**
     * @brief Define the Crack Shape as Line
     */
    void setLineCrackShape(std::vector<double> startingPoint, std::vector<double> tangent);


    Shape getShape() const
    {
        return _shape;
    };

    std::string getShapeName() const
    {
        if (_shape == Shape::NoShape)           return "NoShape";
        else if (_shape == Shape::Ellipse)      return "ELLIPSE";
        else if (_shape == Shape::Square)       return "RECTANGLE";
        else if (_shape == Shape::Cylinder)     return "CYLINDRE";
        else if (_shape == Shape::Notch)        return "ENTAILLE";
        else if (_shape == Shape::HalfPlane)    return "DEMI_PLAN";
        else if (_shape == Shape::Segment)      return "SEGMENT";
        else if (_shape == Shape::HalfLine)     return "DEMI_DROITE";
        else if (_shape == Shape::Line)         return "DROITE";
    };

    double getSemiMajorAxis() const
    {
        return _semiMajorAxis;
    };

    double getSemiMinorAxis() const
    {
        return _semiMinorAxis;
    };

    const std::vector<double> getCenter() const
    {
        return _center;
    };

    const std::vector<double> getVectX() const
    {
        return _vectX;
    };
    const std::vector<double> getVectY() const
    {
        return _vectY;
    };

    std::string getCrackSide() const
    {
        return _crackSide;
    };

    double getFilletRadius() const
    {
        return _filletRadius;
    };

    double getHalfLength() const
    {
        return _halfLength;
    };

    const std::vector<double> getEndPoint() const
    {
        return _endPoint;
    };

    const std::vector<double> getNormal() const
    {
        return _normal;
    };

    const std::vector<double> getTangent() const
    {
        return _tangent;
    };

    const std::vector<double> getStartingPoint() const
    {
        return _startingPoint;
    };

};


/**
 * @typedef CrackShapePtr
 * @brief Pointeur intelligent vers un CrackShapeInstance
 */
typedef boost::shared_ptr< CrackShapeInstance > CrackShapePtr;


#endif /* CRACKSHAPE_H_ */

